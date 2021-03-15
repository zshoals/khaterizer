package khaterizer.pirandello.data;

/**
	Workaround for not being able to use classes as map keys on HTML5

	Stolen from exp-ecs
**/
abstract SystemType(String) {
	inline function new(v:String)
		this = v;
	
	@:from
	public static inline function ofClass(v:Class<System>):SystemType
		return new SystemType(Type.getClassName(v));
		
	@:from
	public static inline function ofInstance(v:System):SystemType
		return ofClass(Type.getClass(v));
		
	@:to
	public inline function toClass():Class<System>
		return cast Type.resolveClass(this);
		
	@:to
	public inline function toString():String
		return this;
}