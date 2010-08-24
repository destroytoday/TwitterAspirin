package com.destroytoday.twitteraspirin.image
{
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.System;
	
	public class TwitpicImageService implements IImageService
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		protected static const GET_ID_REGEX:RegExp = /(http:\/\/)?(www\.)?twitpic\.com\/([A-Za-z0-9]+)$/i;
		
		protected static const GET_IMAGE_PATTERN:String = "http://twitpic.com/show/{size}/{id}";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function TwitpicImageService()
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
			
			data['key'] = "95759afbee758fb6fff2d554f310c63b";
			data['message'] = message;
			
			request.url = "http://api.twitpic.com/2/upload.xml";
			request.data = data;
			
			return request;
		}
		
		public function parseUploadResponse(response:String):String
		{
			var xml:XML = new XML(response);
			
			response = String(xml.url);
			
			System.disposeXML(xml);
			
			return response;
		}
		
		public function parseGetImageRequest(url:String):URLRequest
		{
			var matchList:Array = url.match(GET_ID_REGEX);
			var request:URLRequest;
			
			if (matchList)
			{
				url = GET_IMAGE_PATTERN.replace('{size}', 'large').replace('{id}', matchList[3]);
				
				request = new URLRequest(url);
			}

			return request;
		}
		
		public function parseError(error:String):String
		{
			var xml:XML = new XML(error);
			trace("Twitpic :: parseError ::", xml);
			if (String(xml.@stat) == "fail")
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