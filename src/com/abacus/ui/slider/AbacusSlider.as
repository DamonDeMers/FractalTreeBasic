package com.abacus.ui.slider{
	
	import com.abacus.core.AbacusSprite;
	import com.abacus.utils.LayoutUtils;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class AbacusSlider extends AbacusSprite{
		
		private var _labelTextField:TextField;
		private var _positionTextField:TextField;
		
		private var _handleImage:Image;
		private var _guideImage:Image;
		
		private var _handleTexture:Texture;
		private var _guideTexture:Texture;
		
		private var _touchBeganX:Number;
		private var _value:Number;
		
		private var _labelText:String;
		private var _lowValue:Number;
		private var _highValue:Number;
		private var _startValue:Number;
		
		public function AbacusSlider(handleTexture:Texture, guideTexture:Texture, startValue:Number, lowValue:Number = 1, highValue:Number = 10, 
									 labelText:String = "slider label", scaleForMultiResolution:Boolean=false){
			super(scaleForMultiResolution);
			_handleTexture = handleTexture;
			_guideTexture = guideTexture;
			_labelText = labelText;
			_startValue = startValue;
			_lowValue = lowValue;
			_highValue = highValue;
			
			initData();
			initAssets();
			initListeners();
		}

		private function initData():void{
			_value = _startValue/_highValue;
		}
		
		private function initAssets():void{
			_guideImage = new Image(_guideTexture);
			addChild(_guideImage);
			_guideImage.alignPivot(HAlign.LEFT, VAlign.CENTER);
			_guideImage.scaleX = _guideImage.scaleY = Starling.contentScaleFactor/4;
			_guideImage.touchable = false;
			
			_handleImage = new Image(_handleTexture);
			addChild(_handleImage);
			_handleImage.alignPivot();
			_handleImage.scaleX = _handleImage.scaleY = Starling.contentScaleFactor/4;
			_handleImage.x = (_startValue/_highValue) * _guideImage.width;
			
			_positionTextField = new TextField(_guideImage.width, _handleImage.height, _labelText + ": " +(_value*_highValue).toFixed(0).toString(), "Verdana", 14, 0xFFFFFF);
			addChild(_positionTextField);
			_positionTextField.y = _handleImage.height/4;
			_positionTextField.touchable = false;
			
			/*
			_labelTextField = new TextField(_guideImage.width, _handleImage.height, _labelText, "Verdana", 14, 0xFFFFFF);
			addChild(_labelTextField);
			_labelTextField.y = _positionTextField.y + _positionTextField.height/2;
			*/
		}
		
		private function initListeners():void{
			_eventManager.addEventListener(_handleImage, TouchEvent.TOUCH, onHandleTouch);
		}
		
		private function onHandleTouch(e:TouchEvent):void{
			var touchBegan:Touch = e.getTouch(_handleImage, TouchPhase.BEGAN);
			var touchMoved:Touch = e.getTouch(_handleImage, TouchPhase.MOVED);
			if(touchBegan){
				_touchBeganX = touchBegan.globalX;
			}
			if(touchMoved){
				if(_handleImage.x > 0 && _handleImage.x < _guideImage.width){
					var moveDelta:Number = touchMoved.globalX - _touchBeganX;
					var moveRatio:Number = _isScaledForMultiResolution ? 
						(moveDelta/_guideImage.width)/LayoutUtils.multiResolutionScaleFactor() : moveDelta/_guideImage.width;
					_value = _handleImage.x/_guideImage.width;
					var handleXPos:Number = moveRatio * _guideImage.width;
					if(_handleImage.x + handleXPos > 0 && _handleImage.x + handleXPos < _guideImage.width){
						_handleImage.x += handleXPos;
						_positionTextField.text = _labelText + ": " + int(Math.ceil(_value * _highValue)).toString();
						_touchBeganX = touchMoved.globalX;
						dispatchEventWith(Event.CHANGE, true);
					}
				} 
			}
		}
		
		public function get value():Number{
			return _value;
		}
		
	}
}