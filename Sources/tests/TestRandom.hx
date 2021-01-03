package tests;

import utest.Assert;
import khaterizer.math.Random;

@:keep
class TestRandom extends utest.Test {
    var random:Random;

    public function setup() {
        random = new Random(0x12088312);
    }

    public function testSelection() {
        var items = ["str1", "str2", "str3"];
        var result = random.Selection(items, 2);

        
        Assert.equals(["str3", "str2"], result);
    }
}