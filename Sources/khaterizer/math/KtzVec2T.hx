package khaterizer.math;

@:generic
final class KtzVec2T<T> {
	public var item1: T;
	public var item2: T;

	public inline function new(item1: T, item2: T) {
		this.item1 = item1;
		this.item2 = item2;
	}

	public inline function setFrom(vec: KtzVec2T<T>): Void {
		this.item1 = vec.item1;
		this.item2 = vec.item2;
	}
}