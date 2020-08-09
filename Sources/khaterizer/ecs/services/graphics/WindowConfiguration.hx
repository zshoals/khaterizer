package khaterizer.ecs.services.graphics;

import ecx.Service;
import kha.Window;
import kha.WindowOptions;

typedef ResizeMethod = (x:Int, y:Int) -> Void;

class WindowConfiguration extends Service {
    public var verticalSynced(default, null):Bool;
    public var refreshRate(default, null):Int;

    public var windowTitle(default, null):String;

    public var windowMode(default, null):kha.WindowMode;
    public var windowWidth(default, null):Int;
    public var windowHeight(default, null):Int;

    public var windowMinimizable(default, null):Bool;
    public var windowMaximizable(default, null):Bool;
    public var windowResizable(default, null):Bool;
    public var windowBorderless(default, null):Bool;
    public var windowOnTop(default, null):Bool;

    private var resizeCallbacks:Array<ResizeMethod>;

    public function new() {}

    override function initialize() {
        resizeCallbacks = [];

        Window.get(0).notifyOnResize((x:Int, y:Int) -> {
            windowWidth = x;
            windowHeight = y;
            callResizeCallbacks(windowWidth, windowHeight);
        });
    }

    /**
        Primarily used to scale RenderTargets in relation to the window in some way
    **/
    public function notifyOnResize(callback:ResizeMethod):Void {
        if (callback != null) {
            resizeCallbacks.push(callback);
        }
    }

    public function removeResizeNotifier(callback:ResizeMethod):Void {
        if (callback != null) {
            resizeCallbacks.remove(callback);
        }
    }

    private function callResizeCallbacks(x:Int, y:Int):Void {
        for (cb in resizeCallbacks) {
            cb(x, y);
        }
    }

    public function setWindowFullscreen():Void {} // TODO: Fill me out later when you're not tired

    //We'll never use more than one window amirite
    public function setWindowSize(width:Int, height:Int):Void {
        windowWidth = width;
        windowHeight = height;
    }

    public function setWindowTitle(title:String):Void{
        windowTitle = title;
    }

    public function setWindowMode(mode:kha.WindowMode) {
        windowMode = mode;
    }

    public function setWindowResizable(enabled:Bool):Void {
        windowResizable = enabled;
    }

    public function setWindowMinimizable(enabled:Bool):Void {
        windowMinimizable = enabled;
    }

    public function setWindowMaximizable(enabled:Bool):Void {
        windowMaximizable = enabled;
    }

    public function setWindowBorderless(enabled:Bool):Void {
        windowBorderless = enabled;
    }

    public function setWindowOnTop(enabled:Bool):Void {
        windowOnTop = enabled;
    }

    public function setWindowVerticalSync(enabled:Bool):Void {
        verticalSynced = enabled;
    }

    /**
        Non-functional as this feature is not currently operational in Kha
    **/
    public function setWindowRefreshRate(rate:Int):Void {}

    /**
        Applies all Khaterizer window settings that have been set through setWindow commands to the window.

        They will not be applied until this command is run. This can only used after the Window is initialized.
    **/
    public function applyWindowSettings():Void {
        final window = Window.get(0);
        //Change Framebuffer doesn't work
        //window.changeFramebuffer({frequency: _options.refreshRate, verticalSync: verticalSynced});
        window.changeWindowFeatures(addWindowFeatures());
        window.title = windowTitle;
        callResizeCallbacks(windowWidth, windowHeight);
    }

    private function addWindowFeatures():WindowFeatures {
        final resize = windowResizable ? WindowFeatures.FeatureResizable : WindowFeatures.None;
        final min = windowMinimizable ? WindowFeatures.FeatureMinimizable : WindowFeatures.None;
        final max = windowMaximizable ? WindowFeatures.FeatureMaximizable : WindowFeatures.None;
        final borderless = windowBorderless ? WindowFeatures.FeatureBorderless : WindowFeatures.None;
        final onTop = windowOnTop ? WindowFeatures.FeatureOnTop : WindowFeatures.None;

        return (resize | min | max | borderless | onTop);
    }

}