package com.destroytoday.twitteraspirin.image
{
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.System;
	
	import mx.utils.ObjectUtil;
	
	public class ImgurImageService implements IImageService
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		protected static const GET_ID_REGEX:RegExp = /(http:\/\/)?(www\.)?imgur\.com\/([A-Za-z0-9]+)$/i;
		
		protected static const GET_IMAGE_PATTERN:String = "http://i.imgur.com/{id}.jpg";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ImgurImageService()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get verifyURL():String
		{
			return null;
		}
		
		public function get uploadDataField():String
		{
			return "image";
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function parseUploadRequest(request:URLRequest, message:String):URLRequest
		{
			var data:URLVariables = new URLVariables();
			
			data['key'] = "0508b18000b8a3bcda097c6392efe9ed";
			data['message'] = message;
			
			request.url = "http://imgur.com/api/upload.xml";
			request.data = data;
			
			return request;
		}
		
		public function parseUploadResponse(response:String):String
		{
			var xml:XML = new XML(response);
			
			response = String(xml.imgur_page);
			
			System.disposeXML(xml);
			
			return response;
		}
		
		public function parseGetImageRequest(url:String):URLRequest
		{
			var matchList:Array = url.match(GET_ID_REGEX);
			var request:URLRequest;

			if (matchList)
			{
				url = GET_IMAGE_PATTERN.replace('{id}', matchList[3]);
				
				request = new URLRequest(url);
			}

			return request;
		}
		
		public function parseError(error:String):String
		{
			var xml:XML = new XML(error);
			trace("Imgur :: parseError ::", xml);
			if (String(xml.@stat) == "fail")
			{
				error = String(xml.error_msg);
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