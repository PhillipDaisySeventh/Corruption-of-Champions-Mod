package classes.Perks 
{
	import classes.Perk;
	import classes.PerkType;
	import classes.UnitSystem;
	
	public class MagicalVirilityPerk extends PerkType
	{
		public function MagicalVirilityPerk() 
		{
			super(
				"Magical Virility",
				"Magical Virility",
				"More cum per orgasm and enhanced virility."
      );
		}
		
		override public function desc(params:Perk = null):String
		{
			return UnitSystem.displayLitersShort(200) + " more cum per orgasm and enhanced virility.";
		}
	}
}
