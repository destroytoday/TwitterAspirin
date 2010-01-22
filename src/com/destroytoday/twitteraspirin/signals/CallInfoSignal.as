package com.destroytoday.twitteraspirin.signals {
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	/**
	 * The AccountCallsSignal dispatches changes to the account API call information.
	 * @author Jonnie Hallman
	 */	
	public class CallInfoSignal extends Signal implements ISignal {
		public function CallInfoSignal() {
			super(int, int, Date);
		}
	}
}