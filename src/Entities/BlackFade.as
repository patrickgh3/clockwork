package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Black rectangle used for fading upon player death.
	 */
	public class BlackFade extends Entity
	{
		private var image:Image;
		public static const fadeTime:int = 40;
		private var count:int = 0;
		
		public function BlackFade(count:int = 0) 
		{
			super(0, 0);
			graphic = image = Image.createRect(Main.width, Main.height, 0x000000);
			graphic.scrollX = graphic.scrollY = 0;
			image.alpha = 0;
			this.count = count;
		}
		
		override public function update():void
		{
			count++;
			if (count < fadeTime)
			{
				image.alpha = count / fadeTime;
			}
			else if (count < fadeTime * 2)
			{
				if (count == fadeTime) (GameWorld)(FP.world).addPlayer();
				image.alpha = 1 - (count - fadeTime) / fadeTime;
			}
			else if (count == fadeTime * 2)
			{
				FP.world.remove(this);
				image.alpha = 0;
				count = 0;
			}
		}
		
	}

}