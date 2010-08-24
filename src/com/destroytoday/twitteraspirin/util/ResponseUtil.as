package com.destroytoday.twitteraspirin.util
{
	import com.destroytoday.net.GenericLoader;
	import com.destroytoday.net.GenericLoaderError;
	import com.destroytoday.net.XMLLoader;
	
	import org.osflash.signals.Signal;

	public class ResponseUtil
	{
		protected static const responseTypeMap:Object = 
			{
				'-1': "Not Connected",
				200: "OK",
				304: "Not Modified",
				400: "Bad Request",
				401: "Unauthorized",
				403: "Forbidden",
				404: "Not Found",
				406: "Not Acceptable",
				420: "Enhance Your Calm",
				500: "Internal Server Error",
				502: "Bad Gateway",
				503: "Service Unavailable"
			};
		
		protected static const responseMessageMap:Object = 
			{
				'-1': "There is no internet connection.",
				200: "Success!",
				304: "There is no new data to return.",
				400: "The request is invalid.", // accompanied by error message (rate limiting)
				401: "Authentication credentials are missing or incorrect.",
				403: "The request has been refused.", // accompanied by error message (update limiting)
				404: "The URI requested is invalid or the resource requested does not exist.",
				406: "The request format is invalid.",
				420: "The rate limit has been exceeded.",
				500: "Something in the Twitter API is broken.",
				502: "Twitter is down or upgrading.",
				503: "The Twitter servers are up, but overloaded with requests. Try again later."
			};
		
		public static function getType(responseCode:int):String
		{
			return responseTypeMap[responseCode];
		}
		
		public static function getMessage(responseCode:int):String
		{
			return responseMessageMap[responseCode];
		}
		
		public static function handleResponse(loader:GenericLoader, data:*, parseMethod:Function, successSignal:Signal, errorSignal:Signal):void
		{
			if (loader.responseStatus == 200) 
			{
				successSignal.dispatch(loader, parseMethod(data));
			}
			else
			{
				errorSignal.dispatch(loader, loader.responseStatus, getType(loader.responseStatus), (data is XML ? String(data.error) : data));
			}
		}
		
		public static function dispatchTwitterError(loader:GenericLoader, data:*, signal:Signal):void
		{
			signal.dispatch(loader, loader.responseStatus, getType(loader.responseStatus), (data is XML ? String(data.error) : data));
		}

		public static function dispatchError(loader:GenericLoader, type:String, signal:Signal):void
		{
			if (type == GenericLoaderError.CANCEL) return;
			
			signal.dispatch(loader, loader.responseStatus, "Error: " + getType(loader.responseStatus), getMessage(loader.responseStatus));
		}
	}
}