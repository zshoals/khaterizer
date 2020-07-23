package khaterizer.graphics;

import ecx.Service;
import kha.graphics4.PipelineState;
import kha.Shaders;
import kha.graphics4.hxsl.Shader;
import ecx.types.EntityVector;
import khaterizer.ecs.systems.graphics.RenderSystem;
import khaterizer.ecs.components.graphics.Renderable;
import khaterizer.ecs.components.Spatial;
import ecx.World;
import kha.Color;
import kha.Image;
import kha.graphics2.Graphics;
import khaterizer.types.RenderPackage;

class Renderer extends Service {
    var backbuffer:Image;
    
    var spatials:Wire<Spatial>;
    var renderSystem:Wire<RenderSystem>;
    var renderables:EntityVector;

    public function new() {}

    public function init(backbufferWidth:Int, backbufferHeight:Int) {
        backbuffer = Image.createRenderTarget(backbufferWidth, backbufferHeight);
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