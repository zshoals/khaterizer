package khaterizer.graphics;

import ecx.types.EntityVector;
import khaterizer.ecs.systems.graphics.RenderSystem;
import khaterizer.ecs.components.graphics.Renderable;
import khaterizer.ecs.components.Spatial;
import ecx.World;
import kha.Color;
import kha.Image;
import kha.graphics2.Graphics;
import khaterizer.types.RenderPackage;

class Renderer {
    var backbuffer:Image;

    var world:World;
    var spatials:Spatial;
    var renderables:EntityVector;

    public function new(backbufferWidth:Int, backbufferHeight:Int) {
        //---Let's not make this a habit, world.resolve should only be used in really weird situations like this
        //---It needs to be used here since trying to do rendering from within ECX's System loop effectively locks the 
        //---visible framerate to the system update rate, which is not desirable. 
        //---Example: We do not want to be hard locked to 60 logical frames without being able to interpolate info up to 120 visible frames
        world = Khaterizer.world;
        spatials = world.resolve(Spatial);
        renderables = world.resolve(RenderSystem).renderables;
        //-------------------------------------------------------------------

        backbuffer = Image.createRenderTarget(backbufferWidth, backbufferHeight);
    }

    //This could instead take a list of draw functions, supplied by various ecx render systems
    //and then simply call those functions. Should work, right?
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