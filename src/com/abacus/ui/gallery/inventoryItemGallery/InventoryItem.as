package com.abacus.ui.gallery.inventoryItemGallery{
	
	import com.abacus.ui.gallery.base.Item;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class InventoryItem extends Item{
		
		protected var _inventoryItem:InventoryItemVO;
		protected var _bg:Sprite;
		protected var _item:Sprite;
		
		public function InventoryItem(inventoryItemVO:InventoryItemVO){
			super(inventoryItemVO);
			_inventoryItem = inventoryItemVO;
			
			initAssets();
		}
		
		protected function initAssets():void{
			var bgImg:Image = new Image(_inventoryItem.bgTexture);
			_bg = new Sprite();
			_bg.addChild(bgImg);
			addChild(_bg);
		}
		
	}
}