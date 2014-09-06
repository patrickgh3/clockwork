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
		
		public function Clock() 
		{
			super(startX, 0);
			graphic = new Image(src);
			graphic.x = -60;
			graphic.scrollX = graphic.scrollY = scrollSpeed;
		}
		
		public static function computePositions():void
		{
			if (LevelData.useOriginalMechanics)
			{
				startX = Main.width / 2 + 33;
				scrollSpeed = 0.03;
				return;
			}
			
			var extraPixels:int = (LevelData.width - 14) * 16;
			var maxstartoffset:int = 36;
			var maxscrollspeed:Number = 0.04;
			
			// if the level isn't long enough for the clock to move the max allowed distance (even going as fast as it is allowed to),
			// we move at the max allowed scroll speed, but start at a smaller offset.
			if (extraPixels * maxscrollspeed < maxstartoffset * 2)
			{
				scrollSpeed = maxscrollspeed;
				startX = Main.width / 2 + (extraPixels / 2) * maxscrollspeed;
				return;
			}
			
			// if the level is too long for the clock to move at full speed and stay inside the max allowed distance (offset),
			// we start at the max allowed offset, but move at a slower speed.
			startX = Main.width / 2 + maxstartoffset;
			scrollSpeed = (maxstartoffset * 2) / extraPixels;
			
			// oh god what am i doing it's 3 am and I can't believe this works
			
			// otter pops are tasty
		}
		
	}

}