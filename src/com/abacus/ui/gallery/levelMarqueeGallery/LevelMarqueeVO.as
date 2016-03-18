package com.abacus.ui.gallery.levelMarqueeGallery{
	
	import com.abacus.ui.gallery.base.ItemVO;
	
	import starling.textures.Texture;

	public class LevelMarqueeVO extends ItemVO{
		
		public var bgTexture:Texture;
		public var starOnTexture:Texture;
		public var starOffTexture:Texture;
		public var lockTexture:Texture;
		public var scoringType:String;
		public var highScore:int;
		public var level:int;
		public var visited:Boolean;
		
		public function LevelMarqueeVO(){
		}
	}
}