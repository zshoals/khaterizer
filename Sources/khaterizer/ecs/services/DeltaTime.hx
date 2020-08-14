package khaterizer.ecs.services;

import khaterizer.types.CppPerformanceHack;
import ecx.Service;

/**
    Simple service that provides the fixed update rate timing provided at Khaterizer initialization.

    ECX does not have delta time as a parameter for System updates, so it must be done this way.

    For other time differential purposes, use TimerUtil.
**/
class DeltaTime extends Service {
    private var deltaTime(default, null):Float;

    public function new(){
        new CppPerformanceHack();
    };

    public inline function dt():Float {
        return deltaTime;
    }

    @:allow(Khaterizer)
    public function setTiming(period:Float):Void {
        deltaTime = period;
    }
}