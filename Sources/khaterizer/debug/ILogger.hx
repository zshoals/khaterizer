package khaterizer.debug;



interface ILogger {
	public function info(message: String, ?pos: haxe.PosInfos): Void;
	public function debug(message: String, ?pos: haxe.PosInfos): Void;
	public function warn(message: String, ?pos: haxe.PosInfos): Void;
	public function error(message: String, ?pos: haxe.PosInfos): Void;
	public function critical(message: String, ?pos: haxe.PosInfos): Void;
}

