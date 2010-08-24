package com.destroytoday.twitteraspirin.image
{
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.System;
	
	public class PosterousImageService implements IImageService
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PosterousImageService()
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
			
			data['source'] = "DestroyTwitter";
			data['sourceLink'] = "http://destroytwitter.com";
			data['message'] = message;
			
			request.url = "http://posterous.com/api2/upload.xml";
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
			return null;
		}
		
		public function parseError(error:String):String
		{
			var xml:XML = new XML(error);
			trace("Posterous :: parseError ::", xml);
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