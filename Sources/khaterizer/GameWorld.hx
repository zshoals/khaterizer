package khaterizer;

import kha.Display;
import kha.Window;
import ecx.Service;
import ecx.Wire;
import ecx.Engine;
import ecx.World;
import ecx.WorldConfig;
import kha.Framebuffer;
import kha.Color;
import khaterizer.core.Renderer;

@:nullSafety(Strict)
class GameWorld {

    var _world:World;
    
    public function new(world:World) {
        _world = world;
        Renderer.init(Display.primary.width, Display.primary.height, _world);
    }

	public function update():Void {
        for(system in _world.systems()) {
            @:privateAccess system.update();
            _world.invalidate();
        }
	}

	public function render(frames: Array<Framebuffer>):Void {
        //Extract the RenderSystem into this loop, it should update
        //As fast as render does
        //Render may have to not be a system, unfortunately...Service instead
        final drawable = Renderer.render();
        final g2 = frames[0].g2;

        g2.begin();
        g2.color = Color.White;
        g2.drawImage(drawable, 0, 0);
        g2.end();
	}
}