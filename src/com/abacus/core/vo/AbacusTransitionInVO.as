package com.abacus.core.vo{
	
	import com.abacus.ui.transitioner.TransitionerConsts;
	import com.abacus.ui.transitioner.TransitionerMode;
	
	public class AbacusTransitionInVO extends AbacusVO{
		
		/**
		 * The callback for the end of the transition
		 */
		public var transitionCompleteCallback:Function;
		
		/**
		 * The transition mode for the closing of the current scene
		 */
		public var transitionMode:String = TransitionerMode.FADE_BLACK;
		
		/**
		 * The transition tween time for the closing of the current scene
		 */
		public var transitionTime:Number = TransitionerConsts.TWEEN_TIME_DEFAULT;
		
		/**
		 * The callback args for the end of the transition
		 */
		public var transitionCompleteArgs:Array = null;
		
		
		public function AbacusTransitionInVO(){
			super();
		}
	}
}