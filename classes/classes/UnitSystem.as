package classes
{
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.internals.Utils;

	/**
	 * Automatically display values in the correct unit system; Imperial or International (SI).
	 * The UnitSystem follows a naming convention where the methods are named using the following keyword to describe their behaviour.
	 * - literal : Get a string of a unit giving a general sense of quantity, instead of a precise measurement.
	 * - display : Return a string of a measurement, i.e. value and unit.
	 * - Qualified : Include an adjective that qualifies the unit.
	 * - {*Xyz*}In{*Units*} : Specify the unit used for a type of measurement, e.g. *LengthInInches*, *LengthInFeet*, *WeightInPounds*.
	 * - Estimate : Return a value that gives a sense of estimation, a vague and general idea of the quantity to the mesure.
	 * - Range : A range of a measurement described by two values.
	 * - Short : Use the symbol of a unit instead of its full name, e.g. *in*, *lb* / *cm*, *g*
	 * - Short2 : Use the alternative symbol of an imperial unit, e.g. *"* instead of *in*.
	 * - WithHyphen : Display measurement as a compound adjective.
	 * - Textually : Display the number value of the measurement as a number word.
	 * @author Phillip Daisy Seventh
	 */
	public class UnitSystem
	{

		private static function formatFloat(value:Number, sig:int = 0):Number { return Utils.round(value, sig); }
		private static function num2Text(value:Number):String { return Utils.num2Text(value); }

		private static const INCH_TO_METER:Number = 0.0254;
		private static const FOOT_TO_METER:Number = 0.3048;
		private static const YARD_TO_METER:Number = 0.9144;

		private static const POUND_TO_GRAM:Number = 453.59237;

		private static const GALLON_TO_LITER:Number = 3.785411784;

		private static const INCHES_IN_A_FOOT:int = 12;

		private static const FOOT_TO_METER_APPROX:Number = formatFloat(FOOT_TO_METER, 1);
		private static const INCH_TO_METER_APPROX:Number = formatFloat(INCH_TO_METER, 3);

		private static const POUND_TO_GRAM_APPROX:Number = 500;

		private static const GALLON_TO_LITER_APPROX:Number = formatFloat(GALLON_TO_LITER, 0);

		private static const SI_PREFIX_TERA_POWER:int = 12;
		private static const SI_PREFIX_GIGA_POWER:int = 9;
		private static const SI_PREFIX_MEGA_POWER:int = 6;
		private static const SI_PREFIX_KILO_POWER:int = 3;
		private static const SI_PREFIX_HECTO_POWER:int = 2;
		private static const SI_PREFIX_DECA_POWER:int = 1;
		private static const SI_PREFIX_NONE_POWER:int = 0;
		private static const SI_PREFIX_DECI_POWER:int = -1;
		private static const SI_PREFIX_CENTI_POWER:int = -2;
		private static const SI_PREFIX_MILLI_POWER:int = -3;
		private static const SI_PREFIX_MICRO_POWER:int = -6;
		private static const SI_PREFIX_NANO_POWER:int = -9;
		private static const SI_PREFIX_PICO_POWER:int = -12;

		private static const SI_MAX_PREFIX_POWER:int = SI_PREFIX_TERA_POWER;
		private static const SI_MIN_PREFIX_POWER:int = SI_PREFIX_PICO_POWER;

		private static const SI_PREFIX_FACTOR:int = 1000;
		private static const SI_PREFIX_POWER_STEP:int = 3;

		private static const SI_PREFIX_CENTI_FACTOR:Number = Math.pow(10, SI_PREFIX_CENTI_POWER);

		private static const SI_POWER_TO_PREFIX:Object = {}
		SI_POWER_TO_PREFIX[SI_PREFIX_TERA_POWER.toString()] = { name: "tera", symbol: "T" };
		SI_POWER_TO_PREFIX[SI_PREFIX_GIGA_POWER.toString()] = { name: "giga", symbol: "G" };
		SI_POWER_TO_PREFIX[SI_PREFIX_MEGA_POWER.toString()] = { name: "mega", symbol: "M" };
		SI_POWER_TO_PREFIX[SI_PREFIX_KILO_POWER.toString()] = { name: "kilo", symbol: "k" };
		SI_POWER_TO_PREFIX[SI_PREFIX_HECTO_POWER.toString()] = { name: "hecto", symbol: "h" };
		SI_POWER_TO_PREFIX[SI_PREFIX_DECA_POWER.toString()] = { name: "deca", symbol: "da" };
		SI_POWER_TO_PREFIX[SI_PREFIX_NONE_POWER.toString()] = { name: "", symbol: "" };
		SI_POWER_TO_PREFIX[SI_PREFIX_DECI_POWER.toString()] = { name: "deci", symbol: "d" };
		SI_POWER_TO_PREFIX[SI_PREFIX_CENTI_POWER.toString()] = { name: "centi", symbol: "c" };
		SI_POWER_TO_PREFIX[SI_PREFIX_MILLI_POWER.toString()] = { name: "milli", symbol: "m" };
		SI_POWER_TO_PREFIX[SI_PREFIX_MICRO_POWER.toString()] = { name: "micro", symbol: "µ" };
		SI_POWER_TO_PREFIX[SI_PREFIX_NANO_POWER.toString()] = { name: "nano", symbol: "n" };
		SI_POWER_TO_PREFIX[SI_PREFIX_PICO_POWER.toString()] = { name: "pico", symbol: "p" };

		/**
		 * An integer value.
		 * @typedef {number} int
		 */
		/**
		 * A positive integer value.
		 * @typedef {number} uint
		 */
		/**
		 * A numerical value formated with the SI prefixes.
		 * @typedef {Object} PrefixedValue
		 * @property {Number} value - A numerical value.
		 * @property {int} power - A power of ten for the value.
		 */

		/**
		 * Get a value with the least number of significant digits, while staying over one but under the factor between prefix.
		 * @example
		 * _optimizePrefix(1234)                 // { value: 1.234, power: 3 }
		 * _optimizePrefix(0.0012)               // { value: 1.2, power: -3 }
		 * _optimizePrefix(0.00001234)           // { value: 12.34, power: -6 }
		 * _optimizePrefix(1234567, -3, 3, 3)    // { value: 1234.567, power: 3 }
		 * _optimizePrefix(0.00001234, -3, 3, 3) // { value: 0.01234, power: -3 }
		 * _optimizePrefix(1234, -12, 12, 6)     // { value: 1234, power: 0 }
		 * _optimizePrefix(1234567, -12, 12, 6)  // { value: 1.234567, power: 3 }
		 * _optimizePrefix(0.0123, -12, 12, 6)   // { value: 12300, power: -3 }
		 * @param {Number} value - A numerical value to get the adequate prefix from.
		 * @param {int} [minPrefixPower=SI_MIN_PREFIX_POWER] - The lower limit for optimization.
		 * @param {int} [maxPrefixPower=SI_MAX_PREFIX_POWER] - The upper limit for optimization.
		 * @param {int} [powerStep=SI_PREFIX_POWER_STEP] - A power defining the maximum value in base 10 under which the result value should be presented.
		 * @return {PrefixedValue} An object that contains the optimized value and the prefix in power of 10.
		 */
		private static function _optimizePrefix(value:Number, minPrefixPower:int = SI_MIN_PREFIX_POWER, maxPrefixPower:int = SI_MAX_PREFIX_POWER, powerStep:int = SI_PREFIX_POWER_STEP):Object {
			if (powerStep <= 0) return {value: value, power: 0};

			const factor:int = Math.pow(10, powerStep);

			function r(value:Number, power:int):Object {
				if (value == 0) {
					return {value: 0, power: 0};
				} else if (value >= factor && power < maxPrefixPower) {
					return r(value / factor, power + powerStep);
				} else if (value < 1 && power > minPrefixPower) {
					return r(value * factor, power - powerStep);
				} else {
					return {value: value, power: power}
				}
			}
			return r(value, 0);
		}

		/**
		 * Find the number of digits after the decimal points to keep for a prefixed value to still have at least one significant digit, when displayed at a greater power.
		 * @example
		 * _powerDifferenceForSignificantDigit({ value: 12.3, power: -3 }, 0)  // 2
		 * _powerDifferenceForSignificantDigit({ value: 123, power: 3 }, 9)    // 4
		 * _powerDifferenceForSignificantDigit({ value: 12.3, power: 3 }, 9)   // 5
		 * _powerDifferenceForSignificantDigit({ value, 12.3, power: -9 }, -3) // 5
		 * _powerDifferenceForSignificantDigit({ value, 1.23, power: -9 }, -3) // 6
		 * @param {PrefixedValue} optimizedValue - A prefixed value.
		 * @param {int} targetPower - A greater target power than the one of the prefixed value.
		 * @return {int} The number of significant digits after the decimal point to keep to have at least one remaining digit from the prefixed value.
		 */
		private static function _powerDifferenceForSignificantDigit(optimizedValue:Object, targetPower:int):int {
			var powerDifference:int = targetPower - optimizedValue.power;
			var significantDigitPosition:int = 0;
			var value:int = optimizedValue.value;

			while (!(value < 10)) {
				value = Math.floor(value / 10);
				significantDigitPosition++;
			}

			return powerDifference - significantDigitPosition;
		}

		/**
		 * Return the state of the flag for displaying units in the SI system.
		 * @return {Boolean} The value of the SI units flag.
		 */
		public static function isSI():Boolean {
			return kGAMECLASS.flags[kFLAGS.USE_METRICS];
		}

		/**
		 * Return either the provided "imperial" string or the "international" string, based on the value of the global flag.
		 * @param {String} impStr - A string returned if the measurement system used is the Imperial System.
		 * @param {String} siStr - A string returned if the measurement system used is the International System (SI).
		 * @return {String} A provided string chosen based on the value of the global flag.
		 */
		public static function display(impStr:String, siStr:String):String {
			return isSI() ? siStr : impStr;
		}

		// = LENGTH ===================================================================================

		// - Static unit names -

		/**
		 * Get a string of "meter".
		 * @return {String} A string of value "meter".
		 */
		public static function meter():String {
			return "meter";
		}

		/**
		 * Get a string of "meters".
		 * @return {String} A string of value "meters".
		 */
		public static function meters():String {
			return meter() + "s";
		}

		// - For using units as text ----------

		/**
		 * Get a string of "inch", or "centimeter" as the equivalent in SI units.
		 * @return {String} A string of value "inch" or "centimeter".
		 */
		public static function literalInch():String {
			return isSI() ? "centimeter" : "inch";
		}

		/**
		 * Get a string of "inches", or "centimeters" as the equivalent in SI units.
		 * @return {String} A string of value "inches" or "centimeters".
		 */
		public static function literalInches():String {
			return isSI() ? "centimeters" : "inches";
		}

		/**
		 * Get a string of "an inch", or "a centimeter" as the equivalent in SI units.
		 * @return {String} A string of value "an inch" or "a centimeter".
		 */
		public static function literalAnInch():String {
			return isSI() ? "a centimeter" : "an inch";
		}

		/**
		 * Get a string of "inch", or "three centimeters" as the equivalent in SI units.
		 * @return {String} A string of value "inch" or "three centimeters".
		 */
		public static function inch():String {
			return isSI() ? "three centimeters" : "inch";
		}

		/**
		 * Get a string of "inch", or "three-centimeter" as the equivalent in SI units.
		 * @return {String} A string of value "inch" or "three-centimeter".
		 */
		public static function inchCompound():String {
			return isSI() ? "three-centimeter" : "inch";
		}

		/**
		 * Get a string of "an inch", or "three centimeters" as the equivalent in SI units.
		 * @return {String} A string of value "an inch" or "three centimeters".
		 */
		public static function anInch():String {
			return isSI() ? "three centimeters" : "an inch";
		}

		/**
		 * Get a string of "an inch", or "a three-centimeter" as the equivalent in SI units.
		 * @return {String} A string of value "an inch" or "a three-centimeter".
		 */
		public static function anInchCompound():String {
			return isSI() ? "a three-centimeter" : "an inch";
		}

		/**
		 * Get a string of "half-inch", or "centimeter" as the equivalent in SI units.
		 * @return {String} A string of value "half-inch" or "centimeter".
		 */
		public static function halfInch():String {
			return isSI() ? "centimeter" : "half-inch";
		}

		/**
		 * Get a string of "half-inch", or "one-centimeter" as the equivalent in SI units.
		 * @return {String} A string of value "half-inch" or "one-centimeter".
		 */
		public static function halfInchCompound():String {
			return isSI() ? "one-centimeter" : "half-inch";
		}

		/**
		 * Get a string of "half an inch", or "one centimeter" as the equivalent in SI units.
		 * @return {String} A string of value "half an inch" or "one centimeter".
		 */
		public static function halfAnInch():String {
			return isSI() ? "one centimeter" : "half an inch";
		}

		/**
		 * Get a string of "quarter-inch", or "half-centimeter" as the equivalent in SI units.
		 * @return {String} A string of value "quarter-inch" or "half-centimeter".
		 */
		public static function quarterInch():String {
			return isSI() ? "half-centimeter" : "quarter-inch";
		}

		/**
		 * Get a string of "an inch or two", or "three or five centimeters" as the equivalent in SI units.
		 * @return {String} A string of value "an inch or two" or "three or five centimeters".
		 */
		public static function anInchOrTwo():String {
			return isSI() ? "three or five centimeters" : "an inch or two";
		}

		/**
		 * Get a string of "foot", or "decimeter" as the equivalent in SI units.
		 * @return {String} A string of value "foot" or "decimeter".
		 */
		public static function literalFoot():String {
			return isSI() ? "decimeter" : "foot";
		}

		/**
		 * Get a string of "feet", or "decimeters" as the equivalent in SI units.
		 * @return {String} A string of value "feet" or "decimeters".
		 */
		public static function literalFeet():String {
			return isSI() ? "decimeters" : "feet";
		}

		/**
		 * Get a string of "foot", or "thirty centimeters" as the equivalent in SI units.
		 * @return {String} A string of value "foot" or "thirty centimeters".
		 */
		public static function foot():String {
			return isSI() ? "thirty centimeters" : "foot";
		}

		/**
		 * Get a string of "foot", or "thirty-centimeter" as the equivalent in SI units, to be used a compound adjective.
		 * @return {String} A string of value "foot" or "thirty-centimeter".
		 */
		public static function footCompound():String {
			return isSI() ? "thirty-centimeter" : "foot";
		}

		/**
		 * Get a string of "a foot", or "thirty centimeters" as the equivalent in SI units.
		 * @return {String} A string of value "a foot" or "thirty centimeters".
		 */
		public static function aFoot():String {
			return isSI() ? "thirty centimeters" : "a foot";
		}

		/**
		 * Get a string of "half a foot", or "fifteen centimeters" as the equivalent in SI units.
		 * @return {String} A string of value "half a foot" or "fifteen centimeters".
		 */
		public static function halfAFoot():String {
			return isSI() ? "fifteen centimeters" : "half a foot";
		}

		/**
		 * Get a string of "a foot and a half", or "fifty centimeters" as the equivalent in SI units, to be used a compound adjective.
		 * @return {String} A string of value "a foot and a half" or "fifty centimeters".
		 */
		public static function aFootAndAHalf():String {
			return isSI() ? "fifty centimeters" : "a foot and a half";
		}

		/**
		 * Get a string of "foot and a half", or "fifty centimeters" as the equivalent in SI units, to be used a compound adjective.
		 * @return {String} A string of value "foot and a half" or "fifty centimeters".
		 */
		public static function footAndAHalf():String {
			return isSI() ? "fifty centimeters" : "foot and a half";
		}

		/**
		 * Get a string of "foot-and-a-half", or "fifty-centimeter" as the equivalent in SI units, to be used a compound adjective.
		 * @return {String} A string of value "foot-and-a-half" or "fifty-centimeter".
		 */
		public static function footAndAHalfCompound():String {
			return isSI() ? "fifty-centimeter" : "foot-and-a-half";
		}

		/**
		 * Get a string of "a few feet", or "a meter" as the equivalent in SI units, to be used a compound adjective.
		 * @return {String} A string of value "a few feet" or "a meter".
		 */
		public static function aFewFeet():String {
			return isSI() ? "a meter" : "a few feet";
		}

		/**
		 * Get a string of "a dozen feet", or "a few meters" as the equivalent in SI units, to be used a compound adjective.
		 * @return {String} A string of value "a dozen feet" or "a few meters".
		 */
		public static function aDozenFeet():String {
			return isSI() ? "a few meters" : "a dozen feet";
		}

		/**
		 * Get a string of "dozens feet", or "meters" as the equivalent in SI units, to be used a compound adjective.
		 * @return {String} A string of value "dozens feet" or "meters".
		 */
		public static function dozensFeet():String {
			return isSI() ? "meters" : "dozens feet";
		}

		/**
		 * Get a string of "dozens of feet", or "meters" as the equivalent in SI units, to be used a compound adjective.
		 * @return {String} A string of value "dozens of feet" or "meters".
		 */
		public static function dozensOfFeet():String {
			return isSI() ? "meters" : "dozens of feet";
		}

		/**
		 * Get a string of "yard", or "meter" as the equivalent in SI units.
		 * @return {String} A string of value "yard" or "meter".
		 */
		public static function literalYard():String {
			return isSI() ? "meter" : "yard";
		}

		/**
		 * Get a string of "yards", or "meters" as the equivalent in SI units.
		 * @return {String} A string of value "yards" or "meters".
		 */
		public static function literalYards():String {
			return isSI() ? "meters" : "yards";
		}

		/**
		 * Get a string of "a yard", or "a meter" as the equivalent in SI units.
		 * @return {String} A string of value "a yard" or "a meter".
		 */
		public static function aYard():String {
			return isSI() ? "a meter" : "a yard";
		}

		// - For converting length from a system to another -

		/**
		 * Return a value representing a length in inches or in centimeters.
		 * @param {Number} inches - A length in inches.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {Number} A length value in inches or in centimeters.
		 */
		public static function lengthInInches(inches:Number, sig:int = 0):Number {
			return formatFloat((isSI() ? inches * INCH_TO_METER / SI_PREFIX_CENTI_FACTOR : inches), sig);
		}

		/**
		 * Return a value representing a length in inches or an approximation in centimeters.
		 * @param {Number} inches - A length in inches.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {Number} A length value in inches or in centimeters.
		 */
		public static function lengthInInchesEstimate(inches:Number, sig:int = 0):Number {
			return formatFloat((isSI() ? inches * INCH_TO_METER_APPROX / SI_PREFIX_CENTI_FACTOR : inches), sig);
		}

		/**
		 * Return a value representing a length in feet or in centimeters.
		 * @param {Number} feet - A length in feet.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {Number} A length value in feet or in centimeters.
		 */
		public static function lengthInFeet(feet:Number, sig:int = 0):Number {
			return formatFloat((isSI() ? feet * FOOT_TO_METER / SI_PREFIX_CENTI_FACTOR : feet), sig);
		}

		/**
		 * Return a value representing a length in feet or an approximation in centimeters.
		 * @param {Number} feet - A length in feet.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {Number} A length value in feet or in centimeters.
		 */
		public static function lengthInFeetEstimate(feet:Number, sig:int = 0):Number {
			return formatFloat((isSI() ? feet * FOOT_TO_METER_APPROX / SI_PREFIX_CENTI_FACTOR : feet), sig);
		}

		/**
		 * Return a value representing a length in yards or in centimeters.
		 * @param {Number} yards - A length in yards.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {Number} A length value in yards or in centimeters.
		 */
		public static function lengthInYards(yards:Number, sig:int = 0):Number {
			return formatFloat((isSI() ? yards * YARD_TO_METER / SI_PREFIX_CENTI_FACTOR : yards), sig);
		}

		/**
		 * Convert a value in centimeters to inches.
		 * @param {Number} centimeters - A value in centimeters.
		 * @return {Number} A converted value in inches.
		 */
		public static function centimeterToInch(centimeters:Number):Number {
			return formatFloat(centimeters / INCH_TO_METER * SI_PREFIX_CENTI_FACTOR, 1);
		}

		/**
		 * Convert a value in inches to centimeters.
		 * @param {Number} inches - A value in inches.
		 * @return {Number} A converted value in centimeters.
		 */
		public static function inchToCentimeter(inches:Number):Number {
			return formatFloat(inches * INCH_TO_METER / SI_PREFIX_CENTI_FACTOR, 1);
		}

		// - For printing heights ----------

		/**
		 * Return a string of a length in inches or in centimeters, with the unit written in full form.
		 * @example
		 * _displayInches(0.4, 1)          // "0.4 inches"   / "1 centimeter"
		 * _displayInches(1, 0, 1)         // "1 inch"       / "2.5 centimeters"
		 * _displayInches(2.125, 1, 2)     // "2.1 inches"   / "5.39 centimeters"
		 * _displayInches(2.535, 3, 3)     // "2.535 inches" / "6.439 centimeters"
		 * _displayInches(2, 1, 1, true)   // "two inches"   / "5.1 centimeters"
		 * _displayInches(0.8, 1, 1, true) // "0.8 inches"   / "two centimeters"
		 * @param {Number} inches - A length in inches.
		 * @param {int} [impSig=0] - The number of significant digits after the decimal point to keep for the value in the imperial system.
		 * @param {int} [siSig=0] - The number of significant digits after the decimal point to keep for the value in the International System.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @param {String} [qualifier=""] - A string to modifiy the qualitiy of the measurement unit; Should contain a trailing space to separate the qualifier and the unit.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		private static function _displayInches(inches:Number, impSig:int = 0, siSig:int = 0, useNum2Text:Boolean = false, qualifier:String = ""):String {
			var sig:uint = isSI() ? siSig : impSig;
			var value:Number = lengthInInches(inches, sig);
			var symbol:String = isSI() ? "centimeter" : "inch";
			if (!(value == 1 || value == 0)) symbol += isSI() ? "s" : "es";

			return (useNum2Text ? num2Text(value) : value) + " " + qualifier + symbol;
		}

		/**
		 * Return a string of a height in inches or in centimeters, with the unit written in full form.
		 * @example
		 * displayHeightInInches(60)      // "60 inches"   / "152 centimeters"
		 * displayHeightInInches(74.8)    // "74.8 inches" / "190 centimeters"
		 * displayHeightInInches(75.3945) // "75.4 inches" / "192 centimeters"
		 * @param {Number} inches - A height in inches.
		 * @return {String} A string of a height with the unit written in full form.
		 */
		public static function displayHeightInInches(inches:Number):String {
			return _displayInches(inches, 1, 0);
		}

		/**
		 * Return a string of a height in feet and inches, or in meters/centimeters, with the units written in full form.
		 * To display a height from its value in feet and inches, @see {@link displayHeight2}.
		 * @example
		 * displayHeight(11)           // "11 inches"           / "28 centimeters"
		 * displayHeight(12)           // "1 foot"              / "30 centimeters"
		 * displayHeight(33.5)         // "2 feet 10 inches"    / "85 centimeters"
		 * displayHeight(39.37)        // "3 feet 3 inches"     / "1 meter"
		 * displayHeight(60)           // "5 feet"              / "1.52 meters"
		 * displayHeight(74, "and")    // "6 feet and 2 inches" / "1.88 meters"
		 * displayHeight(78, "", true) // "six feet six inches" / "1.98 meters"
		 * @param {Number} inches - A height in inches.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches values.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a height with the units written in full form.
		 */
		public static function displayHeight(inches:Number, impStrSep:String = "", useNum2Text:Boolean = false):String {
			var value:Number = lengthInInches(inches);
			var result:String;
			if (isSI()) {
				if (value < 1 / SI_PREFIX_CENTI_FACTOR) {
					result = value + " centimeter" + (value > 1 ? "s" : "");
				} else {
					var meter:Number = value / (1/SI_PREFIX_CENTI_FACTOR);
					result = (useNum2Text ? num2Text(meter) : meter) + " meter" + (meter > 1 ? "s" : "");
				}
			} else {
				var inch:int = value % INCHES_IN_A_FOOT;
				var feet:int = (value - inch) / INCHES_IN_A_FOOT;

				result = (feet == 0 && inch > 0 ? "" : (useNum2Text ? num2Text(feet) : feet) + " f" + (feet > 1 ? "ee" : "oo") + "t") + (inch > 0 ? " " + (impStrSep.length > 0 ? impStrSep + " " : "") + (useNum2Text ? num2Text(inch) : inch) + " inch" + (inch > 1 ? "es" : "") : "");
			}
			return result;
		}

  	/**
		 * Return a string of a height in text form, in feet and inches, or in meters/centimeters, with the units written in full form.
		 * To display a height from its value in feet and inches, @see {@link displayHeight2Textually}.
		 * @example
		 * displayHeightTextually(11)        // "11 inches"               / "28 centimeters"
		 * displayHeightTextually(12)        // "one foot"                / "30 centimeters"
		 * displayHeightTextually(33.5)      // "two feet ten inches"     / "85 centimeters"
		 * displayHeightTextually(39.37)     // "three feet three inches" / "one meter"
		 * displayHeightTextually(60)        // "five feet"               / "1.52 meters"
		 * displayHeightTextually(74, "and") // "six feet and two inches" / "1.88 meters"
		 * displayHeightTextually(78)        // "six feet six inches"     / "1.98 meters"
		 * @param {Number} inches - A height in inches.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches values.
		 * @return {String} A string of a height in text form with the units written in full form.
		 */
		public static function displayHeightTextually(inches:Number, impStrSep:String = ""):String {
			return displayHeight(inches, impStrSep, true);
		}

		/**
		 * Return a string of a height in feet and inches, or in meters/centimeters, with the units written as symbols.
		 * To display a height from its value in feet and inches, @see {@link displayHeight2Short2}.
		 * @example
		 * displayHeightShort2(11)    // «11"»    / «28 cm»
		 * displayHeightShort2(12)    // «1'»     / «30 cm»
		 * displayHeightShort2(33.5)  // «2' 10"» / «85 cm»
		 * displayHeightShort2(39.37) // «3' 3"»  / «1 m»
		 * displayHeightShort2(60)    // «5'»     / «1.52 m»
		 * displayHeightShort2(74)    // «6' 2"»  / «1.88 m»
		 * @param {Number} inches - A height in inches.
		 * @return {String} A string of a height with the units written as symbols.
		 */
		public static function displayHeightShort2(inches:Number):String {
			var value:Number = lengthInInches(feet * INCHES_IN_A_FOOT + inches);
			var result:String;
			if (isSI()) {
				result = value < 1 / SI_PREFIX_CENTI_FACTOR ?
					value + " cm":
					value / (1/SI_PREFIX_CENTI_FACTOR) + " m";
			} else {
				var inch:int = value % INCHES_IN_A_FOOT;
				var feet:int = (value - inch) / INCHES_IN_A_FOOT;

				if (feet == 0 && inch == 0) result = "0\"";
				else {
					result = (feet > 0 ? feet + "'" : "")
						+ (feet > 0 && inch > 0 ? " " : "")
						+ (inch > 0 ? inch + "\"" : "");
				}
			}
			return result;
		}

		/**
		 * Return a string of a height in feet and inches, or in meters/centimeters, with the units written in full form.
		 * To display a height only from its value in inches, @see {@link displayHeight}.
		 * @example
		 * displayHeight2(0, 11)            // "11 inches"                / "28 centimeters"
		 * displayHeight2(1, 0)             // "1 foot"                   / "30 centimeters"
		 * displayHeight2(0, 12)            // "1 foot"                   / "30 centimeters"
		 * displayHeight2(2, 9.5)           // "2 feet 10 inches"         / "85 centimeters"
		 * displayHeight2(1, 21.5)          // "2 feet 10 inches"         / "85 centimeters"
		 * displayHeight2(3, 3.37)          // "3 feet 3 inches"          / "1 meter"
		 * displayHeight2(5)                // "5 feet"                   / "1.52 meters"
		 * displayHeight2(5, 0, "and")      // "5 feet"                   / "1.52 meters"
		 * displayHeight2(6, 2, "and")      // "6 feet and 2 inches"      / "1.88 meters"
		 * displayHeight2(6, 2, "and some") // "6 feet and some 2 inches" / "1.88 meters"
		 * @param {Number} feet - The number of feet in the height value.
		 * @param {Number} [inches=0] - The number of inches in the height value.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches, e.g. impStrSep="and" => 5 feet and 4 inches.
		 * @return {String} A string of a height with the units written in full form.
		 */
		public static function displayHeight2(feet:Number, inches:Number = 0, impStrSep:String = ""):String {
			return displayHeight(feet * INCHES_IN_A_FOOT + inches, impStrSep, false);
		}

		/**
		 * Return a string of a height in text form, in feet and inches, or in meters/centimeters, with the units written in full form.
		 * To display a height only from its value in inches, @see {@link displayHeightTextually}.
		 * @example
		 * displayHeight2Textually(0, 11)            // "11 inches"                    / "28 centimeters"
		 * displayHeight2Textually(1, 0)             // "one foot"                     / "30 centimeters"
		 * displayHeight2Textually(0, 12)            // "one foot"                     / "30 centimeters"
		 * displayHeight2Textually(2, 9.5)           // "two feet ten inches"          / "85 centimeters"
		 * displayHeight2Textually(1, 21.5)          // "two feet ten inches"          / "85 centimeters"
		 * displayHeight2Textually(3, 3.37)          // "three feet three inches"      / "one meter"
		 * displayHeight2Textually(5)                // "five feet"                    / "1.52 meters"
		 * displayHeight2Textually(5, 0, "and")      // "five feet"                    / "1.52 meters"
		 * displayHeight2Textually(6, 2, "and")      // "six feet and two inches"      / "1.88 meters"
		 * displayHeight2Textually(6, 2, "and some") // "six feet and some two inches" / "1.88 meters"
		 * @param {Number} feet - The number of feet in the height value.
		 * @param {Number} [inches=0] - The number of inches in the height value.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches, e.g. impStrSep="and" => 5 feet and 4 inches.
		 * @return {String} A string of a height in text form with the units written in full form.
		 */
		public static function displayHeight2Textually(feet:Number, inches:Number = 0, impStrSep:String = ""):String {
			return displayHeightTextually(feet * INCHES_IN_A_FOOT + inches, impStrSep);
		}

		/**
		 * Return a string of a height in feet and inches, or in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * To display a height from its value in feet and inches, @see {@link displayHeight2WithHyphen}.
		 * @example
		 * displayHeightWithHyphen(11)           // "11-inch"           / "28-centimeter"
		 * displayHeightWithHyphen(12)           // "1-foot"            / "30-centimeter"
		 * displayHeightWithHyphen(33.5)         // "2-foot 10-inch"    / "85-centimeter"
		 * displayHeightWithHyphen(39.37)        // "3-foot 3-inch"     / "1-meter"
		 * displayHeightWithHyphen(60)           // "5-foot"            / "1.52-meter"
		 * displayHeightWithHyphen(74, "and")    // "6-foot and 2-inch" / "1.88-meter"
		 * displayHeightWithHyphen(78, "", true) // "six-foot six-inch" / "1.98-meter"
		 * @param {Number} inches - A height in inches.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches values.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a height and a unit, joined by a hyphen.
		 */
		public static function displayHeightWithHyphen(inches:Number, impStrSep:String = "", useNum2Text:Boolean = false): String {
			var value:Number = lengthInInches(inches);
			var result:String;
			if (isSI()) {
				if (value < 1 / SI_PREFIX_CENTI_FACTOR) {
					result = value + "-centimeter";
				} else {
					var meter:Number = value / (1/SI_PREFIX_CENTI_FACTOR);
					result = (useNum2Text ? num2Text(meter) : meter) + "-meter";
				}
			} else {
				var inch:int = value % INCHES_IN_A_FOOT;
				var feet:int = (value - inch) / INCHES_IN_A_FOOT;

				result = (feet == 0 && inch > 0 ? "" : (useNum2Text ? num2Text(feet) : feet) + "-foot") + (inch > 0 ? " " + (impStrSep.length > 0 ? impStrSep + " " : "") + (useNum2Text ? num2Text(inch) : inch) + "-inch" : "");
			}
			return result;
		}

		/**
		 * Return a string of a height in text form, in feet and inches, or in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * To display a height from its value in feet and inches, @see {@link displayHeight2WithHyphenTextually}.
		 * @example
		 * displayHeightWithHyphenTextually(11)        // "11-inch"               / "28-centimeter"
		 * displayHeightWithHyphenTextually(12)        // "one-foot"              / "30-centimeter"
		 * displayHeightWithHyphenTextually(33.5)      // "two-foot ten-inch"     / "85-centimeter"
		 * displayHeightWithHyphenTextually(39.37)     // "one-foot three-inch"   / "one-meter"
		 * displayHeightWithHyphenTextually(60)        // "five-foot"             / "1.52-meter"
		 * displayHeightWithHyphenTextually(74, "and") // "six-foot and two-inch" / "1.88-meter"
		 * displayHeightWithHyphenTextually(78)        // "six-foot six-inch"     / "1.98-meter"
		 * @param {Number} inches - A height in inches.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches values.
		 * @return {String} A string of a height in text form and a unit, joined by a hyphen.
		 */
		public static function displayHeightWithHyphenTextually(inches:Number, impStrSep:String = ""):String {
			return displayHeightWithHyphen(inches, impStrSep, true);
		}

		/**
		 * Return a string of a height in feet and inches, or in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * To display a height only from its value in inches, @see {@link displayHeightWithHyphen}.
		 * @example
		 * displayHeight2WithHyphen(0, 11)            // "11-inch"                / "28-centimeter"
		 * displayHeight2WithHyphen(1, 0)             // "1-foot"                 / "30-centimeter"
		 * displayHeight2WithHyphen(0, 12)            // "1-foot"                 / "30-centimeter"
		 * displayHeight2WithHyphen(2, 9.5)           // "2-foot 10-inch"         / "85-centimeter"
		 * displayHeight2WithHyphen(1, 21.5)          // "2-foot 10-inch"         / "85-centimeter"
		 * displayHeight2WithHyphen(3, 3.37)          // "3-foot 3-inch"          / "1-meter"
		 * displayHeight2WithHyphen(5)                // "5-foot"                 / "1.52-meter"
		 * displayHeight2WithHyphen(5, 0, "and")      // "5-foot"                 / "1.52-meter"
		 * displayHeight2WithHyphen(6, 2, "and")      // "6-foot and 2-inch"      / "1.88-meter"
		 * displayHeight2WithHyphen(6, 2, "and some") // "6-foot and some 2-inch" / "1.88-meter"
		 * @param {Number} feet - The number of feet in the height value.
		 * @param {Number} [inches=0] - The number of inches in the height value.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches values.
		 * @return {String} A string of a height and a unit, joined by a hyphen.
		 */
		public static function displayHeight2WithHyphen(feet:Number, inches:Number = 0, impStrSep:String = ""):String {
			return displayHeightWithHyphen(feet * INCHES_IN_A_FOOT + inches, impStrSep, false);
		}

		/**
		 * Return a string of a height in text form, in feet and inches, or in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * To display a height only from its value in inches, @see {@link displayHeightWithHyphenTextually}.
		 * @example
		 * displayHeight2WithHyphenTextually(0, 11)            // "11-inch"                    / "28-centimeter"
		 * displayHeight2WithHyphenTextually(1, 0)             // "one-foot"                   / "30-centimeter"
		 * displayHeight2WithHyphenTextually(0, 12)            // "one-foot"                   / "30-centimeter"
		 * displayHeight2WithHyphenTextually(2, 9.5)           // "two-foot ten-inch"          / "85-centimeter"
		 * displayHeight2WithHyphenTextually(1, 21.5)          // "two-foot ten-inch"          / "85-centimeter"
		 * displayHeight2WithHyphenTextually(3, 3.37)          // "three-foot three-inch"      / "one-meter"
		 * displayHeight2WithHyphenTextually(5)                // "five-foot"                  / "1.52-meter"
		 * displayHeight2WithHyphenTextually(5, 0, "and")      // "five-foot"                  / "1.52-meter"
		 * displayHeight2WithHyphenTextually(6, 2, "and")      // "six-foot and two-inch"      / "1.88-meter"
		 * displayHeight2WithHyphenTextually(6, 2, "and some") // "six-foot and some two-inch" / "1.88-meter"
		 * @param {Number} feet - The number of feet in the height value.
		 * @param {Number} [inches=0] - The number of inches in the height value.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches values.
		 * @return {String} A string of a height in text form and a unit, joined by a hyphen.
		 */
		public static function displayHeight2WithHyphenTextually(feet:Number, inches:Number = 0, impStrSep:String = ""):String {
			return displayHeightWithHyphen(feet * INCHES_IN_A_FOOT + inches, impStrSep, true);
		}

		/**
		 * Return a string of a height in feet and inches, or in meters/centimeters, with the units written as symbols.
		 * @example
		 * displayHeight2Short2(0, 11)   // «11"»   / «28 cm»
		 * displayHeight2Short2(1, 0)    // «1'»    / «30 cm»
		 * displayHeight2Short2(0, 12)   // «1'»    / «30 cm»
		 * displayHeight2Short2(2, 9.5)  // «2' 9"» / «85 cm»
		 * displayHeight2Short2(1, 21.5) // «2' 9"» / «85 cm»
		 * displayHeight2Short2(3, 3.37) // «3' 3"» / «1 m»
		 * displayHeight2Short2(5)       // «5'»    / «1.52 m»
		 * displayHeight2Short2(6, 2)    // «6' 2"» / «1.88 m»
		 * @param {Number} feet - The number of feet in the height value.
		 * @param {Number} [inches=0] - The number of inches in the height value.
		 * @return {String} A string of a height with the units written as symbols.
		 */
		public static function displayHeight2Short2(feet:Number, inches:Number = 0):String {
			return displayHeightShort2(feet * INCHES_IN_A_FOOT + inches);
		}

		/**
		 * Return a string of a length of great precision in feet and inches, or in meters/centimeters, with the units written as symbols.
		 * @example
		 * displayPreciseLengthShort2(33.5)  // «2' 9 <sup>1</sup>/<sub>2</sub>"»    / «85.1 cm»
		 * displayPreciseLengthShort2(66)    // «5' 6"»                              / «1.676 m»
		 * displayPreciseLengthShort2(69.65) // «5' 10 <sup>11</sup>/<sub>16</sub>"» / «1.769 m»
		 * @param {Number} inches - A length in inches.
		 * @return {String} A string of a length with the units written as symbols.
		 */
		public static function displayPreciseLengthShort2(inches:Number):String {
			var value:Number = lengthInInches(inches, 3);
			var result:String;
			if (isSI()) {
				if (value < 1 / SI_PREFIX_CENTI_FACTOR) {
					result = value + " cm";
				} else {
					var meter:Number = formatFloat(value / (1/SI_PREFIX_CENTI_FACTOR), 3);
					result = meter + " m";
				}
			} else {
				/**
				 * @author Fenoxo
				 * @author Jacques00
				 */
				// Feet
				var feet:int = Math.floor(value / INCHES_IN_A_FOOT);
				// Inches
				var inch:int = Math.floor(value % INCHES_IN_A_FOOT);
				var num:String = "";
				var den:String = "";
				if(value % INCHES_IN_A_FOOT > 0)
				{
					// Fractional stuff, proper maffs format! (to the nearest 1/16th inch)
					var fraction:Number = formatFloat((value - Math.floor(value)), 4);
					if(fraction >= 0.0125)
					{
						if(fraction <= 0.0625) { num = "1"; den = "16"; }
						else if(fraction <= 0.125) { num = "1"; den = "8"; }
						else if(fraction <= 0.1875) { num = "3"; den = "16"; }
						else if(fraction <= 0.25) { num = "1"; den = "4"; }
						else if(fraction <= 0.3125) { num = "5"; den = "16"; }
						else if(fraction <= 0.375) { num = "3"; den = "8"; }
						else if(fraction <= 0.4375) { num = "7"; den = "16"; }
						else if(fraction <= 0.5) { num = "1"; den = "2"; }
						else if(fraction <= 0.5625) { num = "9"; den = "16"; }
						else if(fraction <= 0.625) { num = "5"; den = "8"; }
						else if(fraction <= 0.6875) { num = "11"; den = "16"; }
						else if(fraction <= 0.75) { num = "3"; den = "4"; }
						else if(fraction <= 0.8125) { num = "13"; den = "16"; }
						else if(fraction <= 0.875) { num = "7"; den = "8"; }
						else if(fraction <= 0.9375) { num = "15"; den = "16"; }
						else {
							inch++;
							if(inch == INCHES_IN_A_FOOT) { feet++; inch = 0; }
						}
					}
				}
				result = (feet == 0 && (inch > 0 || num != "") ? "" : feet + "'")
					+ (inch > 0 ? (feet > 0 ? " " : "") + inch : "")
					+ (num != "" ? (feet > 0 || inch > 0 ? " " : "") + "<sup>" + num + "</sup>/<sub>" + den + "</sub>" : "")
					+ (inch > 0 || num != "" ? "\"" : "");
			}
			return result;
		}

		/**
		 * Return a string of a height in feet and inches, or an approximation in meters/centimeters, with the units written in full form.
		 * To display a height from its value in feet and inches, @see {@link displayHeight2Estimate}.
		 * @example
		 * displayHeightEstimate(11)           // "11 inches"           / "30 centimeters"
		 * displayHeightEstimate(12)           // "1 foot"              / "30 centimeters"
		 * displayHeightEstimate(33.5)         // "2 feet 10 inches"    / "85 centimeters"
		 * displayHeightEstimate(39.37)        // "3 feet 3 inches"     / "1 meter"
		 * displayHeightEstimate(60)           // "5 feet"              / "1.5 meters"
		 * displayHeightEstimate(74, "and")    // "6 feet and 2 inches" / "1.9 meters"
		 * displayHeightEstimate(78, "", true) // "six feet six inches" / "two meters"
		 * @param {Number} inches - A height in inches.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches values.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a height with the units written in full form.
		 */
		public static function displayHeightEstimate(inches:Number, impStrSep:String = "", useNum2Text:Boolean = false):String {
			var value:Number = lengthInInches(inches);
			var result:String;
			if (isSI()) {
				// Round the value to the nearest unit that is 0 or 5.
				value = formatFloat(value / 5) * 5;
				if (value < 1 / SI_PREFIX_CENTI_FACTOR) {
					result = value + " centimeter" + (value > 1 ? "s" : "");
				} else {
					var meter:Number = formatFloat(value / (1/SI_PREFIX_CENTI_FACTOR), 1);
					result = (useNum2Text ? num2Text(meter) : meter) + " meter" + (meter > 1 ? "s" : "");
				}
			} else {
				var inch:int = value % INCHES_IN_A_FOOT;
				var feet:int = (value - inch) / INCHES_IN_A_FOOT;

				result = (feet == 0 && inch > 0 ? "" : (useNum2Text ? num2Text(feet) : feet) + " f" + (feet > 1 ? "ee" : "oo") + "t") + (inch > 0 ? " " + (impStrSep.length > 0 ? impStrSep + " " : "") + (useNum2Text ? num2Text(inch) : inch) + " inch" + (inch > 1 ? "es" : "") : "");
			}
			return result;
		}

  	/**
		 * Return a string of a height in text form, in feet and inches, or an approximation in meters/centimeters, with the units written in full form.
		 * To display a height from its value in feet and inches, @see {@link displayHeight2EstimateTextually}.
		 * @example
		 * displayHeightTextually(11)        // "11 inches"               / "28 centimeters"
		 * displayHeightTextually(12)        // "one foot"                / "30 centimeters"
		 * displayHeightTextually(33.5)      // "two feet ten inches"     / "85 centimeters"
		 * displayHeightTextually(39.37)     // "three feet three inches" / "one meter"
		 * displayHeightTextually(60)        // "five feet"               / "1.52 meters"
		 * displayHeightTextually(74, "and") // "six feet and two inches" / "1.88 meters"
		 * displayHeightTextually(78)        // "six feet six inches"     / "1.98 meters"
		 * @param {Number} inches - A height in inches.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches values.
		 * @return {String} A string of a height in text form with the units written in full form.
		 */
		public static function displayHeightEstimateTextually(inches:Number, impStrSep:String = ""):String {
			return displayHeightEstimate(inches, impStrSep, true);
		}

		/**
		 * Return a string of a height in feet and inches, or an approximation in meters/centimeters, with the units written in full form.
		 * To display a height only from its value in inches, @see {@link displayHeightEstimate}.
		 * @example
		 * displayHeight2Estimate(0, 11)            // "11 inches"                / "30 centimeters"
		 * displayHeight2Estimate(1, 0)             // "1 foot"                   / "30 centimeters"
		 * displayHeight2Estimate(0, 12)            // "1 foot"                   / "30 centimeters"
		 * displayHeight2Estimate(2, 9.5)           // "2 feet 10 inches"         / "85 centimeters"
		 * displayHeight2Estimate(1, 21.5)          // "2 feet 10 inches"         / "85 centimeters"
		 * displayHeight2Estimate(3, 3.37)          // "3 feet 3 inches"          / "1 meter"
		 * displayHeight2Estimate(5)                // "5 feet"                   / "1.5 meters"
		 * displayHeight2Estimate(5, 0, "and")      // "5 feet"                   / "1.5 meters"
		 * displayHeight2Estimate(6, 2, "and")      // "6 feet and 2 inches"      / "1.9 meters"
		 * displayHeight2Estimate(6, 2, "and some") // "6 feet and some 2 inches" / "1.9 meters"
		 * @param {Number} feet - The number of feet in the height value.
		 * @param {Number} [inches=0] - The number of inches in the height value.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches, e.g. impStrSep="and" => 5 feet and 4 inches.
		 * @return {String} A string of a height with the units written in full form.
		 */
		public static function displayHeight2Estimate(feet:Number, inches:Number = 0, impStrSep:String = ""):String {
			return displayHeightEstimate(feet * INCHES_IN_A_FOOT + inches, impStrSep, false);
		}

		/**
		 * Return a string of a height in text form, in feet and inches, or an approximation in meters/centimeters, with the units written in full form.
		 * To display a height only from its value in inches, @see {@link displayHeightEstimateTextually}.
		 * @example
		 * displayHeight2EstimateTextually(0, 11)            // "11 inches"                  / "30 centimeters"
		 * displayHeight2EstimateTextually(1, 0)             // "one foot"                   / "30 centimeters"
		 * displayHeight2EstimateTextually(0, 12)            // "one foot"                   / "30 centimeters"
		 * displayHeight2EstimateTextually(2, 9.5)           // "two feet ten inches"        / "85 centimeters"
		 * displayHeight2EstimateTextually(1, 21.5)          // "two feet ten inches"        / "85 centimeters"
		 * displayHeight2EstimateTextually(3, 3.37)          // "three feet three inches"    / "one meter"
		 * displayHeight2EstimateTextually(5)                // "five feet"                  / "1.5 meters"
		 * displayHeight2EstimateTextually(5, 0, "and")      // "five feet"                  / "1.5 meters"
		 * displayHeight2EstimateTextually(6, 2, "and")      // "six feet and 2 inches"      / "1.9 meters"
		 * displayHeight2EstimateTextually(6, 2, "and some") // "six feet and some 2 inches" / "1.9 meters"
		 * @param {Number} feet - The number of feet in the height value.
		 * @param {Number} [inches=0] - The number of inches in the height value.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches, e.g. impStrSep="and" => 5 feet and 4 inches.
		 * @return {String} A string of a height in text form with the units written in full form.
		 */
		public static function displayHeight2EstimateTextually(feet:Number, inches:Number = 0, impStrSep:String = ""):String {
			return displayHeightEstimate(feet * INCHES_IN_A_FOOT + inches, impStrSep, true);
		}

		/**
		 * Return a string of a height in feet and inches, or an approximation in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * To display a height from its value in feet and inches, @see {@link displayHeight2EstimateWithHyphen}.
		 * @example
		 * displayHeightEstimateWithHyphen(11)           // "11-inch"           / "30-centimeter"
		 * displayHeightEstimateWithHyphen(12)           // "1-foot"            / "30-centimeter"
		 * displayHeightEstimateWithHyphen(33.5)         // "2-foot 10-inch"    / "85-centimeter"
		 * displayHeightEstimateWithHyphen(39.37)        // "3-foot 3-inch"     / "1-meter"
		 * displayHeightEstimateWithHyphen(60)           // "5-foot"            / "1.5-meter"
		 * displayHeightEstimateWithHyphen(74, "and")    // "6-foot and 2-inch" / "1.9-meter"
		 * displayHeightEstimateWithHyphen(78, "", true) // "six-foot six-inch" / "two-meter"
		 * @param {Number} inches - A height in inches.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches values.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a height and a unit, joined by a hyphen.
		 */
		public static function displayHeightEstimateWithHyphen(inches:Number, impStrSep:String = "", useNum2Text:Boolean = false): String {
			var value:Number = lengthInInches(inches);
			var result:String;
			if (isSI()) {
				// Round the value to the nearest unit that is 0 or 5.
				value = formatFloat(value / 5) * 5;
				if (value < 1 / SI_PREFIX_CENTI_FACTOR) {
					result = value + "-centimeter";
				} else {
					var meter:Number = formatFloat(value / (1/SI_PREFIX_CENTI_FACTOR), 1);
					result = (useNum2Text ? num2Text(meter) : meter) + "-meter";
				}
			} else {
				var inch:int = value % INCHES_IN_A_FOOT;
				var feet:int = (value - inch) / INCHES_IN_A_FOOT;

				result = (feet == 0 && inch > 0 ? "" : (useNum2Text ? num2Text(feet) : feet) + "-foot") + (inch > 0 ? " " + (impStrSep.length > 0 ? impStrSep + " " : "") + (useNum2Text ? num2Text(inch) : inch) + "-inch" : "");
			}
			return result;
		}

		/**
		 * Return a string of a height in text form, in feet and inches, or an approximation in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * To display a height from its value in feet and inches, @see {@link displayHeight2EstimateWithHyphenTextually}.
		 * @example
		 * displayHeightEstimateWithHyphenTextually(11)        // "11-inch"               / "30-centimeter"
		 * displayHeightEstimateWithHyphenTextually(12)        // "one-foot"              / "30-centimeter"
		 * displayHeightEstimateWithHyphenTextually(33.5)      // "two-foot ten-inch"     / "85-centimeter"
		 * displayHeightEstimateWithHyphenTextually(39.37)     // "one-foot three-inch"   / "one-meter"
		 * displayHeightEstimateWithHyphenTextually(60)        // "five-foot"             / "1.5-meter"
		 * displayHeightEstimateWithHyphenTextually(74, "and") // "six-foot and two-inch" / "1.9-meter"
		 * displayHeightEstimateWithHyphenTextually(78)        // "six-foot six-inch"     / "two-meter"
		 * @param {Number} inches - A height in inches.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches values.
		 * @return {String} A string of a height in text form and a unit, joined by a hyphen.
		 */
		public static function displayHeightEstimateWithHyphenTextually(inches:Number, impStrSep:String = ""):String {
			return displayHeightEstimateWithHyphen(inches, impStrSep, true);
		}

		/**
		 * Return a string of a height in feet and inches, or an approximation in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * To display a height only from its value in inches, @see {@link displayHeightEstimateWithHyphen}.
		 * @example
		 * displayHeight2EstimateWithHyphen(0, 11)            // "11-inch"                / "30-centimeter"
		 * displayHeight2EstimateWithHyphen(1, 0)             // "1-foot"                 / "30-centimeter"
		 * displayHeight2EstimateWithHyphen(0, 12)            // "1-foot"                 / "30-centimeter"
		 * displayHeight2EstimateWithHyphen(2, 9.5)           // "2-foot 10-inch"         / "85-centimeter"
		 * displayHeight2EstimateWithHyphen(1, 21.5)          // "2-foot 10-inch"         / "85-centimeter"
		 * displayHeight2EstimateWithHyphen(3, 3.37)          // "3-foot 3-inch"          / "1-meter"
		 * displayHeight2EstimateWithHyphen(5)                // "5-foot"                 / "1.5-meter"
		 * displayHeight2EstimateWithHyphen(5, 0, "and")      // "5-foot"                 / "1.5-meter"
		 * displayHeight2EstimateWithHyphen(6, 2, "and")      // "6-foot and 2-inch"      / "1.9-meter"
		 * displayHeight2EstimateWithHyphen(6, 2, "and some") // "6-foot and some 2-inch" / "1.9-meter"
		 * @param {Number} feet - The number of feet in the height value.
		 * @param {Number} [inches=0] - The number of inches in the height value.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches values.
		 * @return {String} A string of a height and a unit, joined by a hyphen.
		 */
		public static function displayHeight2EstimateWithHyphen(feet:Number, inches:Number = 0, impStrSep:String = ""):String {
			return displayHeightEstimateWithHyphen(feet * INCHES_IN_A_FOOT + inches, impStrSep, false);
		}

		/**
		 * Return a string of a height in text form, in feet and inches, or an approximation in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * To display a height only from its value in inches, @see {@link displayHeightEstimateWithHyphenTextually}.
		 * @example
		 * displayHeight2EstimateWithHyphenTextually(0, 11)            // "11-inch"                    / "30-centimeter"
		 * displayHeight2EstimateWithHyphenTextually(1, 0)             // "one-foot"                   / "30-centimeter"
		 * displayHeight2EstimateWithHyphenTextually(0, 12)            // "one-foot"                   / "30-centimeter"
		 * displayHeight2EstimateWithHyphenTextually(2, 9.5)           // "two-foot ten-inch"          / "85-centimeter"
		 * displayHeight2EstimateWithHyphenTextually(1, 21.5)          // "two-foot ten-inch"          / "85-centimeter"
		 * displayHeight2EstimateWithHyphenTextually(3, 3.37)          // "three-foot three-inch"      / "one-meter"
		 * displayHeight2EstimateWithHyphenTextually(5)                // "five-foot"                  / "1.5-meter"
		 * displayHeight2EstimateWithHyphenTextually(5, 0, "and")      // "five-foot"                  / "1.5-meter"
		 * displayHeight2EstimateWithHyphenTextually(6, 2, "and")      // "six-foot and two-inch"      / "1.9-meter"
		 * displayHeight2EstimateWithHyphenTextually(6, 2, "and some") // "six-foot and some two-inch" / "1.9-meter"
		 * @param {Number} feet - The number of feet in the height value.
		 * @param {Number} [inches=0] - The number of inches in the height value.
		 * @param {String} [impStrSep=""] - A separator to add between the feet and the inches values.
		 * @return {String} A string of a height in text form and a unit, joined by a hyphen.
		 */
		public static function displayHeight2EstimateWithHyphenTextually(feet:Number, inches:Number = 0, impStrSep:String = ""):String {
			return displayHeightEstimateWithHyphen(feet * INCHES_IN_A_FOOT + inches, impStrSep, true);
		}

		// - For printing length in inches ----------

		/**
		 * Return a string of a length in inches or in centimeters, with the unit written in full form.
		 * @example
		 * displayInches(0.4, 1)   // "0.4 inches"   / "1 centimeter"
		 * displayInches(1)        // "1 inch"       / "3 centimeters"
		 * displayInches(1, 1)     // "1 inch"       / "2.5 centimeters"
		 * displayInches(2.1, 1)   // "2.1 inches"   / "5.3 centimeters"
		 * displayInches(3.125, 3) // "3.125 inches" / "7.938 centimeters"
		 * @param {Number} inches - A length in inches.
		 * @param {uint} [sig=0] - The number of significant digits after the decimal point to keep for the value.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		public static function displayInches(inches:Number, sig:uint = 0):String {
			return _displayInches(inches, sig, sig, false);
		}

		/**
		 * Return a string of a length in text form, in inches or in centimeters, with the unit written in full form.
		 * @example
		 * displayInchesTextually(0.4, 1)   // "0.4 inches"   / "one centimeter"
		 * displayInchesTextually(1)        // "one inch"     / "three centimeters"
		 * displayInchesTextually(1, 1)     // "one inch"     / "2.5 centimeters"
		 * displayInchesTextually(2.1, 1)   // "2.1 inches"   / "5.3 centimeters"
		 * displayInchesTextually(3.125, 3) // "3.125 inches" / "7.938 centimeters"
		 * @param {Number} inches - A length in inches.
		 * @param {uint} [sig=0] - The number of significant digits after the decimal point to keep for the value.
		 * @return {String} A string of a length in text form with the unit written in full form.
		 */
		public static function displayInchesTextually(inches:Number, sig:uint = 0):String {
			return _displayInches(inches, sig, sig, true);
		}

		/**
		 * Return a string of a qualified length in inches or in centimeters, with the unit written in full form.
		 * @example
		 * displayQualifiedInches(0.4, "tiny " 1)    // "0.4 tiny inches"   / "1 tiny centimeter"
		 * displayQualifiedInches(1, "")             // "1 inch"            / "3 centimeters"
		 * displayQualifiedInches(1, "magical-" 1)   // "1 magical-inch"    / "2.5 magical-centimeters"
		 * displayQualifiedInches(2.1, "thick ", 1)  // "2.1 thick inches"  / "5.3 thick centimeters"
		 * displayQualifiedInches(3.125, "cute ", 3) // "3.125 cute inches" / "7.938 cute centimeters"
		 * @param {Number} inches - A length in inches.
		 * @param {String} qualifier - A string to modifiy the qualitiy of the measurement unit; Should contain a trailing space to separate the qualifier and the unit.
		 * @param {uint} [sig=0] - The number of significant digits after the decimal point to keep for the value.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		public static function displayQualifiedInches(inches:Number, qualifier:String, sig:uint = 0): String {
			return _displayInches(inches, sig, sig, false, qualifier);
		}

		/**
		 * Return a string of a qualified length in text form, in inches or in centimeters, with the unit written in full form.
		 * @example
		 * displayQualifiedInchesTextually(0.4, "tiny " 1)    // "0.4 tiny inches"   / "one tiny centimeter"
		 * displayQualifiedInchesTextually(1, "")             // "one inch"          / "three centimeters"
		 * displayQualifiedInchesTextually(1, "magical-" 1)   // "one magical-inch"  / "2.5 magical-centimeters"
		 * displayQualifiedInchesTextually(2.1, "thick ", 1)  // "2.1 thick inches"  / "5.3 thick centimeters"
		 * displayQualifiedInchesTextually(3.125, "cute ", 3) // "3.125 cute inches" / "7.938 cute centimeters"
		 * @param {Number} inches - A length in inches.
		 * @param {String} qualifier - A string to modifiy the qualitiy of the measurement unit; Should contain a trailing space to separate the qualifier and the unit.
		 * @param {uint} [sig=0] - The number of significant digits after the decimal point to keep for the value.
		 * @return {String} A string of a length in text form with the unit written in full form.
		 */
		public static function displayQualifiedInchesTextually(inches:Number, qualifier:String, sig:uint = 0): String {
			return _displayInches(inches, sig, sig, true, qualifier);
		}

		/**
		 * Return a string of a range of lengths in inches or in centimeters, with the unit written in full form.
		 * @example
		 * displayInchesRange(0.5, " to ", 1, 1)         // "0.5 to 1 inch"         / "1.3 to 2.5 centimeters"
		 * displayInchesRange(1, " to ", 2)              // "1 to 2 inches"         / "3 to 5 centimeters"
		 * displayInchesRange(1, " to ", 2, 1)           // "1 to 2 inches"         / "2.5 to 5.1 centimeters"
		 * displayInchesRange(15.454, " to ", 23.816, 2) // "15.54 to 23.82 inches" / "39.25 to 60.49 centimeters"
		 * displayInchesRange(5, "-", 10)                // "5-10 inches"           / "12-25 centimeters"
		 * displayInchesRange(5, " and ", 10)            // "5 and 10 inches"       / "12 and 25 centimeters"
		 * @param {Number} inches1 - The first length value in inches of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} inches2 - The second length value in inches of the range.
		 * @param {uint} [sig=0] - A number of significant digits after the decimal point to keep for the two values.
		 * @return {String} A string of a range of lengths with the unit written in full form.
		 */
		public static function displayInchesRange(inches1:Number, strSep:String, inches2:Number, sig:uint = 0):String {
			return lengthInInches(inches1, sig) + strSep + displayInches(inches2, sig);
		}

		/**
		 * Return a string of a range of lengths in text form, in inches or in centimeters, with the unit written in full form.
		 * @example
		 * displayInchesRangeTextually(0.5, " to ", 1, 1)         // "0.5 to one inch"           / "1.3 to 2.5 centimeters"
		 * displayInchesRangeTextually(1, " to ", 2)              // "one to two inches"         / "three to five centimeters"
		 * displayInchesRangeTextually(1, " to ", 2, 1)           // "one to two inches"         / "2.5 to 5.1 centimeters"
		 * displayInchesRangeTextually(15.454, " to ", 23.816, 2) // "15.54 to 23.82 inches"     / "39.25 to 60.49 centimeters"
		 * displayInchesRangeTextually(5, "-", 10)                // "five-ten inches"           / "12-25 centimeters"
		 * displayInchesRangeTextually(5, " and ", 10)            // "five and ten inches"       / "12 and 25 centimeters"
		 * @param {Number} inches1 - The first length value in inches of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} inches2 - The second length value in inches of the range.
		 * @param {uint} [sig=0] - A number of significant digits after the decimal point to keep for the two values.
		 * @return {String} A string of a range of lengths in text form with the unit written in full form.
		 */
		public static function displayInchesRangeTextually(inches1:Number, strSep:String, inches2:Number, sig:uint = 0):String {
			return num2Text(lengthInInches(inches1, sig)) + strSep + displayInchesTextually(inches2, sig);
		}

		// - For printing length in inches with the unit written as a symbol -

		/**
		 * Return a string of a length in inches or in centimeters, with a specified string symbol.
		 * @example
		 * _displayInchesShort(0.4, " in", " cm", 1)       // "0.4 in"  / "1 cm"
		 * _displayInchesShort(1, " in", " cm")            // "1 in"    / "3 cm"
		 * _displayInchesShort(1.7665, " in", " cm", 0, 3) // "2 in"    / "4.487 cm"
		 * _displayInchesShort(56, " in", " cm")           // "56 in"   / "142 cm"
		 * _displayInchesShort(56, "in", "cm")             // "56in"    / "142cm"
		 * _displayInchesShort(56, "\"", " cm")            // «56"»     / «142 cm»
		 * _displayInchesShort(64.6, " in", " cm", 1, 1)   // "64.6 in" / "164.1 cm"
		 * @param {Number} inches - A length in inches.
		 * @param {String} impUnit - A string used for the symbol of the imperial unit.
		 * @param {String} siUnit - A string used for the symbol of the SI unit.
		 * @param {int} [impSig=0] - A number of significant digits after the decimal point to keep for the value in the imperial system.
		 * @param {int} [siSig=0] - A number of significant digits after the decimal point to keep for the value in the International System.
		 * @return {String} A string of a length with a specified symbol.
		 */
		private static function _displayInchesShort(inches:Number, impUnit:String, siUnit:String, impSig:int = 0, siSig:int = 0):String {
			var sig:uint = isSI() ? siSig : impSig;
			var value:Number = lengthInInches(inches, sig);
			var symbol:String = isSI() ? siUnit : impUnit;

			return value + symbol;
		}

		/**
		 * Return a string of a height in inches or in centimeters, with the unit written as a symbol.
		 * The value keeps 1 significant digit in inches, and 0 in centimeters.
		 * It uses «in» as the symbol for inch, and «cm» for centimeter.
		 * @example
		 * displayHeightInInchesShort(64.6) // "64.6 in" / "164 cm"
		 * displayHeightInInchesShort(70.5) // "70.5 in" / "179 cm"
		 * @param {Number} inches - A height in inches.
		 * @return {String} A string of a height with the unit written as a symbol.
		 */
		public static function displayHeightInInchesShort(inches:Number):String {
			return _displayInchesShort(inches, " in", " cm", 1, 0);
		}

		/**
		 * Return a string of a height in inches or in centimeters, with the unit written as a symbol.
		 * The value keeps 1 significant digit in inches, and 0 in centimeters.
		 * It uses the double quotes «"» as the symbol for inch, and «cm» for centimeter.
		 * @example
		 * displayHeightInInchesShort2(64.6) // «64.6"» / «164 cm»
		 * displayHeightInInchesShort2(70.5) // «70.5"» / «179 cm»
		 * @param {Number} inches - A height in inches.
		 * @return {String} A string of a height with the unit written as a symbol.
		 */
		public static function displayHeightInInchesShort2(inches:Number):String {
			return _displayInchesShort(inches, "\"", " cm", 1, 0);
		}

		/**
		 * Return a string of a length in inches or centimeters, with the unit written as a symbol.
		 * The value keeps 1 significant digit for both inches and centimeters.
		 * It uses «in» as the symbol for inch, and «cm» for centimeter.
		 * @example
		 * displayInchesShort(64.6) // "64.6 in" / "164.1 cm"
		 * displayInchesShort(70.5) // "70.5 in" / "179.1 cm"
		 * @param {Number} inches - A length in inches.
		 * @return {String} A string of a length with the unit written as a symbol.
		 */
		public static function displayInchesShort(inches:Number):String {
			return _displayInchesShort(inches, " in", " cm", 1, 1);
		}

		/**
		 * Return a string of a length in inches or in centimeters, with the unit written as a symbol.
		 * The value keeps 1 significant digit for both inches and centimeters.
		 * It uses the double quotes «"» as the symbol for inch, and «cm» for centimeter.
		 * @example
		 * displayHeightInInchesShort2(64.6) // «64.6"» / «164.1 cm»
		 * displayHeightInInchesShort2(70.5) // «70.5"» / «179.1 cm»
		 * @param {Number} inches - A length in inches.
		 * @return {String} A string of a length with the unit written as a symbol.
		 */
		public static function displayInchesShort2(inches:Number):String {
			return _displayInchesShort(inches, "\"", " cm", 1, 1);
		}

		/**
		 * Return a string of a range of lengths in inches or in centimeters, with the unit written as a symbol.
		 * @example
		 * displayInchesRangeShort2(1, " to ", 2)              // «1 to 2"»         / «3 to 5 cm»
		 * displayInchesRangeShort2(1, " to ", 2, 1)           // «1 to 2"»         / «2.5 to 5.1 cm»
		 * displayInchesRangeShort2(15.454, " to ", 23.816, 2) // «15.45 to 23.82"» / «39.25 to 60.49 cm»
		 * displayInchesRangeShort2(5, "-", 10)                // «5-10"»           / «12-25 cm»
		 * displayInchesRangeShort2(5, " and ", 10)            // «5 and 10"»       / «12 and 25 cm»
		 * @param {Number} inches1 - The first length value in inches of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} inches2 - The second length value in inches of the range.
		 * @param {uint} [sig=0] - A number of significant digits after the decimal point to keep for the two values.
		 * @return {String} A string of a range of lengths with the unit written as a symbol.
		 */
		public static function displayInchesRangeShort2(inches1:Number, strSep:String, inches2:Number, sig:int = 0):String {
			return lengthInInches(inches1, sig) + strSep + _displayInchesShort(inches2, "\"", " cm", sig, sig);
		}

		// - For printing approximation of length in inches

		/**
		 * Return a length in inches or an approximation in centimeters.
		 * Use the approximation that 1 inch is 2.5 centimeters.
		 * @example
		 * _inchesToCentimetersApproximation(1)        // 1    / 3
		 * _inchesToCentimetersApproximation(1, 1)     // 1    / 2.5
		 * _inchesToCentimetersApproximation(1, 2)     // 1    / 2.5
		 * _inchesToCentimetersApproximation(2.125)    // 2    / 5
		 * _inchesToCentimetersApproximation(2.125, 2) // 2.13 / 5.31
		 * _inchesToCentimetersApproximation(12)       // 12   / 30
		 * _inchesToCentimetersApproximation(15)       // 15   / 38
		 * _inchesToCentimetersApproximation(15, 1)    // 15   / 37.5
		 * _inchesToCentimetersApproximation(20)       // 20   / 50
		 * @param {Number} inches - A length in inches.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {Number} A length value in inches or in centimeters.
		 */
		private static function _inchesToCentimetersApproximation(inches:Number, sig:int = 0):Number {
			return formatFloat((isSI() ? inches * INCH_TO_METER_APPROX / SI_PREFIX_CENTI_FACTOR : inches), sig);
		}

		/**
		 * Return a string of a length in inches or an approximation in centimeters, with the unit written in full form.
		 * @example
		 * _displayInchesEstimate(0.4)     // "0 inch"    / "1 centimeter"
		 * _displayInchesEstimate(0.52)    // "1 inch"    / "1 centimeter"
		 * _displayInchesEstimate(1, true) // "one inch"  / "three centimeters"
		 * _displayInchesEstimate(5)       // "5 inches"  / "13 centimeters"
		 * _displayInchesEstimate(11)      // "11 inches" / "28 centimeters"
		 * @param {Number} inches - A length in inches.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		private static function _displayInchesEstimate(inches:Number, useNum2Text:Boolean = false):String {
			var value:Number = _inchesToCentimetersApproximation(inches, 0);
			var symbol:String = isSI() ? "centimeter" : "inch";
			if (!(value == 1 || value == 0)) symbol += isSI() ? "s" : "es";

			return (useNum2Text ? num2Text(value) : value) + " " + symbol;
		}

		/**
		 * Return a string of a length in inches or an approximation in centimeters, with the unit written in full form.
		 * @example
		 * displayInchesEstimate(0.4)  // "0 inch"    / "1 centimeter"
		 * displayInchesEstimate(0.52) // "1 inch"    / "1 centimeter"
		 * displayInchesEstimate(1)    // "1 inch"    / "3 centimeters"
		 * displayInchesEstimate(5)    // "5 inches"  / "13 centimeters"
		 * displayInchesEstimate(11)   // "11 inches" / "28 centimeters"
		 * @param {Number} inches - A length in inches.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		public static function displayInchesEstimate(inches:Number):String {
			return _displayInchesEstimate(inches, false);
		}

		/**
		 * Return a string of a length in text form, in inches or an approximation in centimeters, with the unit written in full form.
		 * @example
		 * displayInchesEstimateTextually(0.4)  // "zero inch"   / "one centimeter"
		 * displayInchesEstimateTextually(0.52) // "one inch"    / "one centimeter"
		 * displayInchesEstimateTextually(1)    // "one inch"    / "three centimeters"
		 * displayInchesEstimateTextually(5)    // "five inches" / "13 centimeters"
		 * displayInchesEstimateTextually(11)   // "11 inches"   / "28 centimeters"
		 * @param {Number} inches - A length in inches.
		 * @return {String} A string of a length in text form with the unit written in full form.
		 */
		public static function displayInchesEstimateTextually(inches:Number):String {
			return _displayInchesEstimate(inches, true);
		}

		/**
		 * Return a string of a range of lengths in inches or an approximation in centimeters, with the unit written in full form.
		 * @example
		 * displayInchesEstimateRange(0.5, " to ", 1)         // "1 to 1 inch"     / "1 to 3 centimeters"
		 * displayInchesEstimateRange(1, " to ", 2)           // "1 to 2 inches"   / "3 to 5 centimeters"
		 * displayInchesEstimateRange(15.454, " to ", 23.816) // "15 to 24 inches" / "39 to 60 centimeters"
		 * displayInchesEstimateRange(5, "-", 10)             // "5-10 inches"     / "13-25 centimeters"
		 * displayInchesEstimateRange(5, " and ", 10)         // "5 and 10 inches" / "13 and 25 centimeters"
		 * @param {Number} inches1 - The first length value in inches of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} inches2 - The second length value in inches of the range.
		 * @return {String} A string of a range of lengths with the unit written in full form.
		 */
		public static function displayInchesEstimateRange(inches1:Number, strSep:String, inches2:Number):String {
			return _inchesToCentimetersApproximation(inches1, 0) + strSep + displayInchesEstimate(inches2);
		}

		/**
		 * Return a string of a range of lengths in text form, in inches or an approximation in centimeters, with the unit written in full form.
		 * @example
		 * displayInchesEstimateRangeTextually(0.5, " to ", 1)         // "one to one inch"     / "one to three centimeters"
		 * displayInchesEstimateRangeTextually(1, " to ", 2)           // "one to two inches"   / "three to five centimeters"
		 * displayInchesEstimateRangeTextually(15.454, " to ", 23.816) // "15 to 24 inches"     / "39 to 60 centimeters"
		 * displayInchesEstimateRangeTextually(5, "-", 10)             // "five-ten inches"     / "13-25 centimeters"
		 * displayInchesEstimateRangeTextually(5, " and ", 10)         // "five and ten inches" / "13 and 25 centimeters"
		 * @param {Number} inches1 - The first length value in inches of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} inches2 - The second length value in inches of the range.
		 * @return {String} A string of a range of lengths in text form with the unit written in full form.
		 */
		public static function displayInchesEstimateRangeTextually(inches1:Number, strSep:String, inches2:Number):String {
			return num2Text(_inchesToCentimetersApproximation(inches1, 0)) + strSep + displayInchesEstimateTextually(inches2);
		}

		/**
		 * Return a string of a length in inches or in centimeters, with a hyphen between the numeric value and the unit.
		 * @example
		 * _displayInchEstimateWithHyphen(1.1)     // "1-inch"   / "3-inch"
		 * _displayInchEstimateWithHyphen(2, true) // "two-inch" / "five-inch"
		 * _displayInchEstimateWithHyphen(3.2)     // "3-inch"   / "8-centimeter"
		 * _displayInchEstimateWithHyphen(4.378)   // "4-inch"   / "11-centimeter"
		 * @param {Number} inches - A length in inches.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a length and a unit, joined by a hyphen.
		 */
		private static function _displayInchEstimateWithHyphen(inches:Number, useNum2Text:Boolean = false):String {
			var value:Number = _inchesToCentimetersApproximation(inches, 0);

			return (useNum2Text ? num2Text(value) : value) + "-" + (isSI() ? "centimeter" : "inch");
		}

		/**
		 * Return a string of a length in inches or in centimeters, with a hyphen between the numeric value and the unit.
		 * @example
		 * displayInchEstimateWithHyphen(1.1)   // "1-inch" / "3-inch"
		 * displayInchEstimateWithHyphen(2)     // "2-inch" / "5-inch"
		 * displayInchEstimateWithHyphen(3.2)   // "3-inch" / "8-centimeter"
		 * displayInchEstimateWithHyphen(4.378) // "4-inch" / "11-centimeter"
		 * @param {Number} inches - A length in inches.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a length and a unit, joined by a hyphen.
		 */
		public static function displayInchEstimateWithHyphen(inches:Number):String {
			return _displayInchEstimateWithHyphen(inches, false);
		}

		/**
		 * Return a string of a length in text form, in inches or in centimeters, with a hyphen between the numeric value and the unit.
		 * @example
		 * displayInchEstimateWithHyphenTextually(1.1)   // "one-inch"   / "three-inch"
		 * displayInchEstimateWithHyphenTextually(2)     // "two-inches" / "five-inches"
		 * displayInchEstimateWithHyphenTextually(3.2)   // "three-inch" / "eight-centimeter"
		 * displayInchEstimateWithHyphenTextually(4.378) // "four-inch"  / "11-centimeter"
		 * @param {Number} inches - A length in inches.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a length in text form and a unit, joined by a hyphen.
		 */
		public static function displayInchEstimateWithHyphenTextually(inches:Number):String {
			return _displayInchEstimateWithHyphen(inches, true);
		}

		// - For printing length in inches with a hyphen between the value and the unit -

		/**
		 * Return a string of a length in inches or in centimeters, and a speficied string symbol, joined by a hyphen.
		 * @todo Delegate the calculation of the length to the caller of the function, to fix the weirdness below, i.e. the same unit used by both measurement system.
		 * @example
		 * _displayInchWithHyphen(1.1, "-inch", false, 1)         // "1.1-inch"         / "2.8-inch"
		 * _displayInchWithHyphen(2, "-inches", true)             // "two-inches"       / "five-inches"
		 * _displayInchWithHyphen(3.2, "-inch")                   // "3-inch"           / "8-inch"
		 * _displayInchWithHyphen(4.378, "-centimeter", false, 3) // "4.378-centimeter" / "11.121-centimeter"
		 * @param {Number} inches - A length in inches.
		 * @param {String} symbol - The unit's symbol displayed with the value.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a length and a unit, joined by a hyphen.
		 */
		private static function _displayInchWithHyphen(inches:Number, symbol:String, useNum2Text:Boolean = false, sig:int = 0):String {
			var value:Number = lengthInInches(inches, sig);
			return (useNum2Text ? num2Text(value) : value) + "-" + symbol;
		}

		/**
		 * Return a string of a length in inches or in centimeters, with a hypen between the numeric value and the symbol.
		 * @example
		 * displayInchWithHyphen(1.1, 1)     // "1.1-inch"   / "2.8-centimeter"
		 * displayInchWithHyphen(2, 0, true) // "two-inch"   / "five-centimeter"
		 * displayInchWithHyphen(3.2)        // "3-inch"     / "8-centimeter"
		 * displayInchWithHyphen(4.378, 3)   // "4.378-inch" / "11.121-centimeter"
		 * @param {Number} inches - A length in inches.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a length and a unit, joined by a hyphen.
		 */
		public static function displayInchWithHyphen(inches:Number, sig:int = 0, useNum2Text:Boolean = false):String {
			return _displayInchWithHyphen(inches, literalInch(), useNum2Text, sig);
		}

		/**
		 * Return a string of a length in text form, in inches or in centimeters, with a hypen between the numeric value and the symbol.
		 * @example
		 * displayInchWithHyphenTextually(1.1, 1)     // "1.1-inch"   / "2.8-centimeter"
		 * displayInchWithHyphenTextually(2)          // "two-inch"   / "five-centimeter"
		 * displayInchWithHyphenTextually(3.2)        // "three-inch" / "eight-centimeter"
		 * displayInchWithHyphenTextually(4.378, 3)   // "4.378-inch" / "11.121-centimeter"
		 * @param {Number} inches - A length in inches.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a length in text form and a unit, joined by a hyphen.
		 */
		public static function displayInchWithHyphenTextually(inches:Number, sig:int = 0):String {
			return displayInchWithHyphen(inches, sig, true);
		}

		// - For printing length in feet ----------

		/**
		 * Return a string of a length in feet or in meters/centimeters, with the unit written in full form.
		 * @example
		 * _displayFeet(0.2, 1, 1)     // "0.2 feet"   / "6.1 centimeters"
		 * _displayFeet(1, 1, 1)       // "1 foot"     / "30.5 centimeters"
		 * _displayFeet(4.5213, 3, 3)  // "4.521 feet" / "1.378 meters"
		 * _displayFeet(5.1, 0, 1)     // "5 feet"     / "1.6 meters"
		 * _displayFeet(6, 0, 0, true) // "six feet"   / "two meters"
		 * _displayFeet(30, 0, 1)      // "30 feet"    / "9.1 meters"
		 * _displayFeet(100, 1, 1)     // "100 feet"   / "30.5 meters"
		 * @param {Number} feet - A length in feet.
		 * @param {int} [impSig=0] - A number of significant digits after the decimal point to keep for the value in the imperial system.
		 * @param {int} [siSig=0] - A number of significant digits after the decimal point to keep for the value in the International System.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @param {String} [qualifier=""] - A string to modifiy the qualitiy of the measurement unit; Should contain a trailing space to separate the qualifier and the unit.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		private static function _displayFeet(feet:Number, impSig:int = 0, siSig:int = 0, useNum2Text:Boolean = false, qualifier:String = ""):String {
			var sig:uint = isSI() ? siSig : impSig;
			var value:Number = lengthInFeet(feet, sig);
			var symbol:String = "";
			if (isSI()) {
				// If the value is inferior to 100, display it in centimeters
				if (value < 1 / SI_PREFIX_CENTI_FACTOR) {
					 symbol = "centi";
					} else value = formatFloat(value * SI_PREFIX_CENTI_FACTOR, sig);
					symbol += "meter" + (!(value == 1 || value == 0) ? "s" : "");
			} else symbol = "f" + (!(value == 1 || value == 0) ? "ee" : "oo") + "t";

			return (useNum2Text ? num2Text(value) : value) + " " + qualifier + symbol;
		}

		/**
		 * Return a string of a length in feet or in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayFeet(0.2, 1)    // "0.2 feet"   / "6.1 centimeters"
		 * displayFeet(1, 1)      // "1 foot"     / "30.5 centimeters"
		 * displayFeet(4.5213, 3) // "4.521 feet" / "1.378 meters"
		 * displayFeet(5.1)       // "5 feet"     / "2 meters"
		 * displayFeet(6)         // "6 feet"     / "2 meters"
		 * displayFeet(30)        // "30 feet"    / "9 meters"
		 * displayFeet(100, 1)    // "100 feet"   / "30.5 meters"
		 * @param {Number} feet - A length in feet.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		public static function displayFeet(feet:Number, sig:int = 0):String {
			return _displayFeet(feet, sig, sig);
		}

		/**
		 * Return a string of a length in text form, in feet or in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayFeetTextually(0.2, 1)    // "0.2 feet"   / "6.1 centimeters"
		 * displayFeetTextually(1, 1)      // "one foot"   / "30.5 centimeters"
		 * displayFeetTextually(4.5213, 3) // "4.521 feet" / "1.378 meters"
		 * displayFeetTextually(5.1)       // "five feet"  / "two meters"
		 * displayFeetTextually(6)         // "six feet"   / "two meters"
		 * displayFeetTextually(30)        // "30 feet"    / "nine meters"
		 * displayFeetTextually(100, 1)    // "100 feet"   / "30.5 meters"
		 * @param {Number} feet - A length in feet.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a length in text form with the unit written in full form.
		 */
		public static function displayFeetTextually(feet:Number, sig:int = 0):String {
			return _displayFeet(feet, sig, sig, true);
		}

		/**
		 * Return a string of a qualified length in feet or in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayQualifiedFeet(0.2, "cute " 1)      // "0.2 cute feet"     / "6.1 cute centimeters"
		 * displayQualifiedFeet(1, "", 1)            // "1 foot"            / "30.5 centimeters"
		 * displayQualifiedFeet(4.5213, "of fat " 3) // "4.521 of fat feet" / "1.378 of fat meters"
		 * displayQualifiedFeet(5.1, "huge ")        // "5 huge feet"       / "2 huge meters"
		 * displayQualifiedFeet(6, "turgid ")        // "6 turgid feet"     / "2 turgid meters"
		 * displayQualifiedFeet(30, "terran-")       // "30 terran-feet"    / "9 terran-meters"
		 * displayQualifiedFeet(100, "distant ", 1)  // "100 distant feet"  / "30.5 distant meters"
		 * @param {Number} feet - A length in feet.
		 * @param {String} qualifier - A string to modifiy the qualitiy of the measurement unit; Should contain a trailing space to separate the qualifier and the unit.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		public static function displayQualifiedFeet(feet:Number, qualifier:String, sig:int = 0):String {
			return _displayFeet(feet, sig, sig, false, qualifier);
		}

		/**
		 * Return a string of a qualified length in text form, in feet or in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayQualifiedFeetTextually(0.2, "cute " 1)      // "0.2 cute feet"     / "6.1 cute centimeters"
		 * displayQualifiedFeetTextually(1, "", 1)            // "1 foot"            / "30.5 centimeters"
		 * displayQualifiedFeetTextually(4.5213, "of fat " 3) // "4.521 of fat feet" / "1.378 of fat meters"
		 * displayQualifiedFeetTextually(5.1, "huge ")        // "5 huge feet"       / "2 huge meters"
		 * displayQualifiedFeetTextually(6, "turgid ")        // "6 turgid feet"     / "2 turgid meters"
		 * displayQualifiedFeetTextually(30, "terran-")       // "30 terran-feet"    / "9 terran-meters"
		 * displayQualifiedFeetTextually(100, "distant ", 1)  // "100 distant feet"  / "30.5 distant meters"
		 * @param {Number} feet - A length in feet.
		 * @param {String} qualifier - A string to modifiy the qualitiy of the measurement unit; Should contain a trailing space to separate the qualifier and the unit.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a length in text form with the unit written in full form.
		 */
		public static function displayQualifiedFeetTextually(feet:Number, qualifier:String, sig:int = 0):String {
			return _displayFeet(feet, sig, sig, true, qualifier);
		}

		/**
		 * Return a string of a range of lengths in feet or in meters/centimeters, with the unit written in full form.
		 * @example
		 * _displayFeetRange(1, " to ", 2)              // "1 to 2 feet"         / "30 to 61 centimeters"
		 * _displayFeetRange(2, " to ", 4)              // "2 to 4 feet"         / "0.6 to 1 meter"
		 * _displayFeetRange(2, " to ", 4, 1)           // "2 to 4 feet"         / "0.6 to 1.2 meters"
		 * _displayFeetRange(2, " to ", 4, 2)           // "2 to 4 feet"         / "0.61 to 1.22 meters"
		 * _displayFeetRange(3, "-", 6, 0, true)        // "three-six feet"      / "one-two meters"
		 * _displayFeetRange(30, " and ", 40, 1)        // "30 and 40 feet"      / "9 and 12 meters"
		 * _displayFeetRange(20, "-", 35, 1)            // "20-35 feet"          / "6.1-10.7 meters"
		 * _displayFeetRange(14.621, " to ", 18.379, 2) // "14.62 to 18.38 feet" / "4.46 to 5.6 meters"
		 * @param {Number} feet1 - The first length value in feet of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} feet2 - The second length value in feet of the range.
		 * @param {uint} [sig=0] - A number of significant digits after the decimal point to keep for the two values.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a range of lengths with the unit written in full form.
		 */
		private static function _displayFeetRange(feet1:Number, strSep:String, feet2:Number, sig:int = 0, useNum2Text:Boolean = false):String {
			var value1:Number = lengthInFeet(feet1, sig);
			var value2:Number = lengthInFeet(feet2, sig);
			var unit:String;
			if(isSI()) {
				unit = "meter";
				if (value2 < 1 / SI_PREFIX_CENTI_FACTOR) {
					unit = "centi" + unit;
				} else {
					value2 = formatFloat(value2 * SI_PREFIX_CENTI_FACTOR, sig);
					value1 = formatFloat(
						value1 * SI_PREFIX_CENTI_FACTOR,
						value1 < 1 / SI_PREFIX_CENTI_FACTOR && sig == 0 ? 1 : sig
					);
				}
				unit += (value2 != 1 && value2 != 0 ? "s" : "");
			} else {
				unit = "f" + (value2 != 1 && value2 != 0 ? "ee" : "oo") + "t";
			}

			return (useNum2Text ? num2Text(value1) : value1) + strSep + (useNum2Text ? num2Text(value2) : value2) + " " + unit;
		}

		/**
		 * Return a string of a range of lengths in feet or in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayFeetRange(1, " to ", 2)              // "1 to 2 feet"         / "30 to 61 centimeters"
		 * displayFeetRange(2, " to ", 4)              // "2 to 4 feet"         / "0.6 to 1 meter"
		 * displayFeetRange(2, " to ", 4, 1)           // "2 to 4 feet"         / "0.6 to 1.2 meters"
		 * displayFeetRange(2, " to ", 4, 2)           // "2 to 4 feet"         / "0.61 to 1.22 meters"
		 * displayFeetRange(3, "-", 6, 0)              // "3-6 feet"            / "1-2 meters"
		 * displayFeetRange(30, " and ", 40, 1)        // "30 and 40 feet"      / "9 and 12 meters"
		 * displayFeetRange(20, "-", 35, 1)            // "20-35 feet"          / "6.1-10.7 meters"
		 * displayFeetRange(14.621, " to ", 18.379, 2) // "14.62 to 18.38 feet" / "4.46 to 5.6 meters"
		 * @param {Number} feet1 - The first length value in feet of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} feet2 - The second length value in feet of the range.
		 * @param {uint} [sig=0] - A number of significant digits after the decimal point to keep for the two values.
		 * @return {String} A string of a range of lengths with the unit written in full form.
		 */
		public static function displayFeetRange(feet1:Number, strSep:String, feet2:Number, sig:int = 0):String {
			return _displayFeetRange(feet1, strSep, feet2, sig, false);
		}

		/**
		 * Return a string of a range of lengths in text form, in feet or in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayFeetRangeTextually(1, " to ", 2)              // "one to two feet"     / "30 to 61 centimeters"
		 * displayFeetRangeTextually(2, " to ", 4)              // "two to four feet"    / "0.6 to one meter"
		 * displayFeetRangeTextually(2, " to ", 4, 1)           // "two to four feet"    / "0.6 to 1.2 meters"
		 * displayFeetRangeTextually(2, " to ", 4, 2)           // "two to four feet"    / "0.61 to 1.22 meters"
		 * displayFeetRangeTextually(3, "-", 6, 0)              // "three-six feet"      / "one-two meters"
		 * displayFeetRangeTextually(30, " and ", 40, 1)        // "30 and 40 feet"      / "nine and 12 meters"
		 * displayFeetRangeTextually(20, "-", 35, 1)            // "20-35 feet"          / "6.1-10.7 meters"
		 * displayFeetRangeTextually(14.621, " to ", 18.379, 2) // "14.62 to 18.38 feet" / "4.46 to 5.6 meters"
		 * @param {Number} feet1 - The first length value in feet of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} feet2 - The second length value in feet of the range.
		 * @param {uint} [sig=0] - A number of significant digits after the decimal point to keep for the two values.
		 * @return {String} A string of a range of lengths in text form with the unit written in full form.
		 */
		public static function displayFeetRangeTextually(feet1:Number, strSep:String, feet2:Number, sig:int = 0):String {
			return _displayFeetRange(feet1, strSep, feet2, sig, true);
		}


		// - For printing approximation of length in feet -

		/**
		 * Return a length in feet or an approximation in centimeters.
		 * Use the approximation that 1 foot is 30 centimeters, instead of 30.48 centimeters.
		 * @example
		 * _feetToCentimeterApproximation(1)        // 1     / 30
		 * _feetToCentimeterApproximation(4.521, 3) // 4.521 / 140
		 * _feetToCentimeterApproximation(5)        // 5     / 150
		 * _feetToCentimeterApproximation(30)       // 90    / 900
		 * _feetToCentimeterApproximation(100)      // 100   / 3000
		 * @param {Number} feet - A length in feet.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {Number} A length value in feet or in centimeters.
		 */
		private static function _feetToCentimeterApproximation(feet:Number, sig:int = 0):Number {
			var value:Number = feet;

			if (isSI()) {
				value = feet * FOOT_TO_METER_APPROX / SI_PREFIX_CENTI_FACTOR;

				if (!(value < 1 / SI_PREFIX_CENTI_FACTOR)) {
					value = value * SI_PREFIX_CENTI_FACTOR;

					if (value > 100) {
						var optValue:Object = _optimizePrefix(value, SI_PREFIX_MILLI_POWER, SI_MAX_PREFIX_POWER, 1);
						var roundingFactor:int = Math.pow(10, optValue.power - 1);

						value = formatFloat(value / roundingFactor) * roundingFactor;
					} else if (value > 20) {
						value = formatFloat(value / 5) * 5;
					} else if (value > 3) {
						value = formatFloat(value);
					} else {
						value = formatFloat(value, 1);
					}

					value = value / SI_PREFIX_CENTI_FACTOR;
				}
			}

			return formatFloat(value, sig);
		}

		/**
		 * Return a string of a length in feet or an approximation in meters/centimeters, with the unit written in full form.
		 * @example
		 * _displayFeetEstimate(0.2)       // "0 foot"     / "6 centimeters"
		 * _displayFeetEstimate(1)         // "1 foot"     / "30 centimeters"
		 * _displayFeetEstimate(4.7)       // "5 feet"     / "1.4 meters"
		 * _displayFeetEstimate(5)         // "5 feet"     / "1.5 meters"
		 * _displayFeetEstimate(6.7, true) // "seven feet" / "two meters"
		 * _displayFeetEstimate(30)        // "30 feet"    / "9 meters"
		 * _displayFeetEstimate(100)       // "100 feet"   / "30 meters"
		 * _displayFeetEstimate(5555)      // "5555 feet"  / "1600 meters"
		 * @param {Number} feet - A length in feet.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @param {String} [qualifier=""] - A string to modifiy the qualitiy of the measurement unit; Should contain a trailing space to separate the qualifier and the unit.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		private static function _displayFeetEstimate(feet:Number, useNum2Text:Boolean = false, qualifier:String = ""):String {
			var value:Number = _feetToCentimeterApproximation(feet, 0);
			var symbol:String = "";
			if (isSI()) {
				// If the value is inferior to 100, display it in centimeters
				if (value < 1 / SI_PREFIX_CENTI_FACTOR) {
					 symbol = "centi";
					} else value = formatFloat(value * SI_PREFIX_CENTI_FACTOR, 1);
					symbol += "meter" + (!(value == 1 || value == 0) ? "s" : "");
			} else symbol = "f" + (!(value == 1 || value == 0) ? "ee" : "oo") + "t";

			return (useNum2Text ? num2Text(value) : value) + " " + qualifier + symbol;
		}

		/**
		 * Return a string of a length in feet or an approximation in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayFeetEstimate(0.2)  // "0 foot"    / "6 centimeters"
		 * displayFeetEstimate(1)    // "1 foot"    / "30 centimeters"
		 * displayFeetEstimate(4.7)  // "5 feet"    / "1.4 meters"
		 * displayFeetEstimate(5)    // "5 feet"    / "1.5 meters"
		 * displayFeetEstimate(6.7)  // "7 feet"    / "2 meters"
		 * displayFeetEstimate(30)   // "30 feet"   / "9 meters"
		 * displayFeetEstimate(100)  // "100 feet"  / "30 meters"
		 * displayFeetEstimate(5555) // "5555 feet" / "1600 meters"
		 * @param {Number} feet - A length in feet.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		public static function displayFeetEstimate(feet:Number):String {
			return _displayFeetEstimate(feet, false);
		}

		/**
		 * Return a string of a length in text form, in feet or an approximation in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayFeetEstimateTextually(0.2)  // "zero foot"  / "six centimeters"
		 * displayFeetEstimateTextually(1)    // "one foot"   / "30 centimeters"
		 * displayFeetEstimateTextually(4.7)  // "five feet"  / "1.4 meters"
		 * displayFeetEstimateTextually(5)    // "five feet"  / "1.5 meters"
		 * displayFeetEstimateTextually(6.7)  // "seven feet" / "two meters"
		 * displayFeetEstimateTextually(30)   // "30 feet"    / "nine meters"
		 * displayFeetEstimateTextually(100)  // "100 feet"   / "30 meters"
		 * displayFeetEstimateTextually(5555) // "5555 feet"  / "1600 meters"
		 * @param {Number} feet - A length in feet.
		 * @return {String} A string of a length in text form with the unit written in full form.
		 */
		public static function displayFeetEstimateTextually(feet:Number):String {
			return _displayFeetEstimate(feet, true);
		}

		/**
		 * Return a string of a qualified length in feet or an approximation in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayQualifiedFeetEstimate(0.2, "cute ")     // "0 cute foot"       / "6 cute centimeters"
		 * displayQualifiedFeetEstimate(1, "")            // "1 foot"            / "30 centimeters"
		 * displayQualifiedFeetEstimate(4.7, "of fat ")   // "5 of fat feet"     / "1.4 of fat meters"
		 * displayQualifiedFeetEstimate(5, "huge ")       // "5 huge feet"       / "1.5 huge meters"
		 * displayQualifiedFeetEstimate(6.7, "turgid ")   // "7 turgid feet"     / "2 turgid meters"
		 * displayQualifiedFeetEstimate(30, "terran-")    // "30 terran-feet"    / "9 terran-meters"
		 * displayQualifiedFeetEstimate(100, "distant ")  // "100 distant feet"  / "30 distant meters"
		 * displayQualifiedFeetEstimate(5555, "faraway ") // "5555 faraway feet" / "1600 faraway meters"
		 * @param {Number} feet - A length in feet.
		 * @param {String} qualifier - A string to modifiy the qualitiy of the measurement unit; Should contain a trailing space to separate the qualifier and the unit.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		public static function displayQualifiedFeetEstimate(feet:Number, qualifier:String):String {
			return _displayFeetEstimate(feet, false, qualifier);
		}

		/**
		 * Return a string of a qualified length in text form, in feet or an approximation in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayQualifiedFeetEstimateTextually(0.2, "cute ")     // "zero cute foot"    / "six cute centimeters"
		 * displayQualifiedFeetEstimateTextually(1, "")            // "one foot"          / "30 centimeters"
		 * displayQualifiedFeetEstimateTextually(4.7, "of fat ")   // "five of fat feet"  / "1.4 of fat meters"
		 * displayQualifiedFeetEstimateTextually(5, "huge ")       // "five huge feet"    / "1.5 huge meters"
		 * displayQualifiedFeetEstimateTextually(6.7, "turgid ")   // "seven turgid feet" / "two turgid meters"
		 * displayQualifiedFeetEstimateTextually(30, "terran-")    // "30 terran-feet"    / "nine terran-meters"
		 * displayQualifiedFeetEstimateTextually(100, "distant ")  // "100 distant feet"  / "30 distant meters"
		 * displayQualifiedFeetEstimateTextually(5555, "faraway ") // "5555 faraway feet" / "1600 faraway meters"
		 * @param {Number} feet - A length in feet.
		 * @param {String} qualifier - A string to modifiy the qualitiy of the measurement unit; Should contain a trailing space to separate the qualifier and the unit.
		 * @return {String} A string of a length in text form with the unit written in full form.
		 */
		public static function displayQualifiedFeetEstimateTextually(feet:Number, qualifier:String):String {
			return _displayFeetEstimate(feet, true, qualifier);
		}
		/**
		 * Return a string of a range of lengths in feet or an approximation in meters/centimeters, with the unit written in full form.
		 * @example
		 * _displayFeetEstimateRange(1, " to ", 2)           // "1 to 2 feet"      / "30 to 60 centimeters"
		 * _displayFeetEstimateRange(2, " to ", 4)           // "2 to 4 feet"      / "0.6 to 1.2 meters"
		 * _displayFeetEstimateRange(2, " to ", 4, true)     // "two to four feet" / "0.6 to 1.2 meters"
		 * _displayFeetEstimateRange(3, "-", 6, true)        // "three-six feet"   / "0.9-1.8 meters"
		 * _displayFeetEstimateRange(30, " and ", 40)        // "30 and 40 feet"   / "9 and 12 meters"
		 * _displayFeetEstimateRange(20, "-", 35)            // "20-35 feet"       / "6-11 meters"
		 * _displayFeetEstimateRange(14.621, " to ", 18.379) // "15 to 18 feet"    / "4.4 to 6 meters"
		 * @param {Number} feet1 - The first length value in feet of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} feet2 - The second length value in feet of the range.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a range of lengths with the unit written in full form.
		 */
		private static function _displayFeetEstimateRange(feet1:Number, strSep:String, feet2:Number, useNum2Text:Boolean = false):String {
			var value1:Number = _feetToCentimeterApproximation(feet1, 0);
			var value2:Number = _feetToCentimeterApproximation(feet2, 0);
			var unit:String;
			if(isSI()) {
				unit = "meter";
				if (value2 < 1 / SI_PREFIX_CENTI_FACTOR) {
					unit = "centi" + unit;
				} else {
					value2 = formatFloat(value2 * SI_PREFIX_CENTI_FACTOR, 1);
					value1 = formatFloat(value1 * SI_PREFIX_CENTI_FACTOR, 1);
				}
				unit += (value2 != 1 && value2 != 0 ? "s" : "");
			} else {
				unit = "f" + (value2 != 1 && value2 != 0 ? "ee" : "oo") + "t";
			}

			return (useNum2Text ? num2Text(value1) : value1) + strSep + (useNum2Text ? num2Text(value2) : value2) + " " + unit;
		}

		/**
		 * Return a string of a range of lengths in feet or an approximation in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayFeetEstimateRange(1, " to ", 2)           // "1 to 2 feet"    / "30 to 60 centimeters"
		 * displayFeetEstimateRange(2, " to ", 4)           // "2 to 4 feet"    / "0.6 to 1.2 meters"
		 * displayFeetEstimateRange(3, "-", 6)              // "3-6 feet"       / "0.9-1.8 meters"
		 * displayFeetEstimateRange(30, " and ", 40)        // "30 and 40 feet" / "9 and 12 meters"
		 * displayFeetEstimateRange(20, "-", 35)            // "20-35 feet"     / "6-11 meters"
		 * displayFeetEstimateRange(14.621, " to ", 18.379) // "15 to 18 feet"  / "4.4 to 6 meters"
		 * @param {Number} feet1 - The first length value in feet of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} feet2 - The second length value in feet of the range.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a range of lengths with the unit written in full form.
		 */
		public static function displayFeetEstimateRange(feet1:Number, strSep:String, feet2:Number):String {
			return _displayFeetEstimateRange(feet1, strSep, feet2, false);
		}

		/**
		 * Return a string of a range of lengths in text form, in feet or an approximation in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayFeetEstimateRangeTextually(1, " to ", 2)           // "one to two feet"  / "30 to 60 centimeters"
		 * displayFeetEstimateRangeTextually(2, " to ", 4)           // "two to four feet" / "0.6 to 1.2 meters"
		 * displayFeetEstimateRangeTextually(3, "-", 6)              // "three-six feet"   / "0.9-1.8 meters"
		 * displayFeetEstimateRangeTextually(30, " and ", 40)        // "30 and 40 feet"   / "nine and 12 meters"
		 * displayFeetEstimateRangeTextually(20, "-", 35)            // "20-35 feet"       / "six-11 meters"
		 * displayFeetEstimateRangeTextually(14.621, " to ", 18.379) // "15 to 18 feet"    / "4.4 to six meters"
		 * @param {Number} feet1 - The first length value in feet of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} feet2 - The second length value in feet of the range.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a range of lengths with the unit written in full form.
		 */
		public static function displayFeetEstimateRangeTextually(feet1:Number, strSep:String, feet2:Number):String {
			return _displayFeetEstimateRange(feet1, strSep, feet2, true);
		}

		// - For printing length in feet with a hyphen between the value and the unit -

		/**
		 * Return a string of a length in feet or meters/centimeters, with a hyphen between the numeric value and the unit.
		 * @example
		 * _displayFootWithHyphen(1)          // "1-foot"    / "30-centimeter"
		 * _displayFootWithHyphen(3)          // "3-foot"    / "91-centimeter"
		 * _displayFootWithHyphen(5)          // "5-foot"    / "2-meter"
		 * _displayFootWithHyphen(5, 1)       // "5-foot"    / "1.5-meter"
		 * _displayFootWithHyphen(6, 0, true) // "six-foot"  / "two-meter"
		 * _displayFootWithHyphen(5.75, 2)    // "5.75-foot" / "1.75-meter"
		 * @param {Number} feet - A length in feet.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a length and a unit, joined by a hyphen.
		 */
		private static function _displayFootWithHyphen(feet:Number, sig:int = 0, useNum2Text:Boolean = false):String {
			var value:Number = lengthInFeet(feet, sig);
			var unit:String;
			if (isSI()) {
				unit = "meter";
				if (value < 1 / SI_PREFIX_CENTI_FACTOR) {
					unit = "centi" + unit;
				} else {
					value = formatFloat(value * SI_PREFIX_CENTI_FACTOR, sig);
				}
			} else {
				unit = "foot";
			}
			return (useNum2Text ? num2Text(value) : value) + "-" + unit;
		}

		/**
		 * Return a string of a length in feet or meters/centimeters, with a hyphen between the numeric value and the unit.
		 * @example
		 * displayFootWithHyphen(1)       // "1-foot"    / "30-centimeter"
		 * displayFootWithHyphen(3)       // "3-foot"    / "91-centimeter"
		 * displayFootWithHyphen(5)       // "5-foot"    / "2-meter"
		 * displayFootWithHyphen(5, 1)    // "5-foot"    / "1.5-meter"
		 * displayFootWithHyphen(6)       // "6-foot"    / "2-meter"
		 * displayFootWithHyphen(5.75, 2) // "5.75-foot" / "1.75-meter"
		 * @param {Number} feet - A length in feet.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a length and a unit, joined by a hyphen.
		 */
		public static function displayFootWithHyphen(feet:Number, sig:int = 0):String {
			return _displayFootWithHyphen(feet, sig, false);
		}

		/**
		 * Return a string of a length in text form, in feet or meters/centimeters, with a hyphen between the numeric value and the unit.
		 * @example
		 * displayFootWithHyphenTextually(1)       // "one-foot"   / "30-centimeter"
		 * displayFootWithHyphenTextually(3)       // "three-foot" / "91-centimeter"
		 * displayFootWithHyphenTextually(5)       // "five-foot"  / "two-meter"
		 * displayFootWithHyphenTextually(5, 1)    // "five-foot"  / "1.5-meter"
		 * displayFootWithHyphenTextually(6)       // "six-foot"   / "two-meter"
		 * displayFootWithHyphenTextually(5.75, 2) // "5.75-foot"  / "1.75-meter"
		 * @param {Number} feet - A length in feet.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a length in text form and a unit, joined by a hyphen.
		 */
		public static function displayFootWithHyphenTextually(feet:Number, sig:int = 0):String {
			return _displayFootWithHyphen(feet, sig, true);
		}

		/**
		 * Return a string of a length in feet or an approximation in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * @example
		 * _displayFootEstimateWithHyphen(1)       // "1-foot"   / "30-centimeter"
		 * _displayFootEstimateWithHyphen(3)       // "3-foot"   / "90-centimeter"
		 * _displayFootEstimateWithHyphen(5)       // "5-foot"   / "1.5-meter"
		 * _displayFootEstimateWithHyphen(6, true) // "six-foot" / "1.8-meter"
		 * _displayFootEstimateWithHyphen(5.75)    // "6-foot"   / "1.7-meter"
		 * @param {Number} feet - A length in feet.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a length and a unit, joined by a hyphen.
		 */
		private static function _displayFootEstimateWithHyphen(feet:Number, useNum2Text:Boolean = false):String {
			var value:Number = _feetToCentimeterApproximation(feet, 0);
			var unit:String;
			if (isSI()) {
				unit = "meter";
				if (value < 1 / SI_PREFIX_CENTI_FACTOR) {
					unit = "centi" + unit;
				} else {
					value = formatFloat(value * SI_PREFIX_CENTI_FACTOR, 1);
				}
			} else {
				unit = "foot";
			}
			return (useNum2Text ? num2Text(value) : value) + "-" + unit;
		}

		/**
		 * Return a string of a length in feet or an approximation in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * @example
		 * displayFootEstimateWithHyphen(1)    // "1-foot" / "30-centimeter"
		 * displayFootEstimateWithHyphen(3)    // "3-foot" / "90-centimeter"
		 * displayFootEstimateWithHyphen(5)    // "5-foot" / "1.5-meter"
		 * displayFootEstimateWithHyphen(6)    // "6-foot" / "1.8-meter"
		 * displayFootEstimateWithHyphen(5.75) // "6-foot" / "1.7-meter"
		 * @param {Number} feet - A length in feet.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a length and a unit, joined by a hyphen.
		 */
		public static function displayFootEstimateWithHyphen(feet:Number):String {
			return _displayFootEstimateWithHyphen(feet, false);
		}

		/**
		 * Return a string of a length in text form, in feet or an approximation in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * @example
		 * displayFootEstimateWithHyphenTextually(1)    // "one-foot"   / "30-centimeter"
		 * displayFootEstimateWithHyphenTextually(3)    // "three-foot" / "90-centimeter"
		 * displayFootEstimateWithHyphenTextually(5)    // "five-foot"  / "1.5-meter"
		 * displayFootEstimateWithHyphenTextually(6)    // "six-foot"   / "1.8-meter"
		 * displayFootEstimateWithHyphenTextually(5.75) // "six-foot"   / "1.7-meter"
		 * @param {Number} feet - A length in feet.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a length in text form and a unit, joined by a hyphen.
		 */
		public static function displayFootEstimateWithHyphenTextually(feet:Number):String {
			return _displayFootEstimateWithHyphen(feet, true);
		}

		/**
		 * Return a string of a range of lengths in feet or an approximation in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * @example
		 * displayFootEstimateRangeWithHyphen(1, "to", 2)           // "1-to-2-foot"      / "30-to-60-centimeter"
		 * displayFootEstimateRangeWithHyphen(2, "to", 4)           // "2-to-4-foot"      / "0.6-to-1.2-meter"
		 * displayFootEstimateRangeWithHyphen(2, "to", 4, true)     // "two-to-four-foot" / "0.6-to-1.2-meter"
		 * displayFootEstimateRangeWithHyphen(3, "", 6)             // "3-6-foot"         / "0.9-1.8-meter"
		 * displayFootEstimateRangeWithHyphen(30, "and", 40)        // "30-and-40-foot"   / "9-and-12-meter"
		 * displayFootEstimateRangeWithHyphen(20, "", 35)           // "20-35-foot"       / "6-11-meter"
		 * displayFootEstimateRangeWithHyphen(14.621, "to", 18.379) // "15-to-18-foot"    / "4.4-to-6-meter"
		 * @param {Number} feet1 - The first length value in feet of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} feet2 - The second length value in feet of the range.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a range of lengths and a unit, joined by a hyphen.
		 */
		public static function displayFootEstimateRangeWithHyphen(feet1:Number, strSep:String, feet2:Number, useNum2Text:Boolean = false): String {
			var value1:Number = _feetToCentimeterApproximation(feet1, 0);
			var value2:Number = _feetToCentimeterApproximation(feet2, 0);
			var unit:String;
			if(isSI()) {
				unit = "meter";
				if (value2 < 1 / SI_PREFIX_CENTI_FACTOR) {
					unit = "centi" + unit;
				} else {
					value2 = formatFloat(value2 * SI_PREFIX_CENTI_FACTOR, 1);
					value1 = formatFloat(value1 * SI_PREFIX_CENTI_FACTOR, 1);
				}
			} else {
				unit = "foot";
			}

			return (useNum2Text ? num2Text(value1) : value1) + "-" + (strSep.length > 0 ? strSep + "-" : "") + (useNum2Text ? num2Text(value2) : value2) + "-" + unit;
		}

		/**
		 * Return a string of a range of lengths in text form, in feet or an approximation in meters/centimeters, with a hyphen between the numeric value and the unit.
		 * @example
		 * displayFootEstimateRangeWithHyphenTextually(1, "to", 2)           // "two-to-two-foot"  / "30-to-60-centimeter"
		 * displayFootEstimateRangeWithHyphenTextually(2, "to", 4)           // "two-to-four-foot" / "0.6-to-1.2-meter"
		 * displayFootEstimateRangeWithHyphenTextually(3, "", 6)             // "three-six-foot"   / "0.9-1.8-meter"
		 * displayFootEstimateRangeWithHyphenTextually(30, "and", 40)        // "30-and-40-foot"   / "nine-and-12-meter"
		 * displayFootEstimateRangeWithHyphenTextually(20, "", 35)           // "20-35-foot"       / "six-11-meter"
		 * displayFootEstimateRangeWithHyphenTextually(14.621, "to", 18.379) // "15-to-18-foot"    / "4.4-to-six-meter"
		 * @param {Number} feet1 - The first length value in feet of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} feet2 - The second length value in feet of the range.
		 * @return {String} A string of a range of lengths and a unit, joined by a hyphen.
		 */
		public static function displayFootEstimateRangeWithHyphenTextually(feet1:Number, strSep:String, feet2:Number): String {
			return displayFootEstimateRangeWithHyphen(feet1, strSep, feet2, true);
		}

		// - For printing length in yards ----------

		/**
		 * Return a string of a length in yards or in meters/centimeters, with the unit written in full form.
		 * @example
		 * _displayYards(1)          // "1 yard"      / "91 centimeters"
		 * _displayYards(2)          // "2 yards"     / "2 meters"
		 * _displayYards(3, 0, true) // "three yards" / "three meters"
		 * _displayYards(4, 1)       // "4 yards"     / "3.7 meters"
		 * _displayYards(6.506, 1)   // "6.5 yards"   / "5.9 meters"
		 * _displayYards(7.125, 3)   // "7.125 yards" / "6.515 meters"
		 * @param {Number} yards - A length in yards.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		private static function _displayYards(yards:Number, sig:int = 0, useNum2Text:Boolean = false):String {
			var value:Number = lengthInYards(yards, sig);
			var unit:String;
			if (isSI()) {
				unit = "meter";
				if (value < 1 / SI_PREFIX_CENTI_FACTOR) {
					unit = "centi" + unit;
				} else {
					value = formatFloat(value * SI_PREFIX_CENTI_FACTOR, sig);
				}
			} else {
				unit = "yard";
			}
			return (useNum2Text ? num2Text(value) : value) + " " + unit + (value != 1 && value != 0 ? "s" : "");
		}

		/**
		 * Return a string of a length in yards or in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayYards(1)        // "1 yard"      / "91 centimeters"
		 * displayYards(2)        // "2 yards"     / "2 meters"
		 * displayYards(3)        // "3 yards"     / "3 meters"
		 * displayYards(4, 1)     // "4 yards"     / "3.7 meters"
		 * displayYards(6.506, 1) // "6.5 yards"   / "5.9 meters"
		 * displayYards(7.125, 3) // "7.125 yards" / "6.515 meters"
		 * @param {Number} yards - A length in yards.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		public static function displayYards(yards:Number, sig:int = 0):String {
			return _displayYards(yards, sig, false);
		}

		/**
		 * Return a string of a length in text form, in yards or in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayYardsTextually(1)        // "one yard"    / "91 centimeters"
		 * displayYardsTextually(2)        // "two yards"   / "two meters"
		 * displayYardsTextually(3)        // "three yards" / "three meters"
		 * displayYardsTextually(4, 1)     // "four yards"  / "3.7 meters"
		 * displayYardsTextually(6.506, 1) // "6.5 yards"   / "5.9 meters"
		 * displayYardsTextually(7.125, 3) // "7.125 yards" / "6.515 meters"
		 * @param {Number} yards - A length in yards.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a length in text form with the unit written in full form.
		 */
		public static function displayYardsTextually(yards:Number, sig:int = 0):String {
			return _displayYards(yards, sig, true);
		}

		/**
		 * Return a string of a length in yards or an approximation in meters/centimeters, with the unit written in full form.
		 * @example
		 * _displayYardsEstimate(0.4)         // "0 yard"      / "0 meter"
		 * _displayYardsEstimate(0.6)         // "1 yard"      / "1 meter"
		 * _displayYardsEstimate(1)           // "1 yard"      / "1 meter"
		 * _displayYardsEstimate(2)           // "2 yards"     / "2 meters"
		 * _displayYardsEstimate(3, true)     // "three yards" / "three meters"
		 * _displayYardsEstimate(4)           // "4 yards"     / "4 meters"
		 * _displayYardsEstimate(6.506)       // "7 yards"     / "7 meters"
		 * _displayYardsEstimate(7.125, true) // "seven yards" / "seven meters"
		 * @param {Number} yards - A length in yards.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		private static function _displayYardsEstimate(yards:Number, useNum2Text:Boolean = false): String {
			return formatFloat(yards) + (isSI() ? "yard" : "meter") + (yards > 1 ? "s" : "");
		}

		/**
		 * Return a string of a length in yards or an approximation in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayYardsEstimate(0.4)   // "0 yard"  / "0 meter"
		 * displayYardsEstimate(0.6)   // "1 yard"  / "1 meter"
		 * displayYardsEstimate(1)     // "1 yard"  / "1 meter"
		 * displayYardsEstimate(2)     // "2 yards" / "2 meters"
		 * displayYardsEstimate(3)     // "3 yards" / "3 meters"
		 * displayYardsEstimate(4)     // "4 yards" / "4 meters"
		 * displayYardsEstimate(6.506) // "7 yards" / "7 meters"
		 * displayYardsEstimate(7.125) // "7 yards" / "7 meters"
		 * @param {Number} yards - A length in yards.
		 * @return {String} A string of a length with the unit written in full form.
		 */
		public static function displayYardsEstimate(yards:Number): String {
			return _displayYardsEstimate(yards, false);
		}

		/**
		 * Return a string of a length in text form, in yards or an approximation in meters/centimeters, with the unit written in full form.
		 * @example
		 * displayYardsEstimateTextually(0.4)   // "zero yard"   / "zero meter"
		 * displayYardsEstimateTextually(0.6)   // "one yard"    / "one meter"
		 * displayYardsEstimateTextually(1)     // "one yard"    / "one meter"
		 * displayYardsEstimateTextually(2)     // "two yards"   / "two meters"
		 * displayYardsEstimateTextually(3)     // "three yards" / "three meters"
		 * displayYardsEstimateTextually(4)     // "four yards"  / "four meters"
		 * displayYardsEstimateTextually(6.506) // "seven yards" / "seven meters"
		 * displayYardsEstimateTextually(7.125) // "seven yards" / "seven meters"
		 * @param {Number} yards - A length in yards.
		 * @return {String} A string of a length in text form with the unit written in full form.
		 */
		public static function displayYardsEstimateTextually(yards:Number): String {
			return _displayYardsEstimate(yards, true);
		}

		// = LENGTH - END =============================================================================


		// = WEIGHT ===================================================================================

		/**
		 * Get a string of "pound", or "kilogram" as the equivalent in SI units.
		 * @return {String} A string of value "pound" or "kilogram".
		 */
		public static function literalPound():String {
			return isSI() ? "kilogram" : "pound";
		}

		/**
		 * Get a string of "pounds", or "kilograms" as the equivalent in SI units.
		 * @return {String} A string of value "pounds" or "kilograms".
		 */
		public static function literalPounds():String {
			return isSI() ? "kilograms" : "pounds";
		}

		/**
		 * Get a string of "ton", or "tonne" as the equivalent in SI units.
		 * @return {String} A string of value "ton" or "tonne".
		 */
		public static function literalTon():String {
			return isSI() ? "tonne" : "ton";
		}

		/**
		 * Get a string of "tons", or "tonnes" as the equivalent in SI units.
		 * @return {String} A string of value "tons" or "tonnes".
		 */
		public static function literalTons():String {
			return isSI() ? "tonnes" : "tons";
		}

		/**
		 * Return a weight in pounds or grams.
		 * @example
		 * _weightInPounds(0.00220462262185) // 0.00220462262185 / 1
		 * _weightInPounds(1)                // 1                / 453.59237
		 * _weightInPounds(4.76)             // 4.76             / 2159.0996812
		 * _weightInPounds(10.071658238)     // 10.071658238     / 4568.42733
		 * @param {Number} pounds - A weight in pounds.
		 * @return {Number} A weight value in pounds or grams.
		 */
		private static function _weightInPounds(pounds:Number):Number {
			return isSI() ? pounds * POUND_TO_GRAM : pounds;
		}

		/**
		 * Return a weight in pounds or an approximation in grams.
		 * @example
		 * _weightInPoundsApproximation(0.00220462262185) // 0.00220462262185 / 1.102311310925
		 * _weightInPoundsApproximation(1)                // 1                / 500
		 * _weightInPoundsApproximation(4.76)             // 4.76             / 2380
		 * _weightInPoundsApproximation(10.071658238)     // 10.071658238     / 5035.829119
		 * @param {Number} pounds - A weight in pounds.
		 * @return {Number} A weight value in pounds or grams.
		 */
		private static function _weightInPoundsApproximation(pounds:Number):Number {
			return isSI() ? pounds * POUND_TO_GRAM_APPROX : pounds;
		}

		/**
		 * Return a string of a weight in pounds or in tonnes/grams, with the unit written in full form.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * Once the SI unit reaches the "mega" prefix [M], the unit is switched to tonnes and the prefix reset. The reason being that the usage of "tonne" is more common that "megagram".
		 * @example
		 * _displayWeight(0.00220462262185, 3)    // "0.002 pounds"      / "1 gram"
		 * _displayWeight(1, 2)                   // "1 pound"           / "453.59 grams"
		 * _displayWeight(4.76, 3)                // "4.76 pounds"       / "2.159 kilograms"
		 * _displayWeight(10.071658238, 3)        // "10.072 pounds"     / "4.568 kilograms"
		 * _displayWeight(1929)                   // "1929 pounds"       / "875 kilograms"
		 * _displayWeight(2204.623, 3)            // "2204.623 pounds"   / "1 tonne"
		 * _displayWeight(7233366822.43, 0, true) // "7233366822 pounds" / "three megatonnes"
		 * @param {Number} pounds - A weight in pounds.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a weight with the unit written in full form.
		 */
		private static function _displayWeight(pounds:Number, sig:int = 0, useNum2Text:Boolean = false):String {
			var value:Number = _weightInPounds(pounds);
			var unit:String;
			if (isSI()) {
				var optValue:Object = _optimizePrefix(value, SI_PREFIX_MILLI_POWER, SI_MAX_PREFIX_POWER + SI_PREFIX_POWER_STEP * 2);
				unit = "gram";
				if (optValue.power > SI_PREFIX_KILO_POWER) { unit = "tonne"; optValue.power -= SI_PREFIX_POWER_STEP * 2; }
				unit = SI_POWER_TO_PREFIX[optValue.power.toString()].name + unit;
				value = formatFloat(optValue.value, sig);
			} else {
				unit = "pound";
				value = formatFloat(value, sig);
			}
			return (useNum2Text ? num2Text(value) : value) + " " + unit + (value > 1 ? "s" : "");
		}

		/**
		 * Return a string of a weight in pounds or in tonnes/grams, with the unit written in full form.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * Once the SI unit reaches the "mega" prefix [M], the unit is switched to tonnes and the prefix reset. The reason being that the usage of "tonne" is more common that "megagram".
		 * @example
		 * displayWeight(0.00220462262185, 3) // "0.002 pounds"      / "1 gram"
		 * displayWeight(1, 2)                // "1 pound"           / "453.59 grams"
		 * displayWeight(4.76, 3)             // "4.76 pounds"       / "2.159 kilograms"
		 * displayWeight(10.071658238, 3)     // "10.072 pounds"     / "4.568 kilograms"
		 * displayWeight(1929)                // "1929 pounds"       / "875 kilograms"
		 * displayWeight(2204.623, 3)         // "2204.623 pounds"   / "1 tonne"
		 * displayWeight(7233366822.43, 0)    // "7233366822 pounds" / "3 megatonnes"
		 * @param {Number} pounds - A weight in pounds.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a weight with the unit written in full form.
		 */
		public static function displayWeight(pounds:Number, sig:int = 0):String {
			return _displayWeight(pounds, sig, false);
		}

		/**
		 * Return a string of a weight in text form, in pounds or in tonnes/grams, with the unit written in full form.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * Once the SI unit reaches the "mega" prefix [M], the unit is switched to tonnes and the prefix reset. The reason being that the usage of "tonne" is more common that "megagram".
		 * @example
		 * displayWeightTextually(0.00220462262185, 3) // "0.002 pounds"      / "one gram"
		 * displayWeightTextually(1, 2)                // "one pound"         / "453.59 grams"
		 * displayWeightTextually(4.76, 3)             // "4.76 pounds"       / "2.159 kilograms"
		 * displayWeightTextually(10.071658238, 3)     // "10.072 pounds"     / "4.568 kilograms"
		 * displayWeightTextually(1929)                // "1929 pounds"       / "875 kilograms"
		 * displayWeightTextually(2204.623, 3)         // "2204.623 pounds"   / "one tonne"
		 * displayWeightTextually(7233366822.43, 0)    // "7233366822 pounds" / "three megatonnes"
		 * @param {Number} pounds - A weight in pounds.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a weight in text form with the unit written in full form.
		 */
		public static function displayWeightTextually(pounds:Number, sig:int = 0):String {
			return _displayWeight(pounds, sig, true);
		}

		/**
		 * Return a string of a weight in pounds or an approximation in tonnes/grams, with the unit written in full form.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * Once the SI unit reaches the "mega" prefix [M], the unit is switched to tonnes and the prefix reset. The reason being that the usage of "tonne" is more common that "megagram".
		 * @example
		 * _displayWeightEstimate(0.00220462262185)    // "0 pound"           / "1 gram"
		 * _displayWeightEstimate(1)                   // "1 pound"           / "500 grams"
		 * _displayWeightEstimate(4.76)                // "5 pounds"          / "2 kilograms"
		 * _displayWeightEstimate(10.071658238)        // "10 pounds"         / "5 kilograms"
		 * _displayWeightEstimate(1929)                // "1929 pounds"       / "965 kilograms"
		 * _displayWeightEstimate(2204.623)            // "2205 pounds"       / "1 tonne"
		 * _displayWeightEstimate(7233366822.43, true) // "7233366822 pounds" / "four megatonnes"
		 * @param {Number} pounds - A weight in pounds.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a weight with the unit written in full form.
		 */
		private static function _displayWeightEstimate(pounds:Number, useNum2Text:Boolean = false):String {
			var value:Number = _weightInPoundsApproximation(pounds);
			var unit:String;
			if (isSI()) {
				var optValue:Object = _optimizePrefix(value, SI_PREFIX_MILLI_POWER, SI_MAX_PREFIX_POWER + SI_PREFIX_POWER_STEP * 2);
				unit = "gram";
				if (optValue.power > SI_PREFIX_KILO_POWER) { unit = "tonne"; optValue.power -= SI_PREFIX_POWER_STEP * 2; }
				unit = SI_POWER_TO_PREFIX[optValue.power.toString()].name + unit;
				value = formatFloat(optValue.value, 0);
			} else {
				unit = "pound";
				value = formatFloat(value, 0);
			}
			return (useNum2Text ? num2Text(value) : value) + " " + unit + (value > 1 ? "s" : "");
		}

		/**
		 * Return a string of a weight in pounds or an approximation in tonnes/grams, with the unit written in full form.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * Once the SI unit reaches the "mega" prefix [M], the unit is switched to tonnes and the prefix reset. The reason being that the usage of "tonne" is more common that "megagram".
		 * @example
		 * displayWeightEstimate(0.00220462262185) // "0 pound"           / "1 gram"
		 * displayWeightEstimate(1)                // "1 pound"           / "500 grams"
		 * displayWeightEstimate(4.76)             // "5 pounds"          / "2 kilograms"
		 * displayWeightEstimate(10.071658238)     // "10 pounds"         / "5 kilograms"
		 * displayWeightEstimate(1929)             // "1929 pounds"       / "965 kilograms"
		 * displayWeightEstimate(2204.623)         // "2205 pounds"       / "1 tonne"
		 * displayWeightEstimate(7233366822.43)    // "7233366822 pounds" / "4 megatonnes"
		 * @param {Number} pounds - A weight in pounds.
		 * @return {String} A string of a weight with the unit written in full form.
		 */
		public static function displayWeightEstimate(pounds:Number):String {
			return _displayWeightEstimate(pounds);
		}

		/**
		 * Return a string of a weight in text form, in pounds or an approximation in tonnes/grams, with the unit written in full form.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * Once the SI unit reaches the "mega" prefix [M], the unit is switched to tonnes and the prefix reset. The reason being that the usage of "tonne" is more common that "megagram".
		 * @example
		 * displayWeightEstimateTextually(0.00220462262185) // "zero pound"        / "one gram"
		 * displayWeightEstimateTextually(1)                // "one pound"         / "500 grams"
		 * displayWeightEstimateTextually(4.76)             // "five pounds        / "two kilograms"
		 * displayWeightEstimateTextually(10.071658238)     // "ten pounds"        / "five kilograms"
		 * displayWeightEstimateTextually(1929)             // "1929 pounds"       / "965 kilograms"
		 * displayWeightEstimateTextually(2204.623)         // "2205 pounds"       / "one tonne"
		 * displayWeightEstimateTextually(7233366822.43)    // "7233366822 pounds" / "four megatonnes"
		 * @param {Number} pounds - A weight in pounds.
		 * @return {String} A string of a weight in text form with the unit written in full form.
		 */
		public static function displayWeightEstimateTextually(pounds:Number):String {
			return _displayWeightEstimate(pounds, true);
		}

		/**
		 * Return a string of a range of weights in pounds or in tonnes/grams, with the unit written in full form.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * Once the SI unit reaches the "mega" prefix [M], the unit is switched to tonnes and the prefix reset. The reason being that the usage of "tonne" is more common that "megagram".
		 * @example
		 * _displayWeightRange(1, " to ", 2)               // "1 to 2 pounds"          / "454 to 907 grams"
		 * _displayWeightRange(1, " and ", 4)              // "1 and 4 pounds"         / "0.5 and 2 kilograms"
		 * _displayWeightRange(10, "-", 11)                // "10-11 pounds"           / "4-5 kilograms"
		 * _displayWeightRange(10.5, " and ", 13.5, "", 1) // "10.5 and 13.5 pounds"   / "4.8 and 6.1 kilograms"
		 * _displayWeightRange(120, "-", 180, "terran ")   // "120-180 terran pounds"  / "54-82 terran kilograms"
		 * _displayWeightRange(150, "-", 160, "marsian-")  // "150-160 marsian-pounds" / "68-73 marsian-kilograms"
		 * _displayWeightRange(2205, " to ", 4410)         // "2205 to 4410 pounds"    / "1 to 2 tonnes"
		 * @param {Number} pounds1 - The first weight value in pounds of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} pounds2 - The second weight value in pounds of the range.
		 * @param {String} qualifier - A string to modifiy the qualitiy of the measurement unit; Should contain a trailing space to separate the qualifier and the unit.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @param {Boolean} [useNum2Text=false] - A flag to display the value as a cardinal number word.
		 * @return {String} A string of a range of weights with the unit written in full form.
		 */
		private static function _displayWeightRange(pounds1:Number, strSep:String, pounds2:Number, qualifier:String, sig:int = 0, useNum2Text:Boolean = false):String {
			var value1:Number = _weightInPounds(pounds1);
			var value2:Number = _weightInPounds(pounds2);
			var unit:String;
			if (isSI()) {
				var optValue2:Object = _optimizePrefix(value2, SI_PREFIX_MILLI_POWER, SI_MAX_PREFIX_POWER + SI_PREFIX_POWER_STEP * 2);
				var optValue1:Object = _optimizePrefix(value1, SI_PREFIX_MILLI_POWER, optValue2.power);

				unit = "gram";
				const originalPowerInGrams:int = optValue2.power;
				if (optValue2.power > SI_PREFIX_KILO_POWER) { unit = "tonne"; optValue2.power -= SI_PREFIX_POWER_STEP * 2; }

				// If the value1 has a lower prefix than value2: bring the value1 to the same prefix than value2's, then round value1 to keep at least one significant digit and keep some more if the sig parameter did specify it.
				value1 = optValue1.power < originalPowerInGrams ?
					formatFloat(
						optValue1.value / Math.pow(10, originalPowerInGrams - optValue1.power),
						_powerDifferenceForSignificantDigit(optValue1, originalPowerInGrams) + (sig > 0 ? sig - 1 : 0)
					):
					formatFloat(optValue1.value, sig);
				value2 = formatFloat(optValue2.value, sig);
				unit = SI_POWER_TO_PREFIX[optValue2.power.toString()].name + unit;
				if (value1 == value2) value1 = value2 - 1;
			} else {
				value1 = formatFloat(value1, sig);
				value2 = formatFloat(value2, sig);
				unit = "pound";
			}
			return (useNum2Text ? num2Text(value1) : value1) + strSep + (useNum2Text ? num2Text(value2) : value2) + " " + qualifier + unit + (value2 != 1 && value2 != 0 ? "s" : "");
		}

		/**
		 * Return a string of a range of weights in pounds or in tonnes/grams, with the unit written in full form.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * Once the SI unit reaches the "mega" prefix [M], the unit is switched to tonnes and the prefix reset. The reason being that the usage of "tonne" is more common that "megagram".
		 * @example
		 * displayWeightRange(1, " to ", 2)           // "1 to 2 pounds"        / "454 to 907 grams"
		 * displayWeightRange(1, " and ", 4)          // "1 and 4 pounds"       / "0.5 and 2 kilograms"
		 * displayWeightRange(10, "-", 11)            // "10-11 pounds"         / "4-5 kilograms"
		 * displayWeightRange(10.5, " and ", 13.5, 1) // "10.5 and 13.5 pounds" / "4.8 and 6.1 kilograms"
		 * displayWeightRange(2205, " to ", 4410)     // "2205 to 4410 pounds"  / "1 to 2 tonnes"
		 * @param {Number} pounds1 - The first weight value in pounds of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} pounds2 - The second weight value in pounds of the range.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a range of weights with the unit written in full form.
		 */
		public static function displayWeightRange(pounds1:Number, strSep:String, pounds2:Number, sig:int = 0):String {
			return _displayWeightRange(pounds1, strSep, pounds2, "", sig, false);
		}

		/**
		 * Return a string of a range of weights in text form, in pounds or in tonnes/grams, with the unit written in full form.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * Once the SI unit reaches the "mega" prefix [M], the unit is switched to tonnes and the prefix reset. The reason being that the usage of "tonne" is more common that "megagram".
		 * @example
		 * displayWeightRangeTextually(1, " to ", 2)           // "one to two pounds"    / "454 to 907 grams"
		 * displayWeightRangeTextually(1, " and ", 4)          // "one and four pounds"  / "0.5 and two kilograms"
		 * displayWeightRangeTextually(10, "-", 11)            // "ten-11 pounds"        / "four-five kilograms"
		 * displayWeightRangeTextually(10.5, " and ", 13.5, 1) // "10.5 and 13.5 pounds" / "4.8 and 6.1 kilograms"
		 * displayWeightRangeTextually(2205, " to ", 4410)     // "2205 to 4410 pounds"  / "one to two tonnes"
		 * @param {Number} pounds1 - The first weight value in pounds of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} pounds2 - The second weight value in pounds of the range.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a range of weights in text form with the unit written in full form.
		 */
		public static function displayWeightRangeTextually(pounds1:Number, strSep:String, pounds2:Number, sig:int = 0):String {
			return _displayWeightRange(pounds1, strSep, pounds2, "", sig, true);
		}

		/**
		 * Return a string of a range of qualified weights in pounds or in tonnes/grams, with the unit written in full form.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * Once the SI unit reaches the "mega" prefix [M], the unit is switched to tonnes and the prefix reset. The reason being that the usage of "tonne" is more common that "megagram".
		 * @example
		 * displayQualifiedWeightRange(1, " to ", 2, "ancient-time ")     // "1 to 2 ancient-time pounds"  / "454 to 907 ancient-time grams"
		 * displayQualifiedWeightRange(10.5, " and ", 13.5, "normal ", 1) // "10.5 and 13.5 normal pounds" / "4.8 and 6.1 normal kilograms"
		 * displayQualifiedWeightRange(120, "-", 180, "terran ")          // "120-180 terran pounds"       / "54-82 terran kilograms"
		 * displayQualifiedWeightRange(150, "-", 160, "marsian-")         // "150-160 marsian-pounds"      / "68-73 marsian-kilograms"
		 * displayQualifiedWeightRange(2205, " to ", 4410, "common ")     // "2205 to 4410 common pounds"  / "1 to 2 common tonnes"
		 * @param {Number} pounds1 - The first weight value in pounds of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} pounds2 - The second weight value in pounds of the range.
		 * @param {String} qualifier - A string to modifiy the qualitiy of the measurement unit; Should contain a trailing space to separate the qualifier and the unit.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a range of weights with the unit written in full form.
		 */
		public static function displayQualifiedWeightRange(pounds1:Number, strSep:String, pounds2:Number, qualifier:String, sig:int = 0):String {
			return _displayWeightRange(pounds1, strSep, pounds2, qualifier, sig, false);
		}

		/**
		 * Return a string of a weight in pounds or tonnes/grams, with the unit written as a symbol.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * Once the SI unit reaches the "mega" prefix [M], the unit is switched to tonnes and the prefix reset. The reason being that the usage of "tonne" is more common that "megagram".
		 * @example
		 * displayWeightShort(0.00220462262185) // "0.002 lb"          / "1 g"
		 * displayWeightShort(1)                // "1 lb"              / "453.592 g"
		 * displayWeightShort(4.76)             // "4.76 lb"           / "2.159 kg"
		 * displayWeightShort(10.072)           // "10.072 lb"         / "4.568 kg"
		 * displayWeightShort(1929.3984)        // "1929.2984 lb"      / "875.16 kg"
		 * displayWeightShort(2204.6236)        // "2204.624 lb"       / "1 t"
		 * displayWeightShort(7233366822.286)   // "7233366822.286 lb" / "3.281 Mt"
		 * @param {Number} pounds - A weight in pounds.
		 * @return {String} A string of a weight with the unit written as a symbol.
		 */
		public static function displayWeightShort(pounds:Number):String {
			var value:Number = _weightInPounds(pounds);
			var result:String;
			if (isSI()) {
				// A power that is two steps higher than the max can be used, because the prefix will step 2 levels down when it reaches the megagram (to switch to tonnes).
				var optValue:Object = _optimizePrefix(value, SI_PREFIX_MILLI_POWER, SI_MAX_PREFIX_POWER + SI_PREFIX_POWER_STEP * 2);
				var unit:String = "g";
				// A megagram [Mg] is a tonne [t]
				if (optValue.power > SI_PREFIX_KILO_POWER) { unit = "t"; optValue.power -= SI_PREFIX_POWER_STEP * 2; }
				result = formatFloat(optValue.value, 3) + " " + SI_POWER_TO_PREFIX[optValue.power.toString()].symbol + unit;
			} else result = formatFloat(value, 3) + " lb";
			return result;
		}

		/**
		 * Return a string of a range of weights in pounds or in tonnes/grams, with the unit written as a symbol.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * Once the SI unit reaches the "mega" prefix [M], the unit is switched to tonnes and the prefix reset. The reason being that the usage of "tonne" is more common that "megagram".
		 * @example
		 * displayWeightRangeShort(1, " to ", 2)           // "1 to 2 lb"        / "456 to 907 g"
		 * displayWeightRangeShort(1, " and ", 4)          // "1 and 4 lb"       / "0.5 and 2 kg"
		 * displayWeightRangeShort(10, "-", 11)            // "10-11 lb"         / "4-5 kg"
		 * displayWeightRangeShort(10.5, " and ", 13.5, 1) // "10.5 and 13.5 lb" / "4.8 and 6.1 kg"
		 * displayWeightRangeShort(2205, " to ", 4410)     // "2205 to 4410 lb"  / "1 to 2 t"
		 * @param {Number} pounds1 - The first weight value in pounds of the range.
		 * @param {String} strSep - A string used to separate the two values.
		 * @param {Number} pounds2 - The second weight value in pounds of the range.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a range of weights with the unit written as a symbol.
		 */
		public static function displayWeightRangeShort(pounds1:Number, strSep:String, pounds2:Number, sig:int = 0):String {
			var value1:Number = _weightInPounds(pounds1);
			var value2:Number = _weightInPounds(pounds2);
			var symbol:String;
			if (isSI()) {
				var optValue2:Object = _optimizePrefix(value2, SI_PREFIX_MILLI_POWER, SI_MAX_PREFIX_POWER + SI_PREFIX_POWER_STEP * 2);
				var optValue1:Object = _optimizePrefix(value1, SI_PREFIX_MILLI_POWER, optValue2.power);

				symbol = "g";
				const originalPowerInGrams:int = optValue2.power;
				if (optValue2.power > SI_PREFIX_KILO_POWER) { symbol = "t"; optValue2.power -= SI_PREFIX_POWER_STEP * 2; }

				// If the value1 has a lower prefix than value2: bring the value1 to the same prefix than value2's, then round value1 to keep at least one significant digit and keep some more if the sig parameter did specify it.
				value1 = optValue1.power < originalPowerInGrams ?
					formatFloat(
						optValue1.value / Math.pow(10, originalPowerInGrams - optValue1.power),
						_powerDifferenceForSignificantDigit(optValue1, originalPowerInGrams) + (sig > 0 ? sig - 1 : 0)
					):
					formatFloat(optValue1.value, sig);
				value2 = formatFloat(optValue2.value, sig);
				symbol = SI_POWER_TO_PREFIX[optValue2.power.toString()].symbol + symbol;
				if (value1 == value2) value1 = value2 - 1;
			} else {
				value1 = formatFloat(value1, sig);
				value2 = formatFloat(value2, sig);
				symbol = "lb";
			}
			return value1 + strSep + value2 + " " + symbol;
		}

		// = WEIGHT - END =============================================================================

		// = VOLUME ===================================================================================

		// - Liquid volumes -------------------------

		/**
		 * Get a string of "liter".
		 * @return {String} A string of value "liter".
		 */
		public static function liter(): String {
			return "liter";
		}

		/**
		 * Get a string of "liters".
		 * @return {String} A string of value "liters".
		 */
		public static function liters(): String {
			return liter() + "s";
		}

		/**
		 * Get a string of "a gallon", or "four liters" as the equivalent in SI units.
		 * @return {String} A string of value "a gallon" or "four liters".
		 */
		public static function aGallon():String {
			return isSI() ? "four liters" : "a gallon";
		}

		/**
		 * Get a string of "half-gallon", or "two-liter" as the equivalent in SI units.
		 * @return {String} A string of value "half-gallon" or "two-litter".
		 */
		public static function halfGallonCompound():String {
			return isSI() ? "two-liter" : "half-gallon";
		}

		/**
		 * Get a string of "gallon", or "liter" as the equivalent in SI units.
		 * @return {String} A string of value "gallon" or "liter".
		 */
		public static function literalGallon():String {
			return isSI() ? "liter" : "gallon";
		}

		/**
		 * Get a string of "gallons", or "liters" as the equivalent in SI units.
		 * @return {String} A string of value "gallons" or "liters".
		 */
		public static function literalGallons():String {
			return isSI() ? "liters" : "gallons";
		}

		/**
		 * Return a value representing a volume in gallons or an approximation in liters.
		 * @param {Number} gallons - A volume in gallons.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {Number} A volume value in gallons or in liters.
		 */
		public static function volumeInGallonsEstimate(gallons:Number, sig:int = 0):Number {
			return formatFloat((isSI() ? gallons * GALLON_TO_LITER_APPROX : gallons), sig);
		}

		/**
		 * Return a string of a volume in liters with the unit written as a symbol.
		 * The value is prefixed in order to keep it as readable as possible.
		 * The difference between the imperial system and the International System, is the symbol used for the unit. Both symbols are recognized in the International System, but the uppercase "L" symbol is more commonly used in English-speaking countries (i.e. USA, Canada, Australia), while lowercase "L" (l) more closely follows the SI convention for symbols.
		 * @example
		 * displayLitersShort(100)             // "100 mL"     / "100 ml"
		 * displayLitersShort(1000)            // "1 L"        / "1 l"
		 * displayLitersShort(128359462)       // "128.359 kL" / "128.359 kl"
		 * displayLitersShort(43000000000)     // "43 ML"      / "43 Ml"
		 * displayLitersShort(672000000000000) // "672 TL"     / "672 Tl"
		 * @param {Number} milliliters - A volume in milliliters.
		 * @return {String} A string of a volume with the unit written as a symbol.
		 */
		public static function displayLitersShort(milliliters:Number):String {
			var optValue:Object = _optimizePrefix(milliliters / SI_PREFIX_FACTOR);
			return formatFloat(optValue.value, 3) + " " + SI_POWER_TO_PREFIX[optValue.power.toString()].symbol + (isSI() ? "l" : "L");
		}

		/**
		 * Return a string of a volume in text form, in gallons or in liters, with the unit written in full form.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * @example
		 * displayGallonsTextually(0.03, 2) // "0.03 gallons" / "113.56 milliliters"
		 * displayGallonsTextually(5)       // "five gallons" / "19 liters"
		 * displayGallonsTextually(6.3)     // "six gallons"  / "24 liters"
		 * displayGallonsTextually(250)     // "250 gallons"  / "946 liters"
		 * displayGallonsTextually(376)     // "376 gallons"  / "one kiloliter"
		 * @param {Number} gallons - A volume in gallons.
		 * @param {int} [sig=0] - A number of significant digits to keep after the decimal point.
		 * @return {String} A string of a volume in text form and a unit, joined by a hyphen.
		 */
		public static function displayGallonsTextually(gallons:Number, sig:int = 0):String {
			var value:Number = gallons;
			var unit:String = isSI() ? "liter" : "gallon";

			if (isSI()) {
				value = gallons * GALLON_TO_LITER;
				var optValue:Object = _optimizePrefix(value);
				value = optValue.value;
				unit = SI_POWER_TO_PREFIX[optValue.power.toString()].name + unit;
			}

			return num2Text(formatFloat(value, sig)) + " " + unit + (value != 1 && value != 0 ? "s" : "");
		}

		// - Gallon estimate ------------------------

		/**
		 * Return a string of a volume in text form, in gallons or an approximation in liters, with the unit written in full form.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * @example
		 * displayGallonsEstimateTextually(0.03)    // "zero gallon"  / "120 milliliters"
		 * displayGallonsEstimateTextually(5)       // "five gallons" / "20 liters"
		 * displayGallonsEstimateTextually(6.3)     // "six gallons"  / "25 liters"
		 * displayGallonsEstimateTextually(250)     // "250 gallons"  / "one kiloliter"
		 * displayGallonsEstimateTextually(376)     // "376 gallons"  / "two kiloliters"
		 * @param {Number} gallons - A volume in gallons.
		 * @return {String} A string of a volume in text form and a unit, joined by a hyphen.
		 */
		public static function displayGallonsEstimateTextually(gallons:Number):String {
			var value:Number = gallons;
			var unit:String = isSI() ? "liter" : "gallon";

			if (isSI()) {
				value = gallons * GALLON_TO_LITER_APPROX;
				var optValue:Object = _optimizePrefix(value);
				value = optValue.value;
				unit = SI_POWER_TO_PREFIX[optValue.power.toString()].name + unit;
			}

			return num2Text(formatFloat(value, 0)) + " " + unit + (value != 1 && value != 0 ? "s" : "");
		}

		/**
		 * Return a string of a volume in text form, in gallons or an approximation in liters, with a hyphen between the numeric value and the unit.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * @example
		 * displayGallonEstimateWithHyphenTextually(0.03) // "zero-gallon" / "120-milliliter"
		 * displayGallonEstimateWithHyphenTextually(5)    // "five-gallon" / "20-liter"
		 * displayGallonEstimateWithHyphenTextually(6.3)  // "six-gallon"  / "25-liter"
		 * displayGallonEstimateWithHyphenTextually(250)  // "250-gallon"  / "one-kiloliter"
		 * @param {Number} gallons - A volume in gallons.
		 * @return {String} A string of a volume in text form and a unit, joined by a hyphen.
		 */
		public static function displayGallonEstimateWithHyphenTextually(gallons:Number):String {
			var value:Number = gallons;
			var unit:String = isSI() ? "liter" : "gallon";

			if (isSI()) {
				value = gallons * GALLON_TO_LITER_APPROX;
				var optValue:Object = _optimizePrefix(value);
				value = optValue.value;
				unit = SI_POWER_TO_PREFIX[optValue.power.toString()].name + unit;
			}

			return num2Text(formatFloat(value, 0)) + "-" + unit;
		}

		// - Solid volumes --------------------------

		/**
		 * Return a volume value in cubic inches or cubic meters.
		 * @example
		 * _volumeInCubicInches(1)                       // 1                       / 0.000016387064
		 * _volumeInCubicInches(61023.744094732)         // 61023.744094732         / 1
		 * _volumeInCubicInches(8931679.281)             // 8931679.281             / 146.364
		 * _volumeInCubicInches(61023744094732.29)       // 61023744094732.29       / 1000000000
		 * _volumeInCubicInches(61023744094732290000000) // 61023744094732290000000 / 1000000000000000000
		 * @param {Number} cubicinches - A volume in cubic inches.
		 * @return {Number} A volume value in cubic inches or cubic meters.
		 */
		private static function _volumeInCubicInches(cubicinches:Number):Number {
			return isSI() ? cubicinches * Math.pow(INCH_TO_METER, 3) : cubicinches;
		}

		/**
		 * Return a string of a volume in cubic inches or cubic meters, with the unit written as a symbol.
		 * The SI value is prefixed in order to keep it as readable as possible.
		 * @example
		 * displayVolumeShort(1)                       // "1 in³"                       / "16.387 cm³"
		 * displayVolumeShort(100)                     // "100 in³"                     / "1.639 dm³"
		 * displayVolumeShort(61023.744)               // "61023.744 in³"               / "1 m³"
		 * displayVolumeShort(8931679.281)             // "8931679.281 in³"             / "146.364 m³"
		 * displayVolumeShort(89316792.807             // "89316792.807 in³"            / "1.463 dam³"
		 * displayVolumeShort(89316792806.814)         // "89316792806.814 in³"         / "1.463 hm³"
		 * displayVolumeShort(61023744094732.29)       // "61023744094732.29 in³"       / "1 km³"
		 * displayVolumeShort(61023744094732290000000) // "61023744094732290000000 in³" / "1 Mm³"
		 * @param {Number} cubicinches - A volume in cubic inches.
		 * @return {String} A string of a volume with the unit written as a symbol.
		 */
		public static function displayVolumeShort(cubicinches:Number):String {
			var value:Number = _volumeInCubicInches(cubicinches);
			var result:String;
			if (isSI()) {
				var optValue:Object = _optimizePrefix(value, SI_PREFIX_MILLI_POWER, SI_PREFIX_KILO_POWER, SI_PREFIX_POWER_STEP * 3);
				if (optValue.power == SI_PREFIX_MILLI_POWER) {
					const DECI_IN_MILLI:int = 1000000;
					const CENTI_IN_MILLI:int = 1000;
					if (optValue.value >= DECI_IN_MILLI) { optValue.value /= DECI_IN_MILLI; optValue.power = SI_PREFIX_DECI_POWER; }
					else if (optValue.value >= CENTI_IN_MILLI) { optValue.value /= CENTI_IN_MILLI; optValue.power = SI_PREFIX_CENTI_POWER; }
				} else if (optValue.power == SI_PREFIX_NONE_POWER) {
					const HECTO_IN_METER:int = 1000000;
					const DECA_IN_METER:int = 1000;
					if (optValue.value >= HECTO_IN_METER) { optValue.value /= HECTO_IN_METER; optValue.power = SI_PREFIX_HECTO_POWER; }
					else if (optValue.value >= DECA_IN_METER) { optValue.value /= DECA_IN_METER; optValue.power = SI_PREFIX_DECA_POWER; }
				}
				result = formatFloat(optValue.value, 3) + " " + SI_POWER_TO_PREFIX[optValue.power.toString()].symbol + "m³";
			} else {
				result = formatFloat(value, 3) + " " + "in³";
			}
			return result;
		}

		// = VOLUME - END =============================================================================
	}
}