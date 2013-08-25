package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * A tile which the structure of the world is made of.
	 */
	public class Tile extends Entity
	{
		[Embed(source = "/../assets/tiles.png")]
		private static const src:Class;
		
		private var image:Image;
		public var isLock:Boolean = false;
		
		public function Tile(x:int, y:int, tx:int, ty:int) 
		{
			x -= 2;
			y -= 3;
			super(x, y);
			graphic = image = new Image(src, new Rectangle(tx * 20, ty * 20, 20, 20));
			if (tx == 3 && ty == 0) isLock = true;
		}
		
		public function unlock():void
		{
			image.alpha = 0;
			LevelData.levelmask[(x + 2) / 16][(y + 3) / 16] = 0;
		}
		
		public function lock():void
		{
			image.alpha = 1;
			if (isLock) LevelData.levelmask[(x + 2) / 16][(y + 3) / 16] = 2;
		}
		
	}

}