package com.destroytoday.twitteraspirin {
	import com.destroytoday.pool.ObjectPool;
	import com.destroytoday.twitteraspirin.net.StringLoaderPool;
	import com.destroytoday.twitteraspirin.net.XMLLoaderPool;
	import com.destroytoday.twitteraspirin.oauth.OAuth;
	
	import org.robotlegs.base.ContextBase;
	import org.robotlegs.base.SignalCommandMap;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.ISignalCommandMap;
	import org.robotlegs.core.ISignalContext;
	
	/**
	 * The TwitterContext class sets up the class maps.
	 * @author Jonnie Hallman
	 */	
	public class TwitterContext extends ContextBase implements ISignalContext {
		/**
		 * @private 
		 */		
		protected var twitter:Twitter;
		
		/**
		 * @private 
		 */		
		protected var _signalCommandMap:ISignalCommandMap;
		
		/**
		 * Instantiates the TwitterContext instance. 
		 * @param twitter the Twitter instance to map
		 */		
		public function TwitterContext(twitter:Twitter) {
			this.twitter = twitter;
			
			startup();
		}
		
		/**
		 * @private
		 */		
		protected function startup():void {
			injector.mapValue(ISignalCommandMap, signalCommandMap);

			injector.mapValue(Twitter, twitter);
			injector.mapValue(StringLoaderPool, twitter.stringLoaderPool);
			injector.mapValue(XMLLoaderPool, twitter.xmlLoaderPool);
			injector.mapValue(OAuth, twitter.oauth);
			
			injector.injectInto(twitter.oauth);
		}
		
		/**
		 * SignalCommandMap
		 * //TODO
		 * @return 
		 */		
		public function get signalCommandMap():ISignalCommandMap {
			return _signalCommandMap || (_signalCommandMap = new SignalCommandMap(injector));
		}

		/**
		 * @private
		 * @param value
		 */		
		public function set signalCommandMap(value:ISignalCommandMap):void {
			_signalCommandMap = value;
		}
	}
}