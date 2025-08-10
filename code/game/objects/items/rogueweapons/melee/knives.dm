//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/dagger
	clickcd = 8

/datum/intent/dagger/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 0
	chargetime = 0
	swingdelay = 0
	clickcd = 10
	item_d_type = "slash"

/datum/intent/dagger/thrust
	name = "thrust"
	icon_state = "instab"
	attack_verb = list("thrusts")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 40
	chargetime = 0
	clickcd = 8
	item_d_type = "stab"

/datum/intent/dagger/thrust/pick
	name = "icepick stab"
	icon_state = "inpick"
	attack_verb = list("stabs", "impales")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 80
	clickcd = 14
	swingdelay = 12
	damfactor = 1.1
	blade_class = BCLASS_PICK

/datum/intent/dagger/sucker_punch
	name = "sucker punch"
	icon_state = "inpunch"
	attack_verb = list("punches", "jabs",)
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg', 'sound/combat/hits/kick/kick.ogg')
	damfactor = 1
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = 14
	recovery = 10
	item_d_type = "blunt"
	canparry = FALSE
	candodge = FALSE

/datum/intent/dagger/chop
	name = "chop"
	icon_state = "inchop"
	attack_verb = list("chops")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 10
	damfactor = 1.5
	swingdelay = 5
	clickcd = 10
	item_d_type = "slash"

/datum/intent/dagger/chop/cleaver
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = 30

//knife and dagger objs ฅ^•ﻌ•^ฅ

/obj/item/rogueweapon/huntingknife
	force = 12
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/dagger/chop)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	name = "hunting knife"
	desc = "A hunter's prized possession. Keep it sharp, and it might last you through the wild."
	icon_state = "huntingknife"
	icon = 'icons/roguetown/weapons/32.dmi'
	item_state = "bone_dagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	gripsprite = FALSE
	//dropshrink = 0.75
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	max_blade_int = 100
	max_integrity = 175
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/knives
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	throwforce = 12
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	thrown_bclass = BCLASS_CUT
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron

	grid_height = 64
	grid_width = 32
	pickup_sound = 'modular_helmsguard/sound/sheath_sounds/draw_dagger.ogg'
	sheathe_sound = 'modular_helmsguard/sound/sheath_sounds/put_back_dagger.ogg'

	//flipping knives has a cooldown on to_chat to reduce chatspam
	COOLDOWN_DECLARE(flip_cooldown)

/obj/item/rogueweapon/huntingknife/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/peasantry/maciejowski_knife,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/rogueweapon/huntingknife/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -10,"sy" = 0,"nx" = 11,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/huntingknife/equipped(mob/user, slot, initial = FALSE)
	pickup_sound = pick("modular_helmsguard/sound/sheath_sounds/draw_dagger.ogg", "modular_helmsguard/sound/sheath_sounds/draw_dagger2.ogg", "sound/foley/equip/swordsmall2.ogg")
	. = ..()

/obj/item/rogueweapon/huntingknife/rmb_self(mob/user)
	. = ..()
	if(.)
		return

	SpinAnimation(4, 2) // The spin happens regardless of the cooldown

	if(!COOLDOWN_FINISHED(src, flip_cooldown))
		return

	COOLDOWN_START(src, flip_cooldown, 3 SECONDS)
	if((user.get_skill_level(/datum/skill/combat/knives) < 3) && prob(40))
		user.visible_message(
			span_danger("While trying to flip [src] [user] drops it instead!"),
			span_userdanger("While trying to flip [src] you drop it instead!"),
		)
		var/mob/living/carbon/human/unfortunate_idiot = user
		var/dropped_knife_target = pick(
			BODY_ZONE_PRECISE_L_FOOT,
			BODY_ZONE_PRECISE_R_FOOT,
			)
		unfortunate_idiot.apply_damage(src.force, BRUTE, dropped_knife_target)
		user.dropItemToGround(src, TRUE)
	else
		user.visible_message(
			span_notice("[user] spins [src] around [user.p_their()] finger"),
			span_notice("You spin [src] around your finger"),
		)
		playsound(src, 'sound/foley/equip/swordsmall1.ogg', 20, FALSE)

	return

/obj/item/rogueweapon/huntingknife/copper
	name = "copper knife"
	desc = "A knife made of copper. Lacking in durability."
	icon_state = "cdagger"
	max_integrity = 75
	smeltresult = null // TODO: We don't have partial melt so coping time

/obj/item/rogueweapon/huntingknife/cleaver
	force = 15
	name = "cleaver"
	desc = "Chop, chop, chop!"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver)
	icon_state = "cleaver"
	icon = 'icons/roguetown/weapons/32.dmi'
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	throwforce = 15
	slot_flags = ITEM_SLOT_HIP
	thrown_bclass = BCLASS_CHOP
	w_class = WEIGHT_CLASS_NORMAL
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/huntingknife/cleaver/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,
"sx" = -10,
"sy" = 0,
"nx" = 13,
"ny" = 2,
"wx" = -8,
"wy" = 2,
"ex" = 5,
"ey" = 2,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 21,
"sturn" = -18,
"wturn" = -18,
"eturn" = 21,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/huntingknife/chefknife
	force = 15
	name = "chef's knife"
	desc = "Keep it in the kitchen!"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver, /datum/intent/dagger/thrust)
	icon_state = "chefsknife"
	icon = 'icons/roguetown/weapons/32.dmi'
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	throwforce = 15
	slot_flags = ITEM_SLOT_HIP
	thrown_bclass = BCLASS_CUT
	w_class = WEIGHT_CLASS_SMALL
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/huntingknife/combat
	force = 16
	name = "seax"
	desc = "A fighting knife used amongst the Grenzels and Northerners for centuries, serving dual purpose as a \
	tool of daily life and as a capable fighting knife."
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver, /datum/intent/dagger/sucker_punch,)
	icon_state = "combatknife"
	icon = 'icons/roguetown/weapons/32.dmi'
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	throwforce = 16
	slot_flags = ITEM_SLOT_HIP
	thrown_bclass = BCLASS_CHOP
	w_class = WEIGHT_CLASS_NORMAL
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/huntingknife/combat/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -9,"sy" = 0,"nx" = 10,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 21,"sturn" = -29,"wturn" = -29,"eturn" = 33,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/huntingknife/idagger
	possible_item_intents = list(/datum/intent/dagger/thrust,/datum/intent/dagger/cut, /datum/intent/dagger/thrust/pick, /datum/intent/dagger/sucker_punch)
	force = 15
	max_integrity = 100
	name = "iron dagger"
	desc = "This is a common dagger of iron."
	icon_state = "idagger"
	smeltresult = /obj/item/ingot/iron
	blade_dulling = DULLING_SHAFT_REINFORCED

/obj/item/rogueweapon/huntingknife/idagger/adagger
	name = "decrepit dagger"
	desc = "an incredibly withered daggered. Aeon's grasp is upon its form."
	force = 12
	max_integrity = 75
	icon_state = "adagger"
	smeltresult = /obj/item/ingot/aalloy
	blade_dulling = DULLING_SHAFT_CONJURED

/obj/item/rogueweapon/huntingknife/idagger/steel/padagger
	name = "ancient dagger"
	desc = "A dagger made of ancient alloys. Aeon's grasp has been lifted from its form."
	icon_state = "adagger"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/huntingknife/idagger/steel
	name = "steel dagger"
	desc = "This is a dagger made of solid steel, more durable."
	icon_state = "sdagger"
	force = 20
	max_integrity = 150
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/huntingknife/idagger/steel/holysee
	name = "eclipsum dagger"
	desc = "A blade forged from the Holy metals of the twinned gods Noc and Astrata, Silver and Gold fused under an Eclipse and blessed, these daggers are very grudgingly given out by the Grenzelhoftian See to ordained Priests of the Ten."
	force = 25
	max_integrity = 200
	icon_state = "gsdagger"


/obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle
	name ="plaguebringer sickle"
	desc = "A wicked edge brings feculent delights."
	icon_state = "pestrasickle"
	max_integrity = 200

/*
	name = "facón"
	desc = "An ornate traditional Etruscan knife inlaid with silver, passed down through generations of farmhands and warlords alike."
	icon_state = "facon" */

/obj/item/rogueweapon/huntingknife/idagger/dtace
	name = "'De Tace'"
	desc = "The right hand of the right hand, this narrow length of steel serves as a quick solution to petty greviences."
	icon_state = "stiletto"
	force = 25
	max_integrity = 200
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/huntingknife/idagger/steel/parrying //direct upgrade but more costly.
	name = "steel parrying dagger"
	desc = "This is a parrying dagger made of solid steel, used to catch opponent's weapons in the handguard, but it's not as good for actual stabbing work."
	force = 15
	throwforce = 15
	icon_state = "spdagger"
	wdefense = 6

/obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero
	name = "sail dagger"
	desc = "An exceptionally protective parrying dagger popular in the Etruscan Isles, this dagger features a plain metal guard in the shape of a ship's sail."
	wdefense = 7
	force = 17
	throwforce = 17
	icon_state = "sail_dagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/special
	icon_state = "sdaggeralt"

/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
	name = "steel tanto"
	desc = "A steel dagger imported from the Kazengunese archipelago. A sturdy blade bears a subtle curve, set into a decorated circular crossguard. A waxed \
	wrapping of twisted cordage provides a secure grip."
	icon_state = "eastdagger"

/obj/item/rogueweapon/huntingknife/idagger/silver
	name = "silver dagger"
	desc = "This silver dagger can be the banishment of vampires and werewolves."
	icon_state = "sildagger"
	sellprice = 50
	smeltresult = /obj/item/ingot/silver
	last_used = 0
	is_silver = TRUE

/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
	name = "ornate dagger"
	desc = "An ornate dagger, plated in a ceremonial veneer of silver. The bane of those cursed, in the hands of a faithful hunter. \
	It is said that on induction into the Inquisitorial order, a new member of the martial arm is handed such a blade. A token, for their service."
	icon_state = "psydagger"
	sellprice = 70

/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger/ComponentInitialize()
	. = ..()					//+2 force, +50 int, +1 def, make silver
	AddComponent(/datum/component/psyblessed, FALSE, 2, FALSE, 50, 1, TRUE)

/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger/preblessed/ComponentInitialize()
	. = ..()					//Pre-blessed, +2 force, +50 int, +1 def, make silver
	AddComponent(/datum/component/psyblessed, TRUE, 2, FALSE, 50, 1, TRUE)

/obj/item/rogueweapon/huntingknife/idagger/silver/pickup(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	var/datum/antagonist/vampirelord/V_lord = H.mind.has_antag_datum(/datum/antagonist/vampirelord/)
	var/datum/antagonist/werewolf/W = H.mind.has_antag_datum(/datum/antagonist/werewolf/)
	if(ishuman(H))
		if(H.mind.has_antag_datum(/datum/antagonist/vampirelord/lesser))
			to_chat(H, span_userdanger("I can't pick up the silver, it is my BANE!"))
			H.Knockdown(10)
			H.Paralyze(10)
			H.adjustFireLoss(25)
			H.fire_act(1,10)
		if(V_lord)
			if(V_lord.vamplevel < 4 && !H.mind.has_antag_datum(/datum/antagonist/vampirelord/lesser))
				to_chat(H, span_userdanger("I can't pick up the silver, it is my BANE!"))
				H.Knockdown(10)
				H.adjustFireLoss(25)
		if(W && W.transformed == TRUE)
			to_chat(H, span_userdanger("I can't pick up the silver, it is my BANE!"))
			H.Knockdown(10)
			H.Paralyze(10)
			H.adjustFireLoss(25)
			H.fire_act(1,10)


/obj/item/rogueweapon/huntingknife/idagger/silver/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	. = ..()
	if(ishuman(M) && M.mind)
		var/mob/living/carbon/human/H = M
		var/datum/antagonist/vampirelord/V_lord = H.mind.has_antag_datum(/datum/antagonist/vampirelord/)
		var/datum/antagonist/werewolf/W = H.mind.has_antag_datum(/datum/antagonist/werewolf/)
		if(H.mind.has_antag_datum(/datum/antagonist/vampirelord/lesser))
			to_chat(H, span_userdanger("I can't equip the silver, it is my BANE!"))
			H.Knockdown(10)
			H.Paralyze(10)
			H.adjustFireLoss(25)
			H.fire_act(1,10)
		if(V_lord)
			if(V_lord.vamplevel < 4 && !H.mind.has_antag_datum(/datum/antagonist/vampirelord/lesser))
				to_chat(H, span_userdanger("I can't equip the silver, it is my BANE!"))
				H.Knockdown(5)
				H.Paralyze(5)
				H.adjustFireLoss(25)
				H.fire_act(1,5)
		if(W && W.transformed == TRUE)
			to_chat(H, span_userdanger("I can't equip the silver, it is my BANE!"))
			H.Knockdown(10)
			H.Paralyze(10)
			H.adjustFireLoss(25)
			H.fire_act(1,10)
			
/obj/item/weapon/knife/dagger/silver/arcyne
	name = "glowing purple silver dagger"
	desc = "This dagger glows a faint purple. Quicksilver runs across its blade."
	var/is_bled = FALSE

/obj/item/weapon/knife/dagger/silver/arcyne/Initialize()
	. = ..()
	filter(type="drop_shadow", x=0, y=0, size=2, offset=1, color=rgb(128, 0, 128, 1))

/obj/item/weapon/knife/dagger/silver/attackby(obj/item/M, mob/user, params)
	if(istype(M,/obj/item/rogueore/cinnabar))
		var/crafttime = (60 - ((user.get_skill_level(/datum/skill/magic/arcane)) * 5))
		if(do_after(user, crafttime, target = src))
			playsound(loc, 'sound/magic/scrapeblade.ogg', 100, TRUE)
			to_chat(user, span_notice("I press acryne magic into the blade and it throbs in a deep purple..."))
			var/obj/arcyne_knife = new /obj/item/weapon/knife/dagger/silver/arcyne
			qdel(M)
			qdel(src)
			user.put_in_active_hand(arcyne_knife)
	else
		return ..()

/obj/item/weapon/knife/dagger/silver/arcyne/attack_self(mob/living/carbon/human/user)
	if(!isarcyne(user))
		return
	var/obj/effect/decal/cleanable/roguerune/pickrune
	var/runenameinput = input(user, "Runes", "All Runes") as null|anything in GLOB.t4rune_types
	pickrune = GLOB.rune_types[runenameinput]
	if(!pickrune)
		return
	var/turf/Turf = get_turf(user)
	if(locate(/obj/effect/decal/cleanable/roguerune) in Turf)
		to_chat(user, span_cult("There is already a rune here."))
		return
	var/structures_in_way = check_for_structures_and_closed_turfs(loc, pickrune)
	if(structures_in_way == TRUE)
		to_chat(user, span_cult("There is a structure, rune or wall in the way."))
		return
	var/chosen_keyword
	if(pickrune.req_keyword)
		chosen_keyword = stripped_input(user, "Keyword for the new rune", "Runes", max_length = MAX_NAME_LEN)
		if(!chosen_keyword)
			return FALSE
	if(!is_bled)
		playsound(loc, get_sfx("genslash"), 100, TRUE)
		user.visible_message(span_warning("[user] cuts open [user.p_their()] palm!"), \
			span_cult("I slice open my palm!"))
		if(user.blood_volume)
			user.apply_damage(pickrune.scribe_damage, BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		is_bled = TRUE
	var/crafttime = (10 SECONDS - ((user.get_skill_level(/datum/skill/magic/arcane)) * 5))

	user.visible_message(span_warning("[user] begins to carve something with [user.p_their()] blade!"), \
		span_notice("I start to drag the blade in the shape of symbols and sigils."))
	playsound(loc, 'sound/magic/bladescrape.ogg', 100, TRUE)
	if(do_after(user, crafttime, target = src))
		if(QDELETED(src) || !pickrune)
			return
		user.visible_message(span_warning("[user] carves an arcyne rune with [user.p_their()] [src]!"), \
		span_notice("I finish dragging the blade in symbols and circles, leaving behind a [pickrune.name]."))
		new pickrune(Turf, chosen_keyword)

/obj/item/weapon/knife/dagger/proc/check_for_structures_and_closed_turfs(loc, obj/effect/decal/cleanable/roguerune/rune_to_scribe)
	for(var/turf/T in range(loc, rune_to_scribe.runesize))
		//check for /sturcture subtypes in the turf's contents
		for(var/obj/structure/S in T.contents)
			return TRUE		//Found a structure, no need to continue
		//check if turf itself is a /turf/closed subtype
		if(istype(T,/turf/closed))
			return TRUE
		//check if rune in the turfs contents
		for(var/obj/effect/decal/cleanable/roguerune/R in T.contents)
			return TRUE
		//Return false if nothing in range was found
	return FALSE

/obj/item/rogueweapon/huntingknife/stoneknife
	possible_item_intents = list(/datum/intent/dagger/cut,/datum/intent/dagger/chop)
	name = "stone knife"
	desc = "A crudely crafted knife made of stone."
	icon_state = "stone_knife"
	smeltresult = null
	max_integrity = 50
	max_blade_int = 50
	wdefense = 1
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/huntingknife/idagger/silver/elvish
	name = "elvish dagger"
	desc = "This beautiful dagger is of intricate, elvish design. Sharper, too."
	force = 22
	icon_state = "elfdagger"
	item_state = "elfdag"
	last_used = 0
	is_silver = TRUE

/obj/item/rogueweapon/huntingknife/idagger/silver/elvish/drow
	name = "drowish dagger"
	desc = "A vicious wave-bladed dagger from the Underdark."
	force = 25
	last_used = 0
	is_silver = TRUE

/obj/item/rogueweapon/huntingknife/idagger/navaja
	possible_item_intents = list(/datum/intent/dagger/thrust,/datum/intent/dagger/cut,  /datum/intent/dagger/thrust/pick)
	name = "navaja"
	desc = "A folding Etruscan knife valued by merchants, mercenaries and peasants for its convenience. It possesses a long hilt, allowing for a sizeable blade with good reach."
	force = 5
	icon_state = "navaja_c"
	item_state = "elfdag"
	var/extended = 0
	wdefense = 2
	sellprice = 30 //shiny :o

/obj/item/rogueweapon/huntingknife/idagger/navaja/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	if(extended)
		force = 20
		wdefense = 6
		w_class = WEIGHT_CLASS_NORMAL
		throwforce = 23
		icon_state = "navaja_o"
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		sharpness = IS_SHARP
		playsound(user, 'sound/items/knife_open.ogg', 100, TRUE)
	else
		force = 5
		w_class = WEIGHT_CLASS_SMALL
		throwforce = 5
		icon_state = "navaja_c"
		attack_verb = list("stubbed", "poked")
		sharpness = IS_BLUNT
		wdefense = 2

/obj/item/rogueweapon/huntingknife/throwingknife
	name = "iron tossblade"
	desc = "Paradoxical; why is it called a blade when it is meant for tossing? Or is it the act of cutting post-toss that makes it a blade? ...Are arrows tossblades, too?"
	item_state = "bone_dagger"
	force = 10
	throwforce = 22
	throw_speed = 4
	max_integrity = 50
	armor_penetration = 30
	wdefense = 1
	icon_state = "throw_knifei"
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 25, "embedded_fall_chance" = 10)
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/chop)
	smeltresult = null
	sellprice = 1
	thrown_damage_flag = "piercing"		//Checks piercing type like an arrow.

/obj/item/rogueweapon/huntingknife/throwingknife/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -3,"wx" = -4,"wy" = -3,"ex" = 5,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/huntingknife/throwingknife/kazengun
	name = "eastern tossblade"
	desc = "A four pointed throwing knife ground and sharpened from a single piece of metal. The design is intended to solve one of weaknesses of basic tossblades; \
	more points means these are more likely to land point-first."
	icon_state = "easttossblade"

/obj/item/rogueweapon/huntingknife/throwingknife/aalloy
	name = "decrepit tossblade"
	desc = "A decrepit old tossblade. You ought to throw cutlery instead."
	icon_state = "throw_knifea"
	force = 7
	throwforce = 16

/obj/item/rogueweapon/huntingknife/throwingknife/steel
	name = "steel tossblade"
	desc = "There are rumors of some sea-marauders loading these into metal tubes with explosive powder to launch then fast and far. Probably won't catch on."
	item_state = "bone_dagger"
	throwforce = 28
	max_integrity = 100
	armor_penetration = 40
	icon_state = "throw_knifes"
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 30, "embedded_fall_chance" = 5)
	sellprice = 2

/obj/item/rogueweapon/huntingknife/throwingknife/steel/palloy
	name = "ancient alloy tossblade"
	desc = "A tossblade crafted of ancient alloy. Aeon's grasp has been lifted from its form."
	icon_state = "throw_knifea"

/obj/item/rogueweapon/huntingknife/throwingknife/psydon
	name = "silver tossblade"
	desc = "An unconventional method of delivering silver to a heretic; but one that the Ten smile at, all the same. Doubles as an actual knife in a pinch, though obviously not as well."
	item_state = "bone_dagger"
	force = 12
	throwforce = 28
	armor_penetration = 50
	max_integrity = 150
	wdefense = 3
	icon_state = "throw_knifep"
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 50, "embedded_fall_chance" = 0)
	is_silver = TRUE
	sellprice = 6

/obj/item/rogueweapon/huntingknife/scissors
	possible_item_intents = list(/datum/intent/snip, /datum/intent/dagger/thrust, /datum/intent/dagger/cut)
	max_integrity = 100
	name = "iron scissors"
	desc = "Scissors made of iron that may be used to salvage usable materials from clothing."
	icon_state = "iscissors"

/obj/item/rogueweapon/huntingknife/scissors/steel
	force = 14
	max_integrity = 150
	name = "steel scissors"
	desc = "Scissors made of solid steel that may be used to salvage usable materials from clothing, more durable and a tad more deadly than their iron conterpart."
	icon_state = "sscissors"
	smeltresult = /obj/item/ingot/steel

/datum/intent/snip // The salvaging intent! Used only for the scissors for now!
	name = "snip"
	icon_state = "insnip"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0
	no_attack = TRUE
	releasedrain = 0
	blade_class = BCLASS_PUNCH

/obj/item/rogueweapon/huntingknife/scissors/attack(mob/living/M, mob/living/user)
	// Check if using snip intent and targeting a human's head or skull
	if(user.used_intent.type == /datum/intent/snip && ishuman(M))
		var/mob/living/carbon/human/H = M
		// Check if targeting the head or skull zone
		if(user.zone_selected == BODY_ZONE_HEAD || user.zone_selected == BODY_ZONE_PRECISE_SKULL)
			var/list/options = list("hairstyle", "facial hairstyle")
			var/chosen = input(user, "What would you like to style?", "Hair Styling") as null|anything in options
			if(!chosen)
				return

			switch(chosen)
				if("hairstyle")
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
					var/list/valid_hairstyles = list()
					for(var/hair_type in hair_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/head/hair = new hair_type()
						valid_hairstyles[hair.name] = hair_type

					var/new_style = input(user, "Choose their hairstyle", "Hair Styling") as null|anything in valid_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user] begins styling [H]'s hair..."), span_notice("You begin styling [H == user ? "your" : "[H]'s"] hair..."))
						if(!do_after(user, 30 SECONDS, target = H))
							to_chat(user, span_warning("The styling was interrupted!"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/head/current_hair = null
							for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
								current_hair = hair_feature
								break

							if(current_hair)
								var/datum/customizer_entry/hair/hair_entry = new()
								hair_entry.hair_color = current_hair.hair_color

								// Preserve gradients and their colors
								if(istype(current_hair, /datum/bodypart_feature/hair/head))
									hair_entry.natural_gradient = current_hair.natural_gradient
									hair_entry.natural_color = current_hair.natural_color
									if(hasvar(current_hair, "hair_dye_gradient"))
										hair_entry.dye_gradient = current_hair.hair_dye_gradient
									if(hasvar(current_hair, "hair_dye_color"))
										hair_entry.dye_color = current_hair.hair_dye_color

								var/datum/bodypart_feature/hair/head/new_hair = new()
								new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)
								hair_choice.customize_feature(new_hair, H, null, hair_entry)

								head.remove_bodypart_feature(current_hair)
								head.add_bodypart_feature(new_hair)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user] finishes styling [H]'s hair."), span_notice("You finish styling [H == user ? "your" : "[H]'s"] hair."))

				if("facial hairstyle")
					if(H.gender != MALE)
						to_chat(user, span_warning("They don't have facial hair to style!"))
						return
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
					var/list/valid_facial_hairstyles = list()
					for(var/facial_type in facial_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/facial/facial = new facial_type()
						valid_facial_hairstyles[facial.name] = facial_type

					var/new_style = input(user, "Choose their facial hairstyle", "Hair Styling") as null|anything in valid_facial_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user] begins styling [H]'s facial hair..."), span_notice("You begin styling [H == user ? "your" : "[H]'s"] facial hair..."))
						if(!do_after(user, 60 SECONDS, target = H))
							to_chat(user, span_warning("The styling was interrupted!"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/facial/current_facial = null
							for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
								current_facial = facial_feature
								break

							if(current_facial)
								var/datum/customizer_entry/hair/facial/facial_entry = new()
								facial_entry.hair_color = current_facial.hair_color
								facial_entry.accessory_type = current_facial.accessory_type

								var/datum/bodypart_feature/hair/facial/new_facial = new()
								new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)
								facial_choice.customize_feature(new_facial, H, null, facial_entry)

								head.remove_bodypart_feature(current_facial)
								head.add_bodypart_feature(new_facial)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user] finishes styling [H]'s facial hair."), span_notice("You finish styling [H == user ? "your" : "[H]'s"] facial hair."))
			return TRUE
	// If not using snip intent on head/skull or not a human, proceed with normal attack
	if(user.used_intent.type == /datum/intent/snip)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/list/options = list("hairstyle", "facial hairstyle")
			var/chosen = input(user, "What would you like to style?", "Hair Styling") as null|anything in options
			if(!chosen)
				return

			switch(chosen)
				if("hairstyle")
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
					var/list/valid_hairstyles = list()
					for(var/hair_type in hair_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/head/hair = new hair_type()
						valid_hairstyles[hair.name] = hair_type

					var/new_style = input(user, "Choose their hairstyle", "Hair Styling") as null|anything in valid_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user] begins styling [H]'s hair..."), span_notice("You begin styling [H == user ? "your" : "[H]'s"] hair..."))
						if(!do_after(user, 60 SECONDS, target = H))
							to_chat(user, span_warning("The styling was interrupted!"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/head/current_hair = null
							for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
								current_hair = hair_feature
								break

							if(current_hair)
								var/datum/customizer_entry/hair/hair_entry = new()
								hair_entry.hair_color = current_hair.hair_color

								// Preserve gradients and their colors
								if(istype(current_hair, /datum/bodypart_feature/hair/head))
									hair_entry.natural_gradient = current_hair.natural_gradient
									hair_entry.natural_color = current_hair.natural_color
									if(hasvar(current_hair, "hair_dye_gradient"))
										hair_entry.dye_gradient = current_hair.hair_dye_gradient
									if(hasvar(current_hair, "hair_dye_color"))
										hair_entry.dye_color = current_hair.hair_dye_color

								var/datum/bodypart_feature/hair/head/new_hair = new()
								new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)
								hair_choice.customize_feature(new_hair, H, null, hair_entry)

								head.remove_bodypart_feature(current_hair)
								head.add_bodypart_feature(new_hair)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user] finishes styling [H]'s hair."), span_notice("You finish styling [H == user ? "your" : "[H]'s"] hair."))

				if("facial hairstyle")
					if(H.gender != MALE)
						to_chat(user, span_warning("They don't have facial hair to style!"))
						return
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
					var/list/valid_facial_hairstyles = list()
					for(var/facial_type in facial_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/facial/facial = new facial_type()
						valid_facial_hairstyles[facial.name] = facial_type

					var/new_style = input(user, "Choose their facial hairstyle", "Hair Styling") as null|anything in valid_facial_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user] begins styling [H]'s facial hair..."), span_notice("You begin styling [H == user ? "your" : "[H]'s"] facial hair..."))
						if(!do_after(user, 60 SECONDS, target = H))
							to_chat(user, span_warning("The styling was interrupted!"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/facial/current_facial = null
							for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
								current_facial = facial_feature
								break

							if(current_facial)
								var/datum/customizer_entry/hair/facial/facial_entry = new()
								facial_entry.hair_color = current_facial.hair_color
								facial_entry.accessory_type = current_facial.accessory_type

								var/datum/bodypart_feature/hair/facial/new_facial = new()
								new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)
								facial_choice.customize_feature(new_facial, H, null, facial_entry)

								head.remove_bodypart_feature(current_facial)
								head.add_bodypart_feature(new_facial)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user] finishes styling [H]'s facial hair."), span_notice("You finish styling [H == user ? "your" : "[H]'s"] facial hair."))
			return
	return ..()

/obj/item/rogueweapon/huntingknife/scissors/attack_obj(obj/O, mob/living/user)
	if(user.used_intent.type == /datum/intent/snip && istype(O, /obj/item))
		var/obj/item/item = O
		if(item.sewrepair && item.salvage_result) // We can only salvage objects which can be sewn!
			var/salvage_time = 70
			salvage_time = (70 - ((user.get_skill_level(/datum/skill/misc/sewing)) * 10))
			if(!do_after(user, salvage_time, target = user))
				return

			if(item.fiber_salvage) //We're getting fiber as base if fiber is present on the item
				new /obj/item/natural/fibers(get_turf(item))
			if(istype(item, /obj/item/storage))
				var/obj/item/storage/bag = item
				bag.emptyStorage()
			var/skill_level = user.get_skill_level(/datum/skill/misc/sewing)
			if(prob(50 - (skill_level * 10))) // We are dumb and we failed!
				to_chat(user, span_info("I ruined some of the materials due to my lack of skill..."))
				playsound(item, 'sound/foley/cloth_rip.ogg', 50, TRUE)
				qdel(item)
				user.mind.add_sleep_experience(/datum/skill/misc/sewing, (user.STAINT)) //Getting exp for failing
				return //We are returning early if the skill check fails!
			item.salvage_amount -= item.torn_sleeve_number
			for(var/i = 1; i <= item.salvage_amount; i++) // We are spawning salvage result for the salvage amount minus the torn sleves!
				var/obj/item/Sr = new item.salvage_result(get_turf(item))
				Sr.color = item.color
			user.visible_message(span_notice("[user] salvages [item] into usable materials."))
			playsound(item, 'sound/items/flint.ogg', 100, TRUE)
			qdel(item)
			user.mind.add_sleep_experience(/datum/skill/misc/sewing, (user.STAINT))
	return ..()
