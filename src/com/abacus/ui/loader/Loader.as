package com.abacus.ui.loader{
	
	import com.abacus.core.AbacusSprite;
	import com.abacus.ui.backgrounder.Backgrounder;
	import com.abacus.ui.backgrounder.VignetteMode;
	import com.abacus.utils.LayoutUtils;
	
	import starling.display.Shape;
	import starling.events.Event;
	
	public class Loader extends AbacusSprite{
		
		private var _overlay:Backgrounder;
		private var _loaderBarBg:Shape;
		private var _loaderBar:Shape;
		
		private var _loaderBarWidth:int;
		private var _loaderBarHeight:int;
		private var _loaderBarPadding:int;
		
		public function Loader(scaleForMultiResolution:Boolean = false){
			super(scaleForMultiResolution);
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			initData();
			initAssets();
		}
		
		protected function initData():void{
			_loaderBarPadding = 50;
			_loaderBarWidth = LayoutUtils.appWidth() - _loaderBarPadding;
			_loaderBarHeight = 5;
		}
		
		protected function initAssets():void{
			_overlay = new Backgrounder(0x000000, VignetteMode.NONE);
			addChild(_overlay);
			_overlay.alpha = 0.8;
			
			_loaderBarBg = new Shape();
			_loaderBarBg.graphics.beginFill(0x000000);
			_loaderBarBg.graphics.drawRoundRect(0, 0, _loaderBarWidth, _loaderBarHeight, 5);
			_loaderBarBg.graphics.endFill();
			addChild(_loaderBarBg);
			LayoutUtils.layout(_loaderBarBg, LayoutUtils.ALIGN_CENTER);
			
			_loaderBar = new Shape();
			_loaderBar.graphics.beginFill(0xFFFFFF);
			_loaderBar.graphics.drawRoundRect(0, 0, _loaderBarWidth, _loaderBarHeight, 5);
			_loaderBar.graphics.endFill();
			addChild(_loaderBar);
			LayoutUtils.layout(_loaderBar, LayoutUtils.ALIGN_CENTER);
			_loaderBar.scaleX = 0;
		}
		
		public function updateProgress(ratio:Number):void{
			_loaderBar.scaleX = ratio;
		}
	}
}