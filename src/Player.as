package  
{
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
		
		private var grav:Number = 0.1;
		private var runSpeed:Number = 1;
		private var jumpSpeed:Number = 1.5;
		
		public function Player(x:int, y:int) 
		{
			super(x, y);
			graphic = Image.createRect(16, 16, 0xff0000);
		}
		
		override public function update():void
		{
			var right:Boolean = Input.check(Key.RIGHT);
			var left:Boolean = Input.check(Key.LEFT);
			var jump:Boolean = Input.pressed(Key.Z);
			var action:Boolean = Input.pressed(Key.X);
			
			/* Calculate velocity */
			if (right && !left) velocity.x = runSpeed;
			else if (left && !right) velocity.x = -runSpeed;
			else velocity.x = 0;
			velocity.y += grav;
			if (jump && onGround) velocity.y = -jumpSpeed;
			
			/* Movement */
			for (var i:int = 0; i < Math.abs(velocity.x); i++)
			{
				var diff:Number = Math.min(1, Math.abs(velocity.x) - i) * sign(velocity.x);
				x += diff;
				
				var collision:Boolean = false;
				if (collision)
				{
					x -= diff;
				}
			}
			for (i = 0; i < Math.abs(velocity.y); i++)
			{
				var diff:Number = Math.min(1, Math.abs(velocity.y) - i) * sign(velocity.y);
				y += diff;
				
				var collision:Boolean = false;
				if (collision)
				{
					y -= diff;
				}
			}
			if (y >= 64)
			{
				y = 64;
				velocity.y = 0;
			}
		}
		
		private function sign(x:Number):Number
		{
			return x / Math.abs(x);
		}
		
	}

}