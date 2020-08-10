package khaterizer.graphics;

import ecx.Service;
import kha.graphics2.Graphics;
import kha.Image;
import kha.Canvas;

enum RenderTargetScaleStrategy {
    Grow;
    GrowAndShrink;
    Shrink;
    IntegerScale;
    None;
}

class RenderTarget implements Canvas {
    private var image:Image;

    public var width(get, null):Int;
    public var height(get, null):Int;
    private var baselineWidth:Int;
    private var baselineHeight:Int;
    private var previousCanvasWidth:Int;
    private var previousCanvasHeight:Int;

    public var scaleStrategy:RenderTargetScaleStrategy;

    public var g1(get, null):kha.graphics1.Graphics;
    public var g2(get, null):kha.graphics2.Graphics;
    public var g4(get, null):kha.graphics4.Graphics;

    public function new(width:Int, height:Int, scaleStrategy:RenderTargetScaleStrategy) {
        this.image = Image.createRenderTarget(width, height);
        this.width = width;
        this.height = height;
        this.baselineWidth = width;
        this.baselineHeight = height;
        this.scaleStrategy = scaleStrategy;

        this.previousCanvasWidth = 0;
        this.previousCanvasHeight = 0;
        assignGraphics();
    }

    public function getImage():Image {
        return image;
    }

    public function resize(width:Int, height:Int):Void {
        this.image.unload();
        this.image = Image.createRenderTarget(width, height);
        this.width = width;
        this.height = height;
        assignGraphics();
    }

    /**
        Resize the Render Target and set its baseline width and height. 

        This affects how various scaling methods affect this Render Target.
    **/
    public function hardResize(width:Int, height:Int):Void {
        this.baselineWidth = width;
        this.baselineHeight = height;
        this.resize(width, height);
    }

    public function draw(canvas:Canvas):Void {
        final g = canvas.g2;
        final cWidth = canvas.width;
        final cHeight = canvas.height;

        if (cWidth != previousCanvasWidth || cHeight != previousCanvasHeight) {
            previousCanvasWidth = cWidth;
            previousCanvasHeight = cHeight;

            switch scaleStrategy {
                case Grow:
                    scaleGrow(g, cWidth, cHeight);
                case GrowAndShrink:
                    scaleGrowAndShrink(g, cWidth, cHeight);
                case Shrink:
                    scaleShrink(g, cWidth, cHeight);
                default: return;
            }
        }

        g.drawImage(this.image, 0, 0);
    }

    //TODO: This check isn't enough, still breaks if things stretch too much on one axis. Too tired to fix :(
    private inline function scaleGrow(g:Graphics, cWidth:Int, cHeight:Int):Void {
        if (cWidth > this.baselineWidth || cHeight > this.baselineHeight) {
            resize(cWidth, cHeight);
        }
        else {
            resize(this.baselineWidth, this.baselineHeight);
        }
    }

    private inline function scaleGrowAndShrink(g:Graphics, cWidth:Int, cHeight:Int):Void {
        if (this.width != cWidth || this.height != cHeight) {
            resize(cWidth, cHeight);
        }
    }

    private inline function scaleShrink(g:Graphics, cWidth:Int, cHeight:Int):Void {
        if (cWidth < this.baselineWidth || cHeight < this.baselineHeight) {
            resize(cWidth, cHeight);
        }
        else {
            resize(this.baselineWidth, this.baselineHeight);
        }
    }

    /**
        Call this before removing your reference to a RenderTarget to unload the render target properly.
    **/
    public function unload():Void {
        this.g1 = null;
        this.g2 = null;
        this.g4 = null;
        this.width = 0;
        this.height = 0;

        this.image.unload();
    }

    private function assignGraphics():Void {
        this.g1 = this.image.g1;
        this.g2 = this.image.g2;
        this.g4 = this.image.g4;
    }

    private function get_width():Int {
        return this.width;
    }

    private function get_height():Int {
        return this.height;
    }

    private function get_g1():kha.graphics1.Graphics {
        return this.g1;
    }

    private function get_g2():kha.graphics2.Graphics {
        return this.g2;
    }

    private function get_g4():kha.graphics4.Graphics {
        return this.g4;
    }
}