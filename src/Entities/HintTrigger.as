package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	
	/**
	 * Trigger which activates a hint message.
	 */
	public class HintTrigger extends Entity
	{
		private var player:Player;
		private var enabled:Boolean;
		private var text:Entity;
		
		public function HintTrigger(x:int, y:int, w:int, h:int, s:String, id:int) 
		{
			super(x, y);
			width = w;
			height = h;
			Text.size = 8;
			text = new Entity(Main.width / 2 - s.length * 2, Main.height / 2 - 16, new Text(s));
			if (id == 21) text.x += s.length - 10;
			text.graphic.scrollX = 0;
			text.graphic.scrollY = 0;
			(Text)(text.graphic).alpha = 0;
		}
		
		override public function update():void
		{
			if (player == null)
			{
				player = (GameWorld)(FP.world).player;
				FP.world.add(text);
			}
			
			var collision:Boolean =
				x < player.x + player.width
				&& x + width > player.x
				&& y < player.y + player.height
				&& y + height > player.y;
			if (collision && !enabled)
			{
				enabled = true;
				(Text)(text.graphic).alpha = 1;
			}
			else if (!collision && enabled)
			{
				enabled = false;
				(Text)(text.graphic).alpha = 0;
			}
		}
		
	}

}