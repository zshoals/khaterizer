package khaterizer.pirandello;

class Entity {
	//Not really robust
	public static var currentId: Int = 0;

	public var id(default, null): Int;
	public var tags(default, null): Array<Tag>;
	public var components(default, null): Map<Class<Component>, Array<Component>>;
	public var localSystems: Map<Class<LocalSystem>, LocalSystem>;

	public function new() {
		this.id = currentId;
		currentId++;

		this.tags = new Array<Tag>();
		this.components = new Map<Class<Component>, Array<Component>>();
		this.localSystems = new Map<Class<LocalSystem>, LocalSystem>();
	}

	public function addComponent(component: Component): Component {
		return component;
	}
}