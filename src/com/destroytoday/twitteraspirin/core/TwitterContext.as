package com.destroytoday.twitteraspirin.core {
	import com.destroytoday.pool.ObjectPool;
	import com.destroytoday.twitteraspirin.Twitter;
	import com.destroytoday.twitteraspirin.commands.StartupCommand;
	import com.destroytoday.twitteraspirin.net.StringLoaderPool;
	import com.destroytoday.twitteraspirin.net.XMLLoaderPool;
	import com.destroytoday.twitteraspirin.oauth.OAuth;
	import com.destroytoday.twitteraspirin.signals.AccountCallsSignal;
	import com.destroytoday.twitteraspirin.signals.StartupSignal;
	
	import org.osflash.signals.Signal;
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
			
			injector.mapSingleton(AccountCallsSignal);
			
			injector.mapValue(Twitter, twitter);
			injector.mapValue(StringLoaderPool, twitter.stringLoaderPool);
			injector.mapValue(XMLLoaderPool, twitter.xmlLoaderPool);
			injector.mapValue(OAuth, twitter.oauth);
			injector.mapValue(Account, twitter.account);
			injector.mapValue(Users, twitter.users);
			injector.mapValue(Statuses, twitter.statuses);

			injector.injectInto(twitter.oauth);
			injector.injectInto(twitter.account);
			injector.injectInto(twitter.users);
			injector.injectInto(twitter.statuses);
			
			//TEMP
			twitter.account.setupListeners();
			
			//StartupSignal(signalCommandMap.mapSignalClass(StartupSignal, StartupCommand, true)).dispatch();
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