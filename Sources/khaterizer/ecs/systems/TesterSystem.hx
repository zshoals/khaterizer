package khaterizer.ecs.systems;

import khaterizer.graphics.Renderer;
import ecx.System;
import khaterizer.ecs.blueprints.Spammer;
import khaterizer.ecs.components.Rect;
import khaterizer.ecs.components.Spatial;
import khaterizer.ecs.components.collision.CollisionRect;
import khaterizer.ecs.components.graphics.Renderable;
import khaterizer.ecs.services.WindowConfiguration;
import khaterizer.math.Random;
import khaterizer.math.Vector2;


class TesterSystem extends System {

    var _firstRun:Bool = true;
    var _rand:Random;
    var _loc:Wire<Spatial>;
    var _rend:Wire<Renderable>;
    var _spam:Wire<Spammer>;
    var _ents:Family<Spatial>;
    var window:Wire<Renderer>;
    var count = 0;

    public function new() {
        _rand = new Random(1337);
    }

    override function update() {
        if (_firstRun) {
            for (i in 0...100000) _spam.addRect(_rand.GetFloatIn(0, window.getCanvasWidth()), _rand.GetFloatIn(0, window.getCanvasHeight()), 5, 5);
            //Do not remove this fucking line
            _firstRun = false;
        }

        count++;
        if (count >= 120) {
            trace(_ents.length);
            count = 0;
        }

        var accum = 0.0;
        for (ent in _ents) {
            var loc = _loc.get(ent);
            loc.position.x = _rand.GetFloatIn(0, window.getCanvasWidth());
            loc.position.y = _rand.GetFloatIn(0, window.getCanvasHeight());
        }
    }
}