package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	/**
	 * SEEEEEEEEEEEEECRET
	 */
	public class Fish extends Entity
	{
		[Embed(source = "/../assets/fish.png")]
		private static const src:Class;
		
		private var player:Player;
		public var used:Boolean = false;
		
		public function Fish(x:int, y:int) 
		{
			x += 5;
			y += 13;
			this.x = x;
			this.y = y;
			graphic = new Image(src);
			graphic.x = -1;
			graphic.y = -5;
			width = 6;
			height = 3;
		}
		
		override public function update():void
		{
			if (player == null) player = (GameWorld)(FP.world).player;
			if (x < player.x + player.width && x + width > player.x
				&& y < player.y + player.height && y + height > player.y
				&& !used)
			{
				used = true;
				(Image)(graphic).alpha = 0;
				player.fish();
			}
		}
		
		public function reset():void
		{
			used = false;
			(Image)(graphic).alpha = 1;
		}
		
	}

}