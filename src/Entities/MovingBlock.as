package Entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	/**
	 * Solid block that moves back and forth.
	 */
	public class MovingBlock extends Entity
	{
		[Embed(source = "/../assets/movingblock.png")]
		private static const src:Class;
		
		private var start:Point = new Point();
		private var end:Point = new Point();
		private var player:Player;
		
		public function MovingBlock(x:int, y:int, xdistance:int, ydistance:int) 
		{
			super(x, y);
			graphic = new Image(src);
			graphic.x = -2;
			graphic.y = -3;
			width = height = 16;
			start.x = x;
			start.y = y;
			end.x = x + xdistance;
			end.y = y + ydistance;
		}
		
		override public function update():void
		{
			if (player == null) player = (GameWorld)(FP.world).player;
			
			x = start.x + (GameWorld.time / 600) * (end.x - start.x);
			y = start.y + (GameWorld.time / 600) * (end.y - start.y);
			
			/* Pushing player horizontally when he's in the way */
			if (ClockUtil.entityCollide(this, player) && player.y > y - 10)
			{
				if (end.x > start.x) player.x = x + width + 1;
				else if (end.x < start.x) player.x = x - player.width - 1;
			}
		}
		
		public function getXSpeed():Number
		{
			var dir:Number = 1;
			if (GameWorld.time == GameWorld.time_backward) dir = -1;
			if (GameWorld.time == 600 || GameWorld.time == 0) return 0;
			return (end.x - start.x) / 600 * dir;
		}
		
	}

}