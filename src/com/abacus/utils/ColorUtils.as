package com.abacus.utils
{
	import flash.filters.ColorMatrixFilter;

	public class ColorUtils{
		
		public function ColorUtils(){
		}
		
		public static function brightenColor(hexColor:Number, percent:Number):Number{
			if(isNaN(percent))
				percent=0;
			if(percent>100)
				percent=100;
			if(percent<0)
				percent=0;
			
			var factor:Number=percent/100;
			var rgb:Object=hexToRgb(hexColor);
			
			rgb.r+=(255-rgb.r)*factor;
			rgb.b+=(255-rgb.b)*factor;
			rgb.g+=(255-rgb.g)*factor;
			
			return rgbToHex(Math.round(rgb.r),Math.round(rgb.g),Math.round(rgb.b));
		}
		
		public static function darkenColor(hexColor:Number, percent:Number):Number{
			if(isNaN(percent))
				percent=0;
			if(percent>100)
				percent=100;
			if(percent<0)
				percent=0;
			
			var factor:Number=1-(percent/100);
			var rgb:Object=hexToRgb(hexColor);
			
			rgb.r*=factor;
			rgb.b*=factor;
			rgb.g*=factor;
			
			return rgbToHex(Math.round(rgb.r),Math.round(rgb.g),Math.round(rgb.b));
		}
		
		public static function rgbToHex(r:Number, g:Number, b:Number):Number {
			return(r<<16 | g<<8 | b);
		}
		
		public static function hexToRgb (hex:Number):Object{
			return {r:(hex & 0xff0000) >> 16,g:(hex & 0x00ff00) >> 8,b:hex & 0x0000ff};
		}
		
		public static function brightness(hex:Number):Number{
			var max:Number=0;
			var rgb:Object=hexToRgb(hex);
			if(rgb.r>max)
				max=rgb.r;
			if(rgb.g>max)
				max=rgb.g;
			if(rgb.b>max)
				max=rgb.b;
			max/=255;
			return max;
		}
		
		public static function interpolateColor(fromColor:uint, toColor:uint, progress:Number):uint{         
			var q:Number = 1-progress;         
			var fromA:uint = (fromColor >> 24) & 0xFF;         
			var fromR:uint = (fromColor >> 16) & 0xFF;         
			var fromG:uint = (fromColor >>  8) & 0xFF;         
			var fromB:uint =  fromColor        & 0xFF;         
			var toA:uint = (toColor >> 24) & 0xFF;         
			var toR:uint = (toColor >> 16) & 0xFF;         
			var toG:uint = (toColor >>  8) & 0xFF;         
			var toB:uint =  toColor        & 0xFF;                 
			var resultA:uint = fromA*q + toA*progress;         
			var resultR:uint = fromR*q + toR*progress;         
			var resultG:uint = fromG*q + toG*progress;         
			var resultB:uint = fromB*q + toB*progress;         
			var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;         
			return resultColor;       
		}
		
		
		/**
		 * Interpolates between two colors.  Randomizes the target colors' brightness, then interpolates.
		 * 
		 * @return uint The interpolated and randomized hex color
		 * @param color1 The first target color
		 * @param color2 The second target color
		 * @param progress The interpolation target between color1 and color2. Input values are 0 - 1.0
		 * @param randomizationStrength The strength of the randomization
		 */
		public static function interpolationRandomizer(color1:uint, color2:uint, progress:Number, randomizationStrength:Number = 10):uint{
			var returnColor:uint;
			
			var randomizeColor1:uint = ColorUtils.interpolateColor(ColorUtils.darkenColor(color1, Math.random()*randomizationStrength), 
				ColorUtils.brightenColor(color1, Math.random()*randomizationStrength), 1);
			var randomizeColor2:uint = ColorUtils.interpolateColor(ColorUtils.darkenColor(color2, Math.random()*randomizationStrength), 
				ColorUtils.brightenColor(color2, Math.random()*randomizationStrength), 1);
			
			returnColor = ColorUtils.interpolateColor(randomizeColor1, randomizeColor2, progress);
			
			return returnColor;
		}
			
		public static function setBrightness(value:Number):ColorMatrixFilter
		{
			value = value*(255/250);
			
			var m:Array = new Array();
			m = m.concat([1, 0, 0, 0, value]);	// red
			m = m.concat([0, 1, 0, 0, value]);	// green
			m = m.concat([0, 0, 1, 0, value]);	// blue
			m = m.concat([0, 0, 0, 1, 0]);		// alpha
			
			return new ColorMatrixFilter(m);
		}
		
		/**
		 * sets contrast value available are -100 ~ 100 @default is 0
		 * @param 		value:int	contrast value
		 * @return		ColorMatrixFilter
		 */
		public static function setContrast(value:Number):ColorMatrixFilter
		{
			value /= 100;
			var s: Number = value + 1;
			var o : Number = 128 * (1 - s);
			
			var m:Array = new Array();
			m = m.concat([s, 0, 0, 0, o]);	// red
			m = m.concat([0, s, 0, 0, o]);	// green
			m = m.concat([0, 0, s, 0, o]);	// blue
			m = m.concat([0, 0, 0, 1, 0]);	// alpha
			
			return new ColorMatrixFilter(m);
		}
		
		/**
		 * sets saturation value available are -100 ~ 100 @default is 0
		 * @param 		value:int	saturation value
		 * @return		ColorMatrixFilter
		 */
		public static function setSaturation(value:Number):ColorMatrixFilter
		{
			const lumaR:Number = 0.212671;
			const lumaG:Number = 0.71516;
			const lumaB:Number = 0.072169;
			
			var v:Number = (value/100) + 1;
			var i:Number = (1 - v);
			var r:Number = (i * lumaR);
			var g:Number = (i * lumaG);
			var b:Number = (i * lumaB);
			
			var m:Array = new Array();
			m = m.concat([(r + v), g, b, 0, 0]);	// red
			m = m.concat([r, (g + v), b, 0, 0]);	// green
			m = m.concat([r, g, (b + v), 0, 0]);	// blue
			m = m.concat([0, 0, 0, 1, 0]);			// alpha
			
			return new ColorMatrixFilter(m);
		}
	
		public static function RGBToHex(r:uint, g:uint, b:uint):uint{
			var hex:uint = (r << 16 | g << 8 | b);
			return hex;
		}
		
		public static function HEXtoGreyScale(c:uint):uint{
			var r:Number=extractRedFromHEX(c);
			var g:Number=extractGreenFromHEX(c);
			var b:Number=extractBlueFromHEX(c);
			
			var av:Number = (r + g + b) / 3;
			
			r = g = b = av;
			
			return RGBToHex(r, g, b);
		}
		
		public static function extractRedFromHEX(c:uint):uint{
			return (( c >> 16 ) & 0xFF);
		}
		
		public static function extractGreenFromHEX(c:uint):uint{
			return ( (c >> 8) & 0xFF );
		}
		
		public static function extractBlueFromHEX(c:uint):uint{
			return ( c & 0xFF );
		}
		
		//////////////////////
			
		public static function RGBtoHSB(_rgb:uint):Object {
			var red:Number = ((_rgb >> 16) & 0xFF) / 255.0;
			var green:Number = ((_rgb >> 8) & 0xFF) / 255.0;
			var blue:Number = ((_rgb) & 0xFF) / 255.0;
			
			var dmax:Number = Math.max(Math.max(red, green), blue);
			var dmin:Number = Math.min(Math.min(red, green), blue);
			var range:Number = dmax - dmin;
			
			var bright:Number = dmax;
			var sat:Number = 0.0;
			var hue:Number = 0.0;
			
			if (dmax != 0.0) {
				sat = range / dmax;
			}
			
			if (sat != 0.0) {
				if (red == dmax) {
					hue = (green - blue) / range;
				}else if (green == dmax) {
					hue = 2.0 + (blue - red) / range;
				}else if (blue == dmax) {
					hue = 4.0 + (red - green) / range;
				}
				
				hue = hue * 60;
				if (hue < 0.0) {
					hue = hue + 360.0;
				}
			}
			
			return { "v":bright, "s":sat, "h":hue };
		}
		
		public static function HSBtoRGB(_hue:Number, _sat:Number, _value:Number):uint {
			var red:Number = 0.0;
			var green:Number = 0.0;
			var blue:Number = 0.0;
			
			if (_sat == 0.0) {
				red = _value;
				green = _value;
				blue = _value;
			}else {
				if (_hue == 360.0) {
					_hue = 0;
				}
				
				var slice:int = _hue / 60.0;
				var hue_frac:Number = (_hue / 60.0) - slice;
				
				var aa:Number = _value * (1.0 - _sat);
				var bb:Number = _value * (1.0 - _sat * hue_frac);
				var cc:Number = _value * (1.0 - _sat * (1.0 - hue_frac));
				switch(slice) {
					case 0:
						red = _value;
						green = cc;
						blue = aa;
						break;
					case 1:
						red = bb;
						green = _value;
						blue = aa;
						break;
					case 2:
						red = aa;
						green = _value;
						blue = cc;
						break;
					case 3:
						red = aa;
						green = bb;
						blue = _value;
						break;
					case 4:
						red = cc;
						green = aa;
						blue = _value;
						break;
					case 5:
						red = _value;
						green = aa;
						blue = bb;
						break;
					default:
						red = 0.0;
						green = 0.0;
						blue = 0.0;
						break;
				}
			}
			
			var ired:Number = red * 255.0;
			var igreen:Number = green * 255.0;
			var iblue:Number = blue * 255.0;

			if(ired < 0) ired = 0;
			if(igreen < 0) igreen = 0;
			if(iblue < 0) iblue = 0;
			
			if(ired > 224) ired = 224;
			if(igreen > 224) igreen = 224;
			if(iblue > 224) iblue = 224;
			
			return ((ired << 16) | (igreen << 8) | (iblue));
		}

		
	}
}