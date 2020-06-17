package khaterizer.util;

import haxe.Timer;
import kha.Scheduler;

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

    public function update() {
        _lastUpdateTime = _updateTime;
        _lastUpdateRealTime = _updateRealTime;
        _updateTime = Scheduler.time();
        _updateRealTime = Scheduler.realTime();
    }

    //The adjusted time between update calls on this timer
    public inline function measure() {
        return _updateTime - _lastUpdateTime;
    }

    //The real time between update calls on this timer
    public inline function measureReal() {
        return _updateRealTime - _lastUpdateRealTime;
    }

    //The adjusted time differential between this exact moment and the last invocation of update
    public inline function dt() {
        return Scheduler.time() - _updateTime;
    }
    //The real time differential between this exact moment and the last invocation of update
    public inline function dtReal() {
        return Scheduler.realTime() - _updateRealTime;
    }

    //Current adjusted time
    public inline function current() {
        return Scheduler.time();
    }

    //Current real time
    public inline function currentReal() {
        return Scheduler.realTime();
    }

    public static function delay(func:Void -> Void, time_seconds:Float) {
        var ms = Std.int(Math.round(time_seconds));
        Timer.delay(func, ms);
    }
}