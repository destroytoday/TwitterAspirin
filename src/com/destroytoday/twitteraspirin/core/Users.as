package com.destroytoday.twitteraspirin.core {
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.constants.TwitterURL;
	import com.destroytoday.twitteraspirin.net.XMLLoaderPool;
	import com.destroytoday.twitteraspirin.oauth.OAuth;
	import com.destroytoday.twitteraspirin.util.TwitterParserUtil;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.iotashan.oauth.OAuthRequest;
	import org.osflash.signals.Signal;

	public class Users {
		[Inject]
		public var xmlLoaderPool:XMLLoaderPool;
		
		[Inject]
		public var oauth:OAuth;
		
		protected var _getUserSignal:Signal = new Signal(Users, UserVO);
		
		public function Users() {
		}
		
		public function get getUserSignal():Signal {
			return _getUserSignal;
		}
		
		public function getUser(id:Number = NaN, screenName:String = null):XMLLoader {
			var parameters:URLVariables = new URLVariables();
			
			if (id > 0) {
				parameters['user_id'] = id;
			} else if (screenName) {
				parameters['screen_name'] = screenName;
			} else {
				//TODO dispatch error
			}
			
			var loader:XMLLoader = xmlLoaderPool.getObject() as XMLLoader;

			loader.completeSignal.addOnce(getUserHandler);
			
			loader.load(oauth.parseURL(URLRequestMethod.GET, TwitterURL.GET_USER, parameters));
			
			return loader;
		}
		
		protected function getUserHandler(loader:XMLLoader, data:XML):void {
			TwitterParserUtil.parseAccountCallInfo(loader.responseHeaders);
			
			_getUserSignal.dispatch(this, TwitterParserUtil.parseUser(data));
		}
	}
}