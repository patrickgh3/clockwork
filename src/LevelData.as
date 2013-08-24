package  
{
	import net.flashpunk.FP;
	
	/**
	 * Class which loads and stores levels from Ogmo.
	 */
	public class LevelData 
	{
		[Embed(source = "../levels/testlevel.oel", mimeType = "application/octet-stream")]
		public static const testlevel:Class;
		
		public static var tiles:Array = new Array();
		public static var levelmask:Array = new Array();
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
				tiles.push(new Tile(x * 16, y * 16, tx, ty));
				levelmask[x][y] = 1;
			}
			
			tiles.reverse();
		}
		
	}

}