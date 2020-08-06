package khaterizer;

import ecx.Engine;
import ecx.Service;
import ecx.Wire;
import ecx.World;
import ecx.WorldConfig;
import haxe.Timer;
import kha.Assets;
import kha.Display;
import kha.Font;
import kha.Framebuffer;
import kha.FramebufferOptions;
import kha.Scheduler;
import kha.System;
import kha.Window;
import kha.WindowOptions;
import khaterizer.ecs.blueprints.*;
import khaterizer.ecs.components.*;
import khaterizer.ecs.components.collision.*;
import khaterizer.ecs.components.graphics.*;
import khaterizer.ecs.services.*;
import khaterizer.ecs.systems.*;
import khaterizer.ecs.systems.graphics.*;
import khaterizer.graphics.*;
import khaterizer.types.InitializationOptions;
import khaterizer.util.*;
import khaterizer.util.TimerUtil;

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
    public static var game:Application;
    
    public static var debugFont:Font;

    public static function initialize(options:InitializationOptions, plugins:Array<WorldConfig>):Void {
        //We're not going to talk about this
        final resize = options.windowResizable ? WindowFeatures.FeatureResizable : WindowFeatures.None;
        final min = options.windowMinimizable ? WindowFeatures.FeatureMinimizable : WindowFeatures.None;
        final max = options.windowMaximizable ? WindowFeatures.FeatureMaximizable : WindowFeatures.None;
        final borderless = options.windowBorderless ? WindowFeatures.FeatureBorderless : WindowFeatures.None;
        final onTop = options.windowOnTop ? WindowFeatures.FeatureOnTop : WindowFeatures.None;

        final features:Null<WindowFeatures> = (resize | min | max | borderless | onTop);

        final windowOptions:WindowOptions = {
            mode: options.windowMode,
            windowFeatures: features,
        }
        
        final fbOptions:FramebufferOptions = {
            frequency: options.refreshRate,
            verticalSync: options.verticalSync
        }

        final systemOptions:SystemOptions = {
            title: options.title,
            width: options.windowWidth,
            height: options.windowHeight,
            framebuffer: fbOptions,
            window: windowOptions
        }

        for (item in getDefineStrings()) trace(item);

        System.start(
            systemOptions,
            (_) -> Assets.loadFont(options.debugFontName, (font) ->
                Assets.loadImage("pixel", (_) -> {
                debugFont = font;

                world = buildWorld(plugins, options.entityCapacity);

                //We must use world.resolve here to access services
                //Since we cannot extend Khaterizer as a service without some weird circular dependency situation, I think
                var engineConfig = world.resolve(EngineConfiguration);
                var windowConfig = world.resolve(WindowConfiguration);
        
                //To get things into ECX we have to set the window stuff twice
                //Not all window settings can be properly changed after Kha begins (vsync)
                windowConfig.setWindowVerticalSync(options.verticalSync);
                windowConfig.setWindowRefreshRate(options.refreshRate);

                windowConfig.setWindowTitle(options.title);
                windowConfig.setWindowMode(options.windowMode);
                windowConfig.setWindowBorderless(options.windowBorderless);

                windowConfig.setWindowSize(options.windowWidth, options.windowHeight);
        
                windowConfig.setWindowMinimizable(options.windowMinimizable);
                windowConfig.setWindowMaximizable(options.windowMaximizable);
                windowConfig.setWindowResizable(options.windowResizable);
                windowConfig.setWindowOnTop(options.windowOnTop);
                
                #if !khaterizer_unsafe_update_rates
                assert(options.updateRate > 0 && options.updateRate <= 300, "InitializationOptions update rate is very low or very high. Use the khafile define khaterizer_unsafe_update_rates to ignore this restriction.");
                #end
                
                var deltaTime = world.resolve(DeltaTime);
                deltaTime.setTiming(1 / options.updateRate);

                game = world.resolve(Application);
                //Renderer needs to be started here but we can retrieve it through Wire later if need be
                var renderer = world.resolve(Renderer);
                renderer.init(windowConfig.windowWidth, windowConfig.windowHeight);

                Scheduler.addTimeTask(function () { game.update(); }, 0, deltaTime.dt());
                System.notifyOnFrames(function (frames) { game.render(frames);});
            }, (e:kha.AssetError) -> throw e)
        ));
    }

    static inline function buildWorld(plugins:Array<WorldConfig>, capacity:Int):World {
        var config = new WorldConfig();

        //==Add any supplied Plugins==
        for (plugin in plugins) config.include(plugin);

        #if khaterizer_default_services_enabled
        //==Core Engine Services==
        config.add(new Application());
        config.add(new WindowConfiguration());
        config.add(new Renderer());
        config.add(new DeltaTime());

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
        return Engine.createWorld(config, capacity);
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