package khaterizer.pirandello.data;

abstract ComponentStore(Map<Class<Component>, Components>) {
	public inline function new() {
		this = new Map<Class<Component>, Components>();
	}


	//We currently have no error checking
	//We could actually have a mismatched componentType and component if the user is an idiot like me
	//How fix?
	public inline function addComponent(componentType: Class<Component>, component: Component): Component {
		if (!this.exists(componentType)) {
			this.set(componentType, new Components());
		}

		this.get(componentType).push(component);
		
		return component;
	}

	public inline function addMultipleComponentsOfType(componentType: Class<Component>, components: Array<Component>): Array<Component> {
		for (c in components) {
			addComponent(componentType, c);
		}

		return components;
	}

	public inline function removeComponentByName(componentType: Class<Component>, componentName: String): Void {
		if (this.exists(componentType)) {
			this.get(componentType).removeByName(componentName);
		}
	}

	public inline function removeComponentByIndex(componentType: Class<Component>, idx: Int): Void {
		if (this.exists(componentType)) {
			this.get(componentType).removeByIndex(idx);
		}
	}

	public inline function removeAllComponentsOfType(componentType: Class<Component>): Void {
		var arr: Components;
		if (this.exists(componentType)) {
			arr = this.get(componentType);
			for (i in 0...arr.length) {
				arr.pop();
			}
		}
	}
}