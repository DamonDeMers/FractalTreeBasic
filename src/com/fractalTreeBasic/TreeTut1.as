package com.fractalTreeBasic{
	
	import com.abacus.ui.backgrounder.Backgrounder;
	import com.abacus.ui.backgrounder.VignetteMode;
	import com.abacus.utils.Assets;
	
	import flash.geom.Point;
	
	import mx.utils.NameUtil;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class TreeTut1 extends Sprite{
		
		private const BRANCH_ROTATION_MULTIPLIER:Number = Math.PI/5;
		private const BRANCH_HEIGHT_MULTIPLIER:Number = 0.68;
		
		private var _bg:Backgrounder;
		private var _grass:Image;
		private var _treeContainer:Sprite;
		
		private var _treeData:Vector.<Object>;
		private var _trunkObj:Object;
		private var _trunkHeight:int;
		
				
		public function TreeTut1(){
			super();
		}
		
		public function start():void{
			initData();
			initAssets();
		}
		
		private function initData():void{
			
			_trunkHeight = 225;
			
			var startPoint:Point = new Point(stage.stageWidth/2, stage.stageHeight - 75);
			var endPoint:Point = new Point(startPoint.x, startPoint.y - _trunkHeight); 
			
			_trunkObj = {};
			_trunkObj.height = _trunkHeight;
			_trunkObj.rotation = 0;
			_trunkObj.startPoint = startPoint;
			_trunkObj.endPoint = endPoint;
			
			_treeData = new Vector.<Object>;
						
			generateTreeData(_trunkObj);
		}	
		
		private function initAssets():void{
			_bg = new Backgrounder(Backgrounder.DEFAULT_BG_COLOR, VignetteMode.SUBTLE);
			addChild(_bg);
			
			_grass = new Image(Assets.MANAGER.getTexture("grass"));
			addChild(_grass);
			_grass.y = stage.stageHeight - _grass.height;
			
			_treeContainer = new Sprite();
			addChild(_treeContainer);
			
			drawTree();
		}
		
		private function drawTree():void{
			var len:int = _treeData.length;
			trace("len: " + len);
			for (var i:int = 0; i < len; i++){
				var branchObj:Object = _treeData[i];
				for (var j:int = 0; j < 2; j++){
					var bark:Image = Assets.getScaledImage("bark");
					_treeContainer.addChild(bark);
					if(j == 0){
						bark.x = branchObj.startPoint.x;
						bark.y = branchObj.startPoint.y;
					} else {
						bark.x = branchObj.endPoint.x;
						bark.y = branchObj.endPoint.y;
					}
				}
			}
		}

		private function generateTreeData(branchObj:Object):void{
			var newBranchHeight:Number = branchObj.height * BRANCH_HEIGHT_MULTIPLIER;
			if(newBranchHeight > 20){
				for (var i:int = 0; i < 2; i++){
					var newBranchObj:Object = {};
					
					newBranchObj.height = newBranchHeight;
					
					if(i == 0)
						newBranchObj.rotation = branchObj.rotation - BRANCH_ROTATION_MULTIPLIER;
					else
						newBranchObj.rotation = branchObj.rotation + BRANCH_ROTATION_MULTIPLIER;
					
					var newStartPoint:Point = new Point(branchObj.endPoint.x, branchObj.endPoint.y);
					newBranchObj.startPoint = newStartPoint;
					
					var newEndPoint:Point = new Point();
					newEndPoint.x = Math.sin(newBranchObj.rotation) * newBranchObj.height + newStartPoint.x;
					newEndPoint.y = newStartPoint.y - Math.cos(newBranchObj.rotation) * newBranchObj.height;
					
					newBranchObj.endPoint = newEndPoint;
					
					generateTreeData(newBranchObj);
				}
				_treeData.push(branchObj);
			}
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * private const MIN_BRANCH_HEIGHT:int = 150;
		private const BRANCH_ROTATION_MULTIPLIER_RADIANS_DEFAULT:Number = Math.PI/5;
		private const BRANCH_HEIGHT_MULTIPLIER:Number = 0.68;
		
		private var _treeData:Vector.<Object>;
		private var _trunkVO:Object;
	
		private var _trunkHeight:Number;

		private var _bg:Backgrounder;
		private var _grass:Sprite;
		private var _treeContainer:Sprite;
		
		public function TreeTut1(){
			super();
		}
		
		public function start():void{
			initData();
			initAssets();
		}
		
		private function initData():void{
			_treeData = new Vector.<Object>;
			_trunkHeight = 225;
			
			_trunkVO = new Object();
			var startPoint:Point = new Point(stage.stageWidth/2, stage.stageHeight - 75);
			var endPoint:Point = new Point(startPoint.x, startPoint.y - _trunkHeight);
			
			_trunkVO.height = _trunkHeight;
			_trunkVO.rotation = 0;
			_trunkVO.startPoint = startPoint;
			_trunkVO.endPoint = endPoint;
			
			generateTreeData(_trunkVO);
		}
		
		private function initAssets():void{
			_bg = new Backgrounder(Backgrounder.DEFAULT_BG_COLOR, VignetteMode.SUBTLE);
			addChild(_bg);
			
			_grass = new Sprite();
			var grassImg:Image = new Image(Assets.MANAGER.getTexture("grass"));
			_grass.addChild(grassImg);
			addChild(_grass);
			_grass.y = stage.stageHeight - _grass.height;
			
			_treeContainer = new Sprite();
			addChild(_treeContainer);
			
			drawTree();
		}
		
		private function generateTreeData(branchObj:Object):void{
			var newBranchHeight:Number = branchObj.height * BRANCH_HEIGHT_MULTIPLIER;
			if(newBranchHeight > MIN_BRANCH_HEIGHT){
				for (var i:int = 0; i < 2; i++){
					var newBranchObj:Object = {};
					
					newBranchObj.height = newBranchHeight;
					
					if(i == 0)
						newBranchObj.rotation = branchObj.rotation - BRANCH_ROTATION_MULTIPLIER_RADIANS_DEFAULT;
					else
						newBranchObj.rotation = branchObj.rotation + BRANCH_ROTATION_MULTIPLIER_RADIANS_DEFAULT;

					var startPoint:Point = new Point(branchObj.endPoint.x, branchObj.endPoint.y);
					var endPoint:Point = new Point();
					
					endPoint.x = Math.sin(newBranchObj.rotation) * newBranchHeight + startPoint.x;
					endPoint.y = startPoint.y - Math.cos(newBranchObj.rotation) * newBranchHeight;
					
					newBranchObj.startPoint = startPoint;
					newBranchObj.endPoint = endPoint;
					generateTreeData(newBranchObj);
				}
			}
			_treeData.push(branchObj);
		}
		
		private function drawTree():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchVO:Object = _treeData[i];
				for (var j:int = 0; j < 2; j++){
					var bark:Image = Assets.getScaledImage("bark");
					bark.alignPivot();
					if(j == 0){
						bark.x = branchVO.startPoint.x;
						bark.y = branchVO.startPoint.y;
					} else {
						bark.x = branchVO.endPoint.x;
						bark.y = branchVO.endPoint.y;
					}
					_treeContainer.addChild(bark);
				}
			}
		}
		 *
		 */
		
	}
}