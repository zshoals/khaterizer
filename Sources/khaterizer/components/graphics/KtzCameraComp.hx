package khaterizer.components.graphics;

import khaterizer.math.KtzVec2;
import khaterizer.math.KtzVec2T;
import khaterizer.utils.KtzRegion2D;
import khaterizer.math.KtzFastMat3;
import khaterizer.math.KtzDegrees;
import khaterizer.math.KtzNormalizedRange;
import kha.Image;

final class KtzCameraComp /*implements IComponent*/ {
	public var position: KtzVec2;
	public var rotation: KtzDegrees;
	public var zoomFactor: Float;
	
	/**
		The region of the primary Window between 0 and 1 on the X and Y axes that this camera draws its surface to.
	**/
	public var screenRegion: KtzRegion2D<KtzNormalizedRange>;
	
	private var projectionMatrix: KtzFastMat3;
	private var viewMatrix: KtzFastMat3;

	//Maybe this should be accessible from elsewhere? Maybe it's not even needed and we can segment things without rendertargets
	private var drawSurface: Image;

	public function new() {
	}
}