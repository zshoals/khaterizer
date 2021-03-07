package khaterizer.math;

/**
	Float value clamped between 0 and 1
**/
abstract KtzNormalizedRange(Float) to Float {
	private inline function new(f: Float) {
		this = f;
	}

	public static inline function normalize(value: Float, initialLowRange: Float, initialHighRange: Float): KtzNormalizedRange {
		if (initialLowRange >= initialHighRange || initialHighRange <= initialLowRange) {
			throw "lowRange value higher than the highRange end value or highRange value lower than the lowRange end value.";
		}
		return new KtzNormalizedRange(KtzMath.remap(value, initialLowRange, initialHighRange, 0, 1));
	}
}