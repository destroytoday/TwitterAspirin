package com.destroytoday.twitteraspirin.core {
	import com.destroytoday.twitteraspirin.signals.CallInfoSignal;

	/**
	 * The Account class consists of the data and methods for the authenticated user.
	 * @author Jonnie Hallman
	 */	
	public class Account {
		/**
		 * @private
		 */		
		[Inject]
		public var callInfoSignal:CallInfoSignal;
		
		/**
		 * @private 
		 */		
		protected var _callsRemaining:int;
		
		/**
		 * @private 
		 */		
		protected var _callLimit:int;
		
		/**
		 * @private 
		 */		
		protected var _callResetDate:Date;
		
		/**
		 * Constructs an Account instance.
		 */		
		public function Account() {
		}
		
		/**
		 * Returns the remaining API calls.
		 * @return 
		 */		
		public function get callsRemaining():int {
			return _callsRemaining;
		}
		
		/**
		 * Returns the API call limit.
		 * @return 
		 */		
		public function get callLimit():int {
			return _callLimit;
		}
		
		/**
		 * Returns the 
		 * @return 
		 */		
		public function get callResetDate():Date {
			return _callResetDate;
		}
		
		//
		// Methods
		//
		
		/**
		 * Adds listeners to injected signals.
		 */		
		public function setupListeners():void {
			callInfoSignal.add(callInfoHandler);
		}
		
		//
		// Handlers
		//
		
		/**
		 * @private
		 * @param callsRemaining
		 * @param callLimit
		 * @param callResetDate
		 */		
		protected function callInfoHandler(callsRemaining:int, callLimit:int, callResetDate:Date):void {
			_callsRemaining = callsRemaining;
			_callLimit = callLimit;
			_callResetDate = callResetDate;
			
			trace(callsRemaining, _callLimit, _callResetDate);
		}
	}
}