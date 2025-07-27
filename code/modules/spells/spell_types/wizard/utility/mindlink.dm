/obj/effect/proc_holder/spell/invoked/mindlink
	name = "Mindlink"
	desc = "Establish a telepathic link with an ally for fifteen minutes. Use ,y before a message to communicate telepathically."
	clothes_req = FALSE
	overlay_state = "mindlink"
	associated_skill = /datum/skill/magic/arcane
	cost = 4
	xp_gain = TRUE
	recharge_time = 5 MINUTES
	spell_tier = 3
	invocation = "Mens Nexu"
	invocation_type = "whisper"
	
	// Charged spell variables
	chargedloop = /datum/looping_sound/invokegen
	chargedrain = 1
	chargetime = 20
	releasedrain = 25
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	warnie = "spellwarning"
	ignore_los = TRUE

/obj/effect/proc_holder/spell/invoked/mindlink/cast(list/targets, mob/living/user)
	. = ..()
	if(!istype(user))
		return

	if(HAS_TRAIT(user, TRAIT_CHAOTIC_MIND))
		to_chat(user, span_warning("My mind is too scattered to link!"))
		revert_cast()
		return FALSE

	var/list/possible_targets = list()
	if(user.mind.known_people.len)
		for(var/people in user.mind.known_people)
			possible_targets += people
	else
		to_chat(user, span_warning("You have no known people to establish a mindlink with!"))
		revert_cast()
		return FALSE

	possible_targets = sortList(possible_targets)

	if(user.client)
		possible_targets = list(user.real_name) + possible_targets // Oohhhhhh this looks bad. But this is supposed to append ourselves at the start of the ordered list.
	
	var/first_target_name = input(user, "Choose the first person to link", "Mindlink") as null|anything in possible_targets

	if(!first_target_name)
		revert_cast()
		return FALSE

	var/mob/living/first_target

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == first_target_name)
			first_target = HL

	possible_targets -= first_target_name
	
	var/second_target_name = input(user, "Choose the second person to link", "Mindlink") as null|anything in possible_targets

	if(!second_target_name)
		revert_cast()
		return FALSE

	var/mob/living/second_target

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == second_target_name)
			second_target = HL

	// Check if either target is a zad
	if(istype(first_target, /mob/living/simple_animal/hostile/retaliate/bat/crow) || istype(second_target, /mob/living/simple_animal/hostile/retaliate/bat/crow))
		to_chat(user, span_warning("Zads are immune to mindlinks!"))
		revert_cast()
		return FALSE

	// Check if either target is a schizo
	if(HAS_TRAIT(first_target, TRAIT_CHAOTIC_MIND) || HAS_TRAIT(second_target, TRAIT_CHAOTIC_MIND))
		to_chat(user, span_warning("The minds clash! The thoughtforms don't link."))
		revert_cast()
		return FALSE

	user.visible_message(span_notice("[user] touches their temples and concentrates..."), span_notice("I establish a mental connection between [first_target] and [second_target]..."))
	
	// Create the mindlink
	var/datum/mindlink/link = new(first_target, second_target)
	GLOB.mindlinks += link
	
	to_chat(first_target, span_notice("A mindlink has been established with [second_target]! Use ,y before a message to communicate telepathically."))
	to_chat(second_target, span_notice("A mindlink has been established with [first_target]! Use ,y before a message to communicate telepathically."))
	
	// Register signals to break mindlink on zad transformation
	RegisterSignal(first_target, "pre_shapeshift", PROC_REF(break_mindlink_if_zad))
	RegisterSignal(second_target, "pre_shapeshift", PROC_REF(break_mindlink_if_zad))
	
	addtimer(CALLBACK(src, PROC_REF(break_link), link), 15 MINUTES)
	return TRUE

/obj/effect/proc_holder/spell/invoked/mindlink/proc/break_link(datum/mindlink/link)
	if(!link)
		return
	
	to_chat(link.owner, span_warning("The mindlink with [link.target] fades away..."))
	to_chat(link.target, span_warning("The mindlink with [link.owner] fades away..."))
	
	GLOB.mindlinks -= link
	qdel(link)

/obj/effect/proc_holder/spell/invoked/mindlink/proc/break_mindlink_if_zad(mob/living/shifter, new_type)
	if(new_type == /mob/living/simple_animal/hostile/retaliate/bat/crow)
		for(var/datum/mindlink/link in GLOB.mindlinks)
			if(shifter == link.owner || shifter == link.target)
				to_chat(link.owner, span_warning("The mindlink breaks as [shifter] transforms into a zad!"))
				to_chat(link.target, span_warning("The mindlink breaks as [shifter] transforms into a zad!"))
				GLOB.mindlinks -= link
				qdel(link)


