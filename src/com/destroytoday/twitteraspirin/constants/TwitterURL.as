package com.destroytoday.twitteraspirin.constants {
	/**
	 * The TwitterURL class houses URL string constants.
	 * @author Jonnie Hallman
	 */	
	public class TwitterURL {
		/**
		 * GET 
		 */		
		public static const OAUTH_REQUEST_TOKEN:String = "http://twitter.com/oauth/request_token";
		
		/**
		 * GET 
		 */				
		public static const OAUTH_ACCESS_TOKEN:String = "http://twitter.com/oauth/access_token";
		
		/**
		 * GET 
		 */		
		public static const OAUTH_AUTHORIZE:String = "http://twitter.com/oauth/authorize";
		
		/**
		 * GET 
		 */		
		public static const OAUTH_VERIFY_ACCESS_TOKEN:String = "http://twitter.com/account/verify_credentials.xml";
		
		/**
		 * @private
		 */		
		public function TwitterURL() {
			throw Error("The TwitterURL class cannot be instantiated.");
		}
	}
}