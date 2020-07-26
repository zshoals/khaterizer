package khaterizer.graphics;

import kha.graphics2.Graphics;
import kha.Image;
import kha.Canvas;

class RenderTarget implements Canvas {
    private var image:Image;

    public var width(get, null):Int;
    public var height(get, null):Int;

    public var g1(get, null):kha.graphics1.Graphics;
    public var g2(get, null):kha.graphics2.Graphics;
    public var g4(get, null):kha.graphics4.Graphics;

    public var lockedSize:Bool;

    public function new(width:Int, height:Int) {
        this.image = Image.createRenderTarget(width, height);
        this.width = width;
        this.height = height;
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
        Call this before removing your reference to a RenderTarget to make sure Kha unloads the render target properly.
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

    private function get_width() {
        return this.width;
    }

    private function get_height() {
        return this.height;
    }

    private function get_g1() {
        return this.g1;
    }

    private function get_g2() {
        return this.g2;
    }

    private function get_g4() {
        return this.g4;
    }
}