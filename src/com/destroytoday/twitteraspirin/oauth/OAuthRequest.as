package com.destroytoday.twitteraspirin.oauth {
	import com.destroytoday.net.URLParameter;
	import com.destroytoday.pool.ObjectWaterpark;
	import com.destroytoday.twitteraspirin.constants.OAuthSignatureMethod;
	import com.destroytoday.twitteraspirin.vo.OAuthConsumerVO;
	import com.destroytoday.twitteraspirin.vo.OAuthTokenVO;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import mx.utils.UIDUtil;

	public class OAuthRequest {
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var method:String;
		
		public var url:String;
		
		public var consumer:OAuthConsumerVO;
		
		public var token:OAuthTokenVO;
		
		protected var _signatureMethod:String = OAuthSignatureMethod.HMAC_SHA1;
		
		protected var _version:String = "1.0";
		
		protected var parameterList:Vector.<URLParameter> = new Vector.<URLParameter>();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function OAuthRequest(consumer:OAuthConsumerVO = null, url:String = null, method:String = URLRequestMethod.GET, token:OAuthTokenVO = null) {
			this.consumer = consumer;
			this.url = url;
			this.method = method;
			this.token = token;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function getURLRequest(parameterMap:Object = null):URLRequest {
			disposeParameterList();
			
			if (parameterMap) {
				for (var parameterName:String in parameterMap) {
					addParameter(parameterName, encode(parameterMap[parameterName]));
				}
			}
			
			var nonce:String = UIDUtil.createUID().replace(/\-/g, "");
			var timestamp:int = new Date().time * 0.001;
			
			if (token) addParameter('oauth_token', token.key);
			addParameter('oauth_consumer_key', consumer.key);
			addParameter('oauth_timestamp', String(timestamp));
			addParameter('oauth_nonce', nonce);
			addParameter('oauth_signature_method', _signatureMethod);
			addParameter('oauth_version', _version);
			
			parameterList.sort(compareParameters);

			var signature:String = method + "&" + encode(url) + "&" + encode(parameterList.join("&"));

			var key:String = consumer.secret + "&";
			if (token) key += token.secret;

			signature = 
				Base64.encodeByteArray(
					Crypto.getHMAC("sha1").compute(
						Hex.toArray(Hex.fromString(key)), 
						Hex.toArray(Hex.fromString(signature))
					)
				);

			addParameter('oauth_signature', encode(signature));
			
			var request:URLRequest = new URLRequest(url);

			request.method = method;
			request.data = parameterList.join("&");
			request.authenticate = false;
			request.cacheResponse = false;
			request.manageCookies = false;
			request.useCache = false;
			
			return request;
		}
		
		public function dispose():void {
			disposeParameterList();
			
			method = null;
			url = null;
			consumer = null;
			token = null;
		}
		
		protected function disposeParameterList():void {
			for each (var parameter:URLParameter in parameterList) {
				ObjectWaterpark.disposeObject(parameter);
			}
		}
		
		protected function addParameter(name:String, value:String):void {
			var parameter:URLParameter = ObjectWaterpark.getObject(URLParameter) as URLParameter;
			
			parameter.name = name;
			parameter.value = value;
			
			parameterList[parameterList.length] = parameter;
		}
		
		protected function compareParameters(a:URLParameter, b:URLParameter):Number {
			if (a.name < b.name) {
				return -1.0;
			} else if (a.name > b.name) {
				return 1.0;
			} else if (a.value < b.value) {
				return -1.0;
			} else if (a.value > b.value) {
				return 1.0;
			}
			
			return 0.0;
		}
		
		protected function encode(str:String):String {
			return escape(unescape(encodeURIComponent(str))).replace(/%7E/g, '~').replace(/@/g, '%40').replace(/\*/g, '%2A').replace(/\+/g, '%2B').replace(/\//g, '%2F');
		}
	}
}