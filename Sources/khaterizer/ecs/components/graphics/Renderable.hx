package khaterizer.ecs.components.graphics;

import khaterizer.math.Vector2;
import khaterizer.math.FastMatrix3;
using khaterizer.math.FastMatrix3Ext;
import ecx.AutoComp;
import khaterizer.graphics.ShaderManager;
import khaterizer.graphics.Shader;
import kha.graphics4.PipelineState;
import kha.Color;

class Renderable extends AutoComp<RenderData> {}

class RenderData {
    public var transformation:FastMatrix3;
    //Should have shader info, basic shader is always necessary
    public var colors:Array<Color>;
    //public var shader:Shader;

    public function new() {}

    public function setup(colors:Color):Void {
        this.colors.push(colors);
        //this.shader = shader;
    }

    public function buildTransform(position:Vector2, anchor:Vector2, rotation:Float, scale:Vector2): Void {
        this.transformation = FastMatrix3.transformation(position, anchor, rotation, scale);
    }

}