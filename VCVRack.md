# VCVRack Plugin
  * Needs a `./jconsole` or other architecture specific version of `J` 9 or greater (not the Java tool but [jsoftware](https://github.com/jsoftware/jsource)).
  * The plugin is built around `lin-arm64` and as such a default `./jconsole` and a bonus `jqt` are included.
  * Insert a `Master` module for the main interpreter thread.
  * Add `Input` and `Output` extenders.
  * The `Master` loads `profile.ijs` form the plugin's directory. (The program and configuration file).
  
## The Controls (`Input` and `Output`)
  * `Select` a variable channel. `A` to `Z`. (Visible on the display indicator).
  * `Start` a trigger input to start a transfer from or to the `Master` of the current clocked array. Normalized to an overflow of `Length` and `Done`.
  * `Done` a gate output to indicate the `Master` has completed processing.
  * `Length` (`Input` only) a variable length in clocks. 1 to 64. (Visible on the display indicator, On an `Output` the display is set by the engine and excess over 64 is truncated).
  * `Index` (`Output` only) allows an offset into the returned array. 1 to 64.
  * `Clock` a trigger input to clock in and out values.
  * `Input` (`Input` only) is the input to sample.
  * `Output` (`Output` only) is the generated output.
  * `Lock` a toggle button to prevent `Select` changes from unintentional overwriting an `Input` and to lock an `Output`.
  * `Mux` a variable to decide things like polyphony and time indexing order.
  
## The Controls (`Master`)
  * `Sync` a trigger input to synchronize data `Output` presentation. If it is not present `Output` extender modules will not present the calculated `Output` signal. This allows synchronous changes. The `Output` modules display new `Length` data and `Clock` through it if they are `Done`.
  * `Reload` a button to trigger a refresh of the J core including a reload of the `profile.ijs` file.
  * `Error` a light indicating a returned error (latching until expanders all get good results).
  * `Format` a light indicating invalid `float` data (latching until expanders all get good results).
  * `Init` a light indicating a new `profile.ijs` is detected differing from the patch (only 1 `Master` is required, and contexts of 2 of them can differ).
  * `Dominate` a button to force a stored patch `profile.ijs` to be the global one and only. Needs slave `Master`'s of the `Master` to `Reload`.
  * `Saved` an light indicating a JSON save since a load. Technically `profile.ijs` is loaded multiple times.
  * `Lock On` a master momentary button to lock all IO.
  * `Lock Off` a master momentary button to unlock all IO.
  
## Computational Considerations
The `J` engine uses a string IO interface. Conversion of `char*` to and from `float` can consume CPU, but as the engine runs on its own thread this will be just occasional delay by a number of `Sync` intervals at the worst. Consider it a feature.

There maybe later adaptation to other console language handlers as the sub-process spawned by the engine thread should be quite generic based on some parse and stringify configuration. There is a menu option for the engine selection. Using a sub-process also means that the engine does not need any strange compile doing, just place a suitable `./jconsole` and the associated libraries in the plugin directory.  

Other data formats or errors other than `float` are not supported and should trigger a `Lock` on previous data, needing a press of the `Lock` button to continue processing. The `Master` indicates a returned error condition and also things like infinities, rationals or string data parse errors when technically the return is not a `J` error separately.

## Patch Saves
The `Master` (maybe multiple copies) use `profile.ijs` so apparently a checksum `Init` warning is required (when the before and after engine load comparison fails). The patch then might not have the totality of the save, and writing a temporary `profile.ijs` from the save might have been dominated. The default patch obviously loads the `profile.ijs` as it is loaded before the save state is applied. In this way the `profile.ijs` is stored in the save to overwrite definitions in the default patch. So `profile.ijs` can be edited after the fact with altered and extra definitions. Dynamic dispatching can call these profile definitions.

If you actually want to take advantage of this effect, include another `.ijs` file inside `profile.ijs`, as this is not saved with the patch. It might be good for editing a nice library of features without having to have an `Init` complaint. As `Init` like `Error` and `Format` can trigger a `Lock` but, unlike those two, it is a master `Lock On` as it affects all IO.

This simplifies the design of `Master` and the `Dominate` button clears this effect on the respective `Master` by writing `profile.ijs` from the patch and clearing any `Init` signal on the dominating `Master`. `Saved` helps with not destroying a profile. Nope, never a bug then. Though be aware it is any save including saving machine presets too, not just autosaves and project saves. `Saved` means it saved somewhere for some reason. A `Reload` can clear the `Saved` state, and also can cause an `Init` state. As `Init` is both for `profile.ijs` changes during loading and also profile not matching internal state loaded state (different from `profile.ijs` and so not dominated until a `Reload`, and does not trigger `Lock On`).

## Other Possible Environments
As `asset::plugin(pluginInstance, "jconsole")` could get the path if necessary, and other things would use `$PATH` to find them, I think much is possible.

  * `j` by `./jconsole` (default original).
  * `python` by `env PYTHONSTARTUP=profile.py python` (uses current virtual environment).
  * `emacs` by `emacs --batch -l profile.el --eval "(while t (print (eval (read))))"` (easy package install on Linux `emacs`).
  
These may be added as the project develops. There are other tools that could produce data to be used by the plugin, but some of them are too simplistic, and some would have difficulty producing `float` data arrays. There is also the matter of hard baking the list into the plugin as a precise order has to be maintained even if a particular installation does not include one of the methods.

## Alphanumeric Data
TBD.

## Atomic GUI Menus and Internals
The right click menu helper in `plugin.hpp` and by rationale in `plugin.cpp` are defined for a new control statement macro `on(name)` which picks up an un-responded GUI menu trigger and clears it then applies the block or statement following it like an `if`, but it can be in another thread as all the critical writes are `std::atomic` and it should just work. The care of clearing triggers via triggers is abated by guarding the `on(name)` internally by actual eventual certainty of other value ignoring the trigger to sequential two hot. Also available is `matic(MENU(name), MENU(set))` or the macro `haut(name, set)`.

I guess I decided on a word based on maybe some noun from positional action opportunities deciding first focus action roots of verbs based on noun iconography. You speak-a-da-lingo? To 'ave centra loco.