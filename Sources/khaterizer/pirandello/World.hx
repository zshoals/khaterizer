package khaterizer.pirandello;

import khaterizer.pirandello.data.ComponentType;
import khaterizer.pirandello.data.SystemType;
import haxe.ds.Vector;

final class World {
	private var activeEntities: Vector<Bool>; //should be some set of bitflags
	public var activeEntityCount: Int;
	public var manager: EntityManager;

	private var components: Map<ComponentType, Vector<Component>>;
	private var systems: Map<SystemType, System>;

	// public function new(configuration: WorldConfiguration) {
	// 	for 
	// }

	@:generic
	private inline function resolveComponent<T: ComponentType>(type: T, comps: Vector<Component>): Vector<T> {
		return (cast comps: Vector<T>);
	}

	@:generic
	private inline function resolveSystem<T: SystemType>(type: T, system: System): T {
		return (cast system: T);
	}

}

final class WorldConfiguration {
	public var componentsToRegister: Array<Class<Component>>;
	public var systemsToRegister: Array<Class<System>>;
	public var entityMaximumCapacity: Int;
	public var sameComponentStorageSize: Int;

	public function new(?entityMaximumCapacity: Int = 10000, ?sameComponentStorageSize = 1) {
		this.componentsToRegister = new Array<Class<Component>>();
		this.systemsToRegister = new Array<Class<System>>();
		this.entityMaximumCapacity = entityMaximumCapacity;
		this.sameComponentStorageSize = sameComponentStorageSize;
		assert(sameComponentStorageSize > 0, "Must have storage for at least one component, otherwise what's the point?");
	}

	public function registerComponentTypes(types: Array<Class<Component>>): Void {
		for (type in types) {
			this.componentsToRegister.push(type);
		}
	}

	public function registerSystemTypes(types: Array<Class<System>>): Void {
		for (type in types) {
			this.systemsToRegister.push(type);
		}
	}
}