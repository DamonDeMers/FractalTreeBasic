package com.abacus.ui.gallery.base{
	
	import com.abacus.core.AbacusSprite;
	import com.abacus.utils.LayoutUtils;
	import com.abacus.utils.TouchUtils;
	
	import flash.utils.Dictionary;
	
	import feathers.controls.Button;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class ItemGallery extends AbacusSprite{
		
		protected var _itemContainer:Sprite;
		protected var _nextButton:Button;
		protected var _previousButton:Button;
		protected var _padding:int;
		protected var _numRows:int;
		protected var _numColumns:int;
		protected var _totalItemsDisplayed:int;
		protected var _currentDisplayIndex:int;
		protected var _itemDict:Dictionary;
		protected var _itemVOVect:*;
		
		public function ItemGallery(numRows:int, numColumns:int, padding:int = 10){
			super();
			_padding = padding;
			_numRows = numRows;
			_numColumns = numColumns;
			_totalItemsDisplayed = _numRows * _numColumns;
			_currentDisplayIndex = 0;

			initData();
			initAssets();
			initListeners();
		}
		
		protected function initData():void{
			_itemDict = new Dictionary(true);
		}
		
		protected function initAssets():void{
			_itemContainer = new Sprite();
			addChild(_itemContainer);
			initButton();
		}
		
		protected function initListeners():void{
			_eventManager.addEventListener(_itemContainer, TouchEvent.TOUCH, onItemTouch);
			_eventManager.addEventListener(_nextButton, Event.TRIGGERED, onNextButton);
			_eventManager.addEventListener(_previousButton, Event.TRIGGERED, onPreviousButton);
		}
		
		protected function initButton():void{
			_nextButton = new Button();
			_nextButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON);
			_nextButton.width = 15;
			addChild(_nextButton);
			
			_previousButton = new Button();
			_previousButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
			_previousButton.width = 15;
			addChild(_previousButton);
		}
		
		protected function onItemTouch(e:TouchEvent):void{
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if(touchBegan){
				var item:Item = TouchUtils.getTopLevelDisplayObjectFromTouch(e.target, Item) as Item;
				if(!_itemDict[item].isLocked){
					var itemSelectedVO:ItemSelectedVO = new ItemSelectedVO();
					itemSelectedVO.itemVO = _itemDict[item];
					dispatchEventWith(ItemGalleryEvent.ITEM_SELECTED, true, itemSelectedVO);
				}
			}
		}
		
		protected function onNextButton(e:Event):void{
			dispatchEventWith(ItemGalleryEvent.NEXT_ITEM_BUTTON_PRESSED);
			_currentDisplayIndex += _totalItemsDisplayed;
			showItems(_itemVOVect);
		}
		
		protected function onPreviousButton(e:Event):void{
			dispatchEventWith(ItemGalleryEvent.PREVIOUS_ITEM_BUTTON_PRESSED);
			_currentDisplayIndex -= _totalItemsDisplayed;
			showItems(_itemVOVect);
		}
		
		public function populate(itemVOVect:*):void{
			_itemVOVect = itemVOVect;
			for (var i:int = 0; i < _numRows; i++){
				for (var j:int = 0; j < _numColumns; j++){
					if(itemVOVect.length-_currentDisplayIndex > i*_numColumns+j){
						var item:Item;
						var itemVO:ItemVO = itemVOVect[i*_numColumns+j+_currentDisplayIndex];
						if(itemVO.subClass)
							item = new itemVO.subClass(itemVO);
						else
							item = new Item(itemVO);
						if(itemVO.isCentered) item.alignPivot();
						item.x = j * (item.width + _padding) + item.width/2 * int(itemVO.isCentered);
						item.y = i * (item.height + _padding) + item.height/2 * int(itemVO.isCentered);
						_itemContainer.addChild(item);
						_itemDict[item] = itemVO;
					}
				}
			}
			
			updateUI();
			reveal();
		}
		
		protected function updateUI():void{
			LayoutUtils.layout(_previousButton, LayoutUtils.ALIGN_CENTER_LEFT, 0, this);
			LayoutUtils.layout(_nextButton, LayoutUtils.ALIGN_CENTER_RIGHT, 0, this);
			_currentDisplayIndex < _totalItemsDisplayed ? _previousButton.visible = false : _previousButton.visible = true;
			_itemVOVect.length-_currentDisplayIndex < _totalItemsDisplayed ? _nextButton.visible = false : _nextButton.visible = true;
		}
		
		protected function reveal():void{
			//override in subclass
		}
		
		public function refresh(itemVOVect:*):void{
			var len:int = itemVOVect.length;
			for (var i:int = 0; i < len; i++){
				var item:Item = _itemContainer.getChildAt(i) as Item;
				item.refresh(itemVOVect[i]);
			}
		}
		
		public function showItems(itemVOVect:*):void{
			_itemContainer.removeChildren();
			populate(itemVOVect);
		}
		
	}
}