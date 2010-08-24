package com.destroytoday.twitteraspirin.net {
	import com.destroytoday.net.StringLoader;
	import com.destroytoday.pool.ObjectPool;
	
	/**
	 * The StringLoaderPool class extends the ObjectPool class for injection purposes.
	 * @author Jonnie Hallman
	 */	
	public class StringLoaderPool extends ObjectPool {
		public function StringLoaderPool(type:Class) {
			super(type);
		}
		
		override public function getObject(weak:Boolean=true):Object {
			var loader:StringLoader = super.getObject(weak) as StringLoader;
			
			loader.includeResponseInfo = true;
			
			return loader;
		}
	}
}