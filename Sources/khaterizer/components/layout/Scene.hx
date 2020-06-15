package khaterizer.components.layout;

import ecx.AutoComp;
import khaterizer.components.layout.Layer;

class Scene extends AutoComp<SceneData>{}

class SceneData {
    var layers:Array<Layer>;
    var nonLayeredEntities:Array<Entity>;

    public function new(){}

    public function setup(layers:Array<Layer>, entities:Array<Entity>) {
        this.layers = layers;
        this.nonLayeredEntities = entities;
    }
}