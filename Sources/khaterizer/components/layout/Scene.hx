package khaterizer.components.layout;

import ecx.AutoComp;
import khaterizer.components.layout.Layer;

class Scene extends AutoComp<SceneData>{}

typedef SceneHandle = String;

class SceneData {
    public var handle:SceneHandle;

    public function new(){}

    public function setup(handle:SceneHandle) {
        this.handle = handle;
    }
}