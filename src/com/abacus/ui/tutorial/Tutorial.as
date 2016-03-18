package com.abacus.ui.tutorial{
	
	import com.abacus.core.AbacusSprite;
	
	import flash.geom.Point;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	
	public class Tutorial extends AbacusSprite{

		protected var _gestureImage:Image;
		protected var _tutorialMode:String;
		protected var _startPoint:Point;
		protected var _endPoint:Point;
		protected var _gestureImageOrigScale:Number;
		protected var _repeatCount:int;
		protected var _currentRepeatIndex:int;
		protected var _mirrorGestureImage:Boolean;
		public var isActive:Boolean;
		
		public function Tutorial(gestureImage:Image, tutorialMode:String, startPoint:Point, endPoint:Point, repeatCount:int = -1, 
								 tweenTime:Number = 2, mirrorGestureImage:Boolean = false){
			_gestureImage = gestureImage;
			_tutorialMode = tutorialMode;
			_startPoint = startPoint;
			_repeatCount = repeatCount;
			_endPoint = endPoint;
			_mirrorGestureImage = mirrorGestureImage;
			initData();
			initAssets();
		}
		
		protected function initData():void{
			isActive = false;
			_currentRepeatIndex = 0;
			_gestureImageOrigScale = _gestureImage.scaleX;
			_gestureImage.x = _startPoint.x;
			_gestureImage.y = _startPoint.y;
		}

		protected function initAssets():void{
			this.touchable = false;
			addChild(_gestureImage);
			_gestureImage.alpha = 0;
			if(_mirrorGestureImage) _gestureImage.scaleX = -_gestureImage.scaleX
		}
		
		public function animate():void{
			isActive = true;
			switch(_tutorialMode){
				case TutorialMode.TOUCH:
					animateTouch();
					break;
				case TutorialMode.SWIPE:
					animateSwipe();
					break;
				default:
					trace("Error: Tutorial Mode not found");
					break;
			}
			_currentRepeatIndex++;
		}
		
		protected function animateTouch():void{
			var origScale:Number = _gestureImage.scaleX;
			var scaleDown:Number = _gestureImage.scaleX * 0.8;
			_gestureImage.alpha = 1;
			Starling.juggler.tween(_gestureImage, 2, {x:_endPoint.x, y:_endPoint.y, transition:Transitions.EASE_OUT, onComplete:pressDown});
			function pressDown():void{Starling.juggler.tween(_gestureImage, 0.1, {scaleX:scaleDown, scaleY:scaleDown, onComplete:liftUp})}
			function liftUp():void{Starling.juggler.tween(_gestureImage, 0.1, {scaleX:origScale, scaleY:origScale, onComplete:resetTouch})}
			function resetTouch():void{
				_gestureImage.x = _startPoint.x;
				_gestureImage.y = _startPoint.y;
				if(_repeatCount == -1){
					animate();
				} else {
					_currentRepeatIndex < _repeatCount ? animate() : complete();
				}
			}	
		}
		
		protected function animateSwipe():void{
			var origScale:Number = _gestureImage.scaleX;
			var scaleDown:Number = _gestureImage.scaleX * 0.8;
			_gestureImage.alpha = 1;
			Starling.juggler.tween(_gestureImage, 0.1, {scaleX:scaleDown, scaleY:scaleDown, onComplete:drag});
			function drag():void{Starling.juggler.tween(_gestureImage, 2, {x:_endPoint.x, y:_endPoint.y, transition:Transitions.EASE_OUT, onComplete:liftUp})};
			function liftUp():void{Starling.juggler.tween(_gestureImage, 0.1, {scaleX:origScale, scaleY:origScale, onComplete:resetTouch})}
			function resetTouch():void{
				_gestureImage.x = _startPoint.x;
				_gestureImage.y = _startPoint.y;
				_gestureImage.scaleX = _gestureImage.scaleY = _gestureImageOrigScale;
				if(_repeatCount == -1){
					animate();
				} else {
					_currentRepeatIndex < _repeatCount ? animate() : complete();
				}
			}	
		}
		
		public function complete(callback:Function = null):void{
			isActive = false;
			_gestureImage.x = _startPoint.x;
			_gestureImage.y = _startPoint.y;
			_gestureImage.scaleX = _gestureImage.scaleY = _gestureImageOrigScale;
			_gestureImage.alpha = 0;
			Starling.juggler.removeTweens(_gestureImage);
			if(callback) callback();
			dispatchEventWith(TutorialEvent.COMPLETE, true);
		}
		
		public function set startPoint(value:Point):void{
			_startPoint = value;
			_gestureImage.x = _startPoint.x;
			_gestureImage.y = _startPoint.y;
		}
		
		public function set endPoint(value:Point):void{
			_endPoint = value;
		}
		
		override public function dispose():void{
			super.dispose();
			complete();
		}
	}
}