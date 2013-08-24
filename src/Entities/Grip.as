package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Wrench grip that the player turns.
	 */
	public class Grip extends Entity
	{
		[Embed(source = "/../assets/grip.png")]
		private static const src:Class;
		
		private var sprite:Spritemap;
		public var count:int = 0;
		private var animspeed:int = 10;
		public var animating:Boolean = false;
		private var animatinglast:Boolean = false;
		
		public function Grip(x:int, y:int) 
		{
			super(x - 1, y - 3);
			graphic = sprite = new Spritemap(src, 16, 20);
			sprite.setFrame(0);
			width = height = 16;
		}
		
		override public function update():void
		{
			if (animating)
			{
				count++;
				if (count == animspeed * 2)
				{
					count = 0;
					sprite.setFrame(0);
				}
				if (count > animspeed) sprite.setFrame(1);
			}
			else
			{
				sprite.setFrame(0);
			}
		}
		
	}

}