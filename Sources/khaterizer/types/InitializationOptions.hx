package khaterizer.types;

typedef WindowMode = kha.WindowMode;

typedef InitializationOptions = {
    var title:String;

    var windowMode:WindowMode;
    var windowWidth:Int;
    var windowHeight:Int;
    var windowBorderless:Bool;

    var windowMinimizable:Bool;
    var windowMaximizable:Bool;
    var windowResizable:Bool;
    var windowOnTop:Bool;

    var refreshRate:Int; //Doesn't actually do anything, blame Robert :^)
    var verticalSync:Bool; //Only works on window initialization. Basically requires a restart

    var updateRate:Int;
    var entityCapacity:Int;
    
    var debugFontName:String;
}