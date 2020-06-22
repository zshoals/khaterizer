package khaterizer;

import kha.Assets;
import kha.Display;
import kha.Window;
import ecx.Engine;
import ecx.World;
import ecx.WorldConfig;
import kha.graphics2.Graphics;
import kha.Framebuffer;
import kha.Color;
import kha.Scheduler;
import khaterizer.graphics.Renderer;
import khaterizer.util.TimerUtil;
import khaterizer.input.Keypress;
import kha.input.KeyCode;
import kha.input.Keyboard;

class GameWorld {

    var _world:World;
    var _drawTimer:TimerUtil;
    var _fpsTimer:TimerUtil;
    var _recentFPS:Array<Float>;
    var _renderCycles:Int;
    var _renderCyclesResult:Int;
    var _keybind:Keypress;
    var testbool:Bool = false;

    public function new(world:World) {
        _world = world;
        _drawTimer = new TimerUtil();
        _fpsTimer = new TimerUtil();
        
        _recentFPS = [];
        _renderCycles = 0;
        _renderCyclesResult = 0;

        _keybind = new Keypress(Keyboard.get(0), KeyCode.Space);
        var _keymod = new Keypress(Keyboard.get(0), KeyCode.Shift);

        _keybind.notify(
            (key:Keypress) -> {
                if (key.isDown() && _keymod.isDown() && key.holdDownTime() >= 2) {
                    testbool = true;
                } else {
                    testbool = false;
                }
            },
            null
        );

        Renderer.init(Display.primary.width, Display.primary.height, _world);
    }

    public function update():Void {
        for(system in _world.systems()) {
            @:privateAccess system.update();
            _world.invalidate();
        }

        _keybind.poll();
    }

    public function render(frames: Array<Framebuffer>):Void {
        _drawTimer.update();

        trace(testbool + " " + _keybind.isDown() + " UP: " + _keybind.holdUpTime() + " DOWN: " + _keybind.holdDownTime());

        final drawable = Renderer.render();
        final g2 = frames[0].g2;

        g2.begin();
        g2.color = Color.White;
        g2.drawImage(drawable, 0, 0);
        g2.end();

        _drawTimer.update();

        if (_fpsTimer.dtReal() > 1) {
            _fpsTimer.update();
            _renderCyclesResult = _renderCycles;
            _renderCycles = 0;
        }
        else {
            _renderCycles++;
        }

        renderDebugMenu(g2);

        if (frames[1] != null) {
            var g2_2 = frames[1].g2;
            g2_2.begin();
            g2_2.drawRect(10, 10, 50, 50);
            g2_2.end();
        }

    }

    /**
        Draws a debug menu :^)
        
        @param g2 The Kha `Graphics` instance
    **/
    inline function renderDebugMenu(g2:Graphics):Void {
        g2.begin(false);

        g2.color = Color.Black;
        g2.fillRect(0, 0, 300, 100);

        g2.color = Color.White;
        g2.font = Assets.fonts.Montserrat_Regular;
        g2.fontSize = 24;
        g2.drawString("Frames Per Second: " + _renderCyclesResult, 20, 20);
        g2.drawString("Render Time: " + calcFrametimeAverage(), 20, 40);

        g2.end();
    }

    inline function calcFrametimeAverage():Float {
        var lameFPS = _drawTimer.measureReal();
        _recentFPS.push(lameFPS);
        if (_recentFPS.length >= 10) {
            _recentFPS.shift();
        }
        var avgFPS = 0.0;
        for (i in _recentFPS) avgFPS += i;
        avgFPS = MathUtil.truncate(avgFPS / _recentFPS.length, 6);
        return avgFPS;
    }
}