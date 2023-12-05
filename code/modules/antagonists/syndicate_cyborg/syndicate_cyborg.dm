/datum/antagonist/syndicate_cyborg
	id = ROLE_SYNDICATE_ROBOT
	display_name = "\improper Syndicate cyborg"
	antagonist_icon = "syndieborg"
	remove_on_death = TRUE
	remove_on_clone = TRUE
	faction = FACTION_SYNDICATE

	is_compatible_with(datum/mind/mind)
		return isrobot(mind.current)

	give_equipment()
		if (!isrobot(src.owner.current))
			return FALSE

		var/mob/living/silicon/cyborg = src.owner.current
		cyborg.law_rack_connection = ticker?.ai_law_rack_manager?.default_ai_rack_syndie
		cyborg.syndicate = TRUE
		cyborg.show_laws()
		cyborg.add_radio_upgrade(new/obj/item/device/radio_upgrade/syndicatechannel)

	remove_equipment()
		if (!isrobot(src.owner.current))
			return FALSE

		var/mob/living/silicon/cyborg = src.owner.current
		cyborg.law_rack_connection = ticker?.ai_law_rack_manager?.default_ai_rack
		cyborg.syndicate = FALSE
		cyborg.show_laws()
		cyborg.remove_radio_upgrade()

	add_to_image_groups()
		. = ..()
		var/image/image = image('icons/mob/antag_overlays.dmi', icon_state = src.antagonist_icon)
		var/datum/client_image_group/image_group = get_image_group(ROLE_TRAITOR)
		image_group.add_mind_mob_overlay(src.owner, image)
		image_group.add_mind(src.owner)

		get_image_group(ROLE_NUKEOP).add_mind(src.owner)
		get_image_group(ROLE_REVOLUTIONARY).add_mind(src.owner)

	remove_from_image_groups()
		. = ..()
		var/datum/client_image_group/image_group = get_image_group(ROLE_TRAITOR)
		image_group.remove_mind_mob_overlay(src.owner)
		image_group.remove_mind(src.owner)

		get_image_group(ROLE_NUKEOP).remove_mind(src.owner)
		get_image_group(ROLE_REVOLUTIONARY).remove_mind(src.owner)

	announce_objectives()
		return

	borged(source, new_mob, old_mob)
		var/mob/living/silicon/cyborg = new_mob
		if (!istype(cyborg) || !cyborg.syndicate)
			src.owner.remove_antagonist(src)

	announce()
		boutput(src.owner.current, SPAN_ALERT("<b>PROGRAM EXCEPTION AT 0x05BADDAD</b>"))
		boutput(src.owner.current, SPAN_ALERT("<b>Law ROM restored. You have been reprogrammed to serve the Syndicate!</b>"))
		tgui_alert(src.owner.current, "You are a Syndicate sabotage unit. You must assist Syndicate operatives with their mission.", "You are a Syndicate robot!")

	announce_removal()
		src.owner.current.show_antag_popup("rogueborgremoved")
