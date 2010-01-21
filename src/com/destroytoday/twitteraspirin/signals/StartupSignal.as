package com.destroytoday.twitteraspirin.signals {
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class StartupSignal extends Signal implements ISignal {
		public function StartupSignal(...parameters) {
			super(parameters);
		}
	}
}