package com.destroytoday.twitteraspirin {
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.pool.ObjectPool;
	import com.destroytoday.twitteraspirin.oauth.OAuth;
	
	import org.iotashan.oauth.OAuthConsumer;

	/**
	 * The Twitter class
	 * @author Jonnie Hallman
	 */	
	public class Twitter {
		//
		// Instances
		//
		
		/**
		 * @private
		 */		
		protected var _oauth:OAuth;
		
		/**
		 * Instantiates the Twitter class.
		 * @param consumerKey the consumer key for the Twitter application
		 * @param consumerSecret the consumer secret for the Twitter application
		 */		
		public function Twitter(consumerKey:String = null, consumerSecret:String = null) {
			if (consumerKey && consumerSecret) {
				setConsumerInfo(consumerKey, consumerSecret);
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
		
		//
		// Methods
		//
		
		/**
		 * Sets the consumer information for the Twitter application.
		 * @param consumerKey the consumer key for the Twitter application
		 * @param consumerSecret the consumer secret for the Twitter application
		 */		
		public function setConsumerInfo(consumerKey:String, consumerSecret:String):void {
			//TODO - if _oauth exists, dispose and recycle
			
			_oauth = new OAuth(consumerKey, consumerSecret);
		}
	}
}