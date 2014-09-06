package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Graphic that moves alongside MovingBlocks.
	 */
	public class Ricket extends Entity
	{
		[Embed(source = "/../assets/ricket.png")]
		private static const src:Class;
		
		public static const dir_top:int = 1;
		public static const dir_bottom:int = 2;
		public static const dir_right:int = 3;
		public static const dir_left:int = 4;
		
		public function Ricket(direction:int) 
		{
			super(0, 0);
			var image:Image;
			graphic = image = new Image(src);
			
			if (direction == dir_top)
			{
				image.angle = 90;
				graphic.y = 0;
				graphic.x = 2;
			}
			else if (direction == dir_bottom)
			{
				image.angle = 90;
				graphic.x = 4;
				graphic.y = 128;
			}
			else if (direction == dir_right)
			{
				image.angle = 0;
				graphic.y = 4;
				graphic.x = 16;
			}
			else if (direction == dir_left)
			{
				image.angle = 0;
				graphic.y = 2;
				graphic.x = -128;
			}
		}
		
	}

}