# VCVRack Plugin
  * Needs a `./jconsole` or other architecture specific version of `J` 9 or greater (not the Java tool but [jsoftware](https://github.com/jsoftware/jsource)).
  * The plugin is built around `lin-arm64` and as such a default `./jconsole` and a bonus `jqt` are included.
  * Insert a `Master` module for the main interpretor thread.
  * Add `Input` and `Output` extenders.
  * The `Master` loads `profile.ijs` form the plugin's directory. (The program and configuration file).
  
## The Controls (`Input` and `Output`)
  * `Select` a variable channel. `A` to `Z`. (Visible on the display indicator).
  * `Start` a trigger input to start a transfer from or to the `Master`.
  * `Done` a gate output to indicate the `Master` has completed the processing.
  * `Input` (`Input` only) is the input to sample.
  * `Output` (`Output` only) is the generated output.
  * `Lock` a toggle button to prevent `Select` changes from unintentional overwriting an `Input` and to lock an `Output`.
  
## The Controls (`Master`)
  * `Sync` a trigger input to synchronize the `Done` signals and data presentation. If it is not present, `Done` will not occur and `Output` extender modules will not present a calculated `Output` signal.
  * `Reload` a button to trigger a refresh of the J core including a reload of the `profile.ijs` file.
  * `Error` a light indicating a returned error (latching until same expanders all get good results).
  * `Format` a light indicating invalid `float` data (latching until same expanders all get good results).
  * `Init` a light indicating a new `profile.ijs` is detected differing from the patch (only 1 `Master` is required, and contexts of 2 of them can differ).
  * `Dominate` a button to force a stored patch `profile.ijs` to be the global one and only. Needs slave `Master`'s of the `Master` to `Reload`.
  * `Saved` an light indicating a JSON save since a load. Technically `profile.ijs` is loaded multiple times.
  * `Lock On` a master momentary button to lock all IO.
  * `Lock Off` a master momentary button to unlock all IO.
  
## Computational Considerations
The `J` engine uses a string IO interface. Conversion of `char*` to and from `float` can consume CPU, but as the engine runs on its own thread this will be just ocassional delay by a number of `Sync` intervals at the worst. Consider it a feature.

There maybe later adaptation to other console language handlers as the sub-process spawned by the engine thread should be quite generic based on some parse and stringify configuration. There is a menu option for the engine selection. Using a sub-process also means that the engine does not need any strange compile doing, just place a suitable `./jconsole` and the associated libraries in the plugin directory.  

Other data formats or errors other than `float` are not supported and should trigger a `Lock` on previous data, needing a press of the `Lock` button to continue processing. The `Master` indicates a returned error condition and also things like infinities, rationals or string data parse errors when technically the return is not a `J` error seperately.

## Patch Saves
The `Master` (maybe multiple copies) use `profile.ijs` so apparently a checksum `Init` warning is required (when the before and after engine load comparison fails). The patch then might not have the totality of the save, and writing a temporary `profile.ijs` from the save might have been dominated. The defualt patch obviously loads the `profile.ijs` as it is loaded before the save state is applied. In this way the `profile.ijs` is stored in the save to overwrite definitions in the default patch. So `profile.ijs` can be edited after the fact with altered and extra definitions. Dynamic dispatching can call these profile definitions.

If you actually want to take advantage of this effect, include another `.ijs` file inside `profile.ijs`, as this is not saved with the patch. It might be good for editing a nice library of features without having to have an `Init` complaint. As `Init` like `Error` and `Format` can trigger a `Lock` but, unlike those two, it is a master `Lock On` as it affects all IO.

This simplifies the design of `Master` and the `Dominate` button clears this effect on the respective `Master` by writing `profile.ijs` from the patch and clearing any `Init` signal on the dominating `Master`. `Saved` helps with not destroying a profile. Nope, never a bug then. Though be aware it is any save including saving machine presets too, not just autosaves and project saves. `Saved` means it saved somewhere for some reason. A `Reload` can clear the `Saved` state, and also can cause an `Init` state. As `Init` is both for `profile.ijs` changes during loading and also profile not matching internal state loaded state (different from `profile.ijs` and so not dominated until a `Reload`, and does not trigger `Lock On`).
