package;

import khaterizer.InitOptions;
import khaterizer.math.Vec2;
import khaterizer.math.Random;
import kha.Window;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	public static function main() {
		var options: InitOptions = {
			title: "Khaterizer Core",
			width: 1280,
			height: 720,
			systemUpdateRate: 60
		};

		//Initialize Khaterizer and pass in options
		//System.start begins in there

		System.start({title: "Khaterizer Core", width: 1280, height: 720}, init);
	}

	static function init(window:Window) {
		//TestAll.main();
		Random.init(456346);
		throw new js.lib.Error("WTF");
		Random.init(1337);
	}
}
