package com.abacus.ui.transitioner{
	
	import com.abacus.core.AbacusView;
	import com.abacus.utils.LayoutUtils;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class Transitioner extends Sprite{
		
		public var sceneView:AbacusView;
		
		private var _screenBlack:Quad;
		private var _screenWhite:Quad;
		private var _tween:Tween;
		private var _tweenTime:Number;
		
		public function Transitioner(tweenTime:Number = TransitionerConsts.TWEEN_TIME_DEFAULT){
			this.touchable = false;
			_tweenTime = tweenTime;
			initAssets();
		}
		
		private function initAssets():void{
			_screenBlack = new Quad(LayoutUtils.appWidth(), LayoutUtils.appHeight(), 0x000000);
			_screenWhite = new Quad(LayoutUtils.appWidth(), LayoutUtils.appHeight(), 0xFFFFFF);
			addChild(_screenBlack);
			addChild(_screenWhite);
			_screenBlack.alpha = 0;
			_screenWhite.alpha = 0;
		}
		
		public function transitionIn(callback:Function = null, mode:String = TransitionerMode.FADE_BLACK, 
									 tweenTime:Number = TransitionerConsts.TWEEN_TIME_DEFAULT, onCompleteArgs:Array = null):void{
			_screenBlack.alpha = 1;
			_screenWhite.alpha = 1;
			
			switch(mode){
				case TransitionerMode.NONE:
					_tween = new Tween(_screenBlack, 0);
					_tween.fadeTo(0);
					break;
				case TransitionerMode.FADE_BLACK:
					_screenWhite.alpha = 0;
					_tween = new Tween(_screenBlack, tweenTime, Transitions.EASE_IN);
					_tween.fadeTo(0);
					break;
				case TransitionerMode.FADE_WHITE:
					_screenBlack.alpha = 0;
					_tween = new Tween(_screenWhite, tweenTime, Transitions.EASE_IN);
					_tween.fadeTo(0);
					break;
			}
			
			_tween.onComplete = callback;
			_tween.onCompleteArgs = onCompleteArgs;
			Starling.juggler.add(_tween);
		}
		
		public function transitionOut(callback:Function, mode:String = TransitionerMode.FADE_BLACK, 
									  tweenTime:Number = TransitionerConsts.TWEEN_TIME_DEFAULT, onCompleteArgs:Array = null):void{
			_screenBlack.alpha = 0;
			_screenWhite.alpha = 0;
			
			switch(mode){
				case TransitionerMode.NONE:
					_tween = new Tween(_screenBlack, 0);
					_tween.fadeTo(0);
					break;
				case TransitionerMode.FADE_BLACK:
					_tween = new Tween(_screenBlack, tweenTime, Transitions.EASE_IN);
					_tween.fadeTo(1);
					break;
				case TransitionerMode.FADE_WHITE:
					_tween = new Tween(_screenWhite, tweenTime, Transitions.EASE_IN);
					_tween.fadeTo(1);
					break;
			}
			
			_tween.onComplete = callback;
			_tween.onCompleteArgs = onCompleteArgs;
			Starling.juggler.add(_tween);
		}
	}
}