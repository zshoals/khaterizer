package khaterizer.ecs.components.layout;

abstract SceneHandle(String) {
    public inline function new(s:String) {
        this = s;
    }
}

class SceneData {
    public var handle:SceneHandle;

    public function new(){}

    public function setup(handle:SceneHandle) {
        this.handle = handle;
    }
}