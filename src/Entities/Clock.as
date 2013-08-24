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
		
		private var lastCamera:Point;
		private var scrollSpeed:Number = 0.95;
		
		public function Clock(x:int, y:int) 
		{
			super(x, y);
			lastCamera = new Point(FP.camera.x, FP.camera.y);
			graphic = new Image(src);
		}
		
		override public function update():void
		{
			if (FP.camera.x != lastCamera.x) x += (FP.camera.x - lastCamera.x) * scrollSpeed;
			if (FP.camera.y != lastCamera.y) y += (FP.camera.y - lastCamera.y) * scrollSpeed;
			lastCamera.x = FP.camera.x;
			lastCamera.y = FP.camera.y;
		}
		
	}

}