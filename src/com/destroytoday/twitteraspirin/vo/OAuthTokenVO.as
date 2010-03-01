package com.destroytoday.twitteraspirin.vo {
	public class OAuthTokenVO {
		public var key:String;
		public var secret:String;
		
		public function OAuthTokenVO(key:String = null, secret:String = null) {
			this.key = key;
			this.secret = secret;
		}
	}
}