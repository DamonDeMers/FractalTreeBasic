package com.fractalTreeBasic{
	import flash.geom.Point;
	
	public class BranchVO{
		
		public function BranchVO(){
		}
		
		public var height:Number;
		public var rotation:Number;
		public var parentVO:BranchVO;
		public var isRightBranch:Boolean;
		public var parentCount:int;
		public var point:Vector.<Point> = new Vector.<Point>;

	}
}