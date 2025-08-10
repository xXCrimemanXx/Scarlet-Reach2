#define TOPER_CAST_TIME_REDUCTION 0.1
#define EMERALD_CAST_TIME_REDUCTION 0.15
#define SAPPHIRE_CAST_TIME_REDUCTION 0.2
#define QUARTZ_CAST_TIME_REDUCTION 0.25
#define RUBY_CAST_TIME_REDUCTION 0.3
#define DIAMOND_CAST_TIME_REDUCTION 0.35
#define RIDDLE_OF_STEEL_CAST_TIME_REDUCTION 0.4

//we use discrete staff objs so that they can be easily thrown into loot tables and maps without complex varediting

/obj/item/rogueweapon/woodstaff
	var/cast_time_reduction = null

/obj/item/rogueweapon/woodstaff/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/gemstaff/toper_staff,
		/datum/crafting_recipe/gemstaff/amethyst_staff,
		/datum/crafting_recipe/gemstaff/emerald_staff,
		/datum/crafting_recipe/gemstaff/sapphire_staff,
		/datum/crafting_recipe/gemstaff/quartz_staff,
		/datum/crafting_recipe/gemstaff/ruby_staff,
		/datum/crafting_recipe/gemstaff/diamond_staff,
		/datum/crafting_recipe/gemstaff/riddle_of_steel_staff,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/rogueweapon/woodstaff/toper
	name = "toper-focused staff"
	desc = "An amber focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "topazstaff"
	cast_time_reduction = TOPER_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF //imagine the salt

/obj/item/rogueweapon/woodstaff/amethyst
	name = "amethyst-focused staff"
	desc = "A purple focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "amethyststaff"
	cast_time_reduction = TOPER_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF

/obj/item/rogueweapon/woodstaff/emerald
	name = "gemerald-focused staff"
	desc = "A glistening green focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "emeraldstaff"
	cast_time_reduction = EMERALD_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF

/obj/item/rogueweapon/woodstaff/sapphire
	name = "saffira-focused staff"
	desc = "A beautiful blue focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "sapphirestaff"
	cast_time_reduction = SAPPHIRE_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF

/obj/item/rogueweapon/woodstaff/quartz
	name = "blortz-focused staff"
	desc = "A crystal-clear focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "quartzstaff"
	cast_time_reduction = QUARTZ_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF

/obj/item/rogueweapon/woodstaff/ruby
	name = "ronts-focused staff"
	desc = "A sanguine focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "rubystaff"
	cast_time_reduction = RUBY_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF

/obj/item/rogueweapon/woodstaff/diamond
	name = "dorpel-focused staff"
	desc = "A beautifully faceted focus-gem hewn by pressure immense sits nestled in crown of this staff."
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "diamondstaff"
	cast_time_reduction = DIAMOND_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF

/obj/item/rogueweapon/woodstaff/riddle_of_steel
	name = "\improper Staff of the Riddle-Steel"
	desc = "Flame dances within the focus-gem of this mighty staff at a rhythm and intensity to match the \
	mage that wields it."
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "riddlestaff"
	cast_time_reduction = RIDDLE_OF_STEEL_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF

/obj/item/rogueweapon/woodstaff/riddle_of_steel/magos
	name = "\improper Staff of the Court Magos"
	icon_state = "courtstaff"

/obj/item/rogueweapon/woodstaff/naledi
	cast_time_reduction = DIAMOND_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF

//crafting datums

/datum/crafting_recipe/gemstaff
	abstract_type = /datum/crafting_recipe/gemstaff

/datum/crafting_recipe/gemstaff/toper_staff
	name = "toper-focused staff"
	result = /obj/item/rogueweapon/woodstaff/toper
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/yellow = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/amethyst_staff
	name = "amethyst-focused staff"
	result = /obj/item/rogueweapon/woodstaff/amethyst
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/amethyst = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/emerald_staff
	name = "gemerald-focused staff"
	result = /obj/item/rogueweapon/woodstaff/emerald
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/green = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/sapphire_staff
	name = "saffira-focused staff"
	result = /obj/item/rogueweapon/woodstaff/sapphire
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/violet = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/quartz_staff
	name = "blortz-focused staff"
	result = /obj/item/rogueweapon/woodstaff/quartz
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/blue = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/ruby_staff
	name = "rontz-focused staff"
	result = /obj/item/rogueweapon/woodstaff/ruby
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/ruby = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/diamond_staff
	name = "dorpel-focused staff"
	result = /obj/item/rogueweapon/woodstaff/diamond
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/diamond = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/riddle_of_steel_staff
	name = "Staff of the Riddlesteel"
	result = /obj/item/rogueweapon/woodstaff/riddle_of_steel
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/riddleofsteel = 1)
	craftdiff = 0
