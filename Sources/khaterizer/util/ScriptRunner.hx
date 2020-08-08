package khaterizer.util;

import hscript.Interp;
import hscript.Parser;
import hscript.Expr;
import haxe.io.Bytes;

class ScriptRunner {
    private static var parser:Parser = new Parser();
    private var script:String;
    private var program:Expr;
    private var interp:Interp;

    public function new() {
        interp = new Interp();
    }

    public function run():Dynamic {
        if (program == null) {
            throw "Tried to run an unloaded script";
        }
        return interp.execute(program);
    }

    public function load(script:kha.Blob):Void {
        this.script = script.readUtf8String();
        program = parse(this.script);
    }

    public function share(name:String, clazz:Dynamic):Void {
        interp.variables.set(name, clazz);
    }

    private static function parse(script:String):Expr {
        return parser.parseString(script);
    }
    
}