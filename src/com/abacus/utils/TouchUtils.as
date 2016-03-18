package com.abacus.utils
{
	import starling.display.DisplayObject;
	import starling.events.EventDispatcher;

	public class TouchUtils{
		
		/**
		 * Processes the target of a touch event and looks for the top level class matching the class reference.
		 * This is useful for targeting an object in a container
		 * 
		 * @param eventTarget The target of the touch event. i.e. "e.target"
		 * @param classReference The class type target
		 * @return DisplayObject The parent display object matching the class reference. 
		 */
		public static function getTopLevelDisplayObjectFromTouch(eventTarget:EventDispatcher, classReference:Class):DisplayObject{
			var topLevelDispObj:DisplayObject;
			inspectClass(eventTarget as DisplayObject);
			function inspectClass(dispObj:DisplayObject):void{
				if(dispObj is classReference){
					topLevelDispObj = dispObj;
				} else {
					if(dispObj.parent)
						inspectClass(dispObj.parent);
					else
						trace("[TouchUtils] Error: Can not find class reference in target");
				}
			}
			return topLevelDispObj;
		}
	}
}