package khaterizer.graphics;

import kha.Color;
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
}

class RenderTarget implements Canvas {
    private var image:Image;

    public var width(get, null):Int;
    public var height(get, null):Int;
    public var resolutionWidth:Int;
    public var resolutionHeight:Int;
    public var scaleX:Float; //I think these are needed for the camera. Using them is pretty gross though IMO
    public var scaleY:Float;
    private var previousCanvasWidth:Int;
    private var previousCanvasHeight:Int;

    private var storedTransform:FastMatrix3;

    public var resolutionResizeStrategy:ResolutionSizing;
    public var scaleMode:ImageScaling;

    public var g1(get, null):kha.graphics1.Graphics;
    public var g2(get, null):kha.graphics2.Graphics;
    public var g4(get, null):kha.graphics4.Graphics;

    public function new(width:Int, height:Int, resolutionWidth:Int, resolutionHeight:Int, resolutionResizeStrategy:ResolutionSizing, scaleMode:ImageScaling) {
        assert(width > 0 && height > 0, "Tried to set a resolution less than 1. What are you doing?");
        this.image = Image.createRenderTarget(width, height);
        this.width = width;
        this.height = height;
        this.scaleX = 1;
        this.scaleY = 1;
        this.resolutionWidth = resolutionWidth;
        this.resolutionHeight = resolutionHeight;

        this.resolutionResizeStrategy = resolutionResizeStrategy;
        this.scaleMode = scaleMode;

        this.previousCanvasWidth = 0;
        this.previousCanvasHeight = 0;

        this.storedTransform = FastMatrix3.identity();
        assignGraphics();
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

        final needsResize = (cWidth != previousCanvasWidth || cHeight != previousCanvasHeight);

        if (needsResize) {
            previousCanvasWidth = cWidth;
            previousCanvasHeight = cHeight;

            switch resolutionResizeStrategy {
                case Grow:
                    resizeGrow(cWidth, cHeight);
                case GrowAndShrink:
                    resizeGrowAndShrink(cWidth, cHeight);
                case Shrink:
                    resizeShrink(cWidth, cHeight);
                case None: //Don't modify the Render Target resolution in any way
            }

            switch scaleMode {
                case Fill:
                    cGraphics.imageScaleQuality = ImageScaleQuality.High;
                    this.scaleX = canvas.width / this.width;
                    this.scaleY = canvas.height / this.height;
                    
                    this.storedTransform = FastMatrix3.scale(scaleX, scaleY);

                    cGraphics.pushTransformation(storedTransform);

                case MaintainAspectRatio:
                    //TODO: We need to extract that scale data from this so we can influence the camera
                    //TODO double: Doesn't work with stored transforms now
                    cGraphics.imageScaleQuality = ImageScaleQuality.High;
                    Scaler.scale(this.image, canvas, RotationNone);

                case IntegerScale:
                    //ScaleQuality just disrupts the image, turn it off here
                    cGraphics.imageScaleQuality = ImageScaleQuality.Low;

                    final minimumScalar = Math.min(Math.floor(cWidth / this.resolutionWidth), Math.floor(cHeight / this.resolutionHeight));
                    this.scaleX = minimumScalar;
                    this.scaleY = minimumScalar;

                    //Floor these to get rid of some stretchy pixel weirdness
                    final centerX = Math.floor(0.5 * (cWidth - (this.width * minimumScalar)));
                    final centerY = Math.floor(0.5 * (cHeight - (this.height * minimumScalar)));

                    final translation = FastMatrix3.translation(centerX, centerY);
                    final scaleMat = FastMatrix3.scale(minimumScalar, minimumScalar);

                    this.storedTransform = translation.multmat(scaleMat);

                    cGraphics.pushTransformation(storedTransform);
            }

            //Laziness
            if (scaleMode != MaintainAspectRatio) {
                cGraphics.drawImage(this.image, 0, 0);
                cGraphics.popTransformation();
            }
        }
        else {
            cGraphics.pushTransformation(storedTransform);
            cGraphics.drawImage(this.image, 0, 0);
            cGraphics.popTransformation();
        }
    }

    private inline function resizeGrow(cWidth:Int, cHeight:Int):Void {
        if (cWidth > this.resolutionWidth || cHeight > this.resolutionHeight) {
            resize(cWidth, cHeight);
        }
        else {
            resize(this.resolutionWidth, this.resolutionHeight);
        }
    }

    private inline function resizeGrowAndShrink(cWidth:Int, cHeight:Int):Void {
        if (this.width != cWidth || this.height != cHeight) {
            resize(cWidth, cHeight);
        }
    }

    private inline function resizeShrink(cWidth:Int, cHeight:Int):Void {
        if (cWidth < this.resolutionWidth || cHeight < this.resolutionHeight) {
            resize(cWidth, cHeight);
        }
        else {
            resize(this.resolutionWidth, this.resolutionHeight);
        }
    }

    private function drawDebugRect(canvas:Canvas, locX:Int, locY:Int) {
        final cGraphics = canvas.g2;
        var previousColor = cGraphics.color;
        cGraphics.color = Color.Red;
        cGraphics.drawRect(0, 0, locX, locY, 2);
        cGraphics.color = previousColor;
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