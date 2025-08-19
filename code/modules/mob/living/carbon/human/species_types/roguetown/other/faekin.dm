/mob/living/carbon/human/species/faekin
	race = /datum/species/faekin
	voice_pitch = 2

/datum/species/faekin
	name = "Faekin"
	id = "faekin"
	desc = "<b>Faekin</b><br>\
	The diminutive Faekin are one of the smallest races you may encounter. \
    Strongly magickly attuned and influenced by nature and the elements, Faekin thrive in environments laden with chaos. \
    They do not reproduce in the fashion of other races, instead sprouting naturally from sources of wild and chaotic magick. \
    The understanding of the Faekin race is rife with myth, rumor, and legend.  \
    Those who cross paths with Faekin should tread with care, as they bring misery and fortune in equal measure.<br>\
	(-8 Strength, -2 Endurance, -6 Constitution, +2 Perception, +2 Intelligence)"

	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY)
	possible_ages = ALL_AGES_LIST
	default_features = MANDATORY_FEATURE_LIST
	inherent_traits = list(TRAIT_NOMOBSWAP, TRAIT_NOFALLDAMAGE2, TRAIT_TINY, TRAIT_CRITICAL_WEAKNESS, TRAIT_ZOMBIE_IMMUNE, TRAIT_CHAOTIC_MIND)
	use_skintones = TRUE
	skin_tone_wording = "Attunement"
	soundpack_m = /datum/voicepack/male/goblin //seems fitting
	soundpack_f = /datum/voicepack/female/goblin
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,1), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,0), \
		)
	race_bonus = list(STAT_STRENGTH = -8, STAT_ENDURANCE = -2, STAT_CONSTITUTION = -8, STAT_PERCEPTION = 2, STAT_INTELLIGENCE = 2, STAT_SPEED = 2) 
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/elfw,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_WINGS = /obj/item/organ/wings/faekin,
		)
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/organ/tail/anthro,
		/datum/customizer/organ/tail_feature/anthro,
		/datum/customizer/organ/snout/anthro,
		/datum/customizer/organ/ears/anthro,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/frills/anthro,
		/datum/customizer/organ/wings/faekin,
		/datum/customizer/organ/neck_feature/anthro,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/animal,
		/datum/customizer/organ/vagina/anthro,
		)
	descriptor_choices = list(
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin_all,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)

	languages = list(
		/datum/language/common,
	)
	stress_examine = TRUE
	stress_desc = span_red("Awful little creacher.")

/datum/species/faekin/check_roundstart_eligible()
	return TRUE

/datum/species/faekin/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/faekin/get_skin_list()
	return list(
		"Aqueous" = SKIN_COLOR_AQUEOUS,
		"Earthen" = SKIN_COLOR_EARTHEN,
		"Hewn" = SKIN_COLOR_HEWN,
		"Stormy" = SKIN_COLOR_STORMY,
		"Sizzling" = SKIN_COLOR_SIZZLING,
		"Verdant" = SKIN_COLOR_VERDANT,
		"Crackling" = SKIN_COLOR_CRACKLING,
		"Arcyne" = SKIN_COLOR_ARCYNE,
		"Envenomed" = SKIN_COLOR_ENVENOMED,
		"Chaotic" = SKIN_COLOR_CHAOTIC
	)
/datum/species/faekin/random_name(gender,unique,lastname)
	var/randname
	if(unique)
		for(var/i in 1 to 10)
			randname = pick( world.file2list("strings/rt/names/other/fairy.txt") )
			if(!findname(randname))
				break
	else
		randname = pick( world.file2list("strings/rt/names/other/fairy.txt") )
	return randname

/datum/species/faekin/after_creation(mob/living/carbon/C)
	..()
	C.voice_pitch = 2
	C.mind.AddSpell(new /obj/effect/proc_holder/spell/self/fae_flight)
	C.mind.AddSpell(new /obj/effect/proc_holder/spell/self/fae_light)

/datum/species/faekin/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(C, COMSIG_LIVING_MOBILITY_UPDATED, PROC_REF(handle_mobility_update)) //for hover animation updating
	passtable_on(C, SPECIES_TRAIT)
	C.pass_flags |= PASSMOB
	C.set_mob_offsets("fae_hover", _x = 0, _y = 3) //hovering
	C.transform = C.transform.Scale(0.5, 0.5) //fae must be small
	C.update_transform()

/datum/species/faekin/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	UnregisterSignal(C, COMSIG_LIVING_MOBILITY_UPDATED)
	passtable_off(C, SPECIES_TRAIT)
	C.pass_flags &= ~PASSMOB
	C.reset_offsets("fae_hover") //nae more hovering
	C.transform = C.transform.Scale(2, 2)
	C.update_transform()

/// Apply the hovering animation
/datum/species/faekin/proc/fairy_hover(mob/living/carbon/human/owner)
	if(!owner.resting && !owner.wallpressed)
		animate(owner, pixel_y = owner.pixel_y + 2, time = 0.5 SECONDS, loop = -1)
	sleep(0.5 SECONDS)
	if(!owner.resting && !owner.wallpressed)
		animate(owner, pixel_y = owner.pixel_y - 2, time = 0.5 SECONDS, loop = -1)

/datum/species/faekin/spec_life(mob/living/carbon/human/owner)
	. = ..()
	if(is_faekin_floating(owner))
		fairy_hover(owner)

/datum/species/faekin/proc/is_faekin_floating(mob/living/carbon/human/owner)
	return !owner.incapacitated(ignore_restraints = TRUE) && (owner.mobility_flags & MOBILITY_STAND) && !owner.buckled

/datum/species/faekin/is_floor_hazard_immune(mob/living/carbon/human/owner)
	return is_faekin_floating(owner)

/datum/species/faekin/proc/handle_mobility_update(mob/living/carbon/human/faekin) //can't hover if buckled or unable to stand
	SIGNAL_HANDLER
	if(is_faekin_floating(faekin))
		faekin.set_mob_offsets("fae_hover", _x = 0, _y = 3)
	else
		faekin.reset_offsets("fae_hover")

/obj/effect/proc_holder/spell/self/fae_flight
	name = "Take Flight"
	desc = "Take flight."
	overlay_state = "jump"
	recharge_time = 90 SECONDS
	chargetime = 5
	chargedrain = 1
	charging_slowdown = 2
	releasedrain = 30

/obj/effect/proc_holder/spell/self/fae_flight/cast(mob/living/user)
	if(!user.incapacitated(ignore_restraints = TRUE) && (user.mobility_flags & MOBILITY_STAND) && !user.buckled)
		user.apply_status_effect(/datum/status_effect/buff/fae_flight)
		return TRUE
	else
		to_chat(user, span_warning("I can't fly like this!"))
		return

/atom/movable/screen/alert/status_effect/buff/fae_flight
	name = "Flight!"
	desc = "With a buzz, I take wing!"
	icon_state = "buff"

/datum/status_effect/buff/fae_flight
	id = "faeflight"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fae_flight
	duration = 60 SECONDS

/datum/status_effect/buff/fae_flight/on_apply()
	. = ..()
	owner.visible_message(span_notice("[owner] begins to ascend!"), span_notice("You take flight..."))
	owner.mind.AddSpell(new /obj/effect/proc_holder/spell/self/fly_up)
	owner.mind.AddSpell(new /obj/effect/proc_holder/spell/self/fly_down)
	owner.movement_type = FLYING

/datum/status_effect/buff/fae_flight/on_remove()
	. = ..()
	to_chat(owner, span_warning("I can't keep flapping!"))
	owner.mind.RemoveSpell(new /obj/effect/proc_holder/spell/self/fly_up)
	owner.mind.RemoveSpell(new /obj/effect/proc_holder/spell/self/fly_down)
	owner.movement_type = GROUND
	var/turf/turf = get_turf(owner)
	if(istype(turf, /turf/open/transparent/openspace))
		turf = GET_TURF_BELOW(turf)
		owner.forceMove(turf)

/obj/effect/proc_holder/spell/self/fly_up
	name = "Fly Up"
	desc = "Take flight."
	overlay_state = "rune5"
	recharge_time = 2 SECONDS
	releasedrain = 60

/obj/effect/proc_holder/spell/self/fly_up/cast(mob/living/user)
	if(user.pulledby != null)
		to_chat(user, span_notice("I can't fly away while being grabbed!"))
		return
	user.visible_message(span_notice("[user] begins to ascend!"), span_notice("You take flight..."))
	if(do_after(user, 5))
		if(user.pulledby == null)
			user.zMove(UP, TRUE)
			to_chat(user, span_notice("I fly up."))
		else
			to_chat(user, span_notice("I can't fly away while being grabbed!"))

/obj/effect/proc_holder/spell/self/fly_down
	name = "Fly Down"
	desc = "Take flight."
	overlay_state = "rune3"
	recharge_time = 2 SECONDS
	releasedrain = 60

/obj/effect/proc_holder/spell/self/fly_down/cast(mob/living/user)
	if(user.pulledby != null)
		to_chat(user, span_notice("I can't fly away while being grabbed!"))
		return
	user.visible_message(span_notice("[user] begins to descend!"), span_notice("You take flight..."))
	if(do_after(user, 5))
		if(user.pulledby == null)
			user.zMove(DOWN, TRUE)
			to_chat(user, span_notice("I fly down."))
		else
			to_chat(user, span_notice("I can't fly away while being grabbed!"))

/obj/effect/proc_holder/spell/self/fae_light
	name = "Toggle Glow"
	desc = "Toggle glow."
	overlay_state = "createlight"
	recharge_time = 1 SECONDS
	var/fae_light_enabled = FALSE

/obj/effect/proc_holder/spell/self/fae_light/cast(mob/living/user)
	if(!fae_light_enabled)
		user.apply_status_effect(/datum/status_effect/buff/fae_light)
		fae_light_enabled = TRUE
		return TRUE
	else
		user.remove_status_effect(/datum/status_effect/buff/fae_light)
		fae_light_enabled = FALSE
		return TRUE

/datum/status_effect/buff/fae_light
	id = "faelight"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fae_light
	duration = 5 MINUTES
	examine_text = "SUBJECTPRONOUN is producing a soft glow."
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj

/atom/movable/screen/alert/status_effect/buff/fae_light
	name = "Faerie Glow"
	desc = "I'm glowing!"
	icon_state = "buff"

/datum/status_effect/buff/fae_light/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	var/light_color = H.skin_tone
	to_chat(owner, span_notice("I begin to emit a glow."))
	mob_light_obj = owner.mob_light(6, 6, _color = light_color)

/datum/status_effect/buff/fae_light/on_remove()
	. = ..()
	to_chat(owner, span_notice("I stop glowing."))
	QDEL_NULL(mob_light_obj)
