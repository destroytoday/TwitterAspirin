package com.destroytoday.twitteraspirin.constants {
	/**
	 * The TwitterError class houses the error string constants.
	 * @author Jonnie Hallman
	 */	
	public class TwitterError {
		public static const OAUTH_AUTHORIZE_URL:String = "TwitterError.OAUTH_AUTHORIZE_URL";
		
		public static const OAUTH_ACCESS_TOKEN:String = "TwitterError.OAUTH_ACCESS_TOKEN";
		
		/**
		 * @private 
		 */		
		public function TwitterError() {
			throw Error("The TwitterError cannot be instantiated.");
		}
	}
}