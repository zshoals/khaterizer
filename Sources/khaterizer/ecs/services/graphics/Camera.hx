package khaterizer.ecs.services.graphics;

import ecx.Service;
import kha.math.FastMatrix3;
import kha.Canvas;

class Camera extends Service {
    public var x:Int;
    public var y:Int;
    public var rotation:Float;
    public var zoom:Float;
    public var captureWidth:Int;
    public var captureHeight:Int;
    public var enabled:Bool;

    private var running:Bool;
    private var graphics:kha.graphics2.Graphics;

    public function new() {}

    public function setup(x:Int, y:Int, rotation:Float, zoom:Float, captureWidth:Int, captureHeight:Int):Void {
        this.x = x;
        this.y = y;
        this.rotation = rotation;
        this.zoom = zoom;
        this.captureWidth = captureWidth;
        this.captureHeight = captureHeight;
        this.enabled = true;

        this.running = false;
    }

    public function begin(canvas:Canvas):Void {
        if (running) throw "End camera before you begin! The classic error returns to haunt you!";
        running = true;

        final cGraphics = canvas.g2;
        this.graphics = cGraphics;

        final translation = FastMatrix3.translation(x, y);
        final rotation = FastMatrix3.rotation(rotation);
        final scale = FastMatrix3.scale(zoom, zoom);
        final result = translation.multmat(rotation.multmat(scale));

        cGraphics.pushTransformation(result);
    }

    public function end():Void {
        if (!running) throw "Begin camera before you end! The classic error returns to haunt you!";
        running = false;
        
        this.graphics.popTransformation();
    }

    public function addMove(x:Int, y:Int):Void {
        this.x += x;
        this.y += y;
    }

    public function addZoomLevel(zoom:Float):Void {
        this.zoom += zoom;
    }

    public function addRotation(rotation:Float):Void {
        this.rotation += rotation;
    }

    public function move(x:Int, y:Int):Void {
        this.x = x;
        this.y = y;
    }

    public function zoomLevel(zoom:Float):Void {
        this.zoom = zoom;
    }

    public function rotate(rotation:Float):Void {
        this.rotation = rotation;
    }

    public function captureRegion(captureWidth:Int, captureHeight:Int):Void {
        this.captureWidth = captureWidth;
        this.captureHeight = captureHeight;
    }

    public function enable():Void {
        this.enabled = true;
    }

    public function disable():Void {
        this.enabled = false;
    }
}