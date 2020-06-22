package khaterizer.input;

import kha.input.KeyCode;
import kha.input.Keyboard;
import khaterizer.util.TimerUtil;

enum abstract KeyState(Int) to Int {
    var UP;
    var DOWN;
}

//This sucks lol
class Keypress {
    var key:KeyCode;

    final downListeners:Array<Keypress->Void>;
    final upListeners:Array<Keypress->Void>;

    var keyState:KeyState;
    
    final timer:TimerUtil;

    public function new(keyboard:Keyboard, key:KeyCode) {
        this.key = key;

        downListeners = [];
        upListeners = [];

        this.keyState = UP;
        
        this.timer = new TimerUtil();
        this.timer.update();

        keyboard.notify(this.passthroughKeyDown, this.passthroughKeyUp);
    }

    public function poll() {
        if (this.isDown()) {
            for (listener in downListeners) listener(this);
        } else {
            for (listener in upListeners) listener(this);
        }
    }

    public inline function isDown():Bool {
        return this.keyState == DOWN;
    }

    public inline function isUp():Bool {
        return this.keyState == UP;
    }

    public inline function holdDownTime():Float {
        return this.keyState == DOWN ? this.timer.dtReal() : 0;
    }

    public inline function holdUpTime():Float {
        return this.keyState == UP ? this.timer.dtReal() : 0;
    }
    
    public inline function useKey():KeyCode {
        return this.key;
    }

    /**
        Adds Keydown and Keyup events, respectively.
    **/
    public function notify(downListener:Keypress->Void, upListener:Keypress->Void):Void {
        if (downListener != null) {
            this.downListeners.push(downListener);
        }
        if (upListener != null) {
            this.upListeners.push(upListener);
        }
    }

    public function remove(downListener:Keypress->Void, upListener:Keypress->Void):Void {
        if (downListener != null) {
            this.downListeners.remove(downListener);
        }
        if (upListener != null) {
            this.upListeners.remove(upListener);
        }
    }
/**
    Removes this Keypress instance from Kha's Keyboard notifier

    Make sure to call this before removing your reference to the Keypress, otherwise strange things may happen
**/
    public function unbindKey() {
        final keyboard = Keyboard.get(0);
        keyboard.remove(this.passthroughKeyDown, this.passthroughKeyUp, null);
    }

    private function sendKeyDown():Void {
        if (this.keyState == UP) {
            this.timer.update();
        }

        this.keyState = DOWN;
    }
    
    private function sendKeyUp():Void {
        if (this.keyState == DOWN) {
            this.timer.update();
        }

        this.keyState = UP;
    }

    private function passthroughKeyDown(key:KeyCode):Void {
        if (key == this.key) {
            this.sendKeyDown();
        }
    }

    private function passthroughKeyUp(key:KeyCode):Void {
        if (key == this.key) {
            this.sendKeyUp();
        }
    }
}