package khaterizer.ecs.components.layout;

// abstract SubSceneHandle(String) {
//     public inline function new(s:String) {
//         this = s;
//     }
// }

class SubSceneData {
    public var handle:String;
    
    public function new(){}
    
    public function setup(handle:String) {
        this.handle = handle;
    }
}