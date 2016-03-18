package com.abacus.utils{
	import flash.geom.Point;
	
	import starling.display.Shape;
	import starling.display.Sprite;

	public class ShapeUtils{
		
		public function ShapeUtils(){
		}
		
		public static function createCircleSprite(radius:int, lineColor:uint = 0xFFFFFF, lineThickness:Number = 1, 
												  center:Boolean = true, fillColor:Number = NaN, fillAlpha:Number = 1):Sprite{
			
			var circleSprite:Sprite = new Sprite();
			var circle:Shape = new Shape;
			
			if(lineThickness) circle.graphics.lineStyle(lineThickness, lineColor);
			if(fillColor) circle.graphics.beginFill(fillColor, fillAlpha);
			circle.graphics.drawCircle(0,0,radius);
			circle.graphics.endFill();
			
			circleSprite.addChild(circle);
			if(center){
				circle.x += radius;
				circle.y += radius;
			}
			circle.x += lineThickness/2;
			circle.y += lineThickness/2;
			
			return circleSprite;
		}

		public static function createPolygonSprite(numSides:uint, width:Number, height:Number, rotationInRads:Number = 0, 
												  lineColor:uint = 0xFFFFFF, lineThickness:Number = 1, center:Boolean = true, 
												  fillColor:Number = NaN, fillAlpha:Number = 1, curve:Boolean = false):Sprite{
			
			var polygonSprite:Sprite = new Sprite();
			var polygon:Shape = new Shape;
			var points:Vector.<Point> = createPolygonPoints(numSides, width, height, center, rotationInRads);
			
			var len:int = points.length;
			
			polygon.graphics.moveTo(points[len-1].x, points[len-1].y);
			if(!isNaN(lineThickness) && lineThickness != 0) polygon.graphics.lineStyle(lineThickness, lineColor);
			if(fillColor) polygon.graphics.beginFill(fillColor, fillAlpha);
			
			if(curve){
				var anchorPoints1:Vector.<Point>;
				var anchorPoints2:Vector.<Point>;
				anchorPoints1 = createPolygonPoints(numSides, width, height, center, rotationInRads-Math.PI/numSides-(Math.PI/numSides*0.33));
				anchorPoints2 = createPolygonPoints(numSides, width, height, center, rotationInRads-Math.PI/numSides+(Math.PI/numSides*0.33));
			}
			
			for (var i:int = 0; i < len; i++){
				if(!curve){
					polygon.graphics.lineTo(points[i].x, points[i].y);
				} else {
					polygon.graphics.cubicCurveTo(anchorPoints1[i].x, anchorPoints1[i].y, anchorPoints2[i].x, anchorPoints2[i].y, points[i].x, points[i].y);
				}
			}
			polygon.graphics.endFill();
			
			polygonSprite.addChild(polygon);
			polygon.x += lineThickness/2;
			polygon.y += lineThickness/2;
			
			return polygonSprite;
		}
		
		public static function createPolygonPoints(numSides:Number, width:Number, height:Number, center:Boolean, rotationInRads:Number):Vector.<Point>{
			var pointsVect:Vector.<Point> = new Vector.<Point>;
			var step:Number = Math.PI/numSides + rotationInRads;
			var radius:Number = 100;
			var radian_step:Number = (Math.PI*2)/numSides;
			
			for (var i:int = 0; i < numSides; i++){
				var x:Number = Math.sin(step) * radius;
				var y:Number = Math.cos(step) * radius;
				
				pointsVect.push(new Point(x,y));
				step += radian_step;
			}
			
			pointsVect = resizeFlashPolygonPoints(pointsVect, width, height, center);
			
			return pointsVect;
		}
		
		private static function resizeFlashPolygonPoints(pointsVect:Vector.<Point>, width:Number, height:Number, center:Boolean):Vector.<Point>{
			var ar:Array = ArrayUtils.convertVectorToArray(pointsVect);
			var lowX:Number = ar.sortOn("x", Array.NUMERIC)[0].x;
			var highX:Number = ar.sortOn("x", Array.NUMERIC || Array.DESCENDING)[0].x;
			var lowY:Number = ar.sortOn("y", Array.NUMERIC)[0].y;
			var highY:Number = ar.sortOn("y", Array.NUMERIC || Array.DESCENDING)[0].y;
			var xDelta:Number = Math.abs(highX) + Math.abs(lowX);
			var yDelta:Number = Math.abs(highY) + Math.abs(lowY);
			var resizeRatioX:Number = width/xDelta;
			var resizeRatioY:Number = height/yDelta;
			var len:int = pointsVect.length;
			
			for (var i:int = 0; i < len; i++){
				pointsVect[i].x = pointsVect[i].x * resizeRatioX;
				pointsVect[i].y = pointsVect[i].y * resizeRatioY;
				if(!center){
					pointsVect[i].x += xDelta/2 * resizeRatioX;
					pointsVect[i].y += yDelta/2 * resizeRatioY;
				}
			}
			
			return pointsVect;
		}
	}
}