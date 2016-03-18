package com.abacus.utils{
	
	public class ArrayUtils{
		
		public function ArrayUtils(){
		}
		
		public static function convertVectorToArray(vect:*):Array{
			var array:Array = [];
			var len:int = vect.length;
			for (var i:int = 0; i < len; i++){
				array.push(vect[i]);
			}
			return array;
		}
		
		public static function shuffleArray(source:Array):Array{
			var shuffledArray:Array = [];
			var clone:Array = source.concat();
			while (clone.length > 0) {
				shuffledArray.push(clone.splice(Math.round(Math.random() * (clone.length - 1)), 1)[0]);
			}
			return shuffledArray;
		}

	}
}