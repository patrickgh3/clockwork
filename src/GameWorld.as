package  
{
	import Entities.BlackFade;
	import Entities.Clock;
	import Entities.ClockHand;
	import Entities.Fish;
	import Entities.Grip;
	import Entities.Key;
	import Entities.MovingBlock;
	import Entities.PlayerSprite;
	import Entities.Star;
	import Entities.TimeDisplay;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	
	/**
	 * Main world of the game.
	 */
	public class GameWorld extends World
	{
		public var player:Player;
		private var blackFade:BlackFade;
		public static var time:int = 0;
		public static const endtime:int = 600;
		public static var timedirection:int = time_forward;
		public static const time_forward:int = 1;
		public static const time_backward:int = 2;
		public static const time_stopped:int = 3;
		public static var playersprite:PlayerSprite;
		public static var spawnx:int;
		public static var spawny:int;
		private var clockcount:int = -1;
		private var clocktime:int = 120;
		
		public function GameWorld() 
		{
			FP.screen.color = 0x1D1A36;
			for (var i:int = 0; i < 12; i++) add(new Star(i * Main.width / 12 + 10, Math.random() * (Main.height - 50) + 10));
			add(new Clock(85, 0));
			add(new ClockHand(144, 77));
			
			for (i = 0; i < LevelData.rickets.length; i++)
			{
				add(LevelData.rickets[i]);
			}
			
			for (i = 0; i < LevelData.movingblocks.length; i++)
			{
				add(LevelData.movingblocks[i]);
			}
			
			var grips:Array = new Array();
			for (i = 0; i < LevelData.actors.length; i++)
			{
				add(LevelData.actors[i]);
				if (LevelData.actors[i] is Grip) grips.push(LevelData.actors[i]);
			}
			player = new Player(spawnx, spawny, grips, LevelData.movingblocks);
			add(player);
			playersprite = new PlayerSprite(player);
			add(playersprite);
			blackFade = new BlackFade(BlackFade.fadeTime);
			add(blackFade);
			
			//add(new TimeDisplay(0, 0));
		}
		
		override public function update():void
		{
			if (clockcount != -1)
			{
				clockcount++;
				if (clockcount == clocktime)
				{
					clockcount = -1;
					addBlackFade();
				}
			}
			if (timedirection == time_forward && time < 600)
			{
				time++;
				if (time == 600)
				{
					/*
					Text.size = 8;
					var f:Entity = new Entity(32, 32, new Text("Game over not implemented yet ;)"))
					f.graphic.scrollX = f.graphic.scrollY = 0;
					add(f);*/
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
			super.update();
			FP.camera.x = Math.max(0, Math.min(LevelData.width * 16 - Main.width, player.x + player.width / 2 - Main.width / 2));
			FP.camera.y = Math.max(0, Math.min(LevelData.height * 16 - Main.height, player.y + player.width / 2 - 16 - Main.height / 2));
		}
		
		public function addBlackFade():void
		{
			add(blackFade);
			remove(player);
			player.frozen = true;
			timedirection = time_stopped;
		}
		
		public function addPlayer():void
		{
			add(player);
			player.x = spawnx;
			player.y = spawny;
			time = 0;
			player.frozen = false;
			timedirection = time_forward;
			for (var i:int = 0; i < LevelData.actors.length; i++)
			{
				if (LevelData.actors[i] is Tile) LevelData.actors[i].lock();
				else if (LevelData.actors[i] is Key) LevelData.actors[i].reset();
				else if (LevelData.actors[i] is Fish) LevelData.actors[i].reset();
				
			}
		}
		
	}

}