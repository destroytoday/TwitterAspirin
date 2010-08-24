package com.destroytoday.twitteraspirin.urlshortening
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.System;

	public class DiggURLShortener implements IURLShortener
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DiggURLShortener()
		{
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
			
			var request:URLRequest = new URLRequest("http://services.digg.com/1.0/endpoint");
			var data:URLVariables = new URLVariables();
			
			data['method'] = 'shorturl.create';
			data['url'] = url;
			
			request.data = data;
			
			return request;
		}
		
		public function parseResponse(response:String):String
		{
			var xml:XML = new XML(response);

			if (String(xml.name()) == "shorturls")
			{
				response = String(xml.shorturl.@short_url);
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
			
			response = String(xml.@message);
			
			System.disposeXML(xml);
			
			return response;
		}
	}
}