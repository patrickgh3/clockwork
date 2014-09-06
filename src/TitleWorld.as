package  
{
	import Entities.SleepPlayer;
	import Entities.Wrench;
	import Entities.Star;
	import flash.events.TextEvent;
	import flash.events.ContextMenuEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
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
		private var _copyPaste:TextField;
		
		public function TitleWorld() 
		{
			// create / add entities
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
			customLevelEntities.push(new Entity(24, 24, new Text("description and links go here.\n\n"
			+ "Right-click and paste the level into the game.\nPress T to return to title")));
			customLevelErrorText = new Entity(32, 100, new Text("Invalid level.", 0, 0, 2000, 100));
			(customLevelErrorText.graphic as Image).alpha = 0;
			customLevelEntities.push(customLevelErrorText);
			
			purplefade = new Entity(0, 0, Image.createRect(Main.width, Main.height, Main.skycolor));
			(Image)(purplefade.graphic).alpha = 0;
			add(purplefade);
			blackfade = new Entity(0, 0, Image.createRect(Main.width, Main.height, 0x000000));
			(Image)(blackfade.graphic).alpha = 0;
			add(blackfade);
			
			// Add a text field over the whole app. Allows for right-click copy/paste, as well as ctrl-c/ctrl-v
			// Taken from as3sfxr: https://code.google.com/p/as3sfxr/source/browse/trunk/src/SfxrApp.as
			// with a few modifications. Honestly I just changed things at random until it worked.
			// Got to here from this thread: http://forums.tigsource.com/index.php?topic=19716.0;wap2
			// which came from a google search.
			_copyPaste = new TextField();
			_copyPaste.addEventListener(TextEvent.TEXT_INPUT, updateFromCopyPaste);
			_copyPaste.defaultTextFormat = new TextFormat("Amiga4Ever", 8, 0);
			_copyPaste.wordWrap = false;
			_copyPaste.multiline = false;
			_copyPaste.type = TextFieldType.INPUT;
			_copyPaste.embedFonts = true;
			_copyPaste.width = 1000;
			_copyPaste.height = 1000;
			_copyPaste.x = 0;
			_copyPaste.y = 0;
			FP.stage.addChild(_copyPaste);
			_copyPaste.contextMenu = new ContextMenu();
			FP.stage.focus = _copyPaste;
			// todo: make it a visible box or something, and direct the player to click on it.
			// and remove it when in the normal title state / game state, so everywhere you right-click you see the standard options menu.
		}
		
		override public function update():void
		{
			super.update();
			if (!isFading())
			{
				if (Input.check(Key.X) && !incustom)
				{
					LevelData.loadStandardLevel();
					startFade();
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
			(customLevelErrorText.graphic as Image).alpha = errortextcount / 90;
		}
		
		private function isFading():Boolean
		{
			return eventcount != -1 || fadecount != fadetime;
		}
		
		private function startFade():void
		{
			eventcount = 0;
			remove(blackfade);
			add(blackfade); // send blackfade to front
		}
		
		private function updateFromCopyPaste(e:TextEvent):void
		{
			if (!incustom || isFading()
				|| e.text.length <= 1) // don't let stray keypresses trigger the level loading
			{
				return;
			}
			
			e.text = e.text.replace(/  /g, "").replace(/    /g, ""); // standard spaces outputted by Ogmo
			var result:Boolean = LevelData.tryLoadCustomLevel(e.text);
			if (result)
			{
				startFade();
			}
			else
			{
				errortextcount = 120;
				(customLevelErrorText.graphic as Text).text = LevelData.errorMessage;
			}
			_copyPaste.text = "";
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