package khaterizer.graphics;

import khaterizer.ecs.components.Rect;
import kha.Assets;
import khaterizer.ecs.services.WindowConfiguration;
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
import khaterizer.ecs.systems.graphics.RenderSystem;
import khaterizer.graphics.RenderTarget;

class Renderer extends Service {
    var backbuffer:RenderTarget;
    
    var spatials:Wire<Spatial>;
    var renderSystem:Wire<RenderSystem>;
    var renderables:EntityVector;
    var rects:Wire<Rect>;

    var window:Wire<WindowConfiguration>;
    var resizerFunction:ResizeMethod;

    var img:Image;

    public function new() {}

    public function init(backbufferWidth:Int, backbufferHeight:Int):Void {
        backbuffer = new RenderTarget(backbufferWidth, backbufferHeight);

        renderables = renderSystem.renderables;

        resizerFunction = (x:Int, y:Int) -> {
            backbuffer.resize(window.windowWidth, window.windowHeight);
        }
        setBackbufferResizeMethod(resizerFunction);

        //Force the sizing strategy to be applied
        //I think this structure kind of sucks
        window.applyWindowSettings();

        //Assets.loadImage("pixel", (image:Image) -> this.img = image);
        img = Assets.images.pixel;
    }

    public function render():Image {
        final g2 = backbuffer.g2;

        g2.begin();
        
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

        g2.end();

        return backbuffer.getImage();
    }

    public function changeBackbufferSize(backbufferWidth:Int, backbufferHeight:Int):Void {
        backbuffer.resize(backbufferWidth, backbufferHeight);
    }

    /**
        The automated resizing method triggered whenever the window is resized. Only one can be active, and the previous strategy is replaced on use.

        Non-functional on HTML5, use changeBackbufferSize instead with your own implementation.

        @param strat The resizing function to use on resize notifications.
    **/
    public function setBackbufferResizeMethod(strat:ResizeMethod):Void {
        #if !kha_js
        if (resizerFunction != null) {
            unsetBackbufferResizeMethod();
        }
        window.notifyOnResize(strat);

        resizerFunction = strat;
        #end
    }

    public function unsetBackbufferResizeMethod():Void {
        #if !kha_js
        window.removeResizeNotifier(resizerFunction);
        resizerFunction = null;
        #end
    }

    public inline function getCanvasWidth():Int {
        return backbuffer.width;
    }

    public inline function getCanvasHeight():Int {
        return backbuffer.height;
    }
}