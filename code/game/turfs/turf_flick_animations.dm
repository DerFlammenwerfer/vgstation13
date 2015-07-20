/turf/proc/turf_animation(var/anim_icon,var/anim_state,var/anim_x=0, var/anim_y=0, var/anim_layer=MOB_LAYER+1, var/anim_sound=null, var/anim_color=null)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/proc/turf_animation() called tick#: [world.time]")
	if(!c_animation)//spamming turf animations can have unintended effects, such as the overlays never disapearing. hence this check.
		if(anim_sound)
			playsound(src, anim_sound, 50, 1)
		c_animation = getFromPool(/atom/movable/overlay, src)
		c_animation.name = "turf_animation"
		c_animation.density = 0
		c_animation.anchored = 1
		c_animation.icon = anim_icon
		c_animation.icon_state = anim_state
		c_animation.layer = anim_layer
		c_animation.master = src
		c_animation.pixel_x = anim_x
		c_animation.pixel_y = anim_y
		if(anim_color)
			c_animation.color = anim_color
		flick("turf_animation",c_animation)
		spawn(10)
			if(c_animation)
				returnToPool(c_animation)
				c_animation = null

//Requires either a target/location or both
//Requires a_icon holding the animation
//Requires either a_icon_state of the animation or the flick_anim
//Does not require sleeptime, specifies for how long the animation should be allowed to exist before returning to pool
//Does not require animation direction, but you can specify
//Does not require a name
proc/anim(turf/location as turf,target as mob|obj,a_icon,a_icon_state as text,flick_anim as text,sleeptime = 0,direction as num, name as text)
//This proc throws up either an icon or an animation for a specified amount of time.
//The variables should be apparent enough.
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/anim() called tick#: [world.time]")
	if(!location && target)
		location = get_turf(target)
	if(location && !target)
		target = location
	var/atom/movable/overlay/animation = getFromPool(/atom/movable/overlay, location)
	if(name)
		animation.name = name
	if(direction)
		animation.dir = direction
	animation.icon = a_icon
	animation.layer = target:layer+1
	if(a_icon_state)
		animation.icon_state = a_icon_state
	else
		animation.icon_state = "blank"
		animation.master = target
		flick(flick_anim, animation)
	spawn(max(sleeptime, 15))
		returnToPool(animation)

/*
//called when the tile is cultified
/turf/proc/cultification()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/proc/cultification() called tick#: [world.time]")
	if(!c_animation)
		c_animation = new /atom/movable/overlay(src)
		c_animation.name = "cultification"
		c_animation.density = 0
		c_animation.anchored = 1
		c_animation.icon = 'icons/effects/effects.dmi'
		c_animation.layer = 3
		c_animation.master = src
		if(density)
			c_animation.icon_state = "cultwall"
		else
			c_animation.icon_state = "cultfloor"
		c_animation.pixel_x = 0
		c_animation.pixel_y = 0
		flick("cultification",c_animation)
		spawn(10)
			c_animation.master = null
			c_animation.loc = null
			qdel(c_animation)

//called by various cult runes
/turf/proc/invocanimation(var/animation_type)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/proc/invocanimation() called tick#: [world.time]")
	if(!c_animation)
		c_animation = new /atom/movable/overlay(src)
		c_animation.name = "invocanimation"
		c_animation.density = 0
		c_animation.anchored = 1
		c_animation.icon = 'icons/effects/effects.dmi'
		c_animation.layer = 5
		c_animation.master = src
		c_animation.icon_state = "[animation_type]"
		c_animation.pixel_x = 0
		c_animation.pixel_y = 0
		flick("invocanimation",c_animation)
		spawn(10)
			qdel(c_animation)

//called whenever a null rod is blocking a spell or rune
/turf/proc/nullding()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/proc/nullding() called tick#: [world.time]")
	playsound(src, 'sound/piano/Ab7.ogg', 50, 1)
	if(!c_animation)
		c_animation = new /atom/movable/overlay(src)
		c_animation.name = "nullding"
		c_animation.density = 0
		c_animation.anchored = 1
		c_animation.icon = 'icons/effects/96x96.dmi'
		c_animation.layer = 5
		c_animation.master = src
		c_animation.icon_state = "nullding"
		c_animation.pixel_x = -32
		c_animation.pixel_y = -32
		flick("nullding",c_animation)
		spawn(10)
			del(c_animation)


/turf/proc/beamin(var/color)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/proc/beamin() called tick#: [world.time]")
	if(color == "admin")
		playsound(src, 'sound/misc/adminspawn.ogg', 50, 1)
		color = ""
	else
		playsound(src, 'sound/weapons/emitter2.ogg', 50, 1)
	if(!c_animation)
		c_animation = new /atom/movable/overlay(src)
		c_animation.name = "beamin"
		c_animation.density = 0
		c_animation.anchored = 1
		c_animation.icon = 'icons/effects/96x96.dmi'
		c_animation.layer = 5
		c_animation.master = src
		c_animation.pixel_x = -32
		c_animation.icon_state = "beamin-[color]"
		if(color == "alien")
			c_animation.pixel_x = -16
		flick(icon_state,c_animation)
		spawn(10)
			del(c_animation)


/turf/proc/rejuv()
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/proc/rejuv() called tick#: [world.time]")
	playsound(src, 'sound/effects/rejuvinate.ogg', 50, 1)
	if(!c_animation)
		c_animation = new /atom/movable/overlay(src)
		c_animation.name = "rejuvinate"
		c_animation.density = 0
		c_animation.anchored = 1
		c_animation.icon = 'icons/effects/64x64.dmi'
		c_animation.layer = 5
		c_animation.master = src
		c_animation.icon_state = "rejuvinate"
		c_animation.pixel_x = -16
		flick("rejuvinate",c_animation)
		spawn(10)
			del(c_animation)


/turf/proc/busteleport(var/tpsound=1)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/turf/proc/busteleport() called tick#: [world.time]")
	if(tpsound)
		playsound(src, 'sound/effects/busteleport.ogg', 50, 1)
	if(!c_animation)
		c_animation = new /atom/movable/overlay(src)
		c_animation.name = "busteleport"
		c_animation.density = 0
		c_animation.anchored = 1
		c_animation.icon = 'icons/effects/160x160.dmi'
		c_animation.layer = 5
		c_animation.master = src
		c_animation.pixel_x = -64
		c_animation.pixel_y = -32
		c_animation.icon_state = "busteleport"
		flick("busteleport",c_animation)
		spawn(10)
			del(c_animation)
*/