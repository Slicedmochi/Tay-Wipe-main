/*

Forum_Account's Dynamic Lighting Library optimized by FIREking
12/31/2012

All original code, concept, and design made by Forum_Account
All optimizations and modifications made by FIREking

This is released without Forum_Account's direct permission
If you do not agree with that, find him and complain

Things Assumed:
	You don't use pixel-based movement
	You use tile-based movement
	You have a movement system with speed
	There is a maximum speed that anything can move
	You don't need / have opaque objects that move
	You don't use light values for game rules, only for visuals

	If you don't agree to any of the above, this won't work well for you
	These things are assumed in order to optimize the library

You realize:
	This is a server sided light engine
	Because of that, there are serious limitations
	I didn't invent this library, it isn't mine
	If you want to see the original code,
		download Forum_Account's Dynamic Lighting Library

Stuff:
	Change LIGHTING_ENABLE to 0 if you want to disable lights for a compile
	Set LIGHTING_ICON to your light icon, see Forum_Account's original library to make your own.
	Set LIGHTING_RANGE to how many tiles away from a client you want lights to be activated
	Set LIGHTING_SPEED to the fastest speed an object can move
		Library assumes speed algorithm is -> (world.icon_size * world.tick_lag) / LIGHTING_SPEED
		If you have another system for speed, just change CalculateDelay() to calculate light_delay variable how you want
		This controls how often the lighting engine loops

Weird:
	It's possible that a light can become stranded if you switch a client's mob
	ie:
		mob/verb/stranded()
			src.client.mob = new/mob/new_mob(src.loc)
			//the original light is now detached unless you remove it at Logout()
			//over time this could leave many many ghost lights, which is bad!

	It's up to you to make sure you delete a light when you switch a client's mob
    ie:
    	mob/Login()
    		..()
    		src.light = new(src, 3)
    	mob/Logout()
    		del(src.light)
    		if(key) del(src)

Bugs:
	Top edge and right edge of map will have a fully lit strip size of 1/2 world.icon_size
	This is a bug from the original library that I've never been able to fix.
	If a client's mob changes, the original mob's light becomes stranded, so delete it

Things left to improve:
	light.effect() could be improved using Recursive Shadow Casting
	improve it even further so it can work with pixel-based movement
	It's also been mentioned that the loop structure could be removed altogether
	and lights could only be updated only when seen / changed.

*/

#define LIGHTING_ENABLE 1

#define LIGHTING_ICON 'lighting-8.dmi'
#define LIGHTING_LAYER 100
#define LIGHTING_RANGE 11
#define LIGHTING_SPEED 11

/*world
	New()
		..()
		if(LIGHTING_ENABLE)
			spawn lighting.init()*/

var/list/clients = list() //keep track of clients

client/New()
	..()
	clients += src

client/Del()
	clients -= src
	..()

atom
	var
		tmp/light/light = null
		opaque = 0

	Del()
		if(light)
			del(light)
		..()

turf
	var
		shading/shading = null
		canshade = 1

var/Lighting/lighting = new()
var/shading/null_shading = new(null, null, 0)

Lighting
	var
		states = 0
		icon = LIGHTING_ICON
		light_range = LIGHTING_RANGE
		list/changed = list()
		list/initialized = list()
		list/lights = list()
		ambient = 0
		__ambient = 0
		_light_delay = 0

	New()
		CalculateDelay()
		spawn(1) _loop()

	proc
		CalculateDelay() //call this when/if you change world.fps or world.tick_lag
			_light_delay = (world.icon_size * world.tick_lag) / LIGHTING_SPEED

		_loop()
			while(src)
				sleep(_light_delay)

				if(clients.len <= 0) continue

				if(!states)
					if(!icon)
						del(src)
						CRASH("The global var lighting.icon must be set.")

					var/list/l = icon_states(icon)
					states = l.len ** 0.25

				if(__ambient != ambient)
					for(var/l in lights)
						l:ambient(ambient)

					__ambient = ambient

				for(var/c in clients)
					for(var/light/l in range(light_range, c))
						if(l.should_wake)
							l:loop()
							l:should_wake = 0

				for(var/s in changed)
					s:icon_state = "[s:c1:lum][s:c2:lum][s:c3:lum][s:lum]"
					s:changed = 0

				changed.Cut()

		init()

			var/list/z_levels = list()

			for(var/a in args)
				if(isnum(a))
					z_levels += a
				else if(isicon(a))
					world << "The lighting's icon should now be set by setting the lighting.icon var directly, not by passing an icon to init()."

			if(z_levels.len == 0)
				for(var/i = 1 to world.maxz)
					z_levels += i

			var/list/light_objects = list()

			for(var/z in z_levels)

				if(isnull(icon))
					CRASH("You have to first tell dynamic lighting which icon file to use by setting the lighting.icon var.")

				if(z in initialized)
					continue

				initialized += z

				for(var/x = 1 to world.maxx)
					for(var/y = 1 to world.maxy)

						var/turf/t = locate(x, y, z)

						if(!t)
							break

						t.shading = new(t, icon, 0)
						light_objects += t.shading

			for(var/shading/s in light_objects)
				s.init()

				if(s.loc && !s.changed)
					s.changed = 1
					lighting.changed += s

shading
	parent_type = /obj

	layer = LIGHTING_LAYER

	mouse_opacity = 0

	var
		lum = 0
		__lum = 0

		shading/c1 = null
		shading/c2 = null
		shading/c3 = null

		shading/u1 = null
		shading/u2 = null
		shading/u3 = null

		changed = 0

		ambient = 0

	New(turf/t, i, l)
		..(t)
		icon = i
		lum = l

	proc
		init()
			pixel_x = -world.icon_size / 2
			pixel_y = pixel_x

			c1 = locate(/shading) in get_step(src, SOUTH)
			c2 = locate(/shading) in get_step(src, SOUTHWEST)
			c3 = locate(/shading) in get_step(src, WEST)

			u1 = locate(/shading) in get_step(src, EAST)
			u2 = locate(/shading) in get_step(src, NORTHEAST)
			u3 = locate(/shading) in get_step(src, NORTH)

			if(!c1) c1 = null_shading
			if(!c2) c2 = null_shading
			if(!c3) c3 = null_shading

			if(!u1) u1 = null_shading
			if(!u2) u2 = null_shading
			if(!u3) u3 = null_shading

		lum(l)
			if(!loc:canshade) return
			__lum += l

			ambient = lighting.ambient

			var/new_lum = round(__lum * lighting.states + ambient, 1)

			if(new_lum < 0)
				new_lum = 0
			else if(new_lum >= lighting.states)
				new_lum = lighting.states - 1

			if(new_lum == lum) return

			lum = new_lum

			if(loc && !changed)
				changed = 1
				lighting.changed += src

			if(u1.loc && !u1.changed)
				u1.changed = 1
				lighting.changed += u1

			if(u2.loc && !u2.changed)
				u2.changed = 1
				lighting.changed += u2

			if(u3.loc && !u3.changed)
				u3.changed = 1
				lighting.changed += u3

		changed()
			if(changed) return

			if(loc)
				changed = 1
				lighting.changed += src

				if(u1.loc && !u1.changed)
					u1.changed = 1
					lighting.changed += u1

				if(u2.loc && !u2.changed)
					u2.changed = 1
					lighting.changed += u2

				if(u3.loc && !u3.changed)
					u3.changed = 1
					lighting.changed += u3

light
	parent_type = /obj

	var
		atom/owner

		radius = 2
		intensity = 1
		ambient = 0

		radius_squared = 4

		__x = 0
		__y = 0

		on = 1

		changed = 1

		mobile = 0

		list/effect

		should_wake = 1

	New(atom/a, radius = 3, intensity = 1)
		if(!a || !istype(a))
			CRASH("The first argument to the light object's constructor must be the atom that is the light source. Expected atom, received '[a]' instead.")

		owner = a

		if(istype(owner, /atom/movable))
			loc = owner.loc
			mobile = 1
		else
			loc = owner
			mobile = 0

		src.radius = radius
		src.radius_squared = radius * radius
		src.intensity = intensity

		__x = owner.x
		__y = owner.y

		lighting.lights += src

	Del()
		off()
		apply()
		lighting.lights -= src
		..()

	proc
		loop()
			if(!owner)
				del(src)

			if(mobile)
				var/opx = owner.x
				var/opy = owner.y

				if(opx != __x || opy != __y)
					__x = opx
					__y = opy
					changed = 1

			if(changed)
				apply()
			else
				should_wake = 0

		apply()

			changed = 0

			if(effect)

				for(var/shading/s in effect)
					s.lum(-effect[s])

				effect.Cut()

			if(on && loc)

				effect = effect()

				for(var/shading/s in effect)
					s.lum(effect[s])

		on()
			if(on) return

			on = 1
			changed = 1

		off()
			if(!on) return

			on = 0
			changed = 1

		toggle()
			if(on)
				off()
			else
				on()

		radius(r)
			if(radius == r) return

			radius = r
			radius_squared = r * r
			changed = 1

		intensity(i)
			if(intensity == i) return

			intensity = i
			changed = 1

		ambient(a)
			if(ambient == a) return

			ambient = a
			changed = 1

		center()
			if(istype(owner, /atom/movable))

				var/atom/movable/m = owner

				. = m.loc
				var/d = bounds_dist(m, .)

				for(var/turf/t in m.locs)
					var/dt = bounds_dist(m, t)
					if(dt < d)
						d = dt
						. = t
			else
				var/turf/t = owner
				while(!istype(t))
					t = t.loc

				return t

		effect()

			var/list/L = list()

			for(var/shading/s in range(radius, src))

				if(!isnull(L[s])) continue

				if(s.x == x && s.y == y)
					var/lum = lum(s)
					if(lum > 0)
						L[s] = lum

					continue

				var/dx = (s.x - x)
				var/dy = (s.y - y)
				var/d = sqrt(dx * dx + dy * dy)

				if(d > 0)
					dx /= d
					dy /= d

				var/tx = x + dx + 0.5
				var/ty = y + dy + 0.5

				for(var/i = 1 to radius)

					var/turf/t = locate(round(tx), round(ty), z)

					if(!t) break

					if(!L[t.shading])
						var/lum = lum(t.shading)
						if(lum > 0)
							L[t.shading] = lum

					if(t.opaque) break

					if(t.shading == s) break

					tx += dx
					ty += dy

			return L

		lum(atom/a)

			if(!radius)
				return 0

			var/d = (__x - a.x) * (__x - a.x) + (__y - a.y) * (__y - a.y)

			if(d > radius_squared) return 0

			d = sqrt(d)

			return cos(90 * d / radius) * intensity + ambient
/*
light/var/dead=0
light/proc/Die() //call this to remove a light from the game
	dead = 1
	if(src.light) //how did the light get a light?
		src.light.Die()
		src.light = null
	should_wake = 0 //stop auto processing this light
	off() //negate its effect
	apply()
	lighting.lights -= src
	src.owner = null
	src.loc = null

light/Del()
	if(!dead)
		CRASH("light.Del() not called by the garbage collector!")
	..()*/