package  
{
	import Entities.*;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	/**
	 * Class which loads the level from Ogmo.
	 */
	public class LevelData 
	{
		[Embed(source = "../levels/testlevel.oel", mimeType = "application/octet-stream")]
		public static const testlevel:Class;
		
		/* actors holds most of the entities to be added to the world.
		 * The other arrays are there to separate specific groups. */
		public static var actors:Array;
		public static var rickets:Array; // added in the background.
		public static var movingblocks:Array; // added in the background, and reference given to player.
		public static var locks:Array; // 2D array, empty except for lock tiles. reference given to player.
		public static var levelmask:Array; // Array of ints. 0 = empty, 1 = solid, 2 = solid and lock. reference given to player.
		public static var width:int;
		public static var height:int;
		public static var errorMessage:String;
		
		// todo: find reasonable values for these
		public static const MIN_WIDTH:int = 15;
		public static const MIN_HEIGHT:int = 15;
		public static const MAX_WIDTH:int = 300;
		public static const MAX_HEIGHT:int = 40;
		public static const MAX_OBJECTS:int = 500;
		
		public static function loadStandardLevel():void
		{
			loadLevel(FP.getXML(testlevel));
		}
		
		public static function tryLoadCustomLevel(levelSource:String):Boolean
		{
			try
			{
				var xml:XML = new XML(levelSource);
			}
			catch (error:Error)
			{
				errorMessage = "Invalid XML.\n" + error.message;
				return false;
			}
			
			if (!validateLevel(xml))
			{
				return false;
			}
			
			loadLevel(xml);
			return true;
		}
		
		private static function validateLevel(xml:XML):Boolean
		{
			var width:int = xml.@width / 16;
			var height:int = xml.@height / 16;
			if (width as int == 0 || height as int == 0)
			{
				errorMessage = "Invalid Ogmo file.";
				return false;
			}
			if (xml.@width % 16 != 0 || xml.@height % 16 != 0)
			{
				errorMessage = "Level width or height not a multiple of 16."
				return false;5
			}
			if (width < MIN_WIDTH || height < MIN_HEIGHT)
			{
				errorMessage = "Level too small (" + width + " x " + height + "). Minimum size is " + MIN_WIDTH + " x " + MIN_HEIGHT + ".";
				return false;
			}
			// todo: maybe check number of tiles / entities instead of level size? or maybe problems with clock / camera?
			if (width > MAX_WIDTH || height > MAX_HEIGHT)
			{
				errorMessage = "Level too big (" + width + " x " + height + "). Maximum size is " + MAX_WIDTH + " x " + MAX_HEIGHT + ".";
				return false;
			}
			
			var node:XML;
			for each (node in xml.Tiles.tile)
			{
				if (node.@x < 0 || node.@x >= width * 16 || node.@y < 0 || node.@y > height * 16)
				{
					errorMessage = "Tile at " + node.@x + "," + node.@y + " is out of bounds.";
					return false;
				}
				if (node.@tx < 0 || node.@tx > 3 || node.@ty != 0)
				{
					errorMessage = "Tile at " + node.@x + "," + node.@y + " has invalid tileset coords.";
					return false;
				}
			}
			for each (node in xml.Entities.child("*"))
			{
				if (node.@x < 0 || node.@x >= width * 16 || node.@y < 0 || node.@y >= height * 16)
				{
					errorMessage = "Entity at " + node.@x + "," + node.@y + " is out of bounds.";
					return false;
				}
			}
			var objectCount:int = xml.Tiles.tile.length() + xml.Entities.child("*").length;
			if (objectCount > MAX_OBJECTS)
			{
				errorMessage = "Too many tiles / entities (" + objectCount + "). Maximum " + MAX_OBJECTS + " allowed.";
			}
			
			if (xml.Entities.PlayerStart.length() == 0)
			{
				errorMessage = "Level has no start entity.";
				return false;
			}
			if (xml.Entities.PlayerStart.length() > 1)
			{
				errorMessage = "Level has more than one start entity.";
				return false;
			}
			if (xml.Entities.EndGrip.length() == 0)
			{
				errorMessage = "Level has no end grip entity.";
				return false;
			}
			
			return true;
		}
		
		private static function loadLevel(xml:XML):void
		{
			actors = [];
			rickets = [];
			movingblocks = [];
			locks = [];
			levelmask = [];
			
			var node:XML;
			width = xml.@width / 16;
			height = xml.@height / 16;
			
			/* Create arrays */
			for (var i:int = 0; i < width; i++)
			{
				locks.push(new Array());
			}
			
			for (i = 0; i < width; i++)
			{
				levelmask.push(new Array());
				for (var j:int = 0; j < height; j++)
				{
					levelmask[i][j] = 0;
				}
			}
			
			/* Load tiles from file from top-left to bottom-right,
			 * then reverse them so they are added to the world from bottom-right to top-left. */
			for each (node in xml.Tiles.tile)
			{
				var x:int = node.@x;
				var y:int = node.@y;
				var tx:int = node.@tx;
				var ty:int = node.@ty;
				var t:Tile = new Tile(x * 16, y * 16, tx, ty);
				actors.push(t);
				levelmask[x][y] = 1;
				if (tx == 3 && ty == 0)
				{
					levelmask[x][y] = 2;
					locks[x][y] = t;
				}
			}
			actors.reverse();
			
			/* Load entities from file. */
			for each (node in xml.Entities.Grip)
			{
				actors.push(new Grip(node.@x, node.@y));
			}
			
			for each (node in xml.Entities.MovingBlock)
			{
				var r:Entity = new Ricket(node.@ricketdirection);
				movingblocks.push(new MovingBlock(node.@x, node.@y, node.@xdistance, node.@ydistance, r));
				rickets.push(r);
			}
			
			for each (node in xml.Entities.Key)
			{
				actors.push(new Key(node.@x, node.@y, node.@special));
			}
			
			for each (node in xml.Entities.HintTrigger)
			{
				actors.push(new HintTrigger(node.@x, node.@y, node.@width, node.@height, node.@text, node.@id));
			}
			
			for each (node in xml.Entities.Fish)
			{
				actors.push(new Fish(node.@x, node.@y));
			}
			
			for each (node in xml.Entities.EndGrip)
			{
				actors.push(new EndGrip(node.@x, node.@y));
			}
			
			for each (node in xml.Entities.PlayerStart)
			{
				GameWorld.spawnx = node.@x;
				GameWorld.spawnx += 3;
				GameWorld.spawny = node.@y;
				GameWorld.spawny += 4;
			}
		}
		
	}

}