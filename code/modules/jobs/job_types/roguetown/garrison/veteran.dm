/datum/job/roguetown/veteran
	title = "Veteran"
	flag = VETERAN
	department_flag = MERCENARIES
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_sexes = list(MALE, FEMALE) //same as town guard
	allowed_races = RACES_ALL_KINDS//But. Actually not. Only Mercenary and Ex-Spy allow All Races.
	tutorial = "You've known combat your entire life. There isn't a way to kill a man you havent practiced in the tapestries of war itself. You wouldn't call yourself a hero--those belong to the men left rotting in the fields where you honed your ancient trade. You don't sleep well at night anymore, you don't like remembering what you've had to do to survive. Trading adventure for stable pay was the only logical solution, and maybe someday you'll get to lay down the blade and rest your weary body..."
	allowed_patrons = NON_PSYDON_PATRONS
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	advclass_cat_rolls = list(CTAG_VETERAN = 20)
	display_order = JDO_VET
	whitelist_req = TRUE
	give_bank_account = 35
	min_pq = 5 //Should...probably actually be a veteran of at least a few weeks before trying to teach others
	max_pq = null
	round_contrib_points = 2

	cmode_music = 'sound/music/combat_veteran.ogg'

/datum/outfit/job/roguetown/captain
	job_bitflag = BITFLAG_ROYALTY | BITFLAG_GARRISON	//Not a noble per-say but not really garrison either. So both, you are a courtier of sorts afterall + combat

/datum/job/roguetown/veteran/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
		if(istype(H.cloak, /obj/item/clothing/cloak/half/vet))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "veteran cloak ([index])"


/datum/advclass/veteran/battlemaster
	name = "Veteran Battlemaster"
	tutorial = "You have served under a hundred masters, some good, some bad. You were a general once. A marshal, a captain. To some a hero, others a monster. Something of the sorts. You made strategies, tactics, new innovations of war. A thousand new ways for one man to kill another. It still keeps you up at night."
	allowed_races = RACES_FEARED_UP//I'm going to assume they are the same criteria as MAA
	outfit = /datum/outfit/job/roguetown/vet/battlemaster

	category_tags = list(CTAG_VETERAN)

// Normal veteran start, from the olden days.

/datum/outfit/job/roguetown/vet/battlemaster/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/bevor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	beltl = /obj/item/rogueweapon/sword/sabre
	beltr = /obj/item/storage/keyring/guardcastle
	backr = /obj/item/storage/backpack/rogue/satchel/black
	cloak = /obj/item/clothing/cloak/half/vet
	belt = /obj/item/storage/belt/rogue/leather/black
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1)
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.change_stat("perception", 1)
	H.change_stat("intelligence", 2)
	H.change_stat("endurance", 1)
	H.change_stat("constitution", 1)
	H.change_stat("speed", 1)
	H.change_stat("strength", 1)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.change_stat("endurance", 1)

	H.verbs |= /mob/proc/haltyell
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.cmode_music = 'sound/music/combat_duelist.ogg'

/datum/advclass/veteran/footman
	name = "Retired Footman"
	tutorial = "You served on the fields of battle as no heroic knight steadfast in shining armor, but a mere mortal clad in whatever cheap armor coin could buy. You fought in formation as a member of a unit, and through discipline, have won numerous battles. Maybe one day you even served as the captain of your unit. You specialize in polearms and bows."
	allowed_races = RACES_FEARED_UP//I'm going to assume they are the same criteria as MAA
	outfit = /datum/outfit/job/roguetown/vet/footman

	category_tags = list(CTAG_VETERAN)

// No hero, just a normal guy who happened to survive war.

/datum/outfit/job/roguetown/vet/footman/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half // Meant to be better than man-at-arms, but worse than knight. No heavy armor!! This is a cuirass, not half-plate.
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	beltl = /obj/item/rogueweapon/sword
	beltr = /obj/item/storage/keyring/guardcastle
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/shield/tower/metal
	r_hand = /obj/item/rogueweapon/spear/billhook
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/rope/chain = 1)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE) // this is a kinda scary skill to give them, surely it won't go wrong though.
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE) // two handed weapons require a LOT of stamina.
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.change_stat("perception", 1)
	H.change_stat("intelligence", 2)
	H.change_stat("endurance", 1)
	H.change_stat("constitution", 2)
	H.change_stat("strength", 1)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
	H.verbs |= /mob/proc/haltyell
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

/datum/advclass/veteran/cavalryman
	name = "Tarnished Knight"
	tutorial = "You were once a member of a knightly calvary regiment, a prestigious title. You were ontop of the world, the townspeople rejoiced when you rode through their streets. Now, all you can hear is the screams of your brothers-in-arms as they fell. You specialize in mounted warfare."
	allowed_races = RACES_NOBILITY_ELIGIBLE_UP//Noble Knight.
	outfit = /datum/outfit/job/roguetown/vet/cavalryman

	category_tags = list(CTAG_VETERAN)

// You get a SAIGA. Saigas are pretty good, you lose out on your legendary weapon skills and you suck more on foot though.

/datum/outfit/job/roguetown/vet/cavalryman/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/plate/	////Former knights should have knightly armour.
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	beltr = /obj/item/storage/keyring/guardcastle
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.change_stat("perception", 1)
	H.change_stat("intelligence", 1)
	H.change_stat("endurance", 2)
	H.change_stat("constitution", 2)
	H.change_stat("speed", -1)
	H.change_stat("strength", 1)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE) // You get a lot of weapon skills, but none are legendary. Jack of all trades, master of none. This is probably worse than just having legendary in one, as people rarely swap weapons mid-combat.
		H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
	H.verbs |= /mob/proc/haltyell
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC) // retired knight!
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

	H.adjust_blindness(-3)
	var/weapons = list("Sword + Recurve Bow","Axe + Crossbow","Spear + Shield")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Sword + Recurve Bow")
			r_hand = /obj/item/rogueweapon/sword/long
			beltl = /obj/item/quiver/arrows
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve

		if("Axe + Crossbow")
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/steel
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			beltl = /obj/item/quiver/bolts

		if ("Spear + Shield")
			r_hand = /obj/item/rogueweapon/spear
			backl = /obj/item/rogueweapon/shield/tower/metal

/datum/advclass/veteran/merc
	name = "Retired Mercenary"
	tutorial = "You were a sell-sword, a warrior of coin. Your pockets were never light, you always had a warm place to stay and food in your belly, but you knew that every battle could be your last. You're the last of your unit, and you can't help but regret it."
	allowed_races = RACES_ALL_KINDS //Mercenary, and thus, the same options as the Mercenary class.
	
	outfit = /datum/outfit/job/roguetown/vet/merc

	category_tags = list(CTAG_VETERAN)
	classes = list("Grenzelhoft" = "Having once served with zweihandler or halberd in the professional echelons of the Grenzelhoft mercenary guild, they are now free from the guild to pursue lordly service rather then highest bidder.",
					"Janissary" = "The elite infantry of Ranesheni, you have found yourself far from home, may your current liege prove a better choice then the Autarchy back home.",
					"Condottiero" = "Hailing from Etrusca, you owe the Grand Duke for your life, and as such you've did the one thing unthinkable for one of the Condotterio. You've traded sellsword opportunism for a stable life.")
//Mercenary Veteran with options!

/datum/outfit/job/roguetown/vet/merc/pre_equip(mob/living/carbon/human/H)
	..()

	// CLASS ARCHETYPES
	H.adjust_blindness(-3)
	var/classes = list("Grenzelhoft","Janissary","Condottiero")
	var/classchoice = input("Choose your archetypes", "Available archetypes") as anything in classes

	switch(classchoice)
		if("Grenzelhoft") //this is the original Mercenary Veteran and is untouched
			neck = /obj/item/clothing/neck/roguetown/gorget
			wrists = /obj/item/clothing/wrists/roguetown/bracers
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft // You do NOT get the BLACKSTEEL CUIRASS for balance reasons.
			head = /obj/item/clothing/head/roguetown/grenzelhofthat
			armor = /obj/item/clothing/suit/roguetown/armor/plate/half
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
			shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
			gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
			beltl = /obj/item/rogueweapon/sword/short
			beltr = /obj/item/storage/keyring/guardcastle
			backr = /obj/item/storage/backpack/rogue/satchel/black
			belt = /obj/item/storage/belt/rogue/leather/black
			cloak = /obj/item/clothing/cloak/half/vet
			backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1)
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
			H.change_stat("intelligence", 1)
			H.change_stat("endurance", 3) // two handed weapons require a LOT of stamina.
			H.change_stat("constitution", 1)
			H.change_stat("speed", -1)
			H.change_stat("strength", 2)
			if(H.age == AGE_OLD)
				H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
				H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
				H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
				H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE) // two handed weapons require a LOT of stamina.
			H.verbs |= /mob/proc/haltyell
			H.grant_language(/datum/language/grenzelhoftian)
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
			H.cmode_music = 'sound/music/combat_grenzelhoft.ogg'

			var/weapons = list("Zweihander","Halberd")
			var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
			H.set_blindness(0)
			switch(weapon_choice)
				if("Zweihander")
					r_hand = /obj/item/rogueweapon/greatsword/grenz
					H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
					H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
				if("Halberd")
					r_hand = /obj/item/rogueweapon/halberd
					H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE) // SO, fun fact. The description of the grenzel halbardier says they specialize in axes, but they get no axe skill. Maybe this guy is where that rumor came from.
					H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		if("Janissary") //Battlemaster who sacrifices the potential to have both legendary sword and mace for more shield and armor
			to_chat(H, span_warning("The elite infantry of Ranesheni, you have found yourself far from home, may your current liege prove a better choice then the Autarchy back home."))
			head = /obj/item/clothing/head/roguetown/helmet/sallet/raneshen
			neck = /obj/item/clothing/neck/roguetown/bevor
			armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
			wrists = /obj/item/clothing/wrists/roguetown/splintarms
			gloves = /obj/item/clothing/gloves/roguetown/chain
			pants = /obj/item/clothing/under/roguetown/splintlegs
			backr = /obj/item/storage/backpack/rogue/satchel/black
			belt = /obj/item/storage/belt/rogue/leather/black
			beltr = /obj/item/storage/keyring/guardcastle
			cloak = /obj/item/clothing/cloak/half/vet
			backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/navaja, /obj/item/clothing/neck/roguetown/shalal)
			H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			H.change_stat("strength", 2)
			H.change_stat("endurance", 2)
			H.change_stat("constitution", 1)
			H.change_stat("perception", -1)
			H.change_stat("speed", 2)
			if(H.age == AGE_OLD)
				H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
				H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
				H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			H.grant_language(/datum/language/celestial)
			H.cmode_music = 'sound/music/combat_desertrider.ogg'
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
			var/weapons = list("Heavy Mace","Shamshir and Shield","Spear and Shield")
			var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
			H.set_blindness(0)
			switch(weapon_choice)
				if("Heavy Mace")
					H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
					backl = /obj/item/rogueweapon/mace/goden
				if("Shamshir and Shield")
					H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
					r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
					backl = /obj/item/rogueweapon/shield/tower/raneshen
				if("Spear and Shield")
					H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
					r_hand = /obj/item/rogueweapon/spear
					backl = /obj/item/rogueweapon/shield/tower/raneshen
		if("Condottiero") //Crossbow Specialist Former Scout who is nowhere as versatile in training.
			to_chat(H, span_warning("A crossbowmen hailing from Etrusca, you owe the Grand Duke for your life, and as such you've did the one thing unthinkable for one of the Condotterio. You've traded sellsword opportunism for stable employment."))
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
			cloak = /obj/item/clothing/cloak/half/vet
			gloves = /obj/item/clothing/gloves/roguetown/angle
			belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/iron
			head = /obj/item/clothing/head/roguetown/helmet
			armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
			backl = /obj/item/storage/backpack/rogue/satchel
			beltl = /obj/item/rogueweapon/sword/short
			beltr = /obj/item/quiver/bolts
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
			pants = /obj/item/clothing/under/roguetown/trou/leather
			neck = /obj/item/clothing/neck/roguetown/chaincoif
			backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/navaja, /obj/item/lockpick = 1, /obj/item/storage/keyring/guardcastle = 1)
			H.adjust_skillrank(/datum/skill/combat/crossbows, 5, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/tracking, 4, TRUE)
			H.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)
			H.change_stat("strength", -1)
			H.change_stat("endurance", 1)
			H.change_stat("perception", 3) // you are OLD you have OLD EYES. this is to counter that debuff so you can be OBSERVANT. You sacrifice your strength and armor, so.
			H.change_stat("speed", 2)
			H.change_stat("intelligence", 2)
			if(H.age == AGE_OLD)
				H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
				H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
				H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
				H.change_stat("perception", 2)
			H.grant_language(/datum/language/etruscan)
			H.grant_language(/datum/language/thievescant)
			H.cmode_music = 'sound/music/combat_condottiero.ogg'
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC) //As with Former Scout, better to parry, but the option is there.
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)


/datum/advclass/veteran/scout
	name = "Former Scout"
	allowed_races = RACES_FEARED_UP //Same as MAA, who might as well assume they were apart of.
	tutorial = "You and your unit maneuvered ahead of the main force, ever-watchful for traps and ambushes. You never thought of what would happen should you actually walk into one. You specialize in archery and axes."
	outfit = /datum/outfit/job/roguetown/vet/scout

	category_tags = list(CTAG_VETERAN)

// Originally was meant to be a horse archer. I decided that was a bad idea.
// Former Bogmaster maybe? I feel like that'd be cooler than just an archer guy.

/datum/outfit/job/roguetown/vet/scout/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	beltl = /obj/item/quiver/arrows
	beltr = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/storage/keyring/guardcastle = 1)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE) // I very rarely see ranged weapons outside of PVE. Maybe this'll fix that?
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
	H.change_stat("strength", -1)
	H.change_stat("perception", 3) // you are OLD you have OLD EYES. this is to counter that debuff so you can be OBSERVANT. You sacrifice your strength and armor, so.
	H.change_stat("intelligence", 2)
	H.change_stat("endurance", 1)
	H.change_stat("constitution", 1)
	H.change_stat("speed", 1) // You get -2 speed from being old.
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
		H.change_stat("perception", 2)
	H.verbs |= /mob/proc/haltyell
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC) // You should really be parrying anyways, you have legendary/master skills....
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_WOODSMAN, TRAIT_GENERIC)
	H.cmode_music = 'sound/music/combat_rogue.ogg'

/datum/advclass/veteran/spy
	name = "Ex-Spy"
	tutorial = "You didn't serve on the frontlines, you were an informant, a spy, an assassin. You wove your way through enemy courts, finding information, neutralizing loose ends. You lived old in a career that many die young. It's a miracle you stand here today. You specialize in knives, whips, and stealth."
	allowed_races = RACES_ALL_KINDS //They were a spy. Disposable. It'd make even more sense to send a despised race out for such a high-risk task.
	outfit = /datum/outfit/job/roguetown/vet/spy
	category_tags = list(CTAG_VETERAN)

// The sneaker. Not really typical, but hey, wildcard. Wanna-be Spymaster. I guess that just makes them a normal spy, or, once one.

/datum/outfit/job/roguetown/vet/spy/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/white
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	pants = /obj/item/clothing/under/roguetown/tights/black
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	beltl = /obj/item/rogueweapon/whip
	beltr = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/silver/elvish = 1, /obj/item/storage/keyring/guardcastle = 1, /obj/item/reagent_containers/glass/bottle/rogue/poison = 1, /obj/item/lockpickring/mundane)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
	H.change_stat("strength", -2)
	H.change_stat("perception", 1)
	H.change_stat("intelligence", 3) // you are int-maxxing, especially if you go old.
	H.change_stat("constitution", 1)
	H.change_stat("speed", 1)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE) ///Having Master Knives is extremely negligible for a singular role that isn't even meant to be combative.
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
		H.change_stat("speed", 1) // You get -2 speed from being old. You are still in the negative stat wise from picking old.
		H.change_stat("perception", 2) // You get -2 perception from being old. I want you to at least have a positive perception, to represent that you're observant. The highest perception you can get with this is a 13, so I think we'll be okayed.
	H.verbs |= /mob/proc/haltyell
	H.grant_language(/datum/language/thievescant)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)
