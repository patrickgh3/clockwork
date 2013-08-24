package  
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	[SWF(width="768", height="512", frameRate="-1", backGroundColor = "#000000")]
	
	/**
	 * Entry point into the program.
	 */
	public class Main extends Engine
	{
		private var gw:GameWorld;
		
		public function Main() 
		{
			super(192, 128, 60, true);
			FP.screen.scale = 4;
		}
		
		override public function init():void
		{
			gw = new GameWorld();
			FP.world = gw;
		}
		
	}

}