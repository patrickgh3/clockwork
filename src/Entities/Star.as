package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	
	/**
	 * Shining star in the background.
	 */
	public class Star extends Entity
	{
		[Embed(source = "/../assets/star.png")]
		private static const src:Class;
		
		private var startype:int = (int)(Math.random() * 2);
		private var count:int = Math.random() * (Number)(animSpeed) * 4;
		private const animSpeed:int = 15;
		private var sprite:Spritemap;
		
		public function Star(x:int, y:int) 
		{
			super(x, y);
			graphic = sprite = new Spritemap(src, 8, 8);
			graphic.scrollX = graphic.scrollY = 0;
		}
		
		override public function update():void
		{
			count++;
			if (count == animSpeed * 4) count = 0;
			if (count == 0) sprite.setFrame(0, startype);
			else if (count == animSpeed) sprite.setFrame(1, startype);
			else if (count == animSpeed * 2) sprite.setFrame(2, startype);
			else if (count == animSpeed * 3) sprite.setFrame(1, startype);
		}
		
	}

}