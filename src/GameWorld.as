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
		
		public function GameWorld() 
		{
			add(new Entity(16, 16, new Text("Hello world :P")));
			add(new Entity(16, 64, Image.createRect(16, 16, 0xff0000)));
		}
		
		override public function update():void
		{
			
		}
		
	}

}