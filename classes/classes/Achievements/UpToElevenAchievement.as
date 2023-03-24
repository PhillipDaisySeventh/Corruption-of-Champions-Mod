package classes.Achievements
{
  import classes.Achievement;
	import classes.UnitSystem;

  public class UpToElevenAchievement extends Achievement
  {
    public function UpToElevenAchievement(id:int)
    {
      super(
        id,
        null,
        "",
        ""
      );
    }

    override public function get title():String
    {
      return "Up to " + UnitSystem.display("Eleven", "Three");
    }

    override public function get descLocked():String
    {
      return "Take your height up to " + UnitSystem.displayHeight2Estimate(11) + ".";
    }

    override public function get descUnlocked():String
    {
      return this.descLocked;
    }
  }
}
