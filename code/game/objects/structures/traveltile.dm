
/obj/structure/fluff/testportal
	name = "portal"
	icon_state = "shitportal"
	icon = 'icons/roguetown/misc/structure.dmi'
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	max_integrity = 0
	var/aportalloc = "a"

/obj/structure/fluff/testportal/Initialize()
	name = aportalloc
	..()

/obj/structure/fluff/testportal/attack_hand(mob/user)
	var/fou
	for(var/obj/structure/fluff/testportal/T in shuffle(GLOB.testportals))
		if(T.aportalloc == aportalloc)
			if(T == src)
				continue
			to_chat(user, "<b>I teleport to [T].</b>")
			playsound(src, 'sound/misc/portal_enter.ogg', 100, TRUE)
			user.forceMove(T.loc)
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>There is no portal connected to this. Report it as a bugs.</b>")
	. = ..()


/obj/structure/fluff/traveltile
	name = "travel"
	icon_state = "travel"
	icon = 'icons/turf/roguefloor.dmi'
	density = FALSE
	anchored = TRUE
	layer = ABOVE_OPEN_TURF_LAYER
	max_integrity = 0
	var/aportalid = "REPLACETHIS"
	var/aportalgoesto = "REPLACETHIS"
	var/aallmig
	var/required_trait = null

/obj/structure/fluff/traveltile/Initialize()
	GLOB.traveltiles += src
	. = ..()

/obj/structure/fluff/traveltile/Destroy()
	GLOB.traveltiles -= src
	. = ..()

/obj/structure/fluff/traveltile/attack_ghost(mob/dead/observer/user)
	if(!aportalgoesto)
		return
	var/fou
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			user.forceMove(T.loc)
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>It is a dead end.</b>")

/atom/movable
	var/recent_travel = 0
//  var/last_client_interact = 0  // See mob_defines.dm.

/obj/structure/fluff/traveltile/attack_hand(mob/user)
	var/fou
	if(!aportalgoesto)
		return
	if(!isliving(user))
		return
	var/mob/living/L = user
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			if(!try_living_travel(T, L))
				return
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>It is a dead end.</b>")
	. = ..()

/obj/structure/fluff/traveltile/Crossed(atom/movable/AM)
	. = ..()
	var/fou
	if(!aportalgoesto)
		return
	if(!isliving(AM))
		return
	var/mob/living/L = AM
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			if(!try_living_travel(T, L))
				return
			fou = TRUE
			break
	if(!fou)
		to_chat(AM, "<b>It is a dead end.</b>")

/obj/structure/fluff/traveltile/proc/try_living_travel(obj/structure/fluff/traveltile/T, mob/living/L)
	if(!can_go(L))
		return FALSE
	if(L.pulledby)
		return FALSE
	if(leashed_by_other(L))
		to_chat(L, span_warning("I can't travel! Someone is holding my leash!"))
		return FALSE
	to_chat(L, "<b>I begin to travel...</b>")
	if(do_after(L, 50, needhand = FALSE, target = src))
		if(L.pulledby)
			to_chat(L, span_warning("I can't go, something's holding onto me."))
			return FALSE
		if(leashed_by_other(L))
			to_chat(L, span_warning("I can't go, somebody has me on their leash."))
			return FALSE
		perform_travel(T, L)
		return TRUE
	return FALSE

/obj/structure/fluff/traveltile/proc/perform_travel(obj/structure/fluff/traveltile/T, mob/living/L)
	if(!L.restrained(ignore_grab = TRUE)) // heavy-handedly prevents using prisoners to metagame camp locations. pulledby would stop this but prisoners can also be kicked/thrown into the tile repeatedly
		for(var/mob/living/carbon/human/H in hearers(6,src))
			if(!HAS_TRAIT(H, required_trait) && !HAS_TRAIT(H, TRAIT_BLIND))
				to_chat(H, "<b>I watch [L.name? L : "someone"] go through a well-hidden entrance.</b>")
				if(!(H.m_intent == MOVE_INTENT_SNEAK))
					to_chat(L, "<b>[H.name ? H : "Someone"] watches me pass through the entrance.</b>")
				ADD_TRAIT(H, required_trait, TRAIT_GENERIC)

	/*
	Prior to writing:
	On their own, leashes do not play nice at all with travel tile teleports. At best, they do not follow leashed "pets" to new z-levels if the leash is dropped.
	At worst, they cause the "pet" to fall to 1 z-level lower from where they previously were, and not get teleported, if the "master" isn't also pulling them by hand.
	Thus, the following jank is necessary.

	Procs for getting/checking leash stuff that I made for this got moved to leash.dm as global procs, because their code was entirely independent of this type. - Zoktiik
	*/
	var/atom/movable/pullingg = L.pulling
	var/list/master_leashed_mobs = get_master_leashed_mobs(L, FALSE)
	var/obj/item/leash/user_freepet_leash = get_freepet_leash(L)
	var/obj/item/leash/pullingg_freepet_leash
	// leashes automatically handle "reattachment" to the "master" so we can just move them

	L.recent_travel = world.time
	if(pullingg)
		pullingg_freepet_leash = get_freepet_leash(pullingg)
		if(pullingg_freepet_leash)
			pullingg_freepet_leash.forceMove(T.loc)
		pullingg.recent_travel = world.time
		pullingg.forceMove(T.loc)
	if(length(master_leashed_mobs))
		for(var/mob/living/leashed in master_leashed_mobs)
			if(leashed != pullingg) // we didn't already handle u
				leashed.recent_travel = world.time
				leashed.forceMove(T.loc)

	if(user_freepet_leash)
		user_freepet_leash.forceMove(T.loc)
	L.forceMove(T.loc)

	if(pullingg)
		L.start_pulling(pullingg, supress_message = TRUE)

	return

/obj/structure/fluff/traveltile/proc/can_go(atom/movable/AM)
	. = TRUE
	if(AM.recent_travel)
		if(world.time < AM.recent_travel + 15 SECONDS)
			. = FALSE
	if(. && required_trait && isliving(AM))
		var/mob/living/L = AM
		if(HAS_TRAIT(L, required_trait))
			if(world.time > L.last_client_interact + 0.3 SECONDS)
				return FALSE // we will only be travelling of our own volition (anti-afk-abuse)
			return TRUE
		else
			to_chat(L, "<b>It is a dead end.</b>")
			return FALSE

/obj/structure/fluff/traveltile/bandit
	required_trait = TRAIT_BANDITCAMP
/obj/structure/fluff/traveltile/vampire
	required_trait = TRAIT_VAMPMANSION
/obj/structure/fluff/traveltile/wretch
	required_trait = TRAIT_HERESIARCH //I'd tie this to trait_outlaw but unfortunately the heresiarch virtue exists so we're making a new trait instead.
/obj/structure/fluff/traveltile/dungeon
	name = "gate"
	desc = "This gate's enveloping darkness is so opressive you dread to step through it."
	icon = 'icons/roguetown/misc/portal.dmi'
	icon_state = "portal"
	density = FALSE
	anchored = TRUE
	max_integrity = 0
	bound_width = 96
	appearance_flags = NONE
	opacity = FALSE
