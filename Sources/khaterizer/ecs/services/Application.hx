package khaterizer.ecs.services;

import kha.math.Random;
import kha.Scaler;
import ecx.Engine;
import ecx.Service;
import ecx.World;
import ecx.WorldConfig;
import kha.Assets;
import kha.Color;
import kha.Display;
import kha.Framebuffer;
import kha.Scheduler;
import kha.Window;
import kha.graphics2.Graphics;
import kha.input.KeyCode;
import kha.input.Keyboard;
import khaterizer.graphics.Renderer;
import khaterizer.input.Keypress;
import khaterizer.util.TimerUtil;
import kha.System;

class Application extends Service {
    var renderer:Wire<Renderer>;
    var windowConfig:Wire<WindowConfiguration>;
    var engineConfig:Wire<EngineConfiguration>;

    var fpsTimer:TimerUtil;
    var recentFPS:Array<Float>;
    var renderCycles:Int;
    public var framesPerSecond:Int;

    var drawTimer:TimerUtil;
    public var backbufferRenderTime:Float;
    
    public function new() {}

    override function initialize() {
        drawTimer = new TimerUtil();
        fpsTimer = new TimerUtil();
        
        recentFPS = [];
        renderCycles = 0;
        framesPerSecond = 0;
    }

    public function update():Void {
        for(system in world.systems()) {
            @:privateAccess system.update();
            world.invalidate();
        }
    }

    //Pass this data into the renderer instead of doing work here
    public function render(frames: Array<Framebuffer>):Void {
        drawTimer.update();

        final backbuffer = renderer.render();
        final g2 = frames[0].g2;

        g2.begin();
        g2.color = Color.White;

        #if kha_js
        //Screw it, don't worry about scaling anything on HTML5 and leave it as a static sized window
        g2.drawImage(backbuffer, 0, 0);
        #else
        //We're stuck to G2 if we use Scaler.scale
        Scaler.scale(backbuffer, frames[0], kha.ScreenRotation.RotationNone);
        #end
        g2.end();

        backbufferRenderTime = drawTimer.dtReal();

        if (fpsTimer.dtReal() > 1) {
            fpsTimer.update();
            framesPerSecond = renderCycles;
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
        g2.font = engineConfig.debugFont;
        g2.fontSize = 24;
        g2.drawString("Frames Per Second: " + framesPerSecond, 20, 20);
        g2.drawString("Backbuffer Render Time: " + calcFrametimeAverage(), 20, 40);
        g2.drawString("Fucking Squares on Screen: " + world.used, 20, 60);

        g2.end();
    }

    inline function calcFrametimeAverage():Float {
        recentFPS.push(backbufferRenderTime);
        if (recentFPS.length >= 10) {
            recentFPS.shift();
        }
        var avgFPS = 0.0;
        for (i in recentFPS) avgFPS += i;
        avgFPS = MathUtil.truncate(avgFPS / recentFPS.length, 6);
        return avgFPS;
    }
}