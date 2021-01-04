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
        if (bias < 0) bias = 0;
        if (bias > 1) bias = 1;
        return this.GetFloat() < bias;
    }

    public function RandomSign(): Int {
        return this.Coinflip() ? 1 : -1;
    }

    /**
        Returns an array containing one randomly selected item out of `arr`.

        Returns a length zero array if `arr` is empty.
    **/
    @:generic
    public function Select<T>(arr: Array<T>): Array<T> {
        return this.Selection(arr, 1);
    }

    /**
        Returns an array consisting of `amount` items, randomly selected from `arr`.

        Returns `arr` if `amount` is greater than `arr`'s length, or an empty array if `amount` is 0 or less.

        This CANNOT select any single instance of an item more than once.
    **/
    @:generic
    public function Selection<T>(arr: Array<T>, amount: Int): Array<T> {
        var selection: Array<T> = [];
        if (amount <= 0) return selection;
        if (amount >= arr.length) return arr;

        var temp: Array<T> = arr.copy();
        for (i in 0...amount) {
            var target = this.GetIn(0, (temp.length - 1));
            selection.push(temp[target]);
            temp.splice(target, 1);
        }

        return selection;
    }

    /**
        Returns an array consisting of `amount` items, randomly selected from `arr`.

        Returns `arr` if `amount` is greater than `arr`'s length, or an empty array if `amount` is 0 or less.

        This CAN select a singular instance of an item more than once.
    **/
    @:generic
    public function RepeatableSelection<T>(arr: Array<T>, amount: Int): Array<T> {
        var selection: Array<T> = [];
        if (amount <= 0) return selection;

        for (i in 0...amount) {
            var target = this.GetIn(0, (arr.length - 1));
            selection.push(arr[target]);
        }

        return selection;
    }

    @:generic
    public function WeightedSelection<T>(weights: Map<T, Float>): Array<T> { return []; }

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

    public static function randomSign(): Int {
        return instance.RandomSign();
    }

    @:generic
    public static function select<T>(arr: Array<T>): Array<T> {
        return instance.Select(arr);
    }

    @:generic
    public static function selection<T>(arr: Array<T>, amount: Int): Array<T> {
        return instance.Selection(arr, amount);
    }

    @:generic
    public static function repeatableSelection<T>(arr: Array<T>, amount: Int): Array<T> {
        return instance.RepeatableSelection(arr, amount);
    }
}