package com.abacus.ui{
	
	import com.abacus.core.AbacusSprite;
	import com.abacus.utils.LayoutUtils;
	import com.abacus.utils.MathUtils;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Color;
	
	public class ArrowBar extends AbacusSprite{
		
		protected var _scoreTextField:TextField;
		protected var _outline:Shape;
		protected var _fill:Shape;
		protected var _arrow:Shape;
		
		protected var _progress:Number;
		protected var _barWidth:int;
		protected var _barHeight:int;
		protected var _arrowWidth:int;
		protected var _arrowHeight:int;
		protected var _fontSize:int;
		protected var _fontName:String;

		
		/** Creates a new Starling instance. 
		 *  @param progress  					A number between 0 and 1 representing the progress score.  Progress will be labeled 
		 * 					 					0 - 10.  Ex. progress of 0.5 equals 5 on the arrow bar. 
		 * 
		 *  @param scaleForMultiResolution  	A Boolean representing if the ArrowBar should be scaled for multi-resolution development.
		 *
		 */
		public function ArrowBar(progress:Number, scaleForMultiResolution:Boolean=false){
			super(scaleForMultiResolution);
			_progress = progress;
			_progress = MathUtils.constrainNumberInRange(_progress, 0, 1);
			_eventManager.addEventListener(this, Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void{
			initData();
			initAssets();
		}
		
		protected function initData():void{
			_barWidth = LayoutUtils.appWidth() - 80;
			_barHeight = 15;
			_arrowWidth = 18;
			_arrowHeight = 12;
			_fontSize = 20;
			_fontName = "Nevis";
		}
		
		protected function initAssets():void{
			_fill = new Shape();
			_fill.graphics.beginFill(0xFFFFFF);
			_fill.graphics.drawRect(0, 0, _barWidth, _barHeight);
			_fill.graphics.endFill();
			addChild(_fill);
			
			_outline = new Shape();
			_outline.graphics.lineStyle(1, 0xFFFFFF);
			_outline.graphics.drawRect(0, 0, _barWidth, _barHeight);
			_outline.graphics.endFill();
			addChild(_outline);
			
			_arrow = new Shape();
			_arrow.graphics.beginFill(0xFFFFFF);
			_arrow.graphics.lineStyle(1,0xFFFFFF);
			_arrow.graphics.lineTo(_arrowWidth/2, -_arrowHeight);
			_arrow.graphics.lineTo(_arrowWidth, 0);
			_arrow.graphics.lineTo(0, 0);
			_arrow.graphics.endFill();
			addChild(_arrow);
			_arrow.alignPivot();
			_arrow.y = _barHeight + _arrowHeight/2 + 3;
			
			_scoreTextField = new TextField(_fontSize*2, _fontSize, "10", _fontName, _fontSize, 0xFFFFFF);
			addChild(_scoreTextField);
			_scoreTextField.y -= _fill.height - 4;
			_scoreTextField.alignPivot();
		}
		
		/**
		 * This function adds an additional arrow usually placed ahead of the existing arrow and may be used to
		 * show a forecast in user improvment, next level, etc. 
		 */
		public function forecastImprovement(progress:Number, tweenTime:Number = 2):void{
			var forecastColor:int = 0x28ea6e;
			progress = MathUtils.constrainNumberInRange(progress, 0, 1);
			
			var fill:Shape = new Shape();
			fill.graphics.beginFill(forecastColor);
			fill.graphics.drawRect(0, 0, _barWidth, _barHeight);
			fill.graphics.endFill();
			addChild(fill);
			this.setChildIndex(fill, 0);
			
			var arrow:Shape = new Shape();
			arrow.graphics.lineStyle(1,forecastColor);
			arrow.graphics.beginFill(forecastColor);
			arrow.graphics.lineTo(_arrowWidth/2, -_arrowHeight);
			arrow.graphics.lineTo(_arrowWidth, 0);
			arrow.graphics.lineTo(0, 0);
			arrow.graphics.endFill();
			addChild(arrow);
			arrow.alignPivot();
			arrow.y = _barHeight + _arrowHeight/2 + 3;
			
			var fontScale:Number = 1.2;
			var forecastScoreTxt:TextField = new TextField(_fontSize*2, _fontSize*fontScale, "10", _fontName, _fontSize*fontScale, forecastColor);
			addChild(forecastScoreTxt);
			forecastScoreTxt.y -= _fill.height - 2;
			forecastScoreTxt.alignPivot();
			
			//tintOriginal(tweenTime, 0x2e2e2e);
			setupAnimation(fill, arrow, forecastScoreTxt, progress, tweenTime);
		}
		
		private function tintOriginal(tweenTime:Number, color:int):void{
			var tweenObj:Object = {toOne:0};
			Starling.current.juggler.tween(tweenObj, tweenTime, {toOne:1, onUpdate:onU});
			function onU():void{
				var cmf:ColorMatrixFilter = new ColorMatrixFilter();
				cmf.tint(color, tweenObj.toOne);
				_fill.filter = cmf;
				_arrow.filter = cmf;
				_scoreTextField.filter = cmf;
			}
		}
		
		public function animate(tweenTime:Number = 2):void{
			setupAnimation(_fill, _arrow, _scoreTextField, _progress, tweenTime);
		}
		
		private function setupAnimation(fill:Shape, arrow:Shape, scoreTxt:TextField, progress:Number, tweenTime:Number):void{
			fill.scaleX = 0;
			Starling.current.juggler.tween(fill, tweenTime, {scaleX:progress, transition:Transitions.EASE_OUT});
			Starling.current.juggler.tween(arrow, tweenTime, {x:_barWidth*progress, transition:Transitions.EASE_OUT});
			Starling.current.juggler.tween(scoreTxt, tweenTime, {x:_barWidth*progress, transition:Transitions.EASE_OUT, 
				onUpdate:function():void{scoreTxt.text = String(int(scoreTxt.x/_barWidth*10))}});
		}
		
		public function set scoreFontName(value:String):void{
			_scoreTextField.fontName = value;
		}
		
		public function get progress():Number{
			return _progress;
		}
		
		public function set progress(value:Number):void{
			_progress = value;
		}
	}
}