package khaterizer.pirandello;

import haxe.ds.Option;

class Component {
	public var name: Option<String>;

	public function new(?name: String) {
		if (name != null) {
			this.name = Some(name);
		}
		else {
			this.name = None;
		}
	}
}