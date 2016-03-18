package com.abacus.ui.gallery.storeItemGallery{
	
	import com.abacus.core.AbacusSprite;
	
	import starling.display.Sprite;
	
	public class StoreItemGallery extends AbacusSprite{
		
		private var _galleryContainer:Sprite;
		private var _padding:int;
		
		public function StoreItemGallery(padding:int = 10){
			super();
			_padding = padding;
			initAssets();
		}
		
		private function initAssets():void{
			_galleryContainer = new Sprite();
			addChild(_galleryContainer);
		}
		
		public function populate(storeItemVOVect:Vector.<StoreItemVO>):void{
			var numRows:int = 1;
			for (var i:int = 0; i < numRows; i++){
				var numColumns:int = 4;
				for (var j:int = 0; j < numColumns; j++){
					var storeItem:StoreItem;
					if(storeItemVOVect[i].subClass){
						storeItem = new storeItemVOVect[i].subClass(storeItemVOVect[i*numColumns+j]);
					}
					else{
						storeItem = new StoreItem(storeItemVOVect[i*numColumns+j]);
					}
					storeItem.x = j * (storeItem.width + _padding);
					storeItem.y = i * (storeItem.height + _padding);
					_galleryContainer.addChild(storeItem);
				}
			}
		}
		
		public function refresh(storeItemVOVect:Vector.<StoreItemVO>):void{
			var len:int = storeItemVOVect.length;
			for (var i:int = 0; i < len; i++){
				var storeItem:StoreItem = _galleryContainer.getChildAt(i) as StoreItem;
				storeItem.refresh(storeItemVOVect[i]);
			}
		}
	}
}