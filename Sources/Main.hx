package;

import khaterizer.pirandello.World;
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
		var config = new WorldConfiguration();
		config.registerComponentTypes([
			Position
		]);
		var w = new World(config);
		var classType = w.retrieveStorage(Position);
	}
}

class Position extends Component {
	public var x: Int;
	public var y: Int;
	public var z: Int;
	public function new() {}

	override function initialize() {
		this.x = 0;
		this.y = 0;
		this.z = 0;
	}
}

class Yeppers extends Component {
	public function new() {}
}