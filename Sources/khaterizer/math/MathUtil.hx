package khaterizer.math;

class MathUtil {
    public inline static var EPSILON:Float = 0.0000001;

    public inline static function truncate(number:Float, precision:Int):Float {
        var num = number;
        num = num * Math.pow(10, precision);
        return Math.round(num) / Math.pow(10, precision);
    }

    public inline static function clamp(val:Float, minimum:Float, max:Float):Float {
        return Math.min(Math.max(val, minimum), max);
    }

    public inline static function deg2rad(degrees:Float) {
        return degrees * Math.PI / 180;
    }

    public inline static function rad2deg(radians:Float) {
        return radians * 180 / Math.PI;
    }

    public inline static function withinEpsilon(float1:Float, float2:Float, ?customEpsilon:Float) {
        if (customEpsilon == null) {
            return Math.abs(float1 - float2) < MathUtil.EPSILON;
        }
        else {
            return Math.abs(float1 - float2) < customEpsilon;
        }
    }
}
