package;

import tests.TestRandom;
import utest.Runner;
import utest.ui.Report;

class TestAll {
    public static function main() {
        var runner = new Runner();

        runner.addCases(tests);
        Report.create(runner);
        runner.run();
        //utest.UTest.run([new TestRandom()]);
    }
}