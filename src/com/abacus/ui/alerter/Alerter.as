package com.abacus.ui.alerter{
	
	import com.abacus.core.AbacusSprite;
	import com.abacus.core.vo.AbacusAlertVO;
	import com.abacus.events.EventManager;
	import com.abacus.utils.DisplayObjectUtils;
	import com.abacus.utils.LayoutUtils;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	
	public class Alerter extends AbacusSprite{
		
		protected var _overlay:Sprite;
		protected var _messageBackground:Sprite;
		protected var _messageText:Label;
		protected var _button:Button;
		
		protected var _abacusAlertVO:AbacusAlertVO;
		protected var _messagePadding:int;
		protected var _buttonPadding:int;
		protected var _overlayAlpha:Number;
		
		public function Alerter(){
			super();
			_eventManager.addEventListener(this, Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			initData();
			initAssets();
			initListeners();
		}
		
		protected function initData():void{
			_eventManager = new EventManager();
			_messagePadding = 10;
			_buttonPadding = 10;
			_overlayAlpha = 0.5;
		}
		
		protected function initAssets():void{
			var overlayQuad:Quad = new Quad(LayoutUtils.appWidth(), LayoutUtils.appHeight(), 0x000000);
			_overlay = new Sprite();
			_overlay.visible = false;
			_overlay.addChild(overlayQuad);
			_overlay.scaleX = _overlay.scaleY = Starling.contentScaleFactor;
			_overlay.alpha = _overlayAlpha;
			addChild(_overlay);
			_overlay.touchable = false;
			
			_messageBackground = DisplayObjectUtils.createRoundedRectangle(LayoutUtils.appWidth()/2, LayoutUtils.appHeight()/2, 0x333333, 20, 20, false);
			_messageBackground.visible = false;
			addChild(_messageBackground);
			LayoutUtils.layout(_messageBackground, LayoutUtils.ALIGN_CENTER);
			_messageBackground.touchable = false;
			
			_messageText = new Label();
			_messageText.text = "Alert Text";
			_messageText.visible = false;
			addChild(_messageText);
			LayoutUtils.layout(_messageText, LayoutUtils.ALIGN_CENTER, _messagePadding, _messageBackground);
			_messageText.x += _messageBackground.x;
			_messageText.y += _messageBackground.y;
			_messageText.touchable = false;
			
			_button = new Button();
			_button.label = "alert";
			_button.visible = false;
			addChild(_button);
			_button.filter = BlurFilter.createDropShadow(3, 0.785, 0x0, 0.35, 0, 0.5);
			
			LayoutUtils.layout(_button, LayoutUtils.ALIGN_BOTTOM_CENTER, _buttonPadding, _messageBackground);
			_button.x += _messageBackground.x;
			_button.y += _messageBackground.y;
		}
		
		private function initListeners():void{
			_eventManager.addEventListener(_button, Event.TRIGGERED, onButtonPressed);
		}
		
		private function onButtonPressed(e:Event):void{
			if(_abacusAlertVO.callback != null) _abacusAlertVO.callback();
			hide();
		}
		
		public function show(abacusAlertVO:AbacusAlertVO):void{
			_abacusAlertVO = abacusAlertVO;
			switch(_abacusAlertVO.alertType){
				case AlertType.MESSAGE:
					showMessage();
					break;
				case AlertType.BUTTON:
					showButton();
					break;
			}
		}
		
		protected function showMessage():void{
			_overlay.visible = true;
			_messageBackground.visible = true;
			_messageText.visible = true;

			_messageText.text = _abacusAlertVO.message;
			LayoutUtils.layout(_messageText, LayoutUtils.ALIGN_CENTER, _messagePadding, _messageBackground);
			_messageText.x += _messageBackground.x;
			_messageText.y += _messageBackground.y;
		}
		
		protected function showButton():void{
			_overlay.visible = true;
			_messageBackground.visible = false;
			_messageText.visible = false;
			
			_button.label = _abacusAlertVO.buttonText;
			_button.visible = true;
			LayoutUtils.layout(_button, LayoutUtils.ALIGN_CENTER);
		}
		
		protected function hide():void{
			_overlay.visible = false;
			_messageBackground.visible = false;
			_messageText.visible = false;
			_button.visible = false;
		}
	}
}