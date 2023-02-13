# debug_jig
Augmented Display of J results

At this point jig is only supported in jqt although plans are to have it ported to JHS soon.
jig is a script which takes the representation of a noun and converts it to an svg format that allows the user to interactively discover the properites of the noun.
It is loaded by loading jig.ijs which then uses the version to select the correct form of jig. j901 and j902 share the same code. j903 has separate code to accommodate qtide tooltips.
There is a lab that supports jig in the standard lab file under the name of Jig Augmented Display.
For j901, j902, and j903 boxed structures have depth and path information and there is an option to click on elements and have information displayed in a message box.
