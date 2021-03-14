package khaterizer.pirandello.data;

@:forward
abstract Components(Array<Component>) {
	public inline function new() {
		this = new Array<Component>();
	}

	public inline function getByIndex(idx: Int): Component {
		return this[idx];
	}
}