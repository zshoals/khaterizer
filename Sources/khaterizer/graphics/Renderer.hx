package khaterizer.graphics;

import ecx.types.EntityVector;
import khaterizer.systems.RenderSystem;
import khaterizer.components.graphics.Renderable;
import khaterizer.components.Spatial;
import ecx.World;
import kha.Color;
import kha.Image;
import kha.graphics2.Graphics;
import khaterizer.types.RenderPackage;

class Renderer {
    static var _renderables:RenderPackage;
    static var _image:Image;
    static var _world:World;
    static var _spatials:Spatial;
    static var _renderables2:EntityVector;

    public static function init(renderTargetWidth:Int, renderTargetHeight:Int, world:World):Void {
        _world = world;
        _image = Image.createRenderTarget(renderTargetWidth, renderTargetHeight);
        _renderables = new RenderPackage();

        _spatials = _world.resolve(Spatial);
        _renderables2 = _world.resolve(RenderSystem)._renderables;
    }


    //This could instead take a list of draw functions, supplied by various ecx render systems
    //and then simply call those functions. Should work, right?
    public static function render():Image {
        if (_image == null) throw "Renderer must run init() before rendering";

        final g2 = _image.g2;

        g2.begin();
        
        for (r in _renderables2) {
            var pos = _spatials.get(r).position;
            var x = pos.x;
            var y = pos.y;
            g2.color = Color.Green;
            g2.fillRect(x, y, 1, 1);
        }

        g2.end();

        return _image;
    }

    public static function updateRenderables(renderables:RenderPackage) {
        _renderables = renderables;
    }
}