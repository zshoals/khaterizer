package khaterizer.types;

import kha.WindowMode;

typedef InitializationOptions = {
    var title:String;

    var windowMode:WindowMode;
    var windowWidth:Int;
    var windowHeight:Int;
    var windowBorderless:Bool;

    var refreshRate:Int; //Doesn't actually do anything, blame Robert :^)
    var verticalSync:Bool;

    var updateRate:Int;
    var entityCapacity:Int;
    
    var debugFontName:String;
}