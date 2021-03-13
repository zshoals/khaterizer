package khaterizer.pirandello.data;

import haxe.ds.Option;

@:forward(push, pop, length, remove)
abstract Components(Array<Component>) {
	public inline function new() {
		this = new Array<Component>();
	}

	public inline function getByName(name: String): Option<Component> {
		for (c in this) {
			switch (c.name) {
				case Some(identifier):
					if (identifier == name) {
						return Some(c);
					}
				case None:
					//Do nothing
			}
		}

		return None;
	}

	public inline function getByIndex(idx: Int): Option<Component> {
		if (idx != null) {
			return Some(this[idx]);
		}
		else {
			return None;
		}
	}

	public inline function removeByIndex(idx: Int): Void {
		this.remove(this[idx]);
	}

	/**
		Removes the first instance of a component with *name*
	**/
	public inline function removeByName(name: String): Void {
		for (c in this) {
			switch (c.name) {
				case Some(identifier):
					if (identifier == name) {
						//Careful
						//We're already getting weird if we want to pool components...
						this.remove(c);
						return;
					}
				case None:
					//Do nothing
			}
		}
	}
}