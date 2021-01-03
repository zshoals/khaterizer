package khaterizer.math;

/**
    A suite of tools for random number generation, random element selection, and so on.
**/
class Random extends kha.math.Random {
    public function new(seed: Int) {
        super(seed);
    }

    public function Coinflip(): Bool {
        return this.GetFloat() < 0.5;
    }

    /**
        A bias of 0 inclusive to 1 exclusive towards (or against) true.
    **/
    public function BiasedCoinflip(bias: Float): Bool {
        return this.GetFloat() < bias;
    }

    @:generic
    public function Select<T>(arr: Array<T>): T {
        var randNum = this.GetIn(0, (arr.length - 1));
        return arr[randNum];
    }

    @:generic
    public function Selection<T>(arr: Array<T>, amount: Int): Array<T> {
        if (amount > arr.length) throw "Tried to select an amount of values larger than the array size.";

        var selection:Array<T> = [];
        var temp:Array<T> = arr.copy();
        for (i in 0...amount) {
            var target = this.GetIn(0, (temp.length - 1));
            selection.push(temp[target]);
            temp.splice(target, 1);
        }

        return selection;
    }

    //===================
    //==Global Instance==
    //===================
    private static var instance:Random;

    public static function init(seed: Int) {
        instance = new Random(seed);
    }

    public static function coinflip(): Bool {
        return instance.Coinflip();
    }

    public static function biasedCoinflip(bias: Float): Bool {
        return instance.BiasedCoinflip(bias);
    }

    @:generic
    public static function select<T>(arr: Array<T>): T {
        return instance.Select(arr);
    }

    @:generic
    public static function selection<T>(arr: Array<T>, amount: Int): Array<T> {
        return instance.Selection(arr, amount);
    }
}