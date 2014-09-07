package  
{
	import Entities.*;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * Main world of the game.
	 */
	public class GameWorld extends World
	{
		[Embed(source = "/../assets/sound/bell.mp3")]
		private static const bell:Class;
		
		public var player:Player;
		private var blackFade:BlackFade;
		public static var playersprite:PlayerSprite;
		public static var spawnx:int;
		public static var spawny:int;
		public static var endingTextShown:Boolean = false;
		public static var inEndingCutscene:Boolean = false;
		
		public static var time:int = 0;
		public static var timeFraction:Number;
		public static var timedirection:int = time_forward;
		public static const time_forward:int = 1;
		public static const time_backward:int = 2;
		public static const time_stopped:int = 3;
		
		private var fadeAction:int;
		public static const fade_respawn:int = 1;
		public static const fade_title:int = 2;
		
		public static var isFading:Boolean;
		
		private var clockcount:int = -1; // used when the clock strikes twelve
		private const clocktime:int = 120;
		
		public static var ticks:int = 0; // records how long it took the player to beat the game
		public var stopcountingticks:Boolean = false;
		private var sfxBell:Sfx;
		
		public function GameWorld() 
		{
			time = 0;
			ticks = 0;
			timedirection = time_forward;
			endingTextShown = false;
			inEndingCutscene = false;
			
			/* Background entities */
			FP.screen.color = Main.skycolor;
			for (var i:int = 0; i < 12; i++)
				add(new Star(i * Main.width / 12 + 10, Math.random() * (Main.height - 50) + 10));
			Clock.computePositions();
			add(new Clock());
			add(new ClockHand());
			for each (var r:Entity in LevelData.rickets) add(r);
			for each (var b:Entity in LevelData.movingblocks) add(b);
			
			/* Foreground entities */
			for each (var e:Entity in LevelData.actors)
			{
				add(e);
			}
			player = new Player(spawnx, spawny);
			playersprite = new PlayerSprite(player);
			blackFade = new BlackFade(BlackFade.fadeTime);
			add(player);
			add(playersprite);
			add(blackFade);
			isFading = true;
			
			sfxBell = new Sfx(bell);
		}
		
		override public function update():void
		{
			if (!stopcountingticks) ticks++;
			
			if (clockcount != -1)
			{
				if (clockcount == 0) sfxBell.play(0.5);
				else if (clockcount == clocktime / 2) sfxBell.play(0.5);
				clockcount++;
				if (clockcount == clocktime)
				{
					clockcount = -1;
					fadeOut(fade_respawn);
				}
			}
			
			if (Input.check(net.flashpunk.utils.Key.T)
				&& ((!player.frozen && !isFading && timedirection == time_forward && !inEndingCutscene) || endingTextShown))
			{
				fadeOut(fade_title);
			}
			
			if (timedirection == time_forward && time < 600)
			{
				time++;
				if (time == 600)
				{
					player.frozen = true;
					timedirection = time_stopped;
					clockcount = 0;
				}
			}
			else if (timedirection == time_backward && time > 0)
			{
				time -= 3;
				if (time < 3) time = 0;
			}
			
			timeFraction = time / 600;
			
			super.update();
			
			FP.camera.x = Math.max(0.5, Math.min(LevelData.width * 16 - Main.width - 0.5, player.x + player.width / 2 - Main.width / 2));
			FP.camera.y = Math.max(0.5, Math.min(LevelData.height * 16 - Main.height - 0.5, player.y + player.width / 2 - 16 - Main.height / 2));
		}
		
		public function fadeOut(fadeAction:int):void
		{
			isFading = true;
			add(blackFade);
			remove(player);
			player.frozen = true;
			timedirection = time_stopped;
			this.fadeAction = fadeAction;
		}
		
		public function onFadeIn():void
		{
			if (fadeAction == fade_respawn)
			{
				add(player);
				player.x = spawnx;
				player.y = spawny;
				player.velocity.y = 0;
				time = 0;
				player.frozen = false;
				player.haskey = false;
				timedirection = time_forward;
				for each (var e:Entity in LevelData.actors)
				{
					if (e is Tile) (e as Tile).lock();
					else if (e is Entities.Key) (e as Entities.Key).reset();
					else if (e is Fish) (e as Fish).reset();
					
				}
			}
			else
			{
				removeAll();
				FP.world = new TitleWorld();
			}
		}
		
	}

}