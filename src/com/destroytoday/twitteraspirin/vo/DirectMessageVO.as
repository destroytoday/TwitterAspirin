package com.destroytoday.twitteraspirin.vo {
	public class DirectMessageVO {
		public var id:Number;
		
		public var createdAt:Date;
		
		public var sender:UserVO;
		
		public var recipient:UserVO;
		
		public var text:String;
		
		public function DirectMessageVO() {
		}
	}
}
