/turf/simulated/floor/attackby(var/obj/item/C, var/mob/user)

	if(!C || !user)
		return 0

	if(isCoil(C) || (flooring && istype(C, /obj/item/stack/material/rods)))
		return ..(C, user)

	if(!(isScrewdriver(C) && flooring && (flooring.flags & TURF_REMOVE_SCREWDRIVER)) && try_graffiti(user, C))
		return

	if(flooring)
		if(isCrowbar(C) && user.a_intent != I_HURT)
			if(broken || burnt)
				to_chat(user, "<span class='notice'>Вы разобрали сломанную [flooring.descriptor].</span>")
				make_plating()
			else if(flooring.flags & TURF_IS_FRAGILE)
				to_chat(user, "<span class='danger'>Вы силой отрываете [flooring.descriptor], ломая его в процессе.</span>")
				make_plating()
			else if(flooring.flags & TURF_REMOVE_CROWBAR)
				if (user.do_skilled(0.5, SKILL_CONSTRUCTION , src, 10))
					to_chat(user, "<span class='notice'>Вы поднимаете и отодвигаете [flooring.descriptor].</span>")
					make_plating(1)
				else
					return 0
			else
				return
			playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
			return
		else if(isScrewdriver(C) && (flooring.flags & TURF_REMOVE_SCREWDRIVER))
			if(broken || burnt)
				return
			to_chat(user, "<span class='notice'>Вы раскручиваете и убираете [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
			return
		else if(isWrench(C) && (flooring.flags & TURF_REMOVE_WRENCH))
			to_chat(user, "<span class='notice'>Вы раскручиваете и убираете [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
			return
		else if(istype(C, /obj/item/weapon/shovel) && (flooring.flags & TURF_REMOVE_SHOVEL))
			to_chat(user, "<span class='notice'>Вы откапываете [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			return
		else if(isCoil(C))
			to_chat(user, "<span class='warning'>Вы должны убрать [flooring.descriptor] сначала.</span>")
			return
	else

		if(istype(C, /obj/item/stack))
			if(broken || burnt)
				to_chat(user, "<span class='warning'>Это секция слишком повреждена чтобы поддерживать что-либо. Используйте сварку чтобы починить его.</span>")
				return
			//first check, catwalk? Else let flooring do its thing
			if(locate(/obj/structure/catwalk, src))
				return
			if (istype(C, /obj/item/stack/material/rods))
				var/obj/item/stack/material/rods/R = C
				if (R.use(2))
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
					new /obj/structure/catwalk(src)
				return
			var/obj/item/stack/S = C
			var/decl/flooring/use_flooring
			var/list/decls = decls_repository.get_decls_of_subtype(/decl/flooring)
			for(var/flooring_type in decls)
				var/decl/flooring/F = decls[flooring_type]
				if(!F.build_type)
					continue
				if(ispath(S.type, F.build_type) || ispath(S.build_type, F.build_type))
					use_flooring = F
					break
			if(!use_flooring)
				return
			// Do we have enough?
			if(use_flooring.build_cost && S.get_amount() < use_flooring.build_cost)
				to_chat(user, "<span class='warning'>Вам нужно как минимум [use_flooring.build_cost] [S.name] чтобы сделать [use_flooring.descriptor].</span>")
				return
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time, src))
				return
			if(flooring || !S || !user || !use_flooring)
				return
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return
		// Repairs and Deconstruction.
		else if(isCrowbar(C))
			if((broken || burnt) && !is_prying)
				playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
				visible_message("<span class='notice'>[user] начал убирать сломанный пол.</span>")
				is_prying = 1
				var/turf/T = GetBelow(src)
				if(T)
					T.visible_message("<span class='warning'>Потолок сверху выглядит так, будто он убирается кем-то.</span>")
				if(do_after(user, 10 SECONDS))
					is_prying = 0
					visible_message("<span class='warning'>[user] вынул сломанный пол.</span>")
					new /obj/item/stack/tile/floor(src)
					src.ReplaceWithLattice()
					playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
					if(T)
						T.visible_message("<span class='danger'>Потолок сверху был убран!</span>")
				else
					is_prying = 0
			else
				return
			return
		else if(isWelder(C))
			var/obj/item/weapon/weldingtool/welder = C
			if(welder.isOn() && (is_plating()))
				if(broken || burnt)
					if(welder.remove_fuel(0, user))
						to_chat(user, "<span class='notice'>Вы починили повреждения в полу.</span>")
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						icon_state = "plating"
						burnt = null
						broken = null
					return
				else
					if(welder.remove_fuel(0, user))
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						visible_message("<span class='notice'>[user] has started melting the plating's reinforcements!</span>")
						if(do_after(user, 5 SECONDS) && welder.isOn() && welder_melt())
							visible_message("<span class='warning'>[user] has melted the plating's reinforcements! It should be possible to pry it off.</span>")
							playsound(src, 'sound/items/Welder.ogg', 80, 1)
					return
		else if(istype(C, /obj/item/weapon/gun/energy/plasmacutter) && (is_plating()) && !broken && !burnt)
			var/obj/item/weapon/gun/energy/plasmacutter/cutter = C
			if(!cutter.slice(user))
				return ..()
			playsound(src, 'sound/items/Welder.ogg', 80, 1)
			visible_message("<span class='notice'>[user] has started slicing through the plating's reinforcements!</span>")
			if(do_after(user, 3 SECONDS) && welder_melt())
				visible_message("<span class='warning'>[user] has sliced through the plating's reinforcements! It should be possible to pry it off.</span>")
				playsound(src, 'sound/items/Welder.ogg', 80, 1)

	return ..()

/turf/simulated/floor/proc/welder_melt()
	if(!(is_plating()) || broken || burnt)
		return 0
	burnt = 1
	remove_decals()
	update_icon()
	return 1

/turf/simulated/floor/can_build_cable(var/mob/user)
	if(!is_plating() || flooring)
		to_chat(user, "<span class='warning'>Уберите сначала пол.</span>")
		return 0
	if(broken || burnt)
		to_chat(user, "<span class='warning'>Это секция слишком повреждена чтобы поддерживать что-либо. Используйте сварку чтобы починить его.</span>")
		return 0
	return 1
