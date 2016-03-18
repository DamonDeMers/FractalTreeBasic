package com.abacus.utils
{
	import flash.globalization.LocaleID;
	import flash.globalization.NumberFormatter;

	public class StringUtils{
		
		public function StringUtils(){
		}
		
		public static const KEYBOARD_LETTERS:Array = ["Q","W","E","R","T","Y","U","I","O","P",
													"A","S","D","F","G","H","J","K","L",
														"Z","X","C","V","B","N","M"];
		public static const NUMBERS_ZERO_TO_NINE_STRING:Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
		
		public static const KEYBOARD_LETTERS_INSTRUMENT_MAPPED:Array = ["S", "S", "W", "W", "D", "D", "E", "E", "F", "F", "R", "R", "J", "J", "U",
			"U", "K", "K", "I", "I", "L", "L", "O", "O"]
			
			
			/**
			
			 //Home row
			["A", "A", "A", "S", "S", "S", "D", "D", "D", "F", "F", "F", "J", "J", "J",
				"K", "K", "K", "L","L", "L"]
			
			
			["Z","A","Q","X","S","W","C","D","E","V",
			"F","R","V","G","T","B","H","Y","N",
			"J","U","M","K","I","L","O"];
			 */
		
		
		public static function getCommaDelimitedStringFromInt(number:int):String{
			var numberFormatter:NumberFormatter = new NumberFormatter(LocaleID.DEFAULT);
			return numberFormatter.formatInt(number);
		}
	}
}