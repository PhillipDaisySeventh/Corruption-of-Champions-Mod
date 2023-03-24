package classes.Perks 
{
	import classes.Perk;
	import classes.PerkType;
	import classes.GlobalFlags.kGAMECLASS;
	import classes.UnitSystem;
	
	public class MilkMaidPerk extends PerkType
	{
		
		override public function desc(params:Perk = null):String
		{
			return "(Rank: " + params.value1 + "/10) Increases milk production by " + UnitSystem.displayLitersShort(200 + (params.value1 * 100)) + ".";
		}

		override public function get longDesc():String
		{
			return "Increases milk production by ---" + UnitSystem.display("mL", "ml") + ". Allows you to lactate perpetually.";
		}
		
		public function MilkMaidPerk() 
		{
			super("Milk Maid", "Milk Maid", "");
		}
	}
}
