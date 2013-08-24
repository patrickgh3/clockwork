package  
{
	import Entities.Clock;
	import Entities.PlayerSprite;
	import Entities.Star;
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
		private var player:Player;
		private var levelmask:Array;
		private var clock:Clock;
		
		public function GameWorld() 
		{
			for (var i:int = 0; i < 12; i++) add(new Star(i * Main.width / 12 + 10, Math.random() * (Main.height - 40)));
			clock = new Clock(80, 0);
			add(clock);
			player = new Player(16, 16);
			for (i; i < LevelData.tiles.length; i++) add(LevelData.tiles[i]);
			add(player);
			add(new PlayerSprite(player));
			FP.screen.color = 0x1D1A36;
		}
		
		override public function update():void
		{
			super.update();
			FP.camera.x = Math.max(0, Math.min(LevelData.width * 16 - Main.width, player.x + player.width / 2 - Main.width / 2));
			FP.camera.y = Math.max(0, Math.min(LevelData.height * 16 - Main.height, player.y + player.width / 2 - 8 - Main.height / 2));
		}
		
	}

}