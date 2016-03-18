package com.abacus.core{
	
	import com.abacus.core.vo.AbacusAlertVO;
	import com.abacus.core.vo.AbacusNextSceneVO;
	import com.abacus.core.vo.AbacusTransitionInVO;
	import com.abacus.core.vo.AbacusTransitionOutVO;
	import com.abacus.database.DatabaseManager;
	import com.abacus.events.AbacusEvent;
	import com.abacus.events.EventManager;
	import com.abacus.tests.Benchmarker;
	import com.abacus.tests.BenchmarkerEvent;
	import com.abacus.ui.alerter.Alerter;
	import com.abacus.ui.backgrounder.Backgrounder;
	import com.abacus.ui.transitioner.Transitioner;
	import com.abacus.utils.AppUtils;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class AbacusRoot extends Sprite{
		
		/** The version of the Abacus framework. */
		public static const VERSION:String = "1.1";

		protected var _db:DatabaseManager;
		protected var _eventManager:EventManager;
		protected var _debug:Boolean;
		protected var _isMarkedForBenchMark:Boolean;
		
		protected var _bg:Backgrounder;
		protected var _controller:AbacusController;
		protected var _model:AbacusModel;
		protected var _rootView:AbacusView;
		//protected var _hud:Hud;  //not yet implemented
		protected var _transitioner:Transitioner;
		protected var _alerter:Alerter;
		protected var _benchmarker:Benchmarker;

		public function AbacusRoot(){
			super();
		}
		
		public function init(controller:AbacusController, model:AbacusModel):void{
			_controller = controller;
			_model = model;
			initTheme();
			initData();
			initBg();
			initSceneView();
			initTransitioner();
			initAlerter();
			if(!AppUtils.isDesktop()){
				initAds();
				initPurchase();
				initSocial();
				initGameCenter();
				initRating();
			}
			if(_isMarkedForBenchMark && _db.numVisits == 0)
				initBenchmarker();
			else 
				switchScene(controller, model);
		}

		protected function initTheme():void{
			/**
			 * Override in subclass.  Feathers example below.
			 */
			
			/*
			new MyAppTheme();
			*/
		}
		
		protected function initData():void{
			/**
			 * Override in subclass to add additional vars as below
			 * 
			 * _db = new DatabaseManager();
			 * Flox.init("xgpimM5S4KQIJKL7", "sEqmPUeztjlFst68", "0.9");
			 */
			
			_eventManager = new EventManager();
			_isMarkedForBenchMark = false;
		}
		
		protected function initBg():void{
			_bg = new Backgrounder();
			addChild(_bg);
		}
		
		protected function initSceneView():void{
			_rootView = new AbacusView();
			addChild(_rootView);
		}
		
		protected function switchScene(controller:AbacusController, model:AbacusModel):void{
			_model = model;
			_eventManager.addEventListener(_model, AbacusEvent.UPDATE, onModelUpdate);
			_rootView.removeChildren();
			controller.init(_rootView, model);
		}
		
		protected function initTransitioner():void{
			_transitioner = new Transitioner();
			_transitioner.sceneView = _rootView;
			addChild(_transitioner);
		}
		
		protected function initAlerter():void{
			_alerter = new Alerter();
			addChild(_alerter);
		}
		
		protected function initBenchmarker():void{
			_benchmarker = new Benchmarker();
			addChild(_benchmarker);
			_benchmarker.messageTextField.fontName = "SlimJoe";
			_benchmarker.addEventListener(BenchmarkerEvent.COMPLETE, onBenchmarkerComplete);
			_benchmarker.test();
		}
		
		protected function onBenchmarkerComplete(e:Event):void{
			_db.benchmark = e.data.avgTotalDisplayObjects;
			removeChild(_benchmarker);
			switchScene(_controller, _model);
		}
		
		protected function initAds():void{
			/**
			 * Override in subclass.  MilkmanGame example below.
			 */

			/*
			var adMobService:AdMobService;
			adMobService = AdMobService.getInstance();
			adMobService.init("Android Banner ID", "Apple Banner ID", true);
			adMobService.androidInterstitialID = "Andoid Interstitial ID";
			adMobService.appleInterstitialID = "Apple Interstitial ID";
			*/
		}
		
		protected function initPurchase():void{
			/**
			 * Override in subclass.  MilkmanGame example below.
			 */
		}
		
		protected function initSocial():void{
			/**
			 * Override in subclass.  MilkmanGame example below.
			 */
			
			/*
			var socialMediaService:SocialMediaService;
			socialMediaService = SocialMediaService.getInstance();
			socialMediaService.init("Facebook App ID", "Facebook Page ID", "Twitter ID");
			*/
		}
		
		protected function initGameCenter():void{
			/**
			 * Override in subclass.  MilkmanGame example below.
			 */
			
			/*
			GameCenterServices.getInstance().init();
			*/
		}
		
		protected function initRating():void{
			/**
			 * Override in subclass.  MilkmanGame example below.
			 */

			/*
			var ratingService:RatingService;
			ratingService.create("123456789","Rate My App","If you like this app, please rate it 5 stars!", "Rate Now", "Not now", "Don't ask again", 1, 0, 0, 0);
			ratingService.useTestMode();
			if(AppConts.IS_DEBUG) ratingService.onLaunch();
			*/
		}
		
		protected function onModelUpdate(e:Event):void{
			var abacusVO:Object = e.data;
			switch(abacusVO.type){
				case AbacusEvent.TRANSITION_IN:
					var abacusInitVO:AbacusTransitionInVO = abacusVO as AbacusTransitionInVO;
					_transitioner.transitionIn(abacusInitVO.transitionCompleteCallback, abacusInitVO.transitionMode, 
						abacusInitVO.transitionTime, abacusInitVO.transitionCompleteArgs);
					break;
				case AbacusEvent.TRANSITION_OUT:
					var abacusCompleteVO:AbacusTransitionOutVO = abacusVO as AbacusTransitionOutVO;
					_transitioner.transitionOut(abacusCompleteVO.transitionCompleteCallback, abacusCompleteVO.transitionMode, 
						abacusCompleteVO.transitionTime, abacusCompleteVO.transitionCompleteArgs);
					break;
				case AbacusEvent.NEXT_SCENE:
					var abacusCloseVO:AbacusNextSceneVO = abacusVO as AbacusNextSceneVO;
					switchScene(abacusCloseVO.controller, abacusCloseVO.model);
					break;
				case AbacusEvent.ALERT:
					var abacusAlerterVO:AbacusAlertVO = abacusVO as AbacusAlertVO;
					_alerter.show(abacusAlerterVO);
					break;
			}
		}
		
		public function get debug():Boolean{ return _debug; }
		public function set debug(value:Boolean):void{ _debug = value; }
		
	}
}