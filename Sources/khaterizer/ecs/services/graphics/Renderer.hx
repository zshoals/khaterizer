package khaterizer.ecs.services.graphics;

import khaterizer.types.CppPerformanceHack;
import khaterizer.math.Random;
import ecx.Service;
import ecx.types.EntityVector;
import kha.Assets;
import kha.Color;
import kha.Image;
import kha.Shaders;
import kha.System;
import kha.Window;
import kha.graphics2.Graphics;
import kha.graphics4.PipelineState;
import khaterizer.ecs.components.Rect;
import khaterizer.ecs.components.Spatial;
import khaterizer.ecs.components.graphics.Renderable;
import khaterizer.ecs.services.graphics.WindowConfiguration;
import khaterizer.ecs.systems.graphics.RenderProxySystem;
import khaterizer.graphics.RenderTarget;
import khaterizer.types.ResizerMethod;

class Renderer extends Service {
    public var backbuffer:RenderTarget;

    public var paused:Bool;
    
    var spatials:Wire<Spatial>;
    var renderSystem:Wire<RenderProxySystem>;
    var renderables:EntityVector;
    var rects:Wire<Rect>;
    var camera:Wire<Camera>;
    var engine:Wire<EngineConfiguration>;

    var window:Wire<WindowConfiguration>;
    var resizerFunction:ResizeMethod;

    var fillRectHack:Image;

    private var initialized:Bool = false;

    public function new() {
        new CppPerformanceHack();
    }

    public function init(backbufferWidth:Int, backbufferHeight:Int, resolutionSizingStrategy:ResolutionSizing, scaleMode:ImageScaling):Void {
        if (!initialized) {
            backbuffer = new RenderTarget(backbufferWidth, backbufferHeight, resolutionSizingStrategy, scaleMode);

            renderables = renderSystem.renderables;
            fillRectHack = Assets.images.pixel;
            backbuffer.g2.font = engine.debugFont;
            backbuffer.g2.fontSize = 12;

            initialized = true;
            paused = false;

            camera.setup(0, 0, 0, 1);
        }
        else {
            throw "Renderer should only be initialized once.";
        }
    }

    public function render():Void {
        if (paused) return;

        final g2 = backbuffer.g2;

        g2.begin();
        camera.begin(backbuffer);

        for (r in renderables) {
            var pos = spatials.get(r).position;
            var sizex = rects.get(r).width;
            var sizey = rects.get(r).height;
            var x = pos.x;
            var y = pos.y;
            g2.color = Color.Green;
            g2.drawScaledImage(fillRectHack, x, y, sizex, sizey);
        }

        camera.end();
        g2.end();
    }

    public function changeBackbuffer(width:Int, height:Int, resolutionSizeStrategy:ResolutionSizing, scaleMode:ImageScaling):Void {
        backbuffer.unload();
        backbuffer = new RenderTarget(width, height, resolutionSizeStrategy, scaleMode);
    }

    public function setResolution(width:Int, height:Int):Void {
        backbuffer.setResolution(width, height);
    }

    public function setResolutionResizingStrategy(strategy:ResolutionSizing):Void {
        backbuffer.resolutionResizeStrategy = strategy;
    }

    public function setImageScaleMode(mode:ImageScaling):Void {
        backbuffer.scaleMode = mode;
    }

    public inline function getCanvasScaleWidth():Float {
        return backbuffer.scaleX;
    }

    public inline function getCanvasScaleHeight():Float {
        return backbuffer.scaleY;
    }

    public inline function getCanvasWidth():Int {
        return backbuffer.width;
    }

    public inline function getCanvasHeight():Int {
        return backbuffer.height;
    }

    public inline function getCanvasResolutionWidth():Int {
        return backbuffer.resolutionWidth;
    }
    
    public inline function getCanvasResolutionHeight():Int {
        return backbuffer.resolutionHeight;
    }

    public function pauseRendering():Void {
        paused = true;
    }
    
    public function unpauseRendering():Void {
        paused = false;
    }
}