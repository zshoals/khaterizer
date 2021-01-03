package;

import kha.Window;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	public static function main() {
		System.start({title: "Khaterizer Core", width: 1280, height: 720}, init);
	}

	@:keep
	static function init(window:Window) {
		trace("Init");
		TestAll.main();
	}
}
