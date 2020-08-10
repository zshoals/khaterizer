package khaterizer.ecs.systems;

import khaterizer.graphics.Shader;
import khaterizer.graphics.RenderTarget;
import khaterizer.ecs.services.graphics.Renderer;
import ecx.System;
import khaterizer.ecs.blueprints.Spammer;
import khaterizer.ecs.components.Rect;
import khaterizer.ecs.components.Spatial;
import khaterizer.ecs.components.collision.CollisionRect;
import khaterizer.ecs.components.graphics.Renderable;
import khaterizer.ecs.services.graphics.WindowConfiguration;
import khaterizer.math.Random;
import khaterizer.math.Vector2;


class TesterSystem extends System {

    var _firstRun:Bool;
    var _rand:khaterizer.math.Random;
    var _loc:Wire<Spatial>;
    var _rend:Wire<Renderable>;
    var _spam:Wire<Spammer>;
    var _ents:Family<Spatial>;
    var window:Wire<Renderer>;
    var count:Int;

    public function new() {
        //Welp, we're fucked
        //This line of code inexplicably impacts performance on native MAJORLY
        //It either needs to be placed inside initialize() or new(), and it WILL RANDOMLY CHANGE where it needs to be on compile
        //Good luck :|
        //new Random(9999);
    }

    override function initialize() {
        _firstRun = true;
        count = 0;
    }

    override function update() {
        if (_firstRun) {
            for (i in 0...100000) _spam.addRect(Random.getFloatIn(0, window.getCanvasWidth()), Random.getFloatIn(0, window.getCanvasHeight()), 1, 1);
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
            loc.position.x = Random.getFloatIn(0, window.getCanvasWidth());
            loc.position.y = Random.getFloatIn(0, window.getCanvasHeight());
        }
    }
}