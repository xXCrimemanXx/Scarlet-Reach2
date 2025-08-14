/datum/anvil_recipe/weapons
	abstract_type = /datum/anvil_recipe/weapons
	appro_skill = /datum/skill/craft/weaponsmithing  // inheritance yay !!
	craftdiff = 1
	i_type = "Weapons"

// and Purified Decrepit Alloy

/datum/anvil_recipe/weapons/aalloy/flail
	name = "Flail"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/flail/aflail
	craftdiff = 0


/datum/anvil_recipe/weapons/paalloy/flail/
	name = "Flail"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/flail/sflail/paflail
	craftdiff = 0


/datum/anvil_recipe/weapons/aalloy/dagger
	name = "Dagger"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/huntingknife/idagger/adagger
	craftdiff = 0


/datum/anvil_recipe/weapons/paalloy/dagger
	name = "Dagger"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
	craftdiff = 0

/datum/anvil_recipe/weapons/aalloy/knuckles
	name = "Knuckles"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/knuckles/aknuckles
	craftdiff = 0


/datum/anvil_recipe/weapons/paalloy/knuckles
	name = "Knuckles"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/knuckles/paknuckles
	craftdiff = 0

/datum/anvil_recipe/weapons/aalloy/gladius
	name = "Gladius"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/sword/iron/short/gladius/agladius
	craftdiff = 0


/datum/anvil_recipe/weapons/paalloy/gladius
	name = "Gladius"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/sword/iron/short/gladius/pagladius
	craftdiff = 0

/datum/anvil_recipe/weapons/aalloy/shortsword
	name = "Shortsword"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/sword/iron/short/ashort
	craftdiff = 0


/datum/anvil_recipe/weapons/paalloy/shortsword
	name = "Shortsword"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/sword/short/pashortsword
	craftdiff = 0

/datum/anvil_recipe/weapons/aalloy/khopesh
	name = "Khopesh"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/sword/sabre/alloy
	craftdiff = 0


/datum/anvil_recipe/weapons/paalloy/khopesh
	name = "Khopesh"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/sword/sabre/palloy
	craftdiff = 0

/datum/anvil_recipe/weapons/aalloy/handaxe
	name = "Axe"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/aaxe
	craftdiff = 0


/datum/anvil_recipe/weapons/paalloy/handaxe
	name = "Axe"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
	craftdiff = 0

/datum/anvil_recipe/weapons/aalloy/mace
	name = "Mace"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/mace/alloy
	craftdiff = 0


/datum/anvil_recipe/weapons/paalloy/mace
	name = "Mace"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/mace/steel/palloy
	craftdiff = 0

/datum/anvil_recipe/weapons/aalloy/warhammer
	name = "Warhammer"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/mace/warhammer/alloy
	craftdiff = 0


/datum/anvil_recipe/weapons/paalloy/warhammer
	name = "Warhammer"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/paalloy
	craftdiff = 0

/datum/anvil_recipe/weapons/aalloy/tossblade
	name = "Tossblades x4"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/aalloy
	craftdiff = 0
	createditem_num = 4

/datum/anvil_recipe/weapons/paalloy/tossblade
	name = "Tossblades x4"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel/palloy
	craftdiff = 0
	createditem_num = 4

/datum/anvil_recipe/weapons/aalloy/gsw
	name = "Greatsword (+2 Alloy)"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/greatsword/aalloy
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/ingot/aalloy)
	craftdiff = 3


/datum/anvil_recipe/weapons/paalloy/gsw
	name = "Greatsword (+2 Purified Alloy)"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/greatsword/paalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/ingot/purifiedaalloy)
	craftdiff = 4


/datum/anvil_recipe/weapons/aalloy/bardiche
	name = "Bardiche (+1 log, +1 Alloy)"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/rogueweapon/halberd/bardiche/aalloy
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	craftdiff = 0


/datum/anvil_recipe/weapons/paalloy/bardiche
	name = "Bardiche (+1 log, +1 Purified Alloy)"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/rogueweapon/halberd/bardiche/paalloy
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	craftdiff = 0

/datum/anvil_recipe/weapons/aalloy/grandmace
	name = "Grand Mace (+1 Alloy, +1 Small Log)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/aalloy
	craftdiff = 2

/datum/anvil_recipe/weapons/paalloy/grandmace
	name = "Grand Mace (+1 Purified Alloy, +1 Small Log)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel/paalloy
	craftdiff = 3

/datum/anvil_recipe/weapons/aalloy/spear
	name = "Spear (+1 Small Log)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/aalloy
	craftdiff = 0

/datum/anvil_recipe/weapons/paalloy/spear
	name = "Spear (+1 Small Log)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/paalloy
	craftdiff = 0

/datum/anvil_recipe/weapons/aalloy/javelin
	name = "Javelin x2 (+1 Small Log)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/aalloy
	createditem_num = 2
	craftdiff = 1

/datum/anvil_recipe/weapons/paalloy/javelin
	name = "2x Javelin (+1 Small Log)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel/paalloy
	createditem_num = 2
	craftdiff = 1


/// COPPER WEAPONS
/datum/anvil_recipe/weapons/copper/caxe
	name = "Hatchet (+1 Copper)"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe/copper
	craftdiff = 0

/datum/anvil_recipe/weapons/copper/cbludgeon
	name = "Bludgeon (+1 Stick)"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel/copper
	craftdiff = 0

/datum/anvil_recipe/weapons/copper/cdagger
	name = "Knives x2"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/rogueweapon/huntingknife/copper
	createditem_num = 2
	craftdiff = 0

/datum/anvil_recipe/weapons/copper/cmesser
	name = "Messer"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/rogueweapon/sword/iron/messer/copper
	craftdiff = 0

/datum/anvil_recipe/weapons/copper/cspears
	name = "Spears x2 (+ 1 Small Log)"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/stone/copper
	createditem_num = 2
	craftdiff = 0

/datum/anvil_recipe/weapons/copper/crhomphaia
	name = "Rhomphaia (+ 1 Bar)"
	appro_skill = /datum/skill/craft/weaponsmithing
	req_bar = /obj/item/ingot/copper
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia/copper
	craftdiff = 0

/// IRON WEAPONS

/datum/anvil_recipe/weapons/iron/sword
	name = "Sword"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/sword/iron

/datum/anvil_recipe/weapons/iron/swordshort
	name = "Short sword"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/sword/iron/short
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/messer
	name = "Messer"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/sword/iron/messer
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/dagger
	name = "Dagger"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/huntingknife/idagger
	createditem_num = 1
	craftdiff = 0

/datum/anvil_recipe/weapons/ironflail
	name = "Flail"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/flail

/datum/anvil_recipe/weapons/iron/huntknife
	name = "Knife, Hunting"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/huntingknife
	createditem_num = 1

/datum/anvil_recipe/weapons/iron/zweihander
	name = "Zweihander (+2 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/zwei
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/axe
	name = "Axe (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/greataxe
	name = "Greataxe (+1 Iron, +1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/cudgel
	name = "Cudgel (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/mace
	name = "Mace (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/spear
	name = "Spear (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear
	craftdiff = 0

/datum/anvil_recipe/weapons/iron/bardiche
	name = "Bardiche (+1 Iron, +1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd/bardiche
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/lucerne
	name = "Lucerne (+1 Iron, +1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak/lucerne
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/polemace
	name = "Goedendag (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden

/datum/anvil_recipe/weapons/iron/tossblade
	name = "Tossblades x4"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife
	craftdiff = 0
	createditem_num = 4

/datum/anvil_recipe/weapons/iron/javelin
	name = "Iron Javelin x2 (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin
	createditem_num = 2
	craftdiff = 1

/// STEEL WEAPONS

/datum/anvil_recipe/weapons/steel/dagger
	name = "Dagger"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel
	createditem_num = 1

/datum/anvil_recipe/weapons/steel/daggerparrying
	name = "Parrying Dagger (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/katar
	name = "Katar"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/katar
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/punchdagger
	name = "Punch Dagger"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/katar/punchdagger
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/steelknuckle
	name = "Knuckle"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/knuckles
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/rapier
	name = "Rapier"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/rapier
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/cutlass
	name = "Cutlass"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/cutlass
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/swordshort
	name = "Short Sword"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/short
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/falchion
	name = "Falchion"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/falchion
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/messer
	name = "Messer"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/short/messer
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/sword
	name = "Sword"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/saber
	name = "Sabre"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/sabre
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/flail
	name = "Flail"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/flail/sflail
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/longsword
	name = "Longsword (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/kriegmesser
	name = "Kriegmesser (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/battleaxe
	name = "Battle Axe (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/stoneaxe/battle
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/combatknife
	name = "Combat Knife (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/combat
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/mace
	name = "Mace (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/steel
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/greatsword
	name = "Greatsword (+2 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/steelzweihander
	name = "Zweihander (+2 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword/grenz
	craftdiff = 4

/datum/anvil_recipe/weapons/estoc
	name = "Estoc (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/estoc
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/axe
	name = "Axe (+1 Stick)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/pulaski
	name = "Pulaski axe (+1 Stick)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/pick

/datum/anvil_recipe/weapons/steel/greataxe
	name = "Greataxe (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/greataxe/doublehead
	name = "Double-Headed Greataxe (+2 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel/doublehead
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/billhook
	name = "Billhook (+1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/billhook
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/halberd
	name = "Halberd (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/eaglebeak
	name = "Eagle's Beak (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/grandmace
	name = "Grand Mace (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/partizan
	name = "Partizan (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/partizan
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/naginata
	name = "Naginata (+1 Big Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/) //looong spear
	created_item = /obj/item/rogueweapon/spear/naginata
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/boarspear
	name = "Boar Spear (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/boar
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/lance
	name = "Lance (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/lance
	craftdiff = 4

/datum/anvil_recipe/weapons/steel/tossblade
	name = "Tossblades x4"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel
	craftdiff = 0
	createditem_num = 4

/datum/anvil_recipe/weapons/steel/javelin
	name = "Javelin x2 (+1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel
	createditem_num = 2
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/fishspear
	name = "Fishing Spear (+1 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/fishspear
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/rhomphaia
	name = "Rhomphaia (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/falx
	name = "Falx"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/falx
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/glaive
	name = "Glaive (+2 Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd/glaive

/// UPGRADED WEAPONS

//GOLD
/datum/anvil_recipe/weapons/decsword
	name = "Decorated Sword (+1 Steel Sword)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword)
	created_item = /obj/item/rogueweapon/sword/decorated
	craftdiff = 2

/datum/anvil_recipe/weapons/decsaber
	name = "Decorated Sabre (+1 Steel Sabre)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword/sabre)
	created_item = /obj/item/rogueweapon/sword/sabre/dec
	craftdiff = 2

/datum/anvil_recipe/weapons/decrapier
	name = "Decorated Rapier (+1 Steel Rapier)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword/rapier)
	created_item = /obj/item/rogueweapon/sword/rapier/dec
	craftdiff = 2

/datum/anvil_recipe/weapons/declongsword
	name = "Decorated Longsword (+1 Longsword)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/rogueweapon/sword/long)
	created_item = /obj/item/rogueweapon/sword/long/dec
	craftdiff = 2

// SILVER
/datum/anvil_recipe/weapons/silver/elfsaber
	name = "Elvish Saber (+1 Silver)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/sabre/elf
	craftdiff = 3

/datum/anvil_recipe/weapons/silver/elfdagger
	name = "Elvish Dagger"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish
	craftdiff = 3

/datum/anvil_recipe/weapons/silver/dagger
	name = "Dagger"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver
	craftdiff = 2

/datum/anvil_recipe/weapons/silver/sword
	name = "Sword (+1 Silver)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/silver
	craftdiff = 3

/datum/anvil_recipe/weapons/silver/waraxe
	name = "War Axe (+1 Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/silver
	craftdiff = 3

/datum/anvil_recipe/weapons/silver/warhammer
	name = "War Hammer (+1 Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/silver
	craftdiff = 3

/datum/anvil_recipe/weapons/silver/tossblade
	name = "Tossblades x4"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/psydon
	craftdiff = 3
	createditem_num = 4

/datum/anvil_recipe/weapons/silver/javelin
	name = "avelin (+1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/silver
	craftdiff = 3

// ------ BRONZE ------

/datum/anvil_recipe/weapons/gladius
	name = "Gladius"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/sword/iron/short/gladius
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/spear
	name = "Spear (+1 Bronze, +1 Small Log)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/bronze
	craftdiff = 0

/datum/anvil_recipe/weapons/bronze/bronzeknuckle
	name = "Knuckle"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/knuckles/bronzeknuckles
	craftdiff = 2

/// SHIELDS
/datum/anvil_recipe/weapons/steel/kiteshield
	name = "Kite Shield (+1 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal
	craftdiff = 3

/datum/anvil_recipe/weapons/alloy/shield
	name = "Shield (+1 Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/ingot/aalloy, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/alloy
	craftdiff = 1

/datum/anvil_recipe/weapons/alloy/shield
	name = "Shield (+1 Purified Alloy, +1 Cured Leather)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/ingot/purifiedaalloy, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/palloy
	craftdiff = 3

/datum/anvil_recipe/weapons/iron/towershield
	name = "Tower Shield (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/shield/tower
	craftdiff = 2

/datum/anvil_recipe/weapons/steel/buckler
	name = "Buckler (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/shield/buckler
	craftdiff = 2

/datum/anvil_recipe/weapons/iron/roundshield
	name = "Shield (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/shield/iron
	craftdiff = 2

/// CROSSBOWS
/datum/anvil_recipe/weapons/steel/xbow
	name = "Crossbow (+1 Small Log, +1 Fiber)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/natural/fibers)
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow

/datum/anvil_recipe/weapons/iron/bolts
	name = "Crossbow Bolts 10x (+2 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/aalloy/bolts
	name = "Crossbow Bolts 10x (+2 Stick)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/aalloy
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/paalloy/bolts
	name = "Crossbow Bolts 10x (+2 Stick)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/paalloy
	createditem_num = 10
	i_type = "Ammo"

/// BOWS
/datum/anvil_recipe/weapons/iron/arrows
	name = "Broadhead Arrows 10x (+2 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron
	createditem_num = 10
	i_type = "Ammo"
	craftdiff = 1

/datum/anvil_recipe/weapons/aalloy/arrows
	name = "Broadhead Arrows 10x (+2 Stick)"
	req_bar = /obj/item/ingot/aalloy
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy
	createditem_num = 10
	i_type = "Ammo"
	craftdiff = 1

/datum/anvil_recipe/weapons/steel/arrows
	name = "Bodkin Arrows 10x (+2 Stick)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel
	createditem_num = 10
	i_type = "Ammo"
	craftdiff = 2

/datum/anvil_recipe/weapons/paalloy/arrows
	name = "Bodkin Arrows x10 (+2 Stick)"
	req_bar = /obj/item/ingot/purifiedaalloy
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel/paalloy
	createditem_num = 10
	i_type = "Ammo"
	craftdiff = 2

/// SLINGS
/datum/anvil_recipe/weapons/iron/slingbullets
	name = "Sling Bullets x10"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron
	createditem_num = 10
	i_type = "Ammo"
	craftdiff = 0

/datum/anvil_recipe/weapons/aalloy/slingbullets
	name = "Sling Bullets x10"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/aalloy
	createditem_num = 10
	i_type = "Ammo"
	craftdiff = 0

/datum/anvil_recipe/weapons/paalloy/slingbullets
	name = "Sling Bullets x10"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/paalloy
	createditem_num = 10
	i_type = "Ammo"
	craftdiff = 0

//Rarity
/datum/anvil_recipe/valuables/steel/execution
	name = "Execution Sword (+1 Steel, +1 Iron)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/exe

// BLACKSTEEL

/datum/anvil_recipe/weapons/blackflamb
	name = "Flamberge (+1 Blacksteel, +1 Ruby)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/ruby)
	created_item = /obj/item/rogueweapon/sword/long/blackflamb
	craftdiff = 5


/datum/anvil_recipe/weapons/swarhammer
	name = "Warhammer (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel
	craftdiff = 2

/datum/anvil_recipe/weapons/warhammer
	name = "Warhammer (+1 Stick)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/warhammer

//Church Weapons forged from Holy Steel

/datum/anvil_recipe/weapons/holy/malum_sword
	name = "Forgefiend (+1 H. Steel)"
	req_bar = /obj/item/ingot/steelholy
	craftdiff = 3
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/sword/long/malumflamm
/*
/datum/anvil_recipe/weapons/holy/abyssor_katar
	name = "Barotrauma"
	req_bar = /obj/item/ingot/steelholy
	craftdiff = 3
	created_item = /obj/item/rogueweapon/katar/abyssor

/datum/anvil_recipe/weapons/holy/astrata_exe
	name = "Solar Judgement (+1 H. Steel)"
	req_bar = /obj/item/ingot/steelholy
	craftdiff = 3
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/sword/long/exe/astrata

/datum/anvil_recipe/weapons/holy/noc_kopesh
	name = "Moonlight Kopesh"
	req_bar = /obj/item/ingot/steelholy
	craftdiff = 3
	created_item = /obj/item/rogueweapon/sword/sabre/nockhopesh

/datum/anvil_recipe/weapons/holy/necra_flail
	name = "Swift End"
	req_bar = /obj/item/ingot/steelholy
	craftdiff = 3
	created_item = /obj/item/rogueweapon/flail/necraflail

/datum/anvil_recipe/weapons/holy/pestra_dagger
	name = "Plaguebringer Sickles"
	req_bar = /obj/item/ingot/steelholy
	craftdiff = 3
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle

/datum/anvil_recipe/weapons/holy/dendor_scythe
	name = "Summer Scythe (+1 H. Steel, +1 Small Log)"
	req_bar = /obj/item/ingot/steelholy
	craftdiff = 3
	additional_items = list(/obj/item/ingot/steelholy, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd/bardiche/scythe

/datum/anvil_recipe/weapons/holy/xylix_whip
	name = "Cackle Lash"
	req_bar = /obj/item/ingot/steelholy
	craftdiff = 3
	created_item = /obj/item/rogueweapon/whip/xylix

/datum/anvil_recipe/weapons/holy/ravox_mace
	name = "Duel Settler (+1 H. Steel)"
	req_bar = /obj/item/ingot/steelholy
	craftdiff = 3
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/mace/goden/steel/ravox

/datum/anvil_recipe/weapons/holy/eora_knuckles
	name = "Close Caress"
	req_bar = /obj/item/ingot/steelholy
	craftdiff = 3
	created_item = /obj/item/rogueweapon/knuckles/eora
*/
//Psydonian weapon smithing
/datum/anvil_recipe/weapons/psy/dagger
	name = "Dagger"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 4
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger

/datum/anvil_recipe/weapons/psy/axe
	name = "War Axe (+1 B. Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 5
	created_item = /obj/item/rogueweapon/stoneaxe/battle/psyaxe
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)

/datum/anvil_recipe/weapons/psy/mace
	name = "Mace (+1 B. Silver, +1 Stick)"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 5
	created_item = /obj/item/rogueweapon/mace/goden/psymace
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)

/datum/anvil_recipe/weapons/psy/spear
	name = "Spear (+1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 5
	created_item = /obj/item/rogueweapon/spear/psyspear
	additional_items = list(/obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/psy/sword
	name = "Sword (+1 B. Silver)"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 5
	additional_items = list(/obj/item/ingot/silverblessed)
	created_item = /obj/item/rogueweapon/sword/long/psysword

//Holy, artefact weapons. Not pre-blessed. Gone are the days of mass production.
/datum/anvil_recipe/weapons/psy/halberd
	name = "Halberd (+1 B. Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 6
	created_item = /obj/item/rogueweapon/halberd/psyhalberd
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/psy/gsword
	name = "Greatsword (+1 B. Silver, +1 H. Steel)"
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = 6
	created_item = /obj/item/rogueweapon/greatsword/psygsword
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/steelholy)
