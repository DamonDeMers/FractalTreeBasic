package com.abacus.core
{
	import com.abacus.core.vo.AbacusNextSceneVO;
	import com.abacus.core.vo.AbacusTransitionInVO;
	import com.abacus.core.vo.AbacusTransitionOutVO;
	import com.abacus.events.AbacusEvent;
	import com.abacus.events.EventManager;
	
	import starling.events.EventDispatcher;
	
	public class AbacusModel extends EventDispatcher{
		
		protected var _eventManager:EventManager;
		
		public function AbacusModel(){
			_eventManager = new EventManager();
		}
		
		public function init():void{
			throw new Error("This is an abstract method.  Override in the sublcass");
		}
		
		public function transitionIn():void{
			var transitionInVO:AbacusTransitionInVO = new AbacusTransitionInVO();
			transitionInVO.type = AbacusEvent.TRANSITION_IN;
			dispatchEventWith(AbacusEvent.UPDATE, true, transitionInVO);
		}
		
		public function transitionOut():void{
			var transitionOutVO:AbacusTransitionOutVO = new AbacusTransitionOutVO();
			transitionOutVO.type = AbacusEvent.TRANSITION_OUT;
			transitionOutVO.transitionCompleteCallback = onTransitionOutComplete;
			dispatchEventWith(AbacusEvent.UPDATE, true, transitionOutVO);
		}
		
		protected function onTransitionOutComplete():void{
			dispatchEventWith(AbacusEvent.UPDATE, true, {type:AbacusEvent.CLOSE});
		}
		
		protected function nextScene(controller:AbacusController, model:AbacusModel):void{
			var abacusNextSceneVO:AbacusNextSceneVO = new AbacusNextSceneVO();
			abacusNextSceneVO.type = AbacusEvent.NEXT_SCENE;
			abacusNextSceneVO.controller = controller;
			abacusNextSceneVO.model = model;
			dispatchEventWith(AbacusEvent.UPDATE, true, abacusNextSceneVO);
		}
		
		public function close():void{
			_eventManager.removeAllListeners();
		}
	}
}