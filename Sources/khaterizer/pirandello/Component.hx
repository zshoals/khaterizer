package khaterizer.pirandello;

/**
	The base component class that all other components are derived from.

	All components in Khaterizer are pooled. As such, free() must be overridden to reset the component to a default state.
**/
class Component {
	public function initialize(): Void {
		throw "Initialize must be overridden by the extending component. Reset all values to a default state in your initialize function. Ideally, check for already allocated objects and reuse them.";
	}
}