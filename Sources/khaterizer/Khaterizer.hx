package khaterizer;

import kha.Font;
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
import khaterizer.types.InitializationOptions;
import khaterizer.Application;
import khaterizer.components.*;
import khaterizer.components.collision.*;
import khaterizer.components.graphics.*;
import khaterizer.systems.*;
import khaterizer.systems.graphics.*;
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

    public static var world:World;
    public static var debugFont:Font;

    static var _game:Application;
    static var _options:InitializationOptions;

    public static function initialize(options:InitializationOptions, plugins:Array<WorldConfig>):Void {
        _options = options;
        
        final fbOptions = new FramebufferOptions(
            _options.refreshRate,
            _options.verticalSync
        );

        for (item in getDefineStrings()) trace(item);

        System.start({
            title: _options.title,
            width: _options.windowWidth,
            height: _options.windowHeight,
            framebuffer: fbOptions},
            (_) -> Assets.loadFont(_options.debugFontName, (font) ->  {
                debugFont = font;
                startWorld(plugins);
            }, (e:kha.AssetError) -> throw e)
        );
    }

    static inline function startWorld(plugins:Array<WorldConfig>):Void {
        var config = new WorldConfig();

        //==Add any supplied Plugins==
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
        world = Engine.createWorld(config, _options.entityCapacity);
        final _game = new Application();
        
        #if !khaterizer_unsafe_update_rates
        assert(_options.updateRate > 0 && _options.updateRate <= 300, "InitializationOptions update rate is very low or very high. Use the khafile define khaterizer_unsafe_update_rates to ignore this restriction.");
        #end
        Scheduler.addTimeTask(function () { _game.update(); }, 0, 1 / _options.updateRate);
        System.notifyOnFrames(function (frames) { _game.render(frames);});
    }

    static inline function getDefineStrings():Array<String> {
        //ECX is not a fan of other macros so I guess we're doing it manually for now
        //Macros can be imported from libraries but not used directly in the Khaterizer repository...
        //And I am very lazy
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

        return defines;
    }
}