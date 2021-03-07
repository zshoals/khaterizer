package khaterizer.math;

/**
	Float value clamped between 0 and 1
**/
abstract KtzNormalizedRange(Float) to Float {
	private inline function new(f: Float) {
		this = f;
	}

	public static inline function normalize(value: Float, initialLowRange: Float, initialHighRange: Float): KtzNormalizedRange {
		assert(initialLowRange < initialHighRange, "lowRange must be lower than highRange");
		assert(initialHighRange > initialLowRange, "highRange must be higher than lowRange");
		assert(value >= initialLowRange && value <= initialHighRange, "value must be between low and high ranges");
		return new KtzNormalizedRange(KtzMath.remap(value, initialLowRange, initialHighRange, 0, 1));
	}
}