package com.abacus.ui.toggle{
	
	import com.abacus.core.AbacusSprite;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class AbacusToggleButton extends AbacusSprite{
		
		private const DEFAULT_STATE:uint = 0;
		
		private var _toggleBackgroundTexture:Texture;
		private var _toggleButtonTexture:Texture;
		
		private var _toggleBackgroundImage:Image;
		private var _toggleButton:Sprite;
		private var _toggleButtonImage:Image;
		
		private var _toggleTextField:TextField;
		private var _toggleLabelTextField:TextField;
		private var _toggleLabelText:String;
		
		private var _isOn:Boolean;
		
		public function AbacusToggleButton(toggleBackgroundTexture:Texture, toggleButtonTexture:Texture, labelText:String = "toggle label", scaleForMultiResolution:Boolean=false){
			super(scaleForMultiResolution);
			_toggleBackgroundTexture = toggleBackgroundTexture;
			_toggleButtonTexture = toggleButtonTexture;
			_toggleLabelText = labelText;
			
			initData();
			initAssets();
			initListeners();
		}
		
		private function initData():void{
			_isOn = DEFAULT_STATE;
		}
		
		private function initAssets():void{
			_toggleBackgroundImage = new Image(_toggleBackgroundTexture);
			addChild(_toggleBackgroundImage);
			
			_toggleButton = new Sprite();
			_toggleButtonImage = new Image(_toggleButtonTexture);
			_toggleButton.addChild(_toggleButtonImage);
		
			_toggleTextField = new TextField(_toggleButtonImage.width, _toggleButtonImage.height, "On");
			_toggleButton.addChild(_toggleTextField);
			addChild(_toggleButton);
			
			_toggleLabelTextField = new TextField(_toggleBackgroundImage.width, 16, _toggleLabelText, "Verdana", 12);
			addChild(_toggleLabelTextField);
			_toggleLabelTextField.y = _toggleBackgroundImage.height;
		}
		
		private function initListeners():void{
			_eventManager.addEventListener(_toggleButton, TouchEvent.TOUCH, onToggleTouch);
		}
		
		private function onToggleTouch(e:TouchEvent):void{
			var touchBegan:Touch = e.getTouch(_toggleButton, TouchPhase.BEGAN);
			if(touchBegan){
				_isOn = !_isOn;
				_isOn ? _toggleTextField.text = "On" : _toggleTextField.text = "Off";
				_toggleButton.x = int(_isOn) * _toggleButton.width;
				dispatchEventWith(Event.CHANGE, true);
			}
		}
	}
}