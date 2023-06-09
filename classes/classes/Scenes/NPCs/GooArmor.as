package classes.Scenes.NPCs
{
	import classes.*;
	import classes.BodyParts.*;
	import classes.BodyParts.Hips;
	import classes.GlobalFlags.kFLAGS;
	import classes.Scenes.Areas.Lake.GooGirl;
	import classes.internals.*;

	public class GooArmor extends GooGirl
	{
		public function gooArmorAI():void {
			if (rand(2) == 0 && !player.hasStatusEffect(StatusEffects.GooArmorSilence)) gooSilenceAttack();
			else if (rand(3) > 0) gooArmorAttackPhysical();
			else gooArmorAttackTwoGooConsume();
		}
		//ATTACK ONE: Greatsword
		public function gooArmorAttackPhysical():void {
			var evade:String = player.getEvasionReason();
			if (evade == EVASION_EVADE) {
				outputText("The goo-armor rushes forward and swings her sword in a mighty arc, but you evade the attack!");
			}
			else if (evade == EVASION_FLEXIBILITY) {
				outputText("The goo-armor swings a greatsword at you in a mighty arc, but your cat-like flexibility makes it easy to twist out of the way.");		
			}
			else if (evade == EVASION_MISDIRECTION) {
				outputText("The goo-armor swings a sword at you in a mighty arc, but your training with Raphael allows you to misdirect her into a miss!");	
			}
			else if (evade == EVASION_SPEED || evade != null) {
				outputText("The goo-armor rushes forward and swings her sword in a mighty arc, but you dodge it!");		
			}
			//HIT!
			else {
				outputText("The goo-armor rushes forward and swings her sword in a mighty arc.  You aren't quite quick enough to dodge her blow, and the goopy sword slams into you, throwing you back and leaving a nasty welt. ");
				var damage:Number = Math.round((str + weaponAttack + (game.valeria.valeriaSparIntensity() * 1.5)));
				damage = player.reduceDamage(damage);
				if (damage <= 0) damage = 1;
				outputCritical();
				damage = player.takeDamage(damage, true);
			}
			combatRoundOver();
		}
		//ATTACK TWO: Goo Consume
		public function gooArmorAttackTwoGooConsume():void {
			outputText("Suddenly, the goo-girl leaks half-way out of her heavy armor and lunges at you.  You attempt to dodge her attack, but she doesn't try and hit you - instead, she wraps around you, pinning your arms to your chest.  More and more goo latches onto you - you'll have to fight to get out of this.");
			player.createStatusEffect(StatusEffects.GooArmorBind,0,0,0,0);
			combatRoundOver();
		}
		//(Struggle)
		public function struggleAtGooBind():void {
			clearOutput();
			//If fail:
			if (rand(10) > 0 && player.str/5 + rand(20) < 23 + Math.min(5, Math.floor(game.valeria.valeriaSparIntensity() / 10))) {
				outputText("You try and get out of the goo's grasp, but every bit of goop you pull off you seems to be replaced by twice as much!");
				//(If fail 5 times, go to defeat scene)
				player.addStatusValue(StatusEffects.GooArmorBind,1,1);
				if (player.statusEffectv1(StatusEffects.GooArmorBind) >= 5) {
					if (hasStatusEffect(StatusEffects.Spar)) game.valeria.pcWinsValeriaSparDefeat();
					else game.dungeons.heltower.gooArmorBeatsUpPC();
					return;
				}
			}
			//If succeed: 
			else {
				outputText("You finally pull the goop off of you and dive out of her reach before the goo-girl can re-attach herself to you.  Pouting, she refills her suit of armor and reassumes her fighting stance.");
				player.removeStatusEffect(StatusEffects.GooArmorBind);
			}
			combatRoundOver();
		}
		//ATTACK THREE: Goo Silence
		public function gooSilenceAttack():void {
			outputText("The goo pulls a hand off her greatsword and shoots her left wrist out towards you.  You recoil as a bit of goop slaps onto your mouth, preventing you from speaking - looks like you're silenced until you can pull it off!");
			//(No spells until PC passes a moderate STR check or burns it away)
			player.createStatusEffect(StatusEffects.GooArmorSilence,0,0,0,0);
			combatRoundOver();
		}
		
		override protected function performCombatAction():void
		{
			gooArmorAI();
		}
		
		override public function defeated(hpVictory:Boolean):void
		{
			if (hasStatusEffect(StatusEffects.Spar)) game.valeria.pcWinsValeriaSpar();
			else game.dungeons.heltower.beatUpGooArmor();
		}
		
		override public function won(hpVictory:Boolean, pcCameWorms:Boolean):void
		{
			if (pcCameWorms){
				outputText("\n\nThe armored goo sighs while you exhaust yourself...");
				doNext(game.combat.endLustLoss);
			} else {
				if (hasStatusEffect(StatusEffects.Spar)) game.valeria.pcWinsValeriaSparDefeat();
				else game.dungeons.heltower.gooArmorBeatsUpPC();
			}
		}
		
		public function GooArmor()
		{
			super(true);
			this.a = "a ";
			this.short = "Goo Armor";
			if (flags[kFLAGS.MET_VALERIA] > 0) {
				a = "";
				short = "Valeria";
			}
			this.imageName = "gooarmor";
			this.long = "Before you stands a suit of plated mail armor filled with a bright blue goo, standing perhaps " + UnitSystem.displayHeight2EstimateTextually(6) + " off the ground.  She has a beautiful, feminine face, and her scowl as she stands before you is almost cute.  She has formed a mighty greatsword from her goo, and has assumed the stance of a well-trained warrior.";
			this.race = "Goo-Girl";
			// this.plural = false;
			this.createVagina(false, Vagina.WETNESS_SLAVERING, Vagina.LOOSENESS_GAPING_WIDE);
			createBreastRow(Appearance.breastCupInverse("C"));
			this.ass.analLooseness = Ass.LOOSENESS_STRETCHED;
			this.ass.analWetness = Ass.WETNESS_SLIME_DROOLING;
			this.tallness = rand(8) + 70;
			this.hips.rating = Hips.RATING_AMPLE+2;
			this.butt.rating = Butt.RATING_LARGE;
			this.skin.tone = "blue";
			this.skin.setType(Skin.GOO);
			this.skin.adj = "goopey";
			this.hair.color = "black";
			this.hair.length = 15;
			this.hair.type = Hair.GOO;
			initStrTouSpeInte(60, 50, 50, 40);
			initLibSensCor(60, 35, 50);
			this.weaponName = "goo sword";
			this.weaponVerb="slash";
			this.weaponAttack = 60;
			this.armorName = "armor";
			this.armorDef = 50;
			this.bonusHP = 500;
			this.lustVuln = .35;
			this.temperment = TEMPERMENT_LOVE_GRAPPLES;
			this.level = 16;
			this.gems = rand(25) +40;
			this.drop = NO_DROP;
			//<Intensity>
			this.applySparIntensity(game.valeria.valeriaSparIntensity(), 15, 2, 2, 50);
			this.armorDef += Math.floor(game.valeria.valeriaSparIntensity() / 3);
			//</Intensity>
			checkMonster();
		}
		
	}

}
