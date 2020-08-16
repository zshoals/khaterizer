package khaterizer.ecs.systems;

import khaterizer.types.CppPerformanceHack;
import kha.Assets;
import ecx.System;
import khaterizer.util.ScriptRunner;
import khaterizer.ecs.blueprints.Spammer;

class ScriptTestSystem extends System {
    private var runner:ScriptRunner;
    private var loaded:Bool;
    private var spam:Wire<Spammer>;
    
    public function new() {
        
    }

    override function initialize() {
        loaded = false;
        //Remember that script assets have to be loaded from a path, otherwise we cannot change them at runtime
        //Most asset stuff that Kha does is handled at compile time
        Assets.loadBlobFromPath("tester2.hscript", (blob) -> 
            {
                loaded = true;
                runner = new ScriptRunner();
                runner.load(blob);
                runner.share("Math", Math);
                runner.share("spam", spam);
            },
            (rip) -> throw rip
        );
    }

    override function update() {
        if (loaded) {
            trace(runner.run());
        }
    }
}