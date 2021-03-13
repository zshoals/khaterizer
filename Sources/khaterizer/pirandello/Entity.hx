package khaterizer.pirandello;

import khaterizer.pirandello.data.ComponentStore;
import haxe.ds.Option;

class Entity {
	//Not really robust
	public static var currentId: Int = 0;

	public var id(default, null): Int;
	public var tags(default, null): Array<Tag>;
	public var components(default, null): ComponentStore;
	public var localSystems: Map<Class<LocalSystem>, LocalSystem>;

	public function new() {
		this.id = currentId;
		currentId++;

		this.tags = new Array<Tag>();
		this.components = new ComponentStore();
		this.localSystems = new Map<Class<LocalSystem>, LocalSystem>();
	}
}