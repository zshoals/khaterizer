package khaterizer.ecs.blueprints;

import khaterizer.types.CppPerformanceHack;
import khaterizer.ecs.components.Rect;
import kha.math.Random;
import ecx.Service;
import khaterizer.ecs.components.Spatial;
import khaterizer.ecs.components.graphics.Renderable;

class Spammer extends Service {

    var _spatials:Wire<Spatial>;
    var _rends:Wire<Renderable>;
    var rects:Wire<Rect>;

    public function new() {
        
    }

    public function addRect(x:Float, y:Float, width:Float, height:Float):Entity {
        var ent = world.create();
        var rect = rects.create(ent);
        rect.setup(width, height);

        var s = _spatials.create(ent);
        s.setup(x, y);

        _rends.create(ent);

        return ent;
    }
}