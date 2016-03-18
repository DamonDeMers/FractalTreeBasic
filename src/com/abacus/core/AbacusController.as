package com.abacus.core
{
	import com.abacus.events.EventManager;
	
	public class AbacusController{

		protected var _eventManager:EventManager;
		
		public function AbacusController(){
			_eventManager = new EventManager();
		}

		public function init(rootView:AbacusView, model:AbacusModel):void{
			throw new Error("This is an abstract method.  Override in the sublcass");
		}
		
		public function close(view:AbacusView, model:AbacusModel):void{
			_eventManager.removeAllListeners();
			view.close();
			model.close();
		}
		
	}
}