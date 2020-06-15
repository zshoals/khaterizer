package khaterizer.core;

import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexShader;
import kha.graphics4.FragmentShader;

typedef ShaderHandle = String;

class ShaderManager {

    var _shaderManifest = new Map<ShaderHandle, PipelineState>(); 

    public function new() {
        //Build defaults
        buildShader("Image_Default", Shaders.painter_image_vert, Shaders.postprocess_frag);
        buildShader("Colorize_Default", Shaders.painter_colored_vert, Shaders.painter_colored_frag);
        buildShader("Text_Default", Shaders.painter_text_vert, Shaders.painter_text_frag);
        buildShader("Video_Default", Shaders.painter_video_vert, Shaders.painter_video_frag);
    }

    public function buildShader(name:ShaderHandle, vertexShader:VertexShader, fragmentShader:FragmentShader) {
        var pipeline = new PipelineState();
        var structure = new VertexStructure();
        structure.add("vertexPosition", VertexData.Float3);
        structure.add("texPosition", VertexData.Float2);
        structure.add("vertexColor", VertexData.Float4);
        pipeline.inputLayout = [structure];
        pipeline.vertexShader = vertexShader;
        pipeline.fragmentShader = fragmentShader; // put in your own shader here
        pipeline.compile();

        _shaderManifest.set(name, pipeline);
    }

    public function listAvailableShaders():Array<ShaderHandle> {
        var shaderList:Array<ShaderHandle> = [];
        for (handle => v in _shaderManifest) shaderList.push(handle);
        return shaderList;
    }

    public function get_pipeline(handle:ShaderHandle):PipelineState {
        return _shaderManifest.get(handle);
    }

}