/datum/antagonist/lich
	name = "Lich"
	roundend_category = "Lich"
	antagpanel_category = "Lich"
	job_rank = ROLE_LICH
	confess_lines = list(
		"I WILL LIVE ETERNAL!",
		"I AM BEHIND SEVEN PHYLACTERIES!",
		"YOU CANNOT KILL ME!",
	)
	rogue_enabled = TRUE
	var/list/phylacteries = list()
	var/out_of_lives = FALSE

	var/traits_lich = list(	
		TRAIT_INFINITE_STAMINA,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_VAMPMANSION,
		TRAIT_NOMOOD,
		TRAIT_NOLIMBDISABLE,
		TRAIT_SHOCKIMMUNE,
		TRAIT_LIMBATTACHMENT,
		TRAIT_SEEPRICES,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_HEAVYARMOR,
		TRAIT_CABAL,
		TRAIT_DEATHSIGHT,
		TRAIT_COUNTERCOUNTERSPELL,
		TRAIT_RITUALIST,
		TRAIT_ARCYNE_T3
		)

	var/STASTR = 10
	var/STASPD = 10
	var/STAINT = 10
	var/STAEND = 10
	var/STAPER = 10

/datum/antagonist/lich/on_gain()
	SSmapping.retainer.liches |= owner
	. = ..()
	owner.special_role = name
	skele_look()
	equip_lich()
	greet()
	save_stats()

	return ..()

/datum/antagonist/lich/greet()
	to_chat(owner.current, span_userdanger("An immortal king cries for new subjects. Subdue and conquer."))
	owner.announce_objectives()
	..()

/datum/antagonist/lich/proc/save_stats()
	STASTR = owner.current.STASTR
	STAPER = owner.current.STAPER
	STAINT = owner.current.STAINT
	STASPD = owner.current.STASPD
	STAEND = owner.current.STAEND

/datum/antagonist/lich/proc/set_stats()
	owner.current.STASTR = src.STASTR
	owner.current.STAPER = src.STAPER
	owner.current.STAINT = src.STAINT
	owner.current.STASPD = src.STASPD
	owner.current.STAEND = src.STAEND

/datum/antagonist/lich/proc/skele_look()
	var/mob/living/carbon/human/L = owner.current
	L.hairstyle = "Bald"
	L.facial_hairstyle = "Shaved"
	L.update_body()
	L.update_hair()
	L.update_body_parts(redraw = TRUE)

/datum/antagonist/lich/proc/equip_lich()
	owner.unknow_all_people()
	for (var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)

	var/mob/living/carbon/human/L = owner.current
	L.cmode_music = 'sound/music/combat_heretic.ogg'
	L.faction = list("undead")

	if (L.charflaw)
		QDEL_NULL(L.charflaw)

	L.mob_biotypes |= MOB_UNDEAD
	replace_eyes(L)

	for (var/obj/item/bodypart/B in L.bodyparts)
		B.skeletonize(FALSE)

	equip_and_traits()
	L.equipOutfit(/datum/outfit/job/roguetown/lich)
	L.set_patron(/datum/patron/inhumen/zizo)
	owner.current.forceMove(pick(GLOB.vlord_starts)) // as opposed to spawning at their normal role spot as a skeleton; which is le bad


/datum/outfit/job/roguetown/lich/pre_equip(mob/living/carbon/human/H) //Equipment is located below
	..()

	H.adjust_skillrank(/datum/skill/misc/reading, 6, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 5, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H?.mind.adjust_spellpoints(27)
	// Give it decent combat stats to make up for loss of 2 extra lives
	H.change_stat("strength", 3)
	H.change_stat("intelligence", 5)
	H.change_stat("constitution", 5)
	H.change_stat("perception", 3)
	H.change_stat("speed", 1)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonechill)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_lesser_undead)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/bloodlightning)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/lich_announce)
	H.ambushable = FALSE

	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "LICH"), 5 SECONDS)

/datum/antagonist/lich/proc/replace_eyes(mob/living/carbon/human/L)
	var/obj/item/organ/eyes/eyes = L.getorganslot(ORGAN_SLOT_EYES)
	if (eyes)
		eyes.Remove(L, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(L)

/datum/outfit/job/roguetown/lich/post_equip(mob/living/carbon/human/H)
	..()
	var/datum/antagonist/lich/lichman = H.mind.has_antag_datum(/datum/antagonist/lich)
	// One phylactery instead of 3 so that they don't need to get chased down non-stop.
	var/obj/item/phylactery/new_phylactery = new(H.loc)
	lichman.phylacteries += new_phylactery
	new_phylactery.possessor = lichman
	H.equip_to_slot_or_del(new_phylactery,SLOT_IN_BACKPACK, TRUE)

/datum/antagonist/lich/proc/consume_phylactery(timer = 10 SECONDS)
	if(phylacteries.len)
		for(var/obj/item/phylactery/phyl in phylacteries)
			phyl.be_consumed(timer)
			phylacteries -= phyl
			return TRUE
	return FALSE


///Called post death to equip new body with armour and stats. Order of equipment matters
/datum/antagonist/lich/proc/equip_and_traits()
	var/mob/living/carbon/human/body = owner.current 
	var/list/equipment_slots = list(
		SLOT_PANTS,
		SLOT_SHOES,
		SLOT_NECK,
		SLOT_CLOAK,
		SLOT_ARMOR,
		SLOT_SHIRT,
		SLOT_WRISTS,
		SLOT_GLOVES,
		SLOT_BELT,
		SLOT_BELT_R,
		SLOT_BELT_L,
		SLOT_HANDS,
		SLOT_HANDS,
		SLOT_BACK_L,
		)

	var/list/equipment_items = list(
		/obj/item/clothing/under/roguetown/chainlegs,
		/obj/item/clothing/shoes/roguetown/boots,
		/obj/item/clothing/neck/roguetown/chaincoif,
		/obj/item/clothing/cloak/raincloak/mortus,
		/obj/item/clothing/suit/roguetown/armor/plate/blacksteel_half_plate,
		/obj/item/clothing/suit/roguetown/shirt/tunic/ucolored,
		/obj/item/clothing/wrists/roguetown/bracers,
		/obj/item/clothing/gloves/roguetown/chain,
		/obj/item/storage/belt/rogue/leather/black,
		/obj/item/reagent_containers/glass/bottle/rogue/manapot,
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/rogueweapon/woodstaff/riddle_of_steel,
		/obj/item/ritechalk,
		/obj/item/storage/backpack/rogue/satchel,
	)
	for (var/i = 1, i <= equipment_slots.len, i++)
		var/slot = equipment_slots[i]
		var/item_type = equipment_items[i]
		body.equip_to_slot_or_del(new item_type, slot, TRUE)

	for (var/trait in traits_lich)
		ADD_TRAIT(body, trait, "[type]")

/datum/antagonist/lich/proc/rise_anew()
	if (!owner.current.mind)
		CRASH("Lich: rise_anew called with no mind")
	
	var/mob/living/carbon/human/old_body = owner.current
	var/turf/phylactery_turf = get_turf(old_body)
	var/mob/living/carbon/human/new_body = new /mob/living/carbon/human/species/human/northern(phylactery_turf)

	old_body.mind.transfer_to(new_body)

	if (new_body.charflaw)
		QDEL_NULL(new_body.charflaw)
	
	new_body.real_name = old_body.name
	new_body.dna.real_name = old_body.real_name
	new_body.mob_biotypes |= MOB_UNDEAD
	new_body.faction = list("undead")
	new_body.set_patron(/datum/patron/inhumen/zizo)
	new_body.mind.grab_ghost(force = TRUE)

	for (var/obj/item/bodypart/body_part in new_body.bodyparts)
		body_part.skeletonize(FALSE)
		
	replace_eyes(new_body)
	set_stats()
	skele_look()
	equip_and_traits()
	// Delete the old body if it still exists
	if (!QDELETED(old_body))
		qdel(old_body)


/obj/item/phylactery
	name = "phylactery"
	desc = "Looks like it is filled with some intense power."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	layer = HIGH_OBJ_LAYER
	w_class = WEIGHT_CLASS_TINY
	light_system = MOVABLE_LIGHT
	light_outer_range = 3
	light_color = "#e62424"

	var/datum/antagonist/lich/possessor
	var/datum/mind/mind

/obj/item/phylactery/Initialize(mapload, datum/mind/newmind)
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))

/obj/item/phylactery/proc/be_consumed(timer)
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = -1) //start shaking
	visible_message(span_warning("[src] begins to glow and shake violently!"))
	
	spawn(timer)
		possessor.owner.current.forceMove(get_turf(src))
		possessor.rise_anew()
		qdel(src)

/obj/effect/proc_holder/spell/invoked/raise_undead
	name = "Raise Greater Undead"
	desc = ""
	clothes_req = FALSE
	range = 7
	overlay_state = "animate"
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 60
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	gesture_required = TRUE // Summon spell
	associated_skill = /datum/skill/magic/arcane
	recharge_time = 60 SECONDS

/obj/effect/proc_holder/spell/invoked/raise_undead/cast(list/targets, mob/living/user)
	..()

	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		revert_cast()
		return FALSE

	var/list/candidates = pollGhostCandidates("Do you want to play as a Lich's skeleton?", ROLE_LICH_SKELETON, null, null, 10 SECONDS, POLL_IGNORE_LICH_SKELETON)
	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("The depths are hollow."))
		revert_cast()
		return FALSE

	var/mob/C = pick(candidates)
	if(!C || !istype(C, /mob/dead))
		revert_cast()
		return FALSE

	if (istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	var/mob/living/carbon/human/species/skeleton/no_equipment/target = new /mob/living/carbon/human/species/skeleton/no_equipment(T)
	target.key = C.key
	SSjob.EquipRank(target, "Fortified Skeleton", TRUE)
	target.visible_message(span_warning("[target]'s eyes light up with an eerie glow!"))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "FORTIFIED SKELETON"), 3 SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	return TRUE

/obj/effect/proc_holder/spell/self/suicidebomb
	name = "Calcic Outburst"
	desc = "Explode in a wonderful blast of osseous shrapnel."
	overlay_state = "tragedy"
	chargedrain = 0
	chargetime = 0
	recharge_time = 10 SECONDS
	sound = 'sound/magic/swap.ogg'
	warnie = "spellwarning"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	stat_allowed = TRUE
	var/exp_heavy = 0
	var/exp_light = 3
	var/exp_flash = 3
	var/exp_fire = 0

/obj/effect/proc_holder/spell/self/suicidebomb/cast(list/targets, mob/living/user = usr)
	..()
	if(!user)
		return FALSE
	if(user.stat == DEAD)
		return FALSE
	if(alert(user, "Do you wish to sacrifice this vessel in a powerful explosion?", "ELDRITCH BLAST", "Yes", "No") == "No")
		return FALSE
	playsound(get_turf(user), 'sound/magic/antimagic.ogg', 100)
	user.visible_message(
		span_danger("[user] begins to shake violently, a blindingly bright light beginning to emanate from them!"), 
		span_danger("Powerful energy begins to expand outwards from inside me!")
	)

	user.Immobilize(5 SECONDS)
	user.Knockdown(5 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(lichdeath), user), 5 SECONDS)

/obj/effect/proc_holder/spell/self/suicidebomb/proc/lichdeath(mob/living/user)
	var/datum/antagonist/lich/lichman = user.mind.has_antag_datum(/datum/antagonist/lich)
	explosion(get_turf(user), -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire, soundin = 'sound/misc/explode/incendiary (1).ogg')
	if(lichman && user.stat != DEAD && lichman.consume_phylactery(0)) // Use phylactery at 0 timer. Die if none.
		return TRUE

	user.death()
	return TRUE

/obj/effect/proc_holder/spell/self/suicidebomb/lesser
	name = "Lesser Calcic Outburst"
	exp_heavy = 0
	exp_light = 2
	exp_flash = 2
	exp_fire = 0

/obj/effect/proc_holder/spell/self/lich_announce
	name = "Command Will"
	desc = "Send a booming message to the undead under your will."
	recharge_time = 20 SECONDS

/obj/effect/proc_holder/spell/self/lich_announce/cast(list/targets, mob/user)
	if(user.stat)
		return FALSE
	
	var/calltext = input("Send Your Will To Your Undead", "UNDEAD ANNOUNCE") as text|null
	if(!calltext)
		return FALSE

	priority_announce("[calltext]", title = "Your Lich King Commands", sound = 'sound/misc/deadbell.ogg', sender = user, receiver = /mob/living/carbon/human/species/skeleton)

	..()
