package khaterizer.utils;

import khaterizer.math.KtzVec2T;

@:generic
final class KtzRegion2D<T> {
	public var minBounds: KtzVec2T<T>;
	public var maxBounds: KtzVec2T<T>;

	public inline function new(minBounds: KtzVec2T<T>, maxBounds: KtzVec2T<T>) {
		this.minBounds = minBounds;
		this.maxBounds = maxBounds;
	}

	public inline function setFrom(minBounds: KtzVec2T<T>, maxBounds: KtzVec2T<T>): Void {
		this.minBounds.setFrom(minBounds);
		this.maxBounds.setFrom(maxBounds);
	}
}