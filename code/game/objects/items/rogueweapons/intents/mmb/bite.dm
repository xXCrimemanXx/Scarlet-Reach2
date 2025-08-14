/datum/intent/bite
	name = "bite"
	candodge = TRUE
	canparry = TRUE
	chargedrain = 0
	chargetime = 0
	swingdelay = 0
	unarmed = TRUE
	noaa = FALSE
	animname = "bite"
	attack_verb = list("bites")

/datum/intent/bite/on_mmb(atom/target, mob/living/user, params)
	var/datum/species/dullahan/user_species
	if(isdullahan(user) && ishuman(target))
		var/mob/living/carbon/human/target_human = target
		var/mob/living/carbon/human/user_human = user
		user_species = user_human.dna.species
		var/obj/item/bodypart/head/dullahan/user_head = user_species.my_head

		var/same_tile = (get_turf(user_head) == get_turf(target_human))
		var/head_close = target_human.is_holding(user_head) || same_tile
		if((user_species.headless && !head_close) || (!user_species.headless && !target_human.Adjacent(user)))
			return
	else if(!target.Adjacent(user))
		return
	if(target == user)
		return
	if(user.incapacitated())
		return
	if(!get_location_accessible(user, BODY_ZONE_PRECISE_MOUTH, grabs="other"))
		to_chat(user, span_warning("My mouth is blocked."))
		return
	if(HAS_TRAIT(user, TRAIT_NO_BITE))
		to_chat(user, span_warning("I can't bite."))
		return
	user.changeNext_move(clickcd)
	if(!user_species || (user_species && !user_species.headless))
		user.face_atom(target)
	target.onbite(user)
	. = ..()
	return

/atom/proc/onbite(mob/user)
	return

/mob/living/onbite(mob/living/carbon/human/user)
	return

// Initial bite on target
// src is the target
/mob/living/carbon/onbite(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("I don't want to harm [src]!"))
		return FALSE
	if(!user.can_bite())
		to_chat(user, span_warning("My mouth has something in it."))
		return FALSE

	var/datum/intent/bite/bitten = new()
	if(checkdefense(bitten, user))
		return FALSE

	var/datum/species/dullahan/user_species
	if(isdullahan(user))
		user_species = user.dna.species

	if(user.pulling != src)
		if(user_species && user_species.headless)
			var/obj/item/bodypart/head/dullahan/user_head = user_species.my_head
			if(!user_head.check_closest_zones(src))
				return FALSE
		else if(!lying_attack_check(user))
			return FALSE

	var/def_zone = check_zone(user.zone_selected)
	var/obj/item/bodypart/affecting = get_bodypart(def_zone)
	if(!affecting)
		to_chat(user, span_warning("Nothing to bite."))
		return

	next_attack_msg.Cut()

	user.do_attack_animation(src, "bite")
	playsound(user, 'sound/gore/flesh_eat_01.ogg', 100)
	var/nodmg = FALSE
	var/dam2do = 10*(user.STASTR/20)
	if(HAS_TRAIT(user, TRAIT_STRONGBITE))
		dam2do *= 2
	if(!HAS_TRAIT(user, TRAIT_STRONGBITE))
		if(!affecting.has_wound(/datum/wound/bite))
			nodmg = TRUE
	if(!nodmg)
		var/armor_block = run_armor_check(user.zone_selected, "stab",blade_dulling=BCLASS_BITE)
		if(!apply_damage(dam2do, BRUTE, def_zone, armor_block, user))
			nodmg = TRUE
			next_attack_msg += span_warning("Armor stops the damage.")

	var/datum/wound/caused_wound
	if(!nodmg)
		caused_wound = affecting.bodypart_attacked_by(BCLASS_BITE, dam2do, user, user.zone_selected, crit_message = TRUE)
	visible_message(span_danger("[user] bites [src]'s [parse_zone(user.zone_selected)]![next_attack_msg.Join()]"), \
					span_userdanger("[user] bites my [parse_zone(user.zone_selected)]![next_attack_msg.Join()]"))

	next_attack_msg.Cut()
	/*
		nodmg if they don't have an open wound
		nodmg if we don't have strongbite
		nodmg if our teeth can't break through their armour
	*/
	if(!nodmg)
		playsound(src, "smallslash", 100, TRUE, -1)
		if(ishuman(src) && user.mind)
			var/mob/living/carbon/human/bite_victim = src
			/*
				WEREWOLF INFECTION VIA BITE
			*/
			if(istype(user.dna.species, /datum/species/werewolf))
				if(user.mind)
					if(!HAS_TRAIT(src, TRAIT_SILVER_BLESSED))
						caused_wound?.werewolf_infect_attempt()
						
				if(HAS_TRAIT(src, TRAIT_SILVER_BLESSED))
					to_chat(user, span_warning("BLEH! [bite_victim] tastes of SILVER! My gift cannot take hold."))
				else
					if(prob(30))
						user.werewolf_feed(bite_victim, 10)
			/*
				ZOMBIE INFECTION VIA BITE
			*/
			var/datum/antagonist/zombie/zombie_antag = user.mind.has_antag_datum(/datum/antagonist/zombie)
			if(zombie_antag && zombie_antag.has_turned)
				zombie_antag.last_bite = world.time
				if(bite_victim.zombie_infect_attempt())   // infect_attempt on bite
					to_chat(user, span_danger("You feel your gift trickling from your mouth into [bite_victim]'s wound..."))
	var/obj/item/grabbing/bite/B = new()
	user.equip_to_slot_or_del(B, SLOT_MOUTH)
	if(user.mouth == B)
		var/used_limb = src.find_used_grab_limb(user)
		B.name = "[src]'s [parse_zone(used_limb)]"
		var/obj/item/bodypart/BP = get_bodypart(check_zone(used_limb))
		BP.grabbedby += B
		B.grabbed = src
		B.grabbee = user
		B.limb_grabbed = BP
		B.sublimb_grabbed = used_limb

		lastattacker = user.real_name
		lastattackerckey = user.ckey
		if(mind)
			mind.attackedme[user.real_name] = world.time
		log_combat(user, src, "bit")
	return TRUE

// Checking if the unit can bite
/mob/living/carbon/human/proc/can_bite()
	// if(mouth?.muteinmouth && mouth?.type != /obj/item/grabbing/bite) // This one allows continued first biting rather than having to chew
	if(mouth?.muteinmouth)
		return FALSE
	for(var/obj/item/grabbing/grab in grabbedby) // Grabbed by the mouth
		if(grab.sublimb_grabbed == BODY_ZONE_PRECISE_MOUTH)
			return FALSE

	return TRUE

/obj/item/grabbing/bite
	name = "bite"
	icon_state = "bite"
	d_type = "stab"
	slot_flags = ITEM_SLOT_MOUTH
	bleed_suppressing = 1
	var/last_drink

/obj/item/grabbing/bite/valid_check()
	// We require adjacency to count the grab as valid

	if(isdullahan(grabbee) && ishuman(grabbed))
		var/mob/living/carbon/human/target = grabbed
		var/mob/living/carbon/human/user_human = grabbee

		var/datum/species/dullahan/user_species = user_human.dna.species
		var/obj/item/bodypart/head/dullahan/user_head = user_species.my_head

		if(!user_species.headless && user_human.Adjacent(target))
			return TRUE
		else if(user_species.headless && (get_turf(user_head) == get_turf(target) || target.is_holding(user_head)))
			return TRUE
	else if(grabbee.Adjacent(grabbed))
		return TRUE
	grabbee.stop_pulling(FALSE)
	qdel(src)
	return FALSE

/obj/item/grabbing/bite/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(!valid_check())
		return
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C != grabbee || C.incapacitated() || C.stat == DEAD)
			qdel(src)
			return 1
		if(modifiers["right"])
			qdel(src)
			return 1
		var/_y = text2num(params2list(params)["icon-y"])
		if(_y>=17)
			bitelimb(C)
		else
			drinklimb(C)
	return 1

///Chewing after bite
///User is the one biting.
/obj/item/grabbing/bite/proc/bitelimb(mob/living/carbon/human/user) //implies limb_grabbed and sublimb are things
	var/datum/species/dullahan/user_species
	if(isdullahan(user) && ishuman(grabbed))
		var/mob/living/carbon/human/target_human = grabbed
		var/mob/living/carbon/human/user_human = user
		user_species = user_human.dna.species
		var/obj/item/bodypart/head/dullahan/user_head = user_species.my_head

		var/same_tile = (get_turf(user_head) == get_turf(target_human))
		var/head_close = target_human.is_holding(user_head) || same_tile
		if((user_species.headless && !head_close) || (!user_species.headless && !target_human.Adjacent(user)))
			qdel(src)
			return
	else if(!user.Adjacent(grabbed))
		qdel(src)
		return
	if(world.time <= user.next_move)
		return
	/*if(!user.can_bite()) // If this is enabled, check can_bite or else won't be able to chew after biting
		to_chat(user, span_warning("My mouth has something in it."))
		return FALSE*/

	user.changeNext_move(CLICK_CD_GRABBING)
	var/mob/living/carbon/C = grabbed
	var/armor_block = C.run_armor_check(sublimb_grabbed, d_type, armor_penetration = BLUNT_DEFAULT_PENFACTOR)
	var/damage = user.get_punch_dmg()
	if(HAS_TRAIT(user, TRAIT_STRONGBITE))
		damage = damage*2
	C.next_attack_msg.Cut()
	user.do_attack_animation(C, "bite")
	if(C.apply_damage(damage, BRUTE, limb_grabbed, armor_block))
		playsound(C.loc, "smallslash", 100, FALSE, -1)
		var/datum/wound/caused_wound = limb_grabbed.bodypart_attacked_by(BCLASS_BITE, damage, user, sublimb_grabbed, crit_message = TRUE)
		if(user.mind && caused_wound)
			/*
				WEREWOLF CHEW.
			*/
			if(istype(user.dna.species, /datum/species/werewolf))
				if(user.mind)
					if(!HAS_TRAIT(C, TRAIT_SILVER_BLESSED))
						caused_wound?.werewolf_infect_attempt()
				if(prob(30))
					user.werewolf_feed(C)

			/*
				ZOMBIE CHEW. ZOMBIFICATION
			*/
			var/datum/antagonist/zombie/zombie_antag = user.mind.has_antag_datum(/datum/antagonist/zombie)
			if(zombie_antag && zombie_antag.has_turned)
				var/datum/antagonist/zombie/existing_zombie = C.mind?.has_antag_datum(/datum/antagonist/zombie) //If the bite target is a zombie
				if(!existing_zombie && caused_wound?.zombie_infect_attempt())   // infect_attempt on wound
					to_chat(user, span_danger("You feel your gift trickling into [C]'s wound...")) //message to the zombie they infected the target
/*
	Code below is for a zombie smashing the brains of unit. The code expects the brain to be part of the head which is not the case with AP. Kept for posterity in case it's used in an overhaul.
*/
/*			if(user.mind.has_antag_datum(/datum/antagonist/zombie))
				var/mob/living/carbon/human/H = C
				if(istype(H))
					INVOKE_ASYNC(H, TYPE_PROC_REF(/mob/living/carbon/human, zombie_infect_attempt))
				if(C.stat)
					if(istype(limb_grabbed, /obj/item/bodypart/head))
						var/obj/item/bodypart/head/HE = limb_grabbed
						if(HE.brain)
							QDEL_NULL(HE.brain)
							C.visible_message("<span class='danger'>[user] consumes [C]'s brain!</span>", \
								"<span class='userdanger'>[user] consumes my brain!</span>", "<span class='hear'>I hear a sickening sound of chewing!</span>", COMBAT_MESSAGE_RANGE, user)
							to_chat(user, "<span class='boldnotice'>Braaaaaains!</span>")
							if(!user.mob_timers["zombie_tri"])
								user.mob_timers["zombie_tri"] = world.time
							playsound(C.loc, 'sound/combat/fracture/headcrush (2).ogg', 100, FALSE, -1)
							return*/
	else
		C.next_attack_msg += " <span class='warning'>Armor stops the damage.</span>"
	C.visible_message(span_danger("[user] bites [C]'s [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]"), \
					span_userdanger("[user] bites my [parse_zone(sublimb_grabbed)]![C.next_attack_msg.Join()]"), span_hear("I hear a sickening sound of chewing!"), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("I bite [C]'s [parse_zone(sublimb_grabbed)].[C.next_attack_msg.Join()]"))
	C.next_attack_msg.Cut()
	log_combat(user, C, "limb chewed [sublimb_grabbed] ")

//this is for carbon mobs being drink only
/obj/item/grabbing/bite/proc/drinklimb(mob/living/user) //implies limb_grabbed and sublimb are things
	var/datum/species/dullahan/user_species
	if(isdullahan(user) && ishuman(grabbed))
		var/mob/living/carbon/human/target_human = grabbed
		var/mob/living/carbon/human/user_human = user
		user_species = user_human.dna.species
		var/obj/item/bodypart/head/dullahan/user_head = user_species.my_head

		var/same_tile = (get_turf(user_head) == get_turf(target_human))
		var/head_close = target_human.is_holding(user_head) || same_tile
		if((user_species.headless && !head_close) || (!user_species.headless && !target_human.Adjacent(user)))
			qdel(src)
			return
	else if(!user.Adjacent(grabbed))
		qdel(src)
		return
	if(world.time <= user.next_move)
		return
	if(world.time < last_drink + 2 SECONDS)
		return
	if(!limb_grabbed.get_bleed_rate())
		to_chat(user, span_warning("Sigh. It's not bleeding."))
		return
	var/mob/living/carbon/C = grabbed
	if(C.dna?.species && (NOBLOOD in C.dna.species.species_traits))
		to_chat(user, span_warning("Sigh. No blood."))
		return
	if(C.blood_volume <= 0)
		to_chat(user, span_warning("Sigh. No blood."))
		return
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(istype(H.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver) || HAS_TRAIT(H, TRAIT_SILVER_BLESSED))
			to_chat(user, span_userdanger("SILVER! HISSS!!!"))
			return
	last_drink = world.time
	user.changeNext_move(CLICK_CD_GRABBING)

	if(user.mind)
		var/datum/antagonist/vampirelord/VDrinker = user.mind.has_antag_datum(/datum/antagonist/vampirelord)
		var/datum/antagonist/vampirelord/VVictim = C.mind.has_antag_datum(/datum/antagonist/vampirelord)
		var/zomwerewolf = C.mind.has_antag_datum(/datum/antagonist/werewolf)
		if(!zomwerewolf)
			if(C.stat != DEAD)
				zomwerewolf = C.mind.has_antag_datum(/datum/antagonist/zombie)
		
		if(VDrinker)
			// Regular vampire lords
			if(zomwerewolf)
				to_chat(user, span_danger("I'm going to puke..."))
				addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))
			else
				if(VVictim)
					to_chat(user, span_warning("It's vitae, just like mine."))
				else if (C.vitae_pool > 500)
					C.blood_volume = max(C.blood_volume-45, 0)
					C.vitae_pool -= 500
					if(ishuman(C))
						var/mob/living/carbon/human/H = C
						if(H.virginity)
							to_chat(user, "<span class='love'>Virgin blood, delicious!</span>")
							if(VDrinker.isspawn)
								VDrinker.handle_vitae(1500, 1500)
							else
								VDrinker.handle_vitae(1500)
					if(VDrinker.isspawn)
						VDrinker.handle_vitae(1000, 1000)
					else
						VDrinker.handle_vitae(1000)
				else
					to_chat(user, span_warning("No more vitae from this blood..."))
		else if(HAS_TRAIT(user, TRAIT_HORDE))
			// Horde trait allows safe blood drinking
		else
			// Non-vampires will vomit
			to_chat(user, "<span class='warning'>I'm going to puke...</span>")
			addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), rand(8 SECONDS, 15 SECONDS))

	C.blood_volume = max(C.blood_volume-15, 0)
	C.handle_blood()
	if(HAS_TRAIT(user, TRAIT_HORDE))
		user.adjust_hydration(8)

	playsound(user.loc, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)

	C.visible_message(span_danger("[user] drinks from [C]'s [parse_zone(sublimb_grabbed)]!"), \
					span_userdanger("[user] drinks from my [parse_zone(sublimb_grabbed)]!"), span_hear("..."), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_warning("I drink from [C]'s [parse_zone(sublimb_grabbed)]."))
	log_combat(user, C, "drank blood from ")

	if(user.mind && user.mind.has_antag_datum(/datum/antagonist/vampire))
		var/datum/antagonist/vampire/VDrinker = user.mind.has_antag_datum(/datum/antagonist/vampire)
		if(VDrinker)
			VDrinker.vitae = min(VDrinker.vitae + 400, 5000)
			to_chat(user, span_notice("I gain 400 vitae from drinking blood. Current vitae: [VDrinker.vitae]"))
		else if(VDrinker && !C.mind)
			to_chat(user, span_warning("This blood is not pure enough to nourish me properly!"))
		

	if(C.mind && user.mind.has_antag_datum(/datum/antagonist/vampirelord))
		var/datum/antagonist/vampirelord/VDrinker = user.mind.has_antag_datum(/datum/antagonist/vampirelord)
		if(C.blood_volume <= BLOOD_VOLUME_SURVIVE)
			if(!VDrinker.isspawn)
				switch(alert("Would you like to sire a new spawn?",,"Yes","No"))
					if("Yes")
						user.visible_message("[user] begins to infuse dark magic into [C]")
						if(do_after(user, 30))
							C.visible_message("[C] rises as a new spawn!")
							var/datum/antagonist/vampirelord/lesser/new_antag = new /datum/antagonist/vampirelord/lesser()
							new_antag.sired = TRUE
							C.mind.add_antag_datum(new_antag)
							sleep(10 SECONDS)
							C.fully_heal()
							C.energy = C.max_energy
							C.update_health_hud()
					if("No")
						to_chat(user, span_warning("I decide [C] is unworthy."))
