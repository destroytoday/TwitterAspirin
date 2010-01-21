package com.destroytoday.twitteraspirin.vo {
	public class UserVO {
		public var id:Number;
		
		public var name:String;
		
		public var screenName:String;
		
		public var location:String;
		
		public var description:String;
		
		public var profileImageURL:String;
		
		public var url:String;
		
		public var language:String;
		
		public var protectedAccount:Boolean;
		
		public var followersCount:int;
		
		public var friendsCount:int;
		
		public var createdAt:Date;
		
		public var favoritesCount:int; // favourites
		
		public var utcOffset:int;
		
		public var timezone:String;
		
		public var statusesCount:int;
		
		public var verified:Boolean;
		
		public var contributorsEnabled:Boolean;
		
		public function UserVO() {
		}
	}
}
