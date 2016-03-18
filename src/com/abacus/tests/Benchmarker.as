package com.abacus.tests{
	
	import com.abacus.core.AbacusSprite;
	import com.abacus.events.EventManager;
	import com.abacus.ui.backgrounder.Backgrounder;
	import com.abacus.ui.backgrounder.VignetteMode;
	import com.abacus.utils.LayoutUtils;
	
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * This will 'print' 50 quads at a time then measure the average frame rate
	 * for 5 frames.  When average frame rate drops below 55fps, then it will 
	 * kick off a complete event
	 */
	
	public class Benchmarker extends AbacusSprite{
		
		private const NUM_QUADS_PER_CYCLE:int = 50;
		private const DELAY_INTERVAL_IN_FRAMES:int = 5;
		private const QUAD_WIDTH:int = 10;
		private const QUAD_HEIGHT:int = 10;
		private const DEFAULT_FONT_NAME:String = "Verdana";
		
		private var _screen:Backgrounder;
		private var _messageTextField:TextField;
		private var _imageContainer:Sprite;
		private var _testTexture:Texture;
		
		private var _numRegressions:int;
		private var _message:String;
		private var _regressionArray:Array;
		private var _lowestFrameRateThresh:int;
		private var _currentRegressionCount:int;
		private var _quadPadding:int;
		private var _quadWidth:int;
		private var _quadHeight:int;
		private var _maxTexturesWidth:int;
		private var _maxTexturesHeight:int;
		private var _startX:int;
		private var _startY:int;
		private var _currentTextureCount:int;
		private var _currentWidthIteration:int;
		private var _currentHeightIteration:int;
		private var _numFramesPassed:int;
		private var _timePassed:Number;
		private var _startTime:Number;
		private var _endTime:Number;
		
		public function Benchmarker(numRegressions:int = 3, message:String = "Calibrating..."){
			super(false);
			_numRegressions = numRegressions;
			_message = message;
			_eventManager.addEventListener(this, Event.ADDED_TO_STAGE, onAddedToStage);
		}

		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			initData();
			initAssets();
		}
		
		protected function initData():void{
			_eventManager = new EventManager();
			_regressionArray = [];
			_lowestFrameRateThresh = Starling.current.nativeStage.frameRate - 5;
			_quadPadding = 1;
			_quadWidth = QUAD_WIDTH + _quadPadding;
			_quadHeight = QUAD_HEIGHT + _quadPadding;
			_maxTexturesWidth = Math.floor(LayoutUtils.appWidth()/_quadWidth);
			_maxTexturesHeight = Math.floor(LayoutUtils.appHeight()/_quadHeight);
			_startX = (LayoutUtils.appWidth() - (_maxTexturesWidth * _quadWidth))/2;
			_startY = (LayoutUtils.appHeight() - (_maxTexturesHeight * _quadHeight))/2;
			_currentWidthIteration = 0;
			_currentHeightIteration = 0;
			_numFramesPassed = 0;
			_timePassed = 0;
			_currentRegressionCount = 0;
		}

		protected function initAssets():void{
			this.touchable = false;
			
			_imageContainer = new Sprite();
			addChild(_imageContainer);
			
			_screen = new Backgrounder(0x1e1e27, VignetteMode.NONE);
			_screen.alpha = 0.85;
			_screen.visible = false;
			addChild(_screen);
			
			_messageTextField = new TextField(250, 65, _message, "Verdana", 28, 0xFFFFFF);
			_messageTextField.visible = false;
			addChild(_messageTextField);
			LayoutUtils.layout(_messageTextField, LayoutUtils.ALIGN_CENTER);
		}
		
		public function test():void{
			_eventManager.addEventListener(this, EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			_screen.visible = true;
			_messageTextField.visible = true;
			_startTime = getTimer();
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void{
			_numFramesPassed++;
			_timePassed += e.passedTime;
			
			if(_numFramesPassed == DELAY_INTERVAL_IN_FRAMES){
				var frameRateAvg:Number = _numFramesPassed/_timePassed;
				if(frameRateAvg > _lowestFrameRateThresh || _currentTextureCount < 150){
					createTextureBlock();
					_numFramesPassed = 0;
					_timePassed = 0;
				} else {
					_currentRegressionCount++;
					if(_currentRegressionCount < _numRegressions){
						_regressionArray.push(_currentTextureCount);
						_imageContainer.removeChildren();
						resetData();
					} else {
						endTest();
					}
				}
			}	
		}
		
		private function resetData():void{
			_currentTextureCount = 0;
			_numFramesPassed = 0;
			_timePassed = 0;
			_currentWidthIteration = 0;
			_currentHeightIteration = 0;
		}
		
		private function createTextureBlock():void{
			OuterLoop: for (var i:int = _currentHeightIteration; i < _maxTexturesHeight; i++){
				for (var j:int = _currentWidthIteration; j < _maxTexturesWidth; j++){
					var quad:Quad = new Quad(QUAD_WIDTH, QUAD_HEIGHT);
					quad.x = _startX + j * _quadWidth;
					quad.y = _startY + i * _quadHeight;
					_imageContainer.addChild(quad);
					
					_currentWidthIteration++;
					_currentTextureCount++;
					if(_currentTextureCount % NUM_QUADS_PER_CYCLE == 0)
						break OuterLoop;
				}
				
				_currentWidthIteration = 0;
				_currentHeightIteration++;
				if(_currentHeightIteration == _maxTexturesHeight)
					_currentHeightIteration = 0;
			}
		}
		
		private function endTest():void{
			_eventManager.removeEventListener(this, EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			_screen.visible = false;
			_messageTextField.visible = false;
			_endTime = getTimer();
			
			var len:int = _regressionArray.length;
			var total:int;
			var avgNumObjects:int;
			for (var i:int = 0; i < len; i++){
				total += _regressionArray[i]
			}
			avgNumObjects = total/len;
			if(Capabilities.isDebugger) traceBenchmarkProps(avgNumObjects);
			
			var benchmarkerVO:BenchmarkerVO = new BenchmarkerVO();
			benchmarkerVO.avgTotalDisplayObjects = avgNumObjects;
			dispatchEventWith(BenchmarkerEvent.COMPLETE, true, benchmarkerVO);
		}
		
		private function traceBenchmarkProps(avgNumObjects:int):void{
			trace("** Benchmarker Report **");
			trace("Average num display objects rendered: " + avgNumObjects);
			trace("Test duration: " + Number((_endTime-_startTime)/1000).toFixed(2) + " seconds");
		}
		
		public function get messageTextField():TextField{
			return _messageTextField;
		}

	}
}