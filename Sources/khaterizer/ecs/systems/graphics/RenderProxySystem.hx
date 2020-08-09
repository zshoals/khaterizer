package khaterizer.ecs.systems.graphics;

import ecx.System;
import khaterizer.ecs.components.graphics.Renderable;
import khaterizer.ecs.components.Spatial;

/**
 * This is a proxy class.
 * 
 * Its only purpose is to route rendering data into the decoupled Renderer in khaterizer.graphics, since Renderer is not a service.
 * 
 * This class should still be added to the world config.
 * 
 * If you are trying to create a lockstep renderer, then you can use this system directly to handle drawing.
 * **/
class RenderProxySystem extends System {

    public var renderables:Family<Renderable, Spatial>;

    public function new(){}

    override function update(){
        return;
    }
}