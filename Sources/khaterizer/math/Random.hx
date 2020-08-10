package khaterizer.math;

import haxe.Int64;

/**
    Jury-rigged Implementation of xoshiro128** PRNG with kha.math.Random's interface.

    Simple, faster than Kha's current implementation, and I certainly messed it up. Seems "good enough for games".
**/

// Why xoshiro128** and not a more secure implementation? Because I don't know how to handle 64bit uints in a pleasant crossplatform way :^)
class Random {
    private var s0:Int;
    private var s1:Int;
    private var s2:Int;
    private var s3:Int;

    public function new(seed: Int): Void {
        s0 = seed;
        s1 = 0;
        s2 = 0;
        s3 = 0;

        //Immediately skip some trash results
        for (i in 0...10) {
            this.Get();
        }
    }

    public function Get(): Int {
        final result = rotl(s1 * 5, 7) * 9;

        //Unsign right shift anything that's supposed to be a uint32
        final t = (s1 << 9) >>> 1;

        s2 ^= s0;
        s3 ^= s1;
        s1 ^= s2;
        s0 ^= s3;

        s2 ^= t;

        s3 = rotl(s3, 11);

        return result >>> 1;
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

    private inline function rotl(x:Int, k:Int):Int {
        x >>>= 1;
        return ((x << k) | (x >> (32 - k)));
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