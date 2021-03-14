package khaterizer.pirandello;

import khaterizer.pirandello.Component;

/**
	Lazy, up to the world to handle pooling for now

	Who would have thought making a generic Object Pool required macros or hacks?
**/
@:generic
class ComponentPool<T:Component> {
	private var pool: Array<T>;

	public function new() {}

	/**
		Manually set the pool array from somewhere else, most likely World.

		Preallocate the array in World itself.
	**/
	@:allow(khaterizer.pirandello.World)
	public function setBackingPool(arr: Array<T>): Void {
		this.pool = arr;
	}

	public function get(): T {
		var outbound = this.pool.pop();
		outbound.insidePool = false;
		return outbound;
	}

	public function put(component: T): Void {
		pool.push(component);
		component.insidePool = true;
	}
}