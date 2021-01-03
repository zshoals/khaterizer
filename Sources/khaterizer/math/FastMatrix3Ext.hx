package khaterizer.math;

import kha.FastFloat;
import kha.simd.Float32x4;
import kha.math.FastMatrix3;
using khaterizer.math.FastMatrix3Ext; //Have to use yourself. That's just strange mate.

class FastMatrix3Ext {
    @:extern public static inline function rotationAround(clazz:Class<FastMatrix3>, x:FastFloat, y:FastFloat, alpha:FastFloat): FastMatrix3 {
        return FastMatrix3.translation(x, y).multmat(FastMatrix3.rotation(alpha).multmat(FastMatrix3.translation(-x, -y)));
    }

    /**
        A complete transformation matrix for 2D objects. Intended to be regenerated each frame.

        @param x The pure horizontal position of the object from the top left corner.
        @param y The pure vertical position of the object from the top left corner.
        @param anchorX The horizontal anchor point to adjust this object by for rotation and translation.
        @param anchorY The vertical anchor point to adjust this object by for rotation and translation.
        @param alpha The rotation of this object around its anchor point.
        @param scaleX The horizontal scale of this object.
        @param scaleY The vertical scale of this object.
    **/
    @:extern public static inline function transformationRaw(clazz:Class<FastMatrix3>, 
        x:FastFloat, y:FastFloat, 
        anchorX:FastFloat, anchorY:FastFloat, 
        degrees:FastFloat, 
        scaleX:FastFloat, scaleY:FastFloat): FastMatrix3 {

        return FastMatrix3.translation(x - anchorX, y - anchorY)
            .multmat(FastMatrix3.rotationAround(anchorX, anchorY, MathUtil.deg2rad(degrees))
            .multmat(FastMatrix3.scale(scaleX, scaleY)));

        //This stuff is actually slower and more memory intensive (double) than just doing the above
        //I guess the below code causes an allocation or something :/
        //I have a lot to learn I guess.

        //Try and skip some of the more expensive operations if they're not needed
        // if (MathUtil.withinRotationTolerance(degrees)) {
        //     return FastMatrix3.translation(x - anchorX, y - anchorY).multmat(FastMatrix3.scale(scaleX, scaleY));
        // }
        // else if (MathUtil.withinTolerance(anchorX) && MathUtil.withinTolerance(anchorY)) {
        //     return FastMatrix3.translation(x, y).multmat(FastMatrix3.rotation(MathUtil.deg2rad(degrees)).multmat(FastMatrix3.scale(scaleX, scaleY)));
        // }
        // else {
        //     return FastMatrix3.translation(x - anchorX, y - anchorY)
        //     .multmat(FastMatrix3.rotationAround(anchorX, anchorY, MathUtil.deg2rad(degrees))
        //     .multmat(FastMatrix3.scale(scaleX, scaleY)));
        // }
    }

    /**
        A complete transformation matrix for 2D objects. Intended to be regenerated each frame.

        Uses vectors instead of raw values. See FastMatrix3Ext.transformationRaw for parameter details.
    **/
    @:extern public static inline function transformation(clazz:Class<FastMatrix3>, position:Vector2, anchor:Vector2, degrees:FastFloat, scale:Vector2): FastMatrix3 {
        return FastMatrix3.transformationRaw(position.x, position.y, anchor.x, anchor.y, degrees, scale.x, scale.y);
    }

    // @:extern public static inline function multmatSIMD(mm:FastMatrix3, m:FastMatrix3): FastMatrix3 {
    //     //Seems like it's not worth half assing it, and the performance change is questionable at best.
    //     //I guess my bottlenecks are elsewhere
    //     var base1 = Float32x4.loadFast(mm._00, mm._10, mm._20, 0);
    //     var base2 = Float32x4.loadFast(mm._01, mm._11, mm._21, 0);
    //     var base3 = Float32x4.loadFast(mm._02, mm._12, mm._22, 0);

    //     var targ1 = Float32x4.loadFast(m._00, m._01, m._02, 0);
    //     var targ2 = Float32x4.loadFast(m._10, m._11, m._12, 0);
    //     var targ3 = Float32x4.loadFast(m._20, m._21, m._22, 0);

    //     var slot1 = Float32x4.mul(base1, targ1);
    //     var slot2 = Float32x4.mul(base1, targ2);
    //     var slot3 = Float32x4.mul(base1, targ3);
    //     var slot4 = Float32x4.mul(base2, targ1);
    //     var slot5 = Float32x4.mul(base2, targ2);
    //     var slot6 = Float32x4.mul(base2, targ3);
    //     var slot7 = Float32x4.mul(base3, targ1);
    //     var slot8 = Float32x4.mul(base3, targ2);
    //     var slot9 = Float32x4.mul(base3, targ3);

    //     var add1 = Float32x4.getFast(slot1, 0) + Float32x4.getFast(slot1, 1) + Float32x4.getFast(slot1, 2);
    //     var add2 = Float32x4.getFast(slot2, 0) + Float32x4.getFast(slot2, 1) + Float32x4.getFast(slot2, 2);
    //     var add3 = Float32x4.getFast(slot3, 0) + Float32x4.getFast(slot3, 1) + Float32x4.getFast(slot3, 2);
    //     var add4 = Float32x4.getFast(slot4, 0) + Float32x4.getFast(slot4, 1) + Float32x4.getFast(slot4, 2);
    //     var add5 = Float32x4.getFast(slot5, 0) + Float32x4.getFast(slot5, 1) + Float32x4.getFast(slot5, 2);
    //     var add6 = Float32x4.getFast(slot6, 0) + Float32x4.getFast(slot6, 1) + Float32x4.getFast(slot6, 2);
    //     var add7 = Float32x4.getFast(slot7, 0) + Float32x4.getFast(slot7, 1) + Float32x4.getFast(slot7, 2);
    //     var add8 = Float32x4.getFast(slot8, 0) + Float32x4.getFast(slot8, 1) + Float32x4.getFast(slot8, 2);
    //     var add9 = Float32x4.getFast(slot9, 0) + Float32x4.getFast(slot9, 1) + Float32x4.getFast(slot9, 2);

    //     return new FastMatrix3(add1, add2, add3, add4, add5, add6, add7, add8, add9);
    //}

    //     //ARRAYS + SIMD + STATIC EXTENSION ==== REST IN PEACE
    //     //IT ALL BREAKS
            //NO CONVENIENCE ALLOWED
    // //     var bases:Array<Float32x4> = [];
    // //     bases.push(Float32x4.loadFast(mm._00, mm._10, mm._20, 1));
    // //     bases.push(Float32x4.loadFast(mm._01, mm._11, mm._21, 1));
    // //     bases.push(Float32x4.loadFast(mm._02, mm._12, mm._22, 1));

    // //     var targets = [];
    // //     targets.push(Float32x4.loadFast(m._00, m._01, m._02, 1));
    // //     targets.push(Float32x4.loadFast(m._10, m._11, m._12, 1));
    // //     targets.push(Float32x4.loadFast(m._20, m._21, m._22, 1));

    // //     var mults:Array<Float32x4> = [];
    // //     var count = 0;
    // //     for (i in 0...bases.length) {
    // //         for (j in 0...targets.length) {
    // //             mults.push(Float32x4.mul(bases[i], targets[j]));
    // //             count++;
    // //         }
    // //     }

    // //     var adds:Array<Float> = [0, 0, 0, 1, 1, 1, 1, 1, 1];
    // //     for (i in 0...mults.length) {
    // //         adds.push((Float32x4.getFast(mults[i], 0) + Float32x4.get(mults[i], 1) + Float32x4.get(mults[i], 2)));
    // //     }

    // //     return new FastMatrix3(adds[0], adds[1], adds[2],
    // //                             adds[3], adds[4], adds[5],
    // //                             adds[6], adds[7], adds[8]);
    // }
}