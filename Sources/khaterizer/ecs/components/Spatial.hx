package khaterizer.ecs.components;

import kha.FastFloat;
import khaterizer.math.FastMatrix3;
using khaterizer.math.FastMatrix3Ext;
import khaterizer.math.Vector2;
import ecx.AutoComp;

class Spatial extends AutoComp<SpatialData>{}

class SpatialData {
    public var position:Vector2;
    public var rotation(default, set):Float;
    
    public var linearVelocity:Vector2;
    public var angularVelocity:Float;

    public var scale:Vector2;

    public function new(){}

    public function setup(
        position:Vector2,
        rotation:Float, 
        linearVelocity:Vector2, 
        angularVelocity:Float,
        scale:Vector2
    ): Void {
        this.position = position;
        this.rotation = rotation;
        this.linearVelocity = linearVelocity;
        this.angularVelocity = angularVelocity;
        this.scale = scale;
    }

    function set_rotation(f:Float): Float {
        return rotation = f % 360;
    }
}