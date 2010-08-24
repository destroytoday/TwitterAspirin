package com.destroytoday.twitteraspirin.vo
{
	public class RelationshipVO
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var sourceUserID:int;
		
		public var sourceUserScreenName:String;
		
		public var targetUserID:int;
		
		public var targetUserScreenName:String;
		
		public var type:String;
		
		public var blocking:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function RelationshipVO()
		{
		}
	}
}