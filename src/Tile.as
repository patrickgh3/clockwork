package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	
	/**
	 * A tile which the structure of the world is made of.
	 */
	public class Tile extends Entity
	{
		[Embed(source = "/../assets/tiles.png")]
		private static const src:Class;
		[Embed(source = "/../assets/sound/wrench.mp3")]
		private static const sound:Class;
		
		private var image:Image;
		public var isLock:Boolean = false;
		private static var sfx:Sfx = new Sfx(sound);
		
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
			sfx.play(0.5);
		}
		
		public function lock():void
		{
			image.alpha = 1;
			if (isLock) LevelData.levelmask[(x + 2) / 16][(y + 3) / 16] = 2;
		}
		
	}

}