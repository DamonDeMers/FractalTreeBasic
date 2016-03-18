package com.abacus.database{
	
	public class AppData extends SharedObjectProxy{

		protected var _appDataVO:AppDataVO;
		
		public function AppData(name:String, dataClass:Class){
			super(name, dataClass);
			_appDataVO = dataVO as AppDataVO;
		}
		
		/**
		 * Returns the number of app visits
		 * 
		 * @return int The number of app visits
		 */
		public function get numVisits():int{
			return _appDataVO.numVisits;
		}
		
		/**
		 * Updates the app visit count
		 * 
		 * @param value The number of visits. Usually this will be an incremented value
		 */
		public function set numVisits(value:int):void{
			_appDataVO.numVisits = value;
			flush();
		}
		
		/**
		 * Returns the the benchmark value
		 * 
		 * @return int The number of display objects the device can display simultaneously before the frame 
		 * count dips below 55fps
		 */
		public function get benchmark():int{
			return _appDataVO.benchmark;
		}
		
		/**
		 * Updates the benchmark value. 
		 * 
		 * @param value The number of display objects the device can display simultaneously before the frame 
		 * count dips below 55fps
		 */
		public function set benchmark(value:int):void{
			_appDataVO.benchmark = value;
			flush();
		}
		
		/**
		 * Returns the flag for removing ads from the application. 
		 * 
		 * @return Boolean The show ads value.
		 */
		public function get isRemoveAds():Boolean{
			return _appDataVO.isRemoveAds;
		}
		
		/**
		 * Sets the flag for removing ads from the application. 
		 * 
		 * @param value The flag for removing ads
		 */
		public function set isRemoveAds(value:Boolean):void{
			_appDataVO.isRemoveAds = value;
			flush();
		}
		
		/**
		 * Clears or resets all of the user data
		 */
		public function clear():void{
			_appDataVO = new AppDataVO();
			super.clear();
		}

	}
}