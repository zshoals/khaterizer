package khaterizer.types;

import haxe.io.BytesBuffer;

//Sometimes corrects some performance issue with ECX, accounting for roughly a 30% (!!!) speed increase.
//Put this in the new() constructor of anything deriving from Service.
//I think this ends up causing some performance issues itself at higher entity counts, but it's a major improvement for lower counts (50k or less);
class CppPerformanceHack {
    public function new() {
        new BytesBuffer();
    }
}