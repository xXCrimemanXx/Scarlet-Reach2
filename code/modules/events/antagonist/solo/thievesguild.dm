/datum/round_event_control/antagonist/solo/thievesguild
	name = "Thieves' Guild"
	tags = list(
		TAG_VILLIAN,
		TAG_LOOT
	)
	roundstart = TRUE
	antag_flag = ROLE_THIEVESGUILD
	shared_occurence_type = SHARED_MINOR_THREAT

	// Only allow adventurers to be Thieves' Guild members
	needed_job = list("Adventurer")

	// Restrict from important roles
	restricted_roles = list(
		"Grand Duke",
		"Grand Duchess",
		"Consort",
		"Dungeoneer",
		"Sergeant",
		"Men-at-arms",
		"Marshal",
		"Merchant",
		"Priest",
		"Acolyte",
		"Martyr",
		"Templar",
		"Councillor",
		"Prince",
		"Princess",
		"Hand",
		"Steward",
		"Court Physician",
		"Town Elder",
		"Captain",
		"Archivist",
		"Knight",
		"Court Magician",
		"Inquisitor",
		"Orthodoxist",
		"Warden",
		"Squire",
		"Veteran",
		"Apothecary"
	)

	base_antags = 1
	maximum_antags = 5

	earliest_start = 0 SECONDS

	weight = 1000 // Set very high for testing

	min_players = 0 // Allow testing with any population

	typepath = /datum/round_event/antagonist/solo/thievesguild
	antag_datum = /datum/antagonist/thievesguild

/datum/round_event_control/antagonist/solo/thievesguild/canSpawnEvent(players_amt, gamemode, fake_check)
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild canSpawnEvent() called with players_amt: [players_amt]</span>")
	
	// Check each base condition individually
	if(SSgamemode.current_storyteller?.disable_distribution || SSgamemode.halted_storyteller)
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild - Storyteller disabled or halted</span>")
		return FALSE
	
	if(event_group && !GLOB.event_groups[event_group].can_run())
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild - Event group cannot run</span>")
		return FALSE
	
	if(roundstart && (!SSgamemode.can_run_roundstart || (SSgamemode.ran_roundstart && !fake_check && !SSgamemode.current_storyteller?.ignores_roundstart)))
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild - Roundstart conditions failed</span>")
		return FALSE
	
	if(occurrences >= max_occurrences)
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild - Max occurrences reached</span>")
		return FALSE
	
	if(earliest_start >= world.time-SSticker.round_start_time)
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild - Too soon to start</span>")
		return FALSE
	
	if(wizardevent != SSevents.wizardmode)
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild - Wizard mode mismatch</span>")
		return FALSE
	
	if(players_amt < min_players)
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild - Not enough players (need [min_players], have [players_amt])</span>")
		return FALSE
	
	if(length(todreq) && !(GLOB.tod in todreq))
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild - Time of day requirement not met</span>")
		return FALSE
	
	if(length(allowed_storytellers))
		if(!(SSgamemode.current_storyteller.type in allowed_storytellers))
			to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild - Wrong storyteller</span>")
			return FALSE
	
	if(req_omen)
		if(!GLOB.badomens.len)
			to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild - No bad omens</span>")
			return FALSE
	
	if(!name)
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild - No name</span>")
		return FALSE
	
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild - All base checks passed</span>")
	
	var/antag_amt = get_antag_amount()
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild antag_amt: [antag_amt]</span>")
	
	var/list/candidates = get_candidates()
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild candidates found: [candidates.len]</span>")
	
	if(length(candidates) < antag_amt)
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild canSpawnEvent() failed - not enough candidates</span>")
		return FALSE
	
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild canSpawnEvent() returning TRUE</span>")
	return TRUE

/datum/round_event_control/antagonist/solo/thievesguild/get_candidates()
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild get_candidates() called</span>")
	var/list/candidates = ..()
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild get_candidates() returned [candidates.len] candidates</span>")
	return candidates

/datum/round_event/antagonist/solo/thievesguild
	var/leader = FALSE

/datum/round_event/antagonist/solo/thievesguild/setup()
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild setup() called</span>")
	
	var/datum/round_event_control/antagonist/solo/cast_control = control
	antag_count = cast_control.get_antag_amount()
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild antag_count: [antag_count]</span>")
	
	antag_flag = cast_control.antag_flag
	antag_datum = cast_control.antag_datum
	restricted_roles = cast_control.restricted_roles
	prompted_picking = cast_control.prompted_picking
	
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild antag_flag: [antag_flag]</span>")
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild antag_datum: [antag_datum]</span>")
	
	var/list/possible_candidates = cast_control.get_candidates()
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild possible_candidates: [possible_candidates.len]</span>")
	
	var/list/candidates = list()
	if(cast_control == SSgamemode.current_roundstart_event && length(SSgamemode.roundstart_antag_minds))
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild using roundstart_antag_minds</span>")
		log_storyteller("Running roundstart antagonist assignment, event: [src], roundstart_antag_minds: [english_list(SSgamemode.roundstart_antag_minds)]")
		for(var/datum/mind/antag_mind in SSgamemode.roundstart_antag_minds)
			if(!antag_mind.current)
				log_storyteller("Roundstart antagonist setup error: antag_mind([antag_mind]) in roundstart_antag_minds without a set mob")
				continue
			candidates += antag_mind.current
			SSgamemode.roundstart_antag_minds -= antag_mind
			log_storyteller("Roundstart antag_mind, [antag_mind]")

	//guh
	var/list/cliented_list = list()
	for(var/mob/living/mob as anything in possible_candidates)
		cliented_list += mob.client

	while(length(possible_candidates) && length(candidates) < antag_count) //both of these pick_n_take from weighted_candidates so this should be fine
		var/mob/picked_ckey = pick_n_take(possible_candidates)
		var/client/picked_client = picked_ckey.client
		if(QDELETED(picked_client))
			continue
		var/mob/picked_mob = picked_client.mob
		picked_mob?.mind?.picking = TRUE
		log_storyteller("Picked antag event mob: [picked_mob], special role: [picked_mob.mind?.special_role ? picked_mob.mind.special_role : "none"]")
		candidates |= picked_mob

	var/list/picked_mobs = list()
	for(var/i in 1 to antag_count)
		if(!length(candidates))
			message_admins("A roleset event got fewer antags then its antag_count and may not function correctly.")
			break

		var/mob/candidate = pick_n_take(candidates)
		log_storyteller("Antag event spawned mob: [candidate], special role: [candidate.mind?.special_role ? candidate.mind.special_role : "none"]")

		if(!candidate.mind)
			candidate.mind = new /datum/mind(candidate.key)

		setup_minds += candidate.mind
		candidate.mind.special_role = antag_flag
		candidate.mind.restricted_roles = restricted_roles
		picked_mobs += WEAKREF(candidate.client)

	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild setup_minds: [setup_minds.len]</span>")
	
	setup = TRUE
	if(LAZYLEN(extra_spawned_events))
		var/event_type = pickweight(extra_spawned_events)
		if(!event_type)
			return
		var/datum/round_event_control/triggered_event = locate(event_type) in SSgamemode.control
		//wait a second to avoid any potential omnitraitor bs
		addtimer(CALLBACK(triggered_event, TYPE_PROC_REF(/datum/round_event_control, runEvent), FALSE), 1 SECONDS)

/datum/round_event/antagonist/solo/thievesguild/start()
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild event start() called! setup_minds: [setup_minds.len]</span>")
	
	// Check if we have any candidates
	if(!setup_minds || !setup_minds.len)
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> No candidates found for Thieves' Guild assignment.</span>")
		return
	
	// Check if the antagonist datum is valid
	if(!antag_datum)
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> No antag_datum defined!</span>")
		return
	
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Antag datum type: [antag_datum]</span>")
	
	for(var/datum/mind/antag_mind as anything in setup_minds)
		var/name = antag_mind.current?.real_name || antag_mind.key || "(no mob)"
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Attempting to assign Thieves' Guild to [name]</span>")
		
		// Check if the mind already has this antagonist
		if(antag_mind.has_antag_datum(antag_datum))
			to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> [name] already has Thieves' Guild antagonist datum</span>")
			continue
		
		// Check if the antagonist can be owned by this mind
		var/datum/antagonist/test_antag = new antag_datum()
		if(!test_antag.can_be_owned(antag_mind))
			to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> [name] cannot be owned by Thieves' Guild antagonist</span>")
			qdel(test_antag)
			continue
		qdel(test_antag)
		
		// Attempt to add the antagonist datum
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Calling add_antag_datum directly with antag_datum: [antag_datum]</span>")
		var/datum/antagonist/result = antag_mind.add_antag_datum(antag_datum)
		if(result)
			to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Successfully assigned Thieves' Guild to [name] - result type: [result.type]</span>")
		else
			to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> FAILED to assign Thieves' Guild to [name] - add_antag_datum returned null</span>") 
