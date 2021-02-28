package khaterizer.math;

abstract KtzDegrees(Float) {
	public inline function new(f:Float) {
		this = f % 360;
	}

	@:to
	public inline function toFloat(): Float {
		return this % 360;
	}

	public inline function add(f: KtzDegrees): KtzDegrees {
		return new KtzDegrees((this + f.toFloat()) % 360);
	}

	public inline function sub(f: KtzDegrees): KtzDegrees {
		return new KtzDegrees((this - f.toFloat()) % 360);
	}

	public inline function mult(f: KtzDegrees): KtzDegrees {
		return new KtzDegrees((this * f.toFloat()) % 360);
	}

	public inline function div(f: KtzDegrees): KtzDegrees {
		return new KtzDegrees((this / f.toFloat()) % 360);
	}

	public inline function makeUnitKtzVec2(): KtzVec2 {
		return new KtzVec2(Math.cos(KtzMath.deg2rad(this)), Math.sin(KtzMath.deg2rad(this)));
	}

	public inline function makeKtzRadians(): KtzRadians {
		return new KtzRadians(KtzMath.deg2rad(this));
	}

	public static inline function angleFromKtzVec2(vec: KtzVec2): KtzDegrees {
		return new KtzDegrees(KtzMath.rad2deg(Math.atan2(vec.y, vec.x)));
	}
}