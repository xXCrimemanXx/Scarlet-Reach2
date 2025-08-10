/datum/advclass/mercenary/atgervi
	name = "Atgervi"
	tutorial = "Fear. What more can you feel when a stranger tears apart your friend with naught but hand and maw? What more can you feel when your warriors fail to slay an invader? What more could you ask for, when hiring a mercenary?"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/atgervi
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_OUTLANDER)
	classes = list("Varangian" = "You are a Varangian of the Gronn Highlands. Warrior-Traders whose exploits into the Raneshen Empire will be forever remembered by historians.",
					"Shaman" = "You are a Shaman of the Fjall, The Northern Empty. Savage combatants who commune with the Ecclesical Beast gods through ritualistic violence, rather than idle prayer.")

/datum/outfit/job/roguetown/mercenary/atgervi/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/inhumen/zizo) || istype(H.patron, /datum/patron/inhumen/matthios) || istype(H.patron, /datum/patron/inhumen/graggar) || istype(H.patron, /datum/patron/inhumen/baotha)))
		to_chat(H, span_warning("My former deity has abandoned me.. Graggar is my new master."))
		H.set_patron(/datum/patron/inhumen/graggar)
	// CLASS ARCHETYPES
	H.adjust_blindness(-3)
	var/classes = list("Varangian","Shaman")
	var/classchoice = input("Choose your archetypes", "Available archetypes") as anything in classes

	switch(classchoice)
		if("Varangian")
			H.set_blindness(0)
			to_chat(H, span_warning("You are a Varangian of the Gronn Highlands. Warrior-Traders whose exploits into the Raneshen Empire will be forever remembered by historians."))
			H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)	
			H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)

			H.change_stat("strength", 2)	
			H.change_stat("endurance", 3)
			H.change_stat("constitution", 3)
			H.change_stat("perception", 1)
			H.change_stat("speed", -1)	

			head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi
			gloves = /obj/item/clothing/gloves/roguetown/angle/atgervi
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi	//This is in armor and not shirt just to avoid seeing titty through it.
			pants = /obj/item/clothing/under/roguetown/trou/leather/atgervi
			wrists = /obj/item/clothing/wrists/roguetown/bracers
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
			backr = /obj/item/rogueweapon/shield/atgervi
			backl = /obj/item/storage/backpack/rogue/satchel/black
			beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
			belt = /obj/item/storage/belt/rogue/leather
			neck = /obj/item/storage/belt/rogue/pouch/coins/poor
			beltl = /obj/item/flashlight/flare/torch

			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = FALSE, devotion_limit = CLERIC_REQ_2)	//Capped to T1 miracles.

			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)	
			H.cmode_music = 'sound/music/combat_vagarian.ogg'
		if("Shaman")
			H.set_blindness(0)
			to_chat(H, span_warning("You are a Shaman of the Fjall, The Northern Empty. Savage combatants who commune with the Ecclesical Beast gods through ritualistic violence, rather than idle prayer."))
			H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
			H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)
			H.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE)
			H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/evil/inhumenblade)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/message)
			H.change_stat("strength", 3) 
			H.change_stat("endurance", 2)
			H.change_stat("constitution", 2)
			H.change_stat("intelligence", -1)
			H.change_stat("perception", -1)
			H.change_stat("speed", 1)

			head = /obj/item/clothing/head/roguetown/helmet/leather/saiga/atgervi
			gloves = /obj/item/clothing/gloves/roguetown/plate/atgervi
			armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			pants = /obj/item/clothing/under/roguetown/trou/leather/atgervi
			wrists = /obj/item/clothing/wrists/roguetown/bracers
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
			backr = /obj/item/storage/backpack/rogue/satchel/black
			belt = /obj/item/storage/belt/rogue/leather
			neck = /obj/item/storage/belt/rogue/pouch/coins/poor
			beltl = /obj/item/flashlight/flare/torch

			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.

			ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC) //No weapons. Just beating them to death as God intended.
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC) //Their entire purpose is to rip people apart with their hands and teeth. I don't think they'd be too preturbed to see someone lose a limb.
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC) //Either no armor, or light armor. So dodge expert.
			ADD_TRAIT(H, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
			H.cmode_music = 'sound/music/combat_shaman2.ogg'

	H.grant_language(/datum/language/gronnic)
	backpack_contents = list(/obj/item/roguekey/mercenary, /obj/item/rogueweapon/huntingknife)


/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi
	name = "vagarian hauberk"
	desc = "The pride of the Hammerhold mercenaries a well crafted blend of chain and leather into a dense protective coat."
	icon_state = "atgervi_raider_mail"
	item_state = "atgervi_raider_mail"

/obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi
	name = "shamanic coat"
	desc = "A furred protective coat, Often made by hand it embodies the second trial of the Iskarn Shamans. To honor the leopard is too desire for more."
	icon_state = "atgervi_shaman_coat"
	item_state = "atgervi_shaman_coat"

/obj/item/clothing/under/roguetown/trou/leather/atgervi
	name = "fur pants"
	desc = "Thick fur pants made to endure the coldest winds, offering a share of protection from fang and claw of beast or men alike."
	icon_state = "atgervi_pants"
	item_state = "atgervi_pants"
	flags_inv = HIDECROTCH|HIDEBOOB
	
/obj/item/clothing/gloves/roguetown/angle/atgervi
	name = "fur-lined leather gloves"
	desc = "Thick, padded gloves made for the harshest of climates, and wildest of beasts encountered in the untamed lands."
	icon_state = "atgervi_raider_gloves"
	item_state = "atgervi_raider_gloves"

/obj/item/clothing/gloves/roguetown/plate/atgervi
	name = "beast claws"
	desc = "A menacing pair of plated claws, A closely protected tradition of the Shamans. The four claws embodying the four great beasts. Decorated with symbols of the gods they praise and the Gods they reject."
	icon_state = "atgervi_shaman_gloves"
	item_state = "atergvi_shaman_gloves"

/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi
	name = "owl helmet"
	desc = "A carefully forged steel helmet in the shape of an owl's face, with added chain to cover the face and neck against many blows."
	icon_state = "atgervi_raider"
	item_state = "atgervi_raider"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/atgervi.dmi'
	block2add = null
	worn_x_dimension = 32
	worn_y_dimension = 48

/obj/item/clothing/head/roguetown/helmet/leather/saiga/atgervi
	name = "moose hood"
	desc = "A deceptively strong hood of hide with a pair of large heavy antlers. It is the reward of the fourth trial of the Iskarn Shamans, To slay a Grinning moose in the final hunt alone and fashion a hood from it's head."
	icon_state = "atgervi_shaman"
	item_state = "atgervi_shaman"
	flags_inv = HIDEEARS|HIDEFACE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/atgervi.dmi'
	flags_inv = HIDEEARS
	bloody_icon = 'icons/effects/blood64.dmi'
	worn_x_dimension = 32
	worn_y_dimension = 48
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/obj/item/clothing/shoes/roguetown/boots/leather/atgervi
	name = "atgervi leather boots"
	desc = "A pair of strong leather boots, designed to endure battle and the chill of the frozen north both."
	icon_state = "atgervi_boots"
	item_state = "atgervi_boots"

/obj/item/rogueweapon/shield/atgervi
	name = "kite shield"
	desc = "A large but light wooden shield with a steel boss in the center to deflect blows more easily."
	icon_state = "atgervi_shield"
	item_state = "atgervi_shield"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	force = 15
	throwforce = 10
	dropshrink = 0.8
	coverage = 80
	attacked_sound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 250
	experimental_inhand = FALSE

/obj/item/rogueweapon/shield/atgervi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("onback")
				return list("shrink" = 0.7,"sx" = -17,"sy" = -15,"nx" = -15,"ny" = -15,"wx" = -12,"wy" = -15,"ex" = -18,"ey" = -15,"nturn" = 0,"sturn" = 0,"wturn" = 180,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 1,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
	name = "Bearded Axe"
	desc = "A large axe easily wielded in one hand or two, With a large hooked axehead to tearing into flesh and armor and ripping it away brutally."
	icon_state = "atgervi_axe"
	item_state = "atgervi_axe"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	wlength = WLENGTH_LONG
	experimental_onhip = TRUE

/obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -9,"sy" = -8,"nx" = 9,"ny" = -7,"wx" = -7,"wy" = -8,"ex" = 3,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 2,"sy" = -8,"nx" = -6,"ny" = -3,"wx" = 3,"wy" = -4,"ex" = 4,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -44,"sturn" = 45,"wturn" = 47,"eturn" = 33,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.6,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 180,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
