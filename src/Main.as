package  
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	[SWF(width="896", height="640", frameRate="-1", backGroundColor = "#000000")]
	
	/**
	 * Entry point into the program.
	 */
	public class Main extends Engine
	{
		private var gw:GameWorld;
		public static var width:Number = 224;
		public static var height:Number = 160;
		
		public function Main() 
		{
			super(224, 160, 60, true);
			FP.screen.scale = 4;
		}
		
		override public function init():void
		{
			LevelData.init();
			gw = new GameWorld();
			FP.world = gw;
		}
		
	}

}