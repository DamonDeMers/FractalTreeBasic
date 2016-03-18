package com.abacus.utils
{
	import flash.geom.Point;

	public class MathUtils{
		
		public static const RADIAN_CIRCLE:Number = Math.PI*2;
		
		public function MathUtils(){
		}
		
		public static function constrainNumberInRange(input:Number, lowConstrained:Number, highConstrained:Number):Number{
			if(input<lowConstrained){
				input = lowConstrained;
			} else if(input > highConstrained){
				input = highConstrained;
			}
			return input;
		}
		
		public static function getRandomNumberInRange(low:Number, high:Number, round:Boolean = false, scale:Number = 1):Number{
			var num:Number = 0;
			var range:Number = high - low;
			num = Math.random() * range + low;
			if(round) num = Math.round(num);
			return num * scale;
		}
		
		public static function getNearestMultiple(inputNumber:int, multipleOf:int, highSide:Boolean):int{
			while(inputNumber % multipleOf != 0){
				highSide ? inputNumber ++ : inputNumber--;
			}
			return inputNumber;
		}
		
		public static function quadraticBezierPoint(value:Number, anchor1:Point, anchor2:Point, control:Point):Point {
			var uc:Number = 1 - value;
			var posx:Number = Math.pow(uc, 2) * anchor1.x + 2 * uc * value * control.x + Math.pow(value, 2) * anchor2.x;
			var posy:Number = Math.pow(uc, 2) * anchor1.y + 2 * uc * value * control.y + Math.pow(value, 2) * anchor2.y;
			return new Point(posx, posy);
		}
	}
}