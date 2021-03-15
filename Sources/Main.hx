package;

import haxe.ds.Vector;
import khaterizer.pirandello.Entity;
import khaterizer.pirandello.Component;
import kha.Shaders;
import khaterizer.KtzInitOptions;
import khaterizer.math.KtzVec2;
import khaterizer.math.KtzRandom;
import kha.Window;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	public static function main() {
		var options: KtzInitOptions = {
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
		KtzRandom.init(456346);
	}
}