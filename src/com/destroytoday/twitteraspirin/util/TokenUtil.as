package com.destroytoday.twitteraspirin.util {
	import com.destroytoday.twitteraspirin.vo.XAuthTokenVO;
	import com.destroytoday.twitteraspirin.vo.OAuthTokenVO;

	public class TokenUtil {
		public static function parseOAuthToken(data:String):OAuthTokenVO {
			var parameterList:Array = data.split('&');
			var key:String = parameterList[0];
			var secret:String = parameterList[1];
			
			key = key.substr(key.indexOf('=') + 1);
			secret = secret.substr(secret.indexOf('=') + 1);

			return new OAuthTokenVO(key, secret);
		}
		
		public static function parseXAuthToken(data:String):XAuthTokenVO {
			var parameterList:Array = data.split('&');
			var key:String = parameterList[0];
			var secret:String = parameterList[1];
			var id:String = parameterList[2];
			var screenName:String = parameterList[3];
			
			var token:XAuthTokenVO = new XAuthTokenVO();
			
			token.key = key.substr(key.indexOf('=') + 1);
			token.secret = secret.substr(secret.indexOf('=') + 1);
			token.id = Number(id.substr(id.indexOf('=') + 1));
			token.screenName = screenName.substr(screenName.indexOf('=') + 1);
			
			return token;
		}
	}
}