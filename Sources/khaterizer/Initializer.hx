package khaterizer;

import ecx.World;
import ecx.WorldConfig;
import ecx.Engine;
import khaterizer.input.Keypress;
import khaterizer.ecs.blueprints.*;
import khaterizer.ecs.components.*;
import khaterizer.ecs.components.collision.*;
import khaterizer.ecs.components.graphics.*;
import khaterizer.ecs.services.*;
import khaterizer.ecs.services.graphics.*;
import khaterizer.ecs.systems.*;
import khaterizer.ecs.systems.graphics.*;
import khaterizer.graphics.*;
import khaterizer.types.InitializationOptions;
import khaterizer.util.*;
import khaterizer.util.TimerUtil;
import khaterizer.Khaterizer;

enum abstract SystemPriority(Int) to Int {
    var Preupdate = 1;
    var Update = 100;
    var Move = 200;
    var ResolveCollisions = 300;
    var StateMachines = 400;
    var Animate = 500;
    var Render = 600;
}

class Initializer {
    public static function initialize(options:InitializationOptions, plugins:Array<WorldConfig>):Void {
        var config = new WorldConfig();

        //==Add any supplied Plugins==
        for (plugin in plugins) config.include(plugin);

        //TODO: At some point, turn these default services into a instantiable plugin that can be supplied by the user if they want it
        //Simpler that way
        #if khaterizer_default_services_enabled
        //==Core Engine Services==
        config.add(new Khaterizer());
        config.add(new Application());
        config.add(new WindowConfiguration());
        config.add(new EngineConfiguration());
        config.add(new Renderer());
        config.add(new DeltaTime());
        config.add(new Camera());

        config.add(new Spammer());
        //==Core Engine Systems==
        config.add(new TesterSystem(), Update);
        config.add(new CameraSystem(), Update);
        config.add(new RenderProxySystem(), Render + 1);
        //==Core Engine Components==
        config.add(new Rect());
        config.add(new CollisionRect());
        config.add(new Spatial());
        config.add(new Renderable());
        #end

        //==Initialize==
        var world = Engine.createWorld(config, options.entityCapacity);
        var game = world.resolve(Khaterizer);
        game.start(options);
    }
}