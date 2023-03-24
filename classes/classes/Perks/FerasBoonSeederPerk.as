package classes.Perks 
{
	import classes.Perk;
	import classes.PerkType;
	import classes.UnitSystem;
	
	public class FerasBoonSeederPerk extends PerkType
	{
		public function FerasBoonSeederPerk() 
		{
			super(
				"Fera's Boon - Seeder",
				"Fera's Boon - Seeder",
				"Increases cum output.",
				null,
				true
      );
		}

		override public function desc(params:Perk = null):String
		{
			return "Increases cum output by " + UnitSystem.displayLitersShort(1000) + ".";
		}
	}
}
