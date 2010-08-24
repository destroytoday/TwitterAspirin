package com.destroytoday.twitteraspirin.image
{
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.System;
	
	public class PikchurImageService implements IImageService
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		protected static const GET_ID_REGEX:RegExp = /(http:\/\/)?(www\.)?pk\.gd\/([A-Za-z0-9]+)$/i;
		
		protected static const GET_IMAGE_PATTERN:String = "http://img.pikchur.com/pic_{id}_l.jpg";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PikchurImageService()
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
			request.url = "http://api.pikchur.com/simple/upload";
			
			var data:URLVariables = new URLVariables();
			
			data['api_key'] = "5mfj732y1LkRFqHwubf9Lw";
			data['source'] = "NzI0";
			data['message'] = message;
			
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
				url = GET_IMAGE_PATTERN.replace('{id}', matchList[3]);
				
				request = new URLRequest(url);
			}
			
			return request;
		}
		
		public function parseError(error:String):String
		{
			var xml:XML = new XML(error);
			trace("Pikchur :: parseError ::", xml);
			if (String(xml.@stat) == "fail")
			{
				error = String(xml.err.@msg) || "Error occurred";
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