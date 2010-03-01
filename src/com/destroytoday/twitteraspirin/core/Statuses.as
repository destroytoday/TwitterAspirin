package com.destroytoday.twitteraspirin.core {
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.constants.TwitterURL;
	import com.destroytoday.twitteraspirin.net.LoaderFactory;
	import com.destroytoday.twitteraspirin.oauth.OAuth;
	import com.destroytoday.twitteraspirin.util.TwitterParser;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.utils.ObjectUtil;
	
	import org.osflash.signals.Signal;

	/**
	 * The Statuses class handles all status-related API methods.
	 * @author Jonnie Hallman
	 */	
	public class Statuses {
		/**
		 * @private 
		 */
		[Inject]
		public var loaderFactory:LoaderFactory;
		
		/**
		 * @private 
		 */
		[Inject]
		public var oauth:OAuth;
		
		/**
		 * @private 
		 */		
		protected var _getStatusSignal:Signal = new Signal(Statuses, StatusVO);
		
		/**
		 * @private 
		 */
		protected var _updateStatusSignal:Signal = new Signal(Statuses, StatusVO);
		
		/**
		 * @private 
		 */
		protected var _getHomeTimelineSignal:Signal = new Signal(Statuses, Vector.<StatusVO>);
		
		/**
		 * @private 
		 */
		protected var _getMentionsTimelineSignal:Signal = new Signal(Statuses, Vector.<StatusVO>);
		
		/**
		 * @private 
		 */
		protected var _getSearchTimelineSignal:Signal = new Signal(Statuses, Vector.<StatusVO>);

		/**
		 * Constructs the Statuses instance.
		 */		
		public function Statuses() {
		}
		
		/**
		 * Returns the Signal that dispatches when getStatus is complete.
		 * @return 
		 */		
		public function get getStatusSignal():Signal {
			return _getStatusSignal;
		}
		
		/**
		 * Returns the Signal that dispatches when updateStatus is complete.
		 * @return 
		 */		
		public function get updateStatusSignal():Signal {
			return _updateStatusSignal;
		}
		
		/**
		 * Returns the Signal that dispatches when getHomeTimeline is complete.
		 * @return 
		 */		
		public function get getHomeTimelineSignal():Signal {
			return _getHomeTimelineSignal;
		}
		
		/**
		 * Returns the Signal that dispatches when getMentionsTimeline is complete.
		 * @return 
		 */		
		public function get getMentionsTimelineSignal():Signal {
			return _getMentionsTimelineSignal;
		}
		
		/**
		 * Returns the Signal that dispatches when getSearchTimeline is complete.
		 * @return 
		 */		
		public function get getSearchTimelineSignal():Signal {
			return _getSearchTimelineSignal;
		}

		/**
		 * Loads the request for the status specified by the provided id.
		 * @param id the id of the status to return
		 * @return the loader of the operation
		 */		
		public function getStatus(id:Number):XMLLoader {
			var loader:XMLLoader = loaderFactory.getXMLLoader(getStatusHandler);

			loader.request = oauth.getURLRequest((TwitterURL.GET_STATUS).replace("{id}", id), URLRequestMethod.GET);
			
			loader.load();
			
			return loader;
		}
		
		/**
		 * Loads the request for updating the authenticated user's status.
		 * @param status the status text
		 * @param inReplyToStatusID the id of the status this is in response to
		 * @param latitude the location's latitude
		 * @param longitude the location's longitude
		 * @return the loader of the operation
		 */		
		public function updateStatus(status:String, inReplyToStatusID:Number = NaN, latitude:Number = NaN, longitude:Number = NaN):XMLLoader {
			var parameters:Object = {};

			//TODO - fix issue with statuses including linebreaks
			
			parameters['status'] = status;
			if (inReplyToStatusID > 0) parameters['in_reply_to_status_id'] = inReplyToStatusID;
			if (latitude < 0 || latitude >= 0) parameters['latitude'] = latitude;
			if (longitude < 0 || longitude >= 0) parameters['longitude'] = longitude;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(updateStatusHandler);

			loader.request = oauth.getURLRequest(TwitterURL.UPDATE_STATUS, URLRequestMethod.POST, parameters);

			loader.load();
			
			return loader;
		}
		
		public function getHomeTimeline(sinceID:Number = NaN, maxID:Number = NaN, count:int = 20, page:int = 1):XMLLoader {
			var parameters:Object = {};
			
			if (sinceID > 0) parameters['since_id'] = sinceID;
			if (maxID > 0) parameters['max_id'] = maxID;
			parameters['count'] = count;
			if (page > 1) parameters['page'] = page;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(getHomeTimelineHandler);
			
			loader.request = oauth.getURLRequest(TwitterURL.GET_HOME_TIMELINE, URLRequestMethod.GET, parameters);
			
			loader.load();
			
			return loader;
		}
		
		/**
		 * Loads the request for returning the authenticated user's mentions timeline.
		 * @param sinceID the id to return mentions since
		 * @param maxID the maximum status id
		 * @param count the number of mentions to return
		 * @param page the page of mentions to return, starting at 1
		 * @return the loader of the operation
		 */		
		public function getMentionsTimeline(sinceID:Number = NaN, maxID:Number = NaN, count:int = 20, page:int = 1):XMLLoader {
			var parameters:Object = {};
			
			if (sinceID > 0) parameters['since_id'] = sinceID;
			if (maxID > 0) parameters['max_id'] = maxID;
			parameters['count'] = count;
			if (page > 1) parameters['page'] = page;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(getMentionsTimelineHandler);
			
			loader.request = oauth.getURLRequest(TwitterURL.GET_MENTIONS_TIMELINE, URLRequestMethod.GET, parameters);
			
			loader.load();
			
			return loader;
		}
		
		/**
		 * Loads the request for returning a search of the provided query
		 * @param query the text to search for
		 * @param sinceID the id to return statuses since
		 * @param count the number of statuses to return (maximum 100)
		 * @param page the page of statuses to return, starting at 1
		 * @param geocode the location to return statuses for in 'latitude,longitude,radius' format, where radius is specified by 'mi' or 'km'
		 * @param showUser specifies whether to prepend the status text with the user's screen name
		 * @param language restricts tweets to the given language, give by an ISO-639-1 code
		 * @param locale the language of the query you are sending
		 * @return 
		 */		
		public function getSearchTimeline(query:String, sinceID:Number = NaN, count:int = 20, page:int = 1, geocode:String = null, showUser:Boolean = false, language:String = null, locale:String = null):XMLLoader {
			var parameters:Object = {};
			
			parameters['q'] = query;
			if (sinceID > 0) parameters['sinceID'] = sinceID;
			parameters['count'] = count;
			if (page > 1) parameters['page'] = page;
			if (geocode) parameters['geocode'] = geocode;
			if (showUser) parameters['show_user'] = "true";
			if (language) parameters['language'] = language;
			if (locale) parameters['locale'] = locale;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(getSearchTimelineHandler);
			
			// search does use API calls, but doesn't return call info headers
			loader.includeResponseInfo = false;
			loader.request = oauth.getURLRequest(TwitterURL.GET_SEARCH_TIMELINE, URLRequestMethod.GET, parameters);
			
			loader.load();
			
			return loader;
		}
		
		/**
		 * @private
		 * @param loader
		 * @param data
		 */		
		protected function getStatusHandler(loader:XMLLoader, data:XML):void {
			_getStatusSignal.dispatch(this, TwitterParser.parseStatus(data));
		}
		
		/**
		 * @private
		 * @param loader
		 * @param data
		 */		
		protected function updateStatusHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) {
				_updateStatusSignal.dispatch(this, TwitterParser.parseStatus(data));
			} else {
				//TODO dispatch error
				trace(ObjectUtil.toString(loader.responseHeaders), data);
			}
		}
		
		/**
		 * @private
		 * @param loader
		 * @param data
		 */		
		protected function getHomeTimelineHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) {
				_getHomeTimelineSignal.dispatch(this, TwitterParser.parseStatuses(data));
			} else {
				//TODO dispatch error
				trace(ObjectUtil.toString(loader.responseHeaders), data);
			}
		}
		
		/**
		 * @private
		 * @param loader
		 * @param data
		 */		
		protected function getMentionsTimelineHandler(loader:XMLLoader, data:XML):void {
			if (loader.responseStatus == 200) {
				_getMentionsTimelineSignal.dispatch(this, TwitterParser.parseStatuses(data));
			} else {
				//TODO dispatch error
				trace(ObjectUtil.toString(loader.responseHeaders), data);
			}
		}
		
		/**
		 * @private
		 * @param loader
		 * @param data
		 */		
		protected function getSearchTimelineHandler(loader:XMLLoader, data:XML):void {
			_getSearchTimelineSignal.dispatch(this, TwitterParser.parseSearchStatuses(data));
			
			//TODO error handling
		}
	}
}