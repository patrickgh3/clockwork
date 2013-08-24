package  
{
	import Entities.Grip;
	import Entities.PlayerSprite;
	import flash.geom.Point;
	import net.flashpunk.Entity;
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
		public var turning:Boolean = false;
		private var currentgrip:Grip;
		private var sprite:PlayerSprite;
		
		private var grav:Number = 0.1;
		private var runSpeed:Number = 1;
		private var jumpSpeed:Number = 1.85;
		
		public function Player(x:int, y:int, grips:Array) 
		{
			super(x, y);
			width = 9;
			height = 12;
			levelmask = LevelData.levelmask;
			this.grips = grips;
		}
		
		override public function update():void
		{
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
			}
			
			/* Movement */
			for (var i:int = 0; i < Math.abs(velocity.x); i++)
			{
				var diff:Number = Math.min(1, Math.abs(velocity.x) - i) * sign(velocity.x);
				x += diff;
				
				var collision:Boolean = collidelevelmask();
				if (collision)
				{
					x -= diff;
				}
			}
			for (i = 0; i < Math.abs(velocity.y); i++)
			{
				diff = Math.min(1, Math.abs(velocity.y) - i) * sign(velocity.y);
				y += diff;
				
				collision = collidelevelmask();
				if (collision)
				{
					y -= diff;
					if (velocity.y > 0) onGround = true;
					velocity.y = 0;
				}
			}
			if ((i != 0 && velocity.y != 0) || (i == 0 && !onGround)) onGround = false;
			
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
				
			return levelmask[x1][y1] == 1 ||
				   levelmask[x1][y2] == 1 ||
				   levelmask[x2][y1] == 1 ||
				   levelmask[x2][y2] == 1;
		}
		
		private function sign(x:Number):Number
		{
			return x / Math.abs(x);
		}
		
		public function isOnGround():Boolean
		{
			return onGround;
		}
		
	}

}