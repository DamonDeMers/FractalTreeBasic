package com.abacus.database{
	import flash.net.registerClassAlias;
	import flash.utils.getQualifiedClassName;

	public class AppDataVO{

		public var numVisits:int;
		public var benchmark:int;
		public var isRemoveAds:Boolean;
		
		public function AppDataVO():void{
			registerClassAlias(getQualifiedClassName(AppDataVO), AppDataVO);
		}
	}
}