package khaterizer.ecs.systems.graphics;

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

    public function new() {}

    override function initialize() {
        var mouse = Mouse.get(0);
        
        var onMouseDown = (button:Int, x:Int, y:Int) -> {
            if (button == 0) {
                down = true;
            }

            if (button == 3) {
                renderer.backbuffer.setResolution(1280, 720);
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
                //It feels wrong to access scale here
                //How fix?
                final adjustX = Std.int(moveX / renderer.backbuffer.scaleX);
                final adjustY = Std.int(moveY / renderer.backbuffer.scaleY);
                camera.addMove(adjustX, adjustY);
            }
        }
        var onWheel = (delta:Int) -> {
            if (delta < 0) {
                camera.addZoomLevel(0.01);
            }
            if (delta > 0) {
                camera.addZoomLevel(-0.01);
            }
        }
        var onMouseLeaveCanvas = () -> {
            
        }
        
        mouse.notify(onMouseDown, onMouseUp, onMove, onWheel, onMouseLeaveCanvas);
    }

    override function update() {}

}