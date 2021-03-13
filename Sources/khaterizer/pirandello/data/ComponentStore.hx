package khaterizer.pirandello.data;

import haxe.ds.Option;

abstract ComponentStore(Map<Class<Component>, Components>) {
	public inline function new() {
		this = new Map<Class<Component>, Components>();
	}


	