package khaterizer.components.graphics;

import ecx.AutoComp;
import khaterizer.core.ShaderManager;
import kha.graphics4.PipelineState;
import kha.Color;

class Renderable extends AutoComp<RenderData> {}

class RenderData {
    //Should have shader info, basic shader is always necessary
    var colors:Array<Color>;

    public function new() {}

    public function setup(colors:Color):Void {
        this.colors.push(colors);
    }

}