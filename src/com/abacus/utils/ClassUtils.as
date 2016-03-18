package com.abacus.utils{
	
	public class ClassUtils{
		
		public function ClassUtils(){
		}
		
		public static function extendsClass(a:Class, b:Class):Boolean{
			if (int(!a) | int(!b)) return false;
			return (a == b || a.prototype is b); //used to be "instanceof" instead of "is"...change if breaks
		}
	}
}