package com.destroytoday.twitteraspirin.core {
	import com.destroytoday.twitteraspirin.signals.AccountCallsSignal;

	/**
	 * The Account class consists of the data and methods for the authenticated user.
	 * @author Jonnie Hallman
	 */	
	public class Account {
		[Inject]
		public var callsSignal:AccountCallsSignal;
		
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
			callsSignal.add(callsHandler);
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
		protected function callsHandler(callsRemaining:int, callLimit:int, callResetDate:Date):void {
			_callsRemaining = callsRemaining;
			_callLimit = callLimit;
			_callResetDate = callResetDate;
		}
	}
}