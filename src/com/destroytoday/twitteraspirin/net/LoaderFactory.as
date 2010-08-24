package com.destroytoday.twitteraspirin.net {
	import com.destroytoday.net.GenericLoader;
	import com.destroytoday.net.GenericLoaderError;
	import com.destroytoday.net.StringLoader;
	import com.destroytoday.net.XMLLoader;
	
	import flash.net.URLRequestHeader;

	/**
	 * The LoaderFactory class manages loader instantiation and recycling.
	 * @author Jonnie Hallman
	 */	
	public class LoaderFactory {
		/**
		 * @private 
		 */		
		protected var xmlLoaderPool:XMLLoaderPool = new XMLLoaderPool(XMLLoader);
		
		/**
		 * @private 
		 */		
		protected var stringLoaderPool:StringLoaderPool = new StringLoaderPool(StringLoader);
		
		/**
		 * Constructs the LoaderFactory instance.
		 */		
		public function LoaderFactory() {
		}
		
		/**
		 * Returns an XMLLoader instance that will be disposed upon complete, error, and cancel.
		 * @param completeHandler
		 * @return 
		 */		
		public function getXMLLoader(completeHandler:Function, errorHandler:Function):XMLLoader {
			var loader:XMLLoader = xmlLoaderPool.getObject() as XMLLoader;
			
			addListeners(loader, completeHandler, errorHandler);
			
			return loader;
		}
		
		/**
		 * Returns a StringLoader instance that will be disposed upon complete, error, and cancel. 
		 * @param completeHandler
		 * @return 
		 */		
		public function getStringLoader(completeHandler:Function, errorHandler:Function):StringLoader {
			var loader:StringLoader = stringLoaderPool.getObject() as StringLoader;
			
			addListeners(loader, completeHandler, errorHandler);
			
			return loader;
		}
		
		/**
		 * @private
		 * @param loader
		 * @param completeHandler
		 */		
		protected function addListeners(loader:GenericLoader, completeHandler:Function, errorHandler:Function):void {
			loader.completeSignal.add(completeHandler);
			loader.completeSignal.add(this.completeHandler);
			loader.errorSignal.add(errorHandler);
			loader.errorSignal.add(this.errorHandler);
		}
		
		/**
		 * @private
		 * @param loader
		 */		
		public function disposeLoader(loader:GenericLoader):void {
			if (loader is XMLLoader) {
				xmlLoaderPool.disposeObject(loader);
			} else if (loader is StringLoader) {
				stringLoaderPool.disposeObject(loader);
			}
		}
		
		/**
		 * @private
		 * @param loader
		 * @param data
		 */		
		protected function completeHandler(loader:GenericLoader, data:*):void {
			if (loader.includeResponseInfo && loader.responseStatus == 200) {
				var remainingCalls:int, totalCalls:int;
				var callsResetDate:Date;

				for each(var header:URLRequestHeader in loader.responseHeaders) {
					if (header.name == "X-Ratelimit-Remaining") {
						remainingCalls = int(header.value);
					} else if (header.name == "X-Ratelimit-Limit") {
						totalCalls = int(header.value);
					} else if (header.name == "X-Ratelimit-Reset") {
						callsResetDate = new Date(int(header.value) * 1000);
					}
				}
				
				if (remainingCalls > -1 && totalCalls > -1 && callsResetDate) {
					//account.gotCallInfo.dispatch(remainingCalls, totalCalls, callsResetDate);
				}
			}
			
			if (!loader.storage || !loader.storage.asyncParse) disposeLoader(loader);
		}
		
		/**
		 * @private
		 * @param loader
		 * @param type
		 * @param message
		 */		
		protected function errorHandler(loader:GenericLoader, type:String, message:String):void {
			// If the loader is set to retry, don't dispose unless the retry count has been exceeded.
			if (loader.retryCount == 0 || type == GenericLoaderError.RETRY_COUNT) {
				disposeLoader(loader);
			}
		}
		
		/**
		 * @private
		 * @param loader
		 */		
		protected function cancelHandler(loader:GenericLoader):void {
			disposeLoader(loader);
		}
	}
}