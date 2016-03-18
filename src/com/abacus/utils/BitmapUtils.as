package com.abacus.utils
{
	import flash.display.BitmapData;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Stage;

	public class BitmapUtils{
		
		public function BitmapUtils(){
		}
		
		public static function takeScreenshot(scl:Number=1.0):BitmapData{
			var stage:Stage = Starling.current.stage;
			var width:Number = stage.stageWidth;
			var height:Number = stage.stageHeight;
			
			var rs:RenderSupport = new RenderSupport();
			
			rs.clear(stage.color, 1.0);
			rs.scaleMatrix(scl, scl);
			rs.setProjectionMatrix(0, 0, width, height);
			
			stage.render(rs, 1.0);
			rs.finishQuadBatch();
			
			var outBmp:BitmapData = new BitmapData(width*scl, height*scl, true);
			Starling.context.drawToBitmapData(outBmp);
			
			return outBmp;
		}
		
	}
}