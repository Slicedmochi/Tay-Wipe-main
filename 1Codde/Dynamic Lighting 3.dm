
// File:    dynamic-lighting.dm
// Library: Forum_account.DynamicLighting
// Author:  Forum_account
//
// Contents:
//   This file defines the global /Lighting object. This
//   object is necessary to use dynamic lighting in your
//   project. There is a single global instance of this
//   object (called lighting) which you instantiate to
//   enable dynamic lighting.

var
	const
		LIGHT_LAYER = 100

	Lighting/lighting = new()

Lighting
	var
		// the number of shades of light
		states = 0

		// the icon file to be used
		icon

		// the list of shading objects that have changed and
		// need to be updated this tick
		list/changed = list()

		// the list of z levels that have been initialized
		list/initialized = list()

		// the list of all light sources
		list/lights = list()

		pixel_movement = 1

		// a constant that's added to the illumination of all tiles
		ambient = 0
		__ambient = 0

	New()
		spawn(1)
			loop()

	proc
		loop()
			while(1)
				sleep(world.tick_lag)

				if(!states)

					if(!icon)
						CRASH("The global var lighting.icon must be set.")

					var/list/l = icon_states(icon)
					states = l.len ** 0.25

				if(__ambient != ambient)
					for(var/light/l in lights)
						l.ambient(ambient)

					__ambient = ambient

				// apply all light sources. each apply() proc will
				// check if any changes have occurred, so it's not
				// a bad thing that we're calling this for all lights,
				// if a light hasn't changed since the last tick,
				// nothing will happen.
				for(var/light/l in lights)
					l.loop()

				// update all shading objects in the list and clear
				// their "changed" flag, this guarantees that each
				// shading object is updated once per tick, even if
				// multiple light sources change in a way that affects
				// its illumination.

				for(var/shading/s in changed)
					s.icon_state = "[s.c1.lum][s.c2.lum][s.c3.lum][s.lum]"
					s.changed = 0

				// reset the changed list
				changed.Cut()

		// Initialize lighting for a single z level or for all
		// z levels. This initialization can be time consuming,
		// so you might want to initialize z levels only as you
		// need to.
		init()

			var/list/z_levels = list()

			for(var/a in args)
				if(isnum(a))
					z_levels += a
				else if(isicon(a))
					world << "The lighting's icon should now be set by setting the lighting.icon var directly, not by passing an icon to init()."

			// if you didn't specify any z levels, initialize all z levels
			if(z_levels.len == 0)
				for(var/i = 1 to world.maxz)
					z_levels += i

			var/list/light_objects = list()

			// initialize each z level
			for(var/z in z_levels)

				if(isnull(icon))
					CRASH("You have to first tell dynamic lighting which icon file to use by setting the lighting.icon var.")

				// if it's already been initialized, skip it
				if(z in initialized)
					continue

				// keep track of which z levels have been initialized
				initialized += z

				// to intialize a z level, we create a /shading object
				// on every turf of that level
				for(var/x = 1 to world.maxx)
					for(var/y = 1 to world.maxy)

						var/turf/t = locate(x, y, z)

						if(!t)
							break

						// create the shading object for this tile
						t.shading = new(t, icon, 0)
						light_objects += t.shading

			// initialize the shading objects
			for(var/shading/s in light_objects)
				s.init()

				// this is the inline call to update()
				if(s.loc && !s.changed)
					s.changed = 1
					lighting.changed += s

turf
	var
		shading/shading

var
	shading/null_shading = new(null, null, 0)

// shading objects are a type of /obj placed in each
// turf that are used to graphically show the darkness
// as a result of dynamic lighting.
shading
	mouse_opacity = 0
	parent_type = /obj

	pixel_x = -16
	pixel_y = -16

	layer = LIGHT_LAYER

	var
		lum = 0
		__lum = 0

		// these are the shading objects whose lum values
		// we need to compute the icon_state for this obj
		shading/c1
		shading/c2
		shading/c3

		// these are the shading objects whose icons need to
		// change when this object's lum value changes
		shading/u1
		shading/u2
		shading/u3

		changed = 0

		ambient = 0

	New(turf/t, i, l)
		..(t)
		icon = i
		lum = l

	proc
		init()

			// get references to its neighbors
			c1 = locate(/shading) in locate(x    , y - 1, z)
			c2 = locate(/shading) in locate(x - 1, y - 1, z)
			c3 = locate(/shading) in locate(x - 1, y    , z)

			u1 = locate(/shading) in locate(x + 1, y    , z)
			u2 = locate(/shading) in locate(x + 1, y + 1, z)
			u3 = locate(/shading) in locate(x    , y + 1, z)

			// some of these vars will be null around the edge of the
			// map, so in that case we set them to the global null_shading
			// instance so we don't constantly have to check if these
			// vars are null before referencing them.
			if(!c1) c1 = null_shading
			if(!c2) c2 = null_shading
			if(!c3) c3 = null_shading

			if(!u1) u1 = null_shading
			if(!u2) u2 = null_shading
			if(!u3) u3 = null_shading

		lum(l)
			__lum += l

			ambient = lighting.ambient

			// __lum can be a decimal, but lum is used to set the
			// icon_state, so we want it to be rounded off
			var/new_lum = round(__lum * lighting.states + ambient, 1)

			// we also have to keep lum within certain bounds
			if(new_lum < 0)
				new_lum = 0
			else if(new_lum >= lighting.states)
				new_lum = lighting.states - 1

			if(new_lum == lum) return

			lum = new_lum

			// update this shading object and its dependent neighbors
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



// File:    light-source.dm
// Library: Forum_account.DynamicLighting
// Author:  Forum_account
//
// Contents:
//   This file defines the light object which is used to
//   create light sources that are attached to objects.
//   The light can be attached to a stationary object
//   (ex: a turf) or a mobile object (ex: a player).

atom
	var
		tmp/light/light = null
		opaque = 0

	Del()
		if(light)
			del(light)
		..()

light
	parent_type = /obj

	var
		// the atom the light source is attached to
		atom/owner

		// the radius, intensity, and ambient value control how large of
		// an area the light illuminates and how brightly it's illuminated.
		radius = 2
		intensity = 1
		ambient = 0

		radius_squared = 4

		// the coordinates of the light source - these can be decimal values
		__x = 0
		__y = 0

		// whether the light is turned on or off.
		on = 1

		// this flag is set when a property of the light source (ex: radius)
		// has changed, this will trigger an update of its effect.
		changed = 1

		// this is used to determine if the light is attached to a mobile
		// atom or a stationary one.
		mobile = 0

		// This is the illumination effect of this light source. Storing this
		// makes it very easy to undo the light's exact effect.
		list/effect

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

		// the lighting object maintains a list of all light sources
		lighting.lights += src

	proc
		// this used to be called be an infinite loop that was local to
		// the light object, but now there is a single infinite loop in
		// the global lighting object that calls this proc.
		loop()

			// if the light is mobile (if it was attached to an atom of
			// type /atom/movable), check to see if the owner has moved
			if(mobile)

				// compute the owner's coordinates
				var/opx = owner.x
				var/opy = owner.y

				// if pixel movement is enabled we need to take step_x
				// and step_y into account
				if(lighting.pixel_movement)
					opx += owner:step_x / 32
					opy += owner:step_y / 32

				// see if the owner's coordinates match
				if(opx != __x || opy != __y)
					__x = opx
					__y = opy
					changed = 1

			if(changed)
				apply()

		apply()

			changed = 0

			// before we apply the effect we remove the light's current effect.
			if(effect)

				// negate the effect of this light source
				for(var/shading/s in effect)
					s.lum(-effect[s])

				// clear the effect list
				effect.Cut()

			// only do this if the light is turned on and is on the map
			if(on && loc)

				// identify the effects of this light source
				effect = effect()

				// apply the effect
				for(var/shading/s in effect)
					s.lum(effect[s])

		// turn the light source on
		on()
			if(on) return

			on = 1
			changed = 1

		// turn the light source off
		off()
			if(!on) return

			on = 0
			changed = 1

		// toggle the light source's on/off status
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

		// compute the center of the light source, this is used
		// for light sources attached to mobs when you're using
		// pixel movement.
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

		// compute the total effect of this light source
		effect()

			var/list/L = list()

			for(var/shading/s in range(radius, owner))

				// we call this object's lum() proc to compute the illumination
				// value we contribute to each shading object, this way you can
				// override the lum() proc to change how lighting works but leave
				// this proc alone.
				var/lum = lum(s)

				if(lum > 0)
					L[s] = lum

			return L

		// compute the amount of illumination this light source
		// contributes to a single atom
		lum(atom/a)

			if(!radius)
				return 0

			// compute the distance to the tile, we use the __x and __y vars
			// so the light source's pixel offset is taken into account (provided
			// that's enabled)
			var/d = (__x - a.x) * (__x - a.x) + (__y - a.y) * (__y - a.y)

			// if the turf is outside the radius the light doesn't illuminate it
			if(d > radius_squared) return 0

			d = sqrt(d)

			// this creates a circle of light that non-linearly transitions between
			// the value of the intensity var and zero.
			return cos(90 * d / radius) * intensity + ambient
