package khaterizer.components.layout;

abstract SubSceneHandle(String) {
    public inline function new(s:String) {
        this = s;
    }
}

class SubSceneData {
    public var handle:SubSceneHandle;
    
    public function new(){}
    
    public function setup(handle:SubSceneHandle) {
        this.handle = handle;
    }
}