package khaterizer;

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
import khaterizer.Application;
import khaterizer.ecs.components.*;
import khaterizer.ecs.components.collision.*;
import khaterizer.ecs.components.graphics.*;
import khaterizer.ecs.systems.*;
import khaterizer.ecs.systems.graphics.*;
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

    public static var verticalSynced(default, null):Bool;
    public static var refreshRate(default, null):Int;

    public static var windowTitle(default, null):String;

    public static var windowMode(default, null):kha.WindowMode;

    public static var windowWidth(default, null):Int;
    public static var windowHeight(default, null):Int;

    public static var windowMinimizable(default, null):Bool;
    public static var windowMaximizable(default, null):Bool;
    public static var windowResizable(default, null):Bool;
    public static var windowBorderless(default, null):Bool;
    public static var windowOnTop(default, null):Bool;

    static var _game:Application;
    static var _options:InitializationOptions;

    public static function initialize(options:InitializationOptions, plugins:Array<WorldConfig>):Void {
        _options = options;

        verticalSynced = _options.verticalSync;
        refreshRate = _options.refreshRate;

        windowTitle = _options.title;
        windowMode = _options.windowMode;
        windowBorderless = _options.windowBorderless;

        windowWidth = Display.primary.x;
        windowHeight = Display.primary.y;
        windowMinimizable = true;
        windowMaximizable = true;
        windowResizable = true;
        windowOnTop = false; //Dunno how to handle this yet with regards to WindowMode, will try later

        if (windowBorderless && windowMode == kha.WindowMode.Fullscreen) {
            windowMinimizable = false;
            windowMaximizable = false;
            windowResizable = false;
        } else if (windowMode == kha.WindowMode.Fullscreen) {
            windowResizable = false;
        } else if (windowMode == kha.WindowMode.ExclusiveFullscreen) {
            windowResizable = false;
            windowBorderless = false;
        } else if (windowMode == kha.WindowMode.Windowed) {
            windowWidth = _options.windowWidth;
            windowHeight = _options.windowHeight;
        } else {
            throw "Tried to initialize Khaterizer without a properly set kha.WindowMode, check your initialization options";
        }

        trace("Window Features: " + addWindowFeatures());

        final windowOptions:WindowOptions = {
            mode: windowMode,
            windowFeatures: addWindowFeatures(),
        }
        
        final fbOptions:FramebufferOptions = {
            frequency: refreshRate,
            verticalSync: verticalSynced
        }

        final systemOptions:SystemOptions = {
            title: windowTitle,
            width: windowWidth,
            height: windowHeight,
            framebuffer: fbOptions,
            window: windowOptions
        }

        for (item in getDefineStrings()) trace(item);

        System.start(
            systemOptions,
            (_) -> Assets.loadFont(_options.debugFontName, (font) -> {
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

        final updateFrequency = 1 / _options.updateRate;
        Scheduler.addTimeTask(function () { _game.update(); }, 0, updateFrequency);
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

    //Engine-wide configuration commands
    //These should really all be moved to some sort of config class

    //We'll never use more than one window amirite
    //can't wait for this to be annoying later
    public static function setWindowSize(width:Int, height:Int):Void {
        windowWidth = width;
        windowHeight = height;
    }

    public static function setWindowTitle(title:String):String {
        Window.get(0).title = title;
        return title;
    }

    public static function setWindowMode(mode:kha.WindowMode) {
        windowMode = mode;
    }

    public static function setWindowResizable(enabled:Bool):Void {
        windowResizable = enabled;
    }

    public static function setWindowMinimizable(enabled:Bool):Void {
        windowMinimizable = enabled;
    }

    public static function setWindowMaximizable(enabled:Bool):Void {
        windowMaximizable = enabled;
    }

    public static function setWindowBorderless(enabled:Bool):Void {
        windowBorderless = enabled;
    }

    public static function setWindowOnTop(enabled:Bool):Void {
        windowOnTop = enabled;
    }

    public static function setWindowVerticalSync(enabled:Bool):Void {
        verticalSynced = enabled;
    }

    /**
        Deprecated. Non-functional as this feature is not currently operational in Kha
    **/
    @:deprecated
    public static function setWindowRefreshRate(rate:Int):Void {}

    /**
        Applies all Khaterizer window settings that have been set through setWindow commands to the window.

        They will not be applied until this command is run.
    **/
    public static function applyWindowSettings():Void {
        final window = Window.get(0);
        //window.changeFramebuffer({frequency: _options.refreshRate, verticalSync: verticalSynced});
        window.changeWindowFeatures(addWindowFeatures());
        //window.resize(windowWidth, windowHeight);

        //Hack. Fixes window lockup on feature change, lol.
        //window.mode = windowMode;

    }

    private static function addWindowFeatures():WindowFeatures {
        final resize = windowResizable ? WindowFeatures.FeatureResizable : WindowFeatures.None;
        final min = windowMinimizable ? WindowFeatures.FeatureMinimizable : WindowFeatures.None;
        final max = windowMaximizable ? WindowFeatures.FeatureMaximizable : WindowFeatures.None;
        final borderless = windowBorderless ? WindowFeatures.FeatureBorderless : WindowFeatures.None;
        final onTop = windowOnTop ? WindowFeatures.FeatureOnTop : WindowFeatures.None;

        return (resize | min | max | borderless | onTop);
    }
}