package khaterizer.ecs.systems.graphics;

import khaterizer.types.CppPerformanceHack;
import ecx.System;
import khaterizer.ecs.components.graphics.Renderable;
import khaterizer.ecs.components.Spatial;
import khaterizer.ecs.components.StaticTransform;

/**
 * This is a proxy class.
 * 
 * Its only purpose is to route rendering data into the decoupled Renderer in khaterizer.services.graphics, since Services cannot query entities and
 * 
 * in order for the Renderer to draw at arbitrary framerates it must be out of the system iteration loop.
 * 
 * This class is mandatory to include in at least one of your world configurations without adjustments to Khaterizer.
 * 
 * If you are trying to create a lockstep renderer, then you can use this system directly to handle drawing instead.
 * **/
class RenderProxySystem extends System {

    public var renderables:Family<Renderable, Spatial>;
    public var staticRenderables:Family<Renderable, Spatial, StaticTransform>;

    public function new(){
        
    }
}