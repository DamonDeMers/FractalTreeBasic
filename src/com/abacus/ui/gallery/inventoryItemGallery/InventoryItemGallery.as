package com.abacus.ui.gallery.inventoryItemGallery{
	
	import com.abacus.ui.gallery.base.ItemGallery;
	
	import feathers.controls.Button;
	
	import starling.filters.BlurFilter;
	
	public class InventoryItemGallery extends ItemGallery{

		public function InventoryItemGallery(numRows:int, numColumns:int, padding:int = 10){
			super(numRows, numColumns, padding);
		}
	
		override public function refresh(itemVOVect:*):void{
			showItems(itemVOVect);
		}
		
		override protected function initButton():void{
			_nextButton = new Button();
			_nextButton.filter = BlurFilter.createDropShadow(1, 0.785, 0x0, 0.35, 0, 0.5);
			addChild(_nextButton);
			
			_previousButton = new Button();
			_previousButton.filter = BlurFilter.createDropShadow(1, 0.785, 0x0, 0.35, 0, 0.5);
			addChild(_previousButton);
			
			_nextButton.x = 150;
			_nextButton.y = 135;
			
			_previousButton.x = 10;
			_previousButton.y = 135;
		}
		
		override protected function updateUI():void{
			_currentDisplayIndex < _totalItemsDisplayed ? _previousButton.visible = false : _previousButton.visible = true;
			_itemVOVect.length-_currentDisplayIndex <= _totalItemsDisplayed ? _nextButton.visible = false : _nextButton.visible = true;
		}

	}
}