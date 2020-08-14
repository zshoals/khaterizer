package khaterizer.ecs.systems.graphics;

import khaterizer.types.CppPerformanceHack;
import khaterizer.ecs.services.graphics.WindowConfiguration;
import khaterizer.ecs.services.graphics.Renderer;
import kha.input.Mouse;
import khaterizer.ecs.services.graphics.Camera;
import ecx.System;

class CameraSystem extends System {
    var camera:Wire<Camera>;
    var renderer:Wire<Renderer>;
    var window:Wire<WindowConfiguration>;
    var down:Bool;
    var xx:Float;
    var yy:Float;

    public function new() {
        new CppPerformanceHack();
    }

    override function initialize() {
        var mouse = Mouse.get(0);
        
        var onMouseDown = (button:Int, x:Int, y:Int) -> {
            if (button == 0) {
                down = true;
                renderer.unpauseRendering();
            }

            if (button == 3) {
                renderer.backbuffer.setResolution(1280, 720);
            }

            if (button == 2) {
                renderer.pauseRendering();
            }
        }
        var onMouseUp = (button:Int, x:Int, y:Int) -> {
            if (button == 0) {
                down = false;
            }
        }
        //Find where we ACTUALLY clicked on the backbuffer
        //then adjust from there
        //dunno how to do this yet
        var onMove = (x:Float, y:Float, moveX:Float, moveY:Float) -> {
            if (down) {
                final adjustX = Std.int(moveX / renderer.getCanvasScaleWidth());
                final adjustY = Std.int(moveY / renderer.getCanvasScaleHeight());
                camera.addMove(adjustX, adjustY);
            }

            this.xx = x;
            this.yy = y;
        }
        var onWheel = (delta:Int) -> {
            if (delta < 0) {
                camera.incrementalZoomToPoint(xx, yy, 0.05, 5);
            }
            if (delta > 0) {
                camera.incrementalZoomAwayFromPoint(xx, yy, 0.05, 5);
            }
        }
        var onMouseLeaveCanvas = () -> {
            
        }
        
        mouse.notify(onMouseDown, onMouseUp, onMove, onWheel, onMouseLeaveCanvas);
    }

    override function update() {}
}