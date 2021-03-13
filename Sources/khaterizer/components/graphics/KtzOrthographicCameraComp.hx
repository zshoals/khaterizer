package khaterizer.components.graphics;

import js.html.AbortController;
import haxe.ds.Option;
import khaterizer.math.KtzVec2;
import khaterizer.math.KtzVec2T;
import khaterizer.utils.KtzRegion2D;
import khaterizer.math.KtzFastMat3;
import khaterizer.math.KtzDegrees;
import khaterizer.math.KtzNormalizedRange;
import kha.Image;

final class KtzOrthographicCameraComp /*implements IComponent*/ {
	public var position: KtzVec2;
	public var rotation: KtzDegrees;
	public var zoomFactor: Float;
	
	/**
		The region of the primary Window between 0 and 1 on the X and Y axes that this camera draws its surface to.
	**/
	public var screenRegion: KtzRegion2D<KtzNormalizedRange>;
	
	private var projectionMatrix: KtzFastMat3;
	//private var viewMatrix: KtzFastMat3; Maybe unneeded and should just be recalculated each frame

	//Maybe this should be accessible from elsewhere? Maybe it's not even needed and we can segment things without rendertargets
	private var drawSurface: Option<Image>;

	public function new(position: KtzVec2, rotation: KtzDegrees, zoomFactor: Float, drawSurface: Option<Image>, ?screenRegion: KtzRegion2D<KtzNormalizedRange>) {
		this.position = position;
		this.rotation = rotation;
		this.zoomFactor = zoomFactor;
		this.drawSurface = drawSurface;

		if (screenRegion == null) {
			var min = new KtzNormalizedRange(0);
			var max = new KtzNormalizedRange(1);
			this.screenRegion = new KtzRegion2D<KtzNormalizedRange>(new KtzVec2T(min, min), new KtzVec2T(max, max));
		}
	}
}