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
		public static const OAUTH_VERIFY_ACCESS_TOKEN:String = "https://twitter.com/account/verify_credentials.xml";
		
		/**
		 * GET 
		 */		
		public static const GET_USER:String = "http://twitter.com/users/show.xml";
		
		/**
		 * GET 
		 */		
		public static const GET_STATUS:String = "http://twitter.com/statuses/show/{id}.xml";
		
		/**
		 * POST 
		 */		
		public static const UPDATE_STATUS:String = "https://twitter.com/statuses/update.xml";
		
		/**
		 * GET 
		 */		
		public static const GET_MENTIONS_TIMELINE:String = "https://twitter.com/statuses/mentions.xml";
		
		/**
		 * @private
		 */		
		public function TwitterURL() {
			throw Error("The TwitterURL class cannot be instantiated.");
		}
	}
}