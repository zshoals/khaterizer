package khaterizer;

import khaterizer.util.TimerUtil;
import kha.Assets;
import kha.Framebuffer;
import kha.FramebufferOptions;
import kha.Scheduler;
import kha.System;
import ecx.WorldConfig;
import ecx.World;
import ecx.Engine;
import ecx.Wire;
import khaterizer.types.InitOptions;
import khaterizer.GameWorld;
import khaterizer.components.*;
import khaterizer.components.collision.*;
import khaterizer.components.graphics.*;
import khaterizer.systems.*;
import khaterizer.graphics.*;
import khaterizer.util.*;

enum abstract SystemPriority(Int) to Int {
    var Preupdate = 1;
    var Update = 100;
    var Move = 200;
    var ResolveCollisions = 300;
    var StateMachines = 400;
    var Animate = 500;
    var Render = 600;
}

class Khaterizer {

    public static var _world:World;
    public static var _game:GameWorld;
    static var _options:InitOptions;

    public static function initialize(options:InitOptions, plugins:Array<WorldConfig>):Void {
        _options = options;
        
        final fbOptions = new FramebufferOptions(
            _options.refreshRate,
            _options.verticalSync);

        definesReport();

        System.start({
            title: _options.title,
            width: _options.windowWidth,
            height: _options.windowHeight,
            framebuffer: fbOptions},
            function(_) { 
                Assets.loadEverything(function () {	

                defaultConfigInit(plugins);
                final _game = new GameWorld(_world);
                
                // Avoid passing update/render directly,
                // so replacing them via code injection work
                
                #if !khaterizer_unsafe_update_rates
                assert(_options.updateRate > 0 && _options.updateRate <= 300, "InitOptions update rate is very low or very high. Use the khafile define khaterizer_unsafe_update_rates to ignore this restriction.");
                #end
                Scheduler.addTimeTask(function () { _game.update(); }, 0, 1 / _options.updateRate); //Protect against dangerous update rates
                System.notifyOnFrames(function (frames) { _game.render(frames);});
            });
        });
    }

    static inline function definesReport() {
        //ECX is not a fan of other macros so I guess we're doing it manually
        var defines = ["The following Khaterizer defines are activated:"];
        #if khaterizer_unsafe_update_rates
        defines.push("khaterizer_unsafe_update_rates");
        #end
        #if khaterizer_default_services_enabled
        defines.push("khaterizer_default_services_enabled");
        #end
        #if no_assert
        defines.push("no_assert");
        #end
        if (defines.length == 1) defines.push("None");

        for (d in defines) trace(d);
    }


    static inline function defaultConfigInit(plugins:Array<WorldConfig>):Void {

        var config = new WorldConfig();
        //==Plugins==
        for (plugin in plugins) config.include(plugin);

        #if khaterizer_default_services_enabled
        //==Core Engine Services==
        config.add(new Spammer());
        //==Core Engine Systems==
        config.add(new TesterSystem(), Update);
        config.add(new RenderSystem(), Render + 1);
        //==Core Engine Components==
        config.add(new Rect());
        config.add(new CollisionRect());
        config.add(new Spatial());
        config.add(new Renderable());
        #end

        //==Initialize==
        _world = Engine.createWorld(config, _options.entityCapacity);
    }
}