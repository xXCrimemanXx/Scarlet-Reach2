/datum/job/roguetown/orthodoxist
	title = "Orthodoxist"
	flag = ORTHODOXIST
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 3 // THREE GOONS!!
	spawn_positions = 3
	allowed_races = RACES_SECOND_CLASS_NO_GOLEM
	disallowed_races = list(
		/datum/species/lamia,
	)
	allowed_patrons = ALL_DIVINE_PATRONS
	tutorial = "Whether hand-picked by the Sovereignty of the Church or taken along through mere circumstance, you now serve as a loyal adherent to the Inquisitor's retinue. Descend into the darkness and - be it with a clenched fist or an opened palm - bring the inhumen towards the light: gift them salvation or damnation."
	selection_color = JCOLOR_INQUISITION
	outfit = null
	outfit_female = null
	display_order = JDO_ORTHODOXIST
	min_pq = 5
	max_pq = null
	round_contrib_points = 2
	advclass_cat_rolls = list(CTAG_INQUISITION = 20)
	wanderer_examine = FALSE
	advjob_examine = TRUE
	give_bank_account = 15

/datum/job/roguetown/orthodoxist/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
//They may now assist the Inquisitor. As is proper.
		H.verbs |= /mob/living/carbon/human/proc/faith_test
		H.verbs |= /mob/living/carbon/human/proc/torture_victim
