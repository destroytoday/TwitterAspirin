package com.destroytoday.twitteraspirin.core {
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.constants.TwitterURL;
	import com.destroytoday.twitteraspirin.net.LoaderFactory;
	import com.destroytoday.twitteraspirin.oauth.OAuth;
	import com.destroytoday.twitteraspirin.util.TwitterParser;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
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
		protected var _getMentionsTimelineSignal:Signal = new Signal(Statuses, Vector.<StatusVO>);

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
		 * Returns the Signal that dispatches when getMentionsTimeline is complete.
		 * @return 
		 */		
		public function get getMentionsTimelineSignal():Signal {
			return _getMentionsTimelineSignal;
		}

		/**
		 * Loads the request for the status specified by the provided id.
		 * @param id the id of the status to return
		 * @return the loader of the operation
		 */		
		public function getStatus(id:Number):XMLLoader {
			var loader:XMLLoader = loaderFactory.getXMLLoader(getStatusHandler);

			loader.load(oauth.parseURL(URLRequestMethod.GET, (TwitterURL.GET_STATUS).replace("{id}", id)));
			
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
			var parameters:URLVariables = new URLVariables();

			parameters['status'] = status;
			if (inReplyToStatusID > 0) parameters['in_reply_to_status_id'] = inReplyToStatusID;
			if (latitude < 0 || latitude >= 0) parameters['latitude'] = latitude;
			if (longitude < 0 || longitude >= 0) parameters['longitude'] = longitude;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(updateStatusHandler);
			
			// updateStatus doesn't use API calls
			loader.includeResponseInfo = false;
			loader.request.method = URLRequestMethod.POST;

			loader.load(oauth.parseURL(URLRequestMethod.POST, TwitterURL.UPDATE_STATUS, parameters));
			
			return loader;
		}
		
		public function getMentionsTimeline(sinceID:Number = NaN, maxID:Number = NaN, count:int = 20, page:int = 0):XMLLoader {
			var parameters:URLVariables = new URLVariables();
			
			if (sinceID > 0) parameters['since_id'] = sinceID;
			if (maxID > 0) parameters['max_id'] = maxID;
			parameters['count'] = count;
			if (page > 0) parameters['page'] = page;
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(getMentionsTimelineHandler);
			
			loader.load(oauth.parseURL(URLRequestMethod.GET, TwitterURL.GET_MENTIONS_TIMELINE, parameters));
			
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
			_updateStatusSignal.dispatch(this, TwitterParser.parseStatus(data));
		}
		
		/**
		 * @private
		 * @param loader
		 * @param data
		 */		
		protected function getMentionsTimelineHandler(loader:XMLLoader, data:XML):void {
			_getMentionsTimelineSignal.dispatch(this, TwitterParser.parseStatuses(data));
		}
	}
}