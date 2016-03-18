package com.abacus.utils{
	
	import com.abacus.consts.AppConsts;
	import com.abacus.core.AbacusSprite;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.core.FeathersControl;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;

	public class LayoutUtils extends DisplayObject{
		
		/** static */
		public static const ALIGN_TOP_LEFT:String = "alingTopLeft";
		public static const ALIGN_TOP_CENTER:String = "alingTopCenter";
		public static const ALIGN_TOP_RIGHT:String = "alingTopRight";
		public static const ALIGN_CENTER_LEFT:String = "alingLeftCenter";
		public static const ALIGN_CENTER:String = "alingCenter";
		public static const ALIGN_CENTER_RIGHT:String = "alingRightCenter";
		public static const ALIGN_BOTTOM_LEFT:String = "alingBottomLeft";
		public static const ALIGN_BOTTOM_CENTER:String = "alingBottomCenter";
		public static const ALIGN_BOTTOM_RIGHT:String = "alingBottomRight";

		public function LayoutUtils(){}
		
		/** Layout DisplayObjects on the stage or relative to a reference DisplayObject
		 *  
		 *  @param source           The DisplayObject to be laid out
		 *  @param align            A String designating the alignment.  Ex. LayoutUtils.ALIGN_CENTER_RIGHT
		 *  @param padding          A Number designating the alignment padding in points (viewport).  Padding nudges the source away from corners.
		 *                    
		 *  @param alignReference   The DisplayObjectContainer used as a reference from the alignment.  The alignReference defaults to the current
		 * 							Starling stage if not assigned.  If this alignReference is assigned, the layout function will align the source
		 * 							to the alignReference object - ex. a container, modal, or view element.
		 */
		public static function layout(source:DisplayObject, align:String, padding:Number = 0, alignReference:DisplayObjectContainer = null):void{
			var toX:Number = 0;
			var toY:Number = 0;

			//add source temporarily if not yet added to stage
			var hasSource:Boolean = source.parent != null;
			if(!hasSource) Starling.current.stage.addChild(source);
			
			var sourceW:Number = source.getBounds(Starling.current.stage).width; 
			var sourceH:Number = source.getBounds(Starling.current.stage).height;
			var sourcePivotX:Number = source.pivotX;
			var sourcePivotY:Number = source.pivotY;
			var sourceScale:Number = source.getBounds(Starling.current.stage).width/source.width * source.scaleX;
			var alignReferenceRect:Rectangle;
			var stage:Stage = Starling.current.stage;

			if(!alignReference){ 
				// default align reference is Starling stage
				alignReference = Starling.current.stage;
				alignReferenceRect = alignReference.getBounds(stage);
				alignReferenceRect.x = 0;
				alignReferenceRect.y = 0;
				alignReferenceRect.width = appWidth();
				alignReferenceRect.height = appHeight();
			} else if (alignReference == source){
				throw ArgumentError("source and alignReference can not be same object");
			} else {
				checkIfAlignReferenceIsParentOfSource(source);
			}
			
			function checkIfAlignReferenceIsParentOfSource(dispObj:DisplayObject):void{
				if(alignReference == dispObj.parent){
					//temporarily remove source from reference to get accurate bounds
					var index:int = alignReference.getChildIndex(dispObj);
					alignReference.removeChildAt(index);
					alignReferenceRect = alignReference.getBounds(stage);
					alignReference.addChildAt(dispObj, index);
				}
				else if(dispObj.parent){
					//recurse parent
					checkIfAlignReferenceIsParentOfSource(dispObj.parent);
				} else {
					//otherwise assign ref rect
					alignReferenceRect = alignReference.getBounds(stage);
				}
			}

			//validate Feather's object to get correct size
			if(source is FeathersControl){FeathersControl(source).validate()};
			
			//scale padding and pivots
			if(source is AbacusSprite && AbacusSprite(source).isScaledForMultiResolution) padding *= sourceScale;
			sourcePivotX *= sourceScale;
			sourcePivotY *= sourceScale;
			
			switch(align){
				case ALIGN_TOP_LEFT:
					toX = sourcePivotX + padding;
					toY = sourcePivotY + padding;
					break;
				case ALIGN_TOP_CENTER:
					toX =alignReferenceRect.width/2 - sourceW/2 + sourcePivotX;
					toY = sourcePivotY + padding;
					break;
				case ALIGN_TOP_RIGHT:
					toX = alignReferenceRect.width - sourceW + sourcePivotX - padding;
					toY = sourcePivotY + padding;
					break;
				case ALIGN_CENTER_LEFT:
					toX = sourcePivotX + padding;
					toY = alignReferenceRect.height/2 - sourceH/2 + sourcePivotY;
					break;
				case ALIGN_CENTER:
					toX = alignReferenceRect.width/2 - sourceW/2 + sourcePivotX;
					toY = alignReferenceRect.height/2 - sourceH/2 + sourcePivotY;
					break;
				case ALIGN_CENTER_RIGHT:
					toX = alignReferenceRect.width - sourceW + sourcePivotX - padding;
					toY = alignReferenceRect.height/2 - sourceH/2 + sourcePivotY;
					break;
				case ALIGN_BOTTOM_LEFT:
					toX = sourcePivotX + padding;
					toY = alignReferenceRect.height - sourceH + sourcePivotY - padding;
					break;
				case ALIGN_BOTTOM_CENTER:
					toX = alignReferenceRect.width/2 - sourceW/2 + sourcePivotX;
					toY = alignReferenceRect.height - sourceH + sourcePivotY - padding;
					break;
				case ALIGN_BOTTOM_RIGHT:
					toX = alignReferenceRect.width - sourceW + sourcePivotX - padding;
					toY = alignReferenceRect.height - sourceH + sourcePivotY - padding;
					break;
			}
			
			toX += alignReferenceRect.x;
			toY += alignReferenceRect.y;

			var globalPoint:Point = new Point(toX, toY);
			source.x = source.parent.globalToLocal(globalPoint).x;
			source.y = source.parent.globalToLocal(globalPoint).y;
			
			//remove source if not yet added to stage
			if(!hasSource) Starling.current.stage.removeChild(source);
		}

		/** Calculates the scale for the native device based on the design width and height values
		 * 
		 *  @param designWidth       An int designating the base width value used for designing the application
		 *  @param designHeight      An int designating the base height value used for designing the application
		 */
		public static function multiResolutionScaleFactor(designWidth:int = AppConsts.DESIGN_WIDTH, designHeight:int = AppConsts.DESIGN_HEIGHT):Number{
			var scale:Number;
			var appWidth:int = Starling.current.stage.stageWidth;
			var appHeight:int = Starling.current.stage.stageHeight;
			var widthRatio:Number = appWidth/designWidth;
			var heightRatio:Number = appHeight/designHeight;
			
			scale = widthRatio < heightRatio ? widthRatio : heightRatio;
			
			return scale;
		}
		
		public static function multiResolutionPixelValue(value:Number):Number{
			return value * multiResolutionScaleFactor();
		}
		
		public static function fitScaleFromBounds(targetBounds:Rectangle, referenceBounds:Rectangle, scale:Number):Number{
			var largestTargetDimension:Number = targetBounds.width > targetBounds.height ? targetBounds.width : targetBounds.height;
			var smallestRefDimension:Number = referenceBounds.width < referenceBounds.height ? referenceBounds.width : referenceBounds.height;
			var ratio:Number = (scale * smallestRefDimension)/largestTargetDimension;
			return ratio;
		}
		
		/** Returns the stageWidth value of the application */
		public static function appWidth():int{
			return Starling.current.stage.stageWidth;
		}
		
		/** Returns the stageHeight value of the application */
		public static function appHeight():int{
			return Starling.current.stage.stageHeight;
		}
		
		/** Returns the half the stageWidth */
		public static function centerStageX():int{
			return Starling.current.stage.stageWidth/2
		}
		
		/** Returns the half the stageHeight */
		public static function centerStageY():int{
			return Starling.current.stage.stageHeight/2;
		}
		
	}
}