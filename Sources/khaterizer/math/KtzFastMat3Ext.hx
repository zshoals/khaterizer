package khaterizer.math;

import kha.FastFloat;
import khaterizer.math.KtzFastMat3;
using khaterizer.math.KtzFastMat3Ext; //Have to use yourself. That's just strange mate.

class KtzFastMat3Ext {
	@:extern public static inline function rotationAround(clazz:Class<KtzFastMat3>, x:FastFloat, y:FastFloat, alpha:FastFloat): KtzFastMat3 {
		return KtzFastMat3.translation(x, y).multmat(KtzFastMat3.rotation(alpha).multmat(KtzFastMat3.translation(-x, -y)));
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
	@:extern public static inline function transformationRaw(clazz:Class<KtzFastMat3>, 
		x:FastFloat, y:FastFloat, 
		anchorX:FastFloat, anchorY:FastFloat, 
		degrees:FastFloat, 
		scaleX:FastFloat, scaleY:FastFloat): KtzFastMat3 {

		return KtzFastMat3.translation(x - anchorX, y - anchorY)
			.multmat(KtzFastMat3.rotationAround(anchorX, anchorY, KtzMath.deg2rad(degrees))
			.multmat(KtzFastMat3.scale(scaleX, scaleY)));
	}

	/**
		A complete transformation matrix for 2D objects. Intended to be regenerated each frame.

		Uses vectors instead of raw values. See FastMatrix3Ext.transformationRaw for parameter details.
	**/
	@:extern public static inline function transformation(clazz:Class<KtzFastMat3>, position:KtzVec2, anchor:KtzVec2, degrees:FastFloat, scale:KtzVec2): KtzFastMat3 {
		return KtzFastMat3.transformationRaw(position.x, position.y, anchor.x, anchor.y, degrees, scale.x, scale.y);
	}
}