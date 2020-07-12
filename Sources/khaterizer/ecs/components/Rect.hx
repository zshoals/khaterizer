package khaterizer.ecs.components;

import ecx.AutoComp;
import kha.math.Vector2;

class Rect extends AutoComp<RectData>{}

class RectData {
    public var width:Float;
    public var height:Float;
    public var topLeft:Vector2;
    public var topRight:Vector2;
    public var bottomLeft:Vector2;
    public var bottomRight:Vector2;
    public var midpoint:Vector2;

    public function new(){}

    public function setup(width:Float, height:Float):Void {
        this.width = width;
        this.height = height;
        this.topLeft = {x: 0, y: 0};
        this.topRight = {x: width, y: 0};
        this.bottomLeft = {x: 0, y: height};
        this.bottomRight = {x: width, y: height};
        this.midpoint = {x: width / 2, y: height / 2};
    }
}