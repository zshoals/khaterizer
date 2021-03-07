package khaterizer.debug;

class Assert {
	public static function assert(condition: Bool, ?message: String = "No message.", ?pos: haxe.PosInfos): Void {
	#if !ktz_disable_assertions
		if (!condition) {
			var className = pos.className;
			var line = pos.lineNumber;
			var file = pos.fileName;
			var method = pos.methodName;

			//This has to be on one line otherwise the tabs are inherited by the interpolated string :|
			var output =
				'\nAssertion Failed: $message\nCondition failure in method "$method" on line $line.\nIn File: $file\nIn Class: $className\n';

			trace(output);
			throw output;
		}
	#end
	}
}