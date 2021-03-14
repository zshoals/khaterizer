package khaterizer.pirandello.data;

/**
	All Component Types are guaranteed to set an array of their corresponding component.
**/
abstract ComponentStore(Map<ComponentType, Components>) {
	public inline function new(activeComponents: Array<ComponentType>) {
		this = new Map<ComponentType, Components>();

		for (type in activeComponents) {
			this.set(type, new Components());
		}
	}

	public inline function retrieveComponents(type: ComponentType): Components {
		if (this.exists(type)) {
			return this.get(type);
		}
		else {
			throw "Tried to access a non-existent component type. Make sure that it is added before World Initialization.";
		}
	}
}