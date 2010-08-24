package com.destroytoday.twitteraspirin.image
{
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.System;
	
	public class YfrogImageService implements IImageService
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		protected static const GET_ID_REGEX:RegExp = /(http:\/\/)?(www\.)?yfrog\.(com|ru|com\.tr|it|fr|co\.il|co\.uk|com\.pl|pl|eu)\/([A-Za-z0-9]+[jpg])$/i;
		
		protected static const GET_IMAGE_PATTERN:String = "{url}:iphone";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function YfrogImageService()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get verifyURL():String
		{
			return "https://api.twitter.com/1/account/verify_credentials.xml";
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
			
			data['key'] = "456BFPUY3861e37a5f23685ae000ab6a1f530ca8";
			data['message'] = message;
			
			request.url = "https://yfrog.com/api/xauth_upload";
			request.data = data;

			return request;
		}
		
		public function parseUploadResponse(response:String):String
		{
			var xml:XML = new XML(response);

			if (String(xml.@stat) == "ok")
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
				url = GET_IMAGE_PATTERN.replace('{url}', url);
				
				request = new URLRequest(url);
			}
			
			return request;
		}
		
		public function parseError(error:String):String
		{
			var xml:XML = new XML(error);

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