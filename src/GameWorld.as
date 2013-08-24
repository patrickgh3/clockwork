package  
{
	import Entities.Clock;
	import Entities.ClockHand;
	import Entities.Grip;
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
		private var levelmask:Array;
		private var clock:Clock;
		public static var time:int = 0;
		public static const endtime:int = 600;
		public static var timedirection:int = time_forward;
		public static const time_forward:int = 1;
		public static const time_backward:int = 2;
		public static var playersprite:PlayerSprite;
		
		public function GameWorld() 
		{
			FP.screen.color = 0x1D1A36;
			for (var i:int = 0; i < 12; i++) add(new Star(i * Main.width / 12 + 10, Math.random() * (Main.height - 40)));
			add(new Clock(80, 0));
			add(new ClockHand(139, 77));
			
			var grips:Array = new Array();
			var movingblocks:Array = new Array();
			for (i; i < LevelData.actors.length; i++)
			{
				add(LevelData.actors[i]);
				if (LevelData.actors[i] is Grip) grips.push(LevelData.actors[i]);
				else if (LevelData.actors[i] is MovingBlock) movingblocks.push(LevelData.actors[i]);
			}
			player = new Player(64, 64, grips, movingblocks);
			add(player);
			playersprite = new PlayerSprite(player);
			add(playersprite);
			//add(new TimeDisplay(0, 0));
			Text.size = 8;
			var e:Entity = new Entity(0, 0, new Text("Right, left to move"));
			e.graphic.scrollX = e.graphic.scrollY = 0;
			add(e);
			e = new Entity(0, 8, new Text("Z, Up to jump"));
			e.graphic.scrollX = e.graphic.scrollY = 0;
			add(e);
			e = new Entity(0, 16, new Text("Hold X to turn gears"));
			e.graphic.scrollX = e.graphic.scrollY = 0;
			add(e);
		}
		
		override public function update():void
		{
			if (timedirection == time_forward && time < 600)
			{
				time++;
				if (time == 600)
				{
					Text.size = 8;
					var f:Entity = new Entity(32, 32, new Text("Game over not implemented yet ;)"))
					f.graphic.scrollX = f.graphic.scrollY = 0;
					add(f);
				}
			}
			else if (timedirection == time_backward && time > 0)
			{
				time -= 2;
				if (time < 0) time = 0;
			}
			super.update();
			FP.camera.x = Math.max(0, Math.min(LevelData.width * 16 - Main.width, player.x + player.width / 2 - Main.width / 2));
			FP.camera.y = Math.max(0, Math.min(LevelData.height * 16 - Main.height, player.y + player.width / 2 - 16 - Main.height / 2));
		}
		
	}

}