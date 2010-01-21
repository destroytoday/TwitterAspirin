package com.destroytoday.twitteraspirin.commands {
	import com.destroytoday.twitteraspirin.core.Account;
	
	import org.robotlegs.mvcs.Command;
	
	public class StartupCommand extends Command {
		[Inject]
		public var account:Account;
		
		public function StartupCommand() {
		}
		
		override public function execute():void {
			trace("StartupCommand!");
			
			account.setupListeners();
		}
	}
}