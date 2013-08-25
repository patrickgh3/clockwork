package Entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Clock tower in the background of the game.
	 */
	public class Clock extends Entity
	{
		[Embed(source = "/../assets/clock.png")]
		private static const src:Class;
		
		public static const scrollSpeed:Number = 0.03;
		
		
		public function Clock(x:int, y:int) 
		{
			super(x, y);
			graphic = new Image(src);
			graphic.scrollX = graphic.scrollY = scrollSpeed;
		}
	}

}