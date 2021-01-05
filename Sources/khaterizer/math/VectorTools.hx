package khaterizer.math;

class VectorTools {
    public static var random:Random;

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