package tests;

import utest.Assert;
import khaterizer.math.KtzDegrees;
import khaterizer.math.KtzVec2;

class TestDegrees extends utest.Test {
	public function testVecMake() {
		var angle = new KtzDegrees(180);
		var vecout = angle.makeUnitKtzVec2();

		Assert.floatEquals(-1, vecout.x);
		Assert.floatEquals(0, vecout.y);
	}

	public function testAngleFromVec() {
		var vec = new KtzVec2(0, 1);

		Assert.floatEquals(90, KtzDegrees.angleFromKtzVec2(vec));
	}
}