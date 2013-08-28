package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Sprite looping the player sleeping animation.
	 */
	public class SleepPlayer extends Entity
	{
		[Embed(source = "/../assets/playersleep.png")]
		private static const src:Class;
		
		private var count:int = 0;
		private const animspeed:int = 10;
		private var sprite:Spritemap;
		
		public function SleepPlayer(x:int, y:int) 
		{
			super(x, y);
			graphic = sprite = new Spritemap(src, 32, 32);
		}
		
		override public function update():void
		{
			count++;
			if (count == animspeed * 8) count = 0;
			if (count % animspeed == 0)
			{
				if (count <= animspeed * 3) sprite.setFrame(count / animspeed, 0);
				else sprite.setFrame((count - animspeed * 4) / animspeed, 1);
			}
		}
		
	}

}