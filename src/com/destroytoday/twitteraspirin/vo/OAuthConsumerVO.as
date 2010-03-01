package com.destroytoday.twitteraspirin.vo {
	public class OAuthConsumerVO {
		public var key:String;
		public var secret:String;
		
		public function OAuthConsumerVO(key:String = null, secret:String = null) {
			this.key = key;
			this.secret = secret;
		}
	}
}