package khaterizer.types;

typedef InitOptions = {
    var title:String;
    var windowWidth:Int;
    var windowHeight:Int;
    var refreshRate:Int; //Doesn't actually do anything, blame Robert :^)
    var verticalSync:Bool;
    var updateRate:Int;
    var entityCapacity:Int;
}