/obj/machinery/computer/firing_range
	name = "Firing Range Console"
	desc = "A computer managing a firing range target."
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "terminal1"
	interaction_flags = INTERACT_MACHINE_TGUI
	//Offset to spawn the target in.
	var/offset_x = 5
	var/offset_y = 2
	//Save all the damage done to the object. 2-index based. ID and list of damage and target health at the moment
	var/damage_list = list()
	//Timer to reset itself if left idle.
	var/idle_reset_timer = null
	var/obj/structure/target_dynamic/spawned_target = null
	// Assoc list used to whitelist xeno castes. (Datumpath, Young?, Mature?, Elder?, Ancient?)
	var/xeno_caste_list = list(
		"Boiler" = list(/datum/xeno_caste/boiler, TRUE, TRUE, TRUE, TRUE),
		"Bull" = list(/datum/xeno_caste/bull, TRUE, TRUE, TRUE, TRUE),
		"Carrier" = list(/datum/xeno_caste/carrier, TRUE, TRUE, TRUE, TRUE),
		"Crusher" = list(/datum/xeno_caste/crusher, TRUE, TRUE, TRUE, TRUE),
		"Defender" = list(/datum/xeno_caste/defender, TRUE, TRUE, TRUE, TRUE),
		"Defiler" = list(/datum/xeno_caste/defiler, TRUE, TRUE, TRUE, TRUE),
		"Drone" = list(/datum/xeno_caste/drone, TRUE, TRUE, TRUE, TRUE),
		"Hivelord" = list(/datum/xeno_caste/hivelord, TRUE, TRUE, TRUE, TRUE),
		"Hunter" = list(/datum/xeno_caste/hunter, TRUE, TRUE, TRUE, TRUE),
		"Praetorian" = list(/datum/xeno_caste/praetorian, TRUE, TRUE, TRUE, TRUE),
		"Queen" = list(/datum/xeno_caste/queen, TRUE, TRUE, TRUE, TRUE),
		"Ravager" = list(/datum/xeno_caste/ravager, TRUE, TRUE, TRUE, TRUE),
		"Runner" = list(/datum/xeno_caste/runner, TRUE, TRUE, TRUE, TRUE),
		"Sentinel" = list(/datum/xeno_caste/sentinel, TRUE, TRUE, TRUE, TRUE),
		"Shrike" = list(/datum/xeno_caste/shrike, TRUE, TRUE, TRUE, TRUE),
		"Spitter" = list(/datum/xeno_caste/spitter, TRUE, TRUE, TRUE, TRUE),
		"Warrior" = list(/datum/xeno_caste/warrior, TRUE, TRUE, TRUE, TRUE),
		"Wraith" = list(/datum/xeno_caste/wraith, TRUE, TRUE, TRUE, TRUE),
	)
/obj/machinery/computer/firing_range/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		ui = new(user, src, "FiringRange", name)
		ui.open()

/obj/machinery/computer/firing_range/ui_data(mob/user)
	var/list/data = list()
		if(spawned_target)
			data["active_target"] = TRUE
			for(var/i in damage_list)
				var/dataset = list() //Damage value and target_health at every point
				dataset["[damage_list[i][1]"] = list()
				dataset["[damage_list[i][1]"]["damage"] = damage_list[i][2]
				dataset["[damage_list[i][1]"]["target_health"] = damage_list[i][3]
				data["damage_logs"] += list(dataset)
			data["target_health"] = spawned_target.target_health
			data["target_name"] = spawned_target.target_name
		else
			data["active_target"] = FALSE
			for(var/i in xeno_caste_list)
				var/dataset = list() //2-index based Array. Caste name and list of availability of the 4 evo stages.
				dataset["[i]"] = list()
				dataset["[i]"]["young"] = TRUE
				dataset["[i]"]["mature"] = TRUE
				dataset["[i]"]["elder"] = FALSE
				dataset["[i]"]["ancient"] = TRUE
				data["available_castes"] += dataset
	return data

/obj/machinery/computer/firing_range/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("reset")
			if(spawned_target)
				QDEL(spawned_target)
		if("spawn")
			var/datumpath
			for(var/i in xeno_caste_list)
			if(params["[i]"])
				if(xeno_caste_list["[i]"])
					datumpath = xeno_caste_list[i]
					break
			if(!datumpath) // Key to the list doesn't yield a /datum/. Bad or malicious input.
				log_world("### [src] at [AREACOORD(src)] couldn't find a suitable xeno_caste to imitate")
				return TRUE
			if(params["Young"])
				datumpath = datumpath.young
			if(params["Mature"])
				datumpath = datumpath.mature
			if(params["Elder"])
				datumpath = datumpath.elder
			if(params["Ancient"])
				datumpath = datumpath.ancient
			if(!ispath(datumpath)) // If more than one EvoStage is given, might result in /datum/xeno_caste/runner/young/elder...
				log_world("### [src]'s datumpath yields no viable result: ([datumpath]). [AREACOORD(src)]")
				return TRUE
			spawn_target(datumpath)
			return TRUE
	return FALSE



// type should be sanitized beforehand.
/obj/machinery/computer/firing_range/proc/spawn_target(type)
	if (spawned_target)
		spawned_target.set_target_type(type)
		return
	var/turf/T = locate(x + offset_x, y + offset_y, z)
	if (!T) //Out of bounds
		log_world("### [src] attempted to spawn a target out of bounds. Offset:([offset_x],[offset_y]) [AREACOORD(src)]")
		return
	if (isopenturf(T))
		spawner_target = new(T)
		spawner_target.set_target_type(type)
		return
	say("Warning: Cannot deploy Target inside a wall!")
	return
