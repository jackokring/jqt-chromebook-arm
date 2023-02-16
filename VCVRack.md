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
  
## Computational Considerations
The `J` engine uses a string IO interface. Conversion of `char*` to and from `float` can consume CPU, but as the engine runs on its own thread this will be just ocassional delay by a number of `Sync` intervals at the worst. Consider it a feature. 
