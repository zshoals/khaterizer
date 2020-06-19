package khaterizer.components.layout;

import ecx.AutoComp;
import khaterizer.components.layout.Layer;

class Scene extends AutoComp<SceneData>{}

class SceneData {
    var layers:Array<Layer>;
    public function new(){}

    public function setup(layers:Array<Layer>) {
        this.layers = layers;
    }
}