package  
{
	import Entities.SleepPlayer;
	import Entities.Wrench;
	import Entities.Star;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	
	/**
	 * World for the title screen.
	 */
	public class TitleWorld extends World
	{
		private var titletext:Entity;
		private var presstext:Entity;
		private var cat:SleepPlayer;
		private var wrench:Entity;
		private var purplefade:Entity;
		private var blackfade:Entity;
		private var eventcount:int = -1;
		private var eventtime1:int = 120;
		private var fadecount:int = -10;
		private var fadetime:int = 120;
		
		public function TitleWorld() 
		{
			FP.screen.color = Main.skycolor;
			for (var i:int = 0; i < 8; i++)
				add(new Star(i * Main.width / 8 + 10, Math.random() * (Main.height)));
			
			Text.size = 24;
			titletext = new Entity(24, 32, new Text("Clockwork Cat"));
			add(titletext);
			Text.size = 8;
			presstext = new Entity(72, 128, new Text("Press X to start"));
			add(presstext);
			cat = new SleepPlayer(Main.width / 2 - 28, Main.height / 2 - 16);
			add(cat);
			
			wrench = new Wrench(Main.width / 2 + 12, Main.height / 2 + 8);
			add(wrench);
			
			purplefade = new Entity(0, 0, Image.createRect(Main.width, Main.height, Main.skycolor));
			(Image)(purplefade.graphic).alpha = 0;
			add(purplefade);
			blackfade = new Entity(0, 0, Image.createRect(Main.width, Main.height, 0x000000));
			(Image)(blackfade.graphic).alpha = 0;
			add(blackfade);
		}
		
		override public function update():void
		{
			super.update();
			if (Input.check(Key.X) && eventcount == -1 && fadecount == fadetime)
			{
				eventcount = 0;
			}
			
			if (fadecount < fadetime)
			{
				fadecount++;
				(Image)(purplefade.graphic).alpha = 1 - fadecount / fadetime;
			}
			else if (eventcount >= 0)
			{
				eventcount++;
				(Image)(blackfade.graphic).alpha = eventcount / eventtime1;
				if (eventcount == eventtime1) FP.world = new GameWorld();
			}
		}
		
	}

}