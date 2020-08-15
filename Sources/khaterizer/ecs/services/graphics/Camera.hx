package khaterizer.ecs.services.graphics;

import khaterizer.types.CppPerformanceHack;
import ecx.Service;
import kha.math.FastMatrix3;
import kha.Canvas;

class Camera extends Service {
    public var x:Int;
    public var y:Int;
    public var rotation:Float;
    public var zoom:Float;
    private var zoomLocX:Int;
    private var zoomLocY:Int;
    public var captureWidth:Int;
    public var captureHeight:Int;

    private var dirty:Bool;
    private var lastMatrix:FastMatrix3;
    private var running:Bool;

    private var graphics:kha.graphics2.Graphics;
    private var window:Wire<WindowConfiguration>;

    public function new() {
        new CppPerformanceHack();
    }

    override function initialize():Void {
        this.setup(0, 0, 0, 1);
    }

    //We might want to change x/y to floats, but...
    //I believe this keeps us pixel perfect?
    public function setup(x:Int, y:Int, rotation:Float, zoom:Float):Void {
        this.x = x;
        this.y = y;
        this.rotation = rotation;
        this.zoom = zoom;
        this.zoomLocX = 0;
        this.zoomLocY = 0;
        
        this.dirty = true;
        this.running = false;
    }

    public function begin(canvas:Canvas):Void {
        if (running) throw "End camera before you begin! The classic error returns to haunt you!";
        running = true;
        
        if (this.zoom < 0.1) {
            this.zoom = 0.1;
        }

        final cGraphics = canvas.g2;
        this.graphics = cGraphics;

        if (dirty) {
            final midWidth = canvas.width / 2;
            final midHeight = canvas.height / 2;

            final centerTrans = FastMatrix3.translation(-midWidth, -midHeight);
            final rotation = FastMatrix3.rotation(MathUtil.deg2rad(-rotation));
            final counterTrans = FastMatrix3.translation(midWidth, midHeight);

            final centerScale = FastMatrix3.translation(-midWidth, -midHeight);
            final scale = FastMatrix3.scale(zoom, zoom);
            final counterScale = FastMatrix3.translation(midWidth, midHeight);

            final translation = FastMatrix3.translation(x, y);
            final centeredRotation = counterTrans.multmat(rotation.multmat(centerTrans));
            final centeredScale = counterScale.multmat(scale.multmat(centerScale));

            this.lastMatrix = translation.multmat(centeredRotation.multmat(scale));
            this.dirty = false;
        }

        cGraphics.pushTransformation(this.lastMatrix);
    }

    public function end():Void {
        if (!running) throw "Begin camera before you end! The classic error returns to haunt you!";
        running = false;
        
        this.graphics.popTransformation();
    }

    public function incrementalZoomToPoint(xx:Float, yy:Float, zoom:Float, locationBias:Float):Void {
        this.addZoomLevel(zoom);
        final minimum = Math.min(window.centerWidth, window.centerHeight);
        final shiftX = Std.int(-((MathUtil.clamp(xx - window.centerWidth, -minimum, minimum)  * zoom) * locationBias));
        final shiftY = Std.int(-((MathUtil.clamp(yy - window.centerHeight, -minimum, minimum)  * zoom) * locationBias));
        this.addMove(shiftX, shiftY);

        this.dirty = true;
    }

    public function incrementalZoomAwayFromPoint(xx:Float, yy:Float, zoom:Float, locationBias:Float):Void {
        this.addZoomLevel(-zoom);
        final minimum = Math.min(window.centerWidth, window.centerHeight);
        final shiftX = Std.int(((MathUtil.clamp(xx - window.centerWidth, -minimum, minimum)  * zoom) * locationBias));
        final shiftY = Std.int(((MathUtil.clamp(yy - window.centerHeight, -minimum, minimum)  * zoom) * locationBias));
        this.addMove(shiftX, shiftY);

        this.dirty = true;
    }

    public function addMove(x:Int, y:Int):Void {
        this.x += x;
        this.y += y;

        this.dirty = true;
    }

    public function addZoomLevel(zoom:Float):Void {
        this.zoom += zoom;

        this.dirty = true;
    }

    public function zoomLocation(x:Int, y:Int):Void {
        this.zoomLocX = x;
        this.zoomLocY = y;

        this.dirty = true;
    }

    public function addRotation(rotation:Float):Void {
        //Check previous sign maybe?
        this.rotation += rotation;
        this.rotation %= 360;

        this.dirty = true;
    }

    public function move(x:Int, y:Int):Void {
        this.x = x;
        this.y = y;

        this.dirty = true;
    }

    public function zoomLevel(zoom:Float):Void {
        this.zoom = zoom;

        this.dirty = true;
    }

    public function rotate(rotation:Float):Void {
        this.rotation = rotation;
        this.rotation %= 360;

        this.dirty = true;
    }
}