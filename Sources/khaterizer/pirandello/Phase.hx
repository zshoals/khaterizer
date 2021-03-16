package khaterizer.pirandello;

import khaterizer.pirandello.data.SystemType;

class Phase {
	public var systems: Array<SystemType>;
	public var priority: Int;

	public function new(priority: Int, systems: Array<SystemType>) {
		this.systems = systems;
		this.priority = priority;
	}
}