package khaterizer.systems;

import khaterizer.graphics.Renderer;
import khaterizer.types.RenderPackage;
import khaterizer.components.graphics.Renderable;
import khaterizer.components.Spatial;
import ecx.System;

//This is a proxy class 
//Its only purpose is to route _renderables into the decoupled Renderer in khaterizer.core, since it is not a service
//This class should still be added to the world config
class RenderSystem extends System {

    var _renderList:Wire<Renderable>;
    var _spatialList:Wire<Spatial>;
    public var _renderables:Family<Renderable, Spatial>;

    public function new(){}

    override function update(){
        // var renderData = new RenderPackage();

        // for (r in _renderables) {
        //     renderData.addPosition(_spatialList.get(r).position);
        // }

        // Renderer.updateRenderables(renderData);
    }
}