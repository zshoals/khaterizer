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

	public function addComponent(component: Component): Component {
		components.addComponent(component.componentType, component);
		return component;
	}

	public function addMultipleComponentsOfSameType(components: Array<Component>): Array<Component> {
		//Validate that the components are all of the same type
		var types = new Array<Class<Dynamic>>();
		for (c in components) {
			types.push(c.componentType);
		}

		assert(types.length <= 1, "Tried to add multiple components of various types simultaneously. 
		Make sure that all components are of the same type while using this function.");

		for (c in components) {
			addComponent(c);
		}

		return components;
	}

	public function getComponentByTypeAndName(componentType: Class<Component>, name: String): Option<Component> {
		return components.getComponentByName(componentType, name);
	}

	public function getFirstComponent(componentType: Class<Component>): Option<Component> {
		return components.getComponentByIndex(componentType, 0);
	}

	public function getMultipleComponentsOfSameType(componentType: Class<Component>): Array<Component> {
		return components.getAllComponentsByType(componentType);
	}

	public function removeComponentInstance(component: Component): Void {
		components.removeComponentByInstance(component.componentType, component);
	}

	public function removeComponentByTypeAndName(componentType: Class<Component>, name: String): Void {
		components.removeComponentByName(componentType, name);
	}
}