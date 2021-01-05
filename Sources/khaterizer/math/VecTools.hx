package khaterizer.math;

/**
	Grab bag collection of useful Vector functions.

	Random functions in this class can have their RNG system overridden by assigning
	a Random instance.

	Otherwise, Khaterizer's global static instance is used.
**/
class VecTools {
	public static var random:Random;

	/**
		Generates a random vector within the bounds provided.
	**/
	public static function makeRandomVec2(minX: Float, maxX: Float, minY: Float, maxY: Float): Vec2 {
		if (random == null) return new Vec2(Random.getFloatIn(minX, maxX), Random.getFloatIn(minY, maxY));
		else return new Vec2(random.GetFloatIn(minX, maxX), random.GetFloatIn(minY, maxY));
	}

	public static function assignRNG(rng:Random): Void {
		random = rng;
	}

	public static function unAssignRNG(): Void {
		random = null;
	}
}