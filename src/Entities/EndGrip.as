package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Entity which controls the short ending sequence.
	 */
	public class EndGrip extends Entity
	{
		[Embed(source = "/../assets/endgrip.png")]
		private static const src:Class;
		
		private var count:int = -1;
		private var player:Player;
		private var sprite:Spritemap;
		
		public function EndGrip(x:int, y:int) 
		{
			x -= 8;
			y -= 3;
			this.x = x;
			this.y = y;
			graphic = sprite = new Spritemap(src, 32, 20);
			sprite.setFrame(0);
			width = 32;
			height = 16;
		}
		
		override public function update():void
		{
			if (player == null) player = (GameWorld)(FP.world).player;
			
			if (count >= 0 && count < 421)
			{
				if (count == 0)
				{
					(GameWorld)(FP.world).stopcountingticks = true;
					sprite.setFrame(0, 1);
					if (GameWorld.time > 330) GameWorld.time = 330;
				}
				else if (count == 120)
				{
					sprite.setFrame(0, 2);
					GameWorld.timedirection = GameWorld.time_stopped;
				}
				else if (count == 150)
				{
					sprite.setFrame(0, 3);
				}
				else if (count == 300)
				{
					sprite.setFrame(0, 4);
					FP.world.add(new SleepPlayer(x - 16, y - 12));
				}
				else if (count == 420)
				{
					FP.world.add(new FadeText(Main.width / 2, 4, "Clockwork Cat", 16));
					FP.world.add(new FadeText(Main.width / 2, 24, "a game by Patrick Traynor", 8));
					FP.world.add(new FadeText(Main.width / 2, 34, "for Ludum Dare 27: 10 Seconds", 8));
					FP.world.add(new FadeText(Main.width / 2, 44, "powered by Flashpunk and Ogmo", 8));
					FP.world.add(new FadeText(Main.width / 2, 54, "Thanks for playing!", 8));
					var ticks:Number = (Number)(GameWorld.ticks);
					var minutes:int = ticks / 3600;
					ticks %= 3600;
					var seconds:int = ticks / 60;
					ticks %= 60;
					var milliseconds:int = ticks;
					
					var time:String = "Time: " + minutes + ":";
					if (seconds < 10) time += "0";
					time += seconds + ".";
					if (milliseconds < 10) time += "0";
					time += milliseconds;
					FP.world.add(new FadeText(Main.width / 2, 64, time, 8));
				}
				count++;
			}
			else if (x < player.x + player.width && x + width > player.x
				&& y < player.y + player.height && y + height > player.y
				&& Input.check(net.flashpunk.utils.Key.X))
			{
				count = 0;
				FP.world.remove(player);
				FP.world.remove(player.sprite);
			}
		}
		
	}

}