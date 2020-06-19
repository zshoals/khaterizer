package khaterizer.components.layout;

import ecx.AutoComp;

enum abstract LayerID {
    var BACKGROUND_FAR = -3;
    var BACKGROUND_MEDIUM = -2;
    var BACKGROUND_CLOSE = -1;
    
    var GAMEPLAY = 0;

    var FOREGROUND_CLOSE = 1;
    var FOREGROUND_MEDIUM = 2;
    var FOREGROUND_FAR = 3;

    var USER_INTERFACE = 100;
}

class Layer extends AutoComp<LayerID>{}