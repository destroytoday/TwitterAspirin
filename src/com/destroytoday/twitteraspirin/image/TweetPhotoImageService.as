package com.destroytoday.twitteraspirin.image
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.System;
	
	import mx.utils.ObjectUtil;
	
	public class TweetPhotoImageService implements IImageService
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		protected static const GET_ID_REGEX:RegExp = /(http:\/\/)?(www\.)?((tweetphoto\.com)|(pic\.gd))\/([A-Za-z0-9]+)$/i;
		
		protected static const GET_IMAGE_PATTERN:String = "http://TweetPhotoAPI.com/api/TPAPI.svc/imagefromurl?size={size}&url={url}";
		
		//--------------------------------------------------------------------------
		//
		//  Namespaces
		//
		//--------------------------------------------------------------------------
		
		protected namespace ns = "http://tweetphotoapi.com";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function TweetPhotoImageService()
		{
		}
		
		public function get verifyURL():String
		{
			return "https://api.twitter.com/1/account/verify_credentials.xml";
		}
		
		public function get uploadDataField():String
		{
			return "media";
		}
		
		public function parseUploadRequest(request:URLRequest, message:String):URLRequest
		{
			var data:URLVariables = new URLVariables();
			
			data['api_key'] = "279c51da34e7145951f2669328e70866";
			data['message'] = message;
			
			request.url = "http://tweetphotoapi.com/api/upload.aspx";
			request.data = data;
			
			return request;
		}
		
		public function parseUploadResponse(response:String):String
		{
			var xml:XML = new XML(response);

			if (String(xml.ns::Status) == "OK")
			{
				response = String(xml.ns::MediaUrl);
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
				url = GET_IMAGE_PATTERN.replace('{size}', 'medium').replace('{url}', url);
				
				request = new URLRequest(url);
			}
			
			return request;
			
			return null;
		}
		
		public function parseError(error:String):String
		{
			var xml:XML = new XML(error);

			error = String(xml.ns::Error.ns::Message);

			return error;
		}
	}
}