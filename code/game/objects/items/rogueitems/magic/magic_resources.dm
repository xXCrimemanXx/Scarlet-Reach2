// Magical resources for the Ratwood ported Mage Gameplay Loop system
// Chose to not use /natural typepath because it didn't make much sense and this
// Let me use another .dmi 
// Since the enchanting / summoning system is not here yet, sellprice has been adjusted.
/obj/item/magic
	name = "magic resource"
	desc = "You shouldn't be seeing this."
	icon = 'icons/roguetown/items/magic_resources.dmi'
	w_class = WEIGHT_CLASS_TINY
	grid_width = 32
	grid_height = 32

// MELD
/obj/item/magic/melded
	name = "arcane meld"
	icon_state = "wessence"
	desc = "You should not be seeing this"
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20

/obj/item/magic/melded/t1
	name = "arcanic meld"
	icon_state = "meld"
	desc = "A melding of infernal ash, fairy dust and elemental mote."

/obj/item/magic/melded/t2
	name = "dense arcanic meld"
	icon_state = "dmeld"
	desc = "A melding of hellhound fang, iridescent scales and elemental shard."

/obj/item/magic/melded/t3
	name = "sorcerous weave"
	icon_state = "wessence"
	desc = "A melding of infernal core, heartwood core and elemental fragment."
	sellprice = 40

/obj/item/magic/melded/t4
	name = "magical confluence"
	icon_state = "wessence"
	desc = "A melding of abyssal flame, sylvan essence and elemental relic."
	sellprice = 60

/obj/item/magic/melded/t5
	name = "arcanic aberation"
	icon_state = "wessence"
	desc = "A melding of arcane fusion and voidstone. It pulses erratically, power coiled tightly within and dangerous. Many would be afraid of going near this, let alone holding it."
	sellprice = 100
	
//mapfetchable items
/obj/item/magic/obsidian
	name = "obsidian fragment"
	icon = 'icons/obj/shards.dmi'
	icon_state = "obsidian"
	desc = "Volcanic glass cooled from molten lava rapidly."

/obj/item/magic/leyline
	name = "leyline shards"
	icon_state = "leyline"
	desc = "A shard of a fractured leyline, it glows with lost power."

/obj/item/reagent_containers/food/snacks/grown/manabloom
	name = "mana bloom"
	icon_state = "manabloom"
	desc = "Dense mana that has taken the form of plant life."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	alternate_worn_layer  = 8.9
	seed = /obj/item/seeds/manabloom

/obj/item/magic/manacrystal
	name = "crystalized mana"
	icon_state = "manacrystal"
	desc = "A crystal made of mana, woven into an artifical structure."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL

/obj/item/magic/artifact
	name = "runed artifact"
	icon_state = "runedartifact"
	desc = "An old stone from age long ago, marked with glowing sigils."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/magic/artifact/Initialize()
	.=..()
	var/list/listy = list("runedartifact", "runedartifact1")
	var/newicon = pick(listy)
	icon_state = newicon

/obj/item/magic/voidstone
	name = "voidstone"
	icon_state = "wessence"
	desc = "A piece of blackstone, it feels off to stare at it for long."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL	

// INFERNAL
/obj/item/magic/infernalash//T1 mage summon loot
    name = "infernal ash"
    icon_state = "infernalash"
    desc = "Ash burnt and burnt once again. Smells of brimstone and hellfire. Still has embers within."
    resistance_flags = FIRE_PROOF
    w_class = WEIGHT_CLASS_SMALL
    sellprice = 10

/obj/item/magic/hellhoundfang//T2 mage summon loot
    name = "hellhound fang"
    icon_state = "hellhound_fang"
    desc = "A sharp fang that glows bright red, no matter how long it's left to cool."
    resistance_flags = FIRE_PROOF
    w_class = WEIGHT_CLASS_SMALL
    sellprice = 20

/obj/item/magic/infernalcore// T3 mage summon loot
    name = "infernal core"
    icon_state = "infernal_core"
    desc = "A molten orb of rock and magick. It gives off waves of magical heat and energy."
    resistance_flags = FIRE_PROOF
    w_class = WEIGHT_CLASS_SMALL
    sellprice = 50

/obj/item/magic/abyssalflame//T4 mage summon loot
    name = "abyssal flame"
    icon_state = "abyssalflame"
    desc = "A  flickering, black flame contained in a crystal; the heart of an archfiend. Or atleast, what passes for one. It pulses with dense thrums of magick."
    resistance_flags = FIRE_PROOF
    w_class = WEIGHT_CLASS_SMALL
    sellprice = 250

//FAIRY
/obj/item/magic/fairydust	//T1 mage summon loot
    name = "fairy dust"
    icon_state = "fairy_dust"
    desc = "A glittering powder from a fae sprite."
    resistance_flags = FIRE_PROOF
    w_class = WEIGHT_CLASS_SMALL
    sellprice = 20

/obj/item/magic/iridescentscale	//T2 mage summon loot
    name = "iridescent scales"
    icon_state = "iridescent_scale"
    desc = "Tiny, colorful scales from a glimmerwing, they shine with inate magic"
    resistance_flags = FIRE_PROOF
    w_class = WEIGHT_CLASS_SMALL
    sellprice = 30

/obj/item/magic/heartwoodcore	//T3 mage summon loot
    name = "heartwood core"
    icon_state = "heartwood_core"
    desc = "A piece of enchanted wood imbued with the dryad’s essence. Merely holding it transports one's mind to ancient times."
    resistance_flags = FIRE_PROOF
    w_class = WEIGHT_CLASS_SMALL
    sellprice = 50

/obj/item/magic/sylvanessence	//T4 mage summon loot
    name = "sylvan essence"
    icon_state = "sylvanessence"
    desc = "A swirling, multicolored liquid with emitting a dizzying array of lights."
    resistance_flags = FIRE_PROOF
    w_class = WEIGHT_CLASS_SMALL
    sellprice = 250

//ELEMENTAL
/obj/item/magic/elementalmote
    name = "elemental mote"
    icon_state = "mote"
    desc = "A mystical essence embued with the power of Dendor. Merely holding it transports one's mind to ancient times."
    resistance_flags = FIRE_PROOF
    w_class = WEIGHT_CLASS_SMALL
    sellprice = 15

/obj/item/magic/elementalshard
    name = "elemental shard"
    icon_state = "shard"
    desc = "A mystical essence embued with the power of Dendor. Merely holding it transports one's mind to ancient times."
    resistance_flags = FIRE_PROOF
    w_class = WEIGHT_CLASS_SMALL
    sellprice = 30

/obj/item/magic/elementalfragment
    name = "elemental fragment"
    icon_state = "fragment"
    desc = "A mystical essence embued with the power of Dendor. Merely holding it transports one's mind to ancient times."
    resistance_flags = FIRE_PROOF
    w_class = WEIGHT_CLASS_SMALL
    sellprice = 100

/obj/item/magic/elementalrelic
    name = "elemental relic"
    icon_state = "relic"
    desc = "A mystical essence embued with the power of Dendor. Merely holding it transports one's mind to ancient times."
    resistance_flags = FIRE_PROOF
    w_class = WEIGHT_CLASS_SMALL
    sellprice = 250
