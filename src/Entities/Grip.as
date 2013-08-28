package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	
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
			x -= 1;
			y -= 3;
			this.x = x;
			this.y = y;
			graphic = sprite = new Spritemap(src, 16, 20);
			sprite.setFrame(0);
			width = height = 16;
			sfx = new Sfx(sound);
		}
		
		override public function update():void
		{
			if (animating && !animatinglast)
			{
				sfx.play(0.5);
			}
			
			if (animating)
			{
				count++;
				if (count == animspeed * 2)
				{
					count = 0;
					sprite.setFrame(0);
					sfx.play(0.5);
				}
				if (count > animspeed)
				{
					sprite.setFrame(1);
					sfx.play(0.5);
				}
			}
			else
			{
				sprite.setFrame(0);
			}
			
			animatinglast = animating;
		}
		
	}

}