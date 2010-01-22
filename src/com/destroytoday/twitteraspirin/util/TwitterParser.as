package com.destroytoday.twitteraspirin.util {
	import com.destroytoday.twitteraspirin.vo.DirectMessageVO;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	
	import flash.net.URLRequestHeader;
	import flash.system.System;
	
	import mx.utils.ObjectUtil;

	/**
	 * The TwitterParser takes XML data and returns the appropriate value object.
	 * @author Jonnie Hallman
	 */	
	public class TwitterParser {
		/**
		 * @private
		 */		
		public function TwitterParser() {
			throw Error("The TwitterParser class cannot be instantiated.");
		}
		
		public static function parseAccountCallInfo(headers:Array):void {
			var remainingCalls:int, totalCalls:int;
			var callsResetDate:Date;
			
			for each(var header:URLRequestHeader in headers) {
				if (header.name == "X-Ratelimit-Limit") {
					totalCalls = int(header.value);
				} else if (header.name == "X-Ratelimit-Remaining") {
					remainingCalls = int(header.value);
				} else if (header.name == "X-Ratelimit-Reset") {
					callsResetDate = new Date(int(header.value) * 1000);
				}
			}
			
			trace(totalCalls, remainingCalls, callsResetDate);
		}
		
		/**
		 * Parses a status's XML data into a status value object.
		 * @param data the XML data, with node name 'status'
		 * @return the status value object
		 */		
		public static function parseStatus(data:XML):StatusVO {
			var status:StatusVO = new StatusVO();
			
			status.id = Number(data.id);
			status.createdAt = new Date(Date.parse(data.createdAt));
			status.text = data.text;
			status.source = data.source;
			status.truncated = String(data.truncated) == "true";
			status.inReplyToStatusID = Number(data.in_reply_to_status_id);
			status.inReplyToUserID = Number(data.in_reply_to_user_id);
			status.inReplyToScreenName = data.in_reply_to_screen_name;
			status.favorited = String(data.favorited) == "true";
			
			// free XML from memory
			System.disposeXML(data);
			
			return status;
		}
		
		/**
		 * Parses a user's XML data into a user value object.
		 * @param data the XML data, with node name 'user', 'sender', or 'recipient'
		 * @return the user value object
		 */		
		public static function parseUser(data:XML):UserVO {
			var user:UserVO = new UserVO();
			
			user.id = Number(data.id);
			user.name = data.name;
			user.screenName = data.screen_name;
			user.location = data.location;
			user.description = data.description;
			user.profileImageURL = data.profile_image_url;
			user.url = data.url;
			user.language = data.lang;
			user.protectedAccount = data.protected;
			user.followersCount = int(data.followers_count);
			user.friendsCount = int(data.friends_count);
			user.createdAt = new Date(Date.parse(data.created_at));
			user.favoritesCount = int(data.favourites_count);
			user.utcOffset = int(data.utc_offset);
			user.timezone = String(data.time_zone);
			user.statusesCount = int(data.statuses_count);
			user.verified = String(data.verified) == "true";
			user.contributorsEnabled = String(data.contributors_enabled) == "true";
			
			// free XML from memory
			System.disposeXML(data);
			
			return user;
			
		}

		/**
		 * Parses a direct message's XML data into a direct message value object. 
		 * @param data the XML data, with node name 'direct-message'
		 * @return the direct message value object
		 */		
		public static function parseDirectMessage(data:XML):DirectMessageVO {
			var directMessage:DirectMessageVO = new DirectMessageVO();
				
			directMessage.id = Number(data.id);
			directMessage.createdAt = new Date(Date.parse(data.created_at));
			directMessage.sender = parseUser(data.sender[0]);
			directMessage.recipient = parseUser(data.recipient[0]);
			directMessage.text = data.text;
			
			// free XML from memory
			System.disposeXML(data);
			
			return directMessage;
		}
		
		/**
		 * Parses the XML data of a series of statuses into a vector of status value objects.
		 * @param data the XML data
		 * @return the vector of status value objects
		 */		
		public static function parseStatuses(data:XML):Vector.<StatusVO> {
			var statuses:Vector.<StatusVO> = new Vector.<StatusVO>();
			
			for each (var node:XML in data.status) {
				statuses[statuses.length] = parseStatus(node);
			}
			
			// free XML from memory
			System.disposeXML(data);
			
			return statuses;
		}
	}
}