VCS for CCFE
===
A bundle of functions for the console with a hard requirement of ConsoleCommandsForEveryone and all its hard requirements, as well as a soft requirement for whatever the script is that provides the native functions for the console commands one wants to use.

These include: PO3_SKSEFunctions, DbSKSEFunctions, DynamicPersistentForms, _SE_SpellExtender, NiOverride, sztkUtils, Chargen and ConsoleUtil.

Useful Commands
===
Use "? string" to search for string. There are over 600 commands so really, do that. If you don't know how do use a command, just provide ? as the first argument like "ChangeHeadpart ?" and it will just print out the desired format. 
Using "sc string" or "SetClipboard string" will copy string to the clipboard so you may paste later if you wish. This does support spaces and does not require double quotes. Very useful if you remembered you needed to type a command first but had already typed the second command you'll need as even though there's no native Ctrl+C that I've found for the console, ctrl+v does work.

WIP / Known Bugs
===
* Lacking standardization of the format help.
  *  Actors and other references may or may not be required.
    *  Sorry, this is a massive amount of work. I completely forgot to implement options to use the selected ref in some of them, so it's really hard to know which is which. You'll just have to try. Nothing horrible will happen as there are checks to make sure forms are the right formtype in every function. Initially I did not implement them but that did lead to crashes so I went back and implemented them in all the functions. While it's possible that some check is bad, it's highly unlikely, so it's safe to use this code without expecting crashes EXCEPT FOR THE 2 or 3 FUNCTIONS THAT USE StringArrFromSArgument as I said below.
  *  GENERALLY when the format says Actor akActor = GetSelectedReference() that means it supports using the command on the selected reference. It may or may not use the reference NECESSARILY. Making it optional took additional work and sometimes in a hurry I just didn't implement it. But seriously, just try and select the reference if it turns out that was required.
    * when the reference is optional, what decides whether the selected reference or a typed reference ID is going to be used is the number of arguments. For example, in "ChangeHeadPart", which typically requires two arguments, Actor and Headpart, if you provide just the Headpart it will use the selected reference. If you provide just the Actor it will complain that it failed to find a FormID. This does't mean that the FormID doesn't exist, but that a FormID of the required type wasn't found.  
* Providing arguments with spaces is untested. Where possible it simply removes the command name from the returned string (where it's just the command name plus the arguments) as in the SetClipboard command above, but elsewhere it uses a possibly buggy implementation that requires quoting the argument **with double quotes**. Only a couple of functions out of the hundreds will possibly require you to use spaces so, again, you may use this without fear.
* StringArrFromSArgument was not yet adapted to the above format so it's 100% gonna be buggy wherever it's used as it will detect a different number of arguments compared to the function StringFromSArgument that is the bedrock of this script.


License
===
To whatever extent I may be able to free this code to the wildest reaches of the Internet, it is free to use and redistribute with attribution in whatever means one decides.
