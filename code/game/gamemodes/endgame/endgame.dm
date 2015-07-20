/**********************
 * ENDGAME STUFF
 **********************/

 // Universal State
 // Handles stuff like space icon_state, constants, etc.
 // Essentially a policy manager.  Once shit hits the fan, this changes its policies.
 // Called by master controller.

 // Default shit.
/datum/universal_state
	// Just for reference, for now.
	// Might eventually add an observatory job.
 	var/name = "Normal"
 	var/desc = "Nothing seems awry."

 	// Sets world.turf, replaces all turfs of type /turf/space.
 	var/space_type         = /turf/space

 	// Replaces all turfs of type /turf/space/transit
 	var/transit_space_type = /turf/space/transit

 	// Chance of a floor or wall getting damaged [0-100]
 	// Simulates stuff getting broken due to molecular bonds decaying.
 	var/decay_rate = 0

// Actually decay the turf.
/datum/universal_state/proc/DecayTurf(var/turf/T)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/datum/universal_state/proc/DecayTurf() called tick#: [world.time]")
	if(istype(T,/turf/simulated/wall))
		var/turf/simulated/wall/W=T
		W.melt()
		return
	if(istype(T,/turf/simulated/floor))
		var/turf/simulated/floor/F=T
		// Burnt?
		if(!F.burnt)
			F.burn_tile()
		else
			F.ReplaceWithLattice()
		return

// Return 0 to cause shuttle call to fail.
/datum/universal_state/proc/OnShuttleCall(var/mob/user)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/datum/universal_state/proc/OnShuttleCall() called tick#: [world.time]")
	return 1

// Processed per tick
/datum/universal_state/proc/OnTurfTick(var/turf/T)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/datum/universal_state/proc/OnTurfTick() called tick#: [world.time]")
	if(decay_rate && prob(decay_rate))
		DecayTurf(T)

// Apply changes when exiting state
/datum/universal_state/proc/OnExit()
 	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/datum/universal_state/proc/OnExit() called tick#: [world.time]")
 	// Does nothing by default

// Apply changes when entering state
/datum/universal_state/proc/OnEnter()
 	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/datum/universal_state/proc/OnEnter() called tick#: [world.time]")
 	// Does nothing by default

// Apply changes to a new turf.
/datum/universal_state/proc/OnTurfChange(var/turf/NT)
 	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/datum/universal_state/proc/OnTurfChange() called tick#: [world.time]")
 	return

/datum/universal_state/proc/OverlayAndAmbientSet()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/datum/universal_state/proc/OverlayAndAmbientSet() called tick#: [world.time]")
	return

/proc/SetUniversalState(var/newstate,var/on_exit=1, var/on_enter=1)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/SetUniversalState() called tick#: [world.time]")
	if(on_exit)
		universe.OnExit()
	universe = new newstate
	if(on_enter)
		universe.OnEnter()
