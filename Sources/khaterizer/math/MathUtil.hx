package khaterizer.math;

class MathUtil {
    public inline static var EPSILON:Float = 0.0000001;

    public inline static function truncate(number:Float, precision:Int): Float {
        var num = number;
        num = num * Math.pow(10, precision);
        return Math.round(num) / Math.pow(10, precision);
    }

    public inline static function clamp(val:Float, minimum:Float, max:Float): Float {
        return Math.min(Math.max(val, minimum), max);
    }

    public inline static function deg2rad(degrees:Float): Float {
        return degrees * Math.PI / 180;
    }

    public inline static function rad2deg(radians:Float): Float {
        return radians * 180 / Math.PI;
    }

    public inline static function areClose(float1:Float, float2:Float, ?customEpsilon:Float): Bool {
        if (customEpsilon == null) {
            return Math.abs(float1 - float2) < EPSILON;
        }
        else {
            trace(Math.abs(float1 - float2));
            return Math.abs(float1 - float2) < customEpsilon;
        }
    }

    public inline static function withinTolerance(number:Float, ?customEpsilon:Float): Bool {
        if (customEpsilon == null) {
            return MathUtil.areClose(number, 0);
        }
        else {
            return MathUtil.areClose(number, 0, customEpsilon);
        }
    }

    public inline static function withinRotationTolerance(degrees:Float, ?customEpsilon:Float): Bool {
        degrees = Math.abs(degrees);

        if (customEpsilon == null) {
            return (degrees > 360 - EPSILON || degrees < 0 + EPSILON);
        }
        else {
            return (degrees > 360 - customEpsilon || degrees < customEpsilon);
        }
    }
}
