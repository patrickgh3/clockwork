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
		
		public static var scrollSpeed:Number;
		public static var startX:Number;
		
		private static const clockwidth:int = 120;
		private static const maxstartdist:int = 36; // standard 33
		private static const maxscrollspeed:Number = 0.04; // standard 0.03
		
		
		public function Clock() 
		{
			super(startX, 0);
			graphic = new Image(src);
			graphic.x = -60;
			graphic.scrollX = graphic.scrollY = scrollSpeed;
		}
		
		public static function computePositions():void
		{
			// todo: clean all this up
			
			// no scroll (avoid rounding errors?)
			if (LevelData.width == 14)
			{
				startX = Main.width / 2;
				scrollSpeed = 0;
				return;
			}
			
			// standard level (special case)
			if (LevelData.useOriginalMechanics)
			{
				startX = Main.width / 2 + 33;
				scrollSpeed = 0.03;
				return;
			}
			
			var extraTiles:int = LevelData.width - 14;
			var playerPixelsMoved:int = extraTiles * 16;
			var clockPixelsMovedIfFullRate:Number = playerPixelsMoved * maxscrollspeed;
			if (clockPixelsMovedIfFullRate < maxstartdist * 2)
			
			// level is shorter than "ideal". we move at the max scroll speed, but the clock starts at a smaller offset.
			if (clockPixelsMovedIfFullRate < maxstartdist / maxscrollspeed)
			{
				scrollSpeed = maxscrollspeed;
				startX = Main.width / 2 + (playerPixelsMoved / 2) * maxscrollspeed;
				return;
			}
			
			// level is longer than "ideal". we start at the max offset, but move at a slower speed.
			startX = Main.width / 2 + maxstartdist;
			scrollSpeed = (maxstartdist * 2) / playerPixelsMoved;
			
			// oh god what am i doing it's 3 am and I can't believe this works
			
			// otter pops are tasty
		}
	}

}