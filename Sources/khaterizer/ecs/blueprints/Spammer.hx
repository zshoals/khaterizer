package khaterizer.ecs.blueprints;

import kha.math.Random;
import ecx.Service;
import khaterizer.ecs.components.Spatial;
import khaterizer.ecs.components.graphics.Renderable;

class Spammer extends Service {

    var _spatials:Wire<Spatial>;
    var _rends:Wire<Renderable>;

    public function new() {}

    public function addRect(x:Float, y:Float, width:Float, height:Float):Entity {
        var rect = world.create();

        var s = _spatials.create(rect);
        s.setup(x, y);

        _rends.create(rect);

        return rect;
    }
}