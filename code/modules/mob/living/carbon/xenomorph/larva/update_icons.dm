/mob/living/carbon/human/xenomorph/larva/regenerate_icons()
	update_inv_r_hand(0)
	update_hud()
	update_icons()

/mob/living/carbon/human/xenomorph/larva/update_icons()
	update_hud()		//TODO: remove the need for this to be here
	var/state = 0
	if(amount_grown > 150)
		state = 2
	else if(amount_grown > 50)
		state = 1

	if(stat == DEAD)
		icon_state = "larva[state]_dead"
	else if (handcuffed) //This should be an overlay. Who made this an icon_state?
		icon_state = "larva[state]_cuff"
	else if(stat == UNCONSCIOUS || lying || resting)
		icon_state = "larva[state]_sleep"
	else if (stunned)
		icon_state = "larva[state]_stun"
	else
		icon_state = "larva[state]"

/mob/living/carbon/human/xenomorph/larva/update_hud()
	//TODO
	if (client)
//		if(other)	client.screen |= hud_used.other		//Not used
//		else		client.screen -= hud_used.other		//Not used
		client.screen |= contents
