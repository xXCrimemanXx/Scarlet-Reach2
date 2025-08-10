/obj/effect/proc_holder/spell/invoked/projectile/frostbolt // to do: get scroll icon
	name = "Frost Bolt"
	desc = "A ray of frozen energy, slowing the first thing it touches and lightly damaging it."
	range = 8
	projectile_type = /obj/projectile/magic/frostbolt
	overlay_state = "frost_bolt"
	sound = list('sound/magic/whiteflame.ogg')
	active = FALSE

	releasedrain = 30
	chargedrain = 1
	chargetime = 8
	recharge_time = 13 SECONDS //cooldown

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	antimagic_allowed = FALSE //can you use it if you are antimagicked?
	charging_slowdown = 3
	spell_tier = 2
	invocation = "Sagitta Glaciei!"
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_LOW
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane //can be arcane, druidic, blood, holy
	cost = 3

	xp_gain = TRUE
	miracle = FALSE

/obj/effect/proc_holder/spell/self/frostbolt/cast(mob/user = usr)
	var/mob/living/target = user
	target.visible_message(span_warning("[target] hurls a frosty beam!"), span_notice("You hurl a frosty beam!"))
	. = ..()

/obj/projectile/magic/frostbolt
	name = "Frost Dart"
	icon_state = "ice_2"
	damage = 25
	damage_type = BURN
	flag = "magic"
	range = 10
	speed = 1
	var/aoe_range = 0

/obj/projectile/magic/frostbolt/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			L.apply_status_effect(/datum/status_effect/buff/frostbite)
			new /obj/effect/temp_visual/snap_freeze(get_turf(L))
	qdel(src)
