package com.abacus.database{
	
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	import flash.utils.getQualifiedClassName;
	
	import starling.events.EventDispatcher;
	
	public class SharedObjectProxy extends EventDispatcher{
		
		private const DATA_VO_PROPERTY:String = "dataVO";
	
		protected var _so:SharedObject;
		private var _name:String;
		private var _dataVOClass:Class;
		
		/**
		 * @Constructor
		 * 
		 * The SharedObjectProxy is a base class for value objects that need to persist via the Flash player's SharedObject.  
		 * This class works under the assumption that each instantiation will be responsible for one value object.  
		 * This value object might, for example, contain all of ther user's progress data, or application variables, etc.  
		 * This class can then be extended for specific implementation based on the dataClass type.
		 * 
		 * @param name The name of the local shared object
		 * @param dataClass The class type of the main storage object
		 */
		public function SharedObjectProxy(name:String, dataVOClass:Class){
			super();
			registerClassAlias(getQualifiedClassName(dataVOClass), dataVOClass);
			_name = name;
			_dataVOClass = dataVOClass;
			initData();
		}
		
		
		/**
		 * @private
		 * 
		 * Initializes the shared object and creates the main data class if it does not already exist
		 */
		private function initData():void{
			_so = SharedObject.getLocal(_name);
			if(!_so.data[DATA_VO_PROPERTY]){
				var dataClass:* = new _dataVOClass;
				_so.data[DATA_VO_PROPERTY] = dataClass;
				flush();
			}
		}
		
		/**
		 * @protected
		 * 
		 * Returns the stored value object.  Call this in superclass and cast to assign to typed value object
		 * 
		 * @return Object The stored value object
		 */
		protected function get dataVO():Object{
			return _so.data[DATA_VO_PROPERTY];
		}
		
		protected function flush():void{
			if(_so) _so.flush();
		}
		
		protected function clear():void{
			if(_so){ 
				_so.data[DATA_VO_PROPERTY] = null;
				_so.clear();
			}
		}
	}
}