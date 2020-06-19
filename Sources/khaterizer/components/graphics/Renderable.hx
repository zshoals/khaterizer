package khaterizer.components.graphics;

import js.html.webgl.Shader;
import ecx.AutoComp;
import khaterizer.graphics.ShaderManager;
import khaterizer.graphics.Shader;
import kha.graphics4.PipelineState;
import kha.Color;

class Renderable extends AutoComp<RenderData> {}

class RenderData {
    //Should have shader info, basic shader is always necessary
    var colors:Array<Color>;
    var shader:Shader;

    public function new() {}

    public function setup(colors:Color, shader:Shader):Void {
        this.colors.push(colors);
        this.shader = shader;
    }

}