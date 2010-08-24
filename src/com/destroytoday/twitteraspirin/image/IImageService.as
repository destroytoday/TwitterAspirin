package com.destroytoday.twitteraspirin.image
{
	import flash.filesystem.File;
	import flash.net.URLRequest;

	public interface IImageService
	{
		function get verifyURL():String;
		
		function get uploadDataField():String;
		
		function parseUploadRequest(request:URLRequest, message:String):URLRequest;
		
		function parseUploadResponse(response:String):String;
		
		function parseGetImageRequest(url:String):URLRequest;
		
		function parseError(error:String):String;
	}
}