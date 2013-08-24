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
			Text.size = 8;
			add(new Entity(16, 16, new Text("Hello world :P")));
			player = new Player(16, 16);
			add(player);
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}

}