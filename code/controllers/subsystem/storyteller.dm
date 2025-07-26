#define INIT_ORDER_GAMEMODE 70
///how many storytellers can be voted for along with always_votable ones
#define DEFAULT_STORYTELLER_VOTE_OPTIONS 4
///amount of players we can have before no longer running votes for storyteller
#define MAX_POP_FOR_STORYTELLER_VOTE 25
///the duration into the round for which roundstart events are still valid to run
#define ROUNDSTART_VALID_TIMEFRAME 3 MINUTES

SUBSYSTEM_DEF(gamemode)
	name = "Gamemode"
	init_order = INIT_ORDER_GAMEMODE
	runlevels = RUNLEVEL_GAME
	flags = SS_BACKGROUND | SS_KEEP_TIMING
	priority = 20
	wait = 2 SECONDS
	lazy_load = FALSE

	///world.time of our last devotion check we add 2 minutes to this to determine if we should switch storytellers
	var/last_devotion_check = 0

	/// List of our event tracks for fast access during for loops.
	var/list/event_tracks = EVENT_TRACKS
	/// Our storyteller. They progresses our trackboards and picks out events
	var/datum/storyteller/current_storyteller
	/// Result of the storyteller vote/pick. Defaults to Astrata.
	var/selected_storyteller = /datum/storyteller/astrata
	/// List of all the storytellers. Populated at init. Associative from type
	var/list/storytellers = list()
	/// Next process for our storyteller. The wait time is STORYTELLER_WAIT_TIME
	var/next_storyteller_process = 0
	/// Associative list of even track points.
	var/list/event_track_points = list(
		EVENT_TRACK_MUNDANE = 0,
		EVENT_TRACK_PERSONAL = 0,
		EVENT_TRACK_MODERATE = 0,
		EVENT_TRACK_INTERVENTION = 0,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 0,
		EVENT_TRACK_RAIDS = 0,
		)
	/// Last point amount gained of each track. Those are recorded for purposes of estimating how long until next event.
	var/list/last_point_gains = list(
		EVENT_TRACK_MUNDANE = 0,
		EVENT_TRACK_PERSONAL = 0,
		EVENT_TRACK_MODERATE = 0,
		EVENT_TRACK_INTERVENTION = 0,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 0,
		EVENT_TRACK_RAIDS = 0,
		)
	/// Point thresholds at which the events are supposed to be rolled, it is also the base cost for events.
	var/list/point_thresholds = list(
		EVENT_TRACK_MUNDANE = MUNDANE_POINT_THRESHOLD,
		EVENT_TRACK_PERSONAL = MUNDANE_POINT_THRESHOLD,
		EVENT_TRACK_MODERATE = MODERATE_POINT_THRESHOLD,
		EVENT_TRACK_INTERVENTION = MAJOR_POINT_THRESHOLD,
		EVENT_TRACK_CHARACTER_INJECTION = ROLESET_POINT_THRESHOLD,
		EVENT_TRACK_OMENS = OBJECTIVES_POINT_THRESHOLD,
		EVENT_TRACK_RAIDS = OBJECTIVES_POINT_THRESHOLD * 2,
		)

	/// Minimum population thresholds for the tracks to fire off events.
	var/list/min_pop_thresholds = list(
		EVENT_TRACK_MUNDANE = MUNDANE_MIN_POP,
		EVENT_TRACK_PERSONAL = MODERATE_MIN_POP,
		EVENT_TRACK_MODERATE = MODERATE_MIN_POP,
		EVENT_TRACK_INTERVENTION = MAJOR_MIN_POP,
		EVENT_TRACK_CHARACTER_INJECTION = CHARACTER_INJECTION_MIN_POP,
		EVENT_TRACK_OMENS = OBJECTIVES_MIN_POP,
		EVENT_TRACK_RAIDS = OBJECTIVES_MIN_POP,
		)

	/// Configurable multipliers for point gain over time.
	var/list/point_gain_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
		)
	/// Configurable multipliers for roundstart points.
	var/list/roundstart_point_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
		)
	/// Whether we allow pop scaling. This is configured by config, or the storyteller UI
	var/allow_pop_scaling = TRUE

	/// Associative list of pop scale thresholds.
	var/list/pop_scale_thresholds = list(
		EVENT_TRACK_MUNDANE = MUNDANE_POP_SCALE_THRESHOLD,
		EVENT_TRACK_PERSONAL = MODERATE_POP_SCALE_THRESHOLD,
		EVENT_TRACK_MODERATE = MODERATE_POP_SCALE_THRESHOLD,
		EVENT_TRACK_INTERVENTION = MAJOR_POP_SCALE_THRESHOLD,
		EVENT_TRACK_CHARACTER_INJECTION = ROLESET_POP_SCALE_THRESHOLD,
		EVENT_TRACK_OMENS = OBJECTIVES_POP_SCALE_THRESHOLD,
		EVENT_TRACK_RAIDS = RAID_POP_SCALE_THRESHOLD,
		)

	/// Associative list of pop scale penalties.
	var/list/pop_scale_penalties = list(
		EVENT_TRACK_MUNDANE = MUNDANE_POP_SCALE_PENALTY,
		EVENT_TRACK_PERSONAL = MODERATE_POP_SCALE_PENALTY,
		EVENT_TRACK_MODERATE = MODERATE_POP_SCALE_PENALTY,
		EVENT_TRACK_INTERVENTION = MAJOR_POP_SCALE_PENALTY,
		EVENT_TRACK_CHARACTER_INJECTION = ROLESET_POP_SCALE_PENALTY,
		EVENT_TRACK_OMENS = OBJECTIVES_POP_SCALE_PENALTY,
		EVENT_TRACK_RAIDS = RAID_POP_SCALE_PENALTY,
		)

	/// Associative list of active multipliers from pop scale penalty.
	var/list/current_pop_scale_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
		)



	/// Associative list of control events by their track category. Compiled in Init
	var/list/event_pools = list()

	/// Events that we have scheduled to run in the nearby future
	var/list/scheduled_events = list()

	/// Associative list of tracks to forced event controls. For admins to force events (though they can still invoke them freely outside of the track system)
	var/list/forced_next_events = list()

	var/list/control = list() //list of all datum/round_event_control. Used for selecting events based on weight and occurrences.
	var/list/running = list() //list of all existing /datum/round_event
	var/list/round_end_data = list() //list of all reports that need to add round end reports

	/// List of all uncategorized events, because they were wizard or holiday events
	var/list/uncategorized = list()

	/// Event frequency multiplier, it exists because wizard, eugh.
	var/event_frequency_multiplier = 1

	/// Current preview page for the statistics UI.
	var/statistics_track_page = EVENT_TRACK_MUNDANE
	/// Page of the UI panel.
	var/panel_page = GAMEMODE_PANEL_MAIN
	/// Whether we are viewing the roundstart events or not
	var/roundstart_event_view = TRUE

	/// Whether the storyteller has been halted
	var/halted_storyteller = FALSE

	/// Ready players for roundstart events.
	var/ready_players = 0
	var/active_players = 0
	var/royalty = 0
	var/constructor = 0
	var/garrison = 0
	var/church = 0

	/// Is storyteller secret or not
	var/secret_storyteller = TRUE

	/// List of new player minds we currently want to give our roundstart antag to
	var/list/roundstart_antag_minds = list()

	var/wizardmode = FALSE //refactor this into just being a unique storyteller

	/// What is our currently desired/selected roundstart event
	var/datum/round_event_control/antagonist/solo/current_roundstart_event
	var/list/last_round_events = list()
	/// Has a roundstart event been run
	var/ran_roundstart = FALSE
	/// Are we able to run roundstart events
	var/can_run_roundstart = TRUE
	var/list/triggered_round_events = list()

	var/round_ends_at = 0
	var/roundvoteend = FALSE
	var/reb_end_time = 0

/datum/controller/subsystem/gamemode/Initialize(time, zlevel)
#if defined(UNIT_TESTS) || defined(AUTOWIKI) // lazy way of doing this but idc
	flags |= SS_NO_FIRE
	return ..()
#endif

	// Populate event pools
	for(var/track in event_tracks)
		event_pools[track] = list()

	// Populate storytellers
	if(!length(storytellers))//unit tests can force this before init.
		for(var/type in subtypesof(/datum/storyteller))
			storytellers[type] = new type()

	for(var/datum/round_event_control/event_type as anything in typesof(/datum/round_event_control))
		if(!event_type::typepath || !event_type::name)
			continue

		var/datum/round_event_control/event = new event_type
		if(!event.valid_for_map())
			qdel(event)
			continue // event isn't good for this map no point in trying to add it to the list
		control += event //add it to the list of all events (controls)

	load_config_vars()
	load_event_config_vars()

	///Seeding events into track event pools needs to happen after event config vars are loaded
	for(var/datum/round_event_control/event as anything in control)
		if(event.holidayID || event.wizardevent)
			uncategorized += event
			continue
		event_pools[event.track] += event //Add it to the categorized event pools

	load_roundstart_data()
	. = ..()

/datum/controller/subsystem/gamemode/fire(resumed = FALSE)
	if(last_devotion_check < world.time)
		pick_most_influential()
		last_devotion_check = world.time + 90 MINUTES

	if(SSticker.HasRoundStarted() && (world.time - SSticker.round_start_time) >= ROUNDSTART_VALID_TIMEFRAME)
		can_run_roundstart = FALSE
	else if(current_roundstart_event && length(current_roundstart_event.preferred_events)) //note that this implementation is made for preferred_events being other roundstart events
		var/list/preferred_copy = current_roundstart_event.preferred_events.Copy()
		var/datum/round_event_control/selected_event = pickweight(preferred_copy)
		var/player_count = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)
		if(ispath(selected_event)) //get the instances if we dont have them
			current_roundstart_event.preferred_events = list()
			for(var/datum/round_event_control/e_control as anything in preferred_copy)
				current_roundstart_event.preferred_events[new e_control] = preferred_copy[e_control]
			preferred_copy = current_roundstart_event.preferred_events.Copy()
			selected_event = null
		else if(!selected_event.canSpawnEvent(player_count))
			preferred_copy -= selected_event
			selected_event = null

		var/sanity = 0
		while(!selected_event && length(preferred_copy) && sanity < 100)
			sanity++
			selected_event = pickweight(preferred_copy)
			if(!selected_event.canSpawnEvent(player_count))
				preferred_copy -= selected_event
				selected_event = null

		if(selected_event)
			current_storyteller.try_buy_event(selected_event)

	///Handle scheduled events
	for(var/datum/scheduled_event/sch_event in scheduled_events)
		if(world.time >= sch_event.start_time)
			sch_event.try_fire()
		else if(!sch_event.alerted_admins && world.time >= sch_event.start_time - 1 MINUTES)
			///Alert admins 1 minute before running and allow them to cancel or refund the event, once again.
			sch_event.alerted_admins = TRUE
			message_admins("Scheduled Event: [sch_event.event] will run in [(sch_event.start_time - world.time) / 10] seconds. (<a href='byond://?src=[REF(sch_event)];action=cancel'>CANCEL</a>) (<a href='byond://?src=[REF(sch_event)];action=refund'>REFUND</a>)")

	if(!halted_storyteller && next_storyteller_process <= world.time && current_storyteller)
		// We update crew information here to adjust population scalling and event thresholds for the storyteller.
		update_crew_infos()
		next_storyteller_process = world.time + STORYTELLER_WAIT_TIME
		current_storyteller.process(STORYTELLER_WAIT_TIME * 0.1)

/// Gets the number of antagonists the antagonist injection events will stop rolling after.
/datum/controller/subsystem/gamemode/proc/get_antag_cap()
	var/total_number = get_correct_popcount() + (garrison * 2)
	var/cap = FLOOR((total_number / ANTAG_CAP_DENOMINATOR), 1) + ANTAG_CAP_FLAT
	return cap

/datum/controller/subsystem/gamemode/proc/get_antag_count()
	. = 0
	var/list/already_counted = list() // Never count the same mind twice
	for(var/datum/antagonist/antag as anything in GLOB.antagonists)
		if(QDELETED(antag) || QDELETED(antag.owner) || already_counted[antag.owner])
			continue
		if((antag.antag_flags & (FLAG_FAKE_ANTAG | FLAG_ANTAG_CAP_IGNORE)))
			continue
		if(antag.antag_flags & FLAG_ANTAG_CAP_TEAM)
			var/datum/team/antag_team = antag.get_team()
			if(antag_team)
				if(already_counted[antag_team])
					continue
				already_counted[antag_team] = TRUE
		var/mob/antag_mob = antag.owner.current
		if(QDELETED(antag_mob) || !antag_mob.key || antag_mob.stat == DEAD || antag_mob.client?.is_afk())
			continue
		already_counted[antag.owner] = TRUE
		.++

/// Whether events can inject more antagonists into the round
/datum/controller/subsystem/gamemode/proc/can_inject_antags()
	return (get_antag_cap() > get_antag_count())

/// Gets candidates for antagonist roles.
/datum/controller/subsystem/gamemode/proc/get_candidates(be_special, job_ban, observers, ready_newplayers, living_players, required_time, inherit_required_time = TRUE, midround_antag_pref, no_antags = TRUE, list/restricted_roles, list/required_roles)
	var/list/candidates = list()
	var/list/candidate_candidates = list() //lol

	for(var/mob/player as anything in GLOB.player_list)
		if(QDELETED(player) || player.mind?.picking)
			continue
		if(ready_newplayers && isnewplayer(player))
			var/mob/dead/new_player/new_player = player
			if(new_player.ready == PLAYER_READY_TO_PLAY && new_player.mind && new_player.check_preferences())
				candidate_candidates += player
		else if(observers && isobserver(player))
			candidate_candidates += player
		else if(living_players && isliving(player))
			if(!ishuman(player))
				continue
			candidate_candidates += player

	for(var/mob/candidate as anything in candidate_candidates)
		if(QDELETED(candidate) || !candidate.key || !candidate.client || (!observers && !candidate.mind))
			continue
		if(!observers)
			if(!ready_players && !isliving(candidate))
				continue
			if(no_antags && !isnull(candidate.mind.antag_datums))
				var/real = FALSE
				for(var/datum/antagonist/antag_datum as anything in candidate.mind.antag_datums)
					if(!(antag_datum.antag_flags & FLAG_FAKE_ANTAG))
						real = TRUE
						break
				if(real)
					continue
			if(restricted_roles && (candidate.mind.assigned_role in restricted_roles))
				continue
			if(length(required_roles) && !(candidate.mind.assigned_role in required_roles))
				continue

		if(be_special)
			if(!(candidate.client.prefs) || !(be_special in candidate.client.prefs.be_special))
				continue

		//if(midround_antag_pref)
			//continue

		candidates += candidate
	return candidates

/// Gets the correct popcount, returning READY people if roundstart, and active people if not.
/datum/controller/subsystem/gamemode/proc/get_correct_popcount()
	if(SSticker.HasRoundStarted())
		update_crew_infos()
		return active_players
	else
		calculate_ready_players()
		return ready_players

/// Refunds and removes a scheduled event.
/datum/controller/subsystem/gamemode/proc/refund_scheduled_event(datum/scheduled_event/refunded)
	if(refunded.cost)
		var/track_type = refunded.event.track
		event_track_points[track_type] += refunded.cost
	remove_scheduled_event(refunded)

/// Removes a scheduled event.
/datum/controller/subsystem/gamemode/proc/remove_scheduled_event(datum/scheduled_event/removed)
	scheduled_events -= removed
	qdel(removed)

/// We need to calculate ready players for the sake of roundstart events becoming eligible.
/datum/controller/subsystem/gamemode/proc/calculate_ready_players()
	ready_players = 0
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(player.ready == PLAYER_READY_TO_PLAY)
			ready_players++

/// We roll points to be spent for roundstart events, including antagonists.
/datum/controller/subsystem/gamemode/proc/roll_pre_setup_points()
#if defined(UNIT_TESTS) || defined(AUTOWIKI) // lazy way of doing this but idc
	return
#endif
	if(current_storyteller?.disable_distribution || halted_storyteller)
		return
	/// Distribute points
	for(var/track in event_track_points)
		var/base_amt
		var/gain_amt
		switch(track)
			if(EVENT_TRACK_MUNDANE)
				base_amt = ROUNDSTART_MUNDANE_BASE
				gain_amt = ROUNDSTART_MUNDANE_GAIN
			if(EVENT_TRACK_PERSONAL)
				base_amt = ROUNDSTART_PERSONAL_BASE
				gain_amt = ROUNDSTART_PERSONAL_GAIN
			if(EVENT_TRACK_MODERATE)
				base_amt = ROUNDSTART_MODERATE_BASE
				gain_amt = ROUNDSTART_MODERATE_GAIN
			if(EVENT_TRACK_INTERVENTION)
				base_amt = ROUNDSTART_MAJOR_BASE
				gain_amt = ROUNDSTART_MAJOR_GAIN
			if(EVENT_TRACK_CHARACTER_INJECTION)
				base_amt = ROUNDSTART_ROLESET_BASE
				gain_amt = ROUNDSTART_ROLESET_GAIN
			if(EVENT_TRACK_OMENS)
				base_amt = 0
				gain_amt = 0
			if(EVENT_TRACK_RAIDS)
				base_amt = 0
				gain_amt = 0

		var/calc_value = base_amt + (gain_amt * ready_players)
		calc_value *= roundstart_point_multipliers[track]
		calc_value *= current_storyteller?.starting_point_multipliers[track]
		calc_value *= (rand(100 - current_storyteller?.roundstart_points_variance,100 + current_storyteller?.roundstart_points_variance)/100)
		event_track_points[track] = min(round(calc_value), round(point_thresholds[track] * 1.25))

	/// If the storyteller guarantees an antagonist roll, add points to make it so.
	if(current_storyteller?.guarantees_roundstart_roleset && event_track_points[EVENT_TRACK_CHARACTER_INJECTION] < point_thresholds[EVENT_TRACK_CHARACTER_INJECTION])
		event_track_points[EVENT_TRACK_CHARACTER_INJECTION] = point_thresholds[EVENT_TRACK_CHARACTER_INJECTION]

	/// If we have any forced events, ensure we get enough points for them
	for(var/track in event_tracks)
		if(forced_next_events[track] && event_track_points[track] < point_thresholds[track])
			event_track_points[track] = point_thresholds[track]

/// At this point we've rolled roundstart events and antags and we handle leftover points here.
/datum/controller/subsystem/gamemode/proc/handle_post_setup_points()
//	for(var/track in event_track_points) //Just halve the points for now.
//		event_track_points[track] *= 0.5 TESTING HOW THINGS GO WITHOUT THIS HALVING OF POINTS
	return

/// Because roundstart events need 2 steps of firing for purposes of antags, here is the first step handled, happening before occupation division.
/datum/controller/subsystem/gamemode/proc/handle_pre_setup_roundstart_events()
	if(current_storyteller?.disable_distribution)
		return
	if(halted_storyteller)
		message_admins("WARNING: Didn't roll roundstart events (including antagonists) due to the storyteller being halted.")
		return
	while(TRUE)
		if(!current_storyteller.handle_tracks())
			break

/// Second step of handlind roundstart events, happening after people spawn.
/datum/controller/subsystem/gamemode/proc/handle_post_setup_roundstart_events()
	/// Start all roundstart events on post_setup immediately
	for(var/datum/round_event/event as anything in running)
		if(!event.control.roundstart)
			continue
		ASYNC
			event.try_start()
		INVOKE_ASYNC(event, TYPE_PROC_REF(/datum/round_event, try_start))

/// Schedules an event to run later.
/datum/controller/subsystem/gamemode/proc/schedule_event(datum/round_event_control/passed_event, passed_time, passed_cost, passed_ignore, passed_announce, _forced = FALSE)
	if(_forced)
		passed_ignore = TRUE
	var/datum/scheduled_event/scheduled = new (passed_event, world.time + passed_time, passed_cost, passed_ignore, passed_announce)
	var/round_started = SSticker.HasRoundStarted()
	if(round_started)
		message_admins("Event: [passed_event] has been scheduled to run in [passed_time / 10] seconds. (<a href='byond://?src=[REF(scheduled)];action=cancel'>CANCEL</a>) (<a href='byond://?src=[REF(scheduled)];action=refund'>REFUND</a>)")
	else //Only roundstart events can be scheduled before round start
		message_admins("Event: [passed_event] has been scheduled to run on roundstart. (<a href='byond://?src=[REF(scheduled)];action=cancel'>CANCEL</a>)")
	scheduled_events += scheduled

/datum/controller/subsystem/gamemode/proc/update_crew_infos()
	// Very similar logic to `get_active_player_count()`
	active_players = 0
	royalty = 0
	constructor = 0
	church = 0
	garrison = 0
	for(var/mob/player_mob as anything in GLOB.player_list)
		if(!player_mob.client)
			continue
		if(player_mob.stat) //If they're alive
			continue
		if(player_mob.client.is_afk()) //If afk
			continue
		if(!ishuman(player_mob))
			continue
		active_players++
		if(player_mob.mind?.assigned_role)
			if(player_mob.mind.job_bitflag & BITFLAG_ROYALTY)
				royalty++
			if(player_mob.mind.job_bitflag & BITFLAG_CONSTRUCTOR)
				constructor++
			if(player_mob.mind.job_bitflag & BITFLAG_CHURCH)
				church++
			if(player_mob.mind.job_bitflag & BITFLAG_GARRISON)
				garrison++
	update_pop_scaling()

/datum/controller/subsystem/gamemode/proc/update_pop_scaling()
	for(var/track in event_tracks)
		var/low_pop_bound = min_pop_thresholds[track]
		var/high_pop_bound = pop_scale_thresholds[track]
		var/scale_penalty = pop_scale_penalties[track]

		var/perceived_pop = min(max(low_pop_bound, active_players), high_pop_bound)

		var/divisor = high_pop_bound - low_pop_bound
		/// If the bounds are equal, we'd be dividing by zero or worse, if upper is smaller than lower, we'd be increasing the factor, just make it 1 and continue.
		/// this is only a problem for bad configs
		if(divisor <= 0)
			current_pop_scale_multipliers[track] = 1
			continue
		var/scalar = (perceived_pop - low_pop_bound) / divisor
		var/penalty = scale_penalty - (scale_penalty * scalar)
		var/calculated_multiplier = 1 - (penalty / 100)

		current_pop_scale_multipliers[track] = calculated_multiplier

/datum/controller/subsystem/gamemode/proc/TriggerEvent(datum/round_event_control/event, forced = FALSE)
	. = event.preRunEvent(forced)
	if(. == EVENT_CANT_RUN)//we couldn't run this event for some reason, set its max_occurrences to 0
		event.max_occurrences = 0
	else if(. == EVENT_READY)
		event.runEvent(random = TRUE, admin_forced = forced) // fallback to dynamic
		//add_abstract_elastic_data("storyteller", event.name, 1, 1)

///Resets frequency multiplier.
/datum/controller/subsystem/gamemode/proc/resetFrequency()
	event_frequency_multiplier = 1

///Attempts to select players for special roles the mode might have.
/datum/controller/subsystem/gamemode/proc/pre_setup()
	if(!length(storytellers))
		for(var/type in subtypesof(/datum/storyteller))
			storytellers[type] = new type()
	set_storyteller(/datum/storyteller/astrata)
	calculate_ready_players()
	roll_pre_setup_points()
	//handle_pre_setup_roundstart_events()
	return TRUE

///Everyone should now be on the station and have their normal gear.  This is the place to give the special roles extra things
/datum/controller/subsystem/gamemode/proc/post_setup(report) //Gamemodes can override the intercept report. Passing TRUE as the argument will force a report.
	if(!report)
		report = !CONFIG_GET(flag/no_intercept_report)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(display_roundstart_logout_report)), ROUNDSTART_LOGOUT_REPORT_TIME)

	if(CONFIG_GET(flag/reopen_roundstart_suicide_roles))
		var/delay = CONFIG_GET(number/reopen_roundstart_suicide_roles_delay)
		if(delay)
			delay = (delay SECONDS)
		else
			delay = (4 MINUTES) //default to 4 minutes if the delay isn't defined.
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(reopen_roundstart_suicide_roles)), delay)

	refresh_alive_stats()
	handle_post_setup_roundstart_events()
	handle_post_setup_points()
	roundstart_event_view = FALSE
	return TRUE


///Handles late-join antag assignments
/datum/controller/subsystem/gamemode/proc/make_antag_chance(mob/living/carbon/human/character)
	return

/datum/controller/subsystem/gamemode/proc/check_finished(force_ending) //to be called by SSticker
	if(!SSticker.setup_done)
		return FALSE
	if(force_ending)
		return TRUE

	var/ttime = world.time - SSticker.round_start_time
	if(ttime >= GLOB.round_timer)
		if(roundvoteend)
			if(ttime >= round_ends_at)
				for(var/mob/living/carbon/human/H in GLOB.human_list)
					if(H.stat != DEAD)
						if(H.allmig_reward)
							H.adjust_triumphs(H.allmig_reward)
							H.allmig_reward = 0
				return TRUE
		else
			if(!SSvote.mode)
				SSvote.initiate_vote("endround", pick("Zlod", "Sun King", "Gaia", "Moon Queen", "Aeon", "Gemini", "Aries"))

	if(SSmapping.retainer.head_rebel_decree)
		if(reb_end_time == 0)
			to_chat(world, span_boldannounce("The peasant rebels took control of the throne, hail the new community!"))
			if(ttime >= INITIAL_ROUND_TIMER)
				reb_end_time = ttime + 15 MINUTES
				to_chat(world, span_boldwarning("The round will end in 15 minutes."))
			else
				reb_end_time = INITIAL_ROUND_TIMER
				to_chat(world, span_boldwarning("The round will end at the 2:30 hour mark."))
		if(ttime >= reb_end_time)
			return TRUE

/datum/controller/subsystem/gamemode/proc/generate_town_goals()
	return

/// Loads json event config values from events.txt
/datum/controller/subsystem/gamemode/proc/load_event_config_vars()
	var/json_file = file("[global.config.directory]/events.json")
	if(!fexists(json_file))
		return
	var/list/decoded = json_decode(file2text(json_file))
	for(var/event_text_path in decoded)
		var/event_path = text2path(event_text_path)
		var/datum/round_event_control/event
		for(var/datum/round_event_control/iterated_event as anything in control)
			if(iterated_event.type == event_path)
				event = iterated_event
				break
		if(!event)
			continue
		var/list/var_list = decoded[event_text_path]
		for(var/variable in var_list)
			var/value = var_list[variable]
			switch(variable)
				if("weight")
					event.weight = value
				if("min_players")
					event.min_players = value
				if("max_occurrences")
					event.max_occurrences = value
				if("earliest_start")
					event.earliest_start = value * (1 MINUTES)
				if("track")
					if(value in event_tracks)
						event.track = value
				if("cost")
					event.cost = value
				if("reoccurence_penalty_multiplier")
					event.reoccurence_penalty_multiplier = value
				if("shared_occurence_type")
					if(!isnull(value))
						value = "[value]"
					event.shared_occurence_type = value

/// Loads config values from game_options.txt
/datum/controller/subsystem/gamemode/proc/load_config_vars()
	point_gain_multipliers[EVENT_TRACK_MUNDANE] = CONFIG_GET(number/mundane_point_gain_multiplier)
	point_gain_multipliers[EVENT_TRACK_PERSONAL] = CONFIG_GET(number/moderate_point_gain_multiplier)
	point_gain_multipliers[EVENT_TRACK_MODERATE] = CONFIG_GET(number/moderate_point_gain_multiplier)
	point_gain_multipliers[EVENT_TRACK_INTERVENTION] = CONFIG_GET(number/major_point_gain_multiplier)
	point_gain_multipliers[EVENT_TRACK_CHARACTER_INJECTION] = CONFIG_GET(number/roleset_point_gain_multiplier)
	point_gain_multipliers[EVENT_TRACK_OMENS] = CONFIG_GET(number/objectives_point_gain_multiplier)
	point_gain_multipliers[EVENT_TRACK_RAIDS] = 1

	roundstart_point_multipliers[EVENT_TRACK_MUNDANE] = CONFIG_GET(number/mundane_roundstart_point_multiplier)
	roundstart_point_multipliers[EVENT_TRACK_PERSONAL] = CONFIG_GET(number/moderate_roundstart_point_multiplier)
	roundstart_point_multipliers[EVENT_TRACK_MODERATE] = CONFIG_GET(number/moderate_roundstart_point_multiplier)
	roundstart_point_multipliers[EVENT_TRACK_INTERVENTION] = CONFIG_GET(number/major_roundstart_point_multiplier)
	roundstart_point_multipliers[EVENT_TRACK_CHARACTER_INJECTION] = CONFIG_GET(number/roleset_roundstart_point_multiplier)
	roundstart_point_multipliers[EVENT_TRACK_OMENS] = CONFIG_GET(number/objectives_roundstart_point_multiplier)
	roundstart_point_multipliers[EVENT_TRACK_RAIDS] = 1

	min_pop_thresholds[EVENT_TRACK_MUNDANE] = CONFIG_GET(number/mundane_min_pop)
	min_pop_thresholds[EVENT_TRACK_PERSONAL] = CONFIG_GET(number/moderate_min_pop)
	min_pop_thresholds[EVENT_TRACK_MODERATE] = CONFIG_GET(number/moderate_min_pop)
	min_pop_thresholds[EVENT_TRACK_INTERVENTION] = CONFIG_GET(number/major_min_pop)
	min_pop_thresholds[EVENT_TRACK_CHARACTER_INJECTION] = CONFIG_GET(number/roleset_min_pop)
	min_pop_thresholds[EVENT_TRACK_OMENS] = CONFIG_GET(number/objectives_min_pop)
	min_pop_thresholds[EVENT_TRACK_RAIDS] = CONFIG_GET(number/objectives_min_pop)

	point_thresholds[EVENT_TRACK_MUNDANE] = CONFIG_GET(number/mundane_point_threshold)
	point_thresholds[EVENT_TRACK_PERSONAL] = CONFIG_GET(number/mundane_point_threshold)
	point_thresholds[EVENT_TRACK_MODERATE] = CONFIG_GET(number/moderate_point_threshold)
	point_thresholds[EVENT_TRACK_INTERVENTION] = CONFIG_GET(number/major_point_threshold)
	point_thresholds[EVENT_TRACK_CHARACTER_INJECTION] = CONFIG_GET(number/roleset_point_threshold)
	point_thresholds[EVENT_TRACK_OMENS] = CONFIG_GET(number/objectives_point_threshold)
	point_thresholds[EVENT_TRACK_RAIDS] = CONFIG_GET(number/objectives_point_threshold) * 2

/datum/controller/subsystem/gamemode/proc/handle_picking_storyteller()
	if(length(GLOB.clients) > MAX_POP_FOR_STORYTELLER_VOTE)
		secret_storyteller = TRUE
		selected_storyteller = pickweight(get_valid_storytellers(TRUE))
		return
	pick_most_influential(TRUE)

/datum/controller/subsystem/gamemode/proc/storyteller_vote_choices()
	var/list/final_choices = list()
	var/list/pick_from = list()
	for(var/datum/storyteller/storyboy in get_valid_storytellers())
		if(storyboy.always_votable)
			final_choices[storyboy.name] = 0
		else
			pick_from[storyboy.name] = storyboy.weight //might be able to refactor this to be slightly better due to get_valid_storytellers returning a weighted list

	var/added_storytellers = 0
	while(added_storytellers < DEFAULT_STORYTELLER_VOTE_OPTIONS && length(pick_from))
		added_storytellers++
		var/picked_storyteller = pickweight(pick_from)
		final_choices[picked_storyteller] = 0
		pick_from -= picked_storyteller
	return final_choices

/datum/controller/subsystem/gamemode/proc/storyteller_desc(storyteller_name)
	for(var/storyteller_type in storytellers)
		var/datum/storyteller/storyboy = storytellers[storyteller_type]
		if(storyboy.name != storyteller_name)
			continue
		return storyboy.desc


/datum/controller/subsystem/gamemode/proc/storyteller_vote_result(winner_name)
	for(var/storyteller_type in storytellers)
		var/datum/storyteller/storyboy = storytellers[storyteller_type]
		if(storyboy.name == winner_name)
			selected_storyteller = storyteller_type
			break

///return a weighted list of all storytellers that are currently valid to roll, if return_types is set then we will return types instead of instances
/datum/controller/subsystem/gamemode/proc/get_valid_storytellers(return_types = FALSE)
	var/client_amount = length(GLOB.clients)
	var/list/valid_storytellers = list()
	for(var/storyteller_type in storytellers)
		var/datum/storyteller/storyboy = storytellers[storyteller_type]
		if(storyboy.restricted || (storyboy.population_min && storyboy.population_min > client_amount) || (storyboy.population_max && storyboy.population_max < client_amount))
			continue

		valid_storytellers[return_types ? storyboy.type : storyboy] = storyboy.weight
	return valid_storytellers

/datum/controller/subsystem/gamemode/proc/init_storyteller()
	set_storyteller(selected_storyteller)

/datum/controller/subsystem/gamemode/proc/set_storyteller(passed_type)
	if(!storytellers[passed_type])
		message_admins("Attempted to set an invalid storyteller type: [passed_type], force setting to guide instead.")
		current_storyteller = storytellers[/datum/storyteller/astrata] //if we dont have any then we brick, lets not do that
		CRASH("Attempted to set an invalid storyteller type: [passed_type].")
	var/datum/storyteller/chosen_storyteller = storytellers[passed_type]
	chosen_storyteller.times_chosen++
	GLOB.featured_stats[FEATURED_STATS_STORYTELLERS]["entries"][initial(chosen_storyteller.name)] = chosen_storyteller.times_chosen
	current_storyteller = chosen_storyteller
	if(!secret_storyteller)
		send_to_playing_players(span_notice("<b>Storyteller is [current_storyteller.name]!</b>"))
		send_to_playing_players(span_notice("[current_storyteller.welcome_text]"))

/// Panel containing information, variables and controls about the gamemode and scheduled event
/datum/controller/subsystem/gamemode/proc/admin_panel(mob/user)
	update_crew_infos()
	var/round_started = SSticker.HasRoundStarted()
	var/list/dat = list()
	dat += "Storyteller: [current_storyteller ? "[current_storyteller.name]" : "None"] "
	dat += " <a href='byond://?src=[REF(src)];panel=main;action=halt_storyteller' [halted_storyteller ? "class='linkOn'" : ""]>HALT Storyteller</a> <a href='byond://?src=[REF(src)];panel=main;action=open_stats'>Event Panel</a> <a href='byond://?src=[REF(src)];panel=main;action=set_storyteller'>Set Storyteller</a> <a href='byond://?src=[REF(user.client)];panel=main;viewinfluences=1'>View Influences</a> <a href='byond://?src=[REF(src)];panel=main'>Refresh</a>"
	dat += "<BR><font color='#888888'><i>Storyteller determines points gained, event chances, and is the entity responsible for rolling events.</i></font>"
	dat += "<BR>Active Players: [active_players]   (Royalty: [royalty], Garrison: [garrison], Town Workers: [constructor], Church: [church])"
	dat += "<BR>Antagonist Count vs Maximum: [get_antag_count()] / [get_antag_cap()]"
	dat += "<HR>"
	dat += "<a href='byond://?src=[REF(src)];panel=main;action=tab;tab=[GAMEMODE_PANEL_MAIN]' [panel_page == GAMEMODE_PANEL_MAIN ? "class='linkOn'" : ""]>Main</a>"
	dat += " <a href='byond://?src=[REF(src)];panel=main;action=tab;tab=[GAMEMODE_PANEL_VARIABLES]' [panel_page == GAMEMODE_PANEL_VARIABLES ? "class='linkOn'" : ""]>Variables</a>"
	dat += "<HR>"
	switch(panel_page)
		if(GAMEMODE_PANEL_VARIABLES)
			dat += "<a href='byond://?src=[REF(src)];panel=main;action=reload_config_vars'>Reload Config Vars</a> <font color='#888888'><i>Configs located in game_options.txt.</i></font>"
			dat += "<BR><b>Point Gains Multipliers (only over time):</b>"
			dat += "<BR><font color='#888888'><i>This affects points gained over time towards scheduling new events of the tracks.</i></font>"
			for(var/track in event_tracks)
				dat += "<BR>[track]: <a href='byond://?src=[REF(src)];panel=main;action=vars;var=pts_multiplier;track=[track]'>[point_gain_multipliers[track]]</a>"
			dat += "<HR>"

			dat += "<b>Roundstart Points Multipliers:</b>"
			dat += "<BR><font color='#888888'><i>This affects points generated for roundstart events and antagonists.</i></font>"
			for(var/track in event_tracks)
				dat += "<BR>[track]: <a href='byond://?src=[REF(src)];panel=main;action=vars;var=roundstart_pts;track=[track]'>[roundstart_point_multipliers[track]]</a>"
			dat += "<HR>"

			dat += "<b>Minimum Population for Tracks:</b>"
			dat += "<BR><font color='#888888'><i>This are the minimum population caps for events to be able to run.</i></font>"
			for(var/track in event_tracks)
				dat += "<BR>[track]: <a href='byond://?src=[REF(src)];panel=main;action=vars;var=min_pop;track=[track]'>[min_pop_thresholds[track]]</a>"
			dat += "<HR>"

			dat += "<b>Point Thresholds:</b>"
			dat += "<BR><font color='#888888'><i>Those are thresholds the tracks require to reach with points to make an event.</i></font>"
			for(var/track in event_tracks)
				dat += "<BR>[track]: <a href='byond://?src=[REF(src)];panel=main;action=vars;var=pts_threshold;track=[track]'>[point_thresholds[track]]</a>"

		if(GAMEMODE_PANEL_MAIN)
			var/even = TRUE
			dat += "<h2>Event Tracks:</h2>"
			dat += "<font color='#888888'><i>Every track represents progression towards scheduling an event of it's severity</i></font>"
			dat += "<table align='center'; width='100%'; height='100%'; style='background-color:#13171C'>"
			dat += "<tr style='vertical-align:top'>"
			dat += "<td width=25%><b>Track</b></td>"
			dat += "<td width=20%><b>Progress</b></td>"
			dat += "<td width=10%><b>Next</b></td>"
			dat += "<td width=10%><b>Forced</b></td>"
			dat += "<td width=35%><b>Actions</b></td>"
			dat += "</tr>"
			for(var/track in event_tracks)
				even = !even
				var/background_cl = even ? "#17191C" : "#23273C"
				var/lower = event_track_points[track]
				var/upper = point_thresholds[track]
				var/percent = round((lower/upper)*100)
				var/next = 0
				var/last_points = last_point_gains[track]
				if(last_points)
					next = round(((upper - lower) / last_points / STORYTELLER_WAIT_TIME))
				dat += "<tr style='vertical-align:top; background-color: [background_cl];'>"
				dat += "<td>[track] - [last_points] per process.</td>" //Track
				dat += "<td>[percent]% ([lower]/[upper])</td>" //Progress
				dat += "<td>~[next] seconds</td>" //Next
				var/datum/round_event_control/forced_event = forced_next_events[track]
				var/forced = forced_event ? "[forced_event.name] <a href='byond://?src=[REF(src)];panel=main;action=track_action;track_action=remove_forced;track=[track]'>X</a>" : ""
				dat += "<td>[forced]</td>" //Forced
				dat += "<td><a href='byond://?src=[REF(src)];panel=main;action=track_action;track_action=set_pts;track=[track]'>Set Pts.</a> <a href='byond://?src=[REF(src)];panel=main;action=track_action;track_action=next_event;track=[track]'>Next Event</a></td>" //Actions
				dat += "</tr>"
			dat += "</table>"

			dat += "<h2>Scheduled Events:</h2>"
			dat += "<table align='center'; width='100%'; height='100%'; style='background-color:#13171C'>"
			dat += "<tr style='vertical-align:top'>"
			dat += "<td width=30%><b>Name</b></td>"
			dat += "<td width=17%><b>Severity</b></td>"
			dat += "<td width=12%><b>Time</b></td>"
			dat += "<td width=41%><b>Actions</b></td>"
			dat += "</tr>"
			var/sorted_scheduled = list()
			for(var/datum/scheduled_event/scheduled as anything in scheduled_events)
				sorted_scheduled[scheduled] = scheduled.start_time
			sortTim(sorted_scheduled, cmp=/proc/cmp_numeric_asc, associative = TRUE)
			even = TRUE
			for(var/datum/scheduled_event/scheduled as anything in sorted_scheduled)
				even = !even
				var/background_cl = even ? "#17191C" : "#23273C"
				dat += "<tr style='vertical-align:top; background-color: [background_cl];'>"
				dat += "<td>[scheduled.event.name]</td>" //Name
				dat += "<td>[scheduled.event.track]</td>" //Severity
				var/time = (scheduled.event.roundstart && !round_started) ? "ROUNDSTART" : "[(scheduled.start_time - world.time) / (1 SECONDS)] s."
				dat += "<td>[time]</td>" //Time
				dat += "<td>[scheduled.get_href_actions()]</td>" //Actions
				dat += "</tr>"
			dat += "</table>"

			dat += "<h2>Running Events:</h2>"
			dat += "<table align='center'; width='100%'; height='100%'; style='background-color:#13171C'>"
			dat += "<tr style='vertical-align:top'>"
			dat += "<td width=30%><b>Name</b></td>"
			dat += "<td width=70%><b>Actions</b></td>"
			dat += "</tr>"
			even = TRUE
			for(var/datum/round_event/event as anything in running)
				even = !even
				var/background_cl = even ? "#17191C" : "#23273C"
				dat += "<tr style='vertical-align:top; background-color: [background_cl];'>"
				dat += "<td>[event.control.name]</td>" //Name
				dat += "<td>-TBA-</td>" //Actions
				dat += "</tr>"
			dat += "</table>"

	var/datum/browser/noclose/popup = new(user, "gamemode_admin_panel", "Gamemode Panel", 670, 650)
	popup.set_content(dat.Join())
	popup.open()

/// Panel containing information and actions regarding events
/datum/controller/subsystem/gamemode/proc/event_panel(mob/user)
	var/list/dat = list()
	if(current_storyteller)
		dat += "Storyteller: [current_storyteller.name]"
		dat += "<BR>Repetition penalty multiplier: [current_storyteller.event_repetition_multiplier]"
		dat += "<BR>Cost variance: [current_storyteller.cost_variance]"
		if(current_storyteller.tag_multipliers)
			dat += "<BR>Tag multipliers:"
			for(var/tag in current_storyteller.tag_multipliers)
				dat += "[tag]:[current_storyteller.tag_multipliers[tag]] | "
		current_storyteller.calculate_weights(statistics_track_page)
	else
		dat += "Storyteller: None<BR>Weight and chance statistics will be inaccurate due to the present lack of a storyteller."
	dat += "<BR><a href='byond://?src=[REF(src)];panel=stats;action=set_roundstart'[roundstart_event_view ? "class='linkOn'" : ""]>Roundstart Events</a> Forced Roundstart events will use rolled points, and are guaranteed to trigger (even if the used points are not enough)"
	dat += "<BR>Avg. event intervals: "
	for(var/track in event_tracks)
		if(last_point_gains[track])
			var/est_time = round(point_thresholds[track] / last_point_gains[track] / STORYTELLER_WAIT_TIME * 40 / 6) / 10
			dat += "[track]: ~[est_time] m. | "
	dat += "<HR>"
	for(var/track in EVENT_PANEL_TRACKS)
		dat += "<a href='byond://?src=[REF(src)];panel=stats;action=set_cat;cat=[track]'[(statistics_track_page == track) ? "class='linkOn'" : ""]>[track]</a>"
	dat += "<HR>"
	/// Create event info and stats table
	dat += "<table align='center'; width='100%'; height='100%'; style='background-color:#13171C'>"
	dat += "<tr style='vertical-align:top'>"
	dat += "<td width=17%><b>Name</b></td>"
	dat += "<td width=16%><b>Tags</b></td>"
	dat += "<td width=8%><b>Occurences</b></td>"
	dat += "<td width=8%><b>Max Occurences</b></td>"
	dat += "<td width=5%><b>M.Pop</b></td>"
	dat += "<td width=5%><b>M.Time</b></td>"
	dat += "<td width=7%><b>Can Occur</b></td>"
	dat += "<td width=7%><b>Failure Reason</b></td>"
	dat += "<td width=16%><b>Weight</b></td>"
	dat += "<td width=26%><b>Actions</b></td>"
	dat += "</tr>"
	var/even = TRUE
	var/total_weight = 0
	var/list/event_lookup
	switch(statistics_track_page)
		if(ALL_EVENTS)
			event_lookup = control
		if(UNCATEGORIZED_EVENTS)
			event_lookup = uncategorized
		else
			event_lookup = event_pools[statistics_track_page]
	var/list/assoc_spawn_weight = list()
	for(var/datum/round_event_control/event as anything in event_lookup)
		var/players_amt = get_active_player_count(alive_check = 1, afk_check = 1, human_check = 1)
		if(event.roundstart != roundstart_event_view)
			continue
		if(event.canSpawnEvent(players_amt))
			total_weight += event.calculated_weight
			assoc_spawn_weight[event] = event.calculated_weight
		else
			assoc_spawn_weight[event] = 0
	sortTim(assoc_spawn_weight, cmp=/proc/cmp_numeric_dsc, associative = TRUE)
	for(var/datum/round_event_control/event as anything in assoc_spawn_weight)
		even = !even
		var/background_cl = even ? "#17191C" : "#23273C"
		dat += "<tr style='vertical-align:top; background-color: [background_cl];'>"
		dat += "<td>[event.name]</td>" //Name
		dat += "<td>" //Tags
		for(var/tag in event.tags)
			dat += "[tag] "
		dat += "</td>"
		var/occurence_string = "[event.occurrences]"
		if(event.shared_occurence_type)
			occurence_string += " (shared: [event.get_occurences()])"
		var/max_occurence_string = "[event.max_occurrences]"
		dat += "<td>[occurence_string]</td>" //Occurences
		dat += "<td>[max_occurence_string]</td>" //Max Occurences
		dat += "<td>[event.min_players]</td>" //Minimum pop
		dat += "<td>[event.earliest_start / (1 MINUTES)] m.</td>" //Minimum time
		dat += "<td>[assoc_spawn_weight[event] ? "Yes" : "No"]</td>" //Can happen?
		dat += "<td>[event.return_failure_string(active_players)]</td>" //Why can't happen?
		var/weight_string = "(new.[event.calculated_weight] /raw.[event.weight])"
		if(assoc_spawn_weight[event])
			var/percent = round((event.calculated_weight / total_weight) * 100)
			weight_string = "[percent]% - [weight_string]"
		dat += "<td>[weight_string]</td>" //Weight
		dat += "<td>[event.get_href_actions()]</td>" //Actions
		dat += "</tr>"
	dat += "</table>"
	var/datum/browser/noclose/popup = new(user, "gamemode_event_panel", "Event Panel", 1100, 600)
	popup.set_content(dat.Join())
	popup.open()

/datum/controller/subsystem/gamemode/Topic(href, href_list)
	. = ..()
	var/mob/user = usr
	if(!check_rights(R_ADMIN))
		return
	switch(href_list["panel"])
		if("main")
			switch(href_list["action"])
				if("set_storyteller")
					message_admins("[key_name_admin(usr)] is picking a new Storyteller.")
					var/list/name_list = list()
					for(var/storyteller_type in storytellers)
						var/datum/storyteller/storyboy = storytellers[storyteller_type]
						name_list[storyboy.name] = storyboy.type
					var/new_storyteller_name = input(usr, "Choose new storyteller (circumvents voted one):", "Storyteller")  as null|anything in name_list
					if(!new_storyteller_name)
						message_admins("[key_name_admin(usr)] has cancelled picking a Storyteller.")
						return
					message_admins("[key_name_admin(usr)] has chosen [new_storyteller_name] as the new Storyteller.")
					var/new_storyteller_type = name_list[new_storyteller_name]
					set_storyteller(new_storyteller_type)
				if("halt_storyteller")
					halted_storyteller = !halted_storyteller
					message_admins("[key_name_admin(usr)] has [halted_storyteller ? "HALTED" : "un-halted"] the Storyteller.")
				if("vars")
					var/track = href_list["track"]
					switch(href_list["var"])
						if("pts_multiplier")
							var/new_value = input(usr, "New value:", "Set new value") as num|null
							if(isnull(new_value) || new_value < 0)
								return
							message_admins("[key_name_admin(usr)] set point gain multiplier for [track] track to [new_value].")
							point_gain_multipliers[track] = new_value
						if("roundstart_pts")
							var/new_value = input(usr, "New value:", "Set new value") as num|null
							if(isnull(new_value) || new_value < 0)
								return
							message_admins("[key_name_admin(usr)] set roundstart pts multiplier for [track] track to [new_value].")
							roundstart_point_multipliers[track] = new_value
						if("min_pop")
							var/new_value = input(usr, "New value:", "Set new value") as num|null
							if(isnull(new_value) || new_value < 0)
								return
							message_admins("[key_name_admin(usr)] set minimum population for [track] track to [new_value].")
							min_pop_thresholds[track] = new_value
						if("pts_threshold")
							var/new_value = input(usr, "New value:", "Set new value") as num|null
							if(isnull(new_value) || new_value < 0)
								return
							message_admins("[key_name_admin(usr)] set point threshold of [track] track to [new_value].")
							point_thresholds[track] = new_value
				if("reload_config_vars")
					message_admins("[key_name_admin(usr)] reloaded gamemode config vars.")
					load_config_vars()
				if("tab")
					var/tab = href_list["tab"]
					panel_page = tab
				if("open_stats")
					event_panel(user)
					return
				if("track_action")
					var/track = href_list["track"]
					if(!(track in event_tracks))
						return
					switch(href_list["track_action"])
						if("remove_forced")
							if(forced_next_events[track])
								var/datum/round_event_control/event = forced_next_events[track]
								message_admins("[key_name_admin(usr)] removed forced event [event.name] from track [track].")
								forced_next_events -= track
						if("set_pts")
							var/set_pts = input(usr, "New point amount ([point_thresholds[track]]+ invokes event):", "Set points for [track]") as num|null
							if(isnull(set_pts))
								return
							event_track_points[track] = set_pts
							message_admins("[key_name_admin(usr)] set points of [track] track to [set_pts].")
							log_admin_private("[key_name(usr)] set points of [track] track to [set_pts].")
						if("next_event")
							message_admins("[key_name_admin(usr)] invoked next event for [track] track.")
							log_admin_private("[key_name(usr)] invoked next event for [track] track.")
							event_track_points[track] = point_thresholds[track]
							if(current_storyteller)
								current_storyteller.handle_tracks()
			admin_panel(user)
		if("stats")
			switch(href_list["action"])
				if("set_roundstart")
					roundstart_event_view = !roundstart_event_view
				if("set_cat")
					var/new_category = href_list["cat"]
					if(new_category in EVENT_PANEL_TRACKS)
						statistics_track_page = new_category
			event_panel(user)

/datum/controller/subsystem/gamemode/proc/store_roundend_data()
	var/congealed_string = ""
	for(var/event_name as anything in triggered_round_events)
		congealed_string += event_name
		congealed_string += ","
	text2file(congealed_string, "data/last_round_events.txt")

/datum/controller/subsystem/gamemode/proc/load_roundstart_data()
	var/massive_string = trim(file2text("data/last_round_events.txt"))
	if(fexists("data/last_round_events.txt"))
		fdel("data/last_round_events.txt")
	if(!massive_string)
		return
	last_round_events = splittext(massive_string, ",")

	if(!length(last_round_events))
		return
	for(var/event_name as anything in last_round_events)
		for(var/datum/round_event_control/listed as anything in control)
			if(listed.name != event_name)
				continue
			listed.occurrences++
			listed.occurrences++

/// Compares influence of all storytellers and sets a new storyteller with a highest influence
/datum/controller/subsystem/gamemode/proc/pick_most_influential(roundstart = FALSE)
	refresh_alive_stats(roundstart)
	var/list/storytellers_with_influence = list()
	var/datum/storyteller/highest
	var/datum/storyteller/lowest

	for(var/storyteller_type in storytellers)
		var/datum/storyteller/initialized_storyteller = storytellers[storyteller_type]
		if(!initialized_storyteller)
			continue
		var/influence = calculate_storyteller_influence(storyteller_type)
		storytellers_with_influence[initialized_storyteller] = influence

		if(!highest)
			highest = initialized_storyteller
			lowest = initialized_storyteller
			continue
		if(influence > storytellers_with_influence[highest])
			highest = initialized_storyteller
		else if(influence == storytellers_with_influence[highest] && prob(50))
			highest = initialized_storyteller

		if(influence < storytellers_with_influence[lowest])
			lowest = initialized_storyteller
		else if(influence == storytellers_with_influence[lowest] && prob(50))
			lowest = initialized_storyteller
	if(!highest)
		return

	var/adjustment = min(2.5, 1 + (0.3 * FLOOR(max(0, highest.times_chosen - 5) / 5, 1)))

	if(storytellers_with_influence[highest] > adjustment)
		highest.bonus_points -= adjustment

	lowest.bonus_points += adjustment

	set_storyteller(highest.type)

/// Refreshes statistics regarding alive statuses of certain professions or antags, like nobles
/datum/controller/subsystem/gamemode/proc/refresh_alive_stats(roundstart = FALSE)
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return

	GLOB.patron_follower_counts.Cut()

	// General / Patron count
	GLOB.scarlet_round_stats[STATS_TOTAL_POPULATION] = 0
	GLOB.scarlet_round_stats[STATS_PSYCROSS_USERS] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_NOBLES] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_GARRISON] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_CLERGY] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_TRADESMEN] = 0
	GLOB.scarlet_round_stats[STATS_WEREVOLVES] = 0
	GLOB.scarlet_round_stats[STATS_BANDITS] = 0
	GLOB.scarlet_round_stats[STATS_VAMPIRES] = 0
	GLOB.scarlet_round_stats[STATS_DEADITES_ALIVE] = 0
	GLOB.scarlet_round_stats[STATS_CLINGY_PEOPLE] = 0
	GLOB.scarlet_round_stats[STATS_ALCOHOLICS] = 0
	GLOB.scarlet_round_stats[STATS_JUNKIES] = 0
	GLOB.scarlet_round_stats[STATS_GREEDY_PEOPLE] = 0
	GLOB.scarlet_round_stats[STATS_PLEASURES] = 0

	// Gender count
	GLOB.scarlet_round_stats[STATS_MALE_POPULATION] = 0
	GLOB.scarlet_round_stats[STATS_FEMALE_POPULATION] = 0
	GLOB.scarlet_round_stats[STATS_OTHER_GENDER] = 0

	// Age count
	GLOB.scarlet_round_stats[STATS_ADULT_POPULATION] = 0
	GLOB.scarlet_round_stats[STATS_MIDDLEAGED_POPULATION] = 0
	GLOB.scarlet_round_stats[STATS_ELDERLY_POPULATION] = 0

	// Races count
	GLOB.scarlet_round_stats[STATS_ALIVE_NORTHERN_HUMANS] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_DWARVES] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_DARK_ELVES] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_WOOD_ELVES] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_HALF_ELVES] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_HALF_ORCS] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_GOBLINS] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_KOBOLDS] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_LIZARDS] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_AASIMAR] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_TIEFLINGS] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_HALFKIN] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_WILDKIN] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_GOLEMS] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_VERMINFOLK] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_DRACON] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_AXIAN] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_TABAXI] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_VULPS] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_LUPIANS] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_MOTHS] = 0
	GLOB.scarlet_round_stats[STATS_ALIVE_FAEKIN] = 0

	for(var/client/client in GLOB.clients)
		if(roundstart)
			GLOB.patron_follower_counts[client.prefs.selected_patron.name]++
		var/mob/living/living = client.mob
		if(!istype(living))
			continue
		if(!living.mind)
			continue
		if(living.stat == DEAD)
			continue
		if(!roundstart)
			if(living.patron)
				GLOB.patron_follower_counts[living.patron.name]++
				if(living.job == "Grand Duke")
					GLOB.scarlet_round_stats[STATS_MONARCH_PATRON] = "[living.patron.name]"
		if(living.mind.has_antag_datum(/datum/antagonist/bandit))
			GLOB.scarlet_round_stats[STATS_BANDITS]++
		if(living.mind.has_antag_datum(/datum/antagonist/werewolf))
			GLOB.scarlet_round_stats[STATS_WEREVOLVES]++
		if(living.mind.has_antag_datum(/datum/antagonist/vampire))
			GLOB.scarlet_round_stats[STATS_VAMPIRES]++
		if(living.mind.has_antag_datum(/datum/antagonist/zombie) || living.mind.has_antag_datum(/datum/antagonist/skeleton) || living.mind.has_antag_datum(/datum/antagonist/lich))
			GLOB.scarlet_round_stats[STATS_DEADITES_ALIVE]++
		if(ishuman(living))
			var/mob/living/carbon/human/human_mob = client.mob
			GLOB.scarlet_round_stats[STATS_TOTAL_POPULATION]++
			for(var/obj/item/clothing/neck/current_item in human_mob.get_equipped_items(TRUE))
				if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/aalloy, /obj/item/clothing/neck/roguetown/psicross/silver,	/obj/item/clothing/neck/roguetown/psicross/g))
					GLOB.scarlet_round_stats[STATS_PSYCROSS_USERS]++
					break
			switch(human_mob.pronouns)
				if(HE_HIM)
					GLOB.scarlet_round_stats[STATS_MALE_POPULATION]++
				if(HE_HIM_F)
					GLOB.scarlet_round_stats[STATS_MALE_POPULATION]++
				if(SHE_HER)
					GLOB.scarlet_round_stats[STATS_FEMALE_POPULATION]++
				if(SHE_HER_M)
					GLOB.scarlet_round_stats[STATS_FEMALE_POPULATION]++
				else
					GLOB.scarlet_round_stats[STATS_OTHER_GENDER]++
			switch(human_mob.age)
				if(AGE_ADULT)
					GLOB.scarlet_round_stats[STATS_ADULT_POPULATION]++
				if(AGE_MIDDLEAGED)
					GLOB.scarlet_round_stats[STATS_MIDDLEAGED_POPULATION]++
				if(AGE_OLD)
					GLOB.scarlet_round_stats[STATS_ELDERLY_POPULATION]++
			if(human_mob.is_noble())
				GLOB.scarlet_round_stats[STATS_ALIVE_NOBLES]++
			if(human_mob.mind.assigned_role in GLOB.garrison_positions)
				GLOB.scarlet_round_stats[STATS_ALIVE_GARRISON]++
			if(human_mob.mind.assigned_role in GLOB.church_positions)
				GLOB.scarlet_round_stats[STATS_ALIVE_CLERGY]++
			if((human_mob.mind.assigned_role in GLOB.yeoman_positions) || (human_mob.mind.assigned_role in GLOB.peasant_positions) || (human_mob.mind.assigned_role in GLOB.mercenary_positions))
				GLOB.scarlet_round_stats[STATS_ALIVE_TRADESMEN]++
			if(human_mob.has_flaw(/datum/charflaw/clingy))
				GLOB.scarlet_round_stats[STATS_CLINGY_PEOPLE]++
			if(human_mob.has_flaw(/datum/charflaw/addiction/alcoholic))
				GLOB.scarlet_round_stats[STATS_ALCOHOLICS]++
			if(human_mob.has_flaw(/datum/charflaw/addiction/junkie))
				GLOB.scarlet_round_stats[STATS_JUNKIES]++
			if(human_mob.has_flaw(/datum/charflaw/greedy))
				GLOB.scarlet_round_stats[STATS_GREEDY_PEOPLE]++

			// Races - proper alive checking (We have so fucking many, kill me..)
			if(ishumannorthern(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_NORTHERN_HUMANS]++
			if(isdwarf(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_DWARVES]++
			if(isdarkelf(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_DARK_ELVES]++
			if(iswoodelf(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_WOOD_ELVES]++
			if(ishalfelf(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_HALF_ELVES]++
			if(ishalforc(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_HALF_ORCS]++
			if(isgoblinp(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_GOBLINS]++
			if(iskobold(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_KOBOLDS]++
			if(islizard(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_LIZARDS]++
			if(isaasimar(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_AASIMAR]++
			if(istiefling(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_TIEFLINGS]++
			if(ishalfkin(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_HALFKIN]++
			if(iswildkin(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_WILDKIN]++
			if(isgolemp(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_GOLEMS]++
			if(isvermin(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_VERMINFOLK]++
			if(isdracon(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_DRACON]++
			if(isaxian(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_AXIAN]++
			if(istabaxi(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_TABAXI]++
			if(isvulp(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_VULPS]++
			if(islupian(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_LUPIANS]++
			if(ismoth(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_MOTHS]++
			if(isfaekin(human_mob))
				GLOB.scarlet_round_stats[STATS_ALIVE_FAEKIN]++

/// Returns total follower influence for the given storyteller
/datum/controller/subsystem/gamemode/proc/get_follower_influence(datum/storyteller/chosen_storyteller)
	var/datum/storyteller/initialized_storyteller = storytellers[chosen_storyteller]
	if(!initialized_storyteller)
		return 0

	var/follower_count = GLOB.patron_follower_counts[initialized_storyteller.name] || 0
	var/base_mod = initialized_storyteller.follower_modifier
	var/diminish_threshold = 4
	var/second_diminish_threshold = 9
	var/min_mod = 15
	var/second_min_mod = 10

	// Calculate total influence with diminishing returns
	var/total_influence = 0
	for(var/i in 1 to follower_count)
		if(i <= diminish_threshold)
			total_influence += base_mod
		else if(i <= second_diminish_threshold)
			total_influence += max(min_mod, base_mod - (i - diminish_threshold))
		else
			total_influence += max(second_min_mod, base_mod - (i - diminish_threshold))

	return total_influence

/// Returns influence value for a given storyteller for his given statistic
/datum/controller/subsystem/gamemode/proc/calculate_specific_influence(datum/storyteller/chosen_storyteller, statistic)
	var/datum/storyteller/initalized_storyteller = storytellers[chosen_storyteller]
	if(!initalized_storyteller)
		return

	if(!(statistic in initalized_storyteller.influence_factors))
		return

	var/influence = 0
	var/stat_value = GLOB.scarlet_round_stats[statistic]
	var/list/factors = initalized_storyteller.influence_factors[statistic]
	var/modifier = factors["points"]
	var/capacity = factors["capacity"]

	var/raw_contribution = stat_value * modifier
	influence = (modifier < 0) ? max(raw_contribution, capacity) : min(raw_contribution, capacity)

	return influence

/// Return total influence of the storyteller, which includes all his statistics and number of their followers
/datum/controller/subsystem/gamemode/proc/calculate_storyteller_influence(datum/storyteller/chosen_storyteller)
	var/datum/storyteller/initialized_storyteller = storytellers[chosen_storyteller]
	if(!initialized_storyteller)
		return 0

	var/total_influence = get_follower_influence(chosen_storyteller)
	for(var/influence_factor in initialized_storyteller.influence_factors)
		total_influence += calculate_specific_influence(chosen_storyteller, influence_factor)
	
	total_influence += initialized_storyteller.bonus_points

	return total_influence

/// Adjusts bonus points of the storyteller, which is added to their total influence
/proc/adjust_storyteller_influence(god_name, amount)
	for(var/storyteller_type in SSgamemode.storytellers)
		var/datum/storyteller/S = SSgamemode.storytellers[storyteller_type]
		if(S.name == god_name)
			S.bonus_points += amount
			break

/// Gets total storyteller influence by their name
/proc/get_storyteller_influence(god_name)
	for(var/storyteller_type in SSgamemode.storytellers)
		var/datum/storyteller/S = SSgamemode.storytellers[storyteller_type]
		if(S.name == god_name)
			return SSgamemode.calculate_storyteller_influence(S.type)
	return 0

#undef DEFAULT_STORYTELLER_VOTE_OPTIONS
#undef MAX_POP_FOR_STORYTELLER_VOTE
#undef ROUNDSTART_VALID_TIMEFRAME
