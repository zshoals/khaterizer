package khaterizer.math;

/**
	A Float value between 0 and 1, inclusive. Creating a new instance results in a clamped value between 0 and 1.

	Use normalize to map a value between 0 and 1.
**/
abstract KtzNormalizedRange(Float) to Float {
	public inline function new(f: Float) {
		this = KtzMath.clamp(f, 0, 1);
	}

	public static inline function normalize(value: Float, initialLowRange: Float, initialHighRange: Float): KtzNormalizedRange {
		assert(initialLowRange < initialHighRange, "lowRange must be lower than highRange");
		assert(initialHighRange > initialLowRange, "highRange must be higher than lowRange");
		assert(value >= initialLowRange && value <= initialHighRange, "value must be between low and high ranges");
		return new KtzNormalizedRange(KtzMath.remap(value, initialLowRange, initialHighRange, 0, 1));
	}
}