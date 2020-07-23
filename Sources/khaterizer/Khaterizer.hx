package khaterizer;

import ecx.Service;
import haxe.Timer;
import kha.Display;
import kha.Window;
import kha.WindowOptions;
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
import khaterizer.ecs.components.*;
import khaterizer.ecs.components.collision.*;
import khaterizer.ecs.components.graphics.*;
import khaterizer.ecs.systems.*;
import khaterizer.ecs.systems.graphics.*;
import khaterizer.ecs.services.*;
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
    public static var game:Application;

    public static function initialize(options:InitializationOptions, plugins:Array<WorldConfig>):Void {
        //This must occur before Kha does anything, lest very bad things happen
        startWorld(plugins, options.entityCapacity);
        //==================
        
        //We must use world.resolve here to access services
        //Since we cannot extend Khaterizer as a service without some weird circular dependency situation, I think
        var engineConfig = world.resolve(EngineConfiguration);
        var windowConfig = world.resolve(WindowConfiguration);

        windowConfig.setWindowVerticalSync(options.verticalSync);
        windowConfig.setWindowRefreshRate(options.refreshRate);

        windowConfig.setWindowTitle(options.title);
        windowConfig.setWindowMode(options.windowMode);
        windowConfig.setWindowBorderless(options.windowBorderless);

        windowConfig.setWindowSize(options.windowWidth, options.windowHeight);

        windowConfig.setWindowMinimizable(true);
        windowConfig.setWindowMaximizable(true);
        windowConfig.setWindowResizable(true);
        windowConfig.setWindowOnTop(false);

        final windowOptions:WindowOptions = {
            mode: windowConfig.windowMode,
            windowFeatures: @:privateAccess windowConfig.addWindowFeatures(),
        }
        
        final fbOptions:FramebufferOptions = {
            frequency: windowConfig.refreshRate,
            verticalSync: windowConfig.verticalSynced
        }

        final systemOptions:SystemOptions = {
            title: windowConfig.windowTitle,
            width: windowConfig.windowWidth,
            height: windowConfig.windowHeight,
            framebuffer: fbOptions,
            window: windowOptions
        }

        for (item in getDefineStrings()) trace(item);

        System.start(
            systemOptions,
            (_) -> Assets.loadFont(options.debugFontName, (font) -> {
                debugFont = font;
                
                #if !khaterizer_unsafe_update_rates
                assert(options.updateRate > 0 && options.updateRate <= 300, "InitializationOptions update rate is very low or very high. Use the khafile define khaterizer_unsafe_update_rates to ignore this restriction.");
                #end
                final updateFrequency = 1 / options.updateRate;

                game = world.resolve(Application);
                var renderer = world.resolve(Renderer);
                renderer.init(windowConfig.windowWidth, windowConfig.windowHeight);

                Scheduler.addTimeTask(function () { game.update(); }, 0, updateFrequency);
                System.notifyOnFrames(function (frames) { game.render(frames);});
            }, (e:kha.AssetError) -> throw e)
        );
    }

    static inline function startWorld(plugins:Array<WorldConfig>, capacity:Int):Void {
        var config = new WorldConfig();

        //==Add any supplied Plugins==
        for (plugin in plugins) config.include(plugin);

        #if khaterizer_default_services_enabled
        //==Core Engine Services==
        config.add(new Application());
        config.add(new Renderer());
        config.add(new WindowConfiguration());

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
        world = Engine.createWorld(config, capacity);
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