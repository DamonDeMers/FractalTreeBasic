package com.abacus.events
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import starling.events.EventDispatcher;

	public class EventManager{
		
		private var _dict:Dictionary;
		private var _nativeDict:Dictionary;
		
		public function EventManager(){
			_dict = new Dictionary(true);
			_nativeDict = new Dictionary(true);
		}
		
		public function addEventListener(observerObj:starling.events.EventDispatcher, type:String, listener:Function):void{
			_dict[observerObj] = {type:type, listener:listener}
			observerObj.addEventListener(type, listener);
		}
		
		public function addNativeEventListener(observerObj:flash.events.EventDispatcher, type:String, listener:Function):void{
			_nativeDict[observerObj] = {type:type, listener:listener}
			observerObj.addEventListener(type, listener);
		}
		
		public function removeEventListener(observerObj:starling.events.EventDispatcher, type:String, listener:Function):void{
			_dict[observerObj] = null;
			delete _dict[observerObj];
			observerObj.removeEventListener(type, listener);
		}
		
		public function removeNativeEventListener(observerObj:flash.events.EventDispatcher, type:String, listener:Function):void{
			_nativeDict[observerObj] = null;
			delete _nativeDict[observerObj];
			observerObj.removeEventListener(type, listener);
		}
		
		public function removeAllListeners():void{
			for(var key:* in _dict){
				var eventObj:Object = _dict[key];
				removeEventListener(key, eventObj.type, eventObj.listener);
			}
			for(var nativeKey:* in _nativeDict){
				var nativeEventObj:Object = _nativeDict[nativeKey];
				removeNativeEventListener(nativeKey, nativeEventObj.type, nativeEventObj.listener);
			}
		}
	}
}