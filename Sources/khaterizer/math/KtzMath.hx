package khaterizer.math;

class KtzMath {
	public inline static var EPSILON:Float = 0.0000001;

	public inline static function truncate(number: Float, precision: Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		return Math.round(num) / Math.pow(10, precision);
	}

	public inline static function clamp(val: Float, minimum: Float, max: Float): Float {
		return Math.min(Math.max(val, minimum), max);
	}

	public inline static function deg2rad(degrees: Float): Float {
		return degrees * Math.PI / 180;
	}

	public inline static function rad2deg(radians: Float): Float {
		return radians * 180 / Math.PI;
	}

	/**
	 * Remaps a number from one range to another. Stolen from HaxeFlixel.
	 *
	 * @param 	value	The incoming value to be converted
	 * @param 	start1 	Lower bound of the value's current range
	 * @param 	stop1 	Upper bound of the value's current range
	 * @param 	start2  Lower bound of the value's target range
	 * @param 	stop2 	Upper bound of the value's target range
	 * @return The remapped value
	 */
	public inline static function remap(value: Float, start1: Float, stop1: Float, start2: Float, stop2: Float): Float
	{
		return start2 + (value - start1) * ((stop2 - start2) / (stop1 - start1));
	}

	public inline static function areClose(float1: Float, float2: Float, ?customEpsilon: Float): Bool {
		if (customEpsilon == null) {
			customEpsilon = EPSILON;
		}

		return Math.abs(float1 - float2) < customEpsilon;
	}

	public inline static function withinRotationTolerance(degrees: Float, ?customEpsilon: Float): Bool {
		degrees = Math.abs(degrees);

		if (customEpsilon == null) {
			customEpsilon = EPSILON;
		}

		return (degrees > 360 - customEpsilon || degrees < customEpsilon);
	}
}
