package khaterizer.systems.graphics;

import ecx.System;
import khaterizer.components.graphics.Renderable;
import khaterizer.components.Spatial;

/**
 * This is a proxy class.
 * 
 * Its only purpose is to route _renderables into the decoupled Renderer in khaterizer.graphics, since Renderer is not a service.
 * 
 * This class should still be added to the world config.
 * 
 * If you are trying to create a lockstep renderer, then you can use this system directly to handle drawing.
 * **/
class RenderSystem extends System {

    public var renderables:Family<Renderable, Spatial>;

    public function new(){}

    override function update(){}
}