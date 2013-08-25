package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	
	/**
	 * Wrench grip that the player turns.
	 */
	public class Grip extends Entity
	{
		[Embed(source = "/../assets/grip.png")]
		private static const src:Class;
		[Embed(source = "/../assets/sound/wrench.mp3")]
		private static const sound:Class;
		
		private var sprite:Spritemap;
		public var count:int = 0;
		private var animspeed:int = 10;
		public var animating:Boolean = false;
		private var animatinglast:Boolean = false;
		private var sfx:Sfx;
		
		public function Grip(x:int, y:int) 
		{
			super(x - 1, y - 3);
			graphic = sprite = new Spritemap(src, 16, 20);
			sprite.setFrame(0);
			width = height = 16;
			sfx = new Sfx(sound);
		}
		
		override public function update():void
		{
			if (animating && !animatinglast)
			{
				playsound();
			}
			
			if (animating)
			{
				count++;
				if (count == animspeed * 2)
				{
					count = 0;
					sprite.setFrame(0);
					playsound();
				}
				if (count > animspeed)
				{
					sprite.setFrame(1);
					playsound();
				}
			}
			else
			{
				sprite.setFrame(0);
			}
			animatinglast = animating;
		}
		
		private function playsound():void
		{
			sfx.play(0.5);
		}
		
	}

}