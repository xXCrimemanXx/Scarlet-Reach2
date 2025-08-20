GLOBAL_DATUM_INIT(fire_overlay, /mutable_appearance, mutable_appearance('icons/effects/fire.dmi', "fire"))


GLOBAL_VAR_INIT(rpg_loot_items, FALSE)
// if true, everyone item when created will have its name changed to be
// more... RPG-like.

/obj/item
	name = "item"
	icon = 'icons/obj/items_and_weapons.dmi'
	///icon state name for inhanf overlays
	var/item_state = null
	///Icon file for left hand inhand overlays
	var/lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	///Icon file for right inhand overlays
	var/righthand_file = 'icons/mob/inhands/items_righthand.dmi'

	///Icon file for mob worn overlays.
	///no var for state because it should *always* be the same as icon_state
	var/icon/mob_overlay_icon
	//Forced mob worn layer instead of the standard preferred ssize.
	var/alternate_worn_layer

	//Dimensions of the icon file used when this item is worn, eg: hats.dmi
	//eg: 32x32 sprite, 64x64 sprite, etc.
	//allows inhands/worn sprites to be of any size, but still centered on a mob properly
	var/worn_x_dimension = 32
	var/worn_y_dimension = 32
	//Same as above but for inhands, uses the lefthand_ and righthand_ file vars
	var/inhand_x_dimension = 64
	var/inhand_y_dimension = 64

	var/no_effect = FALSE

	max_integrity = 200

	obj_flags = NONE
	var/item_flags = NONE

	var/list/hitsound
	var/usesound
	///Used when yate into a mob
	var/mob_throw_hit_sound
	///Sound used when equipping the item into a valid slot
	var/equip_sound
	///Sound uses when picking the item up (into my hands)
	var/pickup_sound = "rustle"
	///Sound uses when dropping the item, or when its thrown.
	var/drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	//when being placed on a table play this instead
	var/place_sound = 'sound/foley/dropsound/gen_drop.ogg'
	var/list/swingsound = PUNCHWOOSH
	var/list/parrysound = "parrywood"
	var/w_class = WEIGHT_CLASS_NORMAL
	var/slot_flags = 0		//This is used to determine on which slots an item can fit.
	pass_flags = PASSTABLE
	var/obj/item/master = null

	var/heat_protection = 0 //flags which determine which body parts are protected from heat. Use the HEAD, CHEST, GROIN, etc. flags. See setup.dm
	var/cold_protection = 0 //flags which determine which body parts are protected from cold. Use the HEAD, CHEST, GROIN, etc. flags. See setup.dm
	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags

	var/list/actions //list of /datum/action's that this item has.
	var/list/actions_types //list of paths of action datums to give to the item on New().

	//Since any item can now be a piece of clothing, this has to be put here so all items share it.
	var/flags_inv //This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	var/transparent_protection = NONE //you can see someone's mask through their transparent visor, but you can't reach it

	var/interaction_flags_item = INTERACT_ITEM_ATTACK_HAND_PICKUP

	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags
	var/body_parts_covered_dynamic = 0
	var/body_parts_inherent	= 0 //bodypart coverage areas you cannot peel off because it wouldn't make any sense (peeling chest off of torso armor, hands off of gloves, head off of helmets, etc)
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown = 0 // How much clothing is slowing you down. Negative values speeds you up
	var/armor_penetration = 0 //percentage of armour effectiveness to remove
	var/list/allowed = null //suit storage stuff.
	var/equip_delay_self = 1 //In deciseconds, how long an item takes to equip; counts only for normal clothing slots, not pockets etc.
	var/edelay_type = 1 //if 1, can be moving while equipping (for helmets etc)
	var/equip_delay_other = 20 //In deciseconds, how long an item takes to put on another person
	var/strip_delay = 40 //In deciseconds, how long an item takes to remove from another person
	var/breakouttime = 0 // greater than 15 str get this isnstead
	var/slipouttime = 0

	var/list/attack_verb //Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"
	var/list/species_exception = null	// list() of species types, if a species cannot put items in a certain slot, but species type is in list, it will be able to wear that item

	var/mob/thrownby = null

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER //the icon to indicate this object is being dragged

	var/datum/embedding_behavior/embedding
	var/is_embedded = FALSE

	var/flags_cover = 0 //for flags such as GLASSESCOVERSEYES
	var/heat = 0
	///All items with sharpness of IS_SHARP or higher will automatically get the butchering component.
	var/sharpness = IS_BLUNT

	var/tool_behaviour = NONE
	var/toolspeed = 1

	var/block_chance = 0
	var/hit_reaction_chance = 0 //If you want to have something unrelated to blocking/armour piercing etc. Maybe not needed, but trying to think ahead/allow more freedom
	var/reach = 1 //In tiles, how far this weapon can reach; 1 for adjacent, which is default

	//The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot.
	var/list/slot_equipment_priority = null // for default list, see /mob/proc/equip_to_appropriate_slot()

	// Needs to be in /obj/item because corgis can wear a lot of
	// non-clothing items
	var/datum/dog_fashion/dog_fashion = null

	var/tip_timer

	var/trigger_guard = TRIGGER_GUARD_NONE

	///Used as the dye color source in the washing machine only (at the moment). Can be a hex color or a key corresponding to a registry entry, see washing_machine.dm
	var/dye_color
	///Whether the item is unaffected by standard dying.
	var/undyeable = FALSE
	///What dye registry should be looked at when dying this item; see washing_machine.dm
	var/dying_key

	//Grinder vars
	var/list/grind_results //A reagent list containing the reagents this item produces when ground up in a grinder - this can be an empty list to allow for reagent transferring only
	var/list/juice_results //A reagent list containing blah blah... but when JUICED in a grinder!
	var/mill_result = null // What it grinds into on a millstone or similar.

	var/canMouseDown = FALSE
	var/can_parry = FALSE
	var/datum/skill/associated_skill

	var/list/possible_item_intents = list(/datum/intent/use)

	var/bigboy = FALSE //used to center screen_loc when in hand
	var/wielded = FALSE
	var/altgripped = FALSE
	var/list/alt_intents //these replace main intents
	var/list/gripped_intents //intents while gripped, replacing main intents
	var/force_wielded = 0
	var/gripsprite = FALSE //use alternate grip sprite for inhand

	var/dropshrink = 0
	/// Force value that is force or force_wielded, with any added bonuses from external sources. (Mainly components for enchantments)
	var/force_dynamic = 0
	/// Weapon's length. Indicates what limbs it can target without extra circumstances (like grabs / on a prone target). 
	var/wlength = WLENGTH_NORMAL
	/// Weapon's balance. Swift uses SPD difference between attacker and defender to increase hit%. Heavy increases parry stamina drain based on STR diff.
	var/wbalance = WBALANCE_NORMAL
	/// Weapon's defense. Multiplied by 10 and added to the defender's parry / dodge %-age.
	var/wdefense = 0 
	/// Weapon's defense bonus from wielding it. Added to wdefense upon wielding.
	var/wdefense_wbonus = 0
	/// Weapon's dynamic defense of the wbonus and wdefense added together. This var allows wdefense and the wbonus to be altered by other code / status effects etc.
	var/wdefense_dynamic = 0
	/// Minimum STR required to use the weapon. Will reduce damage by 70% if not met. Wielding halves the requirement.
	var/minstr = 0 
	/// %-age of our raw damage that is dealt to armor or weapon on hit / parry / clip.
	var/intdamage_factor = 1

	var/sleeved = null
	var/sleevetype = null
	var/nodismemsleeves = FALSE
	var/inhand_mod = FALSE
	var/r_sleeve_status = SLEEVE_NOMOD //SLEEVE_TORN or SLEEVE_ROLLED
	var/l_sleeve_status = SLEEVE_NOMOD
	var/r_sleeve_zone = BODY_ZONE_R_ARM
	var/l_sleeve_zone = BODY_ZONE_L_ARM

	var/twohands_required = FALSE

	var/bloody_icon = 'icons/effects/blood.dmi'
	var/bloody_icon_state = "itemblood"
	var/dam_icon = 'icons/effects/item_damage32.dmi'
	var/dam_icon_state = "itemdamaged"
	var/boobed = FALSE

	var/firefuel = 0 //add this idiot

	var/thrown_bclass = BCLASS_BLUNT

	var/icon/experimental_inhand = TRUE
	var/icon/experimental_onhip = FALSE
	var/icon/experimental_onback = FALSE

	///trying to emote or talk with this in our mouth makes us muffled
	var/muteinmouth = TRUE
	///using spit emote spits the item out of our mouth and falls out after some time
	var/spitoutmouth = TRUE

	var/has_inspect_verb = FALSE

	///The appropriate skill to repair this obj/item. If null, our object cannot be placed on an anvil to be repaired
	var/anvilrepair
	//this should be true or false
	var/sewrepair

	var/breakpath

	var/walking_stick = FALSE

	var/mailer = null
	var/mailedto = null

	var/picklvl = 0

	var/list/examine_effects = list()

	///played when an item that is equipped blocks a hit
	var/list/blocksound

	var/thrown_damage_flag = "blunt"

	var/sheathe_sound // played when item is placed on hip_r or hip_l, the belt side slots

	var/visual_replacement //Path. For use in generating dummies for one-off items that would break the game like the crown.

	// Can this be used against a training dummy to learn skills? Prevents dumb exploits.
	var/istrainable = FALSE

	/// This is what we get when we either tear up or salvage a piece of clothing
	var/obj/item/salvage_result = null

	var/craft_blocked = FALSE //blocks the item from being used in crafts, such as conjured items

	/// The amount of salvage we get out of salvaging with scissors
	var/salvage_amount = 0 //This will be more accurate when sewing recipes get sorted

	/// Temporary snowflake var to be used in the rare cases clothing doesn't require fibers to sew, to avoid material duping
	var/fiber_salvage = FALSE

	/// Number of torn sleves, important for salvaging calculations and examine text
	var/torn_sleeve_number = 0
	
	/// Angle of the icon, these are used for attack animations.
	var/icon_angle = 50 // most of our icons are angled

	/// Angle of the icon while wielded, these are used for attack animations. Generally it's flat, but not always.
	var/icon_angle_wielded = 0

	var/leashable = FALSE // More elegant solution to leash checks
	var/bellsound = FALSE //Sanitycheck for bell jingles
	var/bell = FALSE //Does item have bell in it, used for attachables

/obj/item/Initialize()
	. = ..()
	if(!pixel_x && !pixel_y && !bigboy)
		pixel_x = rand(-5,5)
		pixel_y = rand(-5,5)
		
	if(twohands_required)
		has_inspect_verb = TRUE

	if(grid_width <= 0)
		grid_width = (w_class * world.icon_size)
	if(grid_height <= 0)
		grid_height = (w_class * world.icon_size)
	
	if(body_parts_covered)
		body_parts_covered_dynamic = body_parts_covered
	update_transform()


/obj/item/proc/update_transform()
	transform = null
	if(dropshrink)
		if(isturf(loc))
			var/matrix/M = matrix()
			M.Scale(dropshrink,dropshrink)
			transform = M
	if(ismob(loc))
		if(altgripped)
			if(gripsprite)
				icon_state = "[initial(icon_state)]1"
				var/datum/component/decal/blood/B = GetComponent(/datum/component/decal/blood)
				if(B)
					B.remove()
					B.generate_appearance()
					B.apply()
				if (obj_broken)
					update_damaged_state()
			return
		if(wielded)
			if(gripsprite)
				icon_state = "[initial(icon_state)]1"
				var/datum/component/decal/blood/B = GetComponent(/datum/component/decal/blood)
				if(B)
					B.remove()
					B.generate_appearance()
					B.apply()
				if (obj_broken)
					update_damaged_state()
			if(toggle_state)
				icon_state = "[toggle_state]1"
			return
		if(gripsprite)
			if(!toggle_state)
				icon_state = initial(icon_state)
			else
				icon_state = "[toggle_state]"
			var/datum/component/decal/blood/B = GetComponent(/datum/component/decal/blood)
			if(B)
				B.remove()
				B.generate_appearance()
				B.apply()
			if (obj_broken)
				update_damaged_state()

/obj/item/Initialize()
	if (attack_verb)
		attack_verb = typelist("attack_verb", attack_verb)

	if(experimental_inhand)
		var/props2gen = list("gen")
		var/list/prop
		if(gripped_intents)
			props2gen += "wielded"
		for(var/i in props2gen)
			prop = getonmobprop(i)
			if(prop)
				getmoboverlay(i,prop,behind=FALSE,mirrored=FALSE)
				getmoboverlay(i,prop,behind=TRUE,mirrored=FALSE)
				getmoboverlay(i,prop,behind=FALSE,mirrored=TRUE)
				getmoboverlay(i,prop,behind=TRUE,mirrored=TRUE)

	if(experimental_onhip)
		if(slot_flags & ITEM_SLOT_BELT)
			var/i = "onbelt"
			var/list/prop = getonmobprop(i)
			if(prop)
				getmoboverlay(i,prop,behind=FALSE,mirrored=FALSE)
				getmoboverlay(i,prop,behind=TRUE,mirrored=FALSE)
				getmoboverlay(i,prop,behind=FALSE,mirrored=TRUE)
				getmoboverlay(i,prop,behind=TRUE,mirrored=TRUE)

	if(experimental_onback)
		if(slot_flags & ITEM_SLOT_BACK)
			var/i = "onback"
			var/list/prop = getonmobprop(i)
			if(prop)
				getmoboverlay(i,prop,behind=FALSE,mirrored=FALSE)
				getmoboverlay(i,prop,behind=TRUE,mirrored=FALSE)
				getmoboverlay(i,prop,behind=FALSE,mirrored=TRUE)
				getmoboverlay(i,prop,behind=TRUE,mirrored=TRUE)
	
	wdefense_dynamic = wdefense
	force_dynamic = force

	. = ..()
	for(var/path in actions_types)
		new path(src)
	actions_types = null


	if(!hitsound)
		if(damtype == "fire")
			hitsound = list('sound/blank.ogg')
		if(damtype == "brute")
			hitsound = list("swing_hit")

	if (!embedding)
		embedding = getEmbeddingBehavior()
	else if (islist(embedding))
		embedding = getEmbeddingBehavior(arglist(embedding))
	else if (!istype(embedding, /datum/embedding_behavior))
		stack_trace("Invalid type [embedding.type] found in .embedding during /obj/item Initialize()")

	if(sharpness) //give sharp objects butchering functionality, for consistency
		AddComponent(/datum/component/butchering, 80 * toolspeed)

	if(max_blade_int)
		//set blade integrity to randomized 60% to 100% if not already set
		if(!blade_int)
			blade_int = max_blade_int + rand(-(max_blade_int * 0.4), 0)
		//set dismemberment integrity to max_blade_int if not already set
		if(!dismember_blade_int)
			dismember_blade_int = max_blade_int

/obj/item/Destroy()
	item_flags &= ~DROPDEL	//prevent reqdels
	if(ismob(loc))
		var/mob/m = loc
		m.temporarilyRemoveItemFromInventory(src, TRUE)
	for(var/X in actions)
		qdel(X)
	if(is_embedded)
		if(isbodypart(loc))
			var/obj/item/bodypart/embedded_part = loc
			embedded_part.remove_embedded_object(src)
		else if(isliving(loc))
			var/mob/living/embedded_mob = loc
			embedded_mob.simple_remove_embedded_object(src)
	return ..()

/obj/item/proc/check_allowed_items(atom/target, not_inside, target_self)
	if(((src in target) && !target_self) || (!isturf(target.loc) && !isturf(target) && not_inside))
		return 0
	else
		return 1

//user: The mob that is suiciding
//damagetype: The type of damage the item will inflict on the user
//BRUTELOSS = 1
//FIRELOSS = 2
//TOXLOSS = 4
//OXYLOSS = 8
//Output a creative message and then return the damagetype done
/obj/item/proc/suicide_act(mob/user)
	return

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set hidden = 1
	set src in oview(1)

	if(!isturf(loc) || usr.stat || usr.restrained())
		return

	if(isliving(usr))
		var/mob/living/L = usr
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return

	var/turf/T = loc
	loc = null
	loc = T

/obj/item/Topic(href, href_list)
	. = ..()

	if(href_list["inspect"])
		if(!usr.canUseTopic(src, be_close=TRUE))
			return
		var/list/inspec = list(span_notice("Properties of [src.name]"))
		if(minstr)
			inspec += "\n<b>MIN.STR:</b> [minstr]"
		
		if(force)
			inspec += "\n<b>FORCE:</b> [get_force_string(force)]"
		if(gripped_intents && !wielded)
			inspec += "\n<b>WIELDED FORCE:</b> [get_force_string(force_wielded)]"

		if(wbalance)
			inspec += "\n<b>BALANCE: </b>"
			if(wbalance == WBALANCE_HEAVY)
				inspec += "Heavy"
			if(wbalance == WBALANCE_SWIFT)
				inspec += "Swift"

		if(wlength != WLENGTH_NORMAL)
			inspec += "\n<b>LENGTH:</b> "
			switch(wlength)
				if(WLENGTH_SHORT)
					inspec += "Short"
				if(WLENGTH_LONG)
					inspec += "Long"
				if(WLENGTH_GREAT)
					inspec += "Great"

		if(alt_intents)
			inspec += "\n<b>ALT-GRIP (RIGHT CLICK WHILE IN HAND)</b>"

		var/shafttext = get_blade_dulling_text(src, verbose = TRUE)
		if(shafttext)
			inspec += "\n<b>SHAFT:</b> [shafttext]"

		if(gripped_intents)
			inspec += "\n<b>TWO-HANDED</b>"

		if(twohands_required)
			inspec += "\n<b>BULKY</b>"

		if(can_parry)
			inspec += "\n<b>DEFENSE:</b> [wdefense_dynamic]"

		if(max_blade_int)
			inspec += "\n<b>SHARPNESS:</b> "
			var/meme = round(((blade_int / max_blade_int) * 100), 1)
			inspec += "[meme]%"

		if(associated_skill && associated_skill.name)
			inspec += "\n<b>SKILL:</b> [associated_skill.name]"
		
		if(intdamage_factor)
			inspec += "\n<b>INTEGRITY DAMAGE:</b> [intdamage_factor * 100]%"

//**** CLOTHING STUFF

		if(istype(src,/obj/item/clothing))
			var/obj/item/clothing/C = src
			inspec += "<br>"
			inspec += C.defense_examine()
			if(C.body_parts_covered)
				inspec += "\n<b>COVERAGE: <br></b>"
				inspec += " | "
				if(C.body_parts_covered == C.body_parts_covered_dynamic)
					for(var/zone in body_parts_covered2organ_names(C.body_parts_covered))
						inspec += "<b>[capitalize(zone)]</b> | "
				else
					var/list/zones = list()
					//We have some part peeled, so we turn the printout into precise mode and highlight the missing coverage.
					for(var/zoneorg in body_parts_covered2organ_names(C.body_parts_covered, precise = TRUE))
						zones += zoneorg
					for(var/zonedyn in body_parts_covered2organ_names(C.body_parts_covered_dynamic, precise = TRUE))
						inspec += "<b>[capitalize(zonedyn)]</b> | "
						if(zonedyn in zones)
							zones.Remove(zonedyn)
					for(var/zone in zones)			
						inspec += "<b><font color = '#7e0000'>[capitalize(zone)]</font></b> | "
				inspec += "<br>"
			if(C.body_parts_inherent)
				inspec += "<b>CANNOT BE PEELED: </b>"
				var/list/inherentList = body_parts_covered2organ_names(C.body_parts_inherent)
				if(length(inherentList) == 1)
					inspec += "<b><font color = '#77cde2'>[capitalize(inherentList[1])]</font></b>"
				else
					inspec += "| "
					for(var/zone in inherentList)
						inspec += "<b><font color = '#77cde2'>[capitalize(zone)]</b></font> | "
			if(C.prevent_crits)
				if(length(C.prevent_crits))
					inspec += "\n<b>PREVENTS CRITS:</b>"
					for(var/X in C.prevent_crits)
						if(X == BCLASS_PICK)	//BCLASS_PICK is named "stab", and "stabbing" is its own damage class. Prevents confusion.
							X = "pick"
						inspec += ("\n<b>[capitalize(X)]</b>")
				inspec += "<br>"

//**** General durability

		if(max_integrity)
			inspec += "\n<b>DURABILITY:</b> "
			var/percent = round(((obj_integrity / max_integrity) * 100), 1)
			inspec += "[percent]% ([obj_integrity])"

		to_chat(usr, "[inspec.Join()]")

/obj/item
	var/simpleton_price = FALSE

/obj/item/get_inspect_button()
	if(has_inspect_verb || (obj_integrity < max_integrity))
		return " <span class='info'><a href='?src=[REF(src)];inspect=1'>{?}</a></span>"
	return ..()


/obj/item/interact(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/item/ui_act(action, params)
	add_fingerprint(usr)
	return ..()

/obj/item/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!user)
		return
	if(anchored)
		return

	if(twohands_required)
		if(HAS_TRAIT(user, TRAIT_TINY))
			to_chat(user, span_warning("[src] is too big for me to carry."))
			return
		if(user.get_num_arms() < 2)
			to_chat(user, span_warning("[src] is too bulky to carry in one hand!"))
			return
		var/obj/item/twohanded/required/H
		H = user.get_inactive_held_item()
		if(get_dist(src,user) > 1)
			return
		if(H != null)
			to_chat(user, span_warning("[src] is too bulky to carry in one hand!"))
			return

	if(w_class == WEIGHT_CLASS_GIGANTIC)
		return

	if(resistance_flags & ON_FIRE)
		var/mob/living/carbon/C = user
		var/can_handle_hot = FALSE
		if(!istype(C))
			can_handle_hot = TRUE
		else if(C.gloves && (C.gloves.max_heat_protection_temperature > 360))
			can_handle_hot = TRUE
		else if(HAS_TRAIT(C, TRAIT_RESISTHEAT) || HAS_TRAIT(C, TRAIT_RESISTHEATHANDS))
			can_handle_hot = TRUE

		if(can_handle_hot)
			extinguish()
			user.visible_message(span_warning("[user] puts out the fire on [src]."))
		else
			user.visible_message(span_warning("[user] burns [user.p_their()] hand putting out the fire on [src]!"))
			extinguish()
			var/obj/item/bodypart/affecting = C.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
			if(affecting && affecting.receive_damage( 0, 5 ))		// 5 burn damage
				C.update_damage_overlays()
			return

	if(acid_level > 20 && !ismob(loc))// so we can still remove the clothes on us that have acid.
		var/mob/living/carbon/C = user
		if(istype(C))
			if(!C.gloves || (!(C.gloves.resistance_flags & (UNACIDABLE|ACID_PROOF))))
				to_chat(user, span_warning("The acid on [src] burns my hand!"))
				var/obj/item/bodypart/affecting = C.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
				if(affecting && affecting.receive_damage( 0, 5 ))		// 5 burn damage
					C.update_damage_overlays()

	if(!(interaction_flags_item & INTERACT_ITEM_ATTACK_HAND_PICKUP))		//See if we're supposed to auto pickup.
		return

	//Heavy gravity makes picking up things very slow.
	var/grav = user.has_gravity()
	if(grav > STANDARD_GRAVITY)
		var/grav_power = min(3,grav - STANDARD_GRAVITY)
		to_chat(user,span_notice("I start picking up [src]..."))
		if(!do_mob(user,src,30*grav_power))
			return


	//If the item is in a storage item, take it out
	SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, user.loc, TRUE)
	if(QDELETED(src)) //moving it out of the storage to the floor destroyed it.
		return

	if(throwing)
		throwing.finalize(FALSE)
	if(loc == user)
		if(!allow_attack_hand_drop(user) || !user.temporarilyRemoveItemFromInventory(src))
			return

	pickup(user)
	add_fingerprint(user)
	if(!user.put_in_active_hand(src, FALSE, FALSE))
		user.dropItemToGround(src)
	else
		if(twohands_required)
			wield(user)

/atom/proc/ontable()
	if(!isturf(src.loc))
		return FALSE
	for(var/obj/structure/table/T in src.loc)
		return TRUE
	for(var/obj/machinery/anvil/A in src.loc)
		return TRUE
	return FALSE

/obj/item/proc/allow_attack_hand_drop(mob/user)
	return TRUE

/obj/item/attack_paw(mob/user)
	if(!user)
		return
	if(anchored)
		return

	SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, user.loc, TRUE)

	if(throwing)
		throwing.finalize(FALSE)
	if(loc == user)
		if(!user.temporarilyRemoveItemFromInventory(src))
			return

	pickup(user)
	add_fingerprint(user)
	if(!user.put_in_active_hand(src, FALSE, FALSE))
		user.dropItemToGround(src)

/obj/item/proc/GetDeconstructableContents()
	return GetAllContents() - src

// afterattack() and attack() prototypes moved to _onclick/item_attack.dm for consistency

/obj/item/proc/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
	if(prob(final_block_chance))
		owner.visible_message(span_danger("[owner] blocks [attack_text] with [src]!"))
		return 1
	return 0

/obj/item/proc/hit_response(mob/living/carbon/human/owner, mob/living/carbon/human/attacker)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_RESPONSE, owner, attacker)		//sends signal for Magic_items. Used to call enchantments effects for worn items

/obj/item/proc/talk_into(mob/M, input, channel, spans, datum/language/language)
	return ITALICS | REDUCE_RANGE

/obj/item/proc/dropped(mob/user, silent = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(user)
	if(item_flags & DROPDEL)
		qdel(src)
		return
	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y)
	if(isturf(loc))
		if(!ontable())
			var/oldy = pixel_y
			pixel_y = pixel_y+5
			animate(src, pixel_y = oldy, time = 0.5)
	if(altgripped || wielded)
		ungrip(user, FALSE)
	item_flags &= ~IN_INVENTORY
	SEND_SIGNAL(src, COMSIG_ITEM_DROPPED,user)
	if(!silent)
		playsound(src, drop_sound, DROP_SOUND_VOLUME, TRUE, ignore_walls = FALSE)
	user.update_equipment_speed_mods()
	update_transform()

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_PICKUP, user)
	item_flags |= IN_INVENTORY

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// The slot == refers to the new location of the item
// Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
/obj/item/proc/equipped(mob/user, slot, initial = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot)
	for(var/X in actions)
		var/datum/action/A = X
		if(item_action_slot_check(slot, user)) //some items only give their actions buttons when in a specific slot.
			A.Grant(user)
	item_flags |= IN_INVENTORY
	if(!initial)
		var/slotbit = slotdefine2slotbit(slot)
		if(user.m_intent != MOVE_INTENT_SNEAK) // Sneaky sheathing/equipping
			if(slot == ITEM_SLOT_HANDS)
				playsound(src, pickup_sound, PICKUP_SOUND_VOLUME, ignore_walls = FALSE)
			if(slotbit == ITEM_SLOT_HIP | ITEM_SLOT_BACK_R | ITEM_SLOT_BACK_L)
				playsound(src, sheathe_sound, SHEATHE_SOUND_VOLUME, ignore_walls = FALSE)
			else if(equip_sound &&(slot_flags & slotbit))
				playsound(src, equip_sound, EQUIP_SOUND_VOLUME, TRUE, ignore_walls = FALSE)
	user.update_equipment_speed_mods()

	if(!user.is_holding(src))
		if(altgripped || wielded)
			ungrip(user, FALSE)
	if(twohands_required)
		if(slot == SLOT_HANDS)
			wield(user)
		else
			ungrip(user)
	
	if (isliving(user) && slot != ITEM_SLOT_HANDS)
		var/mob/living/living_user = user
		living_user.rebuild_obscured_flags() // AZURE EDIT: cache our equipped items `flags_inv` values

	update_transform()

//sometimes we only want to grant the item's action if it's equipped in a specific slot.
/obj/item/proc/item_action_slot_check(slot, mob/user)
	if(slot == SLOT_IN_BACKPACK || slot == SLOT_LEGCUFFED) //these aren't true slots, so avoid granting actions there
		return FALSE
	return TRUE

//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
//if this is being done by a mob other than M, it will include the mob equipper, who is trying to equip the item to mob M. equipper will be null otherwise.
//If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
//Set disable_warning to TRUE if you wish it to not give you outputs.
/obj/item/proc/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(twohands_required)
		if(!disable_warning)
			to_chat(M, span_warning("[src] is too bulky to carry with anything but my hands!"))
		return 0
	if(!M)
		return FALSE
	if(HAS_TRAIT(M, TRAIT_CHUNKYFINGERS) && (!equipper || equipper == M) && src.type != /obj/item/grabbing/bite) //If a zombie's trying to put something on without assistance that's not a bite
		to_chat(M, span_warning("...What?"))
		return FALSE

	return M.can_equip(src, slot, disable_warning, bypass_equip_delay_self)

/obj/item/verb/verb_pickup()
	set src in oview(1)
	set hidden = 1
	set name = "Pick up"

	if(usr.incapacitated() || !Adjacent(usr))
		return

	if(isliving(usr))
		var/mob/living/L = usr
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return

	if(usr.get_active_held_item() == null) // Let me know if this has any problems -Yota
		usr.UnarmedAttack(src)

//This proc is executed when someone clicks the on-screen UI button.
//The default action is attack_self().
//Checks before we get to here are: mob is alive, mob is not restrained, stunned, asleep, resting, laying, item is on the mob.
/obj/item/proc/ui_action_click(mob/user, actiontype)
	attack_self(user)

/obj/item/proc/IsReflect(def_zone) //This proc determines if and at what% an object will reflect energy projectiles if it's in l_hand,r_hand or wear_armor
	return 0

/obj/item/proc/eyestab(mob/living/carbon/M, mob/living/carbon/user)

	var/is_human_victim
	var/obj/item/bodypart/affecting = M.get_bodypart(BODY_ZONE_HEAD)
	if(ishuman(M))
		if(!affecting) //no head!
			return
		is_human_victim = TRUE

	if(M.is_eyes_covered())
		// you can't stab someone in the eyes wearing a mask!
		to_chat(user, span_warning("You're going to need to remove [M.p_their()] eye protection first!"))
		return

	if(isbrain(M))
		to_chat(user, span_warning("I cannot locate any organic eyes on this brain!"))
		return

	src.add_fingerprint(user)

	playsound(loc, src.hitsound, 30, TRUE, -1)

	user.do_attack_animation(M)

	if(M != user)
		M.visible_message(span_danger("[user] has stabbed [M] in the eye with [src]!"), \
							span_danger("[user] stabs you in the eye with [src]!"))
	else
		user.visible_message( \
			span_danger("[user] has stabbed [user.p_them()]self in the eyes with [src]!"), \
			span_danger("I stab myself in the eyes with [src]!") \
		)
	if(is_human_victim)
		var/mob/living/carbon/human/U = M
		U.apply_damage(7, BRUTE, affecting)

	else
		M.take_bodypart_damage(7)

	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "eye_stab", /datum/mood_event/eye_stab)

	log_combat(user, M, "attacked", "[src.name]", "(INTENT: [uppertext(user.used_intent)])")

	var/obj/item/organ/eyes/eyes = M.getorganslot(ORGAN_SLOT_EYES)
	if (!eyes)
		return
	M.adjust_blurriness(3)
	eyes.applyOrganDamage(rand(2,4))
	if(eyes.damage >= 10)
		M.adjust_blurriness(15)
		if(M.stat != DEAD)
			to_chat(M, span_danger("My eyes start to bleed profusely!"))
		if(!(HAS_TRAIT(M, TRAIT_BLIND) || HAS_TRAIT(M, TRAIT_NEARSIGHT)))
			to_chat(M, span_danger("I become nearsighted!"))
		M.become_nearsighted(EYE_DAMAGE)
		if(prob(50))
			if(M.stat != DEAD)
				if(M.drop_all_held_items())
					to_chat(M, span_danger("I drop what I'm holding and clutch at my eyes!"))
			M.adjust_blurriness(10)
			M.Unconscious(20)
			M.Paralyze(40)
		if (prob(eyes.damage - 10 + 1))
			M.become_blind(EYE_DAMAGE)
			to_chat(M, span_danger("I go blind!"))

/obj/item/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(hit_atom && !QDELETED(hit_atom))
		SEND_SIGNAL(src, COMSIG_MOVABLE_IMPACT, hit_atom, throwingdatum)
		if(get_temperature() && isliving(hit_atom))
			var/mob/living/L = hit_atom
			L.IgniteMob()
		var/itempush = 0
		if(w_class < 4)
			itempush = 0 //too light to push anything
		if(istype(hit_atom, /mob/living)) //Living mobs handle hit sounds differently.
			var/volume = get_volume_by_throwforce_and_or_w_class()
			if (throwforce > 0)
				if (mob_throw_hit_sound)
					playsound(hit_atom, mob_throw_hit_sound, volume, TRUE, -1)
				else if(hitsound)
					playsound(hit_atom, pick(hitsound), volume, TRUE, -1)
				else
					playsound(hit_atom, 'sound/blank.ogg',volume, TRUE, -1)
			else
				playsound(hit_atom, 'sound/blank.ogg', 1, volume, -1)

		else
			playsound(src, drop_sound, YEET_SOUND_VOLUME, TRUE, ignore_walls = FALSE)
		return hit_atom.hitby(src, 0, itempush, throwingdatum=throwingdatum, damage_flag = thrown_damage_flag)

/obj/item/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force)
	thrownby = thrower
	callback = CALLBACK(src, PROC_REF(after_throw), callback) //replace their callback with our own
	. = ..(target, range, speed, thrower, spin, diagonals_first, callback, force)


/obj/item/proc/after_throw(datum/callback/callback)
	if (callback) //call the original callback
		. = callback.Invoke()
	item_flags &= ~IN_INVENTORY
	if(!pixel_y && !pixel_x)
		pixel_x = rand(-8,8)
		pixel_y = rand(-8,8)


/obj/item/proc/remove_item_from_storage(atom/newLoc) //please use this if you're going to snowflake an item out of a obj/item/storage
	if(!newLoc)
		return FALSE
	if(SEND_SIGNAL(loc, COMSIG_CONTAINS_STORAGE))
		return SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, newLoc, TRUE)
	return FALSE

/obj/item/proc/get_belt_overlay() //Returns the icon used for overlaying the object on a belt
	return mutable_appearance('icons/obj/clothing/belt_overlays.dmi', icon_state)

/obj/item/proc/update_slot_icon()
	if(!ismob(loc))
		return
	var/mob/owner = loc
	var/mob/living/carbon/human/H
	if(ishuman(owner))
		H = owner
	var/flags = slot_flags
//	if(flags & ITEM_SLOT_OCLOTHING)
//		owner.update_inv_wear_suit()
//	if(flags & ITEM_SLOT_ICLOTHING)
//		owner.update_inv_w_uniform()
	if(flags & ITEM_SLOT_GLOVES)
		owner.update_inv_gloves()
//	if(flags & ITEM_SLOT_HEAD)
//		owner.update_inv_glasses()
//	if(flags & ITEM_SLOT_HEAD)
//		owner.update_inv_ears()
	if(flags & ITEM_SLOT_MASK)
		owner.update_inv_wear_mask()
	if(flags & ITEM_SLOT_SHOES)
		owner.update_inv_shoes()
	if(flags & ITEM_SLOT_RING)
		owner.update_inv_wear_id()
	if(flags & ITEM_SLOT_WRISTS)
		owner.update_inv_wrists()
	if(flags & ITEM_SLOT_BACK)
		owner.update_inv_back()
	if(flags & ITEM_SLOT_NECK)
		owner.update_inv_neck()
	if(flags & ITEM_SLOT_PANTS)
		owner.update_inv_pants()
	if(flags & ITEM_SLOT_CLOAK)
		owner.update_inv_cloak()
	if(H)
		if(flags & ITEM_SLOT_HEAD && H.head == src)
			owner.update_inv_head()
		if(flags & ITEM_SLOT_ARMOR && H.wear_armor == src)
			owner.update_inv_armor()
		if(flags & ITEM_SLOT_SHIRT && H.wear_shirt == src)
			owner.update_inv_shirt()
		if(flags & ITEM_SLOT_MOUTH && H.mouth == src)
			owner.update_inv_mouth()
		if(flags & ITEM_SLOT_BELT && H.belt == src)
			owner.update_inv_belt()
		if(flags & ITEM_SLOT_HIP && (H.beltr == src || H.beltl == src) )
			owner.update_inv_belt()
	else
		if(flags & ITEM_SLOT_HEAD)
			owner.update_inv_head()
		if(flags & ITEM_SLOT_ARMOR)
			owner.update_inv_armor()
		if(flags & ITEM_SLOT_SHIRT)
			owner.update_inv_shirt()
		if(flags & ITEM_SLOT_MOUTH)
			owner.update_inv_mouth()
		if(flags & ITEM_SLOT_BELT)
			owner.update_inv_belt()
		if(flags & ITEM_SLOT_HIP)
			owner.update_inv_belt()


///Returns the temperature of src. If you want to know if an item is hot use this proc.
/obj/item/proc/get_temperature()
	return heat

///Returns the sharpness of src. If you want to get the sharpness of an item use this.
/obj/item/proc/get_sharpness()
	//Oh no, we are dulled out!
	if(max_blade_int && (blade_int <= 0))
		return FALSE
	var/max_sharp = sharpness
	for(var/datum/intent/intent as anything in possible_item_intents)
		if(initial(intent.blade_class) == BCLASS_CUT)
			max_sharp = max(max_sharp, IS_SHARP)
		if(initial(intent.blade_class) == BCLASS_CHOP)
			max_sharp = max(max_sharp, IS_SHARP)
	return max_sharp

/obj/item/proc/get_dismemberment_chance(obj/item/bodypart/affecting, mob/user)
	if(!affecting.can_dismember(src))
		return 0
	if((get_sharpness() || damtype == BURN) && (w_class >= WEIGHT_CLASS_NORMAL) && force >= 10)
		return force * (affecting.get_damage() / affecting.max_damage)

/obj/item/proc/get_dismember_sound()
	if(damtype == BURN)
		. = 'sound/blank.ogg'
	else
		. = "desceration"

/obj/item/proc/open_flame(flame_heat=700)
	var/turf/location = loc
	if(ismob(location))
		var/mob/M = location
		var/success = FALSE
		if(src == M.get_item_by_slot(SLOT_WEAR_MASK))
			success = TRUE
		if(success)
			location = get_turf(M)
	if(isturf(location))
		location.hotspot_expose(flame_heat, 5)


/obj/item/proc/ignition_effect(atom/A, mob/user)
	if(get_temperature())
		. = "<span class='notice'>[user] lights [A] with [src].</span>"
	else
		. = ""

/obj/item/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_flag = "blunt")
	return SEND_SIGNAL(src, COMSIG_ATOM_HITBY, AM, skipcatch, hitpush, blocked, throwingdatum, damage_flag)

/obj/item/attack_animal(mob/living/simple_animal/M)
	if (obj_flags & CAN_BE_HIT)
		return ..()
	return 0

/obj/item/burn()
	if(!QDELETED(src))
		var/turf/T = get_turf(src)
		var/ash_type = /obj/item/ash
		if(w_class == WEIGHT_CLASS_HUGE || w_class == WEIGHT_CLASS_GIGANTIC)
			ash_type = /obj/item/ash
		var/obj/item/ash/A = new ash_type(T)
		A.desc += "\nLooks like this used to be \an [name] some time ago."
		..()

/obj/item/acid_melt()
	if(!QDELETED(src))
		var/turf/T = get_turf(src)
		var/obj/effect/decal/cleanable/molten_object/MO = new(T)
		MO.pixel_x = rand(-16,16)
		MO.pixel_y = rand(-16,16)
		MO.desc = ""
		..()

/obj/item/proc/heating_act()
	return

/obj/item/proc/on_mob_death(mob/living/L, gibbed)

/obj/item/proc/grind_requirements() //Used to check for extra requirements for grinding an object
	return TRUE

 //Called BEFORE the object is ground up - use this to change grind results based on conditions
 //Use "return -1" to prevent the grinding from occurring
/obj/item/proc/on_grind()

/obj/item/proc/on_juice()

/obj/item/proc/get_force_string(var/force)
	switch(force)
		if(0 to 9)
			return "Puny"
		if(10 to 14)
			return "Weak"
		if(15 to 19)
			return "Modest"
		if(20 to 24)
			return "Fine"
		if(25 to 29)
			return "Great"
		if(30 to 35)
			return "Grand"
		else
			return "Mighty"

/obj/item/MouseEntered(location, control, params)
	. = ..()

/obj/item/MouseExited()
	. = ..()
	deltimer(tip_timer)//delete any in-progress timer if the mouse is moved off the item before it finishes
	closeToolTip(usr)


// Called when a mob tries to use the item as a tool.
// Handles most checks.
/obj/item/proc/use_tool(atom/target, mob/living/user, delay, amount=0, volume=0, datum/callback/extra_checks)
	// No delay means there is no start message, and no reason to call tool_start_check before use_tool.
	// Run the start check here so we wouldn't have to call it manually.
	if(!delay && !tool_start_check(user, amount))
		return

	var/skill_modifier = 1

	delay *= toolspeed * skill_modifier

	// Play tool sound at the beginning of tool usage.
	play_tool_sound(target, volume)

	if(delay)
		// Create a callback with checks that would be called every tick by do_after.
		var/datum/callback/tool_check = CALLBACK(src, PROC_REF(tool_check_callback), user, amount, extra_checks)

		if(ismob(target))
			if(!do_mob(user, target, delay, extra_checks=tool_check))
				return

		else
			if(!do_after(user, delay, target=target, extra_checks=tool_check))
				return
	else
		// Invoke the extra checks once, just in case.
		if(extra_checks && !extra_checks.Invoke())
			return

	// Use tool's fuel, stack sheets or charges if amount is set.
	if(amount && !use(amount))
		return

	// Play tool sound at the end of tool usage,
	// but only if the delay between the beginning and the end is not too small
	if(delay >= MIN_TOOL_SOUND_DELAY)
		play_tool_sound(target, volume)

	return TRUE

// Called before use_tool if there is a delay, or by use_tool if there isn't.
// Only ever used by welding tools and stacks, so it's not added on any other use_tool checks.
/obj/item/proc/tool_start_check(mob/living/user, amount=0)
	return tool_use_check(user, amount)

// A check called by tool_start_check once, and by use_tool on every tick of delay.
/obj/item/proc/tool_use_check(mob/living/user, amount)
	return !amount

// Generic use proc. Depending on the item, it uses up fuel, charges, sheets, etc.
// Returns TRUE on success, FALSE on failure.
/obj/item/proc/use(used)
	return !used

// Plays item's usesound, if any.
/obj/item/proc/play_tool_sound(atom/target, volume=50)
	if(target && usesound && volume)
		var/played_sound = usesound

		if(islist(usesound))
			played_sound = pick(usesound)

		playsound(target, played_sound, volume, TRUE)

// Used in a callback that is passed by use_tool into do_after call. Do not override, do not call manually.
/obj/item/proc/tool_check_callback(mob/living/user, amount, datum/callback/extra_checks)
	return tool_use_check(user, amount) && (!extra_checks || extra_checks.Invoke())

// Returns a numeric value for sorting items used as parts in machines, so they can be replaced by the rped
/obj/item/proc/get_part_rating()
	return 0

/obj/item/doMove(atom/destination)
	if (ismob(loc))
		var/mob/M = loc
		var/hand_index = M.get_held_index_of_item(src)
		if(hand_index)
			M.held_items[hand_index] = null
			M.update_inv_hands()
			if(M.client)
				M.client.screen -= src
			layer = initial(layer)
			plane = initial(plane)
			appearance_flags &= ~NO_CLIENT_COLOR
			dropped(M, TRUE)
	return ..()

/obj/item/throw_at(atom/target, range, speed, mob/thrower, spin=TRUE, diagonals_first = FALSE, datum/callback/callback)
	if(HAS_TRAIT(src, TRAIT_NODROP))
		return
	return ..()

/obj/item/proc/canStrip(mob/stripper, mob/owner)
	return !HAS_TRAIT(src, TRAIT_NODROP)

/obj/item/proc/doStrip(mob/stripper, mob/owner)
	return owner.dropItemToGround(src)

/obj/item/update_icon()
	. = ..()
	update_transform()

/obj/item/proc/ungrip(mob/living/carbon/user, show_message = TRUE)
	if(!user)
		return
	if(twohands_required)
		if(!wielded)
			return
		if(show_message)
			to_chat(user, span_notice("I drop [src]."))
		show_message = FALSE
	if(wielded)
		wielded = FALSE
		if(force_wielded)
			force_dynamic = force
		wdefense_dynamic = wdefense
	if(altgripped)
		altgripped = FALSE
	update_transform()
	if(user.get_item_by_slot(SLOT_BACK) == src)
		user.update_inv_back()
	else
		user.update_inv_hands()
	if(show_message)
		to_chat(user, "<span class='notice'>I wield [src] normally.</span>")
	if(user.get_active_held_item() == src)
		user.update_a_intents()
	icon_angle = initial(icon_angle)
	return

/obj/item/proc/altgrip(mob/living/carbon/user)
	if(altgripped)
		return
	altgripped = TRUE
	update_transform()
	to_chat(user, span_notice("I wield [src] with an alternate grip"))
	if(user.get_active_held_item() == src)
		if(alt_intents)
			user.update_a_intents()

/obj/item/proc/wield(mob/living/carbon/user)
	if(wielded)
		return
	if(user.get_inactive_held_item())
		to_chat(user, span_warning("I need a free hand first."))
		return
	if(user.get_num_arms() < 2)
		to_chat(user, span_warning("I don't have enough hands."))
		return
	if (obj_broken)
		to_chat(user, span_warning("It's completely broken."))
		return
	wielded = TRUE
	if(force_wielded)
		force_dynamic = force_wielded
	wdefense_dynamic = (wdefense + wdefense_wbonus)
	update_transform()
	to_chat(user, span_notice("I wield [src] with both hands."))
	playsound(loc, pick('sound/combat/weaponr1.ogg','sound/combat/weaponr2.ogg'), 100, TRUE)
	if(twohands_required)
		if(!wielded)
			user.dropItemToGround(src)
			return
	user.update_a_intents()
	user.update_inv_hands()
	icon_angle = icon_angle_wielded

/obj/item/attack_self(mob/user)
	. = ..()
	if(twohands_required)
		return
	if(altgripped || wielded) //Trying to unwield it
		ungrip(user)
		return
	if(alt_intents && !gripped_intents)
		altgrip(user)
	if(gripped_intents)
		wield(user)

/obj/item/equip_to_best_slot(mob/M)
	if(..())
		if(altgripped || wielded)
			ungrip(M, FALSE)

/obj/item/proc/on_embed(obj/item/bodypart/bp)
	return

/obj/item/proc/defense_examine()
	var/list/str = list()
	if(istype(src, /obj/item/clothing))
		var/obj/item/clothing/C = src
		if(C.armor)
			var/defense = "<u><b>ABSORPTION: </b></u><br>"
			var/datum/armor/def_armor = C.armor
			defense += "[colorgrade_rating("BLUNT", def_armor.blunt, elaborate = TRUE)] | "
			defense += "[colorgrade_rating("SLASH", def_armor.slash, elaborate = TRUE)] | "
			defense += "[colorgrade_rating("STAB", def_armor.stab, elaborate = TRUE)] | "
			defense += "[colorgrade_rating("PIERCING", def_armor.piercing, elaborate = TRUE)] "
			str += "[defense]<br>"
		else
			str += "NO DEFENSE"
	return str

/obj/item/obj_break(damage_flag)
	..()

	update_damaged_state()
	if(!ismob(loc))
		return
	var/mob/M = loc

	if(altgripped || wielded)
		ungrip(M, FALSE)

	to_chat(M, "\The [src] BREAKS...!")

/obj/item/obj_fix()
	..()
	update_damaged_state()

/obj/item/obj_destruction(damage_flag)
	if (damage_flag == "acid")
		obj_destroyed = TRUE
		acid_melt()
		return TRUE
	if (damage_flag == "fire")
		obj_destroyed = TRUE
		burn()
		return TRUE
	if (ismob(loc) && !always_destroy)
		return FALSE

	obj_destroyed = TRUE
	if(destroy_sound)
		playsound(src, destroy_sound, 100, TRUE)
	if(destroy_message)
		visible_message(destroy_message)
	deconstruct(FALSE)

	return TRUE

/obj/item/proc/update_damaged_state()
	cut_overlays()
	if (!obj_broken)
		return
	var/icon/damaged_icon = icon(initial(icon), icon_state, , TRUE)
	damaged_icon.Blend("#fff", ICON_ADD)
	damaged_icon.Blend(icon(dam_icon, dam_icon_state), ICON_MULTIPLY)
	var/mutable_appearance/damage = new(damaged_icon)
	damage.alpha = 150
	add_overlay(damage)

/// Proc that is only called with the Peel intent. Stacks consecutive hits, shreds coverage once a threshold is met. Thresholds are defined on /obj/item
/obj/item/proc/peel_coverage(bodypart, divisor)
	var/coveragezone = attackzone2coveragezone(bodypart)
	if(!(body_parts_inherent & coveragezone))
		if(!last_peeled_limb || coveragezone == last_peeled_limb)
			if(divisor >= peel_threshold)
				peel_count += divisor ? (peel_threshold / divisor ) : 1
			else if(divisor < peel_threshold)
				peel_count++
			if(peel_count >= peel_threshold)
				body_parts_covered_dynamic &= ~coveragezone
				playsound(src, 'sound/foley/peeled_coverage.ogg', 100)
				var/list/peeledpart = body_parts_covered2organ_names(coveragezone, precise = TRUE)
				var/parttext
				if(length(peeledpart))
					parttext = peeledpart[1]	//There should really only be one bodypart that gets exposed here.
				visible_message("<font color = '#f5f5f5'><b>[parttext ? parttext : "Coverage"]</font></b> gets peeled off of [src]!")
				reset_peel(success = TRUE)
			else
				visible_message(span_info("Peel strikes [src]! <b>[ROUND_UP(peel_count)]</b>!"))
		else
			last_peeled_limb = coveragezone
			reset_peel()
	else
		last_peeled_limb = coveragezone
		reset_peel()

/obj/item/proc/repair_coverage()
	body_parts_covered_dynamic = body_parts_covered
	reset_peel()

/obj/item/proc/reset_peel(success = FALSE)
	if(peel_count > 0 && !success)
		visible_message(span_info("Peel count lost on [src]!"))
	peel_count = 0

/obj/item/proc/reduce_peel(amt)
	if(peel_count > amt)
		peel_count -= amt
	else
		peel_count = 0
	visible_message(span_info("Peel reduced to [peel_count == 0 ? "none" : "[peel_count]"] on [src]!"))

/obj/item/proc/attackzone2coveragezone(location)
	switch(location)
		if(BODY_ZONE_HEAD)
			return HEAD
		if(BODY_ZONE_PRECISE_EARS)
			return EARS
		if(BODY_ZONE_PRECISE_SKULL)
			return HAIR
		if(BODY_ZONE_PRECISE_NOSE)
			return NOSE
		if(BODY_ZONE_PRECISE_NECK)
			return NECK
		if(BODY_ZONE_PRECISE_L_EYE)
			return LEFT_EYE
		if(BODY_ZONE_PRECISE_R_EYE)
			return RIGHT_EYE
		if(BODY_ZONE_PRECISE_MOUTH)
			return MOUTH
		if(BODY_ZONE_CHEST)
			return CHEST
		if(BODY_ZONE_PRECISE_STOMACH)
			return VITALS
		if(BODY_ZONE_PRECISE_GROIN)
			return GROIN
		if(BODY_ZONE_L_ARM)
			return ARM_LEFT
		if(BODY_ZONE_R_ARM)
			return ARM_RIGHT
		if(BODY_ZONE_L_LEG)
			return LEG_LEFT
		if(BODY_ZONE_R_LEG)
			return LEG_RIGHT
		if(BODY_ZONE_LAMIAN_TAIL)
			return TAIL_LAMIA
		if(BODY_ZONE_PRECISE_L_HAND)
			return HAND_LEFT
		if(BODY_ZONE_PRECISE_R_HAND)
			return HAND_RIGHT
		if(BODY_ZONE_PRECISE_L_FOOT)
			return FOOT_LEFT
		if(BODY_ZONE_PRECISE_R_FOOT)
			return FOOT_RIGHT

/obj/item/examine(mob/user)
	. = ..()
	if(isliving(user))
		var/mob/living/L = user
		if(L.STAINT < 9)
			return .
	if(isnull(anvilrepair) && isnull(sewrepair))
		return .
	else
		var/str = "This object can be repaired using "
		if(anvilrepair)	
			var/datum/skill/S = anvilrepair		//Should only ever be a skill or null
			str += "<b>[initial(S.name)]</b> and a hammer."
		if(sewrepair)
			str += "<b>Sewing</b> and a needle."
		str = span_info(str)
		. += str

/obj/item/proc/step_action() //this was made to rewrite clown shoes squeaking, moved here to avoid throwing runtimes with non-/clothing wearables
	SEND_SIGNAL(src, COMSIG_CLOTHING_STEP_ACTION)
