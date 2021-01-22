package khaterizer.math;

abstract KtzDegrees(Float) {
	public inline function new(f:Float) {
		this = f % 360;
	}

	@:to
	public inline function toFloat(): Float {
		return this % 360;
	}

	public inline function add(f:Float): KtzDegrees {
		return new KtzDegrees((this + f) % 360);
	}

	public inline function sub(f:Float): KtzDegrees {
		return new KtzDegrees((this - f) % 360);
	}

	public inline function mult(f:Float): KtzDegrees {
		return new KtzDegrees((this * f) % 360);
	}

	public inline function div(f:Float): KtzDegrees {
		return new KtzDegrees((this / f) % 360);
	}

	public inline function toUnitKtzVec2(): KtzVec2 {
		return new KtzVec2(Math.cos(KtzMath.deg2rad(this)), Math.sin(KtzMath.deg2rad(this)));
	}

	public inline function fromKtzVec2(vec:KtzVec2): KtzDegrees {
		return new KtzDegrees(KtzMath.rad2deg(Math.atan2(vec.x, vec.y)));
	}
}