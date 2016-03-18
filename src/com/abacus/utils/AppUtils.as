package com.abacus.utils{
	import flash.system.Capabilities;
	
	public class AppUtils{
		
		public function AppUtils(){
		}
		
		public static function isDesktop():Boolean{
			return (Capabilities.os.indexOf("Windows") >= 0 || Capabilities.os.indexOf("Mac OS") >= 0);
			return false;
		}
		
		public static function isIOS():Boolean{
			return Capabilities.manufacturer.indexOf("iOS") >= 0;
		}
		
		public static function isAndroid():Boolean{
			return Capabilities.manufacturer.indexOf("Android") >= 0;
		}
	}
}