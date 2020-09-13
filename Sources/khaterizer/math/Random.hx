package khaterizer.math;

/**
    Jury-rigged Implementation of xoshiro128** PRNG with kha.math.Random's interface.

    Simple, faster than Kha's current implementation, and I certainly messed it up. Seems "good enough for games".
**/

// Why xoshiro128** and not a more secure implementation? Because I don't know how to handle 64bit uints in a pleasant crossplatform way :^)
class Random {
    private var s:Array<Int>;

    public function new(seed: Int): Void {
        s = [seed, 0x1337beef, 0x00bad1ad, 0x0120bbed];

        //Immediately skip some trash results
        for (i in 0...10) {
            this.Get();
        }
    }
    
    public function Get(): Int {
        final result = (rotl(s[1] * 5, 7) * 9) & 0x7ffffffe;
        
        final t = (s[1] << 9);

        s[2] ^= s[0];
        s[3] ^= s[1];
        s[1] ^= s[2];
        s[0] ^= s[3];

        s[2] ^= t;

        s[3] = rotl(s[3], 11);

        return result;
    }

    private inline function rotl(x:Int, k:Int):Int {
        x &= 0x7ffffffe;
        return ((x << k) | (x >> (32 - k)));
    }
    
    public function GetFloat(): Float {
        return Get() / 0x7ffffffe;
    }
    
    public function GetUpTo(max: Int): Int {
        return Get() % (max + 1);
    }
    
    public function GetIn(min: Int, max: Int): Int {
        return Get() % (max + 1 - min) + min;
    }
    
    public function GetFloatIn(min: Float, max: Float): Float {
        return min + GetFloat() * (max - min);
    }
    
    public static var Default: Random;
    
    public static function init(seed: Int): Void {
        Default = new Random(seed);
    }
    
    public static function get(): Int {
        return Default.Get();
    }
    
    public static function getFloat(): Float {
        return Default.GetFloat();
    }
    
    public static function getUpTo(max: Int): Int {
        return Default.GetUpTo(max);
    }
    
    public static function getIn(min: Int, max: Int): Int {
        return Default.GetIn(min, max);
    }
    
    public static function getFloatIn(min: Float, max: Float): Float {
        return min + Default.GetFloat() * (max - min);
    }
}