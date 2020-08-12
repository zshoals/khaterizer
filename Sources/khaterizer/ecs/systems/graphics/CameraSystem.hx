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
                //final adjustX = Std.int(x - window.windowWidth / 2);
                //final adjustY = Std.int(y - window.windowHeight / 2);
                camera.addMove(Std.int(moveX * camera.zoom), Std.int(moveY * camera.zoom));
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