package khaterizer.debug;

class KtzLog {
	private var impl: ILogger;

	public function new() {
		#if !ktz_disable_logging
		impl = new StandardLogger();
		#else
		impl = new EmptyLogger();
		#end
	}

	public function info(message: String, ?pos: haxe.PosInfos): Void {
		impl.info(message, pos);
	}

	public function debug(message: String, ?pos: haxe.PosInfos): Void {
		impl.debug(message, pos);
	}

	public function warn(message: String, ?pos: haxe.PosInfos): Void {
		impl.warn(message, pos);
	}

	public function error(message: String, ?pos: haxe.PosInfos): Void {
		impl.error(message, pos);
	}

	public function critical(message: String, ?pos: haxe.PosInfos): Void {
		impl.critical(message, pos);
	}

}

class StandardLogger implements ILogger {
	public function new() {}

	public function info(message: String, ?pos: haxe.PosInfos): Void {
		var out = '[KtzLogger - Info: ${buildMessage(message, pos)}';
		trace(out);
	};

	public function debug(message: String, ?pos: haxe.PosInfos): Void {
		var out = '[KtzLogger - Debug: ${buildMessage(message, pos)}';
		trace(out);
	};

	public function warn(message: String, ?pos: haxe.PosInfos): Void {
		var out = '[**KtzLogger - Warn**: ${buildMessage(message, pos)}';
		trace(out);
	};

	public function error(message: String, ?pos: haxe.PosInfos): Void {
		var out = '[**!KtzLogger - Error!**: ${buildMessage(message, pos)}';
		trace(out);
	};

	public function critical(message: String, ?pos: haxe.PosInfos): Void {
		var out = '[!!!KtzLogger - CRITICAL!!!: ${buildMessage(message, pos)}';
		trace(out);
	};

	private function buildMessage(message: String, pos: haxe.PosInfos): String {
		var className = pos.className;
		var line = pos.lineNumber;
		var file = pos.fileName;
		var method = pos.methodName;

		var out = '$message] From $method on line $line in $className';
		return out;
	}
}

class EmptyLogger implements ILogger {
	public function new() {}

	public function info(message: String, ?pos: haxe.PosInfos): Void {};
	public function debug(message: String, ?pos: haxe.PosInfos): Void {};
	public function warn(message: String, ?pos: haxe.PosInfos): Void {};
	public function error(message: String, ?pos: haxe.PosInfos): Void {};
	public function critical(message: String, ?pos: haxe.PosInfos): Void {};
}