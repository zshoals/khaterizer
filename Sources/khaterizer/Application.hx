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

class Application {
    var world = Khaterizer.world;

    var renderer:Renderer;

    var drawTimer:TimerUtil;
    var fpsTimer:TimerUtil;
    var recentFPS:Array<Float>;
    var renderCycles:Int;
    var fpsResult:Int;

    public function new() {
        drawTimer = new TimerUtil();
        fpsTimer = new TimerUtil();
        
        recentFPS = [];
        renderCycles = 0;
        fpsResult = 0;

        renderer = new Renderer(Display.primary.width, Display.primary.height);
    }

    public function update():Void {
        for(system in world.systems()) {
            @:privateAccess system.update();
            world.invalidate();
        }
    }

    public function render(frames: Array<Framebuffer>):Void {
        drawTimer.update();

        final backbuffer = renderer.render();
        final g2 = frames[0].g2;

        g2.begin();
        g2.color = Color.White;
        g2.drawImage(backbuffer, 0, 0);
        g2.end();

        drawTimer.update();

        if (fpsTimer.dtReal() > 1) {
            fpsTimer.update();
            fpsResult = renderCycles;
            renderCycles = 0;
        }
        else {
            renderCycles++;
        }

        renderDebugMenu(g2);
    }

    /**
        Draws a debug menu :^)
        
        @param g2 The Kha `Graphics` instance
    **/
    inline function renderDebugMenu(g2:Graphics):Void {
        g2.begin(false);

        g2.color = Color.Black;
        g2.fillRect(0, 0, 400, 100);

        g2.color = Color.White;
        g2.font = Khaterizer.debugFont;
        g2.fontSize = 24;
        g2.drawString("Frames Per Second: " + fpsResult, 20, 20);
        g2.drawString("Backbuffer Render Time: " + calcFrametimeAverage(), 20, 40);
        g2.drawString("Fucking Squares on Screen: " + world.used, 20, 60);

        g2.end();
    }

    inline function calcFrametimeAverage():Float {
        var lameFPS = drawTimer.measureReal();
        recentFPS.push(lameFPS);
        if (recentFPS.length >= 10) {
            recentFPS.shift();
        }
        var avgFPS = 0.0;
        for (i in recentFPS) avgFPS += i;
        avgFPS = MathUtil.truncate(avgFPS / recentFPS.length, 6);
        return avgFPS;
    }
}