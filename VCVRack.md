# VCVRack Plugin
  * Needs a `libj.so` or other architecture specific dynamic library version 9 or greater.
  * Insert a `Master` module for the main interpretor thread.
  * Add `Input` and `Output` extenders.
  * The `Master` loads `profile.ijs` form the plugin's directory. (The program and configuration file).
  
## The Controls (`Input` and `Output`)
  * `Select` a variable channel. `A` to `Z`. (Visible on the display indicator).
  * `Start` a trigger input to start a transfer from or to the `Master`.
  * `Done` a gate output to indicate the `Master` has completed the processing.
  * `Input` (`Input` only) is the input to sample.
  * `Output` (`Output` only) is the generated output.
  * `Lock` button to prevent `Select` changes from unintentional overwriting an `Input` and to lock an `Output`.
  
## The Controls (`Master`)
  * `Sync` a trigger input to synchronize the `Done` signals and data presentation. If it is not present, `Done` will not occur and `Output` extender modules will not present a calculated `Output` signal.
  * `Reload` a button to trigger a refresh of the J core including a reload of the `profile.ijs` file.
  * `Error` a light indicating a returned error (latching until same expanders all get good results).
  * `Format` a light indicating invalid `float` data (latching until same expanders all get good results).
  * `Init` a light indicating a new `profile.ijs` is detected differing from the patch (only 1 `Master` is required, and contexts of 2 can differ).
  * `Dominate` a button to force a stored patch `profile.ijs` to be the global one and only. Needs slave `Master`'s of the `Master` to `Reload`.
  * `Saved` an light indicating a JSON save since a load. Technically `profile.ijs` is loaded thrice. Once by `J` and just before (de-)serialization.
  
## Computational Considerations
The `J` engine uses a string IO interface. Conversion of `char*` to and from `float` can consume CPU, but as the engine runs on its own thread this will be just ocassional delay by a number of `Sync` intervals at the worst. Consider it a feature.

Other data formats or errors other than `float` are not supported and should trigger a `Lock` on previous data. The `Master` indicates a returned error condition and also things like infinities, rationals or string data parse errors when technically the return is not a `J` error seperately.

## Patch Saves
The `Master` (maybe multiple copies) use `profile.ijs` so apparently a checksum `Init` warning is required. The patch then does not have the totality of the save. This simplifies the design of `Master` and the `Dominate` button clears this on that `Master` by writing `profile.ijs` from the patch. `Saved` helps with not destroying a profile. Nope, never a bug then.
