package khaterizer.math;

import kha.FastFloat;
import khaterizer.math.FastMatrix3;
using khaterizer.math.FastMatrix3Ext; //Have to use yourself. That's just strange mate.

class FastMatrix3Ext {
    public static inline function rotationAround(clazz:Class<FastMatrix3>, x:FastFloat, y:FastFloat, alpha:FastFloat): FastMatrix3 {
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
    public static inline function transformationRaw(clazz:Class<FastMatrix3>, 
        x:FastFloat, y:FastFloat, 
        anchorX:FastFloat, anchorY:FastFloat, 
        alpha:FastFloat, 
        scaleX:FastFloat, scaleY:FastFloat): FastMatrix3 {

        //Try and skip some of the more expensive operations if they're not needed
        if (alpha == 0) {
            return FastMatrix3.translation(x - anchorX, y - anchorY).multmat(FastMatrix3.scale(scaleX, scaleY));
        }
        else if (anchorX == 0 && anchorY == 0) {
            return FastMatrix3.translation(x, y).multmat(FastMatrix3.rotation(alpha).multmat(FastMatrix3.scale(scaleX, scaleY)));
        }
        else {
            return FastMatrix3.translation(x - anchorX, y - anchorY).multmat(FastMatrix3.rotationAround(anchorX, anchorY, alpha).multmat(FastMatrix3.scale(scaleX, scaleY)));
        }
    }

        /**
        A complete transformation matrix for 2D objects. Intended to be regenerated each frame.

        Uses vectors instead of raw values. See FastMatrix3Ext.transformationRaw for parameter details.
    **/
    public static inline function transformation(clazz:Class<FastMatrix3>, position:Vector2, anchor:Vector2, alpha:FastFloat, scale:Vector2): FastMatrix3 {
        return FastMatrix3.transformationRaw(position.x, position.y, anchor.x, anchor.y, alpha, scale.x, scale.y);
    }
}