package  
{
	import Entities.MovingBlock;
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
		
		public static function collideMovingBlocks(e:Entity):MovingBlock
		{
			for each (var b:MovingBlock in LevelData.movingblocks)
			{
				if (entityCollide(e, b)) return b;
			}
			return null;
		}
		
		public static function collideLevelMask(e:Entity):Boolean
		{
			var x1:int = Math.floor(e.x / 16);
			var x2:int = Math.floor((e.x + e.width - 1) / 16);
			var y1:int = Math.floor(e.y / 16);
			var y2:int = Math.floor((e.y + e.height - 1) / 16);
				
			return getLevelMaskSafe(x1, y1) != 0
				|| getLevelMaskSafe(x1, y2) != 0
				|| getLevelMaskSafe(x2, y1) != 0
				|| getLevelMaskSafe(x2, y2) != 0;
		}
		
		public static function getLevelMaskSafe(x:int, y:int):int
		{
			if (x < 0 || x >= LevelData.width || y < 0 || y >= LevelData.height)
			{
				return 0;
			}
			return LevelData.levelmask[x][y];
		}
	}

}