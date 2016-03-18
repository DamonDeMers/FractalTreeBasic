package com.abacus.ui.gallery.storeItemGallery{
	
	import com.abacus.core.AbacusSprite;
	import com.abacus.events.AbacusEvent;
	import com.abacus.utils.LayoutUtils;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	
	public class StoreItem extends AbacusSprite{
		protected var _storeItemVO:StoreItemVO;
		
		protected var _bg:Sprite;
		protected var _icon:Sprite;
		protected var _levelMeter:Sprite;
		protected var _titleLabel:Label;
		protected var _upgradeLevel:Label;
		protected var _price:Label;
		protected var _buyButton:Button;
		
		protected var _titleLabelPadding:int;
		protected var _iconPadding:int;
		protected var _upgradeLevelPadding:int;
		protected var _levelMeterPadding:int;
		protected var _pricePadding:int;
		protected var _buyButtonPadding:int;
		
		public function StoreItem(upgradeItemVO:StoreItemVO){
			super();
			
			_storeItemVO = upgradeItemVO;
			
			initData();
			initAssets();
			initListeners();
		}
		
		protected function initData():void{
			_titleLabelPadding = 5;
			_iconPadding = 22;
			_upgradeLevelPadding = 5;
			_levelMeterPadding = 68;
			_pricePadding = 82;
			_buyButtonPadding = 95;
		}
		
		protected function initAssets():void{
			initImages();
			initLabels();
			initMeter();
			initButtons();
			queueTexturesForDisposal();

			lock(_storeItemVO.isLocked || _storeItemVO.isMaxed);
		}
		
		protected function initImages():void{
			var bgImage:Image = new Image(_storeItemVO.bgTexture);
			_bg = new Sprite();
			_bg.addChild(bgImage);
			addChild(_bg);
			
			var iconImage:Image = new Image(_storeItemVO.iconTexture);
			_icon = new Sprite();
			_icon.addChild(iconImage);
			addChild(_icon);
			LayoutUtils.layout(_icon, LayoutUtils.ALIGN_TOP_CENTER, _iconPadding, _bg);
		}
		
		protected function initLabels():void{
			_upgradeLevel = new Label();
			addChild(_upgradeLevel);
			
			_titleLabel = new Label();
			_titleLabel.text = _storeItemVO.titleText;
			addChild(_titleLabel);
			LayoutUtils.layout(_titleLabel, LayoutUtils.ALIGN_TOP_CENTER, _titleLabelPadding, _bg);
			
			_price = new Label();
			_price.text = _storeItemVO.isMaxed ? "Max!" : String("$" + _storeItemVO.price);
			addChild(_price);
			LayoutUtils.layout(_price, LayoutUtils.ALIGN_TOP_CENTER, _pricePadding, _bg);
		}
		
		protected function initMeter():void{
			_levelMeter = new Sprite();
			addChild(_levelMeter);
			
			switch(_storeItemVO.upgradeIndicatorType){
				case StoreItemUpgradeIndicatorType.LABEL:
					_levelMeter.visible = false;
					_upgradeLevel.text = String("L: " + _storeItemVO.level);
					LayoutUtils.layout(_upgradeLevel, LayoutUtils.ALIGN_TOP_RIGHT, _upgradeLevelPadding, _bg);
					break;
				case StoreItemUpgradeIndicatorType.METER:
					_upgradeLevel.visible = false;
					var len:int = _storeItemVO.totalUpgradeLevels;
					for (var i:int = 0; i < len; i++){
						var levelIconTexture:Texture = _storeItemVO.level > i ? 
							_storeItemVO.upgradeLevelOnTexture : _storeItemVO.upgradeLevelOffTexture;
						var levelIconImg:Image = new Image(levelIconTexture);
						levelIconImg.x += i * (_bg.width/len - 5);
						_levelMeter.addChild(levelIconImg);
					}
					LayoutUtils.layout(_levelMeter, LayoutUtils.ALIGN_TOP_CENTER, _levelMeterPadding, _bg);
					break;
				default:
					//not upgradeable
					break;
			}
		}
		
		protected function initButtons():void{
			_buyButton = new Button();
			_buyButton.label = _storeItemVO.buttonText;
			_buyButton.filter = BlurFilter.createDropShadow(3, 0.785, 0x0, 0.35, 0, 0.5);
			addChild(_buyButton);
			LayoutUtils.layout(_buyButton, LayoutUtils.ALIGN_TOP_CENTER, _buyButtonPadding, _bg);
		}
		
		protected function queueTexturesForDisposal():void{
			if(_storeItemVO.bgTexture) _textureDisposalQueue.push(_storeItemVO.bgTexture);
			if(_storeItemVO.upgradeLevelOffTexture) _textureDisposalQueue.push(_storeItemVO.upgradeLevelOffTexture);
			if(_storeItemVO.upgradeLevelOffTexture) _textureDisposalQueue.push(_storeItemVO.upgradeLevelOnTexture);
		}
		
		protected function lock(lock:Boolean):void{
			this.alpha = lock ? 0.6 : 1;
			this.touchable = !lock;
		}
		
		protected function initListeners():void{
			_eventManager.addEventListener(_buyButton, Event.TRIGGERED, onBuyButton);
		}
		
		protected function onBuyButton(e:Event):void{
			var buyButtonPressedVO:BuyButtonPressedVO = new BuyButtonPressedVO();
			buyButtonPressedVO.type = StoreItemGalleryEvent.BUY_BUTTON_PRESSED;
			buyButtonPressedVO.itemName = _storeItemVO.name;
			dispatchEventWith(AbacusEvent.UPDATE, true, buyButtonPressedVO);
		}
		
		public function refresh(upgradeItemVO:StoreItemVO):void{
			_upgradeLevel.text =  String("L:" + upgradeItemVO.level);
			var levelIconImg:Image = _levelMeter.getChildAt(upgradeItemVO.level-1) as Image;
			levelIconImg.texture = _storeItemVO.upgradeLevelOnTexture;
			_price.text = upgradeItemVO.isMaxed ? "Max!" : String("$" + upgradeItemVO.price);
			LayoutUtils.layout(_price, LayoutUtils.ALIGN_TOP_CENTER, _pricePadding, _bg);
			lock(_storeItemVO.isLocked || _storeItemVO.isMaxed);
		}
	}
}