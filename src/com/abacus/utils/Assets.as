package com.abacus.utils
{
	import com.abacus.core.AbacusSprite;
	import com.abacus.events.AbacusButtonEvent;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.utils.AssetManager;

	public class Assets{
		
		public static const MANAGER:AssetManager = new AssetManager();
		
		public static function getScaledImage(textureName:String):Image{
			var image:Image = new Image(MANAGER.getTexture(textureName));
			image.scaleX = image.scaleY = Starling.contentScaleFactor/4;
			return image;
		}
		
		public static function getAbacusSprite(textureName:String, 
											   isMultiResolution:Boolean = false, 
											   align:String = null, 
											   padding:int = 0, 
											   alignReference:DisplayObjectContainer = null, 
											   center:Boolean = false):AbacusSprite{
			
			var abacusSprite:AbacusSprite = new AbacusSprite(isMultiResolution);
			abacusSprite.addChild(getScaledImage(textureName));
			if(center) abacusSprite.alignPivot();
			if(align) LayoutUtils.layout(abacusSprite, align, padding, alignReference);
			return abacusSprite;
		}
		
		public static function getAbacusButton(upTextureName:String,
										 buttonText:String,
										 fontSize:int = 14,
										 fontName:String = "Verdana",
										 fontColor:uint = 0xFFFFFF,
										 eventType:String = AbacusButtonEvent.BUTTON_PRESSED,
										 sound:String = "buttonClick",
										 isMultiResolution:Boolean = true,
										 downTextureName:String = null,
										 overTextureName:String = null,
										 disabledTextureName:String = null):AbacusSprite{
			
			var abacusSprite:AbacusSprite = new AbacusSprite(isMultiResolution);
			var button:Button = new Button(MANAGER.getTexture(upTextureName), "text", MANAGER.getTexture(downTextureName), 
				MANAGER.getTexture(overTextureName), MANAGER.getTexture(disabledTextureName));
			button.text = buttonText;
			button.fontSize = fontSize * 4;
			button.fontName = fontName;
			button.fontColor = fontColor;
			button.scaleX = button.scaleY = Starling.contentScaleFactor/4;
			abacusSprite.addChild(button);
			abacusSprite.eventManager.addEventListener(button, Event.TRIGGERED, onB);
			function onB():void {
				Assets.MANAGER.playSound(sound);
				abacusSprite.dispatchEventWith(AbacusButtonEvent.UPDATE, true, {type:eventType})
			};
			return abacusSprite;
		}
	}
}