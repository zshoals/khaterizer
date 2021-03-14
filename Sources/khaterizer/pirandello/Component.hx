package khaterizer.pirandello;

import khaterizer.pirandello.data.ComponentType;
import haxe.ds.Option;


/**
	The base component class that all other components are derived from.

	All components in Khaterizer are pooled.
**/
class Component {
	public var name: Option<String>;
	public var componentType(default, null): ComponentType;
	public var insidePool:Bool;

	public function new(?name: String) {
		if (name != null) {
			this.name = Some(name);
		}
		else {
			this.name = None;
		}

		//Weird, but works.
		this.componentType = this;
		this.insidePool = true;
	}
}