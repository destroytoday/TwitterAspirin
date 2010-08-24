package com.destroytoday.twitteraspirin.util {
	import com.destroytoday.twitteraspirin.constants.RelationshipType;
	import com.destroytoday.twitteraspirin.vo.DirectMessageVO;
	import com.destroytoday.twitteraspirin.vo.RelationshipVO;
	import com.destroytoday.twitteraspirin.vo.SearchStatusVO;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	
	import flash.system.System;

	/**
	 * The TwitterParser takes XML data and returns the appropriate value object.
	 * @author Jonnie Hallman
	 */	
	public class TwitterParser {
		namespace atom = "http://www.w3.org/2005/Atom";
		namespace twitter = "http://api.twitter.com/";
		
		/**
		 * @private
		 */		
		public function TwitterParser() {
			throw Error("The TwitterParser class cannot be instantiated.");
		}
		
		/**
		 * Parses a status's XML data into a status value object.
		 * @param data the XML data, with node name 'status'
		 * @return the status value object
		 */		
		public static function parseStatus(data:XML, disposeXML:Boolean = true):StatusVO {
			var status:StatusVO = new StatusVO();

			status.id = Number(data.id);
			status.createdAt = new Date(Date.parse(data.created_at));
			
			if (String(data.retweeted_status.text) != "")
			{
				status.text = "RT @" + data.retweeted_status.user.screen_name + ": " + data.retweeted_status.text;
			}
			else
			{
				status.text = data.text;
			}
			
			status.source = data.source;
			status.truncated = String(data.truncated) == "true";
			status.inReplyToStatusID = Number(data.in_reply_to_status_id);
			status.inReplyToUserID = Number(data.in_reply_to_user_id);
			status.inReplyToScreenName = data.in_reply_to_screen_name;
			status.favorited = String(data.favorited) == "true";
			status.user = parseUser(data.user[0]);

			// free XML from memory
			if (disposeXML) System.disposeXML(data);
			
			return status;
		}
		
		/**
		 * Parses a user's XML data into a user value object.
		 * @param data the XML data, with node name 'user', 'sender', or 'recipient'
		 * @return the user value object
		 */		
		public static function parseUser(data:XML, disposeXML:Boolean = true):UserVO {
			var user:UserVO = new UserVO();
			
			user.id = Number(data.id);
			user.name = data.name;
			user.screenName = data.screen_name;
			user.location = data.location;
			user.description = data.description;
			user.profileImageURL = data.profile_image_url;
			user.url = data.url;
			user.language = data.lang;
			user.isProtected = String(data.protected) == "true";
			user.followersCount = int(data.followers_count);
			user.friendsCount = int(data.friends_count);
			user.createdAt = new Date(Date.parse(data.created_at));
			user.favoritesCount = int(data.favourites_count);
			user.listedCount = int(data.listed_count);
			user.utcOffset = int(data.utc_offset);
			user.timezone = String(data.time_zone);
			user.statusesCount = int(data.statuses_count);
			user.verified = String(data.verified) == "true";
			user.contributorsEnabled = String(data.contributors_enabled) == "true";
			
			// free XML from memory
			if (disposeXML) System.disposeXML(data);
			
			return user;
		}
		
		public static function parseUsers(data:XML):Vector.<UserVO>
		{
			var users:Vector.<UserVO> = new Vector.<UserVO>();
			
			for each (var node:XML in data.user) {
				users[users.length] = parseUser(node, false);
			}
			
			// free XML from memory
			System.disposeXML(data);
			
			return users;
		}
		
		public static function parseUserID(data:XML, disposeXML:Boolean = true):int {
			var id:int = int(data);
			
			// free XML from memory
			if (disposeXML) System.disposeXML(data);

			return id;
		}
		
		public static function parseUserIDs(data:XML):Vector.<int> {
			var ids:Vector.<int> = new Vector.<int>();
			
			for each (var node:XML in data.ids.id) {
				ids[ids.length] = int(node);
			}
			
			// free XML from memory
			System.disposeXML(data);
			
			return ids;
		}

		/**
		 * Parses a direct message's XML data into a direct message value object. 
		 * @param data the XML data, with node name 'direct-message'
		 * @return the direct message value object
		 */		
		public static function parseDirectMessage(data:XML, disposeXML:Boolean = true):DirectMessageVO {
			var directMessage:DirectMessageVO = new DirectMessageVO();

			directMessage.id = Number(data.id);
			directMessage.createdAt = new Date(Date.parse(data.created_at));
			directMessage.sender = parseUser(data.sender[0]);
			directMessage.recipient = parseUser(data.recipient[0]);
			directMessage.text = data.text;

			// free XML from memory
			if (disposeXML) System.disposeXML(data);
			
			return directMessage;
		}
		
		public static function parseDirectMessages(data:XML):Vector.<DirectMessageVO> {
			var directMessages:Vector.<DirectMessageVO> = new Vector.<DirectMessageVO>();
			
			for each (var node:XML in data.direct_message) {
				directMessages[directMessages.length] = parseDirectMessage(node, false);
			}
			
			// free XML from memory
			System.disposeXML(data);
			
			return directMessages;
		}
		
		public static function getNumStatuses(data:XML):int
		{
			return data.status.length();
		}
		
		/**
		 * Parses the XML data of a list of statuses into a vector of status value objects.
		 * @param data the XML data
		 * @return the vector of status value objects
		 */		
		public static function parseStatuses(data:XML):Vector.<StatusVO> {
			var statuses:Vector.<StatusVO> = new Vector.<StatusVO>();
			
			for each (var node:XML in data.status) {
				statuses[statuses.length] = parseStatus(node, false);
			}
			
			// free XML from memory
			System.disposeXML(data);
			
			return statuses;
		}
		
		/**
		 * Parses the Atom data of a list of search statuses into a vector of status value objects.
		 * @param data the Atom data
		 * @return the vector of status value objects
		 */		
		public static function parseSearchStatuses(data:XML):Vector.<SearchStatusVO> {
			var status:SearchStatusVO;
			var id:String, date:String, time:String, user:String;
			var datetime:Array;
			var statuses:Vector.<SearchStatusVO> = new Vector.<SearchStatusVO>();

			for each (var node:XML in data.atom::entry) {
				status = new SearchStatusVO();
				
				id = node.atom::id;
				datetime = String(node.atom::published).split("T");
				date = String(datetime[0]).split("-").join("/");
				time = datetime[1];
				time = time.substr(0, time.length - 1);
				user = node.atom::author.atom::name;

				status.id = Number(id.substr(id.lastIndexOf (":") + 1));
				status.createdAt = new Date(Date.parse(date + " " + time));
				status.createdAt.minutes -= status.createdAt.timezoneOffset;
				status.text = node.atom::title;
				status.source = node.twitter::source;
				status.userName = user.substring(user.indexOf(" ") + 2, user.length - 1);
				status.userScreenName = user.substr(0, user.indexOf(" "));
				status.userProfileImageURL = String(node.atom::link[1].@href);
				
				statuses[statuses.length] = status;
			}
			
			// free XML from memory
			System.disposeXML(data);
			
			return statuses;
		}
		
		public static function parseRelationship(data:XML):RelationshipVO
		{
			var relationship:RelationshipVO = new RelationshipVO();
			
			relationship.sourceUserID = int(data.source.id);
			relationship.sourceUserScreenName = String(data.source.screen_name);
			relationship.targetUserID = int(data.target.id);
			relationship.targetUserScreenName = String(data.target.screen_name);
			relationship.blocking = String(data.target.blocking) == "true";
			
			if (String(data.source.following) == "true" && String(data.source.followed_by) == "true")
			{
				relationship.type = RelationshipType.MUTUAL;
			}
			else if (String(data.source.following) == "true" && String(data.source.followed_by) == "false")
			{
				relationship.type = RelationshipType.FOLLOWING;
			}
			else if (String(data.source.following) == "false" && String(data.source.followed_by) == "true")
			{
				relationship.type = RelationshipType.FOLLOWER;
			}
			else
			{
				relationship.type = RelationshipType.NONE;
			}
			
			return relationship;
		}
	}
}