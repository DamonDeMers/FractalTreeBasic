package com.abacus.core{
	
	import com.abacus.ui.loader.AppLoader;
	import com.abacus.utils.AppUtils;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	[SWF(width="768", height="1024", frameRate="60", backgroundColor="0x000000")]
	public class StarlingApp extends Sprite{

		protected var _assets:AssetManager;
		
		protected var _starling:Starling;
		protected var _root:AbacusRoot;
		
		protected var _background:Bitmap;
		protected var _appLoader:AppLoader;
		
		protected var _designWidth:int;
		protected var _designHeight:int;
		protected var _isDebug:Boolean;
		protected var _scaleFactor:int;
		protected var _viewport:Rectangle;
		protected var _viewPortWidth:int;
		protected var _stageWidth:int;
		protected var _stageHeight:int;
		protected var _viewPortHeight:int;
		protected var _isWeb:Boolean;
		
		public final function StarlingApp(designWidth:int, designHeight:int, isDebug:Boolean){
			_designWidth = designWidth;
			_designHeight = designHeight;
			_isDebug = isDebug;
			initStageProps();
			initStarlingProps();
			calculateScaleFactor();
			initViewport();
			enqueueAssets();
			initBackground();
			initLoaderBar();
			initStarling();
			if(!AppUtils.isDesktop()) initNativeApplicationListeners();
			initConsole();
			traceProps();
		}
		
		protected function initStageProps():void{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			_isWeb = AppUtils.isDesktop() && !_isDebug;
		}
			
		protected function initStarlingProps():void{
			Starling.multitouchEnabled = false;
			Starling.handleLostContext = true;
		}
		
		protected function initViewport():void{
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			_stageWidth = _isWeb ? stage.stageWidth : stage.fullScreenWidth;
			_stageHeight = _isWeb ? stage.stageHeight : stage.fullScreenHeight;
			_viewPortWidth =  _stageWidth/_scaleFactor;
			_viewPortHeight = _stageHeight/_scaleFactor;
			
			_viewport = RectangleUtil.fit(
				new Rectangle(0, 0, _viewPortWidth, _viewPortHeight), 
				new Rectangle(0, 0, _stageWidth, _stageHeight), 
				ScaleMode.SHOW_ALL, iOS);
		}
		
		protected function enqueueAssets():void{
			/**
			 * Override in subclass.  Implement as shown below
			 */
			
			/*
			var appDir:File = File.applicationDirectory;
			_assets = Assets.MANAGER;
			_assets.scaleFactor = _scaleFactor;
			_assets.verbose = Capabilities.isDebugger;
			_assets.enqueue(
				appDir.resolvePath(assets/images/")
			);
			*/
		}
		
		protected function initBackground():void{
			_background = new Bitmap(new BitmapData(1, 1, false, 0x1e1e27));
			addChild(_background); 
			
			_background.x = _viewport.x;
			_background.y = _viewport.y;
			_background.width  = _viewport.width;
			_background.height = _viewport.height;
			_background.smoothing = true;
		}
		
		protected function calculateScaleFactor():void{
			var fsWidth:Number = _isWeb ? stage.stageWidth : stage.fullScreenWidth;
			var smallScreen:Number = _designWidth * 1.49; //~ midway between small and medium screen resolution
			var mediumScreen:Number = _designWidth * 2.24; //~ midway between medium and large screen resolution
			
			_scaleFactor = fsWidth <= smallScreen ? 1 : fsWidth <= mediumScreen ? 2 : 4;
		}
		
		protected function initLoaderBar():void{
			_appLoader = new AppLoader(_viewport, _scaleFactor);
			addChild(_appLoader);
		}
		
		protected function initStarling():void{
			throw new Error("[StarlingApp] (initStarling) -- This function must be overriden in subclass");
			
			//Implement as shown below
			/*		
			_starling = new Starling(GameRoot, stage, _viewport);
			_starling.stage.stageWidth  = _viewPortWidth; 
			_starling.stage.stageHeight = _viewPortHeight;
			_starling.simulateMultitouch  = false;
			_starling.enableErrorChecking = false;
			_starling.showStats = Capabilities.isDebugger;
			_starling.showStatsAt("left", "top", 1/_scaleFactor);
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			*/
		}
		
		protected function initNativeApplicationListeners():void{
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function(e:*):void {_starling.start()});
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.DEACTIVATE, function(e:*):void {_starling.stop()});
		}

		protected function onRootCreated(e:starling.events.Event):void{
			throw new Error("[StarlingApp] (onRootCreated) -- This function must be overriden in subclass");
			
			//Implement as shown below
			
			/*
			_starling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			_root = _starling.root as GameRoot;
			_starling.start();
			
			_assets.loadQueue(function(ratio:Number):void{
				_appLoader.updateProgress(ratio);
				if (ratio == 1.0){
					removeChild(_appLoader);
					removeChild(_background);
					_root.init(GameController, GameModel);
				}
			});
			*/
		}
		
		protected function initConsole():void{
			/**
			 * Override in subclass.  Example of below using DConsole.
			 */
			
			/*
			addChild(DConsole.view);
			*/
		}
		
		public function traceProps():void{
			trace("** Starling App Props **");
			trace("stage width: " + _stageWidth);
			trace("stage height: " + _stageHeight);
			trace("full screen width: " + stage.fullScreenWidth);
			trace("full screen height: " + stage.fullScreenHeight);
			trace("viewport width: " + _viewport.width);
			trace("viewport height: " + _viewport.height);
			trace("scaleFactor: " + _scaleFactor);
			trace("Capabilities.os: " + Capabilities.os);
			trace("Capabilities.isDebugger: " + Capabilities.isDebugger);
			trace("isWeb: " + _isWeb);
			trace("isDesktop: " + AppUtils.isDesktop());
			trace("isIOS: " + AppUtils.isIOS());
			trace("isAndroid: " + AppUtils.isAndroid());
		}
	}
}