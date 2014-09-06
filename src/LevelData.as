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
		public static var actors:Array = new Array();
		public static var rickets:Array = new Array(); // added in the background.
		public static var movingblocks:Array = new Array(); // added in the background, and reference given to player.
		public static var locks:Array = new Array(); // 2D array, empty except for lock tiles. reference given to player.
		public static var levelmask:Array = new Array(); // Array of ints. 0 = empty, 1 = solid, 2 = solid and lock. reference given to player.
		public static var width:int;
		public static var height:int;
		
		public static function init():void
		{
			var xml:XML = FP.getXML(testlevel);
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