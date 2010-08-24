package com.destroytoday.twitteraspirin.constants {
	/**
	 * The TwitterURL class houses URL string constants.
	 * @author Jonnie Hallman
	 */	
	public class TwitterURL {
		public static const OAUTH_REQUEST_TOKEN:String = "http://twitter.com/oauth/request_token";
		
		public static const OAUTH_ACCESS_TOKEN:String = "https://api.twitter.com/oauth/access_token";
		
		public static const OAUTH_AUTHORIZE:String = "http://twitter.com/oauth/authorize";
		
		public static const OAUTH_VERIFY_ACCESS_TOKEN:String = "http://api.twitter.com/1/account/verify_credentials.xml";
		
		public static const GET_USER:String = "https://api.twitter.com/1/users/show.xml";
		
		public static const GET_STATUS:String = "https://api.twitter.com/1/statuses/show/{id}.xml";

		public static const DELETE_STATUS:String = "https://api.twitter.com/1/statuses/destroy/{id}.xml";
		
		public static const UPDATE_STATUS:String = "https://api.twitter.com/1/statuses/update.xml";

		public static const RETWEET_STATUS:String = "https://api.twitter.com/1/statuses/retweet/{id}.xml";
		
		public static const FAVORITE_STATUS:String = "https://api.twitter.com/1/favorites/create/{id}.xml";
		
		public static const GET_HOME_TIMELINE:String = "https://api.twitter.com/1/statuses/home_timeline.xml";
		
		public static const GET_RETWEETS_BY_ME:String = "https://api.twitter.com/1/statuses/retweeted_by_me.xml";
		
		public static const GET_MENTIONS_TIMELINE:String = "https://api.twitter.com/1/statuses/mentions.xml";
		
		public static const SEND_MESSAGE:String = "https://api.twitter.com/1/direct_messages/new.xml";
		
		public static const DELETE_MESSAGE:String = "https://api.twitter.com/1/direct_messages/destroy/{id}.xml";
		
		public static const GET_MESSAGES_INBOX_TIMELINE:String = "https://api.twitter.com/1/direct_messages.xml";
		
		public static const GET_MESSAGES_SENT_TIMELINE:String = "https://api.twitter.com/1/direct_messages/sent.xml";
		
		public static const GET_SEARCH_TIMELINE:String = "http://search.twitter.com/search.atom";
		
		public static const GET_FRIENDS_IDS:String = "https://api.twitter.com/1/friends/ids.xml";
		
		public static const GET_USERS:String = "https://api.twitter.com/1/users/lookup.xml";

		public static const GET_RELATIONSHIP:String = "https://api.twitter.com/1/friendships/show.xml";

		public static const FOLLOW:String = "https://api.twitter.com/1/friendships/create.xml";

		public static const UNFOLLOW:String = "https://api.twitter.com/1/friendships/destroy.xml";
		
		public function TwitterURL() {
			throw Error("The TwitterURL class cannot be instantiated.");
		}
	}
}