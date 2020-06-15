package khaterizer.util;

import ecx.Entity;
import ecx.Service;
import ecx.Wire;
import khaterizer.components.Spatial;
import khaterizer.components.graphics.Renderable;

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