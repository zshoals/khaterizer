package khaterizer.ecs.components.graphics;

import ecx.AutoComp;
import khaterizer.graphics.ShaderManager;
import khaterizer.graphics.Shader;
import kha.graphics4.PipelineState;
import kha.Color;

class Renderable extends AutoComp<RenderData> {}

class RenderData {
    //Should have shader info, basic shader is always necessary
    public var colors:Array<Color>;
    //public var shader:Shader;

    public function new() {}

    public function setup(colors:Color):Void {
        this.colors.push(colors);
        //this.shader = shader;
    }

}