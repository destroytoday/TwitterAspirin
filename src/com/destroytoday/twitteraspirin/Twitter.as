package com.destroytoday.twitteraspirin {
	import com.destroytoday.net.StringLoader;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.pool.ObjectPool;
	import com.destroytoday.twitteraspirin.core.Account;
	import com.destroytoday.twitteraspirin.core.TwitterContext;
	import com.destroytoday.twitteraspirin.core.Users;
	import com.destroytoday.twitteraspirin.net.StringLoaderPool;
	import com.destroytoday.twitteraspirin.net.XMLLoaderPool;
	import com.destroytoday.twitteraspirin.oauth.OAuth;
	
	import org.iotashan.oauth.OAuthConsumer;
	import org.robotlegs.base.ContextBase;
	import org.robotlegs.core.IContext;

	/**
	 * The Twitter class
	 * @author Jonnie Hallman
	 */	
	public class Twitter {
		public namespace twitter;
		
		//
		// Instances
		//
		
		/**
		 * @private 
		 */		
		protected var context:TwitterContext;
		
		/**
		 * @private
		 */		
		protected var _oauth:OAuth = new OAuth();
		
		/**
		 * @private 
		 */		
		protected var _account:Account = new Account();
		
		/**
		 * @private 
		 */		
		protected var _users:Users = new Users();

		/**
		 * @private 
		 */		
		protected var _stringLoaderPool:StringLoaderPool = new StringLoaderPool(StringLoader);

		/**
		 * @private 
		 */		
		protected var _xmlLoaderPool:XMLLoaderPool = new XMLLoaderPool(XMLLoader);
		
		/**
		 * Instantiates the Twitter class.
		 * @param consumerKey the consumer key for the Twitter application
		 * @param consumerSecret the consumer secret for the Twitter application
		 */		
		public function Twitter(consumerKey:String = null, consumerSecret:String = null) {
			context = new TwitterContext(this);
			
			if (consumerKey && consumerSecret) {
				oauth.setConsumerCredentials(consumerKey, consumerSecret);
			}
		}
		
		//
		// Instance getters
		//
		
		/**
		 * Returns the OAuth instance.
		 * @return 
		 */		
		public function get oauth():OAuth {
			return _oauth;
		}
		
		/**
		 * Returns the Account instance. 
		 * @return 
		 */		
		public function get account():Account {
			return _account;
		}
		
		/**
		 * Returns the Users instance. 
		 * @return 
		 * 
		 */		
		public function get users():Users {
			return _users;
		}
		
		/**
		 * @private
		 * Returns the StringLoader pool.
		 * @return 
		 */		
		public function get stringLoaderPool():StringLoaderPool {
			return _stringLoaderPool;
		}

		/**
		 * @private
		 * Returns the XMLLoader pool.
		 * @return 
		 */		
		public function get xmlLoaderPool():XMLLoaderPool {
			return _xmlLoaderPool;
		}
	}
}