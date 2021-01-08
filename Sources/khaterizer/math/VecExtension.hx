package khaterizer.math;

/**
	Grab bag collection of useful Vector functions.

	Random functions in this class can have their RNG system overridden by assigning
	a Random instance.

	Otherwise, Khaterizer's global static instance is used.
**/
class VecExtension {
	private static var random:Random;

	/**
		Generates a random vector within the bounds provided.
	**/
	@:extern
	public inline static function makeRandomVec2(clazz: Vec2, minX: Float, maxX: Float, minY: Float, maxY: Float): Vec2 {
		if (random == null) return new Vec2(Random.getFloatIn(minX, maxX), Random.getFloatIn(minY, maxY));
		else return new Vec2(random.GetFloatIn(minX, maxX), random.GetFloatIn(minY, maxY));
	}

	@:extern
	public inline static function clampVec2(clazz: Vec2, vec: Vec2, vecMin: Vec2, vecMax: Vec2): Vec2 {
		var clampedX = MathUtil.clamp(vec.x, vecMin.x, vecMax.x);
		var clampedY = MathUtil.clamp(vec.y, vecMin.y, vecMax.y);

		return new Vec2(clampedX, clampedY);
	}

	public static function assignRNG(rng: Random): Void {
		random = rng;
	}

	public static function unAssignRNG(): Void {
		random = null;
	}
}