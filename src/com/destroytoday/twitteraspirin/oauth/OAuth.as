package com.destroytoday.twitteraspirin.oauth {
	import com.destroytoday.net.StringLoader;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.pool.ObjectPool;
	import com.destroytoday.twitteraspirin.Twitter;
	import com.destroytoday.twitteraspirin.constants.TwitterURL;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;
	import org.iotashan.utils.OAuthUtil;

	/**
	 * The OAuth class handles authentication.
	 * @author Jonnie Hallman
	 */	
	public class OAuth {
		/**
		 * @private 
		 */		
		protected var pool:ObjectPool;
		
		/**
		 * @private 
		 */		
		protected var consumer:OAuthConsumer;
		
		/**
		 * @private 
		 */		
		protected var consumerKey:String;
		
		/**
		 * @private 
		 */		
		protected var consumerSecret:String;
		
		/**
		 * @private 
		 */	
		protected var signature:OAuthSignatureMethod_HMAC_SHA1 = new OAuthSignatureMethod_HMAC_SHA1();
		
		/**
		 * @private 
		 */	
		protected var requestToken:OAuthToken;
		
		/**
		 * @private 
		 */	
		protected var accessToken:OAuthToken;
		
		/**
		 * Instantiates the OAuth class.
		 * @param consumerKey the consumer key for the Twitter application
		 * @param consumerSecret the consumer secret for the Twitter application
		 */		
		public function OAuth(consumerKey:String, consumerSecret:String) {
			consumer = new OAuthConsumer(consumerKey, consumerSecret);
		}
		
		/**
		 * Loads a request for the request token.
		 */		
		public function getRequestToken():void {
			var request:OAuthRequest = new OAuthRequest(URLRequestMethod.GET, TwitterURL.OAUTH_REQUEST_TOKEN, null, consumer);
			var loader:StringLoader = pool.getObject() as StringLoader;
			
			loader.completeSignal.addOnce(getRequestTokenCompleteHandler);
			
			loader.request = request.buildRequest(signature);
			
			loader.load();
		}
		
		/**
		 * Returns the authorize URL using the request token.
		 * This can only be called after first retrieving the request token.
		 * @return 
		 */		
		public function getAuthorizeURL():String {
			// TODO
			return null;
		}
		
		/**
		 * Loads a request for the access token.
		 * @param pin the pin number provided by Twitter after navigating to the authorize URL
		 */		
		public function getAccessToken(pin:uint):void {
			// TODO
		}
		
		/**
		 * @private
		 * @param loader the loader instance
		 * @param data the request token data in string query format
		 */		
		protected function getRequestTokenCompleteHandler(loader:StringLoader, data:String):void {
			requestToken = OAuthUtil.getTokenFromResponse(data);
			
			// TODO
		}
	}
}