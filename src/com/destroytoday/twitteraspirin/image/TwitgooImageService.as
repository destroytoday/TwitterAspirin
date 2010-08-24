package com.destroytoday.twitteraspirin.image
{
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.System;
	
	import mx.utils.ObjectUtil;
	
	import org.osmf.utils.URL;
	
	public class TwitgooImageService implements IImageService
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		protected static const GET_IMAGE_PATTERN:String = "http://twitgoo.com/{id}/{size}";
		
		protected static const GET_ID_REGEX:RegExp = /(http:\/\/)?(www.)?twitgoo.com\/([A-Za-z0-9]+)$/i;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function TwitgooImageService()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get verifyURL():String
		{
			return "https://api.twitter.com/1/account/verify_credentials.json";
		}
		
		public function get uploadDataField():String
		{
			return "media";
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function parseUploadRequest(request:URLRequest, message:String):URLRequest
		{
			var data:URLVariables = new URLVariables();
			
			data['source'] = "destroytwitter";
			data['message'] = message;
			
			request.url = "http://twitgoo.com/api/upload";
			request.data = data;
			
			return request;
		}
		
		public function parseUploadResponse(response:String):String
		{
			var xml:XML = new XML(response);
			
			if (String(xml.@status) == "ok")
			{
				response = String(xml.mediaurl);
			}
			else
			{
				response = null;
			}
			
			System.disposeXML(xml);
			
			return response;
		}
		
		public function parseGetImageRequest(url:String):URLRequest
		{
			var matchList:Array = url.match(GET_ID_REGEX);
			var request:URLRequest;

			if (matchList)
			{
				url = GET_IMAGE_PATTERN.replace('{size}', 'Img').replace('{id}', matchList[3]);

				request = new URLRequest(url);
			}
			
			return request;
		}
		
		public function parseError(error:String):String
		{
			var xml:XML = new XML(error);
			trace("Twitgoo :: parseError ::", xml);
			if (String(xml.@status) == "fail" || String(xml.@stat) == "fail")
			{
				error = String(xml.err.@msg);
			}
			else
			{
				error = null;
			}
			
			System.disposeXML(xml);
			
			return error;
		}
	}
}