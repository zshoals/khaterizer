package khaterizer.math;

abstract KtzRadians(Float) {
	public inline function new(f: Float) {
		this = f;
	}

	@:to
	public inline function toFloat(): Float {
		return this;
	}

	public inline function add(f: KtzRadians): KtzRadians {
		return new KtzRadians(this + f.toFloat());
	}

	public inline function sub(f: KtzRadians): KtzRadians {
		return new KtzRadians(this - f.toFloat());
	}

	public inline function mult(f: KtzRadians): KtzRadians {
		return new KtzRadians(this * f.toFloat());
	}

	public inline function div(f: KtzRadians): KtzRadians {
		return new KtzRadians(this / f.toFloat());
	}

	public inline function makeKtzDegrees(): KtzDegrees {
		return new KtzDegrees(KtzMath.rad2deg(this));
	}
}