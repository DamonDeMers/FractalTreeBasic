package com.abacus.utils
{
	import starling.core.Starling;

	public class AudioUtils{
		
		public static const SAMPLE_RATE:int = 44100;
		public static const BUFFER_SIZE:int = 8192;
		
		public static const SECONDS_IN_MINUTE:int = 60;
		public static const NUM_MEASURES_IN_BAR:int = 4;
		public static const NUM_WHOLE_NOTES_IN_A_MEASURE:int = 1;
		public static const NUM_HALF_NOTES_IN_A_MEASURE:int = 2;
		public static const NUM_QUARTER_NOTES_IN_A_MEASURE:int = 4;
		public static const NUM_EIGHTH_NOTES_IN_A_MEASURE:int = 8;
		
		public static const CHROMATIC_SCALE:Array = ["C", "Cs", "D", "Eb", "F", "Fs", "G", "Gs", "A", "Bb", "B", "C2"];
		
		public function AudioUtils(){
		}
		
		public static function secondsPerFrame():Number{
			return 1/Starling.current.nativeStage.frameRate;
		}
		
		public static function convertMeasureToSeconds(bpm:Number):Number{
			return SECONDS_IN_MINUTE/bpm;
		}
		
		public static function convertEighthNoteToSeconds(bpm:Number, numBeats:int):Number{
			return numBeats * SECONDS_IN_MINUTE/bpm/2;
		}
		
		public static function convertEighthToSamples(bpm:Number, numBeats:int):int{
			return numBeats * SECONDS_IN_MINUTE/bpm/2 * SAMPLE_RATE;
		}
	}
}