package khaterizer.graphics;

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

class Renderer extends Service {
    var backbuffer:Image;
    
    var spatials:Wire<Spatial>;
    var renderSystem:Wire<RenderSystem>;
    var renderables:EntityVector;

    public function new() {}

    public function init(backbufferWidth:Int, backbufferHeight:Int) {
        backbuffer = Image.createRenderTarget(backbufferWidth, backbufferHeight);

        //This needs to be handled better, since the backbuffer is not necessarily always the size of the window
        //we may want it smaller or something sometimes
        kha.Window.get(0).notifyOnResize((x:Int, y:Int) -> changeBackbufferSize(x, y));
        
        renderables = renderSystem.renderables;
    }

    public function render():Image {
        final g2 = backbuffer.g2;

        g2.begin();
        
        for (r in renderables) {
            var pos = spatials.get(r).position;
            var x = pos.x;
            var y = pos.y;
            g2.color = Color.Green;
            g2.fillRect(x, y, 1, 1);
        }

        g2.end();

        return backbuffer;
    }

    public function changeBackbufferSize(backbufferWidth:Int, backbufferHeight:Int):Void {
        backbuffer.unload();
        backbuffer = Image.createRenderTarget(backbufferWidth, backbufferHeight);
    }
}