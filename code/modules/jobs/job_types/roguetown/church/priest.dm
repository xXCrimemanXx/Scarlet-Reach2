GLOBAL_LIST_EMPTY(apostasy_players)
GLOBAL_LIST_EMPTY(cursed_players)
GLOBAL_LIST_EMPTY(excommunicated_players)
GLOBAL_LIST_EMPTY(heretical_players)

/datum/job/roguetown/priest
	title = "Priest"
	flag = PRIEST
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_CHURCH
	f_title = "Priestess"
	allowed_races = RACES_SECOND_CLASS_NO_GOLEM		//Too recent arrivals to ascend to priesthood.
	disallowed_races = list(
		/datum/species/lamia,
	)
	allowed_patrons = ALL_DIVINE_PATRONS
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "The Divine is all that matters in a world of the immoral. The Weeping God left his children to rule over us mortals--and you will preach their wisdom to any who still heed their will. The faithless are growing in number. It is up to you to shepard them toward a Gods-fearing future; for you are a priest of Astrata."
	whitelist_req = FALSE


	spells = list(/obj/effect/proc_holder/spell/invoked/cure_rot, /obj/effect/proc_holder/spell/self/convertrole/templar, /obj/effect/proc_holder/spell/self/convertrole/monk)
	outfit = /datum/outfit/job/roguetown/priest

	display_order = JDO_PRIEST
	give_bank_account = 115
	min_pq = 5 // You should know the basics of things if you're going to lead the town's entire religious sector
	max_pq = null
	round_contrib_points = 3

	//No nobility for you, being a member of the clergy means you gave UP your nobility. It says this in many of the church tutorial texts.
	virtue_restrictions = list(/datum/virtue/utility/noble)

/datum/outfit/job/roguetown/priest
	job_bitflag = BITFLAG_CHURCH
	allowed_patrons = list(/datum/patron/divine/astrata)	//We lock this cus head of church, acktully

/datum/outfit/job/roguetown/priest/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/psicross/astrata
	head = /obj/item/clothing/head/roguetown/priestmask
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	beltl = /obj/item/storage/keyring/priest
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	id = /obj/item/clothing/ring/active/nomag
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/priest
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/needle/pestra = 1,
		/obj/item/natural/worms/leech/cheele = 1, //little buddy
		/obj/item/ritechalk = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/holysee = 1,	//Unique knife from the Holy See
	)
	ADD_TRAIT(H, TRAIT_CHOSEN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_RITUALIST, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)

	H.cmode_music = 'sound/music/combat_holy.ogg'
	H.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 3, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	H.change_stat("strength", -1)
	H.change_stat("intelligence", 3)
	H.change_stat("constitution", -1)
	H.change_stat("endurance", 1)
	H.change_stat("speed", -1)
	var/datum/devotion/C = new /datum/devotion(H, H.patron) // This creates the cleric holder used for devotion spells
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.

	H.verbs |= /mob/living/carbon/human/proc/coronate_lord
	H.verbs |= /mob/living/carbon/human/proc/churchexcommunicate //your button against clergy
	H.verbs |= /mob/living/carbon/human/proc/churchannouncement
	H.verbs |= /mob/living/carbon/human/proc/churchpriestcurse //snowflake priests button. Will not sacrifice them
	H.verbs |= /mob/living/carbon/human/proc/churcheapostasy //punish the lamb reward the wolf
	H.verbs |= /mob/living/carbon/human/proc/completesermon
	H.verbs |= /mob/living/carbon/human/proc/change_miracle_set

//	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)		- You are literally disinherited. Begone......

/datum/job/priest/vice //just used to change the priest title
	title = "Vice Priest"
	f_title = "Vice Priestess"
	flag = PRIEST
	department_flag = CHURCHMEN
	total_positions = 0
	spawn_positions = 0

/mob/living/carbon/human/proc/change_miracle_set(mob/living/user)
	set name = "Change Miracle Set"
	set category = "Priest"
	if(!mind)
		return
	var/list/god_choice = list()
	var/list/god_type = list()
	for (var/path as anything in GLOB.patrons_by_faith[/datum/faith/divine])
		var/datum/patron/patron = GLOB.patronlist[path]
		god_choice += list("[patron.name]" = icon(icon = 'icons/mob/overhead_effects.dmi', icon_state = "sign_[patron.name]"))
		god_type[patron.name] = patron
	var/string_choice = show_radial_menu(src, src, god_choice, require_near = FALSE)
	if(!string_choice)
		return
	var/datum/patron/god = god_type[string_choice]
	mind.RemoveAllSpells()
	var/datum/devotion/patrondev = new /datum/devotion(src, god)
	patrondev.grant_miracles(src, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = FALSE)
	if (string_choice == "Astrata")
		to_chat(src, "<font color='yellow'>HEAVEN SHALL THEE RECOMPENSE. THOU BEARS MYNE POWER ONCE MORE.</font>")
	else
		to_chat(src, "<font color='yellow'>Thou wieldeth now the power of [string_choice].</font>")
	to_chat(src, "<font color='yellow'>TThe strain of changing your miracles has consumed all your devotion.</font>")
	mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/cure_rot)
	mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/monk)
	mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/templar)

/mob/living/carbon/human/proc/coronate_lord()
	set name = "Coronate"
	set category = "Priest"
	if(!mind)
		return
	if(world.time < 30 MINUTES)
		to_chat(src, span_warning("It is a bad omen to coronate so early in the week."))
		return FALSE
	if(!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("I need to do this in the chapel."))
		return FALSE
	for(var/mob/living/carbon/human/HU in get_step(src, src.dir))
		if(!HU.mind)
			continue
		if(HU.mind.assigned_role == "Grand Duke")
			continue
		if(!HU.head)
			continue
		if(!istype(HU.head, /obj/item/clothing/head/roguetown/crown/serpcrown))
			continue

		//Abdicate previous King
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.mind)
				if(HL.mind.assigned_role == "Grand Duke")
					HL.mind.assigned_role = "Towner" //So they don't get the innate traits of the king
			//would be better to change their title directly, but that's not possible since the title comes from the job datum
			if(HL.job == "Grand Duke")
				HL.job = "Duke Emeritus"

		//Coronate new King (or Queen)
		HU.mind.assigned_role = "Grand Duke"
		HU.job = "Grand Duke"
		if(should_wear_femme_clothes(HU))
			SSticker.rulertype = "Grand Duchess"
		else
			SSticker.rulertype = "Grand Duke"
		SSticker.rulermob = HU
		SSticker.regentmob = null
		var/dispjob = mind.assigned_role
		removeomen(OMEN_NOLORD)
		say("By the authority of the gods, I pronounce you Ruler of all Scarlet Reach!")
		priority_announce("[real_name] the [dispjob] has named [HU.real_name] the inheritor of SCARLET REACH!", title = "Long Live [HU.real_name]!", sound = 'sound/misc/bell.ogg')
		var/datum/job/roguetown/nomoredukes = SSjob.GetJob("Grand Duke")
		if(nomoredukes)
			nomoredukes.total_positions = -1000 //We got what we got now.


/mob/living/carbon/human/proc/churchexcommunicate()
    set name = "Excommunicate"
    set category = "Priest"

    if (stat)
        return

    var/inputty = input("Excommunicate someone, away from the Ten... Or show to their heretical gods that they are worthy... (excommunicate them again to remove it)", "Sinner Name") as text|null

    if (inputty)
        if (!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
            to_chat(src, span_warning("I need to do this from the Church."))
            return FALSE

        if (inputty in GLOB.excommunicated_players)
            GLOB.excommunicated_players -= inputty
            priority_announce("[real_name] has forgiven [inputty]. Their patron hears their prayer once more!", title = "Hail the Ten!", sound = 'sound/misc/bell.ogg')

            for (var/mob/living/carbon/human/H in GLOB.player_list)
                if (H.real_name == inputty)
                    REMOVE_TRAIT(H, TRAIT_EXCOMMUNICATED, TRAIT_GENERIC)

                    if (H.patron)
                        if (istype(H.patron, /datum/patron/divine))
                            H.remove_stress(/datum/stressevent/excommunicated)
                            H.remove_status_effect(/datum/status_effect/debuff/excomm)
                        else if (istype(H.patron, /datum/patron/inhumen))
                            H.remove_stress(/datum/stressevent/gazeuponme)
                            H.remove_status_effect(/datum/status_effect/buff/gazeuponme)
                        else
                            continue
            return

        var/found = FALSE

        for (var/mob/living/carbon/human/H in GLOB.player_list)
            if (H == src)
                continue
            if (H.real_name == inputty)
                found = TRUE
                ADD_TRAIT(H, TRAIT_EXCOMMUNICATED, TRAIT_GENERIC)

                if (H.patron)
                    if (istype(H.patron, /datum/patron/divine))
                        H.add_stress(/datum/stressevent/excommunicated)
                        H.apply_status_effect(/datum/status_effect/debuff/excomm)
                        to_chat(H, span_warning("Your divine patron recoils from your excommunication."))
                    else if (istype(H.patron, /datum/patron/inhumen))
                        H.add_stress(/datum/stressevent/gazeuponme)
                        H.apply_status_effect(/datum/status_effect/buff/gazeuponme)
                        to_chat(H, span_notice("Your inhuman patron embraces your rejection from the Ten."))
                    else
                        continue

        if (!found)
            return FALSE

        GLOB.excommunicated_players += inputty
        priority_announce("[real_name] has excommunicated [inputty]!", title = "SHAME", sound = 'sound/misc/excomm.ogg')

/mob/living/carbon/human/proc/churchannouncement()
	set name = "Announcement"
	set category = "Priest"
	if(stat)
		return
	var/inputty = input("Make an announcement", "SCARLET REACH") as text|null
	if(inputty)
		if(!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
			to_chat(src, span_warning("I need to do this from the chapel."))
			return FALSE
		priority_announce("[inputty]", title = "The Priest Speaks", sound = 'sound/misc/bell.ogg', sender = src)

/mob/living/carbon/human/proc/churcheapostasy()
	set name = "Apostasy"
	set category = "Priest"

	if (stat)
		return

	var/inputty = input("Put an apostasy on someone, removing their ability to use miracles... (apostasy them again to remove it)", "Sinner Name") as text|null

	if (!inputty)
		return

	if (!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("I need to do this from the Church's chapel."))
		return FALSE

	if (inputty in GLOB.apostasy_players)
		GLOB.apostasy_players -= inputty
		priority_announce("[real_name] has forgiven [inputty]. Their patron hears their prayer once more!", title = "Hail the Ten!", sound = 'sound/misc/bell.ogg')

		for (var/mob/living/carbon/human/H in GLOB.player_list)
			if (H.real_name == inputty)
				if (istype(H.patron, /datum/patron/divine) && H.devotion)
					H.devotion.recommunicate()
					H.remove_status_effect(/datum/status_effect/debuff/apostasy)
					H.remove_stress(/datum/stressevent/apostasy)

		return TRUE

	var/found = FALSE

	for (var/mob/living/carbon/human/H in GLOB.player_list)
		if (H.real_name == inputty)
			found = TRUE
			GLOB.apostasy_players += inputty

			if (istype(H.patron, /datum/patron/divine) && H.devotion)
				H.devotion.excommunicate()
				H.apply_status_effect(/datum/status_effect/debuff/apostasy)
				H.add_stress(/datum/stressevent/apostasy)
				to_chat(H, span_warning("A holy silence falls upon you. Your Patron cannot hear you anymore..."))
			else
				to_chat(H, span_warning("A holy silence falls upon you..."))

			priority_announce("[real_name] has cast apostasy upon [inputty]. Their prayers fall on deaf ears.", title = "SHAME", sound = 'sound/misc/excomm.ogg')
			return TRUE

	if (!found)
		return FALSE

/mob/living/carbon/human/proc/completesermon()
	set name = "Sermon"
	set category = "Priest"

	if (!mind)
		return

	if (!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("I need to do this in the chapel."))
		return FALSE

	src.visible_message(span_notice("[src] begins preaching a sermon..."))

	if (!do_after(src, 300, target = src)) // 30 seconds
		src.visible_message(span_warning("[src] stops preaching."))
		return

	src.visible_message(span_notice("[src] finishes the sermon, inspiring those nearby!"))

	for (var/mob/living/carbon/human/H in view(7, src))
		if (!H.patron)
			continue

		if (istype(H.patron, /datum/patron/divine))
			H.apply_status_effect(/datum/status_effect/buff/sermon)
			H.add_stress(/datum/stressevent/sermon)
			to_chat(H, span_notice("You feel a divine affirmation from your patron."))

		else if (istype(H.patron, /datum/patron/inhumen))
			H.apply_status_effect(/datum/status_effect/debuff/hereticsermon)
			H.add_stress(/datum/stressevent/heretic_on_sermon)
			to_chat(H, span_warning("Your patron seethes with disapproval."))

		else
			// Other patrons - fluff only
			to_chat(H, span_notice("Nothing seems to happen to you."))

	return TRUE

/mob/living/carbon/human/proc/churchpriestcurse()
    set name = "Divine punishment"
    set category = "Priest"

    if (stat)
        return

    if (world.time < last_curse_time + 12000) // 1200 seconds = 20 minutes
        to_chat(src, span_warning("You must wait before invoking divine punishment again."))
        return

    var/target_name = input("Who shall receive divine punishment?", "Target Name") as text|null
    if (!target_name)
        return

    var/list/curse_choices = list(
        "Ravox's Curse" = /datum/curse/ravox, //your way to deal with TOP 10 ROGUE BUILD PLAYERS. They lose ~2 level of their combat skills (-30 parry dodge accuracy)
        "Necra's Curse" = /datum/curse/necra, //they cannot be revived
        "Pestra's Curse" = /datum/curse/pestra, //annoying effects
        "Eora's Curse" = /datum/curse/eora, //locks their 50% erp buttons and they cannot end up
        "Abyssor's Curse" = /datum/curse/abyssor, //water burns them
        "Malum's Curse" = /datum/curse/malum //They cannot craft or touch smith hammer
    )

    var/curse_pick = input("Choose a curse to apply or lift.", "Select Curse") as null|anything in curse_choices
    if (!curse_pick)
        return

    var/curse_type = curse_choices[curse_pick]

    for (var/mob/living/carbon/human/H in GLOB.player_list)
        if (H.real_name == target_name)
            if (H == src)
                to_chat(src, span_warning("Cursing yourself is heresy!"))
                return

            var/datum/curse/temp = new curse_type()

            if (H.is_cursed(temp))
                H.remove_curse(temp)
                priority_announce("[real_name] has lifted [curse_pick] from [H.real_name]!", title = "Mercy of the Faith", sound = 'sound/misc/bell.ogg')
            else
                if (length(H.curses) >= 1)
                    to_chat(src, span_warning("[H.real_name] is already afflicted by another curse."))
                    return

                // Check if target is a bandit, wretch, lich, or vampire lord - silently fail for outlaws and undead
                if (H.mind?.assigned_role == "Bandit" || H.mind?.special_role == "Bandit" || H.mind?.assigned_role == "Wretch" || H.mind?.special_role == "Lich" || H.mind?.special_role == "Vampire Lord")
                    // Curse appears to work but has no effect on outlaws and undead
                    priority_announce("[real_name] has cursed [H.real_name] with [curse_pick]!", title = "Judgment of the Gods", sound = 'sound/misc/excomm.ogg')
                    last_curse_time = world.time // set cooldown
                    return

                H.add_curse(curse_type)
                priority_announce("[real_name] has cursed [H.real_name] with [curse_pick]!", title = "Judgment of the Gods", sound = 'sound/misc/excomm.ogg')

            last_curse_time = world.time // set cooldown
            return

    to_chat(src, span_warning("No soul has such name."))

/obj/effect/proc_holder/spell/self/convertrole/templar
	name = "Recruit Templar"
	new_role = "Templar"
	overlay_state = "recruit_templar"
	recruitment_faction = "Templars"
	recruitment_message = "Serve the ten, %RECRUIT!"
	accept_message = "FOR THE TEN!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/monk
	name = "Recruit Acolyte"
	new_role = "Acolyte"
	overlay_state = "recruit_acolyte"
	recruitment_faction = "Church"
	recruitment_message = "Serve the ten, %RECRUIT!"
	accept_message = "FOR THE TEN!"
	refuse_message = "I refuse."
