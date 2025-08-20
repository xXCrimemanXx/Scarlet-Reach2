//NOT using the existing /obj/machinery/door type, since that has some complications on its own, mainly based on its
//machineryness

/obj/structure/mineral_door
	name = "metal door"
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	layer = CLOSED_DOOR_LAYER

	icon = 'icons/roguetown/misc/doors.dmi'
	icon_state = "metal"
	max_integrity = 1000
	integrity_failure = 0.5
	CanAtmosPass = ATMOS_PASS_DENSITY

	var/ridethrough = FALSE

	var/door_opened = FALSE //if it's open or not.
	var/isSwitchingStates = FALSE //don't try to change stats if we're already opening

	var/close_delay = -1 //-1 if does not auto close.
	var/openSound = 'sound/blank.ogg'
	var/closeSound = 'sound/blank.ogg'

	var/sheetAmount = 7 //how much we drop when deconstructed

	var/windowed = FALSE
	var/base_state = null

	var/locked = FALSE
	var/last_bump = null
	var/brokenstate = 0
	var/keylock = FALSE
	var/lockhash = 0
	var/lockid = null
	var/lockbroken = 0
	var/locksound = 'sound/foley/doors/woodlock.ogg'
	var/unlocksound = 'sound/foley/doors/woodlock.ogg'
	var/rattlesound = 'sound/foley/doors/lockrattle.ogg'
	var/masterkey = TRUE //if masterkey can open this regardless
	var/kickthresh = 15
	var/swing_closed = TRUE
	var/lock_strength = 100
	var/repairable = FALSE
	var/repair_state = 0
	var/obj/item/repair_cost_first = null
	var/obj/item/repair_cost_second = null	
	var/repair_skill = null
	damage_deflection = 10
	var/mob/last_bumper = null
	var/smashable = FALSE
	/// Whether to grant a resident_key
	var/grant_resident_key = FALSE
	var/resident_key_amount = 1
	/// The type of a key the resident will get
	var/resident_key_type
	/// The required role of the resident
	var/resident_role
	/// The requied advclass of the resident
	var/list/resident_advclass


/obj/structure/mineral_door/onkick(mob/user)
	if(isSwitchingStates)
		return
	if(door_opened)
		playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
		if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
			user.visible_message(span_warning("[user] slams [src] shut with [user.p_their()] tail!"), \
				span_notice("I slam [src] shut with my tail!"))
		else
			user.visible_message(span_warning("[user] kicks [src] shut!"), \
				span_notice("I kick [src] shut!"))
		force_closed()
	else
		if(locked)
			if(isliving(user))
				var/mob/living/L = user
				if(L.STASTR >= initial(kickthresh))
					kickthresh--
				if((prob(L.STASTR * 0.5) || kickthresh == 0) && (L.STASTR >= initial(kickthresh)))
					playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
					if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
						user.visible_message(span_warning("[user] slams [src] open with [user.p_their()] tail!"), \
							span_notice("I tailslam [src] open!"))
					else
						user.visible_message(span_warning("[user] kicks open [src]!"), \
							span_notice("I kick open [src]!"))
					locked = 0
					force_open()
				else
					playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
					if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
						user.visible_message(span_warning("[user] tailslams [src]!"), \
							span_notice("I slam [src] with my tail!"))
					else
						user.visible_message(span_warning("[user] kicks [src]!"), \
							span_notice("I kick [src]!"))
			//try to kick open, destroy lock
		else
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
				user.visible_message(span_warning("[user] slams [src] open with [user.p_their()] tail!"), \
					span_notice("I tailslam [src] open!"))
			else
				user.visible_message(span_warning("[user] kicks open [src]!"), \
					span_notice("I kick open [src]!"))
			force_open()

/obj/structure/mineral_door/proc/force_open()
	isSwitchingStates = TRUE
	if(!windowed)
		set_opacity(FALSE)
	density = FALSE
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	air_update_turf(1)
	update_icon()
	isSwitchingStates = FALSE

	if(close_delay != -1)
		addtimer(CALLBACK(src, PROC_REF(Close)), close_delay)

/obj/structure/mineral_door/proc/force_closed()
	isSwitchingStates = TRUE
	if(!windowed)
		set_opacity(TRUE)
	density = TRUE
	door_opened = FALSE
	layer = CLOSED_DOOR_LAYER
	air_update_turf(1)
	update_icon()
	isSwitchingStates = FALSE

/obj/structure/mineral_door/Initialize()
	. = ..()
	if(!base_state)
		base_state = icon_state
	air_update_turf(TRUE)
	if(grant_resident_key && !lockid)
		lockid = "random_lock_id_[rand(1,9999999)]" // I know, not foolproof
	if(lockhash)
		GLOB.lockhashes += lockhash
	else if(keylock)
		if(lockid)
			if(GLOB.lockids[lockid])
				lockhash = GLOB.lockids[lockid]
			else
				lockhash = rand(1000,9999)
				while(lockhash in GLOB.lockhashes)
					lockhash = rand(1000,9999)
				GLOB.lockhashes += lockhash
				GLOB.lockids[lockid] = lockhash
		else
			lockhash = rand(1000,9999)
			while(lockhash in GLOB.lockhashes)
				lockhash = rand(1000,9999)
			GLOB.lockhashes += lockhash

/obj/structure/mineral_door/proc/try_award_resident_key(mob/user)
	if(!grant_resident_key)
		return FALSE
	if(!lockid)
		return FALSE
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/human = user
	if(human.received_resident_key)
		return FALSE
	if(resident_role)
		var/datum/job/job = SSjob.name_occupations[human.job]
		if(job.type != resident_role)
			if(!HAS_TRAIT(human, TRAIT_RESIDENT))
				return FALSE
	if(resident_advclass)
		if(!human.advjob)
			return FALSE
		var/datum/advclass/advclass = SSrole_class_handler.get_advclass_by_name(human.advjob)
		if(!advclass)
			return FALSE
		if(!(advclass.type in resident_advclass))
			return FALSE
	var/alert = alert(user, "Is this my home?", "Home", "Yes", "No")
	if(alert != "Yes")
		return
	if(!grant_resident_key)
		return
	var/spare_key = alert(user, "Have I got an extra spare key?", "Home", "Yes", "No")
	if(!grant_resident_key)
		return
	if(spare_key == "Yes")
		resident_key_amount = 2
	else
		resident_key_amount = 1
	for(var/i in 1 to resident_key_amount)
		var/obj/item/roguekey/key
		if(resident_key_type)
			key = new resident_key_type(get_turf(human))
		else
			key = new /obj/item/roguekey(get_turf(human))
		key.lockid = lockid
		key.lockhash = lockhash
		human.put_in_hands(key)
	human.received_resident_key = TRUE
	grant_resident_key = FALSE
	if(resident_key_amount > 1)
		to_chat(human, span_notice("They're just where I left them..."))
	else
		to_chat(human, span_notice("It's just where I left it..."))
	return TRUE

/obj/structure/mineral_door/Move()
	var/turf/T = loc
	. = ..()
	move_update_air(T)

/obj/structure/mineral_door/Bumped(atom/movable/AM)
	..()
	if(door_opened)
		return
	if(world.time < last_bump+20)
		return
	last_bump = world.time
	if(ismob(AM))
		var/mob/user = AM
		if(HAS_TRAIT(user, TRAIT_BASHDOORS))
			if(locked)
				user.visible_message(span_warning("[user] bashes into [src]!"))
				take_damage(200, "brute", "blunt", 1)
			else
				playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
				force_open()
				user.visible_message(span_warning("[user] smashes through [src]!"))
			return
		if(locked)
			if(istype(user.get_active_held_item(), /obj/item/roguekey) || istype(user.get_active_held_item(), /obj/item/storage/keyring))
				src.attackby(user.get_active_held_item(), user, TRUE)
				return
			door_rattle()
			return
		if(TryToSwitchState(user))
			if(swing_closed)
				if(user.m_intent == MOVE_INTENT_SNEAK)
					addtimer(CALLBACK(src, PROC_REF(Close), TRUE), 25)
				else
					addtimer(CALLBACK(src, PROC_REF(Close), FALSE), 25)


/obj/structure/mineral_door/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/mineral_door/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(brokenstate)
		return
	if(isSwitchingStates)
		return
	if(try_award_resident_key(user))
		return
	if(locked)
		if(isliving(user))
			var/mob/living/L = user
			if(L.m_intent == MOVE_INTENT_SNEAK)
				to_chat(user, span_warning("This door is locked."))
				return
		if(world.time >= last_bump+20)
			last_bump = world.time
			playsound(src, 'sound/foley/doors/knocking.ogg', 100)
			user.visible_message(span_warning("[user] knocks on [src]."), \
				span_notice("I knock on [src]."))
		return
	return TryToSwitchState(user)

/obj/structure/mineral_door/CanPass(atom/movable/mover, turf/target)
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/mineral_door/CanAStarPass(ID, to_dir, datum/caller)
	. = ..()
	if(.) // we can already go through it
		return TRUE
	if(!anchored)
		return FALSE
	if(HAS_TRAIT(caller, TRAIT_BASHDOORS))
		return TRUE // bash into it!
	// it's openable
	return ishuman(caller) && !locked // only humantype mobs can open doors, as funny as it'd be for a volf to walk in on you ERPing

/obj/structure/mineral_door/proc/TryToSwitchState(mob/living/user)
	if(!isliving(user) || isSwitchingStates || !anchored)
		return FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		// must have a client or be trying to pass through the door
		if(!human_user.client && !length(human_user.myPath))
			return FALSE
		if(human_user.handcuffed)
			return FALSE
	else if(!user.client) // simplemobs aren't allowed to pathfind through doors, currently
		return FALSE
	SwitchState(user.m_intent == MOVE_INTENT_SNEAK) // silent when sneaking
	return TRUE

/obj/structure/mineral_door/proc/SwitchState(silent = FALSE)
	if(door_opened)
		Close(silent)
	else
		Open(silent)

/obj/structure/mineral_door/proc/Open(silent = FALSE)
	isSwitchingStates = TRUE
	if(!silent)
		playsound(src, openSound, 100)
	if(!windowed)
		set_opacity(FALSE)
	flick("[base_state]opening",src)
	sleep(2)
	density = FALSE
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	air_update_turf(1)
	update_icon()
	isSwitchingStates = FALSE

	if(close_delay != -1)
		addtimer(CALLBACK(src, PROC_REF(Close)), close_delay)

/obj/structure/mineral_door/proc/Close(silent = FALSE, autobump = FALSE)
	if(isSwitchingStates || !door_opened)
		return
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		return
	isSwitchingStates = TRUE
	if(!silent)
		playsound(src, closeSound, 100)
	flick("[base_state]closing",src)
	sleep(2)
	density = TRUE
	if(!windowed)
		set_opacity(TRUE)
	door_opened = FALSE
	layer = initial(layer)
	air_update_turf(1)
	update_icon()
	isSwitchingStates = FALSE
	if(autobump && src.Adjacent(last_bumper))
		if(istype(last_bumper.get_active_held_item(), /obj/item/roguekey) || istype(last_bumper.get_active_held_item(), /obj/item/storage/keyring))
			src.attack_right(last_bumper)
	last_bumper = null

/obj/structure/mineral_door/update_icon()
	icon_state = "[base_state][door_opened ? "open":""]"

/obj/structure/mineral_door/examine(mob/user)	
	. = ..()
	if(repairable)
		var/obj/cast_repair_cost_first = repair_cost_first
		var/obj/cast_repair_cost_second = repair_cost_second
		if((repair_state == 0) && (obj_integrity < max_integrity))
			. += span_notice("A [initial(cast_repair_cost_first.name)] can be used to repair it.")
			if(brokenstate)
				. += span_notice("An additional [initial(cast_repair_cost_second.name)] is needed to finish repairs.")
		if(repair_state == 1)
			. += span_notice("An additional [initial(cast_repair_cost_second.name)] is needed to finish repairs.")



/obj/structure/mineral_door/proc/door_rattle()
	playsound(src, rattlesound, 100)
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+1, time = 0.5)
	animate(pixel_x = oldx-1, time = 0.5)
	animate(pixel_x = oldx, time = 0.5)

/obj/structure/mineral_door/attackby(obj/item/I, mob/user, autobump = FALSE)
	user.changeNext_move(CLICK_CD_FAST)
	if(istype(I, /obj/item/roguekey) || istype(I, /obj/item/storage/keyring))
		if(!locked)
			to_chat(user, span_warning("It won't turn this way. Try turning to the right."))
			door_rattle()
			return
		if(autobump == TRUE) //Attackby passes UI coordinate onclick stuff, so forcing check to TRUE
			trykeylock(I, user, autobump)
			return
		else
			trykeylock(I, user)
			return
	if(istype(I, /obj/item/lockpick))
		trypicklock(I, user)
	if(istype(I, /obj/item/melee/touch_attack/lesserknock))
		trypicklock(I, user)
	if(istype(I,/obj/item/lockpickring))
		var/obj/item/lockpickring/pickring = I
		if(pickring.picks.len)
			pickring.removefromring(user)
			to_chat(user, span_warning("You clumsily drop a lockpick off the ring as you try to pick the lock with it."))
		return
	if(istype(I, /obj/item/skeleton_key))
		tryskeletonlock(user)
	else
		if(repairable && (user.get_skill_level(repair_skill) > 0) && ((istype(I, repair_cost_first)) || (istype(I, repair_cost_second)))) // At least 1 skill level needed
			repairdoor(I,user)
		else
			return ..()

/obj/structure/mineral_door/attacked_by(obj/item/I, mob/living/user)
	..()
	if(obj_broken || obj_destroyed)
		var/obj/effect/track/structure/new_track = new(get_turf(src))
		new_track.handle_creation(user)

/obj/structure/mineral_door/proc/repairdoor(obj/item/I, mob/user)
	if(brokenstate)				
		switch(repair_state)
			if(0)					
				if(istype(I, repair_cost_first))
					user.visible_message(span_notice("[user] starts repairing [src]."), \
					span_notice("I start repairing [src]."))
					playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
					if(do_after(user, (300 / user.get_skill_level(repair_skill)), target = src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
						qdel(I)
						playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
						repair_state = 1
						var/obj/cast_repair_cost_second = repair_cost_second
						to_chat(user, span_notice("An additional [initial(cast_repair_cost_second.name)] is needed to finish the job."))				
			if(1)
				if(istype(I, repair_cost_second))
					user.visible_message(span_notice("[user] starts repairing [src]."), \
					span_notice("I start repairing [src]."))
					playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
					if(do_after(user, (300 / user.get_skill_level(repair_skill)), target = src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.	
						qdel(I)	
						playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)	
						icon_state = "[base_state]"
						density = TRUE
						opacity = TRUE
						brokenstate = FALSE
						obj_broken = FALSE
						obj_integrity = max_integrity
						repair_state = 0								
						user.visible_message(span_notice("[user] repaired [src]."), \
						span_notice("I repaired [src]."))												
	else
		if(obj_integrity < max_integrity && istype(I, repair_cost_first))
			to_chat(user, span_warning("[obj_integrity]"))	
			user.visible_message(span_notice("[user] starts repairing [src]."), \
			span_notice("I start repairing [src]."))
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			if(do_after(user, (300 / user.get_skill_level(repair_skill)), target = src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
				qdel(I)
				playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
				obj_integrity = obj_integrity + (max_integrity/2)					
				if(obj_integrity > max_integrity)
					obj_integrity = max_integrity
				user.visible_message(span_notice("[user] repaired [src]."), \
				span_notice("I repaired [src]."))		

/obj/structure/mineral_door/attack_right(mob/user)
	user.changeNext_move(CLICK_CD_FAST)
	
	// Special handling for deadbolt and shutter doors - preserve their custom behavior
	if(istype(src, /obj/structure/mineral_door/wood/deadbolt) || istype(src, /obj/structure/mineral_door/wood/deadbolt/shutter))
		return ..()
	
	// Check if user has a key in hand or belt slots
	var/obj/item/key_item = find_key_for_door(user)
	if(key_item)
		trykeylock(key_item, user)
		return
	
	// If no key found, fall back to parent behavior
	return ..()

// Helper proc to find a matching key or keyring in hand or belt slots
/obj/structure/mineral_door/proc/find_key_for_door(mob/user)
	if(!user || !keylock)
		return null
	
	// Check hand first
	var/obj/item/W = user.get_active_held_item()
	if(W && (istype(W, /obj/item/roguekey) || istype(W, /obj/item/storage/keyring)))
		if(istype(W, /obj/item/roguekey))
			var/obj/item/roguekey/K = W
			if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord))
				return W
		if(istype(W, /obj/item/storage/keyring))
			if(keyring_has_matching_key(W))
				return W
	
	// Check belt slots if human
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/list/belt_slots = list(
			H.get_item_by_slot(SLOT_BELT),
			H.get_item_by_slot(SLOT_BELT_L), 
			H.get_item_by_slot(SLOT_BELT_R)
		)
		
		for(var/obj/item/I in belt_slots)
			if(!I) continue
			
			// Check if the belt item itself is a key or keyring
			if(istype(I, /obj/item/roguekey))
				var/obj/item/roguekey/K = I
				if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord))
					return I
			if(istype(I, /obj/item/storage/keyring))
				if(keyring_has_matching_key(I))
					return I
			
			// Check inside the belt item if it has contents (storage belts, etc.)
			if(I.contents && I.contents.len)
				for(var/obj/item/contained_item in I.contents)
					if(istype(contained_item, /obj/item/roguekey))
						var/obj/item/roguekey/K = contained_item
						if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord))
							return I // Return the belt item that contains the key
					if(istype(contained_item, /obj/item/storage/keyring))
						if(keyring_has_matching_key(contained_item))
							return I // Return the belt item that contains the keyring
	
	return null

// Helper proc to check if a keyring contains a matching key
/obj/structure/mineral_door/proc/keyring_has_matching_key(obj/item/storage/keyring/keyring)
	if(!keyring || !istype(keyring, /obj/item/storage/keyring))
		return FALSE
	
	for(var/obj/item/I in keyring.contents)
		if(istype(I, /obj/item/roguekey))
			var/obj/item/roguekey/K = I
			if(K.lockhash == lockhash)
				return TRUE
		if(istype(I, /obj/item/storage/keyring))
			if(keyring_has_matching_key(I))
				return TRUE
	
	return FALSE

/obj/structure/mineral_door/proc/trykeylock(obj/item/I, mob/user, autobump = FALSE)
	if(door_opened || isSwitchingStates)
		return
	if(!keylock)
		return
	if(lockbroken)
		to_chat(user, span_warning("The lock to this door is broken."))
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(istype(I,/obj/item/storage/keyring))
		var/obj/item/storage/keyring/R = I
		if(!R.contents.len)
			return
		var/list/keysy = shuffle(R.contents.Copy())
		for(var/obj/item/roguekey/K in keysy)
			if(user.cmode)
				if(!do_after(user, 10, TRUE, src))
					break
			if(K.lockhash == lockhash)
				lock_toggle(user)
				if(autobump && !locked)
					src.Open()
					addtimer(CALLBACK(src, PROC_REF(Close), FALSE, TRUE), 25)
					src.last_bumper = user
				return
			else
				if(user.cmode)
					door_rattle()
		to_chat(user, span_warning("None of the keys on my keyring go to this door."))
		door_rattle()
		return
	else
		var/obj/item/roguekey/K = I
		if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord)) //master key cares not for lockhashes
			lock_toggle(user)
			if(autobump)
				src.Open()
				addtimer(CALLBACK(src, PROC_REF(Close), FALSE, TRUE), 25)
				src.last_bumper = user
			return
		else
			to_chat(user, span_warning("This is not the correct key that goes to this door."))
			door_rattle()
		return

/obj/structure/mineral_door/proc/trypicklock(obj/item/I, mob/user)
	if(door_opened || isSwitchingStates)
		to_chat(user, "<span class='warning'>This cannot be picked while it is open.</span>")
		return
	if(!keylock)
		return
	if(lockbroken)
		to_chat(user, "<span class='warning'>The lock to this door is broken.</span>")
		user.changeNext_move(CLICK_CD_INTENTCAP)
	else
		var/lockprogress = 0
		var/locktreshold = lock_strength

		var/obj/item/lockpick/P = I
		var/mob/living/L = user

		var/pickskill = user.get_skill_level(/datum/skill/misc/lockpicking)
		var/perbonus = L.STAPER/5
		var/picktime = 70
		var/pickchance = 35
		var/moveup = 10

		picktime -= (pickskill * 10)
		picktime = clamp(picktime, 10, 70)

		moveup += (pickskill * 3)
		moveup = clamp(moveup, 10, 30)

		pickchance += pickskill * 10
		pickchance += perbonus
		pickchance *= P.picklvl
		pickchance = clamp(pickchance, 1, 95)

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			message_admins("[H.real_name]([key_name(user)]) is attempting to lockpick [src.name]. [ADMIN_JMP(src)]")
			log_admin("[H.real_name]([key_name(user)]) is attempting to lockpick [src.name].")

		while(!QDELETED(I) &&(lockprogress < locktreshold))
			if(!do_after(user, picktime, target = src))
				break
			if(prob(pickchance))
				lockprogress += moveup
				playsound(src.loc, pick('sound/items/pickgood1.ogg','sound/items/pickgood2.ogg'), 5, TRUE)
				to_chat(user, "<span class='warning'>Click...</span>")
				if(L.mind)
					add_sleep_experience(L, /datum/skill/misc/lockpicking, L.STAINT/2)
				if(lockprogress >= locktreshold)
					to_chat(user, "<span class='deadsay'>The locking mechanism gives.</span>")
					if(ishuman(user))
						var/mob/living/carbon/human/H = user
						message_admins("[H.real_name]([key_name(user)]) successfully lockpicked [src.name] & [locked ? "unlocked" : "locked"] it. [ADMIN_JMP(src)]")
						log_admin("[H.real_name]([key_name(user)]) successfully lockpicked [src.name].")
						record_featured_stat(FEATURED_STATS_CRIMINALS, user)
						GLOB.scarlet_round_stats[STATS_LOCKS_PICKED]++
						var/obj/effect/track/structure/new_track = new(get_turf(src))
						new_track.handle_creation(user)
					lock_toggle(user)
					break
				else
					continue
			else
				playsound(loc, 'sound/items/pickbad.ogg', 40, TRUE)
				I.take_damage(1, BRUTE, "blunt")
				to_chat(user, "<span class='warning'>Clack.</span>")
				add_sleep_experience(L, /datum/skill/misc/lockpicking, L.STAINT/4)
				continue
		return

/obj/structure/mineral_door/proc/tryskeletonlock(mob/user)
	if(door_opened || isSwitchingStates)
		return
	if(!keylock)
		return
	if(lockbroken)
		to_chat(user, span_warning("The lock to this door is broken."))
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		message_admins("[H.real_name]([key_name(user)]) successfully skeletonkey'd [src.name] & [locked ? "unlocked" : "locked"] it. [ADMIN_JMP(src)]")
		log_admin("[H.real_name]([key_name(user)]) successfully used a skeleton key on [src.name].")
	do_sparks(3, FALSE, src)
	playsound(user, 'sound/items/skeleton_key.ogg', 100)
	lock_toggle(user) //All That It Does.
	user.changeNext_move(CLICK_CD_INTENTCAP)
	return

/obj/structure/mineral_door/proc/lock_toggle(mob/user)
	if(isSwitchingStates || door_opened)
		return
	if(locked)
		user.visible_message(span_warning("[user] unlocks [src]."), \
			span_notice("I unlock [src]."))
		playsound(src, unlocksound, 100)
		locked = 0
	else
		user.visible_message(span_warning("[user] locks [src]."), \
			span_notice("I lock [src]."))
		playsound(src, locksound, 100)
		locked = 1

/obj/structure/mineral_door/setAnchored(anchorvalue) //called in default_unfasten_wrench() chain
	. = ..()
	set_opacity(anchored ? !door_opened : FALSE)
	air_update_turf(TRUE)

/obj/structure/mineral_door/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 40)
	return TRUE


/obj/structure/mineral_door/obj_break(damage_flag, mapload)
	if(!brokenstate)
		icon_state = "[base_state]br"
		density = FALSE
		opacity = FALSE
		brokenstate = TRUE
	..()

/obj/structure/mineral_door/OnCrafted(dirin, user)
	. = ..()
	keylock = FALSE
	GLOB.lockhashes.Remove(lockhash)
	lockhash = 0

/////////////////////// TOOL OVERRIDES ///////////////////////


/obj/structure/mineral_door/proc/pickaxe_door(mob/living/user, obj/item/I) //override if the door isn't supposed to be a minable mineral.
	return/*
	if(!istype(user))
		return
	if(I.tool_behaviour != TOOL_MINING)
		return
	. = TRUE
	to_chat(user, span_notice("I start digging [src]..."))
	if(I.use_tool(src, user, 40, volume=50))
		to_chat(user, span_notice("I finish digging."))
		deconstruct(TRUE)*/

/obj/structure/mineral_door/welder_act(mob/living/user, obj/item/I) //override if the door is supposed to be flammable.
	..()
	. = TRUE
	if(anchored)
		to_chat(user, span_warning("[src] is still firmly secured to the ground!"))
		return

	user.visible_message(span_notice("[user] starts to weld apart [src]!"), span_notice("I start welding apart [src]."))
	if(!I.use_tool(src, user, 60, 5, 50))
		to_chat(user, span_warning("I failed to weld apart [src]!"))
		return

	user.visible_message(span_notice("[user] welded [src] into pieces!"), span_notice("I welded apart [src]!"))
	deconstruct(TRUE)

/obj/structure/mineral_door/proc/crowbar_door(mob/living/user, obj/item/I) //if the door is flammable, call this in crowbar_act() so we can still decon it
	. = TRUE
	if(anchored)
		to_chat(user, span_warning("[src] is still firmly secured to the ground!"))
		return

	user.visible_message(span_notice("[user] starts to pry apart [src]!"), span_notice("I start prying apart [src]."))
	if(!I.use_tool(src, user, 60, volume = 50))
		to_chat(user, span_warning("I failed to pry apart [src]!"))
		return

	user.visible_message(span_notice("[user] pried [src] into pieces!"), span_notice("I pried apart [src]!"))
	deconstruct(TRUE)

//ROGUEDOOR

/obj/structure/mineral_door/wood
	name = "door"
	desc = ""
	icon_state = "woodhandle"
	openSound = 'sound/foley/doors/creak.ogg'
	closeSound = 'sound/foley/doors/shut.ogg'
	resistance_flags = FLAMMABLE
	max_integrity = 1000
	damage_deflection = 12
	layer = ABOVE_MOB_LAYER
	keylock = TRUE
	icon = 'icons/roguetown/misc/doors.dmi'
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	var/over_state = "woodover"
	repairable = TRUE
	repair_cost_first = /obj/item/grown/log/tree/small
	repair_cost_second = /obj/item/grown/log/tree/small	
	repair_skill = /datum/skill/craft/carpentry
	smashable = TRUE

/obj/structure/mineral_door/wood/Initialize()
	if(icon_state =="woodhandle")
		if(icon_state != "wcv")
			if(prob(10))
				icon_state = "wcg"
			else if(prob(10))
				icon_state = "wcr"
	if(over_state)
		add_overlay(mutable_appearance(icon, "[over_state]", ABOVE_MOB_LAYER))
	..()

/obj/structure/mineral_door/wood/blue
	icon_state = "wcb"
/obj/structure/mineral_door/wood/red
	icon_state = "wcr"
/obj/structure/mineral_door/wood/violet
	icon_state = "wcv"


/obj/structure/mineral_door/obj_break(damage_flag)
	loud_message("A loud crash of door splinters echoes", hearing_distance = 14)
	. = ..()

/obj/structure/mineral_door/wood/pickaxe_door(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/wood/welder_act(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/wood/crowbar_act(mob/living/user, obj/item/I)
	return crowbar_door(user, I)

/obj/structure/mineral_door/wood/attackby(obj/item/I, mob/living/user)
	return ..()

/obj/structure/mineral_door/wood/fire_act(added, maxstacks)
	testing("added [added]")
	if(!added)
		return FALSE
	if(added < 10)
		return FALSE
	..()

/obj/structure/mineral_door/swing_door
	name = "swing door"
	desc = "A door that swings."
	icon_state = "woodhandle"
	openSound = 'sound/foley/doors/creak.ogg'
	closeSound = 'sound/foley/doors/shut.ogg'
	resistance_flags = FLAMMABLE
	max_integrity = 500
	damage_deflection = 12
	layer = ABOVE_MOB_LAYER
	opacity = FALSE
	windowed = TRUE
	keylock = FALSE
	icon = 'icons/roguetown/misc/doors.dmi'
	icon_state = "swing"
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	repairable = TRUE
	repair_cost_first = /obj/item/grown/log/tree/small
	repair_cost_second = /obj/item/grown/log/tree/small	
	repair_skill = /datum/skill/craft/carpentry
	ridethrough = TRUE
	smashable = TRUE

/obj/structure/mineral_door/wood/window
	opacity = FALSE
	icon_state = "woodwindow"
	windowed = TRUE
	desc = ""
	over_state = "woodwindowopen"
	smashable = TRUE

/obj/structure/mineral_door/wood/fancywood
	icon_state = "fancy_wood"
	desc = ""
	over_state = "fancy_woodopen"
	smashable = TRUE

/obj/structure/mineral_door/wood/deadbolt
	desc = "This door comes with a deadbolt."
	icon_state = "wooddir"
	base_state = "wood"
	var/lockdir
	keylock = FALSE
	max_integrity = 1000
	over_state = "woodopen"
	kickthresh = 10
	openSound = 'sound/foley/doors/shittyopen.ogg'
	closeSound = 'sound/foley/doors/shittyclose.ogg'
	smashable = TRUE

/obj/structure/mineral_door/wood/deadbolt/OnCrafted(dirin)
	dir = turn(dirin, 180)
	lockdir = dir

/obj/structure/mineral_door/wood/deadbolt/Initialize()
	. = ..()
	lockdir = dir
	icon_state = base_state

/obj/structure/mineral_door/wood/deadbolt/attack_right(mob/user)
	user.changeNext_move(CLICK_CD_FAST)
	
	// If keylock is disabled, implement manual locking behavior
	if(!keylock)
		if(get_dir(src,user) == lockdir)
			if(brokenstate)
				to_chat(user, span_warning("It's broken, that would be foolish."))
				return
			lock_toggle(user)
		else
			to_chat(user, span_warning("The deadbolt doesn't toggle from this side."))
		return
	
	var/obj/item = user.get_active_held_item()
	var/obj/item/roguekey/found_key = null
	var/obj/item/storage/keyring/found_keyring = null

	// Check held item first
	if(istype(item, /obj/item/roguekey))
		found_key = item
	else if(istype(item, /obj/item/storage/keyring))
		found_keyring = item

	// If no key in hand, check all storage items
	if(!found_key && !found_keyring)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/list/checked_items = list()
			var/list/to_check = H.get_all_slots()
			
			while(to_check.len)
				var/obj/item/I = to_check[1]
				to_check -= I
				if(I in checked_items)
					continue
				checked_items += I
				
				if(istype(I, /obj/item/roguekey))
					var/obj/item/roguekey/K = I
					if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord))
						found_key = K
						break
				if(istype(I, /obj/item/storage/keyring))
					var/obj/item/storage/keyring/R = I
					for(var/obj/item/roguekey/K in R.contents)
						if(K.lockhash == lockhash || istype(K, /obj/item/roguekey/lord))
							found_keyring = R
							break
					if(found_keyring)
						break
				if(istype(I, /obj/item/storage))
					var/obj/item/storage/S = I
					to_check += S.contents

	if(found_key || found_keyring)
		if(door_opened || isSwitchingStates)
			return ..()
		if(lockbroken)
			to_chat(user, span_warning("The lock to this door is broken."))
			return
		trykeylock(found_key || found_keyring, user)
	else
		to_chat(user, span_warning("I don't have the right key for this door."))
		return

/obj/structure/mineral_door/wood/donjon
	desc = "A solid metal door with a slot to peek through."
	icon_state = "donjondir"
	base_state = "donjon"
	keylock = TRUE
	max_integrity = 2000
	over_state = "dunjonopen"
	var/viewportdir
	kickthresh = 15
	locksound = 'sound/foley/doors/lockmetal.ogg'
	unlocksound = 'sound/foley/doors/lockmetal.ogg'
	rattlesound = 'sound/foley/doors/lockrattlemetal.ogg'
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	lock_strength = 200
	repair_cost_second = /obj/item/ingot/iron
	repair_skill = /datum/skill/craft/carpentry

/obj/structure/mineral_door/wood/donjon/stone
	desc = "stone door"
	icon_state = "stone"
	base_state = "stone"
	keylock = TRUE
	max_integrity = 1500
	over_state = "stoneopen"
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	repair_cost_first = /obj/item/natural/stone
	repair_cost_second = /obj/item/natural/stone
	repair_skill = /datum/skill/craft/masonry

/obj/structure/mineral_door/wood/donjon/stone/broken // no repair
	icon_state = "stonebr"
	base_state = "stone"
	density = 0
	opacity = 0
	obj_integrity = 0
	gc_destroyed = 1
	brokenstate = 1
	obj_broken = 1

/obj/structure/mineral_door/wood/donjon/stone/attack_right(mob/user)
	// Check for keys first (inherited from parent)
	var/obj/item/key_item = find_key_for_door(user)
	if(key_item)
		trykeylock(key_item, user)
		return
	
	// If no key, fall back to parent behavior
	if(user.get_active_held_item())
		return ..()

/obj/structure/mineral_door/wood/donjon/stone/view_toggle(mob/user)
	return

/obj/structure/mineral_door/wood/donjon/stone/MiddleClick(mob/user, params)
	if(user.get_active_held_item())
		return ..()
	if(door_opened || isSwitchingStates)
		return
	if(brokenstate)
		to_chat(user, span_warning("There isn't much left of this door."))
		return
	if(get_dir(src,user) == viewportdir)
		view_toggle(user)
	else
		to_chat(user, span_warning("The viewport doesn't toggle from this side."))
		return

/obj/structure/mineral_door/wood/donjon/Initialize()
	viewportdir = dir
	icon_state = base_state
	..()

/obj/structure/mineral_door/wood/donjon/MiddleClick(mob/user, params)
	if(user.get_active_held_item())
		return ..()

	if(door_opened || isSwitchingStates)
		return
	if(brokenstate)
		to_chat(user, span_warning("There isn't much left of this door."))
		return
	if(get_dir(src,user) == viewportdir)
		view_toggle(user)
	else
		to_chat(user, span_warning("The viewport doesn't toggle from this side."))
		return

/obj/structure/mineral_door/wood/donjon/proc/view_toggle(mob/user)
	if(door_opened)
		return
	if(opacity)
		to_chat(user, span_info("I slide the viewport open."))
		opacity = FALSE
		playsound(src, 'sound/foley/doors/windowup.ogg', 100, FALSE)
	else
		to_chat(user, span_info("I slide the viewport closed."))
		opacity = TRUE
		playsound(src, 'sound/foley/doors/windowup.ogg', 100, FALSE)


/obj/structure/mineral_door/bars
	name = "iron door"
	desc = ""
	icon_state = "bars"
	openSound = 'sound/foley/doors/ironopen.ogg'
	closeSound = 'sound/foley/doors/ironclose.ogg'
	resistance_flags = null
	max_integrity = 2000
	damage_deflection = 15
	layer = ABOVE_MOB_LAYER
	keylock = TRUE
	icon = 'icons/roguetown/misc/doors.dmi'
	blade_dulling = DULLING_BASH
	opacity = FALSE
	windowed = TRUE
	locksound = 'sound/foley/doors/lock.ogg'
	unlocksound = 'sound/foley/doors/unlock.ogg'
	rattlesound = 'sound/foley/doors/lockrattlemetal.ogg'
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	ridethrough = TRUE
	swing_closed = FALSE
	lock_strength = 150
	repairable = TRUE
	repair_cost_first = /obj/item/ingot/iron
	repair_cost_second = /obj/item/ingot/iron
	repair_skill = /datum/skill/craft/blacksmithing
	
/obj/structure/mineral_door/barsold
	name = "iron door"
	desc = ""
	icon_state = "barsold"

/obj/structure/mineral_door/bars/Initialize()
	. = ..()
	add_overlay(mutable_appearance(icon, "barsopen", ABOVE_MOB_LAYER))


/obj/structure/mineral_door/bars/onkick(mob/user)
	if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
		user.visible_message(span_warning("[user] tailslams [src]!"))
	else
		user.visible_message(span_warning("[user] kicks [src]!"))
	return


/obj/structure/mineral_door/wood/deadbolt/shutter
	name = "serving hatch"
	desc = "Can be locked from the inside."
	icon_state = "serving"
	base_state = "serving"
	max_integrity = 250
	over_state = "servingopen"
	openSound = 'modular/Neu_Food/sound/blindsopen.ogg'
	closeSound = 'modular/Neu_Food/sound/blindsclose.ogg'
	dir = NORTH
	locked = TRUE

/obj/structure/mineral_door/wood/towner
	locked = TRUE
	keylock = TRUE
	grant_resident_key = TRUE
	resident_key_type = /obj/item/roguekey/townie
	resident_role = /datum/job/roguetown/villager
	lockid = null //Will be randomized

/obj/structure/mineral_door/wood/towner/generic

/obj/structure/mineral_door/wood/towner/generic/two_keys
	resident_key_amount = 2

/obj/structure/mineral_door/wood/towner/blacksmith
	resident_advclass = list(/datum/advclass/blacksmith)
	lockid = "towner_blacksmith"

/obj/structure/mineral_door/wood/towner/cheesemaker
	resident_advclass = list(/datum/advclass/cheesemaker)
	lockid = "towner_cheesemaker"

/obj/structure/mineral_door/wood/towner/miner
	resident_advclass = list(/datum/advclass/miner)
	lockid = "towner_miner"

/obj/structure/mineral_door/wood/towner/seamstress
	resident_advclass = list(/datum/advclass/seamstress)
	lockid = "towner_seamstress"

/obj/structure/mineral_door/wood/towner/woodcutter
	resident_advclass = list(/datum/advclass/woodcutter)
	lockid = "towner_woodcutter"

/obj/structure/mineral_door/wood/towner/fisher
	resident_advclass = list(/datum/advclass/fisher)
	lockid = "towner_fisher"

/obj/structure/mineral_door/wood/towner/hunter
	resident_advclass = list(/datum/advclass/hunter)
	lockid = "towner_hunter"

/obj/structure/mineral_door/wood/towner/witch
	resident_advclass = list(/datum/advclass/witch)
	lockid = "towner_witch"

/obj/structure/mineral_door/wood/bath
	locked = TRUE
	keylock = TRUE
	grant_resident_key = TRUE
	resident_key_type = /obj/item/roguekey/bath
	resident_role = /datum/job/roguetown/nightmaiden
	lockid = null //Will be randomized

/obj/structure/mineral_door/wood/bath/bathmaid
	icon_state = "woodwindow"
	resident_advclass = list(/datum/advclass/nightmaiden)

/obj/structure/mineral_door/wood/bath/courtesan
	resident_advclass = list(/datum/advclass/nightmaiden/concubine, /datum/advclass/nightmaiden/courtesan)
