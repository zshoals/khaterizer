package khaterizer.pirandello;

import haxe.ds.Option;

class Component {
	public var name: Option<String>;
	public var componentType(default, null): Class<Component>;

	public function new(?name: String) {
		if (name != null) {
			this.name = Some(name);
		}
		else {
			this.name = None;
		}

		this.componentType = Type.getClass(this);
	}
}