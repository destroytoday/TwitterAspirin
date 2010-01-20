package com.destroytoday.twitteraspirin.constants {
	public class TwitterURL {
		public static const OAUTH_REQUEST_TOKEN:String = "http://twitter.com/oauth/request_token";
		public static const OAUTH_ACCESS_TOKEN:String = "http://twitter.com/oauth/access_token";
		public static const OAUTH_AUTHORIZE:String = "http://twitter.com/oauth/authorize";
		
		public function TwitterURL() {
			throw Error("The TwitterURL class cannot be instantiated.");
		}
	}
}