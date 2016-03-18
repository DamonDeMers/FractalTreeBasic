package com.abacus.utils
{
	import flash.utils.ByteArray;

	public class ObjectUtils{
		
		/**
		 * Decorates target object with property values from source object. 
		 * 
		 * @param source The source object
		 * @param target The target object to be serialized
		 */
		public static function serializeObject(source:Object, target:Object):void{
			for(var prop:* in source){
				target[prop] = source[prop];
			}
		}
		
		/**
		 * Decorates target value with property values from source object.  Checks
		 * to see that value object contains property, otherwise prop is skipped 
		 * 
		 * @param source The source object
		 * @param target The target value object to be serialized
		 */
		public static function serializeValueObject(source:Object, vo:Object):void{
			for(var prop:* in source){
				if(vo.hasOwnProperty(prop)){
					vo[prop] = source[prop];
				}
			}
		}
		
		/**
		 * Writes source object into bytearray, then reads and returns it's clone 
		 * 
		 * @param source The source object
		 * @return The cloned object
		 */
		public static function cloneObject(source:Object):Object{ 
			var byteArray:ByteArray = new ByteArray(); 
			byteArray.writeObject( source ); 
			byteArray.position = 0; 
			return(byteArray.readObject()); 
		}
		
	}
}