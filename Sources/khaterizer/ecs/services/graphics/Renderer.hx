package khaterizer.ecs.services.graphics;

import khaterizer.ecs.components.Rect;
import kha.Assets;
import khaterizer.ecs.services.graphics.WindowConfiguration;
import kha.Window;
import ecx.Service;
import ecx.World;
import ecx.types.EntityVector;
import kha.Color;
import kha.Image;
import kha.Shaders;
import kha.System;
import kha.graphics2.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.hxsl.Shader;
import khaterizer.ecs.components.Spatial;
import khaterizer.ecs.components.graphics.Renderable;
import khaterizer.ecs.systems.graphics.RenderProxySystem;
import khaterizer.graphics.RenderTarget;
import khaterizer.types.ResizerMethod;

class Renderer extends Service {
    public var backbuffer:RenderTarget;
    
    var spatials:Wire<Spatial>;
    var renderSystem:Wire<RenderProxySystem>;
    var renderables:EntityVector;
    var rects:Wire<Rect>;
    var camera:Wire<Camera>;

    var window:Wire<WindowConfiguration>;
    var resizerFunction:ResizeMethod;

    var img:Image;

    private var initialized:Bool = false;

    public function new() {}

    public function init(backbufferWidth:Int, backbufferHeight:Int, resolutionSizingStrategy:ResolutionSizing, scaleMode:ImageScaling):Void {
        if (!initialized) {
            backbuffer = new RenderTarget(backbufferWidth, backbufferHeight, resolutionSizingStrategy, scaleMode);

            renderables = renderSystem.renderables;

            img = Assets.images.pixel;

            initialized = true;

            camera.setup(0, 0, 0, 1);
        }
        else {
            throw "Renderer should only be initialized once.";
        }
    }

    public function render():Void {
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
            //g2.fillRect(x, y, 1, 1);
            g2.drawScaledImage(img, x, y, sizex, sizey);
        }

        camera.end();
        g2.end();
    }

    public function changeBackbuffer(width:Int, height:Int, resolutionSizeStrategy:ResolutionSizing, scaleMode:ImageScaling):Void {
        backbuffer.unload();
        backbuffer = new RenderTarget(width, height, resolutionSizeStrategy, scaleMode);
    }

    public inline function getCanvasWidth():Int {
        return backbuffer.width;
    }

    public inline function getCanvasHeight():Int {
        return backbuffer.height;
    }
}