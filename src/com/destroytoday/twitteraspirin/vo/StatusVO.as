package com.destroytoday.twitteraspirin.vo {
	public class StatusVO {
		public var createdAt:Date;
		
		public var id:Number;
		
		public var text:String;
		
		public var source:String;
		
		public var truncated:Boolean;
		
		public var inReplyToStatusID:Number;
		
		public var inReplyToUserID:Number;
		
		public var inReplyToScreenName:String;
		
		public var favorited:Boolean;
		
		public var user:UserVO;
		
		//public var geo;
		
		//public var contributors;
		
		public function StatusVO() {
		}
	}
}
