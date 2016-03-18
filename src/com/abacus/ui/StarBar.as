package com.abacus.ui{
	
	import com.abacus.utils.DisplayObjectUtils;
	
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class StarBar extends Sprite{
		
		private var _numStars:int;
		private var _padding:int;
		
		private var _starContainer:Sprite;
		private var _baseContainer:Sprite;
		private var _fillContainer:Sprite;
		private var _baseTexture:Texture;
		private var _fillTexture:Texture;
		
		public function StarBar(numStars:int = 3, padding:int = 5, baseStarTexture:Texture = null, fillStarTexture:Texture = null){
			super();
			
			_numStars = numStars;
			_padding = padding;
			
			if(baseStarTexture){
				_baseTexture = baseStarTexture;
			} else {
				var defaultBaseSprite:Sprite = DisplayObjectUtils.createCircle(20, 0x333333, false);
				_baseTexture = DisplayObjectUtils.getStarlingTextureFromStarlingSprite(defaultBaseSprite);
			}
			if(fillStarTexture){
				_fillTexture = fillStarTexture;
			} else {
				var defaultFillSprite:Sprite = DisplayObjectUtils.createCircle(20, 0xFFFF33, false);
				_fillTexture = DisplayObjectUtils.getStarlingTextureFromStarlingSprite(defaultFillSprite);
			}
			
			initAssets();
		}
		
		protected function initAssets():void{
			_baseContainer = new Sprite();
			addChild(_baseContainer);
			
			_fillContainer = new Sprite();
			addChild(_fillContainer);
			
			for (var i:int = 0; i < _numStars; i++){
				var baseStar:Sprite = new Sprite();
				var fillStar:Sprite = new Sprite();
				
				baseStar.addChild(new Image(_baseTexture));
				fillStar.addChild(new Image(_fillTexture));
				
				baseStar.x += baseStar.width * i + _padding * i;
				fillStar.x += fillStar.width * i + _padding * i;
				
				_baseContainer.addChild(baseStar);
				_fillContainer.addChild(fillStar);
			}
			
			_fillContainer.clipRect = new Rectangle(-_fillContainer.width+_padding, 0, _fillContainer.width+_padding, _fillContainer.height);
		}
		
		public function showResults(percent:Number):void{
			var tweenTime:Number = 1.5;
			var starsWidth:Number = _baseContainer.getChildAt(0).width * _numStars;
			var paddingWidth:Number = _numStars-1 * _padding;
			var toX:int = (percent/100 * starsWidth) + (Math.floor(percent/100 * _numStars) * _padding) - _fillContainer.clipRect.width;
			
			Starling.juggler.tween(_fillContainer.clipRect, tweenTime, {x:toX});
		}
	}
}