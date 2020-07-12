package khaterizer.ecs.components;

import ecx.AutoComp;

class Circle extends AutoComp<CircleData> {}

class CircleData {
    public var radius:Float;

    public function new(){}

    public function setup(radius:Float = 0):Void {
        this.radius = radius;
    }
}