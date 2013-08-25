package Entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Key entitiy that the player picks up.
	 */
	public class Key extends Entity
	{
		[Embed(source = "/../assets/key.png")]
		private static const src:Class;
		
		private var count:int = 0;
		private var time1:int = 120;
		private var time2:int = 7;
		public var sprite:Spritemap;
		private var velocity:Point = new Point();
		private var grav:Number = 0.1;
		private var player:Player;
		public var used:Boolean = false;
		private var special:int;
		private var startx:int;
		private var starty:int;
		private var pushed:int = 0;
		
		public function Key(x:int, y:int, special:int) 
		{
			x += 4;
			y += 11;
			this.x = x;
			this.y = y;
			graphic = sprite = new Spritemap(src, 16, 16);
			sprite.x = -4;
			sprite.y = -6;
			sprite.setFrame(0);
			width = 8;
			height = 4;
			this.special = special;
			startx = x;
			starty = y;
		}
		
		override public function update():void
		{
			if (player == null) player = (GameWorld)(FP.world).player;
			
			count++;
			if (count == time1) sprite.setFrame(1);
			else if (count == time1 + time2) sprite.setFrame(2);
			else if (count == time1 + time2 * 2) sprite.setFrame(1);
			else if (count == time1 + time2 * 3)
			{
				sprite.setFrame(0);
				count = 0;
			}
			
			if (x < player.x + player.width && x + width > player.x
				&& y < player.y + player.height && y + height > player.y
				&& !used)
			{
				used = true;
				sprite.alpha = 0;
				player.giveKey();
			}
			
			/* Physics */
			if (special == 1 && FP.world.camera.x + Main.width >= x) special = 2;
			if (special == 2)
			{
				x = -pushed + startx + 96 * GameWorld.time / 600;
				if (x > startx + 70)
				{
					pushed++;
					if (pushed == width) special = 3;
				}
			}
			else if (special == 3)
			{
				velocity.y += grav;
				y += velocity.y;
				if (y > starty + 80)
				{
					y = starty + 80;
					special = 4;
				}
			}
		}
		
		public function reset():void
		{
			if (special != 0)
			{
				special = 1;
				pushed = 0;
				y = starty;
				x = startx;
				velocity.y = 0;
			}
		}
		
	}

}