package  
{
	import Entities.Grip;
	import Entities.MovingBlock;
	import Entities.PlayerSprite;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * User-controlled player.
	 */
	public class Player extends Entity
	{
		public var velocity:Point = new Point();
		private var onGround:Boolean = true;
		private var levelmask:Array;
		private var grips:Array;
		private var movingblocks:Array;
		public var turning:Boolean = false;
		private var currentgrip:Grip;
		private var currentmovingblock:MovingBlock;
		public var sprite:PlayerSprite;
		public var frozen:Boolean = false;
		private var haskey:Boolean = false;
		
		private var grav:Number = 0.1;
		private var runSpeed:Number = 1;
		private var jumpSpeed:Number = 1.85;
		
		public function Player(x:int, y:int, grips:Array, movingblocks:Array) 
		{
			super(x, y);
			width = 9;
			height = 12;
			levelmask = LevelData.levelmask;
			this.grips = grips;
			this.movingblocks = movingblocks;
		}
		
		override public function update():void
		{
			if (frozen) return;
			if (sprite == null) sprite = GameWorld.playersprite;
			var right:Boolean = Input.check(Key.RIGHT);
			var left:Boolean = Input.check(Key.LEFT);
			var jump:Boolean = Input.pressed(Key.Z) || Input.pressed(Key.UP);
			var action:Boolean = Input.check(Key.X);
			if (turning) right = left = jump = false;
			
			/* Calculate velocity */
			if (right && !left) velocity.x = runSpeed;
			else if (left && !right) velocity.x = -runSpeed;
			else velocity.x = 0;
			velocity.y += grav;
			if (jump && onGround)
			{
				velocity.y = -jumpSpeed;
				onGround = false;
				currentmovingblock = null;
				y--;
			}
			
			/* Movement */
			for (var i:int = 0; i < Math.abs(velocity.x); i++)
			{
				var diff:Number = Math.min(1, Math.abs(velocity.x) - i) * sign(velocity.x);
				x += diff;
				var lock:Tile = collideLock();
				if (haskey && lock)
				{
					haskey = false;
					lock.unlock();
				}
				if (currentmovingblock) y -= 2;
				var collision:Boolean = collidelevelmask();
				var blockcollision:MovingBlock = collidemovingblocks();
				if (collision || blockcollision)
				{
					x -= diff;
				}
				if (currentmovingblock) y += 2;
			}
			if (currentmovingblock != null &&
				(x > currentmovingblock.x + currentmovingblock.width
				|| x + width < currentmovingblock.x)) currentmovingblock = null;
			if (currentmovingblock)
			{
				y = currentmovingblock.y - 11;
				velocity.y = 0;
				x += currentmovingblock.getXSpeed();
			}
			else for (i = 0; i < Math.abs(velocity.y); i++)
			{
				diff = Math.min(1, Math.abs(velocity.y) - i) * sign(velocity.y);
				y += diff;
				
				collision = collidelevelmask();
				blockcollision = collidemovingblocks();
				if (blockcollision && velocity.y > 0)
				{
					onGround = true;
					currentmovingblock = blockcollision;
					x = (Number)((int)(x)) + (currentmovingblock.x - (Number)((int)(currentmovingblock.x)));
					velocity.y = 0;
				}
				if (collision || (blockcollision && velocity.y < 0))
				{
					y -= diff;
					if (velocity.y > 0)
					{
						onGround = true;
					}
					velocity.y = 0;
				}
			}
			
			if (!currentmovingblock && ((i != 0 && velocity.y != 0) || (i == 0 && !onGround))) onGround = false;
			sprite.x = x - 12;
			sprite.y = y - 8;
			
			if (y > 520)
			{
				(GameWorld)(FP.world).addBlackFade();
				currentgrip = null;
				currentmovingblock = null;
			}
			
			while (collidelevelmask()) y--;
			
			/* Turning grip */
			if (action && !turning && onGround)
			{
				for (i = 0; i < grips.length; i++)
				{
					var g:Grip = grips[i];
					if (x > g.x + g.width
					|| x + width < g.x
					|| y > g.y + g.height
					|| y + height < g.y) continue;
					
					turning = true;
					g.animating = true;
					g.count = 0;
					currentgrip = g;
					GameWorld.timedirection = GameWorld.time_backward;
					if (!sprite.isFlipped()) x = g.x - 6;
					else x = g.x + 13;
					sprite.startTurning();
					sprite.walking = false;
					GameWorld.spawnx = g.x;
					GameWorld.spawny = g.y + 4;
				}
			}
			else if (!action && turning)
			{
				turning = false;
				GameWorld.timedirection = GameWorld.time_forward;
				currentgrip.animating = false;
				currentgrip = null;
				sprite.stopTurning();
			}
			else if (action && turning && GameWorld.time == 0)
			{
				currentgrip.animating = false;
				sprite.holding = true;
			}
		}
		
		private function collidelevelmask():Boolean
		{
			var x1:int = int(x / 16);
			var x2:int = int((x + width - 1) / 16);
			var y1:int = int(y / 16);
			var y2:int = int((y + height - 1) / 16);
			if (x < 0) x1 = -1;
			if (y < 0) y1 = -1;
				
			return levelmask[x1][y1]
				|| levelmask[x1][y2]
				|| levelmask[x2][y1]
				|| levelmask[x2][y2] ;
		}
		
		private function collideLock():Tile
		{
			var x1:int = int(x / 16);
			var x2:int = int((x + width - 1) / 16);
			var y1:int = int(y / 16);
			var y2:int = int((y + height - 1) / 16);
			if (x < 0) x1 = -1;
			if (y < 0) y1 = -1;
			
			if (levelmask[x1][y1] == 2) return LevelData.locks[x1][y1]
			else if (levelmask[x1][y2] == 2) return LevelData.locks[x1][y2];
			else if (levelmask[x2][y1] == 2) return LevelData.locks[x2][y1];
			else if (levelmask[x2][y2] == 2) return LevelData.locks[x2][y2];
			else return null;
		}
		
		private function collidemovingblocks():MovingBlock
		{
			for (var i:int = 0; i < movingblocks.length; i++)
			{
				var b:MovingBlock = movingblocks[i];
				if (x > b.x + b.width
					|| x + width < b.x
					|| y > b.y + b.height
					|| y + height < b.y) continue;
				return b;
			}
			return null;
		}
		
		private function sign(x:Number):Number
		{
			return x / Math.abs(x);
		}
		
		public function isOnGround():Boolean
		{
			return onGround;
		}
		
		public function giveKey():void
		{
			haskey = true;
		}
		
	}

}