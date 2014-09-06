package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	
	/**
	 * Text that fades in; used for showing the credits.
	 */
	public class FadeText extends Entity
	{
		private var count:int = 0;
		private var fadetime:int = 120;
		private var text:Text;
		private var should_update_position_using_new_positioning_next_tick:Boolean = false;
		
		public function FadeText(x:int, y:int, s:String, size:int, usenewpositioning:Boolean = false) 
		{
			super(x, y);
			Text.size = size;
			graphic = text = new Text(s);
			text.alpha = 0;
			graphic.scrollX = graphic.scrollY = 0;
			
			if (usenewpositioning)
			{
				should_update_position_using_new_positioning_next_tick = true;
			}
			else
			{
				this.x -= s.length * 2;
				if (size == 16) this.x -= s.length * 2;
			}
		}
		
		override public function update():void
		{
			if (should_update_position_using_new_positioning_next_tick)
			{
				x -= (graphic as Text).width / 2;
				should_update_position_using_new_positioning_next_tick = false;
			}
			if (count > 120) return;
			count++;
			text.alpha = count / fadetime;
		}
		
	}

}