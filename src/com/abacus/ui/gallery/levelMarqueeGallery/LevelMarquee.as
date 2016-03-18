package com.abacus.ui.gallery.levelMarqueeGallery{
	
	import com.abacus.ui.gallery.base.Item;
	import com.abacus.utils.LayoutUtils;
	
	import feathers.controls.Label;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class LevelMarquee extends Item{

		private const STAR_PADDING_DEFAULT:int = 2;
		
		protected var _levelMarqueeVO:LevelMarqueeVO;
		protected var _locked:Boolean;
		protected var _visited:Boolean;
		protected var _scoreType:String;
		protected var _highScore:int;
		protected var _level:int;
		
		protected var _bg:Sprite;
		protected var _lock:Sprite;
		protected var _starContainer:Sprite;
		protected var _levelLabel:Label;
		protected var _highScoreLabel:Label;
		
		public function LevelMarquee(levelMarqueeVO:LevelMarqueeVO){
			super(levelMarqueeVO);
			_levelMarqueeVO = levelMarqueeVO;
			initData();
			initAssets();
		}

		protected function initData():void{
			_locked = _levelMarqueeVO.isLocked;
			_visited = _levelMarqueeVO.visited;
			_scoreType = _levelMarqueeVO.scoringType;
			_highScore = _levelMarqueeVO.highScore;
			_level = _levelMarqueeVO.level;
		}
		
		protected function initAssets():void{
			_bg = new Sprite();
			_bg.addChild(new Image(_levelMarqueeVO.bgTexture));
			addChild(_bg);
			
			if(_levelMarqueeVO.isLocked){
				_lock = new Sprite();
				_lock.addChild(new Image(_levelMarqueeVO.lockTexture));
				addChild(_lock);
				LayoutUtils.layout(_lock, LayoutUtils.ALIGN_CENTER, 0, this);
			} else {
				_levelLabel = new Label();
				_levelLabel.text = String(_level);
				addChild(_levelLabel);
				LayoutUtils.layout(_levelLabel, LayoutUtils.ALIGN_CENTER, 0, this);
				_levelLabel.y -= 5;
			}
			
			switch(_levelMarqueeVO.scoringType){
				case LevelMarqueeScoreType.SCORING_TYPE_STARS:
					if(!_levelMarqueeVO.isLocked) createStars();
					break;
				case LevelMarqueeScoreType.SCORING_TYPE_PERCENTAGE:
					if(!_levelMarqueeVO.isLocked) createScoreLabel();
					break;
			}
		}
		
		protected function createStars():void{
			_starContainer = new Sprite();
			addChild(_starContainer);
			for (var i:int = 0; i < 3; i++){
				var starOff:Sprite = new Sprite();
				var starOn:Sprite = new Sprite();
				starOff.addChild(new Image(_levelMarqueeVO.starOffTexture));
				starOn.addChild(new Image(_levelMarqueeVO.starOnTexture));
				
				starOff.x = i * starOff.width + i * STAR_PADDING_DEFAULT;
				starOn.x = i * starOff.width + i * STAR_PADDING_DEFAULT;
				
				starOff.name = "starOff"+i;
				starOn.name = "starOn"+i;
				if(_levelMarqueeVO.highScore <= i) starOn.visible = false;
				
				_starContainer.addChild(starOff);
				_starContainer.addChild(starOn);
			}
			LayoutUtils.layout(_starContainer, LayoutUtils.ALIGN_BOTTOM_CENTER, 7, this);
		}
		
		protected function createScoreLabel():void{
			_highScoreLabel = new Label();
			_highScoreLabel.text = "Accuracy: " + String(_highScore) + "%";
			addChild(_highScoreLabel);		
			LayoutUtils.layout(_highScoreLabel, LayoutUtils.ALIGN_BOTTOM_CENTER, 35, this);
		}
		
		public function get locked():Boolean{
			return _locked;
		}
		
	}
}