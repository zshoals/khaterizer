package khaterizer.pirandello;

class Phase {
	public var systems: Array<Class<System>>;
	public var priority: Int;

	public function new(priority: Int, systems: Array<Class<System>>) {
		this.systems = systems;
		this.priority = priority;
	}
}