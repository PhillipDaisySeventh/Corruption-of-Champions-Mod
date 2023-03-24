package classes.Perks 
{
	import classes.Perk;
	import classes.PerkType;
	import classes.UnitSystem;
	
	public class FutaFormPerk extends PerkType
	{
		public function FutaFormPerk() 
		{
			super(
        "Futa Form",
        "Futa Form",
				"Ensures that your body fits the Futa look (Tits DD+, Big Dick, & Pussy).  Also keeps your lusts burning bright and improves the tease skill."
      );
		}
		
		override public function desc(params:Perk = null):String
		{
			return "Ensures that your body fits the Futa look (Tits DD+, Dick " + UnitSystem.displayInchesShort2(8) + "+, & Pussy).  Also keeps your lusts burning bright and improves the tease skill.";
		}
	}
}
