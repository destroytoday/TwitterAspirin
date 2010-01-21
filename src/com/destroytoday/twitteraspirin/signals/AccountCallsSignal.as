package com.destroytoday.twitteraspirin.signals {
	import org.osflash.signals.Signal;
	
	/**
	 * The AccountCallsSignal dispatches changes to the account API call information.
	 * @author Jonnie Hallman
	 */	
	public class AccountCallsSignal extends Signal {
		public function AccountCallsSignal(...parameters) {
			super(parameters);
		}
	}
}