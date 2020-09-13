package khaterizer.util;

import haxe.Timer;
import kha.Scheduler;

/**
    Timer that can be updated to `measure` the time differential.

    Contains separate retrieval functions for atomized and real time from Kha's Scheduler.
**/
class TimerUtil {
    var _updateTime:Float;
    var _updateRealTime:Float;
    var _lastUpdateTime:Float;
    var _lastUpdateRealTime:Float;

    public function new() {
        _updateTime = Scheduler.time();
        _updateRealTime = Scheduler.realTime();
        _lastUpdateTime = _updateTime;
        _lastUpdateRealTime = _updateRealTime;
    }

    /**
        Updates the current atomized and real times to the present.

        Stores the previous times for `measure` purposes.
    **/
    public function update():Void {
        _lastUpdateTime = _updateTime;
        _lastUpdateRealTime = _updateRealTime;
        _updateTime = Scheduler.time();
        _updateRealTime = Scheduler.realTime();
    }

    /**
        Atomized time between update calls.
    **/
    public inline function measure():Float {
        return _updateTime - _lastUpdateTime;
    }

    /**
        Real time between update calls.
    **/
    public inline function measureReal():Float {
        return _updateRealTime - _lastUpdateRealTime;
    }

    /**
        Atomized time differential between the previous update time and right now.
    **/
    public inline function dt():Float {
        return Scheduler.time() - _updateTime;
    }

    /**
        Real time differential between the previous update time and right now.
    **/
    public inline function dtReal():Float {
        return Scheduler.realTime() - _updateRealTime;
    }

    /**
        Atomized time as of this instant.
    **/
    public inline function current():Float {
        return Scheduler.time();
    }

    /**
        Real time as of this instant.
    **/
    public inline function currentReal():Float {
        return Scheduler.realTime();
    }

    public static inline function run(func:Void->Void):Float {
        final startTime = Scheduler.realTime();
        func();
        return Scheduler.realTime() - startTime;
    }
}