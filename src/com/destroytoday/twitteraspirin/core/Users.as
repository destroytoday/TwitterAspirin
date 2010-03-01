package com.destroytoday.twitteraspirin.core {
	import com.destroytoday.net.XMLLoader;
	import com.destroytoday.twitteraspirin.constants.TwitterURL;
	import com.destroytoday.twitteraspirin.net.LoaderFactory;
	import com.destroytoday.twitteraspirin.oauth.OAuth;
	import com.destroytoday.twitteraspirin.util.TwitterParser;
	import com.destroytoday.twitteraspirin.vo.UserVO;
	
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.osflash.signals.Signal;

	/**
	 * The Users class handles all user-related API methods.
	 * @author Jonnie Hallman
	 */	
	public class Users {
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
		protected var _getUserSignal:Signal = new Signal(Users, UserVO);
		
		/**
		 * Constructs the Users instance.
		 */		
		public function Users() {
		}
		
		/**
		 * Returns the Signal that dispatches when getUser is complete.
		 * @return 
		 */		
		public function get getUserSignal():Signal {
			return _getUserSignal;
		}
		
		/**
		 * Loads a request for the information of a given user.
		 * @param id the id of the user
		 * @param screenName the screen name of the user
		 * @return 
		 */		
		/*public function getUser(id:Number = NaN, screenName:String = null):XMLLoader {
			var parameters:URLVariables = new URLVariables();
			
			if (id > 0) {
				parameters['user_id'] = id;
			} else if (screenName) {
				parameters['screen_name'] = screenName;
			} else {
				//TODO dispatch error
			}
			
			var loader:XMLLoader = loaderFactory.getXMLLoader(getUserHandler);

			loader.load(oauth.parseURL(URLRequestMethod.GET, TwitterURL.GET_USER, parameters));
			
			return loader;
		}*/
		
		/**
		 * @private
		 * @param loader
		 * @param data
		 */		
		protected function getUserHandler(loader:XMLLoader, data:XML):void {
			_getUserSignal.dispatch(this, TwitterParser.parseUser(data));
		}
	}
}