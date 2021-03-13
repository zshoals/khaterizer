package khaterizer.macro;

import haxe.macro.Expr;

class EnumExtractor {

	/**
		Taken from the haxe cookbook.
	**/
	public static macro function extract(value:ExprOf<EnumValue>, pattern:Expr):Expr {
		switch (pattern) {
		  case macro $a => $b:
			return macro switch ($value) {
			  case $a: $b;
			  default: throw "no match";
			}
		  default:
			throw new Error("Invalid enum value extraction pattern", pattern.pos);
		}
	  }
}

