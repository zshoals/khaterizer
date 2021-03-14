package khaterizer.pirandello;

import khaterizer.pirandello.data.Components;
import khaterizer.pirandello.data.ComponentType;
import khaterizer.pirandello.data.ComponentStore;

class Entity {
	//Not really robust
	public static var currentId: Int = 0;

	public var id(default, null): Int;
	public var tags(default, null): Array<Tag>;
	public var components(default, null): ComponentStore;
	private var world: World;
	//public var localSystems: Map<Class<LocalSystem>, LocalSystem>;

	public function new(world: World,
		availableComponents: Array<ComponentType>,
		availableLocalSystems: Array<LocalSystem>,
		availableTags: Array<Tag>) {
		this.id = currentId;
		currentId++;

		this.tags = new Array<Tag>();
		this.components = new ComponentStore(availableComponents);
		this.world = world;
		//this.localSystems = new Map<Class<LocalSystem>, LocalSystem>();
	}

	//We already know we'll be using pools, so why not just have this class get the appropriate component for us?
	public function addComponent(type: ComponentType): Component {
		var componentToAdd = world.getComponentFromPool(type);
		components.retrieveComponents(type).push(componentToAdd);
		return componentToAdd;
	}

	public function getFirstComponentOfType(type: ComponentType): Component {
		return components.retrieveComponents(type).getByIndex(0);
	}

	public function getAllComponentsOfType(type: ComponentType): Components {
		return components.retrieveComponents(type);
	}
}