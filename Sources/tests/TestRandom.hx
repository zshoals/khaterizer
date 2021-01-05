package tests;

import utest.Assert;
import khaterizer.math.Random;

class TestRandom extends utest.Test {
	var random:Random;
	var randVerify:Random;

	public function setup() {
		random = new Random(0x12088312);
		randVerify = new Random(0x12088312);
	}

	public function testAmassInts() {
		var amount = 50;
		var min = 0;
		var max = 100;
		var items = random.AmassInts(min, max, amount);

		Assert.isTrue(items.length == amount);
		for (i in 0...items.length) {
			var valid = ((min <= items[i]) && (items[i] <= max));
			Assert.isTrue(valid, "Index " + i + " had an out of range value of " + items[i]);
		}
	}

	public function testAmassFloats() {
		var amount = 50;
		var min = 1.3777745784965579565;
		var max = 10.3673647477547565;
		var items = random.AmassFloats(min, max, amount);

		Assert.isTrue(items.length == amount);
		for (i in 0...items.length) {
			var valid = ((min <= items[i]) && (items[i] <= max));
			Assert.isTrue(valid, "Index " + i + " had an out of range value of " + items[i]);
		}
	}

	public function testSelection() {
		var items = ["str1", "str2", "str3"];
		var result = random.Selection(items, 2);
		var compare = ["str3", "str2"];

		Assert.equals(compare[0], result[0]);
		Assert.equals(compare[1], result[1]);
	}

	public function testSelectionEmpty() {
		var items: Array<String> = [];
		var selection = random.Selection(items, 5);
		Assert.isTrue(selection.length == 0);
	}

	public function testSelectionShortOnItems() {
		var items: Array<String> = ["One", "Two", "Three", "Four"];
		var selection = random.Selection(items, 5);

		Assert.isTrue(selection.length == items.length);
	}

	public function testRepeatableSelection() {
		var items: Array<Int> = [1, 2, 3, 4, 5];
		var selection = random.RepeatableSelection(items, 20);

		Assert.isTrue(selection.length == 20, "Selection length is: " + selection.length);
		for (i in 0...selection.length) {
			Assert.notNull(selection[i], "Index " + i + " was null");
		}
		Assert.notContains(6, selection);
		Assert.notContains(0, selection);

		var counts: Map<Int, Int> = [
			1 => 0,
			2 => 0,
			3 => 0,
			4 => 0,
			5 => 0
		];

		for (i in 0...selection.length) {
			for (key in counts.keys()) {
				if (key == selection[i]) {
					counts.set(key, counts.get(key) + 1);
				}
			}
		}

		var correctVal = false;
		for (value in counts) {
			if (value >= 2) correctVal = true;
		}
		Assert.isTrue(correctVal);
	}

	public function testSelect() {
		var items = ["str1", "str2", "str3"];
		var result = random.Select(items);
		var compare = ["str3"];

		Assert.isTrue(result.length == 1);
		Assert.equals(compare[0], result[0]);
	}

	public function testSelectEmpty() {
		var items: Array<Int> = [];
		var result = random.Select(items);

		Assert.isTrue(result.length == 0);
	}

	public function testWeighted() {
		var weights: Array<Float> = [500, 300, 100];
		var idx = random.WeightedSelection(weights);

		Assert.equals(0, idx, "IDX was " + idx);
	}

	public function testWeightedInRange() {
		var weights: Array<Float> = [400, 400, 400];

		for (i in 0...100) {
			var idx = random.WeightedSelection(weights);
			Assert.isTrue((0 <= idx) && (idx <= 2), "Index out of range");
		}
	}

	public function testBiasCoinflip() {
		var out = random.BiasedCoinflip(0.2);
		Assert.equals(true, out, "Biased coinflip failed with a value of" + randVerify.GetFloat());
	}

	public function testShuffle() {
		var items = [1, 2, 3, 4, 5];
		var result = random.Shuffle(items);

		Assert.isTrue(result.length == 5);
		Assert.equals([2, 1, 3, 4, 5].toString(), result.toString(), "Got: " + result);
	}

	public function testShuffleShort() {
		var items = [1];
		var result = random.Shuffle(items);

		Assert.isTrue(result.length == 1);
		Assert.equals(items[0], result[0]);
	}
}