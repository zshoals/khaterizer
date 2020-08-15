package khaterizer.ecs.services;

import khaterizer.math.Vector2;
import khaterizer.types.CppPerformanceHack;
import ecx.Service;

/**
    Simple service that provides the fixed update rate timing provided at Khaterizer initialization, and the current Timescale.

    ECX does not have delta time as a parameter for System updates, so it must be done this way.

    For other time differential purposes, use TimerUtil.
**/
class Timing extends Service {
    private var deltaTime(default, null):Float;
    private var timeScale:Float;
    private var adjustedTime:Float;
    private var dtReal:Float;

    public function new() {
        new CppPerformanceHack();
    }

    override function initialize():Void {
        timeScale = 1.0;
        deltaTime = 1 / 60;
        dtReal = deltaTime;
    }

    public inline function dt():Float {
        return deltaTime;
    }

    public inline function dtVec():Vector2 {
        return {x: deltaTime, y:deltaTime};
    }

    public inline function timescale():Float {
        return timeScale;
    }

    public inline function timescaleVec():Vector2 {
        return {x: timeScale, y: timeScale};
    }

    /**
        Deltatime and Timescale premultiplied for convenience.
    **/
    public inline function adjusted():Float {
        return deltaTime * timeScale;
    }

    public inline function adjustedVec():Vector2 {
        return {x: adjustedTime, y: adjustedTime};
    }

    public inline function dtreal():Float {
        return dtReal;
    }

    public function setIt(x:Float):Void {
        dtReal = x;
    }

    /**
        Sets the fixed update time interval. 
    **/
    @:allow(Khaterizer)
    public function setTiming(period:Float):Void {
        deltaTime = period;
        adjustedTime = deltaTime * timeScale;
    }

    /**
        Sets the global timescale. Most operations that occur over time should be multiplied by

        timescale for various effects, like slow motion and fast motion, or to freeze everything connected to the Timescale.
    **/
    public function setTimeScale(scale:Float):Void {
        timeScale = scale;
        adjustedTime = deltaTime * timeScale;
    }
}