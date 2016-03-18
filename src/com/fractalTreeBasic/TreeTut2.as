package com.fractalTreeBasic{
	
	import com.abacus.ui.backgrounder.Backgrounder;
	import com.abacus.ui.backgrounder.VignetteMode;
	import com.abacus.utils.Assets;
	import com.abacus.utils.MathUtils;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	public class TreeTut2 extends Sprite{
		
		private const BRANCH_ROTATION_MULTIPLIER:Number = Math.PI/5;
		private const BRANCH_HEIGHT_MULTIPLIER:Number = 0.68;
		private const BRANCH_NUM_POINTS:int = 6;
		
		private var _bg:Backgrounder;
		private var _grass:Image;
		private var _treeContainer:Sprite;
		private var _barkContainer:Sprite;
		private var _leafContainer:Sprite;
		private var _fruitContainer:Sprite;
		
		private var _treeData:Vector.<BranchVO>;
		private var _trunkObj:BranchVO;
		private var _trunkHeight:int;
		private var _touchBeganY:Number;
		private var _rotationChangeOnMoved:Number;
		private var _tweenObj:Object;
		private var _dict:Dictionary;
		
		public function TreeTut2(){
		}
		
		public function start():void{
			initData();
			initAssets();
			initListeners();
		}
		
		private function initData():void{
			_trunkHeight = 225;
			_touchBeganY = 0;
			_rotationChangeOnMoved = 0;
			
			var startPoint:Point = new Point(stage.stageWidth/2, stage.stageHeight - 75);
			var endPoint:Point = new Point(startPoint.x, startPoint.y - _trunkHeight); 
			
			_trunkObj = new BranchVO;
			_trunkObj.height = _trunkHeight;
			_trunkObj.rotation = 0;
			_trunkObj.point = createBezierPointsFromStartAndEndPoint(startPoint, endPoint, _trunkObj.rotation, _trunkObj.height/2, false);
			
			_treeData = new Vector.<BranchVO>;
			
			_tweenObj = {};
			_tweenObj.rotation = _rotationChangeOnMoved;
			
			_dict = new Dictionary(true);
			
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
			
			_barkContainer = new Sprite();
			_fruitContainer = new Sprite();
			_leafContainer = new Sprite();
			
			_treeContainer.addChild(_barkContainer);
			_treeContainer.addChild(_fruitContainer);
			_treeContainer.addChild(_leafContainer);
			
			drawTree();
		}
		
		private function initListeners():void{
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function drawTree():void{
			createBark();
			createLeaves();
			createFruit();
			
			animateBark();
			animateLeaves();
			animateFruit();
		}
		
		private function createBark():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchObj:BranchVO = _treeData[i];
				var numPointsInBranch:int = branchObj.point.length;
				for (var j:int = 0; j < numPointsInBranch; j++){
					var bark:Image = Assets.getScaledImage("bark");
					bark.alignPivot();
					bark.x = branchObj.point[j].x;
					bark.y = branchObj.point[j].y;
					_barkContainer.addChild(bark);
				}
			}
		}
		
		private function animateBark():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchVO:BranchVO = _treeData[i];
				var numPoints:int = branchVO.point.length;
				for (var j:int = 0; j < numPoints; j++){
					var bark:Image = _barkContainer.getChildAt((i*numPoints)+j) as Image;
					var delay:Number = (branchVO.parentCount + (j/numPoints-1))/2;
					var scale:Number = (Math.abs(Math.sin((j/numPoints-1) * Math.PI) * 0.5) + 0.5)/(branchVO.parentCount + 2);
					bark.alpha = 0;
					bark.scaleX = bark.scaleY = 0;
					Starling.juggler.tween(bark, 1, {delay:delay, alpha:1, scaleX:scale, scaleY:scale});
				}
			}
		}
		
		private function createLeaves():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchVO:BranchVO = _treeData[i];
				var numLeaves:int = 2;
				var endPoint:Point = branchVO.point[branchVO.point.length-1];
				if(branchVO.parentCount > 1){
					for (var j:int = 0; j < numLeaves; j++){
						var leaf:Image = new Image(Assets.MANAGER.getTexture("leaf"));
						_leafContainer.addChild(leaf);
						leaf.alignPivot(HAlign.CENTER, VAlign.BOTTOM);
						leaf.x = endPoint.x;
						leaf.y = endPoint.y;
						if(j == 0)
							leaf.rotation = branchVO.rotation - Math.PI/6;
						else
							leaf.rotation = branchVO.rotation + Math.PI/6;
						
						_dict[leaf] = branchVO;
					}	
				}
			}
		}
		
		private function animateLeaves():void{
			var len:int = _leafContainer.numChildren;
			for (var i:int = 0; i < len; i++){
				var leaf:Image = _leafContainer.getChildAt(i) as Image;
				var delay:Number = _dict[leaf].parentCount/2;
				leaf.scaleX = leaf.scaleY = 0;
				Starling.juggler.tween(leaf, 1, {delay:delay, scaleX:0.5, scaleY:0.5});
			}
		}
		
		private function createFruit():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchVO:BranchVO = _treeData[i];
				var endPoint:Point = branchVO.point[branchVO.point.length-1];
				if(branchVO.parentCount > 1 && Math.random() > 0.85){
					var orange:Image = new Image(Assets.MANAGER.getTexture("orange"));
					_fruitContainer.addChild(orange);
					orange.alignPivot();
					orange.x = endPoint.x;
					orange.y = endPoint.y;
					_dict[orange] = branchVO;
				}
			}
		}
		
		private function animateFruit():void{
			var len:int = _fruitContainer.numChildren;
			for (var i:int = 0; i < len; i++){
				var orange:Image = _fruitContainer.getChildAt(i) as Image;
				var delay:Number = _dict[orange].parentCount/2;
				orange.scaleX = orange.scaleY = 0;
				Starling.juggler.tween(orange, 1, {delay:delay, scaleX:0.5, scaleY:0.5});
			}
		}
		
		private function generateTreeData(branchVO:BranchVO):void{
			var newBranchHeight:Number = branchVO.height * BRANCH_HEIGHT_MULTIPLIER;
			if(newBranchHeight > 20){
				for (var i:int = 0; i < 2; i++){
					var newBranchVO:BranchVO = new BranchVO();
					
					newBranchVO.height = newBranchHeight;
					newBranchVO.parentVO = branchVO;
					newBranchVO.parentCount = branchVO.parentCount + 1;
					newBranchVO.isRightBranch = i;
					
					if(i == 0)
						newBranchVO.rotation = branchVO.rotation - BRANCH_HEIGHT_MULTIPLIER;
					else
						newBranchVO.rotation = branchVO.rotation + BRANCH_HEIGHT_MULTIPLIER;
					
					var parentPoint:Point = branchVO.point[branchVO.point.length - 1];
					var startPoint:Point = new Point(parentPoint.x, parentPoint.y);
					var endPoint:Point = new Point();
					
					endPoint.x = Math.sin(newBranchVO.rotation) * newBranchHeight + startPoint.x;
					endPoint.y = startPoint.y - Math.cos(newBranchVO.rotation) * newBranchHeight;
					
					newBranchVO.point = createBezierPointsFromStartAndEndPoint(startPoint, endPoint, newBranchVO.rotation, newBranchVO.height, (i == 0));
					generateTreeData(newBranchVO);
				}
			}
			_treeData.push(branchVO);
		}
		
		private function createBezierPointsFromStartAndEndPoint(startPoint:Point, endPoint:Point, rotation:Number, height:Number, invert:Boolean):Vector.<Point>{
			var points:Vector.<Point> = new Vector.<Point>;
			for (var i:int = 0; i < BRANCH_NUM_POINTS; i++){
				var cPoint:Point = new Point();
				var rotationDelta:Number = invert ? -Math.PI/6 : Math.PI/6;
				cPoint.x = Math.sin(rotation + rotationDelta) * height/2 + startPoint.x;
				cPoint.y = startPoint.y - Math.cos(rotation + rotationDelta) * height/2;
				var bezierPoint:Point = quadraticBezierPoint(i/(BRANCH_NUM_POINTS-1), startPoint, endPoint, cPoint);
				points.push(bezierPoint);
			}
			return points;
		}
		
		private function quadraticBezierPoint(value:Number, anchor1:Point, anchor2:Point, control:Point):Point {
			var uc:Number = 1 - value;
			var posx:Number = Math.pow(uc, 2) * anchor1.x + 2 * uc * value * control.x + Math.pow(value, 2) * anchor2.x;
			var posy:Number = Math.pow(uc, 2) * anchor1.y + 2 * uc * value * control.y + Math.pow(value, 2) * anchor2.y;
			return new Point(posx, posy);
		}
		
		private function updateTreeData():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchVO:BranchVO = _treeData[i];
				
				if(branchVO.parentVO){
					if(branchVO.isRightBranch)
						branchVO.rotation = branchVO.parentVO.rotation + _rotationChangeOnMoved;
					else
						branchVO.rotation = branchVO.parentVO.rotation - _rotationChangeOnMoved;
					
					var parentVOEndPoint:Point = branchVO.parentVO.point[branchVO.parentVO.point.length-1];
					var newStartPoint:Point = new Point(parentVOEndPoint.x, parentVOEndPoint.y);
					var newEndPoint:Point = new Point();
					
					newEndPoint.x = Math.sin(branchVO.rotation) * branchVO.height + newStartPoint.x;
					newEndPoint.y = newStartPoint.y - Math.cos(branchVO.rotation) * branchVO.height;
					
					branchVO.point.length = 0;
					branchVO.point = createBezierPointsFromStartAndEndPoint(newStartPoint, newEndPoint, branchVO.rotation, branchVO.height, !branchVO.isRightBranch);
				}
			}
		}
		
		
		private function onTouch(e:TouchEvent):void{
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			var touchMoved:Touch = e.getTouch(this, TouchPhase.MOVED);
			var touchEnded:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if(touchBegan){
				_touchBeganY = touchBegan.globalY;
			} 
			else if(touchMoved){
				var yDeltaMoved:Number = touchMoved.globalY - _touchBeganY;
				_rotationChangeOnMoved = BRANCH_ROTATION_MULTIPLIER + (yDeltaMoved/stage.stageHeight);
				moveBranches();
			} 
			else if(touchEnded){
				tweenToOrigin();
			}
		}
		
		private function tweenToOrigin():void{
			_tweenObj.rotation = _rotationChangeOnMoved;
			Starling.juggler.tween(_tweenObj, 1.5, {rotation:BRANCH_ROTATION_MULTIPLIER, onUpdate:onU, transition:Transitions.EASE_OUT_ELASTIC});
			function onU():void{
				_rotationChangeOnMoved = _tweenObj.rotation;
				moveBranches();
			}
		}
		
		private function moveBranches():void{
			updateTreeData();
			moveBark();
			moveLeaves();
			moveFruit();
		}
		
		private function moveBark():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchVO:BranchVO = _treeData[i];
				var numPoints:int = branchVO.point.length;
				for (var j:int = 0; j < numPoints; j++){
					var bark:Image = _barkContainer.getChildAt((i*numPoints)+j) as Image;
					bark.x = branchVO.point[j].x;
					bark.y = branchVO.point[j].y;
				}
			}
		}	
		
		private function moveLeaves():void{
			var len:int = _leafContainer.numChildren;
			for (var i:int = 0; i < len; i++){
				var leaf:Image = _leafContainer.getChildAt(i) as Image;
				var branchVO:BranchVO = _dict[leaf];
				var endPointIndex:int = branchVO.point.length - 1;
				leaf.x = branchVO.point[endPointIndex].x;
				leaf.y = branchVO.point[endPointIndex].y;
			}
		}
		
		private function moveFruit():void{
			var len:int = _fruitContainer.numChildren;
			for (var i:int = 0; i < len; i++){
				var orange:Image = _fruitContainer.getChildAt(i) as Image;
				var branchVO:BranchVO = _dict[orange];
				var endPointIndex:int = branchVO.point.length - 1;
				orange.x = branchVO.point[endPointIndex].x;
				orange.y = branchVO.point[endPointIndex].y;
			}
		}

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		private const MIN_BRANCH_HEIGHT:int = 25;
		private const NUM_POINTS_PER_BRANCH:int = 6;
		private const BRANCH_ROTATION_MULTIPLIER_RADIANS_DEFAULT:Number = Math.PI/5;
		private const BRANCH_HEIGHT_MULTIPLIER_DEFAULT:Number = 0.68;
		
		private var _treeData:Vector.<BranchVO>;
		private var _trunkVO:BranchVO;
		private var _tweenObj:Object;
		private var _dict:Dictionary;
		private var _trunkHeight:Number;
		private var _branchHeightMultiplier:Number;
		private var _branchRotationMultiplierRadians:Number;
		private var _numBranchingNodes:int;
		private var _beginTouchY:Number;
		private var _isDrawPoints:Boolean;
		private var _isDrawLines:Boolean;
		
		private var _bg:Backgrounder;
		private var _tutorial:Tutorial;
		private var _grass:Sprite;
		private var _treeContainer:Sprite;
		private var _branchContainer:Sprite;
		private var _leavesContainer:Sprite;
		private var _fruitContainer:Sprite;
		private var _resetButton:Button;
		
		public function start():void{
			initData();
			initAssets();
			initListeners();
		}
		
		private function initData():void{
			_treeData = new Vector.<BranchVO>;
			_dict = new Dictionary(true);
			_trunkHeight = 225;
			_branchHeightMultiplier = BRANCH_HEIGHT_MULTIPLIER_DEFAULT;
			_branchRotationMultiplierRadians = BRANCH_ROTATION_MULTIPLIER_RADIANS_DEFAULT;
			_isDrawPoints = false;
			_isDrawLines = true;
			_beginTouchY = 0;
			
			_trunkVO = new BranchVO();
			var trunkPoints:Vector.<Point> = new Vector.<Point>;
			var startPoint:Point = new Point(stage.stageWidth/2, stage.stageHeight - 75);
			var endPoint:Point = new Point(stage.stageWidth/2, stage.stageHeight - 75-_trunkHeight);
			trunkPoints.push(startPoint, endPoint);
			_trunkVO.height = _trunkHeight;
			_trunkVO.rotation = 0;
			_trunkVO.parentCount = 0;
			_trunkVO.points = createBezierPointsFromStartAndEndPoint(startPoint, endPoint, _trunkVO.rotation, _trunkVO.height/2, true);
			
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
			
			_branchContainer = new Sprite();
			_treeContainer.addChild(_branchContainer);
			
			_fruitContainer = new Sprite();
			_treeContainer.addChild(_fruitContainer);
			
			_leavesContainer = new Sprite();
			_treeContainer.addChild(_leavesContainer);
			
			_resetButton = new Button(Assets.MANAGER.getTexture("resetButton"), "");
			addChild(_resetButton);
			LayoutUtils.layout(_resetButton, LayoutUtils.ALIGN_TOP_RIGHT, 20);
			
			var mouseCursor:Image = new Image(Assets.MANAGER.getTexture("mouseCursor"));
			var startPoint:Point = new Point(LayoutUtils.centerStageX() - mouseCursor.width/2, 200);
			var endPoint:Point = new Point(LayoutUtils.centerStageX() - mouseCursor.width/2, 600);
			_tutorial = new Tutorial(mouseCursor, TutorialMode.SWIPE, startPoint, endPoint);
			addChild(_tutorial);
			
			drawTree();
		}
		
		private function initListeners():void{
			addEventListener(TouchEvent.TOUCH, onTouch);
			_resetButton.addEventListener(Event.TRIGGERED, onReset);
		}
		
		private function onReset():void{
			_branchContainer.removeChildren();
			_leavesContainer.removeChildren();
			_fruitContainer.removeChildren();
			drawTree();
		}
		
		private function generateTreeData(branchVO:BranchVO):void{
			var newBranchHeight:Number = branchVO.height * _branchHeightMultiplier;
			if(newBranchHeight > MIN_BRANCH_HEIGHT){
				for (var i:int = 0; i < 2; i++){
					var newBranchVO:BranchVO = new BranchVO();
					
					newBranchVO.height = newBranchHeight;
					newBranchVO.parentCount = branchVO.parentCount + 1;
					newBranchVO.parentVO = branchVO;
					newBranchVO.index = i;
					
					if(i == 0)
						newBranchVO.rotation = branchVO.rotation - _branchRotationMultiplierRadians;
					else
						newBranchVO.rotation = branchVO.rotation + _branchRotationMultiplierRadians;
					
					var parentPoint:Point = branchVO.points[branchVO.points.length - 1];
					var startPoint:Point = new Point(parentPoint.x, parentPoint.y);
					var endPoint:Point = new Point();
					
					endPoint.x = Math.sin(newBranchVO.rotation) * newBranchHeight + startPoint.x;
					endPoint.y = startPoint.y - Math.cos(newBranchVO.rotation) * newBranchHeight;
					
					newBranchVO.points = createBezierPointsFromStartAndEndPoint(startPoint, endPoint, newBranchVO.rotation, newBranchVO.height, (i==0));
					generateTreeData(newBranchVO);
				}
			}
			_treeData.push(branchVO);
		}
		
		private function updateTreeData():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchVO:BranchVO = _treeData[i];
				
				if(branchVO.parentVO){
					if(branchVO.index == 0)
						branchVO.rotation = branchVO.parentVO.rotation - _branchRotationMultiplierRadians;
					else
						branchVO.rotation = branchVO.parentVO.rotation + _branchRotationMultiplierRadians;
					
					var parentPoint:Point = branchVO.parentVO.points[branchVO.points.length - 1];
					var startPoint:Point = new Point(parentPoint.x, parentPoint.y);
					var endPoint:Point = new Point();
					
					endPoint.x = Math.sin(branchVO.rotation) * branchVO.height + startPoint.x;
					endPoint.y = startPoint.y - Math.cos(branchVO.rotation) * branchVO.height;
					
					branchVO.points = createBezierPointsFromStartAndEndPoint(startPoint, endPoint, branchVO.rotation, branchVO.height, (branchVO.index == 0));
				}
			}
		}
		
		private function createBezierPointsFromStartAndEndPoint(startPoint:Point, endPoint:Point, rotation:Number, branchHeight:Number, invert:Boolean):Vector.<Point>{
			var points:Vector.<Point> = new Vector.<Point>;
			for (var j:int = 0; j < NUM_POINTS_PER_BRANCH; j++){
				var cPoint:Point = new Point();
				var rotationDelta:Number = invert ? -Math.PI/6 : Math.PI/6;
				cPoint.x = Math.sin(rotation + rotationDelta) * branchHeight/2 + startPoint.x;
				cPoint.y = startPoint.y - Math.cos(rotation + rotationDelta) * branchHeight/2;
				var bezierPoint:Point = MathUtils.quadraticBezierPoint(j/(NUM_POINTS_PER_BRANCH-1), startPoint, endPoint, cPoint);
				points.push(bezierPoint);
			}
			return points;
		}
		
		private function drawTree():void{
			drawBranches();
			drawLeaves();
			drawFruit();
			
			animateBranches();
			animateLeaves();
			animateFruit();
		}
		
		private function drawBranches():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchVO:BranchVO = _treeData[i];
				var branchLen:int = branchVO.points.length;
				for (var j:int = 0; j < branchLen; j++){
					var bark:Image = Assets.getScaledImage("bark");
					bark.alignPivot();
					bark.x = branchVO.points[j].x;
					bark.y = branchVO.points[j].y;
					_branchContainer.addChild(bark);
				}
			}
		}
		
		private function drawLeaves():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchVO:BranchVO = _treeData[i];
				var branchLen:int = branchVO.points.length;
				var branchIndex:int = branchVO.points.length-1;
				if(branchVO.parentCount > 1){
					for (var j:int = 0; j < 2; j++){
						var leaf:Leaf = new Leaf();
						leaf.x = branchVO.points[branchIndex].x;
						leaf.y = branchVO.points[branchIndex].y;
						if(j == 0)
							leaf.rotation = branchVO.rotation + (Math.PI/6);
						else
							leaf.rotation = branchVO.rotation - (Math.PI/6);
						
						_leavesContainer.addChild(leaf);
						_dict[leaf] = branchVO;
					}
				}
			}
		}
		
		private function drawFruit():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchVO:BranchVO = _treeData[i];
				var branchLen:int = branchVO.points.length;
				var branchIndex:int = branchVO.points.length-1;
				if(branchVO.parentCount > 2 && Math.random() > 0.85){
					var orange:Orange = new Orange();
					orange.x = branchVO.points[branchIndex].x;
					orange.y = branchVO.points[branchIndex].y;
					_fruitContainer.addChild(orange);
					_dict[orange] = branchVO;
				}
			}
		}
		
		private function animateBranches():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchVO:BranchVO = _treeData[i];
				var branchLen:int = branchVO.points.length;
				for (var j:int = 0; j < branchLen; j++){
					var bark:Image = _branchContainer.getChildAt((i*branchLen)+j) as Image;
					var delay:Number = (branchVO.parentCount + (j/branchLen-1))/2;
					var scaleValue:Number = (Math.abs(Math.sin((j/branchLen-1)*Math.PI) * 0.5) + 0.5)/(branchVO.parentCount+2/1);
					bark.alpha = 0;
					bark.scaleX = bark.scaleY = 0;
					Starling.juggler.tween(bark, 1, {delay:delay, alpha:1, scaleX:scaleValue, scaleY:scaleValue, transition:Transitions.EASE_OUT_ELASTIC});
				}
			}
		}
		
		private function animateLeaves():void{
			var len:int = _leavesContainer.numChildren;
			for (var i:int = 0; i < len; i++){
				var leaf:Leaf = _leavesContainer.getChildAt(i) as Leaf;
				var delay:Number = _dict[leaf].parentCount/2;
				var toRotation:Number = leaf.rotation;
				leaf.alpha = 1;
				leaf.scaleX = leaf.scaleY = 0;
				Starling.juggler.tween(leaf, 1, {delay:delay, alpha:1, scaleX:0.5, scaleY:0.5});
				delay += 0.1;
			}
		}
		
		private function animateFruit():void{
			var len:int = _fruitContainer.numChildren;
			for (var i:int = 0; i < len; i++){
				var orange:Orange = _fruitContainer.getChildAt(i) as Orange;
				var delay:Number = _dict[orange].parentCount/2;
				orange.alpha = 1;
				orange.scaleX = orange.scaleY = 0;
				Starling.juggler.tween(orange, 1, {delay:delay, alpha:1, scaleX:0.5, scaleY:0.5, onComplete:onC, onCompleteArgs:[i]});
				delay += 0.1;
			}
			
			function onC(index:int):void{
				if(index == len-1) _tutorial.animate();
			}
		}
		
		private function moveBark():void{
			var len:int = _treeData.length;
			for (var i:int = 0; i < len; i++){
				var branchVO:BranchVO = _treeData[i];
				var branchLen:int = branchVO.points.length;
				for (var j:int = 0; j < branchLen; j++){
					var bark:Image = _branchContainer.getChildAt((i*branchLen)+j) as Image;
					bark.x = branchVO.points[j].x;
					bark.y = branchVO.points[j].y;
				}
			}
		}
		
		private function moveLeaves():void{
			var len:int = _leavesContainer.numChildren;
			for (var i:int = 0; i < len; i++){
				var leaf:Leaf = _leavesContainer.getChildAt(i) as Leaf;
				if(!leaf.hasDropped){
					var branchVO:BranchVO = _dict[leaf];
					var branchIndex:int = branchVO.points.length-1;
					leaf.x = branchVO.points[branchIndex].x;
					leaf.y = branchVO.points[branchIndex].y;
				}
			}
		}
		
		private function moveFruit():void{
			var len:int = _fruitContainer.numChildren;
			for (var i:int = 0; i < len; i++){
				var orange:Orange = _fruitContainer.getChildAt(i) as Orange;
				if(!orange.hasDropped){
					var branchVO:BranchVO = _dict[orange];
					var branchIndex:int = branchVO.points.length-1;
					orange.x = branchVO.points[branchIndex].x;
					orange.y = branchVO.points[branchIndex].y;
				}
			}
		}
		
		private function onTouch(e:TouchEvent):void{
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			var touchMoved:Touch = e.getTouch(this, TouchPhase.MOVED);
			var touchEnded:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if(touchBegan){
				_beginTouchY = touchBegan.globalY;
				Starling.juggler.removeTweens(_tweenObj);
				if(_tutorial.isActive) _tutorial.complete();
			}
			if(touchMoved){
				var yDeltaMoved:Number = touchMoved.globalY - _beginTouchY;
				var rotationMultiplier:Number = BRANCH_ROTATION_MULTIPLIER_RADIANS_DEFAULT + (yDeltaMoved/stage.stageHeight);
				_branchRotationMultiplierRadians = rotationMultiplier;
				moveBranches();
				var moved:Number = Math.abs((touchMoved.globalY - touchMoved.previousGlobalY));
				if(moved > 50){
					var threshold:Number = 1 - (moved/50)/100;
					shedLeaves(threshold, false);
				}
			}
			if(touchEnded){
				var yDeltaEnd:Number = Math.abs(touchEnded.globalY - _beginTouchY);
				tweenPointsToOrigin(yDeltaEnd);
			}
		}
		
		private function tweenPointsToOrigin(yDelta:Number):void{
			_tweenObj = {rotationMultiplier:_branchRotationMultiplierRadians, ratio:0};
			Starling.juggler.tween(_tweenObj, 1.5, {rotationMultiplier:BRANCH_ROTATION_MULTIPLIER_RADIANS_DEFAULT, onStart:onS,
				onUpdate:onU, transition:Transitions.EASE_OUT_ELASTIC});
			
			function onS():void{
				var threshold:Number = 1 - (yDelta/20)/100;
				shedLeaves(threshold);
				shedFruit(threshold);
			}
			
			function onU():void{
				moveBranches(_tweenObj.rotationMultiplier);
			}
		}
		
		private function moveBranches():void{
			updateTreeData();
			moveBark();
			moveLeaves();
			moveFruit();
		}
		
		private function shedLeaves(threshold:Number, isRanDelay:Boolean = true):void{
			var len:int = _leavesContainer.numChildren;
			for (var i:int = 0; i < len; i++){
				var leaf:Leaf = _leavesContainer.getChildAt(i) as Leaf;
				if(!leaf.hasDropped){
					if(Math.random() > threshold){
						var leafToY:Number = stage.stageHeight - _grass.height * Math.random();
						var toRotation:Number = leaf.rotation + (Math.random() * Math.PI*6) - Math.PI*3;
						var delay:Number = isRanDelay ? Math.random() : 0;
						Starling.juggler.tween(leaf, 2, {delay:delay, y:leafToY, rotation:toRotation, onStart:onS, onStartArgs:[leaf]});
						function onS(leafDropped:Leaf):void{
							leafDropped.hasDropped = true;
						}
					}
				}
			}
		}
		
		private function shedFruit(threshold:Number):void{
			var len2:int = _fruitContainer.numChildren;
			for (var j:int = 0; j < len2; j++){
				if(Math.random() > threshold){
					var orange:Orange = _fruitContainer.getChildAt(j) as Orange;
					if(!orange.hasDropped){
						Starling.juggler.tween(orange, 3, {delay:Math.random(), y:stage.stageHeight - _grass.height/2, onStart:onS, 
							onStartArgs:[orange], transition:Transitions.EASE_OUT_BOUNCE});
						function onS(orangeToShed:Orange):void{
							var ranMoveX:Number = orangeToShed.x + (40 - Math.random() * 80);
							orangeToShed.hasDropped = true;
							Starling.juggler.tween(orangeToShed, 2, {delay:2, x:ranMoveX});
						}	
					}
				}
			}
		}
		 **/
	}
}