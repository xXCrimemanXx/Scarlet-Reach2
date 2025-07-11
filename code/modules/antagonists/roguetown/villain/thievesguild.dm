// Thieves' Guild antagonist for RT

/datum/antagonist/thievesguild
	name = "Thieves' Guild"
	roundend_category = "thievesguild"
	antagpanel_category = "Roguetown"
	show_name_in_check_antagonists = TRUE
	can_coexist_with_others = TRUE
	confess_lines = list(
		"I am a member of the Thieves' Guild!",
		"I work for the underground crime syndicate!",
		"I am a thief and proud of it!",
		"The Thieves' Guild has chosen me as their operative!",
		"I am a criminal mastermind in training!",
		"I serve the shadowy organization known as the Thieves' Guild!",
		"I am a rogue and a scoundrel!",
		"The Thieves' Guild has recruited me for their schemes!",
		"I am a member of the secret crime network!",
		"I work in the shadows for the Thieves' Guild!"
	)

/datum/antagonist/thievesguild/on_gain()
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild on_gain() called for [owner?.key || "unknown"]</span>")
	..()
	if(owner && owner.current)
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Granting Thieves' Cant to [owner.current.real_name]</span>")
		// Grant Thieves' Cant
		owner.current.grant_language(/datum/language/thievescant)
		// Assign objective if not already present
		if(!objectives.len)
			to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Creating objective for [owner.current.real_name]</span>")
			var/datum/objective/thieves_guild_objective/obj = new /datum/objective/thieves_guild_objective(owner = owner)
			objectives += obj
		
		// Send operative message with objective details
		to_chat(owner.current, span_notice("You have been chosen as an operative of a secret crime guild. Carry out your orders quietly and avoid suspicion."))
		
		// Display the objective
		if(objectives.len)
			var/datum/objective/obj = objectives[1]
			to_chat(owner.current, span_danger("Your objective: [obj.explanation_text]"))
			to_chat(owner.current, span_notice("You can view your objective again in the Notes tab under Memory."))
			
			// Add objective to memory
			owner.store_memory("Thieves' Guild Objective: [obj.explanation_text]")
		
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild setup complete for [owner.current.real_name]</span>")
	else
		to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild on_gain() - owner or owner.current is null!</span>")

/datum/antagonist/thievesguild/apply_innate_effects(mob/living/mob_override)
	to_chat(world, "<span class='adminnotice'><b>DEBUG:</b> Thieves' Guild apply_innate_effects() called</span>")
	..()
	if(mob_override)
		mob_override.grant_language(/datum/language/thievescant)

/datum/antagonist/thievesguild/remove_innate_effects(mob/living/mob_override)
	..()
	if(mob_override)
		mob_override.remove_language(/datum/language/thievescant) 
