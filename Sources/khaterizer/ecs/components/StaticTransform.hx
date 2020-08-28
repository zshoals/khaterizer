package khaterizer.ecs.components;

import khaterizer.math.Vector2;
import khaterizer.math.FastMatrix3;
using khaterizer.math.FastMatrix3Ext;
import ecx.AutoComp;

/**
    A tag that represents never-changing entities. If an object will never change position, rotation, or scale, (its render transform) then

    add this component to avoid unnecessary matrix calculations.
**/
class StaticTransform extends AutoComp<StaticTransformData>{}

class StaticTransformData {
    public function new(){}
}