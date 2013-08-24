package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Animated graphic of the player.
	 */
	public class PlayerSprite extends Entity
	{
		[Embed(source = "/../assets/player.png")]
		private static const src:Class;
		
		private var sprite:Spritemap;
		private var player:Player;
		private static const walkSpeed:int = 7;
		private var count:int = 0;
		
		public function PlayerSprite(p:Player) 
		{
			super();
			player = p;
			graphic = sprite = new Spritemap(src, 32, 16);
		}
		
		override public function update():void
		{
			x = player.x - 12;
			y = player.y - 4;
			
			if (player.velocity.x > 0) sprite.flipped = false;
			else if (player.velocity.x < 0) sprite.flipped = true;
			
			if (!player.isOnGround())
			{
				sprite.setFrame(1, 0);
				count = -1;
			}
			else if (player.velocity.x == 0 && player.isOnGround())
			{
				sprite.setFrame(0, 0);
				count = -1;
			}
			else if (player.velocity.x != 0 && player.isOnGround() && count == -1)
			{
				count = 0;
				sprite.setFrame(0, 1);
			}
			
			/* Walking animation */
			if (count != -1)
			{
				count++;
				if (count == walkSpeed * 4) count = 0;
				if (count == 0) sprite.setFrame(0, 1);
				else if (count == walkSpeed) sprite.setFrame(1, 1);
				else if (count == walkSpeed * 2) sprite.setFrame(0, 2);
				else if (count == walkSpeed * 3) sprite.setFrame(1, 2);
			}
		}
		
	}

}