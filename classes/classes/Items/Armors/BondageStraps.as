package classes.Items.Armors
{
	import classes.PerkLib;
  import classes.UnitSystem;

	public class BondageStraps extends ArmorWithPerk {
  
    public function BondageStraps() {
      super(
        "BonStrp",
        "BonStrp",
        "barely-decent bondage straps",
        "a set of bondage straps",
        0,
        600,
        "",
        "Light",
        PerkLib.SluttySeduction,
        10,
        0,
        0,
        0,
        "Your fetishy bondage outfit allows you access to an improved form of 'Tease'.",
        null,
        0,
        0,
        0,
        0,
        "",
        false,
        false
      );
    }

    override public function get description():String {
      description = "These leather straps and well-placed hooks are actually designed in such a way as to be worn as clothing.  While they technically would cover your naughty bits, virtually every other " + UnitSystem.literalInch() + " of your body would be exposed.";
      return super.description;
    }
  }
}