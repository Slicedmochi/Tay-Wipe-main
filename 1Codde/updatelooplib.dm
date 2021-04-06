/*
	An Update Loop is a datum that you can add objects (AKA updaters) to.
	Updaters have their callback proc called every tick.

	Update Loops are constructed with the syntax:

		new/update_loop(tick_lag, default_callback)

		tick_lag:
			Time between ticks (defaults to world.tick_lag),

		default_callback:
			Name of the proc called for updaters every tick
			 if one is not provided upon adding the updater.

			This allows you to add the same object to multiple update loops
			 without having the same proc called by each loop.

			Defaults to "Update".

	You can add an object to an update loop with update_loop.Add(updater).
	 The updater's proc by the name of the update loop's default_callback
	 will be called every tick until the updater is removed.

	You can add an object with a non-default callback with update_loop.Add(updater, callback).

	For users of BYOND 512+, you can add updaters via the += and []= operators.
		Here are each of the add/remove forms grouped with their operator equivalents:

			update_loop.Add(updater)
			update_loop += updater

			update_loop.Add(updater, callback)
			update_loop[updater] = callback

			update_loop.Remove(updater)
			update_loop -= updater
			update_loop[updater] = null
*/

update_loop
	var
		// Callback used when one is not provided when adding an updater.
		// Defaults to "Update".
		default_callback

		// Time between ticks.
		// Defaults to world.tick_lag.
		tick_lag

		tmp
			// All updaters associated with their callback.
			// Updaters can only be added once, with a single callback.
			list/_updaters

	New(tick_lag, default_callback)
		src.tick_lag = tick_lag || world.tick_lag
		src.default_callback = default_callback || "Update"
		Loop()

	proc
		Add(updater, callback)
			if(!_updaters)
				_updaters = new
			_updaters[updater] = callback || default_callback

		Remove(updater)
			if(_updaters)
				_updaters -= updater
				if(!_updaters.len)
					_updaters = null

		// Update all updaters.
		UpdateAll()
			for(var/updater in _updaters)
				Update(updater)

		// Update an individual updater.
		Update(updater)
			var callback = _updaters[updater]
			call(updater, callback)()

		Loop()
			set waitfor = FALSE

			// Loop forever.
			for()
				// Update everything.
				if(_updaters) UpdateAll()

				// Remove any null entries (which can be created when using del).
				if(_updaters)
					while(_updaters.Remove(null));
					if(!_updaters.len) _updaters = null

				sleep tick_lag

		#if DM_VERSION >= 512
		// Operator overloads.

		operator+=(updater)
			Add(updater)

		operator-=(updater)
			Remove(updater)

		operator[]=(updater, callback)
			if(callback)
				Add(updater, callback)
			else
				Remove(updater)
		#endif
//THANKS KAIO