package com.destroytoday.twitteraspirin.urlshortening
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class IsGdURLShortener implements IURLShortener
	{
		public static const URL_REGEX:RegExp = /(?<!@)(\b)((((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp):\/\/)|(www\.))*((([a-zA-Z0-9_-]+\.)+(aero|asia|biz|cat|com|coop|edu|gov|int|info|jobs|mobi|museum|name|net|org|pro|tel|travel|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bl|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cu|cv|cx|cy|cz|de|dj|dk|dm|do|dz|ec|ee|eg|eh|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mf|mg|mh|mil|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|st|su|sv|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|um|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|yu|za|zm|zw))|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(\/[a-zA-Z0-9\+\&amp;%_\.\/\-\~\-\#\?\:\=,]*)?(\/|\b))/ig;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function IsGdURLShortener()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function parseURL(url:String):URLRequest
		{
			if (url.substr(0.0, 7.0) != "http://" &&
				url.substr(0.0, 8.0) != "https://" &&
				url.substr(0.0, 6.0) != "ftp://")
			{
				url = "http://" + url;
			}
			
			var request:URLRequest = new URLRequest("http://is.gd/api.php");
			var data:URLVariables = new URLVariables();
			
			data['longurl'] = url;
			
			request.data = data;
			
			return request;
		}
		
		public function parseResponse(response:String):String
		{
			URL_REGEX.lastIndex = 0;
			
			return URL_REGEX.test(response) ? response : null;
		}
		
		public function parseError(response:String):String
		{
			return response;
		}
	}
}