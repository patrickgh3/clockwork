package  
{
	import Entities.Grip;
	import Entities.Key;
	import Entities.MovingBlock;
	import Entities.Ricket;
	import net.flashpunk.FP;
	
	/**
	 * Class which loads and stores levels from Ogmo.
	 */
	public class LevelData 
	{
		[Embed(source = "../levels/testlevel.oel", mimeType = "application/octet-stream")]
		public static const testlevel:Class;
		
		public static var actors:Array = new Array();
		public static var rickets:Array = new Array();
		public static var movingblocks:Array = new Array();
		public static var levelmask:Array = new Array();
		public static var locks:Array = new Array();
		public static var width:int;
		public static var height:int;
		
		public static function init():void
		{
			var xml:XML = FP.getXML(testlevel);
			var node:XML;
			width = xml.@width / 16;
			height = xml.@height / 16;
			
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
			
			for each (node in xml.Entities.Grip)
			{
				actors.push(new Grip(node.@x, node.@y));
			}
			
			for each (node in xml.Entities.MovingBlock)
			{
				var b:MovingBlock = new MovingBlock(node.@x, node.@y, node.@xdistance, node.@ydistance);
				movingblocks.push(b);
				rickets.push(new Ricket(b, node.@ricketdirection));
			}
			
			for each (node in xml.Entities.Key)
			{
				actors.push(new Key(node.@x, node.@y, node.@special));
			}
			
			for each (node in xml.Entities.PlayerStart)
			{
				GameWorld.spawnx = node.@x;
				GameWorld.spawnx += 3;
				GameWorld.spawny = node.@y;
				GameWorld.spawny += 3;
			}
		}
		
	}

}