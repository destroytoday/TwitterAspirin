package com.destroytoday.twitteraspirin.urlshortening
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public interface IURLShortener
	{
		function parseURL(url:String):URLRequest;
		
		function parseResponse(response:String):String;
		
		function parseError(error:String):String;
	}
}