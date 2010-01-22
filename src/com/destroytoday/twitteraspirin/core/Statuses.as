package com.destroytoday.twitteraspirin.core {
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.constants.TwitterURL;
	import com.destroytoday.twitteraspirin.net.XMLLoaderPool;
	import com.destroytoday.twitteraspirin.oauth.OAuth;
	import com.destroytoday.twitteraspirin.util.TwitterParser;
	import com.destroytoday.twitteraspirin.vo.StatusVO;
	
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.utils.ObjectUtil;
	
	import org.iotashan.utils.URLEncoding;
	import org.osflash.signals.Signal;

	public class Statuses {
		[Inject]
		public var xmlLoaderPool:XMLLoaderPool;
		
		[Inject]
		public var oauth:OAuth;
		
		protected var _updateStatusSignal:Signal = new Signal(Statuses, StatusVO);

		public function Statuses() {
		}
		
		public function get updateStatusSignal():Signal {
			return _updateStatusSignal;
		}
		
		public function updateStatus(status:String, inReplyToStatusID:Number = NaN, latitude:Number = NaN, longitude:Number = NaN):XMLLoader {
			var parameters:URLVariables = new URLVariables();

			parameters['status'] = status;
			if (inReplyToStatusID > 0) parameters['in_reply_to_status_id'] = inReplyToStatusID;
			if (latitude < 0 || latitude >= 0) parameters['latitude'] = latitude;
			if (longitude < 0 || longitude >= 0) parameters['longitude'] = longitude;
			
			var loader:XMLLoader = xmlLoaderPool.getObject() as XMLLoader;
			
			loader.completeSignal.addOnce(updateStatusHandler);
			
			loader.includeResponseInfo = false;
			loader.request.method = URLRequestMethod.POST;

			loader.load(oauth.parseURL(URLRequestMethod.POST, TwitterURL.UPDATE_STATUS, parameters));
			
			return loader;
		}
		
		protected function updateStatusHandler(loader:XMLLoader, data:XML):void {
			_updateStatusSignal.dispatch(this, TwitterParser.parseStatus(data));
		}
	}
}