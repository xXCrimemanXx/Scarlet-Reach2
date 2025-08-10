////click cooldowns, in tenths of a second, used for various combat actions
//#define CLICK_CD_EXHAUSTED 35
//#define CLICK_CD_MELEE 12
//#define CLICK_CD_RANGE 4
//#define CLICK_CD_RAPID 2

/datum/intent
	var/name = "intent"
	var/desc = ""
	var/icon_state = "instrike"
	var/list/attack_verb = list("hits", "strikes")
	var/obj/item/masteritem
	var/mob/living/mastermob
	var/unarmed = FALSE
	var/intent_type
	var/animname = "strike"
	var/blade_class = BCLASS_BLUNT
	var/list/hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg')
	var/canparry = TRUE
	var/candodge = TRUE
	var/chargetime = 0 //if above 0, this attack must be charged to reach full damage
	var/chargedrain = 0 //how mcuh fatigue is removed every second when at max charge
	var/releasedrain = 1 //drain when we go off, regardless
	var/misscost = 1	//extra drain from missing only, ALSO APPLIED IF ENEMY DODGES
	var/tranged = 0
	var/noaa = FALSE //turns off auto aiming, also turns off the 'swooshes'
	var/warnie = ""
	var/pointer = 'icons/effects/mousemice/human_attack.dmi'
	var/clickcd = CLICK_CD_MELEE //the cd invoked clicking on stuff with this intent
	var/recovery = 0		//RTD unable to move for this duration after an attack without becoming off balance
	var/list/charge_invocation //list of stuff to say while charging
	var/no_early_release = FALSE //we can't shoot off early
	var/movement_interrupt = FALSE //we cancel charging when changing mob direction, for concentration spells
	var/rmb_ranged = FALSE //we execute a proc with the same name when rmbing at range with no offhand intent selected
	var/tshield = FALSE //probably needed or something
	var/datum/looping_sound/chargedloop = null
	var/keep_looping = TRUE
	var/damfactor = 1 //multiplied by weapon's force for damage
	var/penfactor = 0 //see armor_penetration
	var/intent_intdamage_factor = 1 // Whether the intent itself has integrity damage modifier. Used for rend.
	var/item_d_type = "blunt" // changes the item's attack type ("blunt" - area-pressure attack, "slash" - line-pressure attack, "stab" - point-pressure attack)
	var/charging_slowdown = 0
	var/warnoffset = 0
	var/swingdelay = 0
	var/no_attack = FALSE //causes a return in /attack() but still allows to be used in attackby(
	var/reach = 1 //In tiles, how far this weapon can reach; 1 for adjacent, which is default
	var/miss_text //THESE ARE FOR UNARMED MISSING ATTACKS
	var/miss_sound //THESE ARE FOR UNARMED MISSING ATTACKS
	var/allow_offhand = TRUE	//Do I need my offhand free while using this intent?
	var/peel_divisor = 0		//How many consecutive peel hits this intent requires to peel a piece of coverage? May be overriden by armor thresholds if they're higher.
	var/glow_intensity = null	//How much glow this intent has. Used for spells
	var/glow_color = null // The color of the glow. Used for spells
	var/mob_light = null // tracking mob_light
	var/obj/effect/mob_charge_effect = null // The effect to be added (on top) of the mob while it is charging


	var/list/static/bonk_animation_types = list(
		BCLASS_BLUNT,
		BCLASS_SMASH,
	)
	var/list/static/swipe_animation_types = list(
		BCLASS_CUT,
		BCLASS_CHOP,
	)
	var/list/static/thrust_animation_types = list(
		BCLASS_STAB,
		BCLASS_PICK,
	)


/datum/intent/Destroy()
	if(chargedloop)
		chargedloop.stop()
	if(mob_light)
		QDEL_NULL(mob_light)
	if(mob_charge_effect)
		mastermob.vis_contents -= mob_charge_effect
	if(mastermob.curplaying == src)
		mastermob.curplaying = null
	mastermob = null
	masteritem = null
	return ..()

/datum/intent/proc/examine(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b> intent</span>"
	if(desc)
		inspec += "\n[desc]"
	if(reach != 1)
		inspec += "\n<b>Reach:</b> [reach]"
	if(damfactor != 1)
		inspec += "\n<b>Damage:</b> [damfactor]"
	if(penfactor)
		inspec += "\n<b>Armor Penetration:</b> [penfactor < 0 ? "NONE" : penfactor]"
	if(get_chargetime())
		inspec += "\n<b>Charge Time</b>"
	if(movement_interrupt)
		inspec += "\n<b>Interrupted by Movement</b>"
	if(no_early_release)
		inspec += "\n<b>No Early Release</b>"
	if(chargedrain)
		inspec += "\n<b>Drain While Charged:</b> [chargedrain]"
	if(releasedrain)
		inspec += "\n<b>Drain On Release:</b> [releasedrain]"
	if(misscost)
		inspec += "\n<b>Drain On Miss:</b> [misscost]"
	if(clickcd != CLICK_CD_MELEE)
		inspec += "\n<b>Recovery Time:</b> "
		if(clickcd < CLICK_CD_MELEE)
			inspec += "Quick"
		if(clickcd > CLICK_CD_MELEE)
			inspec += "Slow"
	if(blade_class == BCLASS_PEEL)
		inspec += "\nThis intent will peel the coverage off of your target's armor in non-key areas after [peel_divisor] consecutive hits.\nSome armor may have higher thresholds."
	if(!allow_offhand)
		inspec += "\nThis intent requires a free off-hand."
	if(blade_class == BCLASS_EFFECT)
		var/datum/intent/effect/int = src
		inspec += "\nThis intent will apply a status effect on a successful hit. Damage dealt is not required."
		if(length(int.target_parts))
			inspec += "\nWorks on these bodyparts: "
			var/str
			for(var/part in int.target_parts)
				str +="|[bodyzone2readablezone(part)]|"
			inspec += str
	if(intent_intdamage_factor != 1)
		var/percstr = abs(intent_intdamage_factor - 1) * 100
		inspec += "\nThis intent deals [percstr]% [intent_intdamage_factor > 1 ? "more" : "less"] damage to integrity."
	inspec += "<br>----------------------"

	to_chat(user, "[inspec.Join()]")

/datum/intent/proc/get_chargetime()
	if(chargetime)
		return chargetime
	else
		return 0

/datum/intent/proc/get_chargedrain()
	if(chargedrain)
		return chargedrain
	else
		return 0

/datum/intent/proc/get_releasedrain()
	if(releasedrain)
		return releasedrain
	else
		return 0

/datum/intent/proc/parrytime()
	return 0

/datum/intent/proc/prewarning()
	return

/datum/intent/proc/rmb_ranged(atom/target, mob/user)
	return

/datum/intent/proc/can_charge()
	return TRUE

/datum/intent/proc/afterchange()
	if(masteritem)
		masteritem.d_type = item_d_type
		var/list/benis = hitsound
		if(benis)
			masteritem.hitsound = benis
	return

/datum/intent/proc/height2limb(height as num)
	var/list/returned
	switch(height)
		if(2)
			returned += list(BODY_ZONE_HEAD)
		if(1)
			returned += list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_CHEST)
		if(0)
			returned += list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	return returned


/// returns the attack animation type this intent uses
/datum/intent/proc/get_attack_animation_type()
	if(blade_class in bonk_animation_types)
		return ATTACK_ANIMATION_BONK
	if(blade_class in swipe_animation_types)
		return ATTACK_ANIMATION_SWIPE
	if(blade_class in thrust_animation_types)
		return ATTACK_ANIMATION_THRUST
	return null

/datum/intent/New(Mastermob, Masteritem)
	..()
	if(Mastermob)
		if(isliving(Mastermob))
			mastermob = Mastermob
			if(chargedloop)
				update_chargeloop()
	if(Masteritem)
		masteritem = Masteritem

/datum/intent/proc/update_chargeloop() //what the fuck is going on here lol
	if(mastermob)
		if(chargedloop)
			if(!istype(chargedloop))
				chargedloop = new chargedloop(mastermob)

/datum/intent/proc/on_charge_start() //what the fuck is going on here lol
	if(mastermob.curplaying)
		mastermob.curplaying.chargedloop.stop()
		mastermob.curplaying = null
	if(chargedloop)
		if(!istype(chargedloop, /datum/looping_sound))
			chargedloop = new chargedloop(mastermob)
		else
			chargedloop.stop()
		chargedloop.start(chargedloop.parent)
		mastermob.curplaying = src
	if(glow_color && glow_intensity)
		mob_light = mastermob.mob_light(glow_color, glow_intensity)
	if(mob_charge_effect)
		mastermob.vis_contents += mob_charge_effect

/datum/intent/proc/on_mouse_up()
	if(chargedloop)
		chargedloop.stop()
	if(mastermob?.curplaying == src)
		mastermob?.curplaying = null
	if(mob_light)
		qdel(mob_light)
	if(mob_charge_effect)
		mastermob?.vis_contents -= mob_charge_effect


/datum/intent/proc/on_mmb(atom/target, mob/living/user, params)
	return

/datum/intent/use
	name = "use"
	icon_state = "inuse"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0
	no_attack = TRUE
	releasedrain = 0
	blade_class = BCLASS_PUNCH

/datum/intent/give
	name = "give"
	candodge = FALSE
	canparry = FALSE
	chargedrain = 0
	chargetime = 0
	noaa = TRUE
	pointer = 'icons/effects/mousemice/human_give.dmi'

/datum/looping_sound/invokegen
	mid_sounds = list('sound/magic/charging.ogg')
	mid_length = 130
	volume = 100
	extra_range = 3

/datum/looping_sound/invokefire
	mid_sounds = list('sound/magic/charging_fire.ogg')
	mid_length = 130
	volume = 100
	extra_range = 3

/datum/looping_sound/invokelightning
	mid_sounds = list('sound/magic/charging_lightning.ogg')
	mid_length = 130
	volume = 100
	extra_range = 3

/datum/looping_sound/invokeholy
	mid_sounds = list('sound/magic/holycharging.ogg')
	mid_length = 320
	volume = 100
	extra_range = 3

/datum/looping_sound/invokeascendant
	mid_sounds = list('sound/magic/chargingold.ogg')
	mid_length = 320
	volume = 100
	extra_range = 5

/datum/looping_sound/flailswing
	mid_sounds = list('sound/combat/wooshes/flail_swing.ogg')
	mid_length = 7
	volume = 100


/datum/intent/hit
	name = "hit"
	icon_state = "instrike"
	attack_verb = list("hit", "strike")
	item_d_type = "blunt"
	chargetime = 0
	swingdelay = 0

/datum/intent/stab
	name = "stab"
	icon_state = "instab"
	attack_verb = list("stab")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	animname = "stab"
	item_d_type = "stab"
	blade_class = BCLASS_STAB
	chargetime = 0
	swingdelay = 0

/datum/intent/stab/militia
	name = "militia stab"
	damfactor = 1.1
	penfactor = 50

/datum/intent/pick //now like icepick intent, we really went in a circle huh
	name = "pick"
	icon_state = "inpick"
	attack_verb = list("picks","impales")
	hitsound = list('sound/combat/hits/pick/genpick (1).ogg', 'sound/combat/hits/pick/genpick (2).ogg')
	penfactor = 80
	animname = "strike"
	item_d_type = "stab"
	blade_class = BCLASS_PICK
	chargetime = 0
	swingdelay = 12

/datum/intent/pick/ranged
	name = "ranged pick"
	icon_state = "inpick"
	attack_verb = list("stabs", "impales")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 60
	damfactor = 1.1
	chargetime = 0.7
	chargedrain = 2
	reach = 2
	no_early_release = TRUE
	blade_class = BCLASS_PICK

/datum/intent/shoot //shooting crossbows or other guns, no parrydrain
	name = "shoot"
	icon_state = "inshoot"
	tranged = 1
	warnie = "aimwarn"
	item_d_type = "stab"
	chargetime = 0.1
	no_early_release = FALSE
	noaa = TRUE
	charging_slowdown = 3
	warnoffset = 20
	var/strength_check = FALSE //used when we fire HEAVY bows

/datum/intent/shoot/prewarning()
	if(masteritem && mastermob)
		mastermob.visible_message(span_warning("[mastermob] aims [masteritem]!"))

/datum/intent/arc
	name = "arc"
	icon_state = "inarc"
	tranged = 1
	warnie = "aimwarn"
	item_d_type = "blunt"
	chargetime = 0
	no_early_release = FALSE
	noaa = TRUE
	charging_slowdown = 3
	warnoffset = 20
	var/strength_check = FALSE //used when we fire HEAVY bows
	
/datum/intent/proc/arc_check()
	return FALSE

/datum/intent/arc/arc_check()
	return TRUE

/datum/intent/arc/prewarning()
	if(masteritem && mastermob)
		mastermob.visible_message(span_warning("[mastermob] aims [masteritem]!"))

/datum/intent/swing //swinging a sling, no parrydrain
	name = "swing"
	icon_state = "inshoot"
	tranged = 1
	warnie = "aimwarn"
	item_d_type = "stab"
	chargetime = 0.1
	no_early_release = FALSE
	noaa = TRUE
	charging_slowdown = 3
	warnoffset = 20

/datum/intent/swing/prewarning()
	if(masteritem && mastermob)
		mastermob.visible_message(span_warning("[mastermob] swings [masteritem]!"))

/datum/intent/unarmed
	unarmed = TRUE

/datum/intent/unarmed/punch
	name = "punch"
	icon_state = "inpunch"
	attack_verb = list("punches", "jabs", "clocks", "strikes")
	chargetime = 0
	noaa = FALSE
	animname = "bite"
	hitsound = list('sound/combat/hits/punch/punch (1).ogg', 'sound/combat/hits/punch/punch (2).ogg', 'sound/combat/hits/punch/punch (3).ogg')
	misscost = 5
	releasedrain = 2	//Lowered for intent stam usage.
	swingdelay = 0
	clickcd = 10
	rmb_ranged = TRUE
	candodge = TRUE
	canparry = TRUE
	blade_class = BCLASS_PUNCH
	miss_text = "swing a fist at the air"
	miss_sound = "punchwoosh"
	item_d_type = "blunt"
	intent_intdamage_factor = 0.5

/datum/intent/unarmed/punch/rmb_ranged(atom/target, mob/user)
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_warning("[user] taunts [M]!"), span_warning("I taunt [M]!"), ignored_mobs = targetl)
		user.emote("taunt")
		if(M.client)
			if(M.can_see_cone(user))
				to_chat(M, span_danger("[user] taunts me!"))
		else
			M.taunted(user)
	return

/datum/intent/unarmed/claw
	name = "claw"
	//icon_state
	attack_verb = list("mauls", "scratches", "claws")
	chargetime = 0
	animname = "blank22"
	hitsound = list('sound/combat/hits/punch/punch (1).ogg', 'sound/combat/hits/punch/punch (2).ogg', 'sound/combat/hits/punch/punch (3).ogg')
	misscost = 5
	releasedrain = 4	//More than punch cus pen factor.
	swingdelay = 0
	penfactor = 10
	candodge = TRUE
	canparry = TRUE
	blade_class = BCLASS_CUT
	miss_text = "claw at the air"
	miss_sound = "punchwoosh"
	item_d_type = "slash"
	

/datum/intent/unarmed/shove
	name = "shove"
	icon_state = "inshove"
	attack_verb = list("shoves", "pushes")
	chargetime = 0
	noaa = TRUE
	rmb_ranged = TRUE
	misscost = 5
	item_d_type = "blunt"

/datum/intent/unarmed/shove/rmb_ranged(atom/target, mob/user)
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_blue("[user] shoos [M] away."), span_blue("I shoo [M] away."), ignored_mobs = targetl)
		if(M.client)
			if(M.can_see_cone(user))
				to_chat(M, span_blue("[user] shoos me away."))
		else
			M.shood(user)
	return

/datum/intent/unarmed/grab
	name = "grab"
	icon_state = "ingrab"
	attack_verb = list("grabs")
	chargetime = 0
	noaa = TRUE
	rmb_ranged = TRUE
	releasedrain = 10
	misscost = 8
	candodge = TRUE
	canparry = TRUE
	item_d_type = "blunt"

/datum/intent/unarmed/grab/rmb_ranged(atom/target, mob/user)
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_green("[user] beckons [M] to come closer."), span_green("I beckon [M] to come closer."), ignored_mobs = targetl)
		if(M.client)
			if(M.can_see_cone(user))
				to_chat(M, span_green("[user] beckons me to come closer."))
		else
			M.beckoned(user)
	return

/datum/intent/unarmed/help
	name = "touch"
	icon_state = "intouch"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 0
	releasedrain = 0
	rmb_ranged = TRUE

/datum/intent/unarmed/help/rmb_ranged(atom/target, mob/user)
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_green("[user] waves friendly at [M]."), span_green("I wave friendly at [M]."), ignored_mobs = targetl)
		if(M.client)
			if(M.can_see_cone(user))
				to_chat(M, span_green("[user] gives me a friendly wave."))
	return

/datum/intent/simple/headbutt
	name = "headbutt"
	icon_state = "instrike"
	attack_verb = list("headbutts", "rams")
	animname = "blank22"
	blade_class = BCLASS_BLUNT
	hitsound = "punch_hard"
	chargetime = 0
	penfactor = 10
	swingdelay = 0
	candodge = TRUE
	canparry = TRUE
	item_d_type = "blunt"

/datum/intent/simple/claw
	name = "claw"
	icon_state = "instrike"
	attack_verb = list("claws", "pecks")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 0
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	miss_text = "slash the air"
	item_d_type = "slash"

/datum/intent/simple/bite
	name = "bite"
	icon_state = "instrike"
	attack_verb = list("bites")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 0
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_d_type = "stab"


/datum/intent/simple/axe
	name = "hack"
	icon_state = "instrike"
	attack_verb = list("hacks at", "chops at", "bashes")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = list("genchop", "genslash")
	chargetime = 0
	penfactor = 0
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_d_type = "slash"

/datum/intent/simple/spear
	name = "spear"
	icon_state = "instrike"
	attack_verb = list("stabs", "skewers")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = list("genthrust", "genstab")
	chargetime = 0
	penfactor = 0
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_d_type = "stab"

/datum/intent/bless
	name = "bless"
	icon_state = "inbless"
	no_attack = TRUE
	candodge = TRUE
	canparry = TRUE

/datum/intent/weep
	name = "weep"
	icon_state = "inweep"
	no_attack = TRUE
	candodge = FALSE
	canparry = FALSE

/datum/intent/effect
	blade_class = BCLASS_EFFECT
	var/datum/status_effect/intent_effect	//Status effect this intent will apply on a successful hit (damage not needed)
	var/list/target_parts					//Targeted bodyparts which will apply the effect. Leave blank for anywhere on the body.

/datum/intent/effect/daze
	name = "dazing strike"
	icon_state = "indaze"
	attack_verb = list("dazes")
	animname = "strike"
	hitsound = list('sound/combat/hits/blunt/daze_hit.ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 6
	damfactor = 1
	item_d_type = "blunt"
	intent_effect = /datum/status_effect/debuff/dazed
	target_parts = list(BODY_ZONE_HEAD)

/*/datum/intent/effect/daze/shield
	intent_effect = /datum/status_effect/debuff/dazed/shield
	swingdelay = 3 */
