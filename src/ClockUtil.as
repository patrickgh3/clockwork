package  
{
	import net.flashpunk.Entity;
	
	/**
	 * Holds utility functions.
	 */
	public class ClockUtil 
	{
		public static function rectCollide(x1:Number, y1:Number, w1:Number, h1:Number,
										   x2:Number, y2:Number, w2:Number, h2:Number):Boolean
		{
			return x1 < x2 + w2
				&& x1 + w1 > x2
				&& y1 < y2 + h2
				&& y1 + h1 > y2;
		}
		
		public static function entityCollide(e1:Entity, e2:Entity):Boolean
		{
			return rectCollide(e1.x, e1.y, e1.width, e1.height, e2.x, e2.y, e2.width, e2.height);
		}
	}

}