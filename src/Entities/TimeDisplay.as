package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	
	/**
	 * Text which shows the current "time" count.
	 */
	public class TimeDisplay extends Entity
	{
		private var text:Text;
		
		public function TimeDisplay(x:int, y:int) 
		{
			super(x, y);
			Text.size = 8;
			graphic = text = new Text("Time: X", 0, 0, 200);
			graphic.scrollX = graphic.scrollY = 0;
		}
		
		override public function update():void
		{
			text.text = "Time: " + GameWorld.time;
		}
		
	}

}