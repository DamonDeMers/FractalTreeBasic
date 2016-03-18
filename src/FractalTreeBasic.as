package{
	
	import com.abacus.core.StarlingApp;
	import com.abacus.utils.Assets;
	import com.fractalTreeBasic.TreeTut2;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(width="768", height="1024", frameRate="60", backgroundColor="0x000000")]
	public class FractalTreeBasic extends StarlingApp{
		
		private var _tree:TreeTut2;
		
		public function FractalTreeBasic(){
			super(800, 800, true);
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		override protected function enqueueAssets():void{
			var appDir:File = File.applicationDirectory;
			_assets = Assets.MANAGER;
			_assets.scaleFactor = _scaleFactor;
			_assets.verbose = Capabilities.isDebugger;
			_assets.enqueue(
				appDir.resolvePath("assets/images/")
			);
		}
		
		override protected function initStarling():void{
			_starling = new Starling(TreeTut2, stage, _viewport);
			_starling.stage.stageWidth  = _viewPortWidth; 
			_starling.stage.stageHeight = _viewPortHeight;
			_starling.simulateMultitouch  = false;
			_starling.enableErrorChecking = false;
			_starling.showStats = Capabilities.isDebugger;
			_starling.showStatsAt("left", "top", 1/_scaleFactor);
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
		}
		
		override protected function onRootCreated(e:starling.events.Event):void{
			_starling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			_tree = _starling.root as TreeTut2;
			
			_assets.loadQueue(function(ratio:Number):void{
				_appLoader.updateProgress(ratio);
				if (ratio == 1.0){
					removeChild(_appLoader);
					removeChild(_background);
					_starling.start();
					_tree.start();
				}
			});
		}
	
	}
}