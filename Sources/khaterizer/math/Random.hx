package khaterizer.math;

/**
	A suite of tools for random number generation, random element selection, and so on.

	Random.init() MUST be fired. So add this as a startup configuration setting.
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

	public function AmassInts(min: Int, max: Int, amount: Int): Array<Int> {
		var ints: Array<Int> = [];
		for (i in 0...amount) {
			ints.push(this.GetIn(min, max));
		}

		return ints;
	}

	public function AmassFloats(min: Float, max: Float, amount: Int): Array<Float> {
		var floats: Array<Float> = [];
		for (i in 0...amount) {
			floats.push(this.GetFloatIn(min, max));
		}

		return floats;
	}

	//Fisher-Yates Shuffle Method
	/**
		Returns an array with randomized item order compared to the original. Non-destructive.
	**/
	@:generic
	public function Shuffle<T>(arr: Array<T>): Array<T> {
		var copy = arr.copy();
		if (copy.length < 2) return copy;

		var i = copy.length - 1;
		while (i > 0) {
			var k = this.GetIn(0, i);
			var temp = copy[i];
			copy[i] = copy[k];
			copy[k] = temp;

			i--;
		}

		return copy;
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

	/**
		TODO: IMPLEMENT ME
	**/
	@:generic
	public function WeightedSelection<T>(weights: Map<T, Float>): Array<T> { return []; }

	//====================
	//==Static Interface==
	//====================
	private static var instance: Random;
	private static var initialized: Bool = false;

	public static function init(seed: Int) {
		if (initialized) return;
		instance = new Random(seed);
		initialized = true;
	}

	public static function get(): Int {
		return instance.Get();
	}

	public static function getIn(min: Int, max: Int): Int {
		return instance.GetIn(min, max);
	}

	public static function getFloat(): Float {
		return instance.GetFloat();
	}
	
	public static function getFloatIn(min: Float, max: Float): Float {
		return instance.GetFloatIn(min, max);
	}

	public static function getUpTo(max: Int): Int {
		return instance.GetUpTo(max);
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

	public static function amassInts(min: Int, max: Int, amount: Int): Array<Int> {
		return instance.AmassInts(min, max, amount);
	}

	public static function amassFloats(min: Float, max: Float, amount: Int): Array<Float> {
		return instance.AmassFloats(min, max, amount);
	}

	@:generic
	public static function shuffle<T>(arr: Array<T>): Array<T> {
		return instance.Shuffle(arr);
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

	@:generic
	public static function weightedSelection<T>(weights: Map<T, Float>): Array<T> {
		return instance.WeightedSelection(weights);
	}
}