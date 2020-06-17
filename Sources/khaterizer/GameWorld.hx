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
import khaterizer.core.Renderer;
import khaterizer.util.TimerUtil;

@:nullSafety(Strict)
class GameWorld {

    var _world:World;
    var _drawTimer:TimerUtil;
    var _fpsTimer:TimerUtil;
    var _recentFPS:Array<Float>;
    var _renderCycles:Int;
    var _renderCyclesResult:Int;

    
    public function new(world:World) {
        _world = world;
        _drawTimer = new TimerUtil();
        _fpsTimer = new TimerUtil();

        _recentFPS = [];
        _renderCycles = 0;
        _renderCyclesResult = 0;

        Renderer.init(Display.primary.width, Display.primary.height, _world);
    }

	public function update():Void {
        for(system in _world.systems()) {
            @:privateAccess system.update();
            _world.invalidate();
        }
	}

	public function render(frames: Array<Framebuffer>):Void {
        _drawTimer.update();

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

    }

    /**
        Draws a debug menu :^)
        
        @param g2 The Kha `Graphics` instance
    **/
    inline function renderDebugMenu(g2:Graphics) {
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