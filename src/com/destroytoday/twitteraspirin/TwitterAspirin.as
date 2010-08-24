package com.destroytoday.twitteraspirin {
	import com.destroytoday.net.StringLoader;
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.pool.ObjectPool;
	import com.destroytoday.twitteraspirin.constants.TwitterURL;
	import com.destroytoday.twitteraspirin.image.IImageService;
	import com.destroytoday.twitteraspirin.net.LoaderFactory;
	import com.destroytoday.twitteraspirin.oauth.OAuthRequest;
	import com.destroytoday.twitteraspirin.urlshortening.IURLShortener;
	import com.destroytoday.twitteraspirin.util.ResponseUtil;
	import com.destroytoday.twitteraspirin.util.TokenUtil;
	import com.destroytoday.twitteraspirin.util.TwitterParser;
	import com.destroytoday.twitteraspirin.vo.DirectMessageVO;
	import com.destroytoday.twitteraspirin.vo.OAuthConsumerVO;
	import com.destroytoday.twitteraspirin.vo.OAuthTokenVO;
	import com.destroytoday.twitteraspirin.vo.RelationshipVO;
	import com.destroytoday.twitteraspirin.vo.SearchStatusVO;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	import com.destroytoday.twitteraspirin.vo.XAuthTokenVO;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;

	/**
	 * The TwitterAspirin class
	 * @author Jonnie Hallman
	 */	
	public class TwitterAspirin {
		//--------------------------------------------------------------------------
		//
		//  OAuth Signals
		//
		//--------------------------------------------------------------------------

		public const gotXAuthAccessToken:Signal = new Signal(XAuthTokenVO);
		
		public const gotXAuthAccessTokenError:Signal = new Signal(StringLoader, int, String, String);
		
		public const verifiedOAuthAccessToken:Signal = new Signal(UserVO);
		
		public const verifiedOAuthAccessTokenError:Signal = new Signal(XMLLoader, int, String, String);
		
		//--------------------------------------------------------------------------
		//
		//  User Signals
		//
		//--------------------------------------------------------------------------
		
		public const gotUser:Signal = new Signal(XMLLoader, UserVO);
		
		public const gotUserError:Signal = new Signal(XMLLoader, int, String, String);
		
		public const gotFriendsIDs:Signal = new Signal(XMLLoader, Vector.<int>, Number, Number);
		
		public const gotFriendsIDsError:Signal = new Signal(XMLLoader, int, String, String);
		
		public const gotUsers:Signal = new Signal(XMLLoader, Vector.<UserVO>);
		
		public const gotUsersError:Signal = new Signal(XMLLoader, int, String, String);
		
		public const gotRelationship:Signal = new Signal(XMLLoader, RelationshipVO);
		
		public const gotRelationshipError:Signal = new Signal(XMLLoader, int, String, String);

		public const followedUser:Signal = new Signal(XMLLoader, UserVO);

		public const followedUserError:Signal = new Signal(XMLLoader, int, String, String);
		
		public const unfollowedUser:Signal = new Signal(XMLLoader, UserVO);

		public const unfollowedUserError:Signal = new Signal(XMLLoader, int, String, String);
		
		//--------------------------------------------------------------------------
		//
		//  Status Signals
		//
		//--------------------------------------------------------------------------
		
		public const gotStatus:Signal = new Signal(XMLLoader, StatusVO);
		
		public const gotStatusError:Signal = new Signal(XMLLoader, int, String, String);
		
		public const updatedStatus:Signal = new Signal(XMLLoader, StatusVO);
		
		public const updatedStatusError:Signal = new Signal(XMLLoader, int, String, String);

		public const retweetedStatus:Signal = new Signal(XMLLoader, StatusVO);
		
		public const retweetedStatusError:Signal = new Signal(XMLLoader, int, String, String);
		
		public const deletedStatus:Signal = new Signal(XMLLoader, StatusVO);
		
		public const deletedStatusError:Signal = new Signal(XMLLoader, int, String, String);

		public const favoritedStatus:Signal = new Signal(XMLLoader, StatusVO);
		
		public const favoritedStatusError:Signal = new Signal(XMLLoader, int, String, String);
		
		public const gotHomeTimeline:Signal = new Signal(XMLLoader, Vector.<StatusVO>);
		
		public const gotHomeTimelineError:Signal = new Signal(XMLLoader, int, String, String);

		public const gotOutgoingRetweetsTimeline:Signal = new Signal(XMLLoader, Vector.<StatusVO>);
		
		public const gotOutgoingRetweetsTimelineError:Signal = new Signal(XMLLoader, int, String, String);

		public const gotMentionsTimeline:Signal = new Signal(XMLLoader, Vector.<StatusVO>);
		
		public const gotMentionsTimelineError:Signal = new Signal(XMLLoader, int, String, String);
		
		public const gotSearchTimeline:Signal = new Signal(XMLLoader, Vector.<SearchStatusVO>);
		
		public const gotSearchTimelineError:Signal = new Signal(XMLLoader, int, String, String);
		
		//--------------------------------------------------------------------------
		//
		//  Message Signals
		//
		//--------------------------------------------------------------------------
		
		public const sentMessage:Signal = new Signal(XMLLoader, DirectMessageVO);
		
		public const sentMessageError:Signal = new Signal(XMLLoader, int, String, String);
		
		public const deletedMessage:Signal = new Signal(XMLLoader, DirectMessageVO);
		
		public const deletedMessageError:Signal = new Signal(XMLLoader, int, String, String);
		
		public const gotIncomingMessagesTimeline:Signal = new Signal(XMLLoader, Vector.<DirectMessageVO>);
		
		public const gotIncomingMessagesTimelineError:Signal = new Signal(XMLLoader, int, String, String);

		public const gotOutgoingMessagesTimeline:Signal = new Signal(XMLLoader, Vector.<DirectMessageVO>);
		
		public const gotOutgoingMessagesTimelineError:Signal = new Signal(XMLLoader, int, String, String);
		
		//--------------------------------------------------------------------------
		//
		//  URL Shortener Signals
		//
		//--------------------------------------------------------------------------
		
		public const shortenedURL:Signal = new Signal(StringLoader, String, String); // original URL, shortened URL
		
		public const shortenedURLError:Signal = new Signal(StringLoader, int, String); // code, message
		
		//--------------------------------------------------------------------------
		//
		//  File Uploader Signals
		//
		//--------------------------------------------------------------------------
		
		public const uploadedFile:Signal = new Signal(File, String); // url
		
		public const uploadedFileError:Signal = new Signal(File, int, String); // code, message
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var loaderFactory:LoaderFactory = new LoaderFactory();
		
		//--------------------------------------------------------------------------
		//
		//  OAuth Properties
		//
		//--------------------------------------------------------------------------
		
		protected var oauthRequestPool:ObjectPool = new ObjectPool(OAuthRequest);
		
		protected var oauthConsumer:OAuthConsumerVO = new OAuthConsumerVO();
		
		//--------------------------------------------------------------------------
		//
		//  URL Shortener Properties
		//
		//--------------------------------------------------------------------------
		
		protected var shortenedURLMap:Object = {};

		protected var originalURLMap:Object = {};
		
		//--------------------------------------------------------------------------
		//
		//  File Uploader Properties
		//
		//--------------------------------------------------------------------------

		protected var fileUploaderMap:Dictionary = new Dictionary();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Instantiates the Twitter class.
		 * @param consumerKey the consumer key for the Twitter application
		 * @param consumerSecret the consumer secret for the Twitter application
		 */		
		public function TwitterAspirin(consumerKey:String = null, consumerSecret:String = null) {
			if (consumerKey && consumerSecret) {
				setOAuthConsumerCredentials(consumerKey, consumerSecret);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  OAuth Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Sets the OAuth consumer credentials for the Twitter application.
		 * @param consumerKey the consumer key for the Twitter application
		 * @param consumerSecret the consumer secret for the Twitter application
		 */		
		public function setOAuthConsumerCredentials(consumerKey:String, consumerSecret:String):void {
			oauthConsumer.key = consumerKey;
			oauthConsumer.secret = consumerSecret;
		}
		
		/**
		 * Loads a request for the access token using xAuth username and password.
		 * @param pin the pin number provided by Twitter after navigating to the authorize URL
		 * @return the StringLoader loading the request
		 */		
		public function getXAuthAccessToken(username:String, password:String):StringLoader {
			var request:OAuthRequest = new OAuthRequest(oauthConsumer, TwitterURL.OAUTH_ACCESS_TOKEN, URLRequestMethod.POST);
			var loader:StringLoader = loaderFactory.getStringLoader(gotXAuthAccessTokenHandler, gotXAuthAccessTokenErrorHandler);
			
			loader.request = request.getURLRequest({x_auth_username: username, x_auth_password: password, x_auth_mode: "client_auth"});
			
			loader.load();
			
			return loader;
		}
		
		/**
		 * Verifies an access token.
		 * If successful, Twitter returns the authenticated user's info.
		 * @param accessToken the access token to verify
		 * @return the XMLLoader loading the verification
		 */		
		public function verifyOAuthAccessToken(accessToken:OAuthTokenVO):XMLLoader {
			var request:OAuthRequest = new OAuthRequest(oauthConsumer, TwitterURL.OAUTH_VERIFY_ACCESS_TOKEN, URLRequestMethod.GET, accessToken);
			var loader:XMLLoader = loaderFactory.getXMLLoader(verifyOAuthAccessTokenHandler, verifyOAuthAccessTokenErrorHandler);
			
			loader.request = request.getURLRequest();
			
			loader.load();
			
			return loader;
		}
		
		public function getOAuthURLRequest(accessToken:OAuthTokenVO, url:String, method:String, parameters:Object = null):URLRequest {
			var request:OAuthRequest = oauthRequestPool.getObject() as OAuthRequest;
			
			request.consumer = oauthConsumer;
			request.token = accessToken;
			request.url = url;
			request.method = method;
			
			return request.getURLRequest(parameters);
		}
		
		//--------------------------------------------------------------------------
		//
		//  User Methods
		//
		//--------------------------------------------------------------------------
		
		public function getUser(accessToken:XAuthTokenVO, id:Number = NaN, screenName:String = null):XMLLoader {
			var parameters:URLVariables = new URLVariables();
			
			if (id > 0) {
				parameters['user_id'] = id;
			} else if (screenName) {
				parameters['screen_name'] = screenName;
			} else {
				return null;
			}
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(gotUserHandler, gotUserErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.GET_USER, URLRequestMethod.GET, parameters);
			
			loader.load();
			
			return loader;
		}
		
		public function getFriendIDList(accessToken:XAuthTokenVO, id:int = -1, screenName:String = null, cursor:Number = -1):XMLLoader
		{
			var parameters:Object = {};

			if (id >= 0) 
			{
				parameters['user_id'] = id;
			}
			else if (screenName)
			{
				parameters['screen_name'] = screenName;
			}
			
			parameters['cursor'] = cursor;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(gotFriendIDListHandler, gotFriendIDListErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.GET_FRIENDS_IDS, URLRequestMethod.GET, parameters);
			
			loader.load();
			
			return loader;
		}
		
		public function getUserList(accessToken:XAuthTokenVO, idList:Array = null, screenNameList:Array = null):XMLLoader
		{
			var parameters:URLVariables = new URLVariables();
			
			if (idList)
			{
				parameters['user_id'] = idList.join(',');
			}
			else if (screenNameList)
			{
				parameters['screen_name'] = screenNameList.join(',');
			}
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(gotUserListHandler, gotUserListErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.GET_USERS, URLRequestMethod.POST, parameters);
			
			loader.load();
			
			return loader;
		}
		
		public function getUserRelationship(accessToken:XAuthTokenVO, id:int):XMLLoader
		{
			var parameters:URLVariables = new URLVariables();
			
			parameters['target_id'] = id;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(gotUserRelationshipHandler, gotUserRelationshipErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.GET_RELATIONSHIP, URLRequestMethod.GET, parameters);
			
			loader.load();
			
			return loader;
		}
		
		public function followUser(accessToken:XAuthTokenVO, id:int):XMLLoader
		{
			var parameters:URLVariables = new URLVariables();
			
			parameters['user_id'] = id;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(followedUserHandler, followedUserErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.FOLLOW, URLRequestMethod.POST, parameters);
			
			loader.load();
			
			return loader;
		}
		
		public function unfollowUser(accessToken:XAuthTokenVO, id:int):XMLLoader
		{
			var parameters:URLVariables = new URLVariables();
			
			parameters['user_id'] = id;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(unfollowedUserHandler, unfollowedUserErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.UNFOLLOW, URLRequestMethod.POST, parameters);
			
			loader.load();
			
			return loader;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Status Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Loads the request for the status specified by the provided id.
		 * @param accessToken
		 * @param id the id of the status to return
		 * @return the loader of the operation
		 */		
		public function getStatus(accessToken:OAuthTokenVO, id:Number):XMLLoader {
			var loader:XMLLoader = loaderFactory.getXMLLoader(gotStatusHandler, gotStatusErrorHandler);

			loader.request = getOAuthURLRequest(accessToken, (TwitterURL.GET_STATUS).replace("{id}", id), URLRequestMethod.GET);
			
			loader.load();
			
			return loader;
		}
		
		/**
		 * Loads the request for updating the authenticated user's status.
		 * @param accessToken
		 * @param status the status text
		 * @param inReplyToStatusID the id of the status this is in response to
		 * @param latitude the location's latitude
		 * @param longitude the location's longitude
		 * @return the loader of the operation
		 */		
		public function updateStatus(accessToken:OAuthTokenVO, status:String, inReplyToStatusID:Number = NaN, latitude:Number = NaN, longitude:Number = NaN):XMLLoader {
			var parameters:URLVariables = new URLVariables();

			//TODO - fix issue with statuses including linebreaks
			parameters['status'] = status;
			if (inReplyToStatusID > 0) parameters['in_reply_to_status_id'] = inReplyToStatusID;
			if (latitude < 0 || latitude >= 0) parameters['latitude'] = latitude;
			if (longitude < 0 || longitude >= 0) parameters['longitude'] = longitude;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(updateStatusHandler, updatedStatusErrorHandler);

			loader.request = getOAuthURLRequest(accessToken, TwitterURL.UPDATE_STATUS, URLRequestMethod.POST, parameters);

			loader.load();
			
			return loader;
		}
		
		public function retweetStatus(accessToken:OAuthTokenVO, id:Number):XMLLoader {
			var loader:XMLLoader = loaderFactory.getXMLLoader(retweetedStatusHandler, retweetedStatusErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, (TwitterURL.RETWEET_STATUS).replace("{id}", id), URLRequestMethod.POST);
			
			loader.load();
			
			return loader;
		}
		
		public function deleteStatus(accessToken:OAuthTokenVO, id:Number):XMLLoader
		{
			var loader:XMLLoader = loaderFactory.getXMLLoader(deletedStatusHandler, deletedStatusErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, (TwitterURL.DELETE_STATUS).replace("{id}", id), URLRequestMethod.POST);
			
			loader.load();
			
			return loader;
		}
		
		public function favoriteStatus(accessToken:OAuthTokenVO, id:Number):XMLLoader
		{
			var loader:XMLLoader = loaderFactory.getXMLLoader(favoritedStatusHandler, favoritedStatusErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, (TwitterURL.FAVORITE_STATUS).replace("{id}", id), URLRequestMethod.POST);
			
			loader.load();
			
			return loader;
		}
		
		public function getHomeTimeline(accessToken:XAuthTokenVO, sinceID:Number = NaN, maxID:Number = NaN, count:int = 20, page:int = 1):XMLLoader {
			var parameters:URLVariables = new URLVariables();
			
			if (sinceID > 0) parameters['since_id'] = sinceID;
			if (maxID > 0) parameters['max_id'] = maxID;
			parameters['count'] = count;
			if (page > 1) parameters['page'] = page;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(gotTimelineHandler, gotTimelineErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.GET_HOME_TIMELINE, URLRequestMethod.GET, parameters);
			
			loader.load();
			
			return loader;
		}
		
		public function getOutgoingRetweetsTimeline(accessToken:XAuthTokenVO, sinceID:Number = NaN, maxID:Number = NaN, count:int = 20, page:int = 1):XMLLoader {
			var parameters:URLVariables = new URLVariables();

			if (sinceID > 0) parameters['since_id'] = sinceID;
			if (maxID > 0) parameters['max_id'] = maxID;
			parameters['count'] = count;
			if (page > 1) parameters['page'] = page;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(gotTimelineHandler, gotTimelineErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.GET_RETWEETS_BY_ME, URLRequestMethod.GET, parameters);
			
			loader.load();
			
			return loader;
		}
		
		/**
		 * Loads the request for returning the authenticated user's mentions timeline.
		 * @param accessToken
		 * @param sinceID the id to return mentions since
		 * @param maxID the maximum status id
		 * @param count the number of mentions to return
		 * @param page the page of mentions to return, starting at 1
		 * @return the loader of the operation
		 */		
		public function getMentionsTimeline(accessToken:OAuthTokenVO, sinceID:Number = NaN, maxID:Number = NaN, count:int = 20, page:int = 1):XMLLoader {
			var parameters:URLVariables = new URLVariables();
			
			if (sinceID > 0) parameters['since_id'] = sinceID;
			if (maxID > 0) parameters['max_id'] = maxID;
			parameters['count'] = count;
			if (page > 1) parameters['page'] = page;
			parameters['include_rts'] = true;

			var loader:XMLLoader = loaderFactory.getXMLLoader(gotTimelineHandler, gotTimelineErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.GET_MENTIONS_TIMELINE, URLRequestMethod.GET, parameters);
			
			loader.load();
			
			return loader;
		}
		
		public function getSearchTimeline(accessToken:OAuthTokenVO, query:String, sinceID:Number = NaN, maxID:Number = NaN, count:int = 20, page:int = 1, geocode:String = null, showUser:Boolean = false, language:String = null, locale:String = null):XMLLoader {
			var parameters:URLVariables = new URLVariables();
			
			parameters['q'] = query;
			if (sinceID > 0) parameters['sinceID'] = sinceID;
			if (maxID > 0) parameters['maxID'] = maxID;
			parameters['rpp'] = count;
			if (page > 1) parameters['page'] = page;
			if (geocode) parameters['geocode'] = geocode;
			if (showUser) parameters['show_user'] = "true";
			if (language) parameters['language'] = language;
			if (locale) parameters['locale'] = locale;
			parameters['result_type'] = 'recent';

			var loader:XMLLoader = loaderFactory.getXMLLoader(gotSearchTimelineHandler, gotSearchTimelineErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.GET_SEARCH_TIMELINE, URLRequestMethod.GET, parameters);
			
			loader.load();
			
			return loader;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Message Methods
		//
		//--------------------------------------------------------------------------
		
		public function sendMessage(accessToken:OAuthTokenVO, text:String, recipient:*):XMLLoader
		{
			var parameters:URLVariables = new URLVariables();

			parameters['text'] = text;
			
			if (recipient is String)
			{
				parameters['screen_name'] = recipient;
			}
			else if (recipient is int)
			{
				parameters['user_id'] = recipient;
			}
			else
			{
				return null;
			}
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(sentMessageHandler, sentMessageErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.SEND_MESSAGE, URLRequestMethod.POST, parameters);
			
			loader.load();
			
			return loader;
		}
		
		public function deleteMessage(accessToken:OAuthTokenVO, id:Number):XMLLoader
		{
			var loader:XMLLoader = loaderFactory.getXMLLoader(deletedMessageHandler, deletedMessageErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, (TwitterURL.DELETE_MESSAGE).replace("{id}", id), URLRequestMethod.POST);
			
			loader.load();
			
			return loader;
		}
		
		public function getIncomingMessagesTimeline(accessToken:XAuthTokenVO, sinceID:Number = NaN, maxID:Number = NaN, count:int = 20, page:int = 1):XMLLoader {
			var parameters:URLVariables = new URLVariables();
			
			if (sinceID > 0) parameters['since_id'] = sinceID;
			if (maxID > 0) parameters['max_id'] = maxID;
			parameters['count'] = count;
			if (page > 1) parameters['page'] = page;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(gotIncomingMessagesTimelineHandler, gotIncomingMessagesTimelineErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.GET_MESSAGES_INBOX_TIMELINE, URLRequestMethod.GET, parameters);
			
			loader.load();
			
			return loader;
		}
		
		public function getOutgoingMessagesTimeline(accessToken:XAuthTokenVO, sinceID:Number = NaN, maxID:Number = NaN, count:int = 20, page:int = 1):XMLLoader {
			var parameters:URLVariables = new URLVariables();
			
			if (sinceID > 0) parameters['since_id'] = sinceID;
			if (maxID > 0) parameters['max_id'] = maxID;
			parameters['count'] = count;
			if (page > 1) parameters['page'] = page;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(gotOutgoingMessagesTimelineHandler, gotOutgoingMessagesTimelineErrorHandler);
			
			loader.request = getOAuthURLRequest(accessToken, TwitterURL.GET_MESSAGES_SENT_TIMELINE, URLRequestMethod.GET, parameters);
			
			loader.load();
			
			return loader;
		}
		
		//--------------------------------------------------------------------------
		//
		//  URL Shortener Methods
		//
		//--------------------------------------------------------------------------
		
		public function shortenURL(service:IURLShortener, url:String):StringLoader {
			var loader:StringLoader = loaderFactory.getStringLoader(shortenedURLHandler, shortenedURLErrorHandler);

			loader.request = service.parseURL(url);
			
			shortenedURLMap[loader.request.url] = service;
			originalURLMap[loader.request.url] = url;
			
			loader.load();
			
			return loader;
		}
		
		//--------------------------------------------------------------------------
		//
		//  File Uploader Methods
		//
		//--------------------------------------------------------------------------
		
		public function uploadFile(accessToken:XAuthTokenVO, service:IImageService, file:File, title:String):File {
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, fileUploadCompleteHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, fileUploadErrorHandler);
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileUploadErrorHandler);
			file.addEventListener(HTTPStatusEvent.HTTP_STATUS, fileUploadHTTPStatusHandler);
			
			var request:URLRequest;
			
			if (service.verifyURL)
			{
				request = getOAuthURLRequest(accessToken, service.verifyURL, URLRequestMethod.GET);
				var variables:URLVariables = new URLVariables(String(request.data));
			}

			request = new URLRequest();
			
			request.method = URLRequestMethod.POST;
			
			if (service.verifyURL)
			{
				request.requestHeaders = 
				[
					new URLRequestHeader('X-Auth-Service-Provider', service.verifyURL),
					new URLRequestHeader('X-Verify-Credentials-Authorization', 
						"OAuth oauth_consumer_key=\"" + variables['oauth_consumer_key'] + "\"," +
						"oauth_nonce=\"" + variables['oauth_nonce'] + "\"," +
						"oauth_signature_method=\"" + variables['oauth_signature_method'] + "\"," +
						"oauth_timestamp=\"" + variables['oauth_timestamp'] + "\"," +
						"oauth_version=\"" + variables['oauth_version'] + "\"," +
						"oauth_token=\"" + variables['oauth_token'] + "\"," +
						"oauth_signature=\"" + escape(variables['oauth_signature']) + "\"")
				];
			}
			
			request.cacheResponse = false;
			request.manageCookies = false;
			request.useCache = false;

			request = service.parseUploadRequest(request, title || "");
			
			fileUploaderMap[file] = service;
			
			file.upload(request, service.uploadDataField);
			
			return file;
		}

		public function cancelFileUpload(file:File):void
		{
			removeFileUploaderListenerList(file);
			
			delete fileUploaderMap[file];
			
			file.cancel();
		}
		
		//--------------------------------------
		// File Uploader Helper Methods 
		//--------------------------------------
		
		protected function removeFileUploaderListenerList(file:File):void
		{
			file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, fileUploadCompleteHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR, fileUploadErrorHandler);
			file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, fileUploadErrorHandler);
			file.removeEventListener(HTTPStatusEvent.HTTP_STATUS, fileUploadHTTPStatusHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  OAuth Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function gotXAuthAccessTokenHandler(loader:StringLoader, data:String):void {
			if (loader.responseStatus == 200) {
				var accessToken:XAuthTokenVO = TokenUtil.parseXAuthToken(data);
	
				gotXAuthAccessToken.dispatch(accessToken);
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, gotXAuthAccessTokenError);
			}
		}

		protected function gotXAuthAccessTokenErrorHandler(loader:StringLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, gotXAuthAccessTokenError);
		}
		
		protected function verifyOAuthAccessTokenHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) {
				var user:UserVO = TwitterParser.parseUser(data);

				verifiedOAuthAccessToken.dispatch(user);
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, verifiedOAuthAccessTokenError);
			}
		}
		
		protected function verifyOAuthAccessTokenErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, verifiedOAuthAccessTokenError);
		}
		
		//--------------------------------------------------------------------------
		//
		//  User Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function gotUserHandler(loader:XMLLoader, data:XML):void {
			
			if (loader.responseStatus == 200) {
				gotUser.dispatch(loader, TwitterParser.parseUser(data));
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, gotUserError);
			}
		}
		
		protected function gotUserErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, gotUserError);
		}
		
		protected function gotFriendIDListHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) {
				var prevCursor:Number = Number(data.previous_cursor);
				var nextCursor:Number = Number(data.next_cursor);
				
				gotFriendsIDs.dispatch(loader, TwitterParser.parseUserIDs(data), prevCursor, nextCursor);
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, gotFriendsIDsError);
			}
		}

		protected function gotFriendIDListErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, gotFriendsIDsError);
		}
		
		protected function gotUserListHandler(loader:XMLLoader, data:XML):void {
			
			if (loader.responseStatus == 200) {
				gotUsers.dispatch(loader, TwitterParser.parseUsers(data));
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, gotUsersError);
			}
		}
		
		protected function gotUserListErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, gotUsersError);
		}
		
		protected function gotUserRelationshipHandler(loader:XMLLoader, data:XML):void {
			
			if (loader.responseStatus == 200) {
				gotRelationship.dispatch(loader, TwitterParser.parseRelationship(data));
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, gotRelationshipError);
			}
		}
		
		protected function gotUserRelationshipErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, gotRelationshipError);
		}
		
		protected function followedUserHandler(loader:XMLLoader, data:XML):void {
			
			if (loader.responseStatus == 200) {
				followedUser.dispatch(loader, TwitterParser.parseUser(data));
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, followedUserError);
			}
		}
		
		protected function followedUserErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, followedUserError);
		}
		
		protected function unfollowedUserHandler(loader:XMLLoader, data:XML):void {
			
			if (loader.responseStatus == 200) {
				unfollowedUser.dispatch(loader, TwitterParser.parseUser(data));
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, unfollowedUserError);
			}
		}
		
		protected function unfollowedUserErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, unfollowedUserError);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Status Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function gotStatusHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) 
			{
				gotStatus.dispatch(loader, TwitterParser.parseStatus(data));
			}
			else
			{
				ResponseUtil.dispatchTwitterError(loader, data, gotStatusError);
			}
		}
		
		protected function gotStatusErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, gotStatusError);
		}
		
		protected function deletedStatusHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) 
			{
				deletedStatus.dispatch(loader, TwitterParser.parseStatus(data));
			}
			else
			{
				ResponseUtil.dispatchTwitterError(loader, data, deletedStatusError);
			}
		}
		
		protected function deletedStatusErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, deletedStatusError);
		}
		
		protected function favoritedStatusHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) 
			{
				favoritedStatus.dispatch(loader, TwitterParser.parseStatus(data));
			}
			else
			{
				ResponseUtil.dispatchTwitterError(loader, data, favoritedStatusError);
			}
		}
		
		protected function favoritedStatusErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, favoritedStatusError);
		}
		
		protected function updateStatusHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) {
				updatedStatus.dispatch(loader, TwitterParser.parseStatus(data));
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, updatedStatusError);
			}
		}

		protected function updatedStatusErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, updatedStatusError);
		}
		
		protected function retweetedStatusHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) {
				retweetedStatus.dispatch(loader, TwitterParser.parseStatus(data));
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, retweetedStatusError);
			}
		}

		protected function retweetedStatusErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, retweetedStatusError);
		}
		
		protected function gotTimelineHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200)
			{	
				switch (loader.request.url)
				{
					case TwitterURL.GET_HOME_TIMELINE:
						gotHomeTimeline.dispatch(loader, TwitterParser.parseStatuses(data));
						break;
					case TwitterURL.GET_MENTIONS_TIMELINE:
						gotMentionsTimeline.dispatch(loader, TwitterParser.parseStatuses(data));
						break;
					case TwitterURL.GET_RETWEETS_BY_ME:
						gotOutgoingRetweetsTimeline.dispatch(loader, TwitterParser.parseStatuses(data));
						break;
				}
			}
			else 
			{
				switch (loader.request.url)
				{
					case TwitterURL.GET_HOME_TIMELINE:
						ResponseUtil.dispatchTwitterError(loader, data, gotHomeTimelineError);
						break;
					case TwitterURL.GET_MENTIONS_TIMELINE:
						ResponseUtil.dispatchTwitterError(loader, data, gotMentionsTimelineError);
						break;
					case TwitterURL.GET_RETWEETS_BY_ME:
						ResponseUtil.dispatchTwitterError(loader, data, gotOutgoingRetweetsTimelineError);
						break;
				}
			}
		}
		
		protected function gotTimelineErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			switch (loader.request.url)
			{
				case TwitterURL.GET_HOME_TIMELINE:
					ResponseUtil.dispatchError(loader, type, gotHomeTimelineError);
					break;
				case TwitterURL.GET_MENTIONS_TIMELINE:
					ResponseUtil.dispatchError(loader, type, gotMentionsTimelineError);
					break;
				case TwitterURL.GET_RETWEETS_BY_ME:
					ResponseUtil.dispatchError(loader, type, gotOutgoingRetweetsTimelineError);
					break;
			}		
		}
		
		protected function gotSearchTimelineHandler(loader:XMLLoader, data:XML):void {
			ResponseUtil.handleResponse(loader, data, TwitterParser.parseSearchStatuses, gotSearchTimeline, gotSearchTimelineError);
		}
		
		protected function gotSearchTimelineErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, gotSearchTimelineError);	
		}
		
		//--------------------------------------------------------------------------
		//
		//  Message Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function sentMessageHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) {
				sentMessage.dispatch(loader, TwitterParser.parseDirectMessage(data));
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, sentMessageError);
			}
		}

		protected function sentMessageErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, sentMessageError);
		}
		
		protected function deletedMessageHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) 
			{
				deletedMessage.dispatch(loader, TwitterParser.parseDirectMessage(data));
			}
			else
			{
				ResponseUtil.dispatchTwitterError(loader, data, deletedMessageError);
			}
		}
		
		protected function deletedMessageErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, deletedMessageError);
		}
		
		protected function gotIncomingMessagesTimelineHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) {
				gotIncomingMessagesTimeline.dispatch(loader, TwitterParser.parseDirectMessages(data));
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, gotIncomingMessagesTimelineError);
			}
		}
		
		protected function gotIncomingMessagesTimelineErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, gotIncomingMessagesTimelineError);
		}
		
		protected function gotOutgoingMessagesTimelineHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) {
				gotOutgoingMessagesTimeline.dispatch(loader, TwitterParser.parseDirectMessages(data));
			} else {
				ResponseUtil.dispatchTwitterError(loader, data, gotOutgoingMessagesTimelineError);
			}
		}
		
		protected function gotOutgoingMessagesTimelineErrorHandler(loader:XMLLoader, type:String, message:String):void
		{
			ResponseUtil.dispatchError(loader, type, gotOutgoingMessagesTimelineError);
		}
		
		//--------------------------------------------------------------------------
		//
		//  URL Shortener Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function shortenedURLHandler(loader:StringLoader, data:String):void
		{
			var service:IURLShortener = shortenedURLMap[loader.request.url] as IURLShortener;
			
			var originalURL:String = originalURLMap[loader.request.url];
			var _shortenedURL:String = service.parseResponse(data);
			
			shortenedURLMap[loader.request.url] = null;
			originalURLMap[loader.request.url] = null;
			
			if (originalURL)
			{
				shortenedURL.dispatch(loader, originalURL, _shortenedURL);
			}
			else
			{
				shortenedURLError.dispatch(loader, loader.responseStatus, service.parseError(data));
			}
		}
		
		protected function shortenedURLErrorHandler(loader:StringLoader, type:String, message:String):void
		{
			shortenedURLMap[loader.request.url] = null;
			originalURLMap[loader.request.url] = null;
			
			shortenedURLError.dispatch(loader, loader.responseStatus, type);
		}
		
		//--------------------------------------------------------------------------
		//
		//  File Uploader Handlers
		//
		//--------------------------------------------------------------------------

		protected function fileUploadCompleteHandler(event:DataEvent):void
		{
			var file:File = event.currentTarget as File;
			var service:IImageService = fileUploaderMap[file] as IImageService;
			
			removeFileUploaderListenerList(file);
			
			delete fileUploaderMap[file];
			
			var url:String = service.parseUploadResponse(event.data);
			
			if (url)
			{
				uploadedFile.dispatch(file, url);
			}
			else
			{
				uploadedFileError.dispatch(file, -1, service.parseError(event.data));
			}
		}

		protected function fileUploadErrorHandler(event:*):void
		{
			var file:File = (event as Event).currentTarget as File;
			
			removeFileUploaderListenerList(file);
			
			delete fileUploaderMap[file];
		}
		
		protected function fileUploadHTTPStatusHandler(event:HTTPStatusEvent):void
		{
			var file:File = (event as Event).currentTarget as File;
			
			uploadedFileError.dispatch(file, event.status, ResponseUtil.getType(event.status));
		}
	}
}