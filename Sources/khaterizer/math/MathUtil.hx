package khaterizer.math;

class MathUtil {
    public inline static function truncate(number:Float, precision:Int):Float {
        var num = number;
        num = num * Math.pow(10, precision);
        return Math.round(num) / Math.pow(10, precision);
    }

    public inline static function clamp(val:Float, minimum:Float, max:Float):Float {
        return Math.min(Math.max(val, minimum), max);
    }
}
