/mob/living/carbon/human/gib_animation()
	new /obj/effect/temp_visual/gib_animation(loc, "gibbed-h")

/mob/living/carbon/human/dust_animation()
	new /obj/effect/temp_visual/dust_animation(loc, "dust-h")

/mob/living/carbon/human/spawn_gibs(with_bodyparts)
	if(with_bodyparts)
		new /obj/effect/gibspawner/human(drop_location(), src)
	else
		new /obj/effect/gibspawner/human/bodypartless(drop_location(), src)

/mob/living/carbon/human/spawn_dust(just_ash = FALSE)
	if(just_ash)
		for(var/i in 1 to 5)
			new /obj/item/ash(loc)
	else
		new /obj/effect/decal/remains/human(loc)

/proc/rogueviewers(range, object)
	. = list(viewers(range, object))
	if(isliving(object))
		var/mob/living/LI = object
		for(var/mob/living/L in .)
			if(!L.can_see_cone(LI))
				. -= L
			if(HAS_TRAIT(L, TRAIT_BLIND))
				. -= L

/mob/living/carbon/human/death(gibbed, nocutscene = FALSE)
	if(stat == DEAD)
		return

	var/area/A = get_area(src)

	if(client)
		SSdroning.kill_droning(client)
		SSdroning.kill_loop(client)
		SSdroning.kill_rain(client)

	if(mind)
		if(!gibbed)
			var/datum/antagonist/vampirelord/VD = mind.has_antag_datum(/datum/antagonist/vampirelord)
			if(VD)
				dust(just_ash=TRUE,drop_items=TRUE)
				return

		var/datum/antagonist/lich/L = mind.has_antag_datum(/datum/antagonist/lich)
		if (L && !L.out_of_lives)
			if(L.consume_phylactery())
				visible_message(span_warning("[src]'s body begins to shake violently, as eldritch forces begin to whisk them away!"))
				to_chat(src, span_userdanger("Death is not the end for me. I begin to rise again."))
				playsound(src, 'sound/magic/antimagic.ogg', 100, FALSE)
			else
				to_chat(src, span_userdanger("No, NO! This cannot be!"))
				L.out_of_lives = TRUE
				gib()
				return

	if(client || mind)
		GLOB.scarlet_round_stats[STATS_DEATHS]++
		var/area_of_death = lowertext(get_area_name(src))
		if(area_of_death == "wilderness")
			GLOB.scarlet_round_stats[STATS_FOREST_DEATHS]++
		if(is_noble())
			GLOB.scarlet_round_stats[STATS_NOBLE_DEATHS]++
		if(ishumannorthern(src))
			GLOB.scarlet_round_stats[STATS_HUMEN_DEATHS]++
		if(mind)
			if(mind.assigned_role in GLOB.church_positions)
				GLOB.scarlet_round_stats[STATS_CLERGY_DEATHS]++
			if(mind.has_antag_datum(/datum/antagonist/vampire))
				GLOB.scarlet_round_stats[STATS_VAMPIRES_KILLED]++
			if(mind.has_antag_datum(/datum/antagonist/zombie))
				GLOB.scarlet_round_stats[STATS_DEADITES_KILLED]++
			if(mind.has_antag_datum(/datum/antagonist/skeleton) || mind.has_antag_datum(/datum/antagonist/lich))
				GLOB.scarlet_round_stats[STATS_SKELETONS_KILLED]++

	if(!gibbed)
		/*
			ZOMBIFICATION BY DEATH BEGINS HERE
		*/
		if(!has_world_trait(/datum/world_trait/necra_requiem))
			if(!is_in_roguetown(src) || has_world_trait(/datum/world_trait/zizo_defilement))
				if(!zombie_check_can_convert()) //Gives the dead unit the zombie antag flag
					to_chat(src, span_userdanger("..is this to be my end..?"))
					to_chat(src, span_danger("The cold consumes the final flicker of warmth in your chest and begins to seep into your limbs...")) 

	stop_sound_channel(CHANNEL_HEARTBEAT)
	var/obj/item/organ/heart/H = getorganslot(ORGAN_SLOT_HEART)
	if(H)
		H.beat = BEAT_NONE

	if(!mob_timers["deathdied"])
		mob_timers["deathdied"] = world.time
		var/tris2take = 0
		if(istype(A, /area/rogue/indoors/town/cell))
			tris2take += -2
//		else
//			if(get_triumphs() > 0)
//				tris2take += -1
		if(H in SStreasury.bank_accounts)
			for(var/obj/structure/roguemachine/camera/C in view(7, src))
				var/area_name = A.name
				var/texty = "<CENTER><B>Death of a Living Being</B><br>---<br></CENTER>"
				texty += "[real_name] perished in front of face #[C.number] ([area_name]) at [station_time_timestamp("hh:mm")]."
				SSroguemachine.death_queue += texty
				break

		var/yeae = TRUE
		if(buckled)
			if(istype(buckled, /obj/structure/fluff/psycross))
				if(real_name in GLOB.excommunicated_players)
					yeae = FALSE
					tris2take += -2
				if(real_name in GLOB.outlawed_players)
					yeae = FALSE
/*
		if(get_triumphs() > 0)
			if(tris2take)
				adjust_triumphs(tris2take)
			else
				adjust_triumphs(-1)
*/
		switch(job)
			if("Grand Duke")
				//omen gets added separately, after a few minutes
				for(var/mob/living/carbon/human/HU in GLOB.player_list)
					if(!HU.stat && is_in_roguetown(HU))
						HU.playsound_local(get_turf(HU), 'sound/music/lorddeath.ogg', 80, FALSE, pressure_affected = FALSE)
			if("Priest")
				addomen(OMEN_NOPRIEST)
//		if(yeae)
//			if(mind)
//				if((mind.assigned_role == "Lord") || (mind.assigned_role == "Priest") || (mind.assigned_role == "Knight Captain") || (mind.assigned_role == "Merchant"))
//					addomen(OMEN_NOBLEDEATH)

		if(!gibbed && yeae)
			for(var/mob/living/carbon/human/HU in viewers(7, src))
				if(HAS_TRAIT(HU, TRAIT_BLIND))
					continue
				if(HAS_TRAIT(HU, TRAIT_STEELHEARTED))
					continue


	. = ..()

	if(isdullahan(src))
		var/datum/species/dullahan/user_species = src.dna.species
		if(user_species.headless)
			user_species.soul_light_off()
			update_body()

	dizziness = 0
	jitteriness = 0
	dna.species.spec_death(gibbed, src)

	if(SSticker.HasRoundStarted())
		SSblackbox.ReportDeath(src)
		log_message("has died (BRUTE: [src.getBruteLoss()], BURN: [src.getFireLoss()], TOX: [src.getToxLoss()], OXY: [src.getOxyLoss()], CLONE: [src.getCloneLoss()])", LOG_ATTACK)

/mob/living/carbon/human/revive(full_heal, admin_revive)
	. = ..()
	if(!.)
		return
	switch(job)
		if("Grand Duke")
			removeomen(OMEN_NOLORD)
		if("Priest")
			removeomen(OMEN_NOPRIEST)

/mob/living/carbon/human/gib(no_brain, no_organs, no_bodyparts, safe_gib = FALSE)
	GLOB.scarlet_round_stats[STATS_PEOPLE_GIBBED]++
	for(var/mob/living/carbon/human/CA in viewers(7, src))
		if(CA != src && !HAS_TRAIT(CA, TRAIT_BLIND))
			if(HAS_TRAIT(CA, TRAIT_STEELHEARTED))
				continue

			CA.add_stress(/datum/stressevent/viewgib)
	return ..()
