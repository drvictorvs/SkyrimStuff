VCS for CCFE
===
A bundle of functions for the console with a hard requirement of ConsoleCommandsForEveryone and all its hard requirements, as well as a soft requirement for whatever the script is that provides the native functions for the console commands one wants to use.

These include: PO3_SKSEFunctions, DbSKSEFunctions, DynamicPersistentForms, _SE_SpellExtender, NiOverride, sztkUtils, Chargen and ConsoleUtil.

WIP
===
* Lacking standardization of the format help.
* Providing arguments with space is untested. Where possible it simply removes the command name from the returned string (where it's just the command name plus the arguments), but elsewhere it uses a possibly buggy implementation that requires quoting the argument **with double quotes**.
* StringArrFromSArgument was not yet adapted to the above format so it's 100% gonna be buggy wherever it's used as it will detect a different number of arguments compared to the function StringFromSArgument that is the bedrock of this script.


License
===
To whatever extent I may be able to free this code to the wildest reaches of the Internet, it is free to use and redistribute with attribution in whatever means one decides.
