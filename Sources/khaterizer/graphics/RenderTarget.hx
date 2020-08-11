package khaterizer.graphics;

import kha.graphics2.ImageScaleQuality;
import khaterizer.math.FastMatrix3;
import kha.input.Mouse;
import kha.ScreenRotation;
import kha.Scaler;
import kha.graphics2.Graphics;
import kha.Image;
import kha.Canvas;

enum abstract ResolutionSizing(Int) {
    var Grow;
    var GrowAndShrink;
    var Shrink;
    var None;
}

enum abstract ImageScaling(Int) {
    var Fill;
    var MaintainAspectRatio;
    var IntegerScale;
    var None;
}

class RenderTarget implements Canvas {
    private var image:Image;

    public var width(get, null):Int;
    public var height(get, null):Int;
    public var resolutionWidth:Int;
    public var resolutionHeight:Int;
    private var previousCanvasWidth:Int;
    private var previousCanvasHeight:Int;

    public var resolutionResizeStrategy:ResolutionSizing;
    public var scaleMode:ImageScaling;

    public var g1(get, null):kha.graphics1.Graphics;
    public var g2(get, null):kha.graphics2.Graphics;
    public var g4(get, null):kha.graphics4.Graphics;

    public function new(width:Int, height:Int, resolutionResizeStrategy:ResolutionSizing, scaleMode:ImageScaling) {
        this.image = Image.createRenderTarget(width, height);
        this.width = width;
        this.height = height;
        this.resolutionWidth = width;
        this.resolutionHeight = height;

        this.resolutionResizeStrategy = resolutionResizeStrategy;
        this.scaleMode = scaleMode;

        this.previousCanvasWidth = 0;
        this.previousCanvasHeight = 0;
        assignGraphics();
    }

    public function getImage():Image {
        return image;
    }

    private function resize(width:Int, height:Int):Void {
        this.image.unload();
        this.image = Image.createRenderTarget(width, height);
        this.width = width;
        this.height = height;
        assignGraphics();
    }

    /**
        Resize the Render Target and set its resolution. 

        This affects how various scaling methods affect this Render Target.
    **/
    public function setResolution(width:Int, height:Int):Void {
        assert(width > 0 && height > 0, "Tried to set a resolution less than 1. What are you doing?");
        this.resolutionWidth = width;
        this.resolutionHeight = height;
        this.resize(width, height);
    }

    public function renderTo(canvas:Canvas):Void {
        final cGraphics = canvas.g2;
        final cWidth = canvas.width;
        final cHeight = canvas.height;

        if (cWidth != previousCanvasWidth || cHeight != previousCanvasHeight) {
            previousCanvasWidth = cWidth;
            previousCanvasHeight = cHeight;

            switch resolutionResizeStrategy {
                case Grow:
                    resizeGrow(cGraphics, cWidth, cHeight);
                case GrowAndShrink:
                    resizeGrowAndShrink(cGraphics, cWidth, cHeight);
                case Shrink:
                    resizeShrink(cGraphics, cWidth, cHeight);
                case None: //Don't modify the Render Target in any way
                    return;
            }
        }

        if (resolutionResizeStrategy == ResolutionSizing.None) {
            switch scaleMode {
                case Fill:
                    cGraphics.imageScaleQuality = ImageScaleQuality.High;
                    cGraphics.pushTransformation(FastMatrix3.scale(canvas.width / this.width, canvas.height / this.height));
                    cGraphics.drawImage(this.image, 0, 0);
                    cGraphics.popTransformation();
                case MaintainAspectRatio:
                    //This tool just does it for us, neat
                    cGraphics.imageScaleQuality = ImageScaleQuality.High;
                    Scaler.scale(this.image, canvas, RotationNone);
                case IntegerScale:
                    //No scaling required if we do it right
                    cGraphics.imageScaleQuality = ImageScaleQuality.Low;
                    this.scaleByInteger(canvas, cWidth, cHeight);
                case None:
                    g2.drawImage(this.image, 0, 0);
            }
        }
    }

    //I think all of these need to be changed, or at least some do
    //They actually need to scale the resultant image, not just resize the Render Target
    //Cool effect anyway
    private inline function resizeGrow(cGraphics:Graphics, cWidth:Int, cHeight:Int):Void {
        if (cWidth > this.resolutionWidth || cHeight > this.resolutionHeight) {
            resize(cWidth, cHeight);
        }
        else {
            resize(this.resolutionWidth, this.resolutionHeight);
        }
    }

    private inline function resizeGrowAndShrink(cGraphics:Graphics, cWidth:Int, cHeight:Int):Void {
        if (this.width != cWidth || this.height != cHeight) {
            resize(cWidth, cHeight);
        }
    }

    private inline function resizeShrink(cGraphics:Graphics, cWidth:Int, cHeight:Int):Void {
        if (cWidth < this.resolutionWidth || cHeight < this.resolutionHeight) {
            resize(cWidth, cHeight);
        }
        else {
            resize(this.resolutionWidth, this.resolutionHeight);
        }
    }

    //Feels good man :)
    private inline function scaleByInteger(cGraphics:Canvas, cWidth:Int, cHeight:Int):Void {
        final scaleMultX = Math.floor(cWidth / this.resolutionWidth);
        final scaleMultY = Math.floor(cHeight / this.resolutionHeight);
        final minimumScalar = Math.min(scaleMultX, scaleMultY);

        var scale = FastMatrix3.scale(minimumScalar, minimumScalar);

        final centerX = 0.5 * (cWidth - (this.width * minimumScalar));
        final centerY = 0.5 * (cHeight - (this.height * minimumScalar));

        final translation = FastMatrix3.translation(centerX, centerY);

        cGraphics.g2.pushTransformation(translation.multmat(scale));
        cGraphics.g2.drawImage(this.image, 0, 0);
        cGraphics.g2.popTransformation();
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