package;

import khaterizer.math.Vec2;
import khaterizer.math.Random;
import kha.Window;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	public static function main() {
		System.start({title: "Khaterizer Core", width: 1280, height: 720}, init);
	}

	static function init(window:Window) {
		//TestAll.main();
		Random.init(1337);
	}
}
