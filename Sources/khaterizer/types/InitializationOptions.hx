package khaterizer.types;

typedef InitializationOptions = {
    var title:String;
    var windowWidth:Int;
    var windowHeight:Int;

    var refreshRate:Int; //Doesn't actually do anything, blame Robert :^)
    var verticalSync:Bool;

    var updateRate:Int;
    var entityCapacity:Int;
    
    var debugFontName:String;
}