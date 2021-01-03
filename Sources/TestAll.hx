package;

import tests.TestRandom;
import utest.Runner;
import utest.ui.Report;

@:keep
class TestAll {
    public static function main() {
        var runner = new Runner();

        runner.addCase(new TestRandom());
        Report.create(runner);
        runner.run();
        //utest.UTest.run([new TestRandom()]);
    }
}