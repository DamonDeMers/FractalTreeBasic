package com.abacus.utils
{
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	
	import avmplus.getQualifiedClassName;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;

	public class DisplayObjectUtils{
		
		//TODO:Create better documentation
		public static function getStarlingSprite3DFromFlashDisplayObject(flashDispObj:flash.display.DisplayObject):Sprite3D{
			var scaleFactor:int = Starling.contentScaleFactor;
			var sprite3D:Sprite3D;
			var bmpData:BitmapData;
			var texture:Texture;
			var image:Image;
			
			bmpData = new BitmapData(flashDispObj.width, flashDispObj.height, true, 0x0000000);
			bmpData.draw(flashDispObj);
			
			texture = Texture.fromBitmapData(bmpData, true, false, scaleFactor);
			image = new Image(texture);
			sprite3D = new Sprite3D();
			sprite3D.addChild(image);
			bmpData.dispose();
			
			return sprite3D;
		}
		
		public static function getStarlingSpriteFromFlashDisplayObject(flashDispObj:flash.display.DisplayObject, flatten:Boolean):Sprite{
			var scaleFactor:int = Starling.contentScaleFactor;
			var sprite:Sprite;
			var bmpData:BitmapData;
			var texture:Texture;
			var image:Image;
			var bounds:Rectangle;
			
			bounds = flashDispObj.getBounds(flashDispObj);
			bmpData = new BitmapData(bounds.width+bounds.x, bounds.height+bounds.y, true, 0x0000000);
			bmpData.draw(flashDispObj);
			
			texture = Texture.fromBitmapData(bmpData, true, false, scaleFactor);
			image = new Image(texture);
			sprite = new Sprite();
			sprite.addChild(image);
			if(flatten){
				sprite.flatten();
			}
			bmpData.dispose();
			
			return sprite;
		}
		
		public static function getStarlingTextureFromFlashDisplayObject(flashDispObj:flash.display.DisplayObject):Texture{
			var scaleFactor:int = Starling.contentScaleFactor;
			var texture:Texture;
			var bmpData:BitmapData;
			var image:Image;
			
			bmpData = new BitmapData(Math.ceil(flashDispObj.width), Math.ceil(flashDispObj.height), true, 0x0000000);
			bmpData.draw(flashDispObj);
			
			texture = Texture.fromBitmapData(bmpData, true, false);
			bmpData.dispose();
			
			return texture;
		}
		
		public static function getStarlingTextureFromStarlingSprite(starlingDispObj:Sprite):Texture{
			var renderTexture:RenderTexture = new RenderTexture(starlingDispObj.width, starlingDispObj.height);
			renderTexture.draw(starlingDispObj);
			
			return renderTexture;
		}
		
		public static function getStarlingTextureReferencesFromStarlingSprite(starlingDispObjContainer:starling.display.DisplayObjectContainer):Vector.<Texture>{
			var textures:Vector.<Texture> = new Vector.<Texture>;
			getTextures(starlingDispObjContainer);
			function getTextures(displayObjContainer:starling.display.DisplayObjectContainer):void{
				var len:int = displayObjContainer.numChildren;
				for (var i:int = 0; i < len; i++){
					var dispObj:starling.display.DisplayObject = displayObjContainer.getChildAt(i);
					if(dispObj is Image){
						var texture:Texture = Image(dispObj).texture;
						textures.push(texture);
					} else {
						getTextures(dispObj as starling.display.DisplayObjectContainer);
					}
				}	
			}
			return textures;
		}
		
		public static function createDottedEllipse(width:int, height:int, numDotsPerRing:int, dotRadius:Number, 
												fillColor:int, dotScaleX:Number = NaN, dotScaleY:Number = NaN, textureDisposalQueue:Vector.<Texture> = null):Sprite{

			var scaleFactor:int = Starling.contentScaleFactor;
			dotRadius = dotRadius *= scaleFactor;
			
			var dotEllipse:Sprite = new Sprite();
			var dotPoints:Vector.<Point> = createPolygonPoints(numDotsPerRing, width, height, true, 0);
			var step:Number = Math.PI*2/numDotsPerRing;
			
			var dotTexture:Texture;
			var dot:Shape = new Shape();
			dot.graphics.beginFill(fillColor);
			dot.graphics.drawCircle(dotRadius,dotRadius,dotRadius);
			dot.graphics.endFill();
			dotTexture = getStarlingTextureFromFlashDisplayObject(dot);
			if(textureDisposalQueue) textureDisposalQueue.push(dotTexture);
			
			for (var i:int = 0; i < numDotsPerRing; i++){
				var dotSprite:Sprite = new Sprite();
				dotSprite.addChild(new Image(dotTexture));
				dotSprite.alignPivot();
				dotSprite.x = Math.cos(step*i) * width;
				dotSprite.y = Math.sin(step*i) * height;
				dotSprite.rotation = step*i;
				if(!isNaN(dotScaleX)) dotSprite.scaleX = dotScaleX;
				if(!isNaN(dotScaleY)) dotSprite.scaleY = dotScaleY;
				
				dotEllipse.addChild(dotSprite);
			}
			return dotEllipse;
		}
		
		public static function createCircle(radius:int, color:int = -1, border:Boolean = true, 
											borderLineThickness:int = 1, borderLineColor:int = 0xFFFFFF):Sprite{
			
			var scaleFactor:int = Starling.contentScaleFactor;
			radius *= scaleFactor;
			borderLineThickness *= scaleFactor;
			
			var circle:Sprite;
			var circleShape:Shape = new Shape();
			var circleX:int = border ? radius + borderLineThickness/2 : radius;
			var circleY:int = border ? radius + borderLineThickness/2 : radius;
			
			if(border) circleShape.graphics.lineStyle(borderLineThickness, borderLineColor);
			if(color != -1) circleShape.graphics.beginFill(color);
			circleShape.graphics.drawCircle(circleX,circleY,radius)

			circle = getStarlingSpriteFromFlashDisplayObject(circleShape, false);
			
			return circle;
		}
		
		public static function createCircleWithDropShadow(radius:int, color:int, dropShadowColor:int, distance:int = 4, angle:Number = 0.785, 
												   dropShadowAlpha:Number = 1, border:Boolean = true, borderLineThickness:int = 1, borderLineColor:int = 0xFFFFF):Sprite{
			var scaleFactor:int = Starling.contentScaleFactor;
			var container:Sprite = new Sprite();
			var circle:Sprite = createCircle(radius, color, border, borderLineThickness, borderLineColor);
			var dropShadow:Sprite = createCircle(radius, dropShadowColor, false);
			
			dropShadow.alpha = dropShadowAlpha;
			dropShadow.x = Math.cos(angle) * distance;
			dropShadow.y = Math.sin(angle) * distance;
			container.addChild(dropShadow);
			container.addChild(circle);
			
			return container;
		}
		
		public static function createRoundedRectangle(width:int, height:int, color:int, elipseWidth:int, elipseHeight:int = undefined, border:Boolean = true, 
											borderLineThickness:int = 1, borderLineColor:int = 0xFFFFFF):Sprite{
			
			var scaleFactor:int = Starling.contentScaleFactor;
			var rectangle:Sprite;
			var rectangleShape:Shape = new Shape();
			var circleMC:MovieClip = new MovieClip();
			
			width *= scaleFactor;
			height *= scaleFactor;
			borderLineThickness = borderLineThickness *= scaleFactor;
			
			if(border) rectangleShape.graphics.lineStyle(borderLineThickness, borderLineColor);
			rectangleShape.graphics.beginFill(color);
			rectangleShape.graphics.drawRoundRect(0, 0, width, height, elipseWidth, elipseHeight);
			
			if(border){
				rectangleShape.x += borderLineThickness/2;
				rectangleShape.y += borderLineThickness/2;
			}
			circleMC.addChild(rectangleShape);
			
			rectangle = getStarlingSpriteFromFlashDisplayObject(circleMC, false);
			
			return rectangle;
		}
		
		public static function createRoundedRectangleWithDropShadow(width:int, height:int, color:int, dropShadowColor:int, elipseWidth:int, elipseHeight:int = undefined, 
																	distance:int = 4, angle:Number = 0.785, dropShadowAlpha:Number = 1, border:Boolean = true, 
																	borderLineThickness:int = 1, borderLineColor:int = 0xFFFFF):Sprite{
			var scaleFactor:int = Starling.contentScaleFactor;
			var container:Sprite = new Sprite();
			var roundedRect:Sprite = createRoundedRectangle(width, height, color, elipseWidth, elipseHeight, border, borderLineThickness, borderLineColor);
			var dropShadow:Sprite = createRoundedRectangle(width, height, dropShadowColor, elipseWidth, elipseHeight, false);
			
			dropShadow.alpha = dropShadowAlpha;
			dropShadow.x = Math.cos(angle) * distance;
			dropShadow.y = Math.sin(angle) * distance;
			container.addChild(dropShadow);
			container.addChild(roundedRect);
			
			return container;
		}
		
		public static function createDashedLine(width:int, lineThickness:int, lineColor:int, numDashes:int):Sprite{
			const DASH_TO_SPACE_RATIO:Number = 0.75;
			var scaleFactor:int = Starling.contentScaleFactor;
			width *= scaleFactor;
			lineThickness *= scaleFactor;
			var dashedLine:Sprite;
			var dashedLineShape:Shape = new Shape();
			var dashWidth:Number = width/numDashes * DASH_TO_SPACE_RATIO;
			var segmentWidth:Number = width/numDashes;

			dashedLineShape.graphics.lineStyle(lineThickness, lineColor, 1, false, "normal", CapsStyle.NONE);
			for (var i:int = 0; i < numDashes; i++){
				dashedLineShape.graphics.lineTo(segmentWidth*i+dashWidth,0);
				dashedLineShape.graphics.moveTo(segmentWidth*(i+1),0);
			}
			
			dashedLine = getStarlingSpriteFromFlashDisplayObject(dashedLineShape, false);
			
			return dashedLine;
		}
		
		public static function centerFlashDisplayObjectRegistrationPoint(flashDisplayObject:flash.display.DisplayObject):MovieClip{
			var nativeStage:Stage = Starling.current.nativeStage;
			var flashMc:MovieClip = new MovieClip();
			
			var onStage:Boolean = flashDisplayObject.stage!=null;
			var parent:flash.display.DisplayObject = flashDisplayObject.parent;
		
			if(!onStage) nativeStage.addChild(flashDisplayObject);
			
			var res:Point = new Point();
			var rect:Rectangle = flashDisplayObject.getRect(flashDisplayObject);
			
			res.x=-1*rect.x;
			res.y=-1*rect.y;
			if(!onStage) nativeStage.removeChild(flashDisplayObject);

			flashDisplayObject.x -= flashDisplayObject.width/2 - rect.x;
			flashDisplayObject.y -= flashDisplayObject.height/2 - rect.y;
			flashMc.addChild(flashDisplayObject);
	
			return flashMc;
		}

		/**
		 * Creates a polygon Flash Ellipse
		 * 
		 * @param width The width of the ellipse

		 * @return The ellipse Shape
		 */
		public static function createFlashEllipse(x:int, y:int, width:Number, height:Number, 
												  lineColor:uint = 0xFFFFFF, lineThickness:Number = 1, 
												  lineThicknessVariationPercentage:Number = NaN, lineThicknessVariationOffsetRads:Number = NaN, 
												  fillColor:Number = NaN):MovieClip{
			
			var scaleFactor:int = Starling.contentScaleFactor;
			var ellipseMc:MovieClip = new MovieClip();
			var ellipseShape:Shape = new Shape();
			
			width *= scaleFactor;
			height *= scaleFactor;
			lineThickness *= scaleFactor;
			
			if(!isNaN(fillColor)){
				ellipseShape.graphics.beginFill(fillColor);
				ellipseShape.x += lineThickness/2;
				ellipseShape.y += lineThickness/2;
			}
			if(lineThicknessVariationPercentage){
				var segments:int = 300;
				var step:Number = (Math.PI * 2) / segments;
				var thicknessMultiplier:Number = lineThicknessVariationPercentage/100;
				var thicknessMakeUpAmount:Number = (100 - lineThicknessVariationPercentage)/100 * lineThickness;
				
				if(!lineThicknessVariationOffsetRads){
					lineThicknessVariationOffsetRads = 0;
				}
				
				for(var i:int = 0; i < segments; i++){
					var a:Number = step * i;
					var cx:Number = Math.cos(a) * width/2 + x;
					var cy:Number = Math.sin(a) * height/2 + y;
					var thickness:Number = ((Math.sin(a+lineThicknessVariationOffsetRads) * lineThickness) + lineThickness)/2 * thicknessMultiplier + thicknessMakeUpAmount;

					ellipseShape.graphics.lineStyle(thickness, lineColor);
					if(i == 0) ellipseShape.graphics.moveTo(cx,cy);
					ellipseShape.graphics.lineTo(cx,cy);
					if(i == segments-1)ellipseShape.graphics.lineTo((width/2 + x),y);
				}

				var xLineThicknessOffset:Number = (((Math.sin(Math.PI+lineThicknessVariationOffsetRads)*lineThickness)/2 + lineThickness) * 
					thicknessMultiplier + thicknessMakeUpAmount)/2;
				var yLineThicknessOffset:Number = (((Math.cos(Math.PI+lineThicknessVariationOffsetRads)*lineThickness)/2 + lineThickness) * 
					thicknessMultiplier + thicknessMakeUpAmount)/2;
				
				ellipseShape.x += width/2 + xLineThicknessOffset;
				ellipseShape.y += height/2 + yLineThicknessOffset;
				
			} else {
				ellipseShape.graphics.lineStyle(lineThickness, lineColor);
				ellipseShape.graphics.drawEllipse(x,y,width,height);
			}
			
			ellipseShape.graphics.endFill();
			ellipseMc.addChild(ellipseShape); //need flash mc to nudge shape and compensate for line thickness
			
			return ellipseMc;
		}

		public static function createFlashPolygon(numSides:uint, width:Number, height:Number, rotationInRads:Number, 
											lineColor:uint = 0xFFFFFF, lineThickness:Number = 1, center:Boolean = true, 
											fillColor:Number = NaN, curve:Boolean = false):flash.display.Shape{
			
			var polygon:flash.display.Shape = new flash.display.Shape();
			var points:Vector.<Point> = createPolygonPoints(numSides, width, height, center, rotationInRads);
			
			var len:int = points.length;
			
			polygon.graphics.moveTo(points[len-1].x, points[len-1].y);
			if(lineThickness) polygon.graphics.lineStyle(lineThickness, lineColor);
			if(fillColor){
				polygon.graphics.beginFill(fillColor);
			}
			
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
			
			return polygon;
		}
		
		
		/**
		 * Creates a Flash circle Shape at registration point 0,0;
		 * 
		 * @param width The width of the ellipse
		 
		 * @return The Flash circle Shape
		 */
		public static function createFlashGradientCircle(radius:Number, gradientColors:Array, alphas:Array, ratios:Array, 
														 fillType:String = GradientType.LINEAR, spreadMethod:String = SpreadMethod.PAD, 
														 center:Boolean = true, matrix:Matrix = null, focalPointRatio:Number = 0):flash.display.Shape{
			var scaleFactor:int = Starling.contentScaleFactor;
			radius *= scaleFactor;
			if(gradientColors == null) gradientColors = [0x000000, 0xFFFFFF];
			if(alphas == null) alphas = [1,1];
			if(ratios == null) ratios = [1,255];
			if(matrix == null && fillType == GradientType.RADIAL){
				matrix = new Matrix();
				matrix.createGradientBox(radius*2,radius*2);
			}
			
			var gradientCircle:Shape = new Shape();
			gradientCircle.graphics.beginGradientFill(fillType, gradientColors, alphas, ratios, matrix, spreadMethod, "rgb", focalPointRatio);
			gradientCircle.graphics.drawCircle(radius,radius,radius);
			
			return gradientCircle;
		}
		
		
		public static function createFlashGradientPolygon(numSides:uint, width:Number, height:Number, rotationInRads:Number, 
												   gradientColors:Array, center:Boolean = true, curve:Boolean = false, curveOut:Boolean = true):flash.display.Shape{
			
			var polygon:flash.display.Shape = new flash.display.Shape();
			var points:Vector.<Point> = createPolygonPoints(numSides, width, height, center, rotationInRads);
			var len:int = points.length;
			
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [gradientColors[0], gradientColors[1]];
			var alphas:Array = [1, 1];
			var ratios:Array = [45, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(width,height/1.6,Math.PI/2);
			var spreadMethod:String = SpreadMethod.REFLECT;
			polygon.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			
			polygon.graphics.moveTo(points[len-1].x, points[len-1].y);
			
			
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
			
			return polygon;
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