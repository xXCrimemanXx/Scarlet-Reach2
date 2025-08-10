/obj/item/clothing/suit/roguetown/shirt
	slot_flags = ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|VITALS
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	equip_sound = 'sound/blank.ogg'
	drop_sound = 'sound/blank.ogg'
	pickup_sound =  'sound/blank.ogg'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	sleevetype = "shirt"
	edelay_type = 1
	equip_delay_self = 25
	bloody_icon_state = "bodyblood"
	boobed = TRUE
	sewrepair = TRUE
	flags_inv = HIDEBOOB
	experimental_inhand = FALSE
	
	grid_width = 64
	grid_height = 32

/obj/item/clothing/suit/roguetown/shirt/undershirt
	name = "shirt"
	desc = "Modest and humble. It lets you walk around in public with your dignity intact."
	icon_state = "undershirt"
	item_state = "undershirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|ARMS|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	name = "undervestments"
	desc = "A soft garment designed to prevent chafing from wearing heavy robes all dae and night."
	icon_state = "priestunder"
	item_state = "priestunder"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
	boobed = TRUE
	flags_inv= HIDEBOOB|HIDECROTCH
	body_parts_covered = CHEST|GROIN|ARMS|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/undershirt/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/undershirt/brown
	color = "#6b5445"

/obj/item/clothing/suit/roguetown/shirt/undershirt/lord
	desc = ""
	color = "#616898"

/obj/item/clothing/suit/roguetown/shirt/undershirt/red
	color = "#851a16"

/obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	color = CLOTHING_SCARLET

/obj/item/clothing/suit/roguetown/shirt/undershirt/guard/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/undershirt/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()


/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond/lordcolor(primary,secondary)
	if(secondary)
		color = secondary

/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/shirt/undershirt/random/Initialize()
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	..()

/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	name = "formal silks"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "puritan_shirt"
	allowed_race = CLOTHED_RACES_TYPES
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	name = "tinker suit"
	desc = "Typical fashion of the best engineers."
	icon_state = "artishirt"

/obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
	name = "low cut tunic"
	desc = "A tunic exposing much of the neck and... shoulders?! How scandalous..."
	icon_state = "lowcut"

/obj/item/clothing/suit/roguetown/shirt/shadowshirt
	name = "silk shirt"
	desc = "A sleeveless shirt woven from glossy material."
	icon_state = "shadowshirt"
	item_state = "shadowshirt"
	r_sleeve_status = SLEEVE_TORN
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/shirt/apothshirt
	name = "apothecary shirt"
	desc = "When trudging through late-autumn forests, one needs to keep warm."
	icon_state = "apothshirt"
	item_state = "apothshirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
	name = "fancy coat"
	desc = "A fancy tunic and coat combo. How elegant."
	icon_state = "noblecoat"
	item_state = "noblecoat"
	sleevetype = "noblecoat"
	detail_tag = "_detail"
	detail_color = CLOTHING_SCARLET
	color = CLOTHING_WHITE
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	name = "tinker suit"
	desc = "Typical fashion of the best engineers."
	icon_state = "artishirt"

//Royal clothing:
//................ Royal Dress (Ball Gown)............... //
/obj/item/clothing/suit/roguetown/shirt/dress/royal
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon = 'icons/roguetown/clothing/shirts_royalty.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_royalty.dmi'
	name = "royal gown"
	desc = "An elaborate ball gown, a favoured fashion of queens and elevated nobility in Enigma."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "royaldress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_royalty.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/dress/royal/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/dress/royal/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/shirt/dress/royal/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/dress/royal/Destroy()
	GLOB.lordcolor -= src
	return ..()

//................ Princess Dress ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "pristine dress"
	desc = "A flowy, intricate dress made by the finest tailors in the land for the monarch's children."
	icon_state = "princess"
	boobed = TRUE
	detail_color = CLOTHING_BLUE

//................ Prince Shirt   ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "gilded dress shirt"
	desc = "A gold-embroidered dress shirt specially tailored for the monarch's children."
	icon_state = "prince"
	boobed = TRUE
	detail_color = CLOTHING_MAGENTA

// End royal clothes

/obj/item/clothing/suit/roguetown/shirt/dress/winterdress_light
	name = "cold dress"
	icon = 'icons/roguetown/clothing/shirts_royalty.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_royalty.dmi'
	desc = "A thick and comfortable dress popular amongst nobility during winter."
	body_parts_covered = COVERAGE_FULL
	icon_state = "winterdress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_royalty.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT

/obj/item/clothing/suit/roguetown/shirt/dress/silkydress
	name = "silky dress"
	desc = "Despite not actually being made of silk, the legendary expertise needed to sew this puts the quality on par."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "silkydress"
	item_state = "silkydress"
	sleevetype = null
	sleeved = null
	flags_inv = HIDECROTCH
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	boobed = TRUE

/obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random/Initialize()
	color = pick("#e6e5e5", "#249589", "#a32121", "#428138", "#8747b1", "#007fff")
	..()

/obj/item/clothing/suit/roguetown/shirt/dress/gown
	icon = 'icons/roguetown/clothing/shirts_gown.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_gown.dmi'
	name = "spring gown"
	desc = "A delicate gown that captures the essence of the season of renewal."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "springgown"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_gown.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_DARK_GREEN
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "summer gown"
	desc = "A breezy flowing gown fit for warm weathers."
	icon_state = "summergown"
	boobed = TRUE
	detail_color = "#e395bb"

/obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "fall gown"
	desc = "A solemn long-sleeved gown that signifies the season of year's end."
	icon_state = "fallgown"
	boobed = TRUE
	detail_color = "#8b3f00"

/obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "winter gown"
	desc = "A warm elegant gown adorned with soft fur for the cold winter."
	icon_state = "wintergown"
	boobed = TRUE
	detail_color = "#45749d"

/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	icon_state = "sailorblues"

/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
	icon_state = "sailorreds"

/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	r_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|ARM_LEFT|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|ARM_RIGHT|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/Initialize()
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	..()

/obj/item/clothing/suit/roguetown/shirt/shortshirt
	name = "shirt"
	desc = ""
	icon_state = "shortshirt"
	item_state = "shortshirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/shortshirt/random/Initialize()
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	..()

/obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	name = "shirt"
	desc = ""
	icon_state = "shortshirt"
	item_state = "shortshirt"
	r_sleeve_status = SLEEVE_TORN
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/shirt/shortshirt/bog
	color = "#9ac878"

/obj/item/clothing/suit/roguetown/shirt/rags
	slot_flags = ITEM_SLOT_ARMOR
	name = "rags"
	desc = "From rags to... nope, still rags."
	body_parts_covered = CHEST|GROIN|VITALS
	color = "#b0b0b0"
	icon_state = "rags"
	item_state = "rags"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/tribalrag
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "tribalrag"
	desc = ""
	body_parts_covered = CHEST|VITALS
	icon_state = "tribalrag"
	item_state = "tribalrag"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/robe/archivist
	name = "archivist's robe"
	desc = "Robes belonging to seekers of knowledge."
	icon_state = "archivist"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)
	color = null
	sellprice = 100

/obj/item/clothing/suit/roguetown/shirt/tunic
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "tunic"
	desc = "Modest and fashionable, with the right colors."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "tunic"
	boobed = FALSE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/tunic/green
	color = CLOTHING_GREEN

/obj/item/clothing/suit/roguetown/shirt/tunic/blue
	color = CLOTHING_BLUE

/obj/item/clothing/suit/roguetown/shirt/tunic/red
	color = CLOTHING_RED

/obj/item/clothing/suit/roguetown/shirt/tunic/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/tunic/white
	color = CLOTHING_WHITE

/obj/item/clothing/suit/roguetown/shirt/tunic/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/tunic/ucolored
	color = COLOR_GRAY

/obj/item/clothing/suit/roguetown/shirt/tunic/random/Initialize()
	color = pick(CLOTHING_PURPLE, CLOTHING_RED, CLOTHING_BLUE, CLOTHING_GREEN, CLOTHING_BLACK, CLOTHING_WHITE, COLOR_GRAY)
	..()
/obj/item/clothing/suit/roguetown/shirt/dress
	slot_flags = ITEM_SLOT_ARMOR
	name = "dress"
	desc = "A simple dress worn by women and the bold."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "dress"
	item_state = "dress"
	allowed_sex = list(MALE, FEMALE)
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/dress/gen
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "dress"
	desc = "A simple dress worn by women and the bold."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "dressgen"
	item_state = "dressgen"
	color = "#6b5445"

/obj/item/clothing/suit/roguetown/shirt/dress/gen/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/gen/blue
	color = CLOTHING_BLUE

/obj/item/clothing/suit/roguetown/shirt/dress/gen/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/dress/gen/random/Initialize()
	color = pick("#6b5445", "#435436", "#704542", "#79763f", CLOTHING_BLUE)
	..()

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "chemise"
	desc = "Comfortable yet elegant, it offers both style and comfort for everyday wear."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "silkdress"
	item_state = "silkdress"
	color = "#e6e5e5"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/princess
	color = CLOTHING_WHITE

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/princess/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/princess/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/green
	color = CLOTHING_DARK_GREEN

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/random/Initialize()
	. = ..()
	color = pick("#e6e5e5", "#52BE80", "#C39BD3", "#EC7063","#5DADE2")

/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "sheer dress"
	desc = "A scandalously short dress made of extra fine fibers for a semi-sheer look."
	body_parts_covered = null
	icon_state = "sexydress"
	sleevetype = null
	sleeved = null
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy/random/Initialize()
	. = ..()
	color = pick(CLOTHING_WHITE, CLOTHING_RED, CLOTHING_PURPLE, CLOTHING_MAGENTA, CLOTHING_TEAL, CLOTHING_BLACK)

/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy/black/Initialize()
	. = ..()
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/undershirt/webs
	name = "webbed shirt"
	desc = "Exotic silk finely woven into... this? Might as well be wearing a spiderweb."
	icon_state = "webs"
	item_state = "webs"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|ARMS|VITALS
	color = null

/obj/item/clothing/suit/roguetown/shirt/jester
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "jester's tunick"
	desc = "Whether it's standup, slapstick, or wrestling nobles to the floor, this tunick can take it all."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "jestershirt"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	boobed = FALSE // for some reason when boobed, the game likes to get rid of the detail and altdetail. I went ahead and just merged it into the main icon.
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	detail_color = CLOTHING_BLACK
	color = CLOTHING_SCARLET
	altdetail_color = CLOTHING_BLACK


/obj/item/clothing/suit/roguetown/shirt/jester/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/jester/lordcolor(primary,secondary)
	detail_color = secondary
	color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/shirt/jester/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/jester/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward
	color = null
	name = "ornate silk dress"
	desc = "A dress woven of only the finest, softest silks. Golden thread is inlaid with a deep royal crimson, expressing the owner's exquisitve wealth."
	icon_state = "stewarddress"
	item_state = "stewarddress"

/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic
	name = "ornate silk tunic"
	desc = "A billowing tunic made of the finest silks and softest fabrics. Inlaid with golden thread, this is the height of fashion for the wealthiest of wearers."
	icon_state = "stewardtunic"
	item_state = "stewardtunic"

//WEDDING CLOTHES
/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/weddingdress
	name = "wedding silk dress"
	desc = "A dress woven from fine silks, with golden threads inlaid in it. Made for that special day."
	icon_state = "weddingdress"
	item_state = "weddingdress"

/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
	name = "exotic silk bra"
	desc = "An exquisite bra crafted from the finest silk and adorned with gold rings. It leaves little to the imagination."
	icon_state = "exoticsilkbra"
	item_state = "exoticsilkbra"
	body_parts_covered = CHEST
	sewrepair = TRUE
	flags_inv = null
	slot_flags = ITEM_SLOT_SHIRT

//................ Noble Dress ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/noble
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	name = "noble dress"
	desc = "An elegant dress fit for nobility, crafted with the finest materials and adorned with intricate details."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "nobledress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'


/obj/item/clothing/suit/roguetown/shirt/dress/noble/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/dress/noble/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/shirt/dress/noble/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/dress/noble/Destroy()
	GLOB.lordcolor -= src
	return ..()

//................ Velvet Dress ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/velvet
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	name = "velvet dress"
	desc = "A luxurious dress made of the finest velvet, soft to the touch and rich in appearance."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "velvetdress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'


//kazengite content
/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "black foreign shirt"
	desc = "A shirt typically used by thugs."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "eastshirt1"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	boobed = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "white foreign shirt"
	desc = "A shirt typically used by foreign gangs."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "eastshirt2"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	boobed = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_race = NON_DWARVEN_RACE_TYPES

//tattoo code
/obj/item/clothing/suit/roguetown/shirt/undershirt/easttats/Initialize(mapload)
	. = ..()
	name = "lenticular tattoos"
	desc = "It's styled into the shapes of clouds. You shudder as the ink moves and condenses into areas where the skin is struck."
	resistance_flags = FIRE_PROOF
	icon_state = "easttats"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	body_parts_covered = ARMS
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/shirt/easttats/easttats/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)
