package com.destroytoday.twitteraspirin.vo {
	public class XAuthTokenVO extends OAuthTokenVO {
		public var id:int;
		public var screenName:String;
		
		public function XAuthTokenVO() {
		}
		
		override public function toString():String
		{
			return "[XAuthTokenVO(key: " + key + ", secret: " + secret + ", id: " + id + ", screenName: " + screenName + ")]";
		}
	}
}