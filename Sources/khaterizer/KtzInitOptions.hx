package khaterizer;

import kha.WindowMode;

@:structInit
class KtzInitOptions {
	@:optional public var title: String = "Khaterizer Project";
	@:optional public var x: Int = -1;
	@:optional public var y: Int = -1;
	@:optional public var width: Int = 800;
	@:optional public var height: Int = 600;

	@:optional public var wMinimizable: Bool = true;
	@:optional public var wMaximizable: Bool = true;
	@:optional public var wResizable: Bool = true;
	@:optional public var wBorderless: Bool = false;
	@:optional public var wOnTop: Bool = false;
	@:optional public var mode: WindowMode = Windowed;
	@:optional public var verticalSync: Bool = true;

	@:optional public var systemUpdateRate: Int = 60;

	public function new(title: String = "Khaterizer Project", ?x: Int = -1, ?y: Int = -1, ?width: Int = 800, ?height: Int = 600,
		?mode: WindowMode = WindowMode.Windowed,
		?wMinimizable: Bool = true, ?wMaximizable: Bool = true, ?wResizable: Bool = true,
		?wBorderless: Bool = false, ?wOnTop: Bool = false,
		?verticalSync: Bool = true,
		?systemUpdateRate: Int = 60) {
			this.title = title;
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.wMinimizable = wMinimizable;
			this.wMaximizable = wMaximizable;
			this.wResizable = wResizable;
			this.wBorderless = wBorderless;
			this.wOnTop = wOnTop;
			this.mode = mode;
			this.verticalSync = verticalSync;
			this.systemUpdateRate = systemUpdateRate;
	}
}