package com.destroytoday.twitteraspirin.util {
	import com.destroytoday.twitteraspirin.vo.OAuthTokenVO;

	public class OAuthUtil {
		public static function parseToken(data:String):OAuthTokenVO {
			var parameterList:Array = data.split('&');
			var key:String = parameterList[0];
			var secret:String = parameterList[1];
			
			key = key.substr(key.indexOf('=') + 1);
			secret = secret.substr(secret.indexOf('=') + 1);

			return new OAuthTokenVO(key, secret);
		}
	}
}