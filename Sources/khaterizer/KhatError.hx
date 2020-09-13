package khaterizer;

class KhatError {
    public function new(message:Dynamic) {
        #if kha_html5
        throw new js.lib.Error(message);
        #else
        throw message;
        #end
    }
}