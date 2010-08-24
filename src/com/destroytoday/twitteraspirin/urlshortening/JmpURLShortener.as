package com.destroytoday.twitteraspirin.urlshortening
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.System;

	public class JmpURLShortener implements IURLShortener
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var username:String;
		
		public var apiKey:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function JmpURLShortener(username:String, apiKey:String)
		{
			this.username = username;
			this.apiKey = apiKey;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function parseURL(url:String):URLRequest
		{
			if (url.substr(0.0, 7.0) != "http://" &&
				url.substr(0.0, 8.0) != "https://" &&
				url.substr(0.0, 6.0) != "ftp://")
			{
				url = "http://" + url;
			}
			
			var request:URLRequest = new URLRequest("http://api.bit.ly/v3/shorten");
			var data:URLVariables = new URLVariables();
			
			data['domain'] = 'j.mp';
			data['longUrl'] = url;
			data['format'] = 'xml';
			if (username) data['login'] = username;
			if (apiKey) data['apiKey'] = apiKey;
			
			request.data = data;
			
			return request;
		}
		
		public function parseResponse(response:String):String
		{
			var xml:XML = new XML(response);

			if (String(xml.status_txt) == "OK")
			{
				response = String(xml.data.url);
			}
			else
			{
				response = null;
			}
			
			System.disposeXML(xml);
			
			return (response) ? response : null;
		}
		
		public function parseError(response:String):String
		{
			var xml:XML = new XML(response);
			
			response = String(xml.status_txt);
			
			System.disposeXML(xml);
			
			return response;
		}
	}
}