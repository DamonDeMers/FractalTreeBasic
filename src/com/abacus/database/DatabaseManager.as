package com.abacus.database{
	
	import starling.events.EventDispatcher;
	
	public class DatabaseManager extends EventDispatcher{
		
		protected var _appData:AppData;
		
		/**
		 * @Constructor
		 * 
		 * The DatabaseManager is a base class for managing persistent data.  This class is meant to be used 
		 * as an interface or API for database calls and shared object handling. 
		 * 
		 */
		public function DatabaseManager(){
			super();
			initData();
		}
		
		/**
		 * This function can be override to add additional or custom sharedObjectProxys 
		 */
		protected function initData():void{
			_appData = new AppData("appData", AppDataVO);
		}
		
		public function get numVisits():int{
			return _appData.numVisits;
		}
		
		public function set numVisits(value:int):void{
			_appData.numVisits = value;
		}
		
		public function get isRemoveAds():Boolean{
			return _appData.isRemoveAds;
		}
		
		public function set isRemoveAds(value:Boolean):void{
			_appData.isRemoveAds = value;
		}
		
		public function get benchmark():int{
			return _appData.benchmark;
		}
		
		public function set benchmark(value:int):void{
			_appData.benchmark = value;
		}
		
		public function clearUserData():void{
			_appData.clear();
		}
	}
}