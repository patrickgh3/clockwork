package  
{
	import net.flashpunk.Entity;
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
		
		public function GameWorld() 
		{
			player = new Player(16, 16);
			for (var i:int = 0; i < LevelData.tiles.length; i++) add(LevelData.tiles[i]);
			add(player);
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}

}