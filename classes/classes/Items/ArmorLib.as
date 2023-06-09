/**
 * Created by aimozg on 10.01.14.
 */
package classes.Items
{
	import classes.Items.Armors.*;
	import classes.PerkLib;
	import classes.PerkType;

	public final class ArmorLib
	{
		public static const COMFORTABLE_UNDERCLOTHES:Armor = new ComfortableUnderclothes();
		public static const NOTHING:Armor = new Nothing();
		
		//Clothing
		public const ADVCLTH:Armor = new Armor("AdvClth","G. Clothes","green adventurer's clothes","a green adventurer's outfit, complete with pointed cap",2,200,"A set of comfortable green adventurer's clothes.  It even comes complete with a pointy hat!","Light");
		public const B_DRESS:Armor = new Armor("B.Dress","Long Dress","long ballroom dress patterned with sequins","a ballroom dress patterned with sequins",0,1200,"A long ballroom dress patterned with sequins.  Perfect for important occasions.","Medium");
		public const BIMBOSK:BimboSkirt = new BimboSkirt();
		public const BONSTRP:ArmorWithPerk = new BondageStraps();
		public const C_CLOTH:ComfortableClothes = new ComfortableClothes();
		public const CLSSYCL:Armor = new Armor("ClssyCl", "Suitclothes", "classy suitclothes", "a set of classy suit-clothes", 1, 400, "A set of classy suitclothes.", "Light");
		public const KIMONO :Armor = new Armor("Kimono ","Kimono ","kimono","a traditional kimono",2,500,"This is a type of robes also known as kimono traditionally worn by the people of the far East. It's pretty elegant.","Light");
		public const LTHRPNT:Armor = new Armor("LthrPnt","T.Lthr Pants","white silk shirt and tight leather pants","a pair of leather pants and a white silk shirt",0,450,"A flowing silk shirt and tight black leather pants.  Suave!","Light");
		public const M_ROBES:Armor = new Armor("M.Robes","Robes","modest robes","a set of modest robes",0,120,"A set of modest robes, not dissimilar from what the monks back home would wear.","Light");
		public const NAGASLK:NagaSilkDress = new NagaSilkDress();
		public const NURSECL:ArmorWithPerk = new ArmorWithPerk("NurseCl","NurseCl","skimpy nurse's outfit","a nurse's outfit",0,800,"This borderline obscene nurse's outfit would barely cover your hips and crotch.  The midriff is totally exposed, and the white top leaves plenty of room for cleavage.  A tiny white hat tops off the whole ensemble.  It would grant a small regeneration to your HP.","Light",
				PerkLib.SluttySeduction,8,0,0,0,"Your fetishy nurse outfit allows you access to an improved form of 'Tease'.");
		public const OVERALL:Armor = new Armor("Overall", "Overalls", "white shirt and overalls", "a white shirt and overalls", 0, 60, "A simple white shirt and overalls.", "Light", true);
		public const R_BDYST:Armor = new Armor("R.BdySt","R.BdySt","red, high-society bodysuit","a red bodysuit for high society",1,1200,"A high society bodysuit. It is as easy to mistake it for ballroom apparel as it is for boudoir lingerie. The thin transparent fabric is so light and airy that it makes avoiding blows a second nature.","Light", true, false);
		public const RBBRCLT:ArmorWithPerk = new ArmorWithPerk("RbbrClt","Rbbr Fetish","rubber fetish clothes","a set of revealing rubber fetish clothes",3,1000,"A revealing set of fetish-wear.  Upgrades your tease attack with the \"Slutty Seduction\" perk.","Light",
				PerkLib.SluttySeduction,8,0,0,0,"Your fetishy rubberwear allows you access to 'Seduce', an improved form of 'Tease'.",null,0,0,0,0,"", true, false);
		public const S_SWMWR:SluttySwimwear = new SluttySwimwear();
		public const T_BSUIT:ArmorWithPerk = new ArmorWithPerk("T.BSuit","Bodysuit","semi-transparent bodysuit","a semi-transparent, curve-hugging bodysuit",0,1300,"A semi-transparent bodysuit. It looks like it will cling to all the curves of your body.","Light",
				PerkLib.SluttySeduction,7,0,0,0,"Your clingy transparent bodysuit allows you access to 'Seduce', an improved form of 'Tease'.");
		public const TUBETOP:Armor = new Armor("TubeTop","Tube Top","tube top and short shorts","a snug tube top and VERY short shorts",0,80,"A clingy tube top and VERY short shorts.","Light");

		//Armour
		public const BEEARMR:Armor = new BeeArmor();
		public const CHBIKNI:ArmorWithPerk = new ArmorWithPerk("ChBikni","Chn Bikini","revealing chainmail bikini","a chainmail bikini",2,700,"A revealing chainmail bikini that barely covers anything.  The bottom half is little more than a triangle of metal and a leather thong.","Light",
				PerkLib.SluttySeduction,5,0,0,0,"Your revealing chain bikini allows you access to 'Seduce', an improved form of 'Tease'.",null,0,0,0,0,"", false, false);
		public const DBARMOR:Armor = new PureMaraeArmor();
		public const DSCLARM:Armor = new Armor("DSclArm", "D.Scale Armor", "dragonscale armor", "a suit of dragonscale armor", 18, 900, "This armor is cleverly fashioned from dragon scales. It offers high protection while at the same time, quite flexible.", "Medium");
		public const DSCLROB:Armor = new ArmorWithPerk("DSclRob", "D.Scale Robes", "dragonscale robes", "a dragonscale robes", 9, 900, "This robe is expertly made from dragon scales. It offers high protection while being lightweight and should be comfortable to wear all day.", "Light",
				PerkLib.WizardsEndurance,20,0,0,0);
		public const EBNARMR:Armor = new ArmorWithPerk("EWPlate", "EW Plate", "Ebonweave Platemail", "a set of Ebonweave Platemail", 27, 3000, "The armor is made of ebonweave, created using refined Ebonbloom petals. The armor consists of two layers: an outer of ebonweave plating and an inner of arrow-proof ebonweave cloth.", "Heavy",
				PerkLib.WizardsEndurance,15,0,0,0);
		public const EBNJACK:Armor = new ArmorWithPerk("EWJackt", "EW Jacket", "Ebonweave Jacket", "an Ebonweave Jacket", 18, 3000, "This outfit is made of ebonweave, created using refined Ebonbloom petals. The outfit consists of a leather-like jacket, a mesh breastplate, and a set of arrow-proof clothing.", "Medium",
				PerkLib.WizardsEndurance,15,0,0,0);
		public const EBNROBE:Armor = new ArmorWithPerk("EW Robe", "EW Robe", "Ebonweave Robe", "an Ebonweave Robe", 9, 3000, "This robe is made of ebonweave, a material created using refined Ebonbloom petals. This robe is comfortable, yet more protective than chainmail. It has a mystical aura to it.", "Medium",
				PerkLib.WizardsEndurance,30,0,0,0);
		public const EBNIROB:Armor = new ArmorWithPerk("EWIRobe", "EW I.Robe", "indecent Ebonweave Robe", "an indecent Ebonweave Robe", 6, 3000, "More of a longcoat than a robe, this outfit is crafted from refined Ebonbloom petals. Discrete straps centered around the belt keep the front open.", "Light",
				PerkLib.WizardsEndurance,30,0,0,0,"",
				PerkLib.SluttySeduction,5,0,0,0,"Your revealing robes allow you access to 'Seduce', an improved form of 'Tease'.", true);
		public const FULLCHN:Armor = new Armor("FullChn","Full Chain","full-body chainmail","a full suit of chainmail armor",8,150,"This full suit of chainmail armor covers its wearer from head to toe in protective steel rings.","Medium");
		public const FULLPLT:Armor = new Armor("FullPlt","Full Plate","full platemail","a suit of full-plate armor",21,250,"A highly protective suit of steel platemail.  It would be hard to find better physical protection than this.","Heavy");
		public const GELARMR:Armor = new Armor("GelArmr","GelArmr","glistening gel-armor plates","a suit of gel armor",10,150,"This suit of interlocking plates is made from a strange green material.  It feels spongy to the touch but is amazingly resiliant.","Heavy");
		public const GOOARMR:GooArmor = new GooArmor();
		public const I_CORST:InquisitorsCorset = new InquisitorsCorset();
		public const I_ROBES:InquisitorsRobes = new InquisitorsRobes();
		public const INDECST:ArmorWithPerk = new ArmorWithPerk("IndecSt","Indec StAr","practically indecent steel armor","a suit of practically indecent steel armor",5,800,"This suit of steel 'armor' has two round disks that barely cover the nipples, a tight chainmail bikini, and circular butt-plates.","Medium",
				PerkLib.SluttySeduction,6,0,0,0,"Your incredibly revealing steel armor allows you access to 'Seduce', an improved form of 'Tease'.");
		public const LEATHRA:Armor = new Armor("LeathrA","LeathrA","leather armor segments","a set of leather armor",5,76,"This is a suit of well-made leather armor.  It looks fairly rugged.","Light");
		public const URTALTA:LeatherArmorSegments = new LeatherArmorSegments();
		public const LMARMOR:LustyMaidensArmor = new LustyMaidensArmor();
		public const LTHCARM:LethiciteArmor = new LethiciteArmor();
		public const LTHRROB:Armor = new Armor("LthrRob","Lthr Robes","black leather armor surrounded by voluminous robes","a suit of black leather armor with voluminous robes",6,100,"This is a suit of flexible leather armor with a voluminous set of concealing black robes.","Light");
		public const TBARMOR:Armor = new MaraeArmor();
		public const SAMUARM:Armor = new Armor("SamuArm","Samu.Armor","samurai armor","a suit of samurai armor",18,300,"This suit of armor is originally worn by the Samurai, the warriors from the far East.","Heavy");
		public const SCALEML:Armor = new Armor("ScaleMl","Scale Mail","scale-mail armor","a set of scale-mail armor",12,170,"This suit of scale-mail covers the entire body with layered steel scales, providing flexibility and protection.","Heavy");
		public const SEDUCTA:SeductiveArmor = new SeductiveArmor();
		public const SEDUCTU:SeductiveArmorUntrapped = new SeductiveArmorUntrapped();
		public const SS_ROBE:ArmorWithPerk = new ArmorWithPerk("SS.Robe","SS.Robes","spider-silk robes","a spider-silk robes",6,950,"This robe looks incredibly comfortable.  It's made from alchemically enhanced spider-silk, and embroidered with what looks like magical glyphs around the sleeves and hood.","Light",
				PerkLib.WizardsEndurance,30,0,0,0);
		public const SSARMOR:Armor = new Armor("SSArmor","SS.Armor","spider-silk armor","a suit of spider-silk armor",25,950,"This armor is as white as the driven snow.  It's crafted out of thousands of strands of spider-silk into an impenetrable protective suit.  The surface is slightly spongy, but so tough you wager most blows would bounce right off.","Heavy");
		public const W_ROBES:ArmorWithPerk = new ArmorWithPerk("W.Robes","W.Robes","wizard's robes","a wizard's robes",1,50,"These robes appear to have once belonged to a female wizard.  They're long with a slit up the side and full billowing sleeves.  The top is surprisingly low cut.  Somehow you know wearing it would aid your spellcasting.","Light",
				PerkLib.WizardsEndurance,25,0,0,0);
		public const FRSGOWN:Gown = new Gown();

		public function ArmorLib()
		{
		}
	}
}
