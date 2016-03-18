package com.abacus.ui.loader{
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.core.Starling;
	
	public class AppLoader extends Sprite{
		
		private const DEFAULT_FONT_NAME:String = "slimJoe";
		private const LOADER_BAR_HEIGHT_DEFAULT:Number = 20;
		private const LOADER_BAR_X_PADDING_DEFAULT:Number = 20;
		private const LOADER_BAR_Y_PADDING_DEFAULT:Number = 40;
		
		private var _viewport:Rectangle;
		private var _scaleFactor:int;
		private var _fontName:String;
		private var _fontSize:Number;
		private var _logoBitmap:Bitmap;
		
		private var _loaderContainer:Sprite;
		private var _text:TextField;
		private var _outline:Shape;
		private var _fillBar:Shape;
		private var _loaderBarHeight:Number
		private var _loaderPaddingX:Number;
		private var _loaderPaddingY:Number;
		
		public function AppLoader(viewport:Rectangle, scaleFactor:int, fontName:String = null, fontSize:Number = 28, logoBitmap:Bitmap = null){
			_viewport = viewport;
			_scaleFactor = scaleFactor;
			fontName ? _fontName = fontName : _fontName = DEFAULT_FONT_NAME;
			_fontSize = fontSize;
			_logoBitmap = logoBitmap;
			
			initData();
			initAssets();
		}
		
		private function initData():void{
			_loaderBarHeight = LOADER_BAR_HEIGHT_DEFAULT;
			_loaderPaddingX = LOADER_BAR_X_PADDING_DEFAULT;
			_loaderPaddingY = LOADER_BAR_Y_PADDING_DEFAULT;
		}
		
		protected function initAssets():void{
			_loaderContainer = new Sprite();
			addChild(_loaderContainer);
			
			if(_logoBitmap == null){
				var textFormat:TextFormat = new TextFormat();
				textFormat.font = _fontName;
				textFormat.size = _fontSize * _scaleFactor;
				textFormat.color = 0xFFFFFF;
				textFormat.align = TextFormatAlign.CENTER;
				
				_text = new TextField();
				_text.defaultTextFormat = textFormat;
				_text.embedFonts = true;
				_text.width = _viewport.width/2;
				_text.text = "Loading...";
				_text.selectable = false;
				addChild(_text);
				
				_text.x = _viewport.width/2 - _text.width/2;
				_text.y = _viewport.height/2 - _text.height/2;
			} else {
				_logoBitmap.x = _viewport.width/2 - _logoBitmap.width/2;
				_logoBitmap.y = _viewport.height/2 - _logoBitmap.height/2;
				addChild(_logoBitmap);
			}
			
			_outline = new Shape();
			_outline.graphics.lineStyle(2, 0xFFFFFF);
			_outline.graphics.drawRect(0, 0, _viewport.width-(_loaderPaddingX*2), _loaderBarHeight);
			_loaderContainer.addChild(_outline);
			
			_fillBar = new Shape();
			_fillBar.graphics.beginFill(0xFFFFFF);
			_fillBar.graphics.drawRect(0, 0, _viewport.width-(_loaderPaddingX*2), _loaderBarHeight);
			_fillBar.scaleX = 0;
			_loaderContainer.addChild(_fillBar);
			
			_loaderContainer.x = (_viewport.width - _loaderContainer.width)/2;
			_loaderContainer.y = _viewport.height - _loaderPaddingY;
		}
		
		public function updateProgress(progress:Number):void{
			_fillBar.scaleX = progress;
		}
	}
}