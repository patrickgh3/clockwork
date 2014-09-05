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
		private var initialEntities:Array = [];
		private var customLevelEntities:Array = [];
		private var purplefade:Entity;
		private var blackfade:Entity;
		private var customLevelErrorText:Entity;
		private var eventcount:int = -1;
		private var eventtime1:int = 120;
		private var fadecount:int = -10;
		private var fadetime:int = 120;
		private var errortextcount:int = 0;
		private var incustom:Boolean = false;
		
		public function TitleWorld() 
		{
			FP.screen.color = Main.skycolor;
			for (var i:int = 0; i < 8; i++)
				add(new Star(i * Main.width / 8 + 10, Math.random() * (Main.height)));
			
			Text.size = 24;
			initialEntities.push(new Entity(24, 32, new Text("Clockwork Cat")));
			Text.size = 8;
			initialEntities.push(new Entity(72, 128, new Text("Press X to start")));
			initialEntities.push(new Entity(58, 137, new Text("Press C for custom level")));
			initialEntities.push(new SleepPlayer(Main.width / 2 - 28, Main.height / 2 - 16));
			initialEntities.push(new Wrench(Main.width / 2 + 12, Main.height / 2 + 8));
			ExecuteOnEntityArray(initialEntities, add);
			
			Text.size = 16;
			customLevelEntities.push(new Entity(32, 8, new Text("Custom Levels =^.^=")));
			Text.size = 8;
			customLevelEntities.push(new Entity(32, 24, new Text("description and links go here.\n\n"
			+ "Press C to load level\nPress T to return to title")));
			customLevelErrorText = new Entity(32, 100, new Text("Invalid level."));
			(customLevelErrorText.graphic as Image).alpha = 0;
			customLevelEntities.push(customLevelErrorText);
			
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
			if (eventcount == -1 && fadecount == fadetime)
			{
				if (Input.check(Key.X))
				{
					if (incustom)
					{
						// todo: try load custom level
						errortextcount = 90;
					}
					else
					{
						eventcount = 0;
						remove(blackfade);
						add(blackfade); // send to front
					}
				}
				else if (Input.check(Key.C) && !incustom)
				{
					incustom = true;
					ExecuteOnEntityArray(initialEntities, remove);
					ExecuteOnEntityArray(customLevelEntities, add);
				}
				else if (Input.check(Key.T) && incustom)
				{
					incustom = false;
					ExecuteOnEntityArray(initialEntities, add);
					ExecuteOnEntityArray(customLevelEntities, remove);
					errortextcount = 0;
				}
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
			
			if (errortextcount > 0) errortextcount--;
			(customLevelErrorText.graphic as Image).alpha = errortextcount / 60;
		}
		
		private function ExecuteOnEntityArray(array:Array, func:Function):void
		{
			for each (var entity:Entity in array)
			{
				func(entity);
			}
		}
		
	}

}