//Target practise
/obj/structure/target_dynamic
	name = "generic target"
	desc = "A mounted target configured to resemble: [target_name]."
	icon = ""
	icon_state = "generic"
	soft_armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = XENO_BOMB_RESIST_0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	hard_armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = XENO_BOMB_RESIST_0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	max_integrity = 1000000 //TODO: make this clean
	obj_flags =
	var/obj/machinery/computer/firing_range/linked_computer = null
	var/target_name = "Generic Target"
	var/target_integrity = 100
	var/integrity_crit = 0 //For when a target would get into crit
	var/available_targets = list(
		"Boiler" = list(/datum/xeno_caste/boiler/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Bull" = list(/datum/xeno_caste/bull/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Carrier" = list(/datum/xeno_caste/carrier/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Crusher" = list(/datum/xeno_caste/crusher/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Defender" = list(/datum/xeno_caste/defender/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Defiler" = list(/datum/xeno_caste/defiler/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Drone" = list(/datum/xeno_caste/drone/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Hivelord" = list(/datum/xeno_caste/hivelord/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Hunter" = list(/datum/xeno_caste/hunter/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Praetorian" = list(/datum/xeno_caste/praetorian/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Queen" = list(/datum/xeno_caste/queen/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Ravager" = list(/datum/xeno_caste/ravager/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Runner" = list(/datum/xeno_caste/runner/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Sentinel" = list(/datum/xeno_caste/sentinel/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Shrike" = list(/datum/xeno_caste/shrike/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Spitter" = list(/datum/xeno_caste/spitter/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Warrior" = list(/datum/xeno_caste/warrior/, list("young","elder","mature","ancient"), "ICON_STATE"),
		"Wraith" = list(/datum/xeno_caste/wraith/, list("young","elder","mature","ancient"), "ICON_STATE"),
	)

/obj/structure/target_dynamic/Initialize()
	. = ..()
	color = rgb(#ffffff)

/obj/structure/target_dynamic/take_damage(damage_amount, damage_type, damage_flag, effects, attack_dir, armour_penetration)
	. = ..()
	if (integrity <= 0)
		color = rgb(#444444)
	if (integrity <= integrity_crit)
		color = rgb(#c82e2e)
		return
	color = BlendRGB(rgb(#00ff00), rgb(#ff8800), integrity/max_integrity)

/obj/structure/target_dynamic/proc/set_target(target_type)
	if (!target_type)
		return
	for
