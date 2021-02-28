package khaterizer.math;

/**
	Grab bag collection of useful Vector functions.

	Random functions in this class can have their RNG system overridden by assigning
	a Random instance.

	Otherwise, Khaterizer's global static instance is used.
**/
class KtzVec2Extension {
	private static var random: KtzRandom;

	/**
		Generates a random vector within the bounds provided.
	**/
	@:extern
	public inline static function makeRandomVec2(clazz: KtzVec2, minX: Float, maxX: Float, minY: Float, maxY: Float): KtzVec2 {
		if (random == null) return new KtzVec2(KtzRandom.getFloatIn(minX, maxX), KtzRandom.getFloatIn(minY, maxY));
		else return new KtzVec2(random.GetFloatIn(minX, maxX), random.GetFloatIn(minY, maxY));
	}

	@:extern
	public inline static function clampVec2(clazz: KtzVec2, vec: KtzVec2, vecMin: KtzVec2, vecMax: KtzVec2): KtzVec2 {
		var clampedX = KtzMath.clamp(vec.x, vecMin.x, vecMax.x);
		var clampedY = KtzMath.clamp(vec.y, vecMin.y, vecMax.y);

		return new KtzVec2(clampedX, clampedY);
	}

	@:extern
	public inline static function angleInKtzDegrees(clazz: KtzVec2, v: KtzVec2): KtzDegrees {
		return new KtzDegrees(clazz.angle(v));
	}

	public static function assignRNG(rng: KtzRandom): Void {
		random = rng;
	}

	public static function unAssignRNG(): Void {
		random = null;
	}
}