package khaterizer.types;

import kha.graphics4.PipelineState;
import kha.math.Vector2;

class RenderPackage {
    public var positions:Array<Vector2>;
    public var shaders:Array<Array<PipelineState>>;

    public function new() {
        positions = [];
        shaders = [];
    }

    public function addPosition(vec:Vector2):Void {
        positions.push(vec);
    }

    public function addPipelines(pipeline:Array<PipelineState>):Void {
        shaders.push(pipeline);
    }
}