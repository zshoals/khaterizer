package khaterizer.pirandello;

import khaterizer.pirandello.data.ComponentType;

final class World {
	public var componentPools: Map<ComponentType, ComponentPool<Component>>;
	public var entities: Array<Entity>;
	public var globalSystems: Array<GlobalSystem>;

	public function new() {}

	@:allow(khaterizer.pirandello.Entity)
	public function getComponentFromPool(type: ComponentType): Component {
		final source = componentPools.get(type);
		return source.get();
	}

	@:allow(khaterizer.pirandello.Entity)
	public function releaseComponentFromEntity(component: Component): Void {
		final source = componentPools.get(component);
		source.put(component);
	}
}