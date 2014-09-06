package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Seconds hand of the clock which ticks back and forth.
	 */
	public class ClockHand extends Entity
	{
		[Embed(source = "/../assets/clockhand.png")]
		private static const src:Class;
		
		private var image:Image;
		
		public function ClockHand() 
		{
			super(Clock.startX, 77);
			graphic = image = new Image(src);
			graphic.scrollX = graphic.scrollY = Clock.scrollSpeed;
			image.originX = 3;
			image.originY = 4;
			graphic.x = -1.75;
		}
		
		override public function update():void
		{
			image.angle = 236 - (Number)(GameWorld.time) / 600 * (236 - 180);
		}
	}

}