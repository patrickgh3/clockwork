package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Just is a wrench. It does wrench things. For some reason embedding the image in TitleWorld gave an error.
	 */
	public class Wrench extends Entity
	{
		[Embed(source = "/../assets/wrench.png")]
		private static const src:Class;
		
		public function Wrench(x:int, y:int) 
		{
			super(x, y);
			graphic = new Image(src);
		}
		
	}

}