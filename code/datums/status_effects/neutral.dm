//entirely neutral or internal status effects go here


//Roguetown

/datum/status_effect/incapacitating/off_balanced
	id = "off_balanced"
	alert_type = /atom/movable/screen/alert/status_effect/off_balanced

/atom/movable/screen/alert/status_effect/off_balanced
	name = "Off Balanced"
	desc = ""
	icon_state = "off_balanced"

//ENDROGUE

/datum/status_effect/sigil_mark //allows the affected target to always trigger sigils while mindless
	id = "sigil_mark"
	duration = -1
	alert_type = null
	var/stat_allowed = DEAD //if owner's stat is below this, will remove itself

/datum/status_effect/sigil_mark/tick()
	if(owner.stat < stat_allowed)
		qdel(src)

/datum/status_effect/crusher_damage //tracks the damage dealt to this mob by kinetic crushers
	id = "crusher_damage"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	var/total_damage = 0

/atom/movable/screen/alert/status_effect/in_love
	name = "In Love"
	desc = ""
	icon_state = "in_love"

/datum/status_effect/in_love
	id = "in_love"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/in_love
	var/mob/living/date

/datum/status_effect/in_love/on_creation(mob/living/new_owner, mob/living/love_interest)
	. = ..()
	if(.)
		date = love_interest
	linked_alert.desc = ""

/datum/status_effect/in_love/tick()
	if(date)
		new /obj/effect/temp_visual/love_heart/invisible(get_turf(date.loc), owner)


/datum/status_effect/throat_soothed
	id = "throat_soothed"
	duration = 60 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/status_effect/throat_soothed/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SOOTHED_THROAT, "[STATUS_EFFECT_TRAIT]_[id]")

/datum/status_effect/throat_soothed/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SOOTHED_THROAT, "[STATUS_EFFECT_TRAIT]_[id]")

/datum/status_effect/bounty
	id = "bounty"
	status_type = STATUS_EFFECT_UNIQUE
	var/mob/living/rewarded

/datum/status_effect/bounty/on_creation(mob/living/new_owner, mob/living/caster)
	. = ..()
	if(.)
		rewarded = caster

/datum/status_effect/bounty/on_apply()
	to_chat(owner, span_boldnotice("I hear something behind you talking...</span> <span class='notice'>I have been marked for death by [rewarded]. If you die, they will be rewarded."))
	playsound(owner, 'sound/blank.ogg', 75, FALSE)
	return ..()

/datum/status_effect/bounty/tick()
	if(owner.stat == DEAD)
		rewards()
		qdel(src)

/datum/status_effect/bounty/proc/rewards()
	if(rewarded && rewarded.mind && rewarded.stat != DEAD)
		to_chat(owner, span_boldnotice("I hear something behind you talking...</span> <span class='notice'>Bounty claimed."))
		playsound(owner, 'sound/blank.ogg', 75, FALSE)
		to_chat(rewarded, span_greentext("I feel a surge of mana flow into you!"))
		for(var/obj/effect/proc_holder/spell/spell in rewarded.mind.spell_list)
			spell.charge_counter = spell.recharge_time
			spell.update_icon()
		rewarded.adjustBruteLoss(-25)
		rewarded.adjustFireLoss(-25)
		rewarded.adjustToxLoss(-25)
		rewarded.adjustOxyLoss(-25)
		rewarded.adjustCloneLoss(-25)

/datum/status_effect/bugged //Lets another mob hear everything you can
	id = "bugged"
	duration = -1
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null
	var/mob/living/listening_in

/datum/status_effect/bugged/on_apply(mob/living/new_owner, mob/living/tracker)
	. = ..()
	if (.)
		RegisterSignal(new_owner, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hearing))

/datum/status_effect/bugged/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)

/datum/status_effect/bugged/proc/handle_hearing(datum/source, list/hearing_args)
	listening_in.show_message(hearing_args[HEARING_MESSAGE])

/datum/status_effect/bugged/on_creation(mob/living/new_owner, mob/living/tracker)
	. = ..()
	if(.)
		listening_in = tracker

/datum/status_effect/ugotmail
	id = "mail"
	alert_type = /atom/movable/screen/alert/status_effect/ugotmail

/atom/movable/screen/alert/status_effect/ugotmail
	name = "Mail"
	desc = "I have a letter waiting for me at the HERMES."
	icon_state = "mail"

//Xylix Gambling
/datum/status_effect/wheel
	id = "lucky(?)"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3000 //Lasts five minutes
	var/wheeleffect
	
/datum/status_effect/wheel/on_apply()
	. = ..()
	wheeleffect = rand(-5,5)
	owner.change_stat("fortune", wheeleffect)
	switch(wheeleffect)
		if(-5 to -1)
			to_chat(owner, span_boldnotice("My heart sinks, I feel as though I've lost something!"))
		if(0)
			to_chat(owner, span_boldnotice("My heart beats, I feel as though nothing has changed at all..."))
		if(1 to 5)
			to_chat(owner, span_boldnotice("My heart flutters, I feel as though I won the lottery!"))

/datum/status_effect/wheel/on_remove()
	. = ..()
	owner.change_stat("fortune", -wheeleffect)

/atom/movable/screen/alert/status_effect/wheel
	name = "Lucky(?)"
	desc = "I feel different since my fortune was changed..."
	icon_state = "asleep"

/atom/movable/screen/alert/status_effect/compliance
	name = "Compliant"
	desc = "I am currently not resisting any grabs or breakout attempts against me."
	icon_state = "buckled" // this really needs its own icon

// Sadly we can't rely on /atom/movable/screen/Click() to return TRUE at all.
// We MUST use the shitcode method of copypasting if both examine and toggle are to work properly.
/atom/movable/screen/alert/status_effect/compliance/Click(location, control, params)
	if(!usr || !usr.client)
		return FALSE
	var/mob/user = usr
	var/paramslist = params2list(params)
	if(paramslist["shift"] && paramslist["left"]) // screen objects don't do the normal Click() stuff so we'll cheat
		examine_ui(user)
		return FALSE
	var/mob/living/L = usr
	if(!istype(L))
		return
	L.playsound_local(L, 'sound/misc/click.ogg', 100)
	L.toggle_compliance()

/datum/status_effect/compliance
	id = "compliance"
	alert_type = /atom/movable/screen/alert/status_effect/compliance

/datum/status_effect/carebox
	id = "carebox"
	alert_type = /atom/movable/screen/alert/status_effect/carebox

/atom/movable/screen/alert/status_effect/carebox
	name = "Package"
	desc = "I have a parcel waiting for me at the HERMES."
	icon_state = "mail"