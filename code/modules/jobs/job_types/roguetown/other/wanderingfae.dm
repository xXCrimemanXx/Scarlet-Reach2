/datum/job/roguetown/wanderingfae
	title = "Wandering Fae"
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	allowed_races = list(/datum/species/faekin,)
	allowed_ages = ALL_AGES_LIST
	tutorial = "Whether you came to be from this land, or simply wandered here from afar, here now you are. Did you come to charm the land with your faerie blessings, or cause trouble?"
	outfit = /datum/outfit/job/roguetown/wanderingfae
	display_order = JDO_FAE
	min_pq = 10
	max_pq = null
	give_bank_account = FALSE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = TRUE
	wanderer_examine = TRUE
	whitelist_req = TRUE

/datum/outfit/job/roguetown/wanderingfae/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	pants = /obj/item/clothing/under/roguetown/tights/random
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/rogueweapon/huntingknife
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing , 2, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H?.mind.adjust_spellpoints(8)
		ADD_TRAIT(H, TRAIT_ARCYNE_T2, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/combat_jester.ogg'
