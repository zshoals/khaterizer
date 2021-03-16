package;

import khaterizer.pirandello.Phase;
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

		var inputPhase = new Phase(1, [
			SuperSystem
		]);

		config.registerComponentTypes([
			Position
		]);
		config.registerPhasedSystems([
			inputPhase,
			inputPhase
		]);

		var w = new World(config);
		var classType = w.retrieveStorage(Position);
		var sys = w.retrieveSystem(SuperSystem);
		trace(sys);
		trace("Are we alive");
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

class SuperSystem extends khaterizer.pirandello.System {
	public var iamasystem: Int;

	public function new() {}
}