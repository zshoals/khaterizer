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
		var ints = Random.amassInts(0, 400, 10);
		var vec = new Vec2(20, 20);
		var out:Vec2 = vec.add(new Vec2(10, 10));

	}
}
