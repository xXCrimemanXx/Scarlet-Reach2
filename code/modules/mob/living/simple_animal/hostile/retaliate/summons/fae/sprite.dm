/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "sprite"
	icon_state = "sprite"
	icon_living = "sprite"
	icon_dead = "vvd"
	summon_primer = "You are a sprite, a small fae. You spend time wandering the wilds. Now you've been pulled from your home into a new world, that is decidedly less wild and natural. How you react to these events, only time can tell."
	summon_tier = 1
	gender = FEMALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/unarmed/claw)
	butcher_results = list()
	faction = list("fae")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 50
	maxHealth = 50
	ranged = FALSE
	melee_damage_lower = 10
	melee_damage_upper = 20
	vision_range = 8
	aggro_vision_range = 11
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	retreat_distance = 3
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STAEND = 6
	STACON = 6
	STASTR = 2
	STASPD = 17
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = 'sound/combat/hits/bladed/smallslash (1).ogg'
	attack_verb_continuous = "jabs"
	attack_verb_simple = "jab"
	dodgetime = 60
	aggressive = 1
	var/drug_cd


/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite/Initialize()
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite/death(gibbed)
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	update_icon()
	sleep(1)
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return
