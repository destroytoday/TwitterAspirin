package com.destroytoday.twitteraspirin.image
{
	import flash.net.URLRequest;
	
	public class GenericImageService
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		protected static const EXTENSION_REGEX:RegExp = /\.(gif|jpg|jpeg|png)$/i;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function GenericImageService()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get uploadDataField():String
		{
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function parseUploadRequest(screenName:String, password:String):URLRequest
		{
			return null;
		}
		
		public function parseUploadResponse(response:String):String
		{
			return null;
		}
		
		public function parseGetImageRequest(url:String):URLRequest
		{
			EXTENSION_REGEX.lastIndex = 0;
			
			if (EXTENSION_REGEX.test(url))
			{
				return new URLRequest(url);
			}
			
			return null;
		}
		
		public function parseError(error:String):String
		{
			return null;
		}
	}
}