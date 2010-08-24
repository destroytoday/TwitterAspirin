package com.destroytoday.twitteraspirin.urlshortening
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class TinyURLShortener implements IURLShortener
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function TinyURLShortener()
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
			
			var request:URLRequest = new URLRequest("http://tinyurl.com/api-create.php");
			var data:URLVariables = new URLVariables();
			
			data['url'] = url;
			
			request.data = data;
			
			return request;
		}
		
		public function parseResponse(response:String):String
		{
			return response;
		}
		
		public function parseError(response:String):String
		{
			return "Error";
		}
	}
}