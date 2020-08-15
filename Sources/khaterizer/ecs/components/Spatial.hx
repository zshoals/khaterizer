package khaterizer.ecs.components;

import khaterizer.math.Vector2;
import ecx.AutoComp;

class Spatial extends AutoComp<SpatialData>{}

class SpatialData {
    public var position:Vector2;
    public var rotation:Float;
    
    public var linearVelocity:Vector2;
    public var angularVelocity:Float;

    public function new(){}

    public function setup(
        x:Float, y:Float, 
        ?rotation:Float, 
        ?linearVelocity:Vector2, 
        ?angularVelocity:Float):Void {
        this.position = new Vector2(x, y);
        this.rotation = rotation == null ? 0 : rotation;
        this.linearVelocity = linearVelocity == null ? new Vector2(0, 0) : linearVelocity;
        this.angularVelocity = angularVelocity == null ? 0 : angularVelocity;
    }
}