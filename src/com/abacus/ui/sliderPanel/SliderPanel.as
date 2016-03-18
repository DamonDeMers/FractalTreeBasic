package com.abacus.ui.sliderPanel
{
	import com.abacus.events.EventManager;
	
	import flash.utils.Dictionary;
	
	import feathers.controls.Label;
	import feathers.controls.Slider;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SliderPanel extends Sprite{
		
		private var _padding:int;
		
		private var _eventManager:EventManager;
		private var _dict:Dictionary;
		
		public function SliderPanel(padding:int = 25){
			_padding = padding;
			initData();
		}
		
		private function initData():void{
			_eventManager = new EventManager();
			_dict = new Dictionary();
		}
		
		public function addSliders(sliderPanelVOs:Vector.<SliderPanelVO>):void{
			for (var i:int = 0; i < sliderPanelVOs.length; i++){
				var slider:Slider = new Slider();
				var label:Label = new Label();

				slider.minimum = sliderPanelVOs[i].minimum;
				slider.value = sliderPanelVOs[i].defaulVal;
				slider.maximum = sliderPanelVOs[i].maximum;
				slider.step = sliderPanelVOs[i].step;
				label.text = sliderPanelVOs[i].labelTxt + ": " + sliderPanelVOs[i].defaulVal;
				
				slider.validate();
				label.validate();
				
				_eventManager.addEventListener(slider, Event.CHANGE, callbackHandler);
				_dict[slider] = {label:label, sliderPanelVO:sliderPanelVOs[i]};
				
				var x:int = _padding;
				var y:int = _padding + slider.height*i;

				slider.x = x;
				slider.y = y + label.height;
				label.x = x;
				label.y = y + slider.height;

				addChild(slider);
				addChild(label);
			}
		}
		
		private function callbackHandler(e:Event):void{
			var slider:Slider = Slider(e.currentTarget);
			var sliderPanelVO:SliderPanelVO = _dict[slider].sliderPanelVO;
			var label:Label = _dict[slider].label;

			label.text = sliderPanelVO.labelTxt + ": " + slider.value.toFixed(2);
			sliderPanelVO.callback(e);
		}
	}
}