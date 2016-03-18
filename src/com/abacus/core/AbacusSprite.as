package com.abacus.core{
	
	import com.abacus.events.EventManager;
	import com.abacus.utils.ClassUtils;
	import com.abacus.utils.LayoutUtils;
	
	import flash.utils.getDefinitionByName;
	
	import avmplus.getQualifiedClassName;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	
	public class AbacusSprite extends Sprite{
		
		protected var _eventManager:EventManager;
		protected var _textureDisposalQueue:Vector.<Texture>;
		protected var _isScaledForMultiResolution:Boolean;
		
		public function AbacusSprite(scaleForMultiResolution:Boolean = false){
			super();
			_eventManager = new EventManager();
			_textureDisposalQueue = new Vector.<Texture>;
			_isScaledForMultiResolution = scaleForMultiResolution;
			_eventManager.addEventListener(this, Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(e:Event):void{
			_eventManager.removeEventListener(this, Event.ADDED_TO_STAGE, onAddedToStage);
			var isScaledInParentHeirarchy:Boolean = parentIsAbacusSprite();
			if(isScaledInParentHeirarchy) _isScaledForMultiResolution = true;
			if(_isScaledForMultiResolution && !isScaledInParentHeirarchy) scale();
		}
		
		private function parentIsAbacusSprite():Boolean{
			var val:Boolean = false;
			if(this.parent) testParent(this.parent);
			function testParent(displayObject:DisplayObject):void{
				if(displayObject is AbacusSprite && !(displayObject is AbacusView) 
					&& AbacusSprite(displayObject).isScaledForMultiResolution)
					val = true;
				else 
					if(displayObject.parent) testParent(displayObject.parent);
			}
			return val;
		}

		private function scale():void{
			var scale:Number = LayoutUtils.multiResolutionScaleFactor();
			this.scaleX = scale;
			this.scaleY = scale;
		}
		
		protected function textureDisposalQueueConcat(textures:Vector.<Texture>):void{
			while(textures.length > 0){
				_textureDisposalQueue.push(textures.shift());
			}
		}
		
		override public function dispose():void{
			_eventManager.removeAllListeners();
			var len:int = this.numChildren-1;
			for (var i:int = len; i >= 0; i--){
				var dispObj:DisplayObject = this.getChildAt(i) as DisplayObject;
				var dispObjClass:Class = Class(getDefinitionByName(getQualifiedClassName(dispObj)));
				var extendsAbacusSprite:Boolean = ClassUtils.extendsClass(dispObjClass, AbacusSprite);
				if(dispObj is AbacusSprite || extendsAbacusSprite){
					AbacusSprite(dispObj).dispose();
				}
				this.removeChildAt(i);
			}
			
			for each(var texture:Texture in _textureDisposalQueue){
				texture.dispose();
				if(texture is SubTexture){
					(texture as SubTexture).parent.dispose();
					(texture as SubTexture).parent.base.dispose();
				}
			}
			super.dispose();
		}
		
		public function get isScaledForMultiResolution():Boolean{
			return _isScaledForMultiResolution;
		}
		
		public function get eventManager():EventManager{
			return _eventManager;
		}
	}
}