// Wretch, soft antagonists. Giving them 9 points as stat (matching mercs) on average since they're a driving antagonist on AP or assistant antagonist. 
/datum/job/roguetown/wretch
	title = "Wretch"
	flag = WRETCH
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 10
	spawn_positions = 10
	allowed_races = RACES_ALL_KINDS
	tutorial = "Somewhere in your lyfe, you fell to the wrong side of civilization. Hounded by the consequences of your actions, you now threaten the peace of those who still heed the authority that condemned you."
	outfit = null
	outfit_female = null
	display_order = JDO_WRETCH
	show_in_credits = FALSE
	min_pq = 20
	max_pq = null

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_WRETCH = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = TRUE
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(/datum/virtue/heretic/zchurch_keyholder) //all wretch classes automatically get this

/datum/job/roguetown/wretch/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")

		if(GLOB.adventurer_hugbox_duration)
			addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_start)), 1)

// Proc for wretch to select a bounty
/proc/wretch_select_bounty(mob/living/carbon/human/H)

	var/bounty_poster = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in list("The Justiciary of Scarlet Reach", "The Grenzelhoftian Holy See", "The Otavan Holy See")
	if(bounty_poster == "The Justiciary of Scarlet Reach")
		GLOB.outlawed_players += H.real_name
	else
		GLOB.excommunicated_players += H.real_name
	// Felinid said we should gate it at 100 or so on at the lowest, so that wretch cannot ezmode it.
	var/bounty_severity = input(H, "How severe are your crimes?", "Bounty Amount") as anything in list("Misdeed", "Harm towards lyfe", "Horrific atrocities")
	var/bounty_total = rand(100, 400) // Just in case
	switch(bounty_severity)
		if("Misdeed")
			bounty_total = rand(100, 200)
		if("Harm towards lyfe")
			bounty_total = rand(200, 300)
		if("Horrific atrocities")
			bounty_total = rand(300, 400) // Let's not make it TOO profitable
	var/my_crime = input(H, "What is your crime?", "Crime") as text|null
	if (!my_crime)
		my_crime = "crimes against the Crown"
	add_bounty(H.real_name, bounty_total, FALSE, my_crime, bounty_poster)
	to_chat(H, span_danger("You are an Antagonistic role. You are expected, by choosing to be a wretch, to sow chaos and division amongst the town while driving a story. Failure to use proper gravitas for this may get you punished for Low Role Play standards."))
