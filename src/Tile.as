package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * A tile which the structure of the world is made of.
	 */
	public class Tile extends Entity
	{
		[Embed(source = "/../assets/tiles.png")]
		private static const src:Class;
		
		public function Tile(x:int, y:int, tx:int, ty:int) 
		{
			x -= 2;
			y -= 3;
			super(x, y);
			graphic = new Image(src, new Rectangle(tx * 20, ty * 20, 20, 20));
		}
		
	}

}