package khaterizer.ecs.services.graphics;

import khaterizer.ecs.components.StaticTransform;
import khaterizer.util.TimerUtil;
import khaterizer.math.FastMatrix3;
using khaterizer.math.FastMatrix3Ext;
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

class Renderer extends Service {
    public var backbuffer:RenderTarget;

    public var paused:Bool;

    var spatials:Wire<Spatial>;
    var renderdata:Wire<Renderable>;
    var staticTransforms:Wire<StaticTransform>;
    var renderSystem:Wire<RenderProxySystem>;
    var renderables:EntityVector;
    var staticRenderables:EntityVector;
    var rects:Wire<Rect>;
    var camera:Wire<Camera>;
    var engine:Wire<EngineConfiguration>;

    var window:Wire<WindowConfiguration>;
    
    var fillRectHack:Image;

    private var initialized:Bool = false;

    public function new() {
        
    }

    public function init(backbufferWidth:Int, backbufferHeight:Int, resolutionWidth:Int, resolutionHeight:Int, resolutionSizingStrategy:ResolutionSizing, scaleMode:ImageScaling):Void {
        if (!initialized) {
            paused = true;
            backbuffer = new RenderTarget(backbufferWidth, backbufferHeight, resolutionWidth, resolutionHeight, resolutionSizingStrategy, scaleMode);

            renderables = renderSystem.renderables;
            staticRenderables = renderSystem.staticRenderables;

            backbuffer.g2.font = engine.debugFont;
            backbuffer.g2.fontSize = 12;

            //TODO: REMOVE TEST STUFF
            Assets.loadImage("big_kha_Logo", (img) -> {
                fillRectHack = img;
                paused = false;
            });

            initialized = true;
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
        g2.color = Color.White;

        {
            //TODO: REMOVE TEST STUFF
            for (r in renderables) {
                final spat = spatials.get(r);
                final rect = rects.get(r);
                final rdata = renderdata.get(r);

                final pos = spat.position;
                final mid = rect.midpoint;
                final rot = spat.rotation;
                final scale = spat.scale;
                
                //We shouldn't even have to make this check
                //Instead, guarantee it somehow whenever a renderable is constructed
                if (rdata.transformation == null) {
                    rdata.buildTransform(pos, mid, rot, scale);
                }

                //TODO: REMOVE TEST STUFF, we need an actual way to set the anchor point for instance
                //We technically only have to update these each logical update, not every render

                //Checking if the element is actually on screen before drawing is a massive performance increase...
                //...obviously.
                //Let's find a way to get an "inDrawRegion() (+ guarantee the image is drawn if any portion is in the draw region + extra buffer just in case) function ready :)!
                if (pos.x < backbuffer.width && pos.x > 0 && pos.y < backbuffer.height && pos.y > 0) {
                    if (staticTransforms.has(r)) {
                        g2.pushTransformation(rdata.transformation);
                    }
                    else {
                        g2.pushTransformation(FastMatrix3.transformation(pos, mid, rot, scale));
                    }
                    g2.drawScaledImage(fillRectHack, 0, 0, rect.width, rect.height);
                    g2.popTransformation();
                }
            }
        }

        camera.end();
        g2.end();
    }

    public function changeBackbuffer(width:Int, height:Int, resolutionWidth:Int, resolutionHeight:Int, resolutionSizeStrategy:ResolutionSizing, scaleMode:ImageScaling):Void {
        backbuffer.unload();
        backbuffer = new RenderTarget(width, height, resolutionWidth, resolutionHeight, resolutionSizeStrategy, scaleMode);
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