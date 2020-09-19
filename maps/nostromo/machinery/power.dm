/obj/machinery/power/apc/bsa
	cell_type = /obj/item/weapon/cell/high
	/*INF@SHRUG
	chargelevel = 0.1 //1% per second (10w)
	*/

//
// SMES units
//

// Main Engine output SMES
/obj/machinery/power/smes/buildable/preset/nostromo/engine_main
	uncreated_component_parts = list(/obj/item/weapon/stock_parts/smes_coil/super_io = 2,
								/obj/item/weapon/stock_parts/smes_coil/super_capacity = 2)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

// Shuttle SMES
/obj/machinery/power/smes/buildable/preset/nostromo/shuttle
	uncreated_component_parts = list(/obj/item/weapon/stock_parts/smes_coil/super_io = 1)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

// Hangar SMES. Charges the shuttles so needs a pretty big throughput.
/obj/machinery/power/smes/buildable/preset/nostromo/hangar
	uncreated_component_parts = list(/obj/item/weapon/stock_parts/smes_coil/super_io = 2)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE
