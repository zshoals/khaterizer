package khaterizer.systems;

import khaterizer.components.graphics.Renderable;
import kha.math.Vector2;
import kha.math.Random;
import ecx.System;

import khaterizer.components.collision.CollisionRect;
import khaterizer.components.Rect;
import khaterizer.components.Spatial;

import khaterizer.util.Spammer;


class TesterSystem extends System {

    var _firstRun:Bool = true;
    var _rand:Random;
    var _loc:Wire<Spatial>;
    var _rend:Wire<Renderable>;
    var _spam:Wire<Spammer>;
    var _ents:Family<Spatial>;
    var count = 0;

    public function new() {
        _rand = new Random(1337);
    }

    override function update() {
        if (_firstRun) {
            for (i in 0...50000) _spam.addRect(_rand.GetFloatIn(0, 1200), _rand.GetFloatIn(0, 500), 5, 5);
            //Do not remove this fucking line retard
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
            loc.position.x = _rand.GetFloatIn(0, 1200);
            loc.position.y = _rand.GetFloatIn(0, 500);
        }
    }
}