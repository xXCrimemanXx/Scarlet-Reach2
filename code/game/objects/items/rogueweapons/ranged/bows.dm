//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/shoot/bow
	chargetime = 1 //used for edge cases only, /datum/intent/shoot/bow/get_chargetime handles the actual number
	chargedrain = 2
	charging_slowdown = 3

/datum/intent/shoot/bow/can_charge()
	if(mastermob)
		if(mastermob.get_num_arms(FALSE) < 2)
			return FALSE
		if(mastermob.get_inactive_held_item())
			return FALSE
	return TRUE

/datum/intent/shoot/bow/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] draws [masteritem]!"))
		playsound(mastermob, pick('sound/combat/Ranged/bow-draw-01.ogg'), 100, FALSE)

/datum/intent/shoot/bow/get_chargetime() //this handles how long it takes for us to fully aim our bow. damage is handled below in /obj/item/gun/ballistic/revolver/grenadelauncher/bow/process_fire
	if(mastermob && chargetime)
		var/newtime = 0
		newtime = ((newtime + 10) - (mastermob.get_skill_level(/datum/skill/combat/bows) * (2)))
		if(strength_check == TRUE)
			newtime = ((newtime + 10) - (mastermob.STASTR / 2))
		else
			newtime = newtime 
		newtime = ((newtime + 20) - (mastermob.STAPER))
		if(newtime > 1)
			return newtime //this value is how fast we can accurately shoot a bow. most builds will turn up with about 6 - 12 on non heavy bows.
		else
			return 1 //our floor for how quickly you can fire an accurate shot if you somehow break the calcs above. you need about 18 PER and master bows to reach this
	else
		return chargetime //if a bow somehow gets drawn by something that doesn't fulfill the above we can use the intent value

/datum/intent/shoot/bow/heavy
	strength_check = TRUE

/datum/intent/arc/bow
	chargetime = 1
	chargedrain = 2
	charging_slowdown = 3

/datum/intent/arc/bow/can_charge()
	if(mastermob)
		if(mastermob.get_num_arms(FALSE) < 2)
			return FALSE
		if(mastermob.get_inactive_held_item())
			return FALSE
	return TRUE

/datum/intent/arc/bow/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] draws [masteritem] in an arc!"))
		playsound(mastermob, pick('sound/combat/Ranged/bow-draw-01.ogg'), 100, FALSE)

/datum/intent/arc/bow/get_chargetime() //same calc as above, but with a higher absolute floor for how fast you can shoot
	if(mastermob && chargetime)
		var/newtime = 0
		newtime = ((newtime + 10) - (mastermob.get_skill_level(/datum/skill/combat/bows) * (2)))
		if(strength_check == TRUE)
			newtime = ((newtime + 10) - (mastermob.STASTR / 2))
		else
			newtime = newtime 
		newtime = ((newtime + 20) - (mastermob.STAPER))
		if(newtime > 3)
			return newtime
		else
			return 3
	else
		return chargetime

/datum/intent/arc/bow/heavy
	strength_check = TRUE

//bow objs ฅ^•ﻌ•^ฅ

/obj/item/gun/ballistic/revolver/grenadelauncher/bow
	name = "crude selfbow"
	desc = "This roughly hewn selfbow is just a bit too little of everything. Too little length, \
	too little poundage, too slow a shot."
	icon = 'icons/roguetown/weapons/32.dmi'
	icon_state = "bow"
	item_state = "bow"
	experimental_onhip = TRUE
	experimental_onback = TRUE
	possible_item_intents = list(
		/datum/intent/shoot/bow,
		/datum/intent/arc/bow,
		INTENT_GENERIC,
		)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/bow
	fire_sound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_BULKY
	randomspread = 0
	spread = 0
	can_parry = TRUE
	force = 10
	verbage = "nock"
	cartridge_wording = "arrow"
	load_sound = 'sound/foley/nockarrow.ogg'
	obj_flags = UNIQUE_RENAME
	var/heavy_bow = FALSE //used for adding a STR check to the charge time of a bow
	pickup_sound = 'modular_helmsguard/sound/sheath_sounds/draw_bow.ogg'
	sheathe_sound = 'sound/items/wood_sharpen.ogg'
	
/obj/item/gun/ballistic/revolver/grenadelauncher/bow/Initialize()
	. = ..()
	if(heavy_bow == TRUE)
		src.possible_item_intents = list(
									/datum/intent/shoot/bow/heavy,
									/datum/intent/arc/bow/heavy,
									INTENT_GENERIC,
									)
		desc += " <b>Has a heavy draw.</b>"
	else
		return

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.7,
					"sx" = -3,
					"sy" = 0,
					"nx" = 6,
					"ny" = 1,
					"wx" = -1,
					"wy" = 1,
					"ex" = -2,
					"ey" = 1,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 9,
					"sturn" = -100,
					"wturn" = -102,
					"eturn" = 10,
					"nflip" = 1,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 1,
					)
			if("onbelt")
				return list(
					"shrink" = 0.6,
					"sx" = 0,
					"sy" = -3,
					"nx" = 4,
					"ny" = -5,
					"wx" = -3,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,
					)
			if("onback")
				return list(
					"shrink" = 0.6,
					"sx" = 0,
					"sy" = 0,
					"nx" = 4,
					"ny" = 0,
					"wx" = 0,
					"wy" = 0,
					"ex" = 0,
					"ey" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,
					)


/obj/item/gun/ballistic/revolver/grenadelauncher/bow/shoot_with_empty_chamber()
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/dropped()
	. = ..()
	if(chambered)
		chambered = null
		var/num_unloaded = 0
		for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
			CB.forceMove(drop_location())
//			CB.bounce_away(FALSE, NONE)
			num_unloaded++
		if (num_unloaded)
			update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(user.get_num_arms(FALSE) < 2)
		return FALSE
	if(user.get_inactive_held_item())
		return FALSE
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/BB = CB.BB
		BB.accuracy += accfactor * (user.STAPER - 9) * 4 // 9+ PER gives +4 per level. Exponential.
		BB.bonus_accuracy += (user.STAPER - 8) * 3 // 8+ PER gives +3 per level. Does not decrease over range.
		BB.bonus_accuracy += (user.get_skill_level(/datum/skill/combat/bows) * 5) // +5 per Bow level.

		if(user.client.chargedprog < 100)
			BB.damage -= (BB.damage * (user.client.chargedprog / 100))
			BB.embedchance /= 2
			BB.accuracy -= 15
		else
			BB.damage = BB.damage
		BB.damage *= damfactor * (user.STAPER > 10 ? user.STAPER / 10 : 1)
		if(HAS_TRAIT(user, TRAIT_TINY)) //faes get bad damage (if they can draw it somehow)
			BB.damage = (BB.damage * 0.1)
	if(user.has_status_effect(/datum/status_effect/buff/clash) && ishuman(user))
		var/mob/living/carbon/human/H = user
		H.bad_guard(span_warning("I can't focus on my Guard and loose arrows! This drains me!"), cheesy = TRUE)
	. = ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/update_icon()
	..()

	var/matrix/mat = matrix()
	mat.Translate(20,20)

	cut_overlays()
	if(chambered)
		var/mutable_appearance/ammo = mutable_appearance('icons/roguetown/weapons/ammo.dmi', chambered.icon_state)
		ammo.transform = mat
		add_overlay(ammo)

	if(!ismob(loc))
		return
	var/mob/M = loc
	M.update_inv_hands()

/obj/item/ammo_box/magazine/internal/shot/bow
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow
	caliber = "arrow"
	max_ammo = 1
	start_empty = TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	name = "recurve bow"
	desc = "A medium length composite bow of glued horn, wood, and sinew with good shooting \
	characteristics."
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "recurve_bow"
	force = 9
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	dropshrink = 0.8

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -3,
					"sy" = 0,
					"nx" = 6,
					"ny" = 1,
					"wx" = -1,
					"wy" = 1,
					"ex" = -2,
					"ey" = 1,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 9,
					"sturn" = -100,
					"wturn" = -102,
					"eturn" = 10,
					"nflip" = 1,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 1,
					)
			if("onbelt")
				return list(
					"shrink" = 0.6,
					"sx" = 0,
					"sy" = -3,
					"nx" = 3,
					"ny" = -5,
					"wx" = -7,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0)
			if("onback")
				return list(
					"shrink" = 0.6,
					"sx" = -1,
					"sy" = 0,
					"nx" = 0,
					"ny" = 1,
					"wx" = -2,
					"wy" = 0,
					"ex" = 0,
					"ey" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	name = "yew longbow"
	desc = "A sturdy warbow made of a tillered yew stave. It's difficult to handle, but the \
	power is worth the effort."
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "longbow"
	slot_flags = ITEM_SLOT_BACK
	damfactor = 1.2
	accfactor = 0.9
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	dropshrink = 0.8
	heavy_bow = TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -3,
					"sy" = 0,
					"nx" = 6,
					"ny" = 1,
					"wx" = -1,
					"wy" = 0,
					"ex" = -2,
					"ey" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 9,
					"sturn" = -100,
					"wturn" = -102,
					"eturn" = 10,
					"nflip" = 1,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 1,
					)
			if("onback")
				return list(
					"shrink" = 0.6,
					"sx" = 0,
					"sy" = 1,
					"nx" = 0,
					"ny" = 0,
					"wx" = -1,
					"wy" = 1,
					"ex" = 0,
					"ey" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,
					)
