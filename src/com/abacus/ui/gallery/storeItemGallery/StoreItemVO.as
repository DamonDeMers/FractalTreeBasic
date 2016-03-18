package com.abacus.ui.gallery.storeItemGallery{
	import com.abacus.ui.gallery.base.ItemVO;
	
	import starling.textures.Texture;
	
	public class StoreItemVO extends ItemVO{
		
		public var bgTexture:Texture;
		public var iconTexture:Texture;
		public var upgradeLevelOnTexture:Texture;
		public var upgradeLevelOffTexture:Texture;
		public var titleText:String;
		public var buttonText:String;
		public var upgradeIndicatorType:String;
		public var totalUpgradeLevels:int;
		public var price:int;
		public var level:int;
		public var isMaxed:Boolean;
	}
}