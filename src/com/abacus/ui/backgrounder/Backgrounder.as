package com.abacus.ui.backgrounder{
	
	import com.abacus.core.AbacusSprite;
	import com.abacus.utils.LayoutUtils;
	import com.abacus.utils.MathUtils;
	
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Backgrounder extends AbacusSprite{
		
		public static const DEFAULT_BG_COLOR:int = 0xfffef3;
		private const DEFAULT_VIGNETTE_ALPHA:Number = 0.35;
		private const DEFAULT_VIGNETTE_SPOTLIGHT_DISTANCE:Number = 1.05;
		private const DEFAULT_VIGNETTE_SPOTLIGHT_FOCAL_POINT:Number = 0;

		private var _bgColor:int;
		private var _flatten:Boolean;
		private var _vignetteMode:String;
		private var _vignetteAlpha:Number;
		private var _vignetteSpotlightDistance:Number;
		private var _vignetteSpotlightFocalPoint:Number;
		
		private var _bgContainerSprite:Sprite;
		private var _bgSprite:Sprite;
		private var _vignette:Sprite;
		
		public function Backgrounder(hexColor:int = DEFAULT_BG_COLOR, vignetteMode:String = VignetteMode.STANDARD, flatten:Boolean = true){
			_bgColor = hexColor;
			_vignetteMode = vignetteMode;
			_flatten = flatten;
			
			initData();
			initAssets();
		}

		private function initData():void{

			switch(_vignetteMode){
				case VignetteMode.SUBTLE:
					_vignetteAlpha = 0.25;
					_vignetteSpotlightDistance = 1.5;
					_vignetteSpotlightFocalPoint = 0;
					break;
				case VignetteMode.STANDARD:
					_vignetteAlpha = DEFAULT_VIGNETTE_ALPHA;
					_vignetteSpotlightDistance = DEFAULT_VIGNETTE_SPOTLIGHT_DISTANCE;
					_vignetteSpotlightFocalPoint = DEFAULT_VIGNETTE_SPOTLIGHT_FOCAL_POINT;
					break;
				case VignetteMode.THEATER:
					_vignetteAlpha = 0.75;
					_vignetteSpotlightDistance = 1.35;
					_vignetteSpotlightFocalPoint = 0.15;
					break;
				case VignetteMode.DARK:
					_vignetteAlpha = 0.8;
					_vignetteSpotlightDistance = 1.1;
					_vignetteSpotlightFocalPoint = 0.35;
					break;
				case VignetteMode.BRIGHT:
					_vignetteAlpha = 1;
					_vignetteSpotlightDistance = 1;
					_vignetteSpotlightFocalPoint = 0;
					break;
			}
			
		}
		
		private function initAssets():void{
			_bgContainerSprite = new Sprite();

			_bgSprite = createBgSprite();
			_bgContainerSprite.addChild(_bgSprite);
			
			if(_vignetteMode != VignetteMode.NONE){
				_vignette = createVignette();
				_bgContainerSprite.addChild(_vignette);
			}
			
			if(_flatten) _bgContainerSprite.flatten();
			addChild(_bgContainerSprite);
		}
		
		private function createBgSprite():Sprite{
			var bgSprite:Sprite;
			var bgQuad:Quad;

			if(isNaN(_bgColor)) _bgColor = DEFAULT_BG_COLOR;
			bgQuad = new Quad(LayoutUtils.appWidth(), LayoutUtils.appHeight(), _bgColor);
			bgSprite = new Sprite();
			bgSprite.scaleX = bgSprite.scaleY = Starling.contentScaleFactor;
			bgSprite.addChild(bgQuad);
			
			return bgSprite;
		}
		
		private function createVignette():Sprite{
			var vignetteSprite:Sprite = new Sprite();
			var vignetteShape:Shape = new Shape();
			var bgBitmapData:BitmapData;
			var texture:Texture;
			var image:Image;
			var fillType:String = GradientType.RADIAL;
			var shadeColor:int = _vignetteMode == VignetteMode.BRIGHT ? 0xFFFFFF : 0x000000;
			var colors:Array = [DEFAULT_BG_COLOR, shadeColor];
			var alphas:Array = [0, _vignetteAlpha];
			var ratios:Array = [0, 255];
			var matr:Matrix = new Matrix();
			var spreadMethod:String = SpreadMethod.PAD;
			var boxDimensions:int = (LayoutUtils.appHeight() > LayoutUtils.appWidth() ? LayoutUtils.appHeight() : LayoutUtils.appWidth()) * _vignetteSpotlightDistance;
			
			matr.createGradientBox(boxDimensions, boxDimensions, 0, (LayoutUtils.appWidth()-boxDimensions)/2, (LayoutUtils.appHeight()-boxDimensions)/2);

			vignetteShape.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod, "rgb", _vignetteSpotlightFocalPoint);
			vignetteShape.graphics.drawRect(0, 0, LayoutUtils.appWidth(), LayoutUtils.appHeight());
			
			bgBitmapData = new BitmapData(vignetteShape.width, vignetteShape.height, true, 0x0000000);
			bgBitmapData.draw(vignetteShape);
			
			texture = Texture.fromBitmapData(bgBitmapData, true, false, Starling.contentScaleFactor);
			_textureDisposalQueue.push(texture);
			
			bgBitmapData.dispose();
			bgBitmapData = null;
			
			image = new Image(texture);
			vignetteSprite.addChild(image);
			vignetteSprite.scaleX = vignetteSprite.scaleY = Starling.contentScaleFactor;
			
			return vignetteSprite;
		}
		
		public function refresh():void{
			_bgContainerSprite.removeChild(_bgSprite);
			_bgContainerSprite.removeChild(_vignette);
			_bgSprite = createBgSprite();
			_vignette = createVignette();
			_bgContainerSprite.addChild(_bgSprite);
			_bgContainerSprite.addChild(_vignette);
			_bgContainerSprite.flatten();
		}
		
		public function set vignetteSpotlightFocalPoint(value:Number):void{
			_vignetteSpotlightFocalPoint = value;
		}
		
		public function set vignetteSpotlightDistance(value:Number):void{
			_vignetteSpotlightDistance = MathUtils.constrainNumberInRange(value,0.1,2);
		}
		
		public function set vignetteAlpha(value:Number):void{
			_vignetteAlpha = value;
		}
		
		public function get bgColor():int{
			return _bgColor;
		}
		
		public function set bgColor(value:int):void{
			_bgColor = value;
		}
		
	}
}