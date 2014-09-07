package Entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	
	/**
	 * Key entitiy that the player picks up.
	 */
	public class Key extends Entity
	{
		[Embed(source = "/../assets/key.png")]
		private static const src:Class;
		[Embed(source = "/../assets/sound/wrench.mp3")]
		private static const sound:Class;
		
		public var sprite:Spritemap;
		public var used:Boolean = false;
		private var player:Player;
		private var startx:int;
		private var starty:int;
		private var sfx:Sfx;
		
		private var physics:int;
		private var count:int = 0;
		private var time1:int = 120;
		private var time2:int = 7;
		private var pushed:int = 0;
		private var velocity:Point = new Point();
		private var grav:Number = 0.1;
		
		public function Key(x:int, y:int) 
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
			this.physics = (LevelData.useOriginalMechanics && y == 123) ? 1 : 0; // a
			startx = x;
			starty = y;
			sfx = new Sfx(sound);
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
			
			if (ClockUtil.entityCollide(this, player) && !used)
			{
				used = true;
				sprite.alpha = 0;
				player.giveKey();
				sfx.play(0.5);
			}
			
			/* Physics.
			 * Since only one key has "physics," I fudged it with exact values. */
			// only do physics if key is onscreen. Otherwise the puzzle would be solved by accident
			// before even seeing it.
			if (physics == 1 && FP.world.camera.x + Main.width >= x) physics = 2;
			// on block
			if (physics == 2)
			{
				x = -pushed + startx + 80 * GameWorld.time / 600;
				if (x > startx + 54)
				{
					pushed++;
					if (pushed == width) physics = 3;
				}
			}
			// falling
			else if (physics == 3)
			{
				velocity.y += grav;
				y += velocity.y;
				if (y > starty + 80)
				{
					y = starty + 80;
					physics = 4;
				}
			}
		}
		
		public function reset():void
		{
			used = false;
			sprite.alpha = 1;
			if (physics != 0)
			{
				physics = 1;
				pushed = 0;
				y = starty;
				x = startx;
				velocity.y = 0;
			}
		}
		
	}

}