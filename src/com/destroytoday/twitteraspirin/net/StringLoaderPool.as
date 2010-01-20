package com.destroytoday.twitteraspirin.net {
	import com.destroytoday.pool.ObjectPool;
	
	/**
	 * The StringLoaderPool class extends the ObjectPool class for injection purposes.
	 * @author Jonnie Hallman
	 */	
	public class StringLoaderPool extends ObjectPool {
		public function StringLoaderPool(type:Class) {
			super(type);
		}
	}
}