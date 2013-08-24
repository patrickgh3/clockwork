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
		private static const turnSpeed:int = 10;
		private var count:int = 0;
		public var walking:Boolean = false;
		private var turning:Boolean = false;
		public var holding:Boolean = false;
		
		public function PlayerSprite(p:Player) 
		{
			super();
			player = p;
			graphic = sprite = new Spritemap(src, 32, 20);
		}
		
		override public function update():void
		{
			x = player.x - 12;
			y = player.y - 8;
			
			if (player.velocity.x > 0) sprite.flipped = false;
			else if (player.velocity.x < 0) sprite.flipped = true;
			
			if (holding) return;
			
			if (!player.isOnGround())
			{
				sprite.setFrame(1, 0);
				count = -1;
				walking = false;
			}
			else if (player.velocity.x == 0 && player.isOnGround() && !turning)
			{
				sprite.setFrame(0, 0);
				count = -1;
				walking = false;
			}
			else if (player.velocity.x != 0 && player.isOnGround() && count == -1)
			{
				count = 0;
				walking = true;
				sprite.setFrame(0, 1);
			}
			
			/* Walking animation */
			if (count != -1 && walking)
			{
				count++;
				if (count == walkSpeed * 4) count = 0;
				if (count == 0) sprite.setFrame(0, 1);
				else if (count == walkSpeed) sprite.setFrame(1, 1);
				else if (count == walkSpeed * 2) sprite.setFrame(0, 2);
				else if (count == walkSpeed * 3) sprite.setFrame(1, 2);
			}
			else if (count != -1 && turning)
			{
				count++;
				if (count == turnSpeed * 2) count = 0;
				if (count == 0) sprite.setFrame(1, 3);
				else if (count == turnSpeed) sprite.setFrame(0, 3);
			}
		}
		
		public function isFlipped():Boolean
		{
			return sprite.flipped;
		}
		
		public function startTurning():void
		{
			turning = true;
			count = 0;
			sprite.setFrame(1, 3);
		}
		
		public function stopTurning():void
		{
			turning = false;
			holding = false;
			count = -1;
		}
		
	}

}