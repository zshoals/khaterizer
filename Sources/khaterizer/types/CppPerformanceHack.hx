package khaterizer.types;

import haxe.io.BytesBuffer;

//Sometimes corrects some ridiculous GC-related bug that occurs in ECX systems
//Put this in initialize or new (guess what, it changes randomly per compile!) to fix performance...
//Gross.
class CppPerformanceHack {
    public function new() {
        new BytesBuffer();
    }
}