package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	
	/**
	 * Animated graphic of the player.
	 */
	public class PlayerSprite extends Entity
	{
		[Embed(source = "/../assets/player.png")]
		private static const src:Class;
		[Embed(source = "/../assets/sound/step.mp3")]
		private static const step:Class;
		[Embed(source = "/../assets/sound/jump.mp3")]
		private static const jump:Class;
		
		private static const walkSpeed:int = 7;
		private static const turnSpeed:int = 10;
		
		private var sprite:Spritemap;
		private var player:Player;
		private var count:int = 0;
		public var walking:Boolean = false;
		private var turning:Boolean = false;
		public var holding:Boolean = false;
		private var lastyvel:Number = 0;
		private var sfxStep:Sfx;
		private var sfxJump:Sfx;
		
		private var nojumpcount:int = nojumptime;
		private const nojumptime:int = 15;
		
		public var allowUpdate:Boolean = false; // flag which nullifies update()'s effects when set. used in "new mechanics" to prevent the world from calling update(), as the Player calls it manually.
		
		public function PlayerSprite(p:Player) 
		{
			super();
			player = p;
			graphic = sprite = new Spritemap(src, 32, 20);
			sfxStep = new Sfx(step);
			sfxJump = new Sfx(jump);
			allowUpdate = LevelData.useOriginalMechanics;
		}
		
		public override function update():void
		{
			if (!allowUpdate) return;
			
			if (player.frozen) return;
			
			if (player.velocity.y == 0 && lastyvel > 1) playstep();
			if (player.velocity.y < -1 && lastyvel >= 0) playjump();
			
			x = player.x - 12;
			y = player.y - 8;
			
			if (player.velocity.x > 0) sprite.flipped = false;
			else if (player.velocity.x < 0) sprite.flipped = true;
			
			if (holding) return;
			
			if (nojumpcount < nojumptime) nojumpcount++;
			
			if (!player.isOnGround() && (nojumpcount == nojumptime || !LevelData.useOriginalMechanics))
			{
				sprite.setFrame(1, 0);
				count = -1;
				walking = false;
				nojumpcount = 0;
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
				if (count == walkSpeed * 4) count = 0;
				if (count == 0)
				{
					sprite.setFrame(0, 1);
					playstep();
				}
				else if (count == walkSpeed) sprite.setFrame(1, 1);
				else if (count == walkSpeed * 2) sprite.setFrame(0, 2);
				else if (count == walkSpeed * 3) sprite.setFrame(1, 2);
				count++;
			}
			else if (count != -1 && turning)
			{
				count++;
				if (count == turnSpeed * 2) count = 0;
				if (count == 0) sprite.setFrame(1, 3);
				else if (count == turnSpeed) sprite.setFrame(0, 3);
			}
			lastyvel = player.velocity.y;
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
		
		public function getFish():void
		{
			sprite.flipped = false;
			sprite.setFrame(0, 4);
		}
		
		private function playstep():void
		{
			sfxStep.play(0.5);
		}
		
		private function playjump():void
		{
			sfxJump.play(0.5);
		}
		
	}

}