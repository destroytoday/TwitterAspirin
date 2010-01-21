package com.destroytoday.twitteraspirin.net {
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.pool.ObjectPool;
	
	/**
	 * The XMLLoaderPool class extends the ObjectPool class for injection purposes.
	 * @author Jonnie Hallman
	 */	
	public class XMLLoaderPool extends ObjectPool {
		public function XMLLoaderPool(type:Class) {
			super(type);
		}
		
		override public function getObject(weak:Boolean=true):Object {
			var loader:XMLLoader = super.getObject(weak) as XMLLoader;
			
			loader.includeResponseInfo = true;
			
			return loader;
		}
	}
}