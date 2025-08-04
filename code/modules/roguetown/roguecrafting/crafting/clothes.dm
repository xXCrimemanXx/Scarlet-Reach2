/datum/crafting_recipe/roguetown/survival/skullmask
	name = "skull mask"
	category = "Clothes"
	result = /obj/item/clothing/mask/rogue/skullmask
	reqs = list(
		/obj/item/natural/bone = 3,
		/obj/item/natural/fibers = 1,
		)
	sellprice = 10
	verbage_simple = "craft"
	verbage = "crafted"
	craftdiff = 0


/datum/crafting_recipe/roguetown/survival/antlerhood
	name = "antlerhood"
	category = "Clothes"
	result = /obj/item/clothing/head/roguetown/antlerhood
	reqs = list(
		/obj/item/natural/hide = 1,
		/obj/item/natural/bone = 2,
		)
	sellprice = 12
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/misc/sewing
	verbage_simple = "sew"
	verbage = "sews"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/tribalrags
	name = "tribal rags (1 fibers, 1 hide)"
	category = "Clothes"
	result = /obj/item/clothing/suit/roguetown/shirt/tribalrag
	reqs = list(
		/obj/item/natural/hide = 1,
		/obj/item/natural/fibers = 1,
		)
	sellprice = 6
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/misc/sewing
	verbage_simple = "sew"
	verbage = "sews"
	craftdiff = 0

/datum/crafting_recipe/roguetown/leather/neck/leather_collar
	name = "leather collar (1 cured hide)"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/collar/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	time = 8 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/neck/catbell_collar
	name = "catbell collar (1 cured leather, catbell)"
	result = /obj/item/clothing/neck/roguetown/collar/catbell
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/catbell = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/neck/cowbell_collar
	name = "cowbell collar (1 curedleather, cowbell)"
	result = /obj/item/clothing/neck/roguetown/collar/cowbell
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/catbell/cow = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/neck/leather_leash
	name = "leather leash (1 cured hide)"
	result = /obj/item/leash/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/survival/goodluckcharm
	name = "cabbit's foot luck charm"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/luckcharm // +1 fortune when worn
	reqs = list(
		/obj/item/natural/rabbitsfoot = 1,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0

// BOUQUETS & CROWNS

/datum/crafting_recipe/roguetown/survival/bouquet_rosa
	name = "rosa bouquet"
	category = "Clothes"
	result = /obj/item/bouquet/rosa
	reqs = list(
		/obj/item/alch/rosa = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

/datum/crafting_recipe/roguetown/survival/bouquet_salvia
	name = "salvia bouquet"
	category = "Clothes"
	result = /obj/item/bouquet/salvia
	reqs = list(
		/obj/item/alch/salvia = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

/datum/crafting_recipe/roguetown/survival/bouquet_matricaria
	name = "matricaria bouquet"
	category = "Clothes"
	result = /obj/item/bouquet/matricaria
	reqs = list(
		/obj/item/alch/matricaria = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

/datum/crafting_recipe/roguetown/survival/bouquet_calendula
	name = "calendula bouquet"
	category = "Clothes"
	result = /obj/item/bouquet/calendula
	reqs = list(
		/obj/item/alch/calendula = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

/datum/crafting_recipe/roguetown/survival/flowercrown_rosa
	name = "rosa crown"
	category = "Clothes"
	result = /obj/item/flowercrown/rosa
	reqs = list(
		/obj/item/alch/rosa = 4,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0
	verbage_simple = "tied"
	verbage = "ties"

/datum/crafting_recipe/roguetown/survival/flowercrown_salvia
	name = "salvia crown"
	category = "Clothes"
	result = /obj/item/flowercrown/salvia
	reqs = list(
		/obj/item/alch/salvia = 4,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0
	verbage_simple = "tied"
	verbage = "ties"

// Amulet
/datum/crafting_recipe/roguetown/survival/pearlcross
	name = "amulet (pearls)"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/pearl
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/pearl = 3,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/bpearlcross
	name = "amulet (blue pearls)"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/bpearl
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/pearl/blue = 3,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/shellnecklace
	name = "shell necklace"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/shell
	reqs = list(
		/obj/item/oystershell = 5,
		/obj/item/natural/fibers = 1,
		)

/datum/crafting_recipe/roguetown/survival/shellbracelet
	name = "shell bracelet"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/shell/bracelet
	reqs = list(
		/obj/item/oystershell = 3,
		/obj/item/natural/fibers = 1,
		)

/datum/crafting_recipe/roguetown/survival/abyssoramulet
	name = "amulet of abyssor"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/abyssor
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/pearl/blue = 1,
		)

/datum/crafting_recipe/roguetown/survival/woodcross
	name = "wooden amulet"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/wickercloak
	name = "wickercloak"
	category = "Clothes"
	result = /obj/item/clothing/cloak/wickercloak
	reqs = list(
		/obj/item/natural/dirtclod = 1,
		/obj/item/grown/log/tree/stick = 5,
		/obj/item/natural/fibers = 3,
		)
	craftdiff = 0
