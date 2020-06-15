package khaterizer.components;

import ecx.AutoComp;
import kha.math.Vector2;

class Velocity extends AutoComp<VelocityData>{}

class VelocityData {
    var velocity:Vector2;
    var angularVelocity:Float;
    var acceleration:Float;
    
    public function new(){}

    public function setup(velocity:Vector2, angularVelocity:Float, acceleration:Float){
        this.velocity = velocity;
        this.angularVelocity = angularVelocity;
        this.acceleration = acceleration;
    }
}