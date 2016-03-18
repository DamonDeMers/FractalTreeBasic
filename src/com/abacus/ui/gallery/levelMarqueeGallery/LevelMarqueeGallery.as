package com.abacus.ui.gallery.levelMarqueeGallery{
	
	import com.abacus.ui.gallery.base.Item;
	import com.abacus.ui.gallery.base.ItemGallery;
	import com.abacus.ui.gallery.base.ItemGalleryEvent;
	import com.abacus.utils.LayoutUtils;
	import com.abacus.utils.TouchUtils;
	
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	
	public class LevelMarqueeGallery extends ItemGallery{
		
		public function LevelMarqueeGallery(numRows:int, numColumns:int, padding:int = 10){
			super(numRows, numColumns, padding);
		}
		
		override protected function reveal():void{
			var len:int = _itemVOVect.length;
			var delay:Number = 0;
			for (var i:int = 0; i < len; i++){
				var levelMarquee:Item = _itemContainer.getChildAt(i) as Item;
				var marqueeY:int = levelMarquee.y;
				levelMarquee.alpha = 0;
				levelMarquee.y -= 20;
				levelMarquee.scaleX = levelMarquee.scaleY = 1.15;
				Starling.juggler.tween(levelMarquee, 0.45, {delay:delay, alpha:1, y:marqueeY, scaleX:1, scaleY:1});
				delay += 0.15;
			}
		}
		
		override protected function updateUI():void{
			LayoutUtils.layout(_previousButton, LayoutUtils.ALIGN_CENTER_LEFT);
			LayoutUtils.layout(_nextButton, LayoutUtils.ALIGN_CENTER_RIGHT);
			_currentDisplayIndex < _totalItemsDisplayed ? _previousButton.visible = false : _previousButton.visible = true;
			_itemVOVect.length-_currentDisplayIndex < _totalItemsDisplayed ? _nextButton.visible = false : _nextButton.visible = true;
		}
		
		override protected function onItemTouch(e:TouchEvent):void{
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if(touchBegan){
				var levelMarquee:LevelMarquee = TouchUtils.getTopLevelDisplayObjectFromTouch(e.target, LevelMarquee) as LevelMarquee;
				if(!levelMarquee.locked){
					Starling.juggler.tween(levelMarquee, 0.2, {y:levelMarquee.y - 10, onComplete:onC});
					function onC():void{
						var level:int = _itemDict[levelMarquee].level;
						var levelSelectedVO:LevelSelectedVO = new LevelSelectedVO;
						levelSelectedVO.levelSelected = level;
						dispatchEventWith(ItemGalleryEvent.ITEM_SELECTED, true, levelSelectedVO);
						_eventManager.removeEventListener(_itemContainer, TouchEvent.TOUCH, onItemTouch);
					}
				} else {
					var cmf:ColorMatrixFilter = new ColorMatrixFilter();
					Starling.juggler.tween(levelMarquee, 0.1, {scaleX:0.95, scaleY:0.95, yoyo:true, repeat:1});
				}
			}
		}
		
	}
}