/datum/job/roguetown/puritan
	title = "Inquisitor"
	flag = PURITAN
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_SECOND_CLASS_NO_GOLEM		//Not been around long enough to be inquisitor, brand new race to the world.
	disallowed_races = list(
		/datum/species/lamia,
	)
	allowed_patrons = ALL_DIVINE_PATRONS //psydon is dead confirmed
	tutorial = "You have been sent here as an envoy from the Sovereignty of Holy see of the Ten : a silver-tipped olive branch, unmatched in aptitude and unshakable in faith to the Ten. Though you might be ostracized due to your overzealous beliefs, neither the Church nor Crown can deny your value, whenever matters of inhumenity arise to threaten this fief."
	whitelist_req = TRUE
	cmode_music = 'sound/music/inquisitorcombat.ogg'
	selection_color = JCOLOR_INQUISITION

	outfit = /datum/outfit/job/roguetown/puritan
	display_order = JDO_PURITAN
	advclass_cat_rolls = list(CTAG_PURITAN = 20)
	give_bank_account = 30
	min_pq = 10
	max_pq = null
	round_contrib_points = 2

/datum/outfit/job/roguetown/puritan
	name = "Inquisitor"
	jobtype = /datum/job/roguetown/puritan
	job_bitflag = BITFLAG_CHURCH	//Counts as church.

/datum/job/roguetown/puritan/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.grant_language(/datum/language/otavan)
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = FALSE, devotion_limit = CLERIC_REQ_1)	//Capped to T1 miracles.



////Classic Inquisitor with a much more underground twist. Use listening devices, sneak into places to gather evidence, track down suspicious individuals. Has relatively the same utility stats as Confessor, but fulfills a different niche in terms of their combative job as the head honcho.

/datum/advclass/puritan/inspector
	name = "Inquisitor"
	tutorial = "Investigators from countless backgrounds, personally chosen by the High Bishop of the Otavan Sovereignty to root out heresy all across the world. Dressed in fashionable leathers and armed with a plethora of equipment, these beplumed officers are ready to tackle the inhumen: anywhere, anytime. Ideal for those who prefer sleuthy-and-clandestine affairs."
	outfit = /datum/outfit/job/roguetown/puritan/inspector

	category_tags = list(CTAG_PURITAN)

/datum/outfit/job/roguetown/puritan/inspector/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.change_stat("strength", 1)
	H.change_stat("endurance", 2)
	H.change_stat("constitution", 1)
	H.change_stat("perception", 3)
	H.change_stat("speed", 3)
	H.change_stat("intelligence", 3)
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SILVER_BLESSED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_INQUISITION, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_PERFECT_TRACKER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_PURITAN, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	// Weapon choice system
	H.adjust_blindness(-3)
	var/weapons = list("Crossbow & Bolts", "Recurve Bow & Arrows", "Buckler")
	var/weapon_choice = input("Choose your auxiliary.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Crossbow & Bolts")
			H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
			beltr = /obj/item/quiver/bolts
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
		if("Recurve Bow & Arrows")
			H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			beltr = /obj/item/quiver/bodkin
		if("Buckler")
			backl = /obj/item/rogueweapon/shield/buckler
	H.set_blindness(0)
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/psydon
	neck = /obj/item/clothing/neck/roguetown/gorget
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	backr = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/inqhat
	gloves = /obj/item/clothing/gloves/roguetown/otavan/inqgloves
	beltl = /obj/item/rogueweapon/sword/rapier
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat
	backpack_contents = list(/obj/item/storage/keyring/puritan = 1, /obj/item/lockpickring/mundane = 1, /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger/preblessed, /obj/item/grapplinghook = 1, /obj/item/storage/belt/rogue/pouch/coins/rich = 1, /obj/item/clothing/neck/roguetown/psicross/silver = 1) //these will be renamed to show that Psydon is dead after the next knife update


///The dirty, violent side of the Inquisition. Meant for confrontational, conflict-driven situations as opposed to simply sneaking around and asking questions. Templar with none of the miracles, but with all the muscles and more.

/datum/advclass/puritan/ordinator
	name = "Ordinator"
	tutorial = "Adjudicators who - through valor and martiality - have proven themselves to be champions in all-but-name. Now, they have been personally chosen by the High Bishop of the Otavan Sovereignty for a mission-most-imperative: to hunt down and destroy the monsters threatening this fief. Ideal for those who prefer overt-and-chivalrous affairs."
	outfit = /datum/outfit/job/roguetown/puritan/ordinator
	cmode_music = 'sound/music/combat_inqordinator.ogg'

	category_tags = list(CTAG_PURITAN)

/datum/outfit/job/roguetown/puritan/ordinator/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)
	H.change_stat("strength", 3)
	H.change_stat("endurance", 3)
	H.change_stat("constitution", 3)
	H.change_stat("perception", 3)
	H.change_stat("speed", -1)
	H.change_stat("intelligence", 3)
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SILVER_BLESSED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_INQUISITION, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_PERFECT_TRACKER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_PURITAN, JOB_TRAIT)
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
	belt = /obj/item/storage/belt/rogue/leather/steel
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	pants = /obj/item/clothing/under/roguetown/chainlegs
	cloak = /obj/item/clothing/cloak/cape/puritan
	backr = /obj/item/storage/backpack/rogue/satchel/black
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	gloves = /obj/item/clothing/gloves/roguetown/otavan/inqgloves
	beltl = /obj/item/rogueweapon/sword/long/psysword/preblessed
	backpack_contents = list(/obj/item/storage/keyring/puritan = 1, /obj/item/lockpickring/mundane = 1, /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger/preblessed, /obj/item/grapplinghook = 1, /obj/item/storage/belt/rogue/pouch/coins/rich = 1)

	var/helmets = list(
	"Ornate Barbute" 	= /obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute,
	"Ornate Armet" 		= /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm,
	"None"
	)
	var/helmchoice = input("Choose your Helm.", "TAKE UP HELMS") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]

	var/shields = list(
	"Holy Shield (Light)" 	= /obj/item/rogueweapon/shield/tower/metal/holysee,
	"Holy Shield (Dark)" 	= /obj/item/rogueweapon/shield/tower/metal/holysee/dark,
	"Weapon Strap" 			=/obj/item/gwstrap,
	"None"
	)
	var/shieldchoice = input("Choose your Auxiliary.", "TAKE UP SHIELD") as anything in shields
	if(shieldchoice != "None")
		backl = shields[shieldchoice]

/obj/item/clothing/gloves/roguetown/chain/blk
		color = CLOTHING_GREY

/obj/item/clothing/under/roguetown/chainlegs/blk
		color = CLOTHING_GREY

/obj/item/clothing/suit/roguetown/armor/plate/blk
		color = CLOTHING_GREY

/obj/item/clothing/shoes/roguetown/boots/armor/blk
		color = CLOTHING_GREY

/mob/living/carbon/human/proc/torture_victim()
	set name = "Extract Confession"
	set category = "Inquisition"
	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/found = null
	if(!istype(I) || !ishuman(I.grabbed))
		to_chat(src, span_warning("I don't have a victim in my hands!"))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("I already torture myself."))
		return
	if(H.stat == DEAD)
		to_chat(src, span_warning("[H] is dead already..."))
		return
	for(var/obj/structure/fluff/psycross/N in oview(5, src))
		found = N
	if(!found)
		to_chat(src, span_warning("I need a large psycross structure nearby to extract this divination!"))
	if(!H.stat)
		SEND_SIGNAL(src, COMSIG_TORTURE_PERFORMED, H)
		var/static/list/torture_lines = list(
			"CONFESS YOUR WRONGDOINGS!",
			"TELL ME YOUR SECRETS!",
			"SPEAK THE TRUTH!",
			"YOU WILL SPEAK!",
			"TELL ME!",
			"THE PAIN HAS ONLY BEGUN, CONFESS!",
		)

		src.visible_message(span_warning("[src] shoves the psycross in [H]'s face!"))
		say(pick(torture_lines), spans = list("torture"))
		H.emote("agony", forced = TRUE)
		H.confession_time("antag", src)
		H.add_stress(/datum/stressevent/tortured)

		if(!(do_mob(src, H, 10 SECONDS)))
			return

		src.visible_message(span_warning("[src]'s psycross abruptly catches flame, burning away in an instant!"))
		H.confess_sins("antag")
		return
	to_chat(src, span_warning("This one is not in a ready state to be questioned..."))

/mob/living/carbon/human/proc/faith_test()
	set name = "Test Faith"
	set category = "Inquisition"
	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/found = null
	if(!istype(I) || !ishuman(I.grabbed))
		to_chat(src, span_warning("I don't have a victim in my hands!"))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("I already torture myself."))
		return
	if (!H.restrained())
		to_chat(src, span_warning ("My victim needs to be restrained in order to do this!"))
		return
	for(var/obj/structure/fluff/psycross/N in oview(5, src))
		found = N
	if(!found)
		to_chat(src, span_warning("I need a large psycross structure nearby to extract this divination!"))
		return
	if(!H.stat)
		SEND_SIGNAL(src, COMSIG_TORTURE_PERFORMED, H)
		var/static/list/faith_lines = list(
			"DO YOU DENY THE ALLFATHER?",
			"WHO IS YOUR GOD?",
			"ARE YOU FAITHFUL?",
			"WHO IS YOUR SHEPHERD?",
		)

		src.visible_message(span_warning("[src] shoves the psycross in [H]'s face!"))
		say(pick(faith_lines), spans = list("torture"))
		H.emote("agony", forced = TRUE)

		if(!(do_mob(src, H, 10 SECONDS)))
			return

		src.visible_message(span_warning("[src]'s psycross abruptly catches flame, burning away in an instant!"))
		H.confess_sins("patron")
		H.add_stress(/datum/stressevent/tortured)
		return
	to_chat(src, span_warning("This one is not in a ready state to be questioned..."))

/mob/living/carbon/human/proc/confession_time(confession_type = "antag", mob/living/carbon/human/user)
	var/timerid = addtimer(CALLBACK(src, PROC_REF(confess_sins), confession_type, FALSE, user), 10 SECONDS, TIMER_STOPPABLE)
	var/static/list/options = list("RESIST!!", "CONFESS!!")
	var/responsey = input(src, "Resist torture?", "TEST OF PAIN", options)

	if(SStimer.timer_id_dict[timerid])
		deltimer(timerid)
	else
		to_chat(src, span_warning("Too late..."))
		return
	if(responsey == "RESIST!!")
		confess_sins(confession_type, resist=TRUE, interrogator=user)
	else
		confess_sins(confession_type, resist=FALSE, interrogator=user)

/mob/living/carbon/human/proc/confess_sins(confession_type = "antag", resist, mob/living/carbon/human/interrogator, torture=TRUE, obj/item/paper/confession/confession_paper, false_result)
	if(stat == DEAD)
		return
	var/static/list/innocent_lines = list(
		"I DON'T KNOW!",
		"STOP THIS MADNESS!!",
		"I DON'T DESERVE THIS!",
		"THE PAIN!",
		"I HAVE NOTHING TO SAY...!",
		"WHY ME?!",
		"I'M INNOCENT!",
		"I AM NO SINNER!",
	)
	var/resist_chance = 0
	if(resist)
		to_chat(src, span_boldwarning("I attempt to resist the torture!"))
		resist_chance = (STAINT + STAEND) + 10

		if(confession_type == "antag")									// Inherant bonus to resist if you are an antag/heretic.
			resist_chance += 25
		if(istype(buckled, /obj/structure/fluff/walldeco/chains))		// If the victim is on hanging chains, apply a resist penalty
			resist_chance -= 10
		var/mob/living/carbon/human/H
		if(H.has_status_effect(/datum/status_effect/buff/drunk))		// Loose lips sink ships.
			resist_chance -= 10
		if(H.has_status_effect(/datum/status_effect/debuff/revived))	//Weakened body and mind
			resist_chance -= 5
		if(H.has_status_effect(/datum/status_effect/debuff/devitalised))	//Weakened soul and mind
			resist_chance -= 10
		if(HAS_TRAIT(H, TRAIT_DECEIVING_MEEKNESS))						// Guraded bonus given you hide your faith better than others.
			resist_chance += 15
		if(HAS_TRAIT(H, TRAIT_CRITICAL_WEAKNESS))						// Negative for being bully-bait.
			resist_chance -= 15
		var/painpercent = (H.get_complex_pain() / (H.STAEND * 10)) * 100
		if(painpercent < 100)											// If beaten/badly wounded, penalty.
			resist_chance -= 15

	if(!prob(resist_chance))
		var/list/confessions = list()
		var/antag_type = null
		switch(confession_type)
			if("antag")
				if(!false_result)
					for(var/datum/antagonist/antag in mind?.antag_datums)
						if(!length(antag.confess_lines))
							continue
						confessions += antag.confess_lines
						antag_type = antag.name
						break // Only need one antag type
			if("patron")
				if(ispath(false_result, /datum/patron))
					var/datum/patron/fake_patron = new false_result()
					if(length(fake_patron.confess_lines))
						confessions += fake_patron.confess_lines
						antag_type = fake_patron.name
				else
					if(length(patron?.confess_lines))
						confessions += patron.confess_lines
						antag_type = patron.name

		if(torture && interrogator && confession_type == "patron")
			var/datum/patron/interrogator_patron = interrogator.patron
			var/datum/patron/victim_patron = patron
			switch(interrogator_patron.associated_faith.type)
				if(/datum/patron/old_god)
					if(victim_patron.type == /datum/patron/divine)
						interrogator.add_stress(/datum/stressevent/tortured)
					else if(victim_patron.type == /datum/patron/inhumen)
						interrogator.add_stress(/datum/stressevent/tortured)


		if(length(confessions))
			if(torture) // Only scream your confession if it's due to torture.
				say(pick(confessions), spans = list("torture"), forced = TRUE)
			else
				say(pick(confessions), forced = TRUE)
			if(has_confessed) // This is to check if the victim has already confessed, if so just inform the torturer and return. This is so that the Inquisitor cannot get infinite confession points and get all of the things upon getting thier first heretic.
				visible_message(span_warning("[name] has already signed a confession!"), "I have already signed a confession!")
				return
			var/obj/item/paper/confession/held_confession
			if(istype(confession_paper))
				held_confession = confession_paper
			else if(interrogator?.is_holding_item_of_type(/obj/item/paper/confession)) // This code is to process gettin a signed confession through torture.
				held_confession = interrogator.is_holding_item_of_type(/obj/item/paper/confession)
			if(held_confession && !held_confession.signed) // Check to see if the confession is already signed.
				// held_confession.bad_type = "AN EVILDOER" // In case new antags are added with confession lines but have yet to be added here.
				//this is no longer reliable as all patrons have confess lines now
				switch(antag_type)
					if("Bandit")
						held_confession.bad_type = "AN OUTLAW OF THE THIEF-LORD"
						held_confession.antag = antag_type
					if("Verewolf")
						held_confession.bad_type = "A BEARER OF DENDOR'S CURSE"
						held_confession.antag = antag_type
					if("Lesser Verewolf")
						held_confession.bad_type = "A BEARER OF DENDOR'S CURSE"
						held_confession.antag = antag_type
					if("Vampire")
						held_confession.bad_type = "A SCION OF KAINE"
						held_confession.antag = antag_type
					if("Lesser Vampire")
						held_confession.bad_type = "A SCION OF KAINE"
						held_confession.antag = antag_type
					if("Vampire Lord")
						held_confession.bad_type = "THE BLOOD-LORD OF VANDERLIN"
						held_confession.antag = antag_type
					if("Vampire Spawn")
						held_confession.bad_type = "AN UNDERLING OF THE BLOOD-LORD"
						held_confession.antag = antag_type
					if("Maniac")
						held_confession.bad_type = "A MANIAC DELUDED BY MADNESS"
						held_confession.antag = antag_type
					if("Matthios")
						held_confession.bad_type = "A FOLLOWER OF THE THIEF-LORD"
						held_confession.antag = "worshiper of " + antag_type
					if("Zizo")
						held_confession.bad_type = "A FOLLOWER OF THE FORBIDDEN ONE"
						held_confession.antag = "worshiper of " + antag_type
					if("Graggar")
						held_confession.bad_type = "A FOLLOWER OF THE DARK SUN"
						held_confession.antag = "worshiper of " + antag_type
					if("Godless")
						held_confession.bad_type = "A DAMNED ANTI-THEIST"
						held_confession.antag = "worshiper of nothing"
					if("Baotha")
						held_confession.bad_type = "A FOLLOWER OF THE REMORSELESS RUINER"
						held_confession.antag = "worshiper of " + antag_type
					if("Peasant Rebel")
						return // Inquisitors don't care about peasant revolts targeting the King
					else
						return // good job you tortured an innocent person
				has_confessed = TRUE
				held_confession.signed = real_name
				held_confession.info = "THE GUILTY PARTY ADMITS THEIR SINFUL NATURE AS <font color='red'>[held_confession.bad_type]</font>. THEY WILL SERVE ANY PUNISHMENT OR SERVICE AS REQUIRED BY THE ORDER OF THE PSYCROSS UNDER PENALTY OF DEATH.<br/><br/>SIGNED,<br/><font color='red'><i>[held_confession.signed]</i></font>"
				held_confession.update_icon_state()
			return
		else
			if(torture) // Only scream your confession if it's due to torture.
				say(pick(innocent_lines), spans = list("torture"), forced = TRUE)
			else
				say(pick(innocent_lines), forced = TRUE)
			return
	to_chat(src, span_good("I resist the torture!"))
	say(pick(innocent_lines), spans = list("torture"), forced = TRUE)
	return
