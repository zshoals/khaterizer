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
    private var multiplier:Float;

    public function new() {
        
    }

    override function initialize():Void {
        timeScale = 1.0;
        deltaTime = 1 / 60;
        multiplier = 1;

        adjustedTime = deltaTime * timeScale * multiplier;
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
        Deltatime, Timescale, and an overall ResultMultiplier combined. Premultiplied for convenience.
    **/
    public inline function adjusted():Float {
        return adjustedTime;
    }

    public inline function adjustedVec():Vector2 {
        return {x: adjustedTime, y: adjustedTime};
    }

    public inline function resultMultiplier():Float {
        return this.multiplier;
    }

    /**
        Sets the fixed update time interval.
    **/
    @:allow(Khaterizer)
    public function setTiming(period:Float):Void {
        deltaTime = period;
        adjustedTime = deltaTime * timeScale * multiplier;
    }

    /**
        An arbitrary value to scale the entire result by.
    **/
    public function setResultMultiplier(multiplier:Float) {
        this.multiplier = multiplier;
        this.adjustedTime = deltaTime * timeScale * multiplier;
    }

    /**
        Sets the global timescale. Most operations that occur over time should be multiplied by

        timescale for various effects, like slow motion and fast motion, or to freeze everything connected to the Timescale.
    **/
    public function setTimeScale(scale:Float):Void {
        timeScale = scale;
        adjustedTime = deltaTime * timeScale * multiplier;
    }
}