package khaterizer;

import khaterizer.types.CppPerformanceHack;
import khaterizer.graphics.RenderTarget.ResolutionSizing;
import khaterizer.graphics.RenderTarget.ImageScaling;
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
import khaterizer.ecs.services.*;
import khaterizer.ecs.services.graphics.Renderer;
import khaterizer.ecs.services.graphics.WindowConfiguration;
import khaterizer.ecs.systems.*;
import khaterizer.ecs.systems.graphics.*;
import khaterizer.math.Random;
import khaterizer.types.InitializationOptions;
import khaterizer.util.*;
import khaterizer.util.TimerUtil;

class Khaterizer extends Service {
    //Only reference this world instance for things lying OUTSIDE ECX
    //This is just a workaround for some of the awkwardness of ECX when it comes to mixing non-ECX and ECX things.
    public static var gWorld:World;

    var window:Wire<WindowConfiguration>;
    var engine:Wire<EngineConfiguration>;
    var deltaTime:Wire<DeltaTime>;
    var game:Wire<Application>;
    var renderer:Wire<Renderer>;

    public function new() {
        new CppPerformanceHack();
    }

    public function start(options:InitializationOptions):Void {
        window.setWindowVerticalSync(options.verticalSync);
        window.setWindowRefreshRate(options.refreshRate);

        window.setWindowTitle(options.title);
        window.setWindowMode(options.windowMode);
        window.setWindowBorderless(options.windowBorderless);

        window.setWindowSize(options.windowWidth, options.windowHeight);

        window.setWindowMinimizable(options.windowMinimizable);
        window.setWindowMaximizable(options.windowMaximizable);
        window.setWindowResizable(options.windowResizable);
        window.setWindowOnTop(options.windowOnTop);

        final windowOptions:WindowOptions = {
            mode: options.windowMode,
            windowFeatures: @:privateAccess window.addWindowFeatures(),
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
            (_) -> Assets.loadFont(options.debugFontName, (font) -> //Can we get an actual asset loader please Zan
                Assets.loadImage("pixel", (_) -> start2(options, font))));
    }

    private function start2(options:InitializationOptions, font:kha.Font):Void {
        //This part is supposed to be handled within ECX, but we really need Kha started before we call initialize on Services
        //So let's just hack it
        for(service in @:privateAccess world._orderedServices) {
            @:privateAccess service.initialize();
        }

        gWorld = world;

        Random.init(1337);

        engine.debugFont = font;
        
        #if !khaterizer_unsafe_update_rates
        assert(options.updateRate > 0 && options.updateRate <= 300, "InitializationOptions update rate is very low or very high. Use the khafile define khaterizer_unsafe_update_rates to ignore this restriction.");
        #end
        deltaTime.setTiming(1 / options.updateRate);

        //Renderer needs to be started here but we can retrieve it through Wire later if need be
        renderer.init(window.width, window.height, ResolutionSizing.None, ImageScaling.IntegerScale);

        Scheduler.addTimeTask(function () { game.update(); }, 0, deltaTime.dt());
        System.notifyOnFrames(function (frames) { game.render(frames);});
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