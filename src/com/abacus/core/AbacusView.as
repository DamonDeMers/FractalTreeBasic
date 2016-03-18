package com.abacus.core{
	
	public class AbacusView extends AbacusSprite{
		
		public function AbacusView(scaleForMultiResolution:Boolean = false){
			super(scaleForMultiResolution);
		}
		
		public function init():void{
			throw new Error("This is an abstract method.  Override in the sublcass");
		}
		
		public function close():void{
			this.dispose();
		}
	}
}