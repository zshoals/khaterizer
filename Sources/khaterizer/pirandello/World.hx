package khaterizer.pirandello;

import haxe.ds.ArraySort;
import js.lib.webassembly.Table;
import khaterizer.pirandello.data.ComponentType;
import khaterizer.pirandello.data.SystemType;
import haxe.ds.Vector;

final class World {
	private var activeEntities: Vector<Bool>; //should be some set of bitflags
	public var activeEntityCount: Int;
	public var maxEntities: Int;
	public var manager: EntityManager;

	private var components: Map<ComponentType, Vector<Component>>;
	private var systems: Map<SystemType, System>;
	private var systemProcessingOrder: Array<System>;

	public function new(configuration: WorldConfiguration) {
		this.maxEntities = configuration.entityMaximumCapacity;
		this.activeEntityCount = 0;
		this.activeEntities = new Vector<Bool>(this.maxEntities);
		for (ent in this.activeEntities) {
			ent = false;
		}
		//======================
		//Component Initialization
		//======================
		this.components = new Map<ComponentType, Vector<Component>>();
		for (componentType in configuration.componentsToRegister) {
			//Careful. This is where we preallocate all of our components.
			//This gets memory intensive fast, requiring either low entity counts or sparse components.
			//We need to find a way to not just do it the stupid way.
			var backingStorage = createStorage(componentType, maxEntities);
			for (i in 0...backingStorage.length) {
				backingStorage[i] = Type.createEmptyInstance(componentType);
				backingStorage[i].initialize();
			}
			this.components.set(componentType, backingStorage);
		}
		//======================
		//System Initialization
		//======================
		this.systems = new Map<SystemType, System>();
		var phases = configuration.systemsToRegister;
		for (phase in phases) {
			var systems = phase.systems;
			for (i in 0...systems.length) {
				this.systems.set(systems[i], Type.createEmptyInstance(systems[i]));
				//systems[i].initialize();
			}
		}
		//======================
		//System Processing Order Setup
		//======================
		this.systemProcessingOrder = new Array<System>();
		ArraySort.sort(phases, (a, b) -> {
			a.priority - b.priority;
		});
		for (phase in phases) {
			for (system in phase.systems) {
				this.systemProcessingOrder.push(this.systems.get(system)); //ugh.
			}
		}
	}

	public function retrieveStorage<T: Class<Component>>(type: T): Vector<T> {
		if (components.exists(type)) {
			return cast components.get(type);
		}
		else {
			throw 'Tried to access a non-existent component backing storage "$type". Verify this component type was added to the world configuration.';
			return null;
		}
	}

	public function retrieveSystem<T: Class<System>>(type: T): T {
		if (systems.exists(type)) {
			return cast systems.get(type);
		}
		else {
			throw 'Tried to access a non-existent system "$type". Verify this system type was added to the world configuration.';
			return null;
		}
	}

	@:generic
	private inline function createStorage<T>(type: Class<T>, len: Int): Vector<T> {
		return new Vector<T>(len);
	}

	// @:generic
	// private inline function resolveStorage<T: ComponentType>(type: Class<T>, comps: Vector<Component>): Vector<T> {
	// 	return (cast comps: Vector<T>);
	// }

	// @:generic
	// private inline function resolveSystem<T: SystemType>(type: T, system: System): T {
	// 	return (cast system: T);
	// }

}

final class WorldConfiguration {
	public var componentsToRegister: Array<ComponentType>;
	public var systemsToRegister: Array<Phase>;
	public var entityMaximumCapacity: Int;
	public var sameComponentStorageSize: Int;

	public function new(?entityMaximumCapacity: Int = 1000, ?sameComponentStorageSize = 1) {
		this.componentsToRegister = new Array<ComponentType>();
		this.systemsToRegister = new Array<Phase>();
		this.entityMaximumCapacity = entityMaximumCapacity;
		this.sameComponentStorageSize = sameComponentStorageSize;
		assert(sameComponentStorageSize > 0, "Must have storage for at least one component, otherwise what's the point?");
	}

	public function registerComponentTypes(types: Array<Class<Component>>): Void {
		for (type in types) {
			this.componentsToRegister.push(type);
		}
	}

	// public function registerSystemTypes(types: Array<Class<System>>): Void {
	// 	for (type in types) {
	// 		this.systemsToRegister.push(type);
	// 	}
	// }

	public function registerPhasedSystems(types: Phase): Void {
		this.systemsToRegister.push(types);
	}
}