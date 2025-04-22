ScriptName CCFE_VictorCustomScript extends ConsoleCommandsForEveryone

Import PO3_SKSEFunctions
Import DbSKSEFunctions
Import DynamicPersistentForms
Import _SE_SpellExtender
Import NiOverride
Import ConsoleUtil
Import VCSMisc
Import MiscUtil
Import CustomSkills
Import OData
Import SILFollower
Import CW03Script
Import f314FD_Utils
Import CBPCPluginScript
Import TNG_PapyrusUtil

Actor Property PlayerRef Auto

Faction Property DLC1VampireFeedNoCrimeFaction Auto
Faction Property DLC1VampireTurnVictim Auto
Faction Property DLC1PlayerTurnedVampire Auto
Faction Property DLC1RV07ThankFaction Auto
Faction Property DLC1RV07CoffinOwnerFaction Auto
Faction Property VampirePCFamily Auto
Faction Property PotentialFollowerFaction Auto
Faction Property CurrentFollowerFaction Auto
Faction Property PotentialMarriageFaction Auto

; Player
Faction Property PlayerFaction Auto
Faction Property PlayerWerewolfFaction Auto
Faction Property PlayerVampireFaction Auto
Faction Property PlayerVampireLordFaction Auto

; Guards
Faction Property IsGuardFaction Auto
Faction Property DawnguardFaction Auto
Faction Property VigilantOfStendarrFaction Auto
Faction Property SilverHandFaction Auto

; Others
Faction Property DarkBrotherhoodFaction Auto
Faction Property CollegeofWinterholdFaction Auto
Faction Property DragonFaction Auto  
Faction Property FalmerFaction Auto
Faction Property PrisonerFaction Auto
Faction Property DraugrFaction Auto
Faction Property DragonPriestFaction Auto
Faction Property ForswornFaction Auto
Faction Property HagravenFaction Auto
Faction Property GiantFaction Auto
Faction Property NecromancerFaction Auto
Faction Property OrcFriendFaction Auto
Faction Property WerewolfFaction Auto
Faction Property BanditFaction Auto
Faction Property VolkiharFaction Auto
Faction Property CompanionsFaction Auto
Faction Property VampireFaction Auto
Faction Property SkeletonFaction Auto
Faction Property ThievesGuildFaction Auto
Faction Property BladesFaction Auto
Faction Property EastEmpireFaction Auto
Faction Property CreatureFaction Auto
Faction Property WarlockFaction Auto
Faction Property DaedraFaction Auto

; Stormcloaks
Faction Property StormcloakFaction Auto
Faction Property StormcloakAllyFaction Auto
Faction Property StormcloakGovFaction Auto
Faction Property StormcloakNPCFaction Auto

; Imperials
Faction Property ImperialFaction Auto
Faction Property ImperialJusticiarFaction Auto
Faction Property PenintusOculatusFaction Auto
Faction Property ImperialGovFaction Auto

; Thalmor
Faction Property ThalmorFaction Auto

; Crime factions
Faction Property CrimeFactionPale Auto
Faction Property CrimeFactionReach Auto
Faction Property CrimeFactionRift Auto
Faction Property CrimeFactionThievesGuild Auto
Faction Property CrimeFactionOrcs Auto
Faction Property CrimeFactionRavenRock Auto
Faction Property CrimeFactionSons Auto
Faction Property CrimeFactionImperial Auto
Faction Property CrimeFactionGreybeard Auto
Faction Property CrimeFactionCidhnaMine Auto
Faction Property CrimeFactionEastmarch Auto
Faction Property CrimeFactionHaafingar Auto

EffectShader property DLC1VampireChangeBackFXS auto

Sound Property MagVampireTransform01  Auto
Sound Property UIHealthHeartbeatALP Auto

EffectShader Property NeckMarksRight auto
EffectShader Property NeckMarksLeft auto

Spell Property VampireCharmEnhanced Auto
Spell Property TP1_TeleportInApplier Auto
Spell Property TP1_TeleportOutApplier Auto
Spell Property VMAG_BeneficialBeasthood Auto

Race Property ArgonianRace Auto
Race Property KhajiitRace Auto

ImageSpaceModifier Property DLC1VampireChangeImod Auto 

Idle Property pa_HugA Auto
Idle Property IdleVampireFeed Auto
Idle Property IdleVampireFeedFailsafe Auto
Idle Property IdleVampireFeastVictim Auto
Idle Property IdleVampireStandingFront Auto
Idle Property IdleVampireStandingBack Auto
Idle Property IdleVampireFeastVictimEnterInstant Auto 
Idle Property IdleBlessingKneel Auto
Idle Property IdleRitualSpellStart Auto
Idle Property IdleRitualSpellRelease Auto
Idle Property IdleSleepNod Auto

; Your event will receive full command in the string argument and number of command parts in the float argument.

Event OnInit()
  RegisterConsoleCommands()
EndEvent

Event OnPlayerLoadGame()
  RegisterConsoleCommands()
EndEvent

String Function IfElse(bool condition, string a, string b)
  If condition
    Return a 
  Else
    Return b
  EndIf
EndFunction

String[] Function StringArrayFromSArgument(String sArgument, Int argNumber = 1)
  ; Initialize variables
  String[] output
  Int index = 0
  Int L = StringUtil.GetLength(sArgument)
  Int currentArg = 0 ; Start counting from 0 (function name is arg 0)
  Bool inQuotes = False
  String currentArgText = ""

  ; Loop through the string to extract the desired argument
  While index < L
    String currentChar = StringUtil.GetNthChar(sArgument, index)

    ; Handle quoted arguments
    If currentChar == DoubleQuote()
      inQuotes = !inQuotes ; Toggle quote state
    EndIf

    ; Detect argument boundaries (spaces outside quotes)
    If (currentChar == " " && !inQuotes) || index == L - 1
      ; If we're at the end of the string, include the last character
      If index == L - 1
        currentArgText += currentChar
      EndIf

      ; Check if the current argument matches the requested argNumber
      If currentArg == argNumber
        ; Split the argument by ";" and store the result in the output array
        String[] tempArray = StringUtil.Split(currentArgText, ";")
        If tempArray.Length > 0
          output = tempArray
        Else
          ; If the split result is empty, return an array with an empty string
          output = New String[1]
          output[0] = ""
        EndIf
        Return output
      EndIf

      ; Reset for the next argument
      currentArgText = ""
      currentArg += 1
    Else
      ; Build the current argument text
      currentArgText += currentChar
    EndIf

    index += 1
  EndWhile

  ; If the requested argument was not found, return an array with an empty string
  output = New String[1]
  output[0] = ""
  Return output
EndFunction

Form[] Function FormArrayFromSArgument(String sArgument, int argNumber = 1)
  ; Split the sArgument string by spaces to get individual parts
  String[] parts = StringUtil.Split(sArgument, " ")
  
  ; Check if the requested argument exists
  If argNumber >= parts.Length
    PrintMessage("Argument " + argNumber + " does not exist in sArgument")
    Form[] result

    Return result  ; Return an empty array if the argument doesn't exist
  EndIf
  
  ; Get the specific argument (e.g., "512424;12335312;423413")
  String argument = parts[argNumber]
  
  ; Split the argument by semicolons to get individual form IDs or editor IDs
  String[] formStrings = StringUtil.Split(argument, ";")
  
  ; Initialize an empty array to store the forms
  Form[] result
  
  ; Loop through the formStrings array
  Int i = 0
  While i < formStrings.Length
    ; Get the current form string (e.g., "512424", "12335312", etc.)
    String formString = formStrings[i]
    
    ; Attempt to get the form from the current form string
    Form akForm = None
    
    ; Check if the form string is a hexadecimal form ID
    If IsHex(formString)
      PrintMessage("Attempting to get form from form ID " + formString)
      akForm = Game.GetFormEx(HexToInt(formString))
    ; Check if the form string is an editor ID
    ElseIf PO3_SKSEFunctions.GetFormFromEditorID(formString)
      PrintMessage("Getting form from editor ID " + formString)
      akForm = PO3_SKSEFunctions.GetFormFromEditorID(formString)
    EndIf
    
    ; If a form was successfully retrieved, add it to the form array
    If akForm != None
      result = PapyrusUtil.PushForm(result, akForm)
    Else
      PrintMessage("Failed to get form from string: " + formString)
    EndIf
    
    ; Move to the next form string
    i += 1
  EndWhile
  
  ; Return the array of forms
  Return result
EndFunction

Bool function IsHex(string hex) global
    Int L = StringUtil.GetLength(hex)
    If L > 8
      Return false
    EndIf
    String HexDigits = "0123456789abcdefABCDEF"
    
    Int I = 0
    While I < L
        String Char = StringUtil.GetNthChar(hex, I)
        Int Value = StringUtil.Find(HexDigits, Char)
        
        if Value == -1
            Return false
        Endif
        
        I += 1
    EndWhile
    
    Return true
EndFunction

Int Function HexToInt(String NumberAsHex, Bool TreatAsNegative = false)
  Return DbMiscFunctions.ConvertHexToInt(NumberAsHex)
EndFunction

String Function IntToHex(Int NumberAsDec)
  Return DbMiscFunctions.ConvertIntToHex(NumberAsDec)
EndFunction

Int Function GetNumPars(String sArgument)
  ; Initialize variables
  Int argCount = 0
  Int index = 0
  Int L = StringUtil.GetLength(sArgument)
  Bool inQuotes = False

  ; Loop through the string to count arguments
  While index < L
    String currentChar = StringUtil.GetNthChar(sArgument, index)

    ; Handle quoted arguments
    If currentChar == DoubleQuote()
      inQuotes = !inQuotes ; Toggle quote state
    EndIf

    ; Count arguments based on spaces (outside quotes)
    If currentChar == " " && !inQuotes
      argCount += 1
    EndIf

    index += 1
  EndWhile

  ; Return the total number of arguments
  Return argCount
endFunction

String Function StringFromSArgument(String sArgument, Int argNumber = 1, Int from = 0, Int to = 0)
  ; Initialize variables
  String output = ""
  Int index = 0
  Int L = StringUtil.GetLength(sArgument)
  Int currentArg = 0 ; Start counting from 0 (function name is arg 0)
  Bool inQuotes = False
  String currentArgText = ""

  ; Loop through the string to extract the desired argument(s)
  While index < L
    String currentChar = StringUtil.GetNthChar(sArgument, index)

    ; Handle quoted arguments
    If currentChar == DoubleQuote()
      inQuotes = !inQuotes ; Toggle quote state
    EndIf

    ; Detect argument boundaries (spaces outside quotes)
    If (currentChar == " " && !inQuotes) || index == L - 1
      ; If we're at the end of the string, include the last character
      If index == L - 1
        currentArgText += currentChar
      EndIf

      ; Check if the current argument matches the requested argNumber or range
      If (from == 0 && to == 0 && currentArg == argNumber) || (from != 0 && to != 0 && currentArg >= from && currentArg <= to)
        output += currentArgText + " "
      EndIf

      ; Reset for the next argument
      currentArgText = ""
      currentArg += 1
    Else
      ; Build the current argument text
      currentArgText += currentChar
    EndIf

    index += 1
  EndWhile

  ; Trim trailing space if necessary
  output = self.Trim(output)

  ; Handle the special case where argNumber = 0 (return the function name)
  If argNumber == 0
    ; Extract the function name (first argument)
    Int firstSpaceIndex = StringUtil.Find(sArgument, " ")
    If firstSpaceIndex == -1
      Return sArgument ; No space found, entire string is the function name
    Else
      Return StringUtil.Substring(sArgument, 0, firstSpaceIndex)
    EndIf
  EndIf

  ; Return the extracted argument(s)
  Return output
EndFunction

Int Function GetDebug(String EventName, String sArgument, Float fArgument, Form Sender)
  ; Print basic debug information
  PrintMessage("EventName: " + EventName)
  PrintMessage("sArgument: " + sArgument)
  PrintMessage("fArgument: " + fArgument as String)
  PrintMessage("Sender: " + Sender.GetName())

  ; Get the number of arguments in sArgument
  Int QtyPars = GetNumPars(sArgument)
  PrintMessage("Number of Arguments: " + QtyPars as String)

  ; Print each argument
  Int i = 1
  While i <= QtyPars
    PrintMessage("Argument " + (i) as String + ": " + self.StringFromSArgument(sArgument, i))
    i += 1
  EndWhile

  ; Return the number of arguments
  Return QtyPars
EndFunction

Int Function IntFromSArgumentHex(String sArgument, int argNumber = 1)
  Return HexToInt(StringUtil.Split(sArgument, " ")[argNumber])
EndFunction

Bool Function BoolFromSArgument(String sArgument, int argNumber = 1, bool fallback = false)
  string arg = StringUtil.Split(sArgument, " ")[argNumber]
  If arg == "1" || arg == "true"
    return true
  ElseIf arg == "0" || arg == "false"
    return false
  Else
    PrintMessage("Failed to get bool at argument " + argNumber as String + ". Defaulting to " + fallback as String)
    return fallback
  EndIf
EndFunction

ObjectReference Function RefFromSArgument(String sArgument, int argNumber = 1, ObjectReference fallback = None)
  If FormFromSArgument(sArgument, argNumber) as ObjectReference
    Return FormFromSArgument(sArgument, argNumber) as ObjectReference
  Else
    Return fallback
  EndIf
EndFunction

Form Function FormFromSArgument(String sArgument, int argNumber = 1, Form fallback = None)
  Form akForm
  String arg = self.StringFromSArgument(sArgument, argNumber)
  If IsHex(arg)
    PrintMessage("Attempting to get form from form ID " + arg)
    akForm = Game.GetFormEx(HexToInt(arg))
  ElseIf PO3_SKSEFunctions.GetFormFromEditorID(arg)
    PrintMessage("Getting form from editor ID " + arg)
    akForm = PO3_SKSEFunctions.GetFormFromEditorID(arg)
  EndIf
  If akForm == none
    PrintMessage("Failed to get form at argument " + argNumber + ". Returning fallback value " + GetFullID(fallback))
  EndIf
  Return akForm
EndFunction

Float Function FloatFromSArgument(String sArgument, int argNumber = 1, float fallback = 0.0)
  String[] parts = StringUtil.Split(sArgument, " ")
  if argNumber >= parts.Length 
    return fallback
  endif
  String part = parts[argNumber]
  float result = part as Float
  Return result
EndFunction

Int Function IntFromSArgument(String sArgument, int argNumber = 1, int fallback = 0)
  String[] parts = StringUtil.Split(sArgument, " ")
  if argNumber >= parts.Length
    return fallback
  endif
  String part = parts[argNumber]
  int result = part as Int
  Return result
EndFunction

String Function Trim(String stringToTrim, String characterToTrim = " ")
  string result = stringToTrim
  If DbMiscFunctions.StringHasPrefix(result, characterToTrim) 
    result = DbMiscFunctions.RemovePrefixFromString(result, characterToTrim)
  EndIf
  If DbMiscFunctions.StringHasSuffix(result, characterToTrim)
    result = DbMiscFunctions.RemoveSuffixFromString(result, characterToTrim)
  EndIf
  return result
EndFunction

Form Function GetSelectedBase()
  Return ConsoleUtil.GetSelectedReference().GetBaseObject()
EndFunction

String Function DoubleQuotes(String Data)
  Return "\"" + Data + "\""
EndFunction

String Function Paren(string str)
  Return " (" + str + ")"
EndFunction

String Function GetFullID(Form akForm)
  String FID = ""
  String EDID = ""
  String FT = DbMiscFunctions.GetFormTypeStringAll(akForm)

  If PO3_SKSEFunctions.IntToString(akForm.GetFormId(), true) != ""
    FID = PO3_SKSEFunctions.IntToString(akForm.GetFormId(), true)
  ElseIf DbMiscFunctions.GetFormIDHex(akForm) != ""
    FID = DbMiscFunctions.GetFormIDHex(akForm)
  Else
    FID = "unk. FormID"
  EndIf
  If PO3_SKSEFunctions.GetFormEditorId(akForm) != ""
    EDID = PO3_SKSEFunctions.GetFormEditorId(akForm)
  Else
    EDID = DbSKSEFunctions.GetFormEditorID(akForm, "unk. EDID")
  EndIf
  String Result = DoubleQuotes(EDID + " [" + FT + ": " + FID + "]")

  If (akForm as ObjectReference).GetDisplayName() != ""
    Result = DoubleQuotes(EDID + " '" + (akForm as ObjectReference).GetDisplayName() + "' [" + FT + ":" + FID + "]")
  EndIf

  Return Result
EndFunction

; sArgument inclui a função
; fArgument sempre será pelo menos 1 (a função)

;;
;; Actor
;;
Event OnConsoleDismount(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: Dismount [<Actor RefID>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  If QtyPars == 0
    akActor = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  If akActor.IsOnMount()
    akActor.Dismount()
    PrintMessage(self.GetFullID(akActor) + " was dismounted from " + self.GetFullID(PO3_SKSEFunctions.GetMount(akActor)))
  Else
    PrintMessage(self.GetFullID(akActor) + " is not mounted")
  EndIf
EndEvent

Event OnConsoleGetActorWarmthRating(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorWarmthRating [<Actor RefID>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  If QtyPars == 0
    akActor = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  String warmthRating = akActor.GetWarmthRating()
  If warmthRating == ""
    PrintMessage("Warmth rating for " + self.GetFullID(akActor) + " not found")
    Return
  EndIf
  PrintMessage("Warmth rating for " + self.GetFullID(akActor) + ": " + warmthRating)
EndEvent

Event OnConsoleGetArmorWarmthRating(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorWarmthRating [<Armor RefID>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  String warmthRating = akArmor.GetWarmthRating()
  If warmthRating == ""
    PrintMessage("Warmth rating for " + self.GetFullID(akArmor) + " not found")
    Return
  EndIf
  PrintMessage("Warmth rating for " + self.GetFullID(akArmor) + ": " + warmthRating)
EndEvent

Event OnConsoleGetArmorArmorRating(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorArmorRating [<Armor RefID>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  String ArmorRating = akArmor.GetArmorRating()
  If ArmorRating == ""
    PrintMessage("Armor rating for " + self.GetFullID(akArmor) + " not found")
    Return
  EndIf
  PrintMessage("Armor rating for " + self.GetFullID(akArmor) + ": " + ArmorRating)
EndEvent

Event OnConsoleSetArmorArmorRating(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetArmorArmorRating [<Armor RefID>] [Int aiRating]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  int aiRating = self.IntFromSArgument(sArgument, 1)
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  akArmor.SetArmorRating(aiRating)
  PrintMessage("Armor rating for " + self.GetFullID(akArmor) + ": " + aiRating)
EndEvent

Event OnConsoleMoveToPackageLocation(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: MoveToPackageLocation [<Actor RefID>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  If QtyPars == 0
    akActor = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  akActor.MoveToPackageLocation()
  PrintMessage(self.GetFullID(akActor) + " was moved to their package location")
EndEvent

Event OnConsoleSetEyeTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetEyeTexture [<Actor RefID>] <Texture akNewTexture>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  TextureSet akNewTexture
  If QtyPars == 1 ; If function + 1 arg
    akActor = ConsoleUtil.GetSelectedReference() as Actor
    akNewTexture = self.FormFromSArgument(sArgument, 1) as TextureSet ; 1 is first function argument, second term in sArgument
  ElseIf QtyPars == 2 ; If function + 1 arg
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    akNewTexture = self.FormFromSArgument(sArgument, 2) as TextureSet ; 1 is first function argument, second term in sArgument
  EndIf
  If akActor == none || akNewTexture == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  akActor.SetEyeTexture(akNewTexture)
  PrintMessage("Eye texture of " + self.GetFullID(akActor) + " set to " + self.GetFullID(akNewTexture))
EndEvent

Event OnConsoleShowBarterMenu(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ShowBarterMenu [<Actor RefID>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor

  If QtyPars == 0
    akActor = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  ElseIf akActor == Game.GetPlayer()
    PrintMessage("You cannot trade with yourself")
    Return
  EndIf
  akActor.ShowBarterMenu()
  PrintMessage("Barter menu shown for " + self.GetFullID(akActor))
EndEvent

Event OnConsoleChangeHeadPart(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ChangeHeadPart [<Actor RefID>] <HeadPart new>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  HeadPart hPart
  If QtyPars == 1
    akActor = ConsoleUtil.GetSelectedReference() as Actor
    hPart = self.FormFromSArgument(sArgument, 1) as HeadPart
  Else
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    hPart = self.FormFromSArgument(sArgument, 2) as HeadPart
  EndIf
  If akActor == none || hPart == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  akActor.ChangeHeadPart(hPart)
  PrintMessage("Head part of " + self.GetFullID(akActor) + " changed to " + self.GetFullID(hPart))
EndEvent

Event OnConsoleReplaceHeadPart(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ReplaceHeadPart [<Actor RefID = GetSelectedReference()>] <HeadPart oldPart> <HeadPart newPart>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  HeadPart oPart
  HeadPart newPart
  If QtyPars == 2
    akActor = ConsoleUtil.GetSelectedReference() as Actor
    oPart = self.FormFromSArgument(sArgument, 1) as HeadPart
    newPart = self.FormFromSArgument(sArgument, 2) as HeadPart
  Else
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    oPart = self.FormFromSArgument(sArgument, 2) as HeadPart
    newPart = self.FormFromSArgument(sArgument, 3) as HeadPart
  EndIf
  If akActor == none || oPart == none || newPart == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  akActor.ReplaceHeadPart(oPart, newPart)
  PrintMessage("Head part " + self.GetFullID(oPart) + " replaced with " + self.GetFullID(newPart) + " on " + self.GetFullID(akActor))
EndEvent

Event OnConsoleUpdateWeight(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: UpdateWeight [<Actor RefID>] <float weight>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  float weight
  If QtyPars == 1
    akActor = ConsoleUtil.GetSelectedReference() as Actor
    weight = self.FloatFromSArgument(sArgument, 1) as float
  ElseIf QtyPars == 2
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    weight = self.FloatFromSArgument(sArgument, 2) as float
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  akActor.UpdateWeight(weight) ; 1 is first argument, which is second term in sArgument
  NiOverride.UpdateModelWeight(akActor)
  PrintMessage("Weight of " + self.GetFullID(akActor) + " updated to " + weight as String)
EndEvent

Event OnConsoleGetEnchantment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetEnchantment [<ObjectReference akRef>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akItem
  If QtyPars == 0 ; The function alone
    akItem = ConsoleUtil.GetSelectedReference()
  ElseIf QtyPars == 1 ; The function + one argument
    akItem = self.RefFromSArgument(sArgument, 1)
  EndIf
  If akItem == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  Endif
  PrintMessage("Enchantment of object " + self.GetFullID(akItem) + " is " + self.GetFullID(akItem.GetEnchantment()))
EndEvent

Event OnConsoleSetEnchantment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetEnchantment [<ObjectReference akRef>] <Enchantment enchantment> <float charges = 100.0>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akItem
  Enchantment e
  float maxCharge
  If QtyPars == 2
    akItem = ConsoleUtil.GetSelectedReference()
    e = self.FormFromSArgument(sArgument, 1) as Enchantment
    maxCharge = self.FloatFromSArgument(sArgument, 2, 100.0)
  ElseIf QtyPars == 3
    akItem = self.RefFromSArgument(sArgument, 1)
    e = self.FormFromSArgument(sArgument, 2) as Enchantment
    maxCharge = self.FloatFromSArgument(sArgument, 3, 100.0)
  EndIf
  If akItem == none || e == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  akItem.SetEnchantment(e, maxCharge)
  PrintMessage("Enchantment of object " + self.GetFullID(akItem) + " set to " + self.GetFullID(e) + " with " + maxCharge as String + " charges")
EndEvent

Event OnConsoleAddToMap(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  bool CanFast = True
  PrintMessage("Format: AddToMap [<ObjectReference akRef>] [<bool CanFast = true>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  ObjectReference MapMarker
  If QtyPars == 0
    MapMarker = ConsoleUtil.GetSelectedReference()
    CanFast = True
    PrintMessage("Fast travel defaulting to true")
  ElseIf QtyPars == 1
    MapMarker = self.RefFromSArgument(sArgument, 1)
    If MapMarker == none
      MapMarker = ConsoleUtil.GetSelectedReference()
      CanFast = self.BoolFromSArgument(sArgument, 1)
    EndIf
  ElseIf QtyPars == 2
    MapMarker = self.RefFromSArgument(sArgument, 1)
    CanFast = self.BoolFromSArgument(sArgument, 2)
  EndIf
  If MapMarker == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  MapMarker.AddToMap(CanFast)
  PrintMessage("Map marker " + self.GetFullID(MapMarker) + " added to map")
EndEvent

Event OnConsoleAddKeywordToForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddKeywordToForm <Form formID> <Keyword formID>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  Keyword akKeyword = self.FormFromSArgument(sArgument, 2) as Keyword
  If akKeyword == none
    akKeyword = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 2))
  EndIf
  If akForm == none || akKeyword == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  PO3_SKSEFunctions.AddKeywordToForm(akForm, akKeyword)
  PrintMessage("Keyword " + self.GetFullID(akKeyword) + " added to " + self.GetFullID(akForm))
EndEvent

Event OnConsoleRemoveKeywordFromForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveKeywordFromForm <Form formID> <Keyword formID>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  Keyword akKeyword = self.FormFromSArgument(sArgument, 2) as Keyword
  
  If akKeyword == none
    akKeyword = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 2))
  EndIf

  If akForm == none
    akForm = self.GetSelectedBase()
  EndIf
  If akForm == none || akKeyword == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  ElseIf akForm.HasKeyword(akKeyword)
    PrintMessage("Keyword " + self.GetFullID(akKeyword) + " not present in " + self.GetFullID(akForm))
  EndIf
  PO3_SKSEFunctions.RemoveKeywordOnForm(akForm, akKeyword)
  PrintMessage("Keyword " + self.GetFullID(akKeyword) + " removed from " + self.GetFullID(akForm))
EndEvent

Event OnConsoleAddKeywordToRef(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddKeywordToRef [<ObjectReference akRef>] <Keyword formID>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  Keyword akKeyword
  If QtyPars == 1
    akRef = ConsoleUtil.GetSelectedReference()
    akKeyword = self.FormFromSArgument(sArgument, 1) as Keyword
    If akKeyword == none
      akKeyword = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 1))
    EndIf
  ElseIf QtyPars == 2
    akRef = self.RefFromSArgument(sArgument, 1)
    akKeyword = self.FormFromSArgument(sArgument, 2) as Keyword
    If akKeyword == none
      akKeyword = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 2))
    EndIf
  EndIf
  If akRef == none || akKeyword == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  PO3_SKSEFunctions.AddKeywordToRef(akRef, akKeyword)
  PrintMessage("Keyword " + self.GetFullID(akKeyword) + " added to " + self.GetFullID(akRef))
EndEvent

Event OnConsoleRemoveKeywordFromRef(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveKeywordFromRef [<ObjectReference akRef>] <Keyword formID>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  Keyword akKeyword
  If QtyPars == 1
    akRef = ConsoleUtil.GetSelectedReference()
    akKeyword = self.FormFromSArgument(sArgument, 1) as Keyword
    If akKeyword == none
      akKeyword = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 1))
    EndIf
  ElseIf QtyPars == 2
    akRef = self.RefFromSArgument(sArgument, 1)
    akKeyword = self.FormFromSArgument(sArgument, 2) as Keyword
    If akKeyword == none
      akKeyword = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 2))
    EndIf
  EndIf
  If akRef == none || akKeyword == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  PO3_SKSEFunctions.RemoveKeywordFromRef(akRef, akKeyword)
  PrintMessage("Keyword " + self.GetFullID(akKeyword) + " removed from " + self.GetFullID(akRef))
EndEvent

Event OnConsoleEvaluatePackage(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: EvaluatePackage [<Actor RefID>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  
  If QtyPars == 0
    akActor = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf

  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf

  akActor.EvaluatePackage()
  PrintMessage("Package of " + self.GetFullID(akActor) + " is now being evaluated")
EndEvent

Event OnConsoleAddKeyIfNeeded(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddKeyIfNeeded [<ObjectReference akRef>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef 
  
  If QtyPars == 0
    akRef = ConsoleUtil.GetSelectedReference()
  ElseIf QtyPars == 1
    akRef = self.RefFromSArgument(sArgument, 1)
  EndIf

  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  Key NeededKey = akRef.GetKey()
  If NeededKey == None
      If Game.GetPlayer().GetItemCount(NeededKey) == 0
          Game.GetPlayer().AddItem(NeededKey)
      EndIf
  Else
    PrintMessage("No key needed for reference " + self.GetFullID(akRef))
  EndIf
  PrintMessage("Key added to player if needed")
EndEvent

Event OnConsoleForceAddRagdollToWorld(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ForceAddRagdollToWorld [<Actor RefID>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  
  If QtyPars == 0
    akActor = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ForceAddRagdollToWorld()
  PrintMessage("Ragdoll added to " + self.GetFullID(akActor))
EndEvent

Event OnConsoleForceRemoveRagdollFromWorld(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ForceRemoveRagdollFromWorld [<Actor RefID>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  
  If QtyPars == 0
    akActor = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ForceRemoveRagdollFromWorld()
  PrintMessage("Ragdoll removed from " + self.GetFullID(akActor))
EndEvent

Event OnConsoleBite(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: Bite(Actor akTarget)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akTarget
  
  If QtyPars == 0
    akTarget = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    akTarget = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf

  If akTarget == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PlayerRef.StartVampireFeed(akTarget)
EndEvent

Event OnConsoleSetVampire(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetVampire [<Actor RefID>] [<bool makeVampireLord = true>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  bool makeVampireLord
  
  If QtyPars == 0
    akActor = ConsoleUtil.GetSelectedReference() as Actor
    makeVampireLord = BoolFromSArgument(sArgument, 1, true)
  ElseIf QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    makeVampireLord = BoolFromSArgument(sArgument, 2, true)
  EndIf

  self.MakeVampire(akActor, makeVampireLord)
EndEvent


Function SetVampireEyes(Actor akActor, bool makeVampireLord)
  TextureSet EyesMaleHumanVampire = Game.GetFormEx(0x000E7AEF) as TextureSet
  TextureSet EyesMaleHumanVampire01 = Game.GetFormEx(0x02006F89) as TextureSet
  TextureSet SkinEyesMaleArgonianVampire = Game.GetFormFromFile(0x54b55a, "Better Vampires.esp") as TextureSet
  TextureSet SkinEyesKhajiitVampire = Game.GetFormFromFile(0x54b55b, "Better Vampires.esp") as TextureSet

  If makeVampireLord
    akActor.SetEyeTexture(EyesMaleHumanVampire01)
  ElseIf (akActor.GetActorBase().GetRace() == ArgonianRace)
    akActor.SetEyeTexture(SkinEyesMaleArgonianVampire)
  ElseIf (akActor.GetActorBase().GetRace() == KhajiitRace)
    akActor.SetEyeTexture(SkinEyesKhajiitVampire)
  Else
    akActor.SetEyeTexture(EyesMaleHumanVampire)
  EndIf
EndFunction


Function MakeVampire(Actor akActor, bool makeVampireLord)
  DLC1VampireChangeBackFXS.Play(akActor)
  int soundInst = UIHealthHeartbeatALP.Play(akActor)

  Race actorRace = akActor.GetRace()
  Race targetRace = RaceCompatibility.GetVampireRaceByRace(actorRace)

  Spell DLC1VampireChange = PO3_SKSEFunctions.GetFormFromEditorID("DLC1VampireChange") as Spell
  Perk DLC1VampireTurnPerk = PO3_SKSEFunctions.GetFormFromEditorID("DLC1VampireTurnPerk") as Perk
  CombatStyle csVampire = PO3_SKSEFunctions.GetFormFromEditorID("csVampire") as CombatStyle
  PO3_SKSEFunctions.AddKeywordToForm(akActor, Keyword.GetKeyword("ActorTypeVampire"))

  If makeVampireLord == true
    akActor.AddSpell(DLC1VampireChange)
    akActor.AddPerk(DLC1VampireTurnPerk)
    PO3_SKSEFunctions.AddKeywordToForm(akActor, Keyword.GetKeyword("ActorTypeVampireBrute"))
  EndIf

  Utility.Wait(0.2)

  self.SetVampireEyes(akActor, makeVampireLord)

  akActor.SetRace(targetRace)

  Utility.Wait(0.2)

  akActor.QueueNiNodeUpdate()

  ActorBase akActorBase = akActor.GetActorBase()
  
  If akActorBase.IsUnique()
    akActorBase.SetCombatStyle(csVampire)
    akActorBase.SetEssential()
  EndIf

  akActor.QueueNiNodeUpdate()

  DLC1VampireChangeBackFXS.Stop(akActor)
  Sound.StopInstance(soundInst)

  PO3_SKSEFunctions.AddKeywordToForm(akActor, Keyword.GetKeyword("Vampire"))

  PO3_SKSEFunctions.AddKeywordToForm(akActor, Keyword.GetKeyword("ActorTypeUndead"))

EndFunction


Event OnConsoleTurnVampire(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: TurnVampire(bool makeVampireLord = true, bool giveSpells = true, bool specialBond = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("Only works with a selected reference")
  Actor akTarget = ConsoleUtil.GetSelectedReference() as Actor
  bool makeVampireLord = self.BoolFromSArgument(sArgument, 1, true)
  bool giveSpells = self.BoolFromSArgument(sArgument, 2, true)
  bool specialBond = self.BoolFromSArgument(sArgument, 3, true)

  akTarget.StopCombat()
  akTarget.StopCombatAlarm()

  DLC1VampireChangeImod.Apply()
  
  
  NeckMarksRight.Play(akTarget, 240)
  int soundInst = MagVampireTransform01.Play(akTarget)

  If akTarget.GetActorBase().IsUnique()
    akTarget.GetActorBase().SetEssential(true)
  EndIf

  PlayerRef.StartVampireFeed(akTarget)

  akTarget.SetUnconscious()
  self.MakeVampire(akTarget, makeVampireLord)
  
  If VMAG_BeneficialBeasthood == none
    VMAG_BeneficialBeasthood = PO3_SKSEFunctions.GetFormFromEditorID("VMAG_BenevolentBeasthood") as Spell
  EndIf

  If giveSpells
    akTarget.AddSpell(VMAG_BeneficialBeasthood)
  EndIf

  Utility.Wait(0.5)
  Utility.Wait(0.5)

  akTarget.AddToFaction(DLC1PlayerTurnedVampire)

  If specialBond
    Faction PlayerBedOwnership = Game.GetFormEx(0xF2073) as Faction
    akTarget.SetRelationshipRank(PlayerRef, 4)
    akTarget.SetFactionRank(PotentialFollowerFaction, 1)
    akTarget.SetFactionRank(PlayerBedOwnership, 1)
    akTarget.SetFactionRank(CurrentFollowerFaction, 1)
    akTarget.SetFactionRank(PotentialMarriageFaction, 1)
    akTarget.SetFactionRank(DLC1RV07CoffinOwnerFaction, 1)
    If VampirePCFamily
      VampirePCFamily = PO3_SKSEFunctions.GetFormFromEditorID("VampirePCFamily") as Faction
      akTarget.SetFactionRank(VampirePCFamily, 1)
    EndIf
  ElseIf akTarget.GetRelationshipRank(PlayerRef) < 1
    akTarget.SetRelationshipRank(PlayerRef, 1)
  EndIf
  
  Utility.Wait(1)
  
  Sound.StopInstance(soundInst)
  

  akTarget.SetUnconscious(false)

  DLC1VampireChangeImod.Remove()

EndEvent

Event OnConsoleApplyMaterialShader(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ApplyMaterialShader <MaterialObject matObject> <float directionalThresholdAngle>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("Only works with a selected reference")
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  MaterialObject akMatObject = self.FormFromSArgument(sArgument, 1) as MaterialObject
  float directionalThresholdAngle = self.FloatFromSArgument(sArgument, 2) as float
  If akRef == none || akMatObject == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.ApplyMaterialShader(akRef, akMatObject, directionalThresholdAngle) 
  PrintMessage("Material shader " + self.GetFullID(akMatObject) + " applied to " + self.GetFullID(akRef))
EndEvent

Event OnConsoleStopAllShaders(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: StopAllShaders [<ObjectReference akRef>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akref
  If QtyPars == 0
    akRef = ConsoleUtil.GetSelectedReference()
  ElseIf QtyPars == 1
    akRef = self.RefFromSArgument(sArgument, 1)
  EndIf
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.StopAllShaders(akRef)
  PrintMessage("All shaders stopped on " + self.GetFullID(akRef))
EndEvent

Event OnConsoleStopArtObject(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: StopArtObject [<ObjectReference akRef>] <Art akArt>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akref
  Art akArt
  If QtyPars == 0
    akRef = ConsoleUtil.GetSelectedReference()
    akArt = self.FormFromSArgument(sArgument,1) as Art
  ElseIf QtyPars == 1
    akRef = self.RefFromSArgument(sArgument, 1)
    akArt = self.FormFromSArgument(sArgument,2) as Art
  EndIf
  If akRef == none || akArt == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.StopArtObject(akRef, akArt)
  PrintMessage("Art object " + self.GetFullID(akArt) + " stopped on " + self.GetFullID(akRef))
EndEvent

Event OnConsoleSetArtObject(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetArtObject <VisualEffect akEffect> <Art akArt>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  VisualEffect akEffect = self.FormFromSArgument(sArgument,1) as VisualEffect
  Art akArt = self.FormFromSArgument(sArgument,2) as Art
  If akEffect == none || akArt == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.SetArtObject(akEffect, akArt)
  PrintMessage("Art object " + self.GetFullID(akArt) + " set on " + self.GetFullID(akEffect))
EndEvent

Event OnConsoleToggleChildNode(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ToggleChildNode [<ObjectReference akRef>] <string nodeName> <bool disable = false>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  string asNodeName
  bool abDisable = false
  If QtyPars == 0
    akRef = ConsoleUtil.GetSelectedReference()
    asNodeName = self.StringFromSArgument(sArgument,1)
    abDisable = self.BoolFromSArgument(sArgument, 2, false)
  ElseIf QtyPars == 3
    akRef = self.RefFromSArgument(sArgument, 1)
    asNodeName = self.StringFromSArgument(sArgument,2)
    abDisable = self.BoolFromSArgument(sArgument, 3, false)
  EndIf
  
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.ToggleChildNode(akRef, asNodeName, abDisable)
  PrintMessage("Child node " + asNodeName + " toggled on " + self.GetFullID(akRef))
EndEvent

Event OnConsoleGetAllEffectShaders(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllEffectShaders [<ObjectReference akRef>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  If QtyPars == 0
    akRef = ConsoleUtil.GetSelectedReference()
  ElseIf QtyPars == 1
    akRef = self.RefFromSArgument(sArgument, 1)
  EndIf
  
  EffectShader[] result = PO3_SKSEFunctions.GetAllEffectShaders(akRef)
  int i = 0
  int L = result.Length
  If L > 0
    PrintMessage("Found " + L + " effect shaders")
  Else
    PrintMessage("No effect shaders found")
    Return
  EndIf
  While i < L
    PrintMessage("Effect shader #" + i + ": " + self.GetFullID(result[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleGetAllArtObjects(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllArtObjects [<ObjectReference akRef>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  If QtyPars == 0
    akRef = ConsoleUtil.GetSelectedReference()
  ElseIf QtyPars == 1
    akRef = self.RefFromSArgument(sArgument, 1)
  EndIf
  Art[] result = PO3_SKSEFunctions.GetAllArtObjects(akRef)
  int i = 0
  int L = result.Length
  If L > 0
    PrintMessage("Found " + L + " art objects")
  Else
    PrintMessage("No art objects found")
    Return
  EndIf
  While i < L
    PrintMessage("Art object #" + i + ": " + self.GetFullID(result[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleFindAllReferencesOfFormType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: FindAllReferencesOfFormType [<ObjectReference akRef>] <int formType> <float afRadius>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  int formTypeN
  float afRadius
  If QtyPars == 0
    akRef = ConsoleUtil.GetSelectedReference()
    formTypeN = self.IntFromSArgument(sArgument,1)
    afRadius = self.FloatFromSArgument(sArgument,2)
  ElseIf QtyPars == 1
    akRef = self.RefFromSArgument(sArgument, 1)
    formTypeN = self.IntFromSArgument(sArgument,2)
    afRadius = self.FloatFromSArgument(sArgument,3)
  EndIf
  ObjectReference[] result = PO3_SKSEFunctions.FindAllReferencesOfFormType(akRef, formTypeN, afRadius)
  int i = 0
  int L = result.Length
  If L > 0
    PrintMessage("Found " + L + " references of form type " + formTypeN)
  Else
    PrintMessage("No references of form type " + formTypeN + " found")
    Return
  EndIf
  While i < L
    PrintMessage("Reference #" + i + ": " + self.GetFullID(result[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleFindAllReferencesWithKeyword(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: FindAllReferencesWithKeyword(ObjectReference akRef, Form keywordOrList, float afRadius, bool abMatchAll)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  Form keywordOrList
  float afRadius
  bool abMatchAll
  If QtyPars == 0
    akRef = ConsoleUtil.GetSelectedReference()
    keywordOrList = self.FormFromSArgument(sArgument,1)
    afRadius = self.FloatFromSArgument(sArgument,2)
    abMatchAll = self.BoolFromSArgument(sArgument,3)
  ElseIf QtyPars == 1
    akRef = self.RefFromSArgument(sArgument, 1)
    keywordOrList = self.FormFromSArgument(sArgument,2)
    afRadius = self.FloatFromSArgument(sArgument,3)
    abMatchAll = self.BoolFromSArgument(sArgument,4)
  EndIf
  ObjectReference[] result = PO3_SKSEFunctions.FindAllReferencesWithKeyword(akRef, keywordOrList, afRadius, abMatchAll)
  int i = 0
  int L = result.Length
  If L > 0
    PrintMessage("Found " + L + " references with keyword " + self.GetFullID(keywordOrList))
  Else
    PrintMessage("No references with keyword " + self.GetFullID(keywordOrList) + " found")
    Return
  EndIf
  While i < L
    PrintMessage("Reference #" + i + ": " + self.GetFullID(result[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleFindAllReferencesOfType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: FindAllReferencesOfType [<ObjectReference akRef>] <Form type> <float afRadius>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  Form type
  float afRadius
  If QtyPars == 2
    akRef = ConsoleUtil.GetSelectedReference()
    type = self.FormFromSArgument(sArgument,1)
    afRadius = self.FloatFromSArgument(sArgument,2)
  ElseIf QtyPars == 3
    akRef = self.RefFromSArgument(sArgument, 1)
    type = self.FormFromSArgument(sArgument,2)
    afRadius = self.FloatFromSArgument(sArgument,3)
  EndIf
  ObjectReference[] result = PO3_SKSEFunctions.FindAllReferencesOfType(akRef, type, afRadius)
  int i = 0
  int L = result.Length
  If L > 0
    PrintMessage("Found " + L + " references of type " + self.GetFullID(type))
  Else
    PrintMessage("No references of type " + self.GetFullID(type) + " found")
    Return
  EndIf
  While i < L
    PrintMessage("Reference #" + i + ": " + self.GetFullID(result[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleSelectCrosshair(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SelectCrosshair")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = Game.GetCurrentCrosshairRef()
  If akRef
    PrintMessage("Reference in crosshairs is " + self.GetFullID(akRef) + " based on FormID " + self.GetFullID(akRef.GetBaseObject()))
    SetSelectedReference(akRef)
  Else
    PrintMessage("No reference in crosshairs")
  EndIf
EndEvent

Event OnConsoleGetRunningPackage(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRunningPackage [<Actor RefID>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  If QtyPars == 0
    akActor = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Package runningPackage = PO3_SKSEFunctions.GetRunningPackage(akActor)
  If runningPackage == none
    PrintMessage("No running package found")
    Return
  EndIf
  PrintMessage("Running package of " + self.GetFullID(akActor) + " is " + self.GetFullID(runningPackage))
EndEvent

Event OnConsoleCreatePersistentForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CreatePersistentForm <Form formID>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Form newForm = DynamicPersistentForms.Create(akForm)
  PrintMessage("Created form " + self.GetFullID(newForm))
EndEvent

Event OnConsoleDisposeOfPersistentForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: DisposeOfPersistentForm <Form formID>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  DynamicPersistentForms.Dispose(akForm)
  PrintMessage("Disposed of form " + self.GetFullID(akForm))
EndEvent

Event OnConsoleTrackForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: TrackForm <Form formID>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  DynamicPersistentForms.Track(akForm)
  PrintMessage("Tracking form " + self.GetFullID(akForm))
EndEvent

Event OnConsoleUntrackForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: UntrackForm <Form formID>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  DynamicPersistentForms.Untrack(akForm)
  PrintMessage("No longer tracking form " + self.GetFullID(akForm))
EndEvent

Event OnConsoleAddMagicEffect(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddMagicEffect <Form item> <MagicEffect effect> <float magnitude> <int area> <int duration> <float cost>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  MagicEffect akEffect = self.FormFromSArgument(sArgument, 2) as MagicEffect
  float magnitude = self.FloatFromSArgument(sArgument, 3)
  int area = self.IntFromSArgument(sArgument, 4)
  int duration = self.IntFromSArgument(sArgument, 5)
  float cost = self.FloatFromSArgument(sArgument, 6)
  If akForm == none || akEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  DynamicPersistentForms.AddMagicEffect(akForm, akEffect, magnitude, area, duration, cost)
  PrintMessage("Magic effect " + self.GetFullID(akEffect) + " added to " + self.GetFullID(akForm))
EndEvent

Event OnConsoleGetRefAliases(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRefAliases [<ObjectReference akRef>]")

  ObjectReference akRef
  If QtyPars == 0
    akRef = ConsoleUtil.GetSelectedReference()
  ElseIf QtyPars == 1
    akRef = self.RefFromSArgument(sArgument, 1)
  EndIf

  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  Alias[] aliases = PO3_SKSEFunctions.GetRefAliases(akRef)
  int i = 0
  int L = aliases.Length
  If L > 0
    PrintMessage("Found " + L + " aliases")
  Else
    PrintMessage("No aliases found")
    Return
  EndIf
  While i < L
    PrintMessage("Alias #" + aliases[i].GetID() + " of quest " + self.GetFullID(aliases[i].GetOwningQuest()) + ": " + aliases[i].GetName())
    i += 1
  EndWhile
EndEvent

Event OnConsoleShowMenu(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ShowMenu <string MenuName>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("MENU NAME HELP")
    PrintMessage("=========================")
    PrintMessage("InventoryMenu")
    PrintMessage("Console")
    PrintMessage("Dialogue Menu")
    PrintMessage("HUD Menu")
    PrintMessage("Main Menu")
    PrintMessage("MessageBoxMenu")
    PrintMessage("Cursor Menu")
    PrintMessage("Fader Menu")
    PrintMessage("MagicMenu")
    PrintMessage("Top Menu")
    PrintMessage("Overlay Menu")
    PrintMessage("Overlay Interaction Menu")
    PrintMessage("Loading Menu")
    PrintMessage("TweenMenu")
    PrintMessage("BarterMenu")
    PrintMessage("GiftMenu")
    PrintMessage("Debug Text Menu")
    PrintMessage("MapMenu")
    PrintMessage("Lockpicking Menu")
    PrintMessage("Quantity Menu")
    PrintMessage("StatsMenu")
    PrintMessage("ContainerMenu")
    PrintMessage("Sleep/Wait Menu")
    PrintMessage("LevelUp Menu")
    PrintMessage("Journal Menu")
    PrintMessage("Book Menu")
    PrintMessage("FavoritesMenu")
    PrintMessage("RaceSex Menu")
    PrintMessage("Crafting Menu")
    PrintMessage("Training Menu")
    PrintMessage("Mist Menu")
    PrintMessage("Tutorial Menu")
    PrintMessage("Credits Menu")
    PrintMessage("TitleSequence Menu")
    PrintMessage("Console Native UI Menu")
    PrintMessage("Kinect Menu")
    PrintMessage("=========================")
    Return
  EndIf
  String UIName = DbMiscFunctions.RemovePrefixFromString(sArgument, self.StringFromSArgument(sArgument, 0) + " ")
  If UIName == ""
    PrintMessage("FATAL ERROR: You must type a MenuName")
    Return
  EndIf
  PO3_SKSEFunctions.ShowMenu(UIName)
  PrintMessage("Menu " + UIName + " shown")
EndEvent

Event OnConsoleHideMenu(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: HideMenu <string MenuName>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  String UIName = DbMiscFunctions.RemovePrefixFromString(sArgument, self.StringFromSArgument(sArgument, 0) + " ")
  If UIName == ""
    PrintMessage("FATAL ERROR: You must type a MenuName")
    Return
  EndIf
  PO3_SKSEFunctions.HideMenu(UIName)
  PrintMessage("Menu " + UIName + " hidden")
EndEvent

Event OnConsoleToggleOpenSleepWaitMenu(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ToggleOpenSleepWaitMenu <bool abSleep = false>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  bool abSleep = self.BoolFromSArgument(sArgument, 1, false)
  PO3_SKSEFunctions.ToggleOpenSleepWaitMenu(abSleep)
EndEvent

Event OnConsoleVCSHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("VCSHelp [<string helpString>]")

  PrintMessage("CCFE_VictorCustomScript Help")
  PrintMessage("======================================================================")

  String[] helpMsg = new String[128]
    helpMsg[0] = "ShowGiftMenu"
    helpMsg[1] = "SetOutfit"
    helpMsg[2] = "Dismount"
    helpMsg[3] = "GetActorWarmthRating"
    helpMsg[4] = "MoveToPackageLocation "
    helpMsg[5] = "SetEyeTexture"
    helpMsg[6] = "ShowBarterMenu"
    helpMsg[7] = "UpdateWeight"
    helpMsg[8] = "ReplaceHeadPart"
    helpMsg[9] = "ChangeHeadPart"
    helpMsg[10] = "GetEnchantment"
    helpMsg[11] = "SetEnchantment"
    helpMsg[12] = "AddToMap"
    helpMsg[13] = "AddKeywordToRef"
    helpMsg[14] = "RemoveKeywordFromRef"
    helpMsg[15] = "AddKeyIfNeeded"
    helpMsg[16] = "ForceAddRagdollToWorld"
    helpMsg[17] = "ForceRemoveRagdollFromWorld"
    helpMsg[18] = "SetVampire"
    helpMsg[19] = "Bite"
    helpMsg[20] = "TurnVampire  [<bool makeVampireLord> <bool giveSpells>]: player turns the selected actor into a related vampire"
    helpMsg[21] = "TurnBetterVampire: player turns the selected actor into a related vampire"
    helpMsg[22] = "ApplyMaterialShader <MaterialObject akMatObject> <float directionalThresholdAngle>: to selected object"
    helpMsg[23] = "StopAllShaders: from selected object"
    helpMsg[24] = "StopArtObject <Art akArt>"
    helpMsg[25] = "SetArtObject <VisualEffect akEffect> <Art akArt>"
    helpMsg[26] = "ToggleChildNode <string asNodeName> <bool abDisable>: from selected object"
    helpMsg[27] = "GetAllEffectShaders: from selected object"
    helpMsg[28] = "GetAllArtObjects: from selected object"
    helpMsg[29] = "FindAllReferencesOfFormType <int formTypeN> <float afRadius>: from selected object"
    helpMsg[30] = "FindAllReferencesOfType <Form type> <float afRadius>: from selected object"
    helpMsg[31] = "SelectCrosshair"
    helpMsg[32] = "GetRunningPackage"
    helpMsg[33] = "CreatePersistentForm"
    helpMsg[34] = "AddMagicEffect <Form item> <MagicEffect effect> <float magnitude> <int area> <int duration> <float cost>"
    helpMsg[35] = "GetRefAliases"
    helpMsg[36] = "ShowMenu <string MenuName>"
    helpMsg[37] = "HideMenu <string MenuName> "
    helpMsg[38] = "ToggleOpenSleepWaitMenu <bool Sleep>"
    helpMsg[39] = "VCSHelp"
    helpMsg[40] = "FormTypeHelp"
    helpMsg[41] = "ReplaceFaceTextureSet (Actor akActor, TextureSet akMaleTXST, TextureSet akFemaleTXST, int aiTextureType)"
    helpMsg[42] = "ReplaceSkinTextureSet (Actor akActor, TextureSet akMaleTXST, TextureSet akFemaleTXST, int aiSlotMask, int aiTextureType)"
    helpMsg[43] = "SetHairColor <int colorR, int colorG, int colorB>"
    helpMsg[44] = "SetHeadPartTextureSet <Actor akActor, TextureSet headpartTXST, int aiType>"
    helpMsg[45] = "SetSkinColor <int colorR, int colorG, int colorB>"
    helpMsg[46] = "SetSkinAlpha <float skinAlpha> "
    helpMsg[47] = "SetKey <Key akKey>"
    helpMsg[48] = "MarkFavorite <Form akForm>"
    helpMsg[49] = "UnmarkFavorite <Form akForm>"
    helpMsg[50] = "SetSoundDescriptor"
    helpMsg[51] = "CreateSoundMarker"
    helpMsg[52] = "PlaySound"
    helpMsg[53] = "PlaySoundDescriptor"
    helpMsg[54] = "ClearMagicEffects"
    helpMsg[55] = "CopyMagicEffects"
    helpMsg[56] = "CopyAppearance"
    helpMsg[57] = "SetSpellTomeSpell"
    helpMsg[58] = "SetSpellAutoCalculate"
    helpMsg[59] = "SetSpellCostOverride"
    helpMsg[60] = "SetSpellChargeTime"
    helpMsg[61] = "SetSpellCastDuration"
    helpMsg[62] = "SetSpellRange"
    helpMsg[63] = "SetSpellCastingPerk"
    helpMsg[64] = "CreateColorForm"
    helpMsg[65] = "Teleport (Tel)"
    helpMsg[66] = "SoundPause"
    helpMsg[67] = "SoundUnpause"
    helpMsg[68] = "SoundMute"
    helpMsg[69] = "SoundUnmute"
    helpMsg[70] = "SetVolume"
    helpMsg[71] = "SaveEx"
    helpMsg[72] = "Del"
    helpMsg[73] = "AttachPapyrusScript"
    helpMsg[74] = "AddKeywordToForm"
    helpMsg[75] = "RemoveKeywordFromForm"
    helpMsg[76] = "GetFormDescription"
    helpMsg[77] = "AddMagicEffectToSpell (AddMGEF)"
    helpMsg[78] = "GetFormTypeAll"
    helpMsg[79] = "CreateXMarkerRef"
    helpMsg[80] = "GetEnchantArt"
    helpMsg[81] = "GetCastingArt"
    helpMsg[82] = "GetHitEffectArt"
    helpMsg[83] = "GetEnchantShader"
    helpMsg[84] = "GetHitShader"
    helpMsg[85] = "SetEnchantArt"
    helpMsg[86] = "SetCastingArt"
    helpMsg[87] = "SetEnchantShader"
    helpMsg[88] = "SetHitShader"
    helpMsg[89] = "RemoveAllPerks"
    helpMsg[90] = "ResetActor3D"
    helpMsg[91] = "AddPackageIdle"
    helpMsg[92] = "RemovePackageIdle"
    helpMsg[93] = "GetFormIDFromEditorID"
    helpMsg[94] = "GetEDIDFromFormID"
    helpMsg[95] = "GetFormModName"
    helpMsg[96] = "GetScriptsAttachedToActiveEffect"
    helpMsg[97] = "DismissAllSummons"
    helpMsg[98] = "AddMagicEffectToEnchantment"
    helpMsg[99] = "RemoveMagicEffectFromEnchantment"
    helpMsg[100] = "GetConditionList"
    helpMsg[101] = "Sleep"
    helpMsg[102] = "LaunchSpell"
    helpMsg[103] = "GetMenuContainer"
    helpMsg[104] = "SetItemHealthPercent"
    helpMsg[105] = "SetDisplayName"
    helpMsg[106] = "EnchantObject"
    helpMsg[107] = "ClearDestruction"
    helpMsg[108] = "PlaceAroundReference"
    helpMsg[109] = "SaveCharacter"
    helpMsg[110] = "LoadCharacter"
    helpMsg[111] = "RecordSignatureHelp (RS)"
    helpMsg[112] = "PlayIdleWithTarget (PIWT)"
    helpMsg[113] = "GetEquipType"
    helpMsg[114] = "SetEquipType"
    helpMsg[115] = "GetDialogueTarget"
    helpMsg[116] = "ForceFirstPerson"
    helpMsg[117] = "ForceThirdPerson"
    helpMsg[118] = "SetPlayerAIDriven"
    helpMsg[119] = "ShowLimitedRaceMenu"
    helpMsg[120] = "SetPlayersLastRiddenHorse"
    helpMsg[121] = "TriggerScreenBlood"
    helpMsg[122] = "TapKey"
    helpMsg[123] = "HoldKey"
    helpMsg[124] = "ReleaseKey"
    helpMsg[125] = "GetLocationKeywordData"
    helpMsg[126] = "SetItemMaxCharge"
    helpMsg[127] = "SetArtModelPath"
    
  String[] helpMsg_2 = new String[128]
    helpMsg_2[0] = "SetLocationKeywordData"
    helpMsg_2[1] = "SetItemCharge"
    helpMsg_2[2] = "VCSEquipItem (vcsei)"
    helpMsg_2[3] = "VCSEquipShout (vcsesh)"
    helpMsg_2[4] = "VCSEquipSpell (vcsesp)"
    helpMsg_2[5] = "SetRestrained"
    helpMsg_2[6] = ""
    helpMsg_2[7] = ""
    helpMsg_2[8] = "RemoveAllPerks"
    helpMsg_2[9] = "RemoveAllVisiblePerks"
    helpMsg_2[10] = "RemoveAllSpells"
    helpMsg_2[11] = "RGBToInt"
    helpMsg_2[12] = "GetItemUniqueID"
    helpMsg_2[13] = "SetItemDyeColor"
    helpMsg_2[14] = "ClearItemDyeColor"
    helpMsg_2[15] = "UpdateItemDyeColor"
    helpMsg_2[16] = "RevertOverlays"
    helpMsg_2[17] = "GetObjectUniqueID"
    helpMsg_2[18] = "GetItemDyeColor"
    helpMsg_2[19] = "SetItemTextureLayerColor"
    helpMsg_2[20] = "GetItemTextureLayerColor"
    helpMsg_2[21] = "ClearItemTextureLayerColor"
    helpMsg_2[22] = "SetItemTextureLayerType"
    helpMsg_2[23] = "GetItemTextureLayerType"
    helpMsg_2[24] = "ClearItemTextureLayerType"
    helpMsg_2[25] = "SetItemTextureLayerTexture"
    helpMsg_2[26] = "GetItemTextureLayerTexture"
    helpMsg_2[27] = "ClearItemTextureLayerTexture"
    helpMsg_2[28] = "SetItemTextureLayerBlendMode"
    helpMsg_2[29] = "GetItemTextureLayerBlendMode"
    helpMsg_2[30] = "ClearItemTextureLayerBlendMode"
    helpMsg_2[31] = "UpdateItemTextureLayers"
    helpMsg_2[32] = "AddWeaponOverrideTextureSet"
    helpMsg_2[33] = "ApplyWeaponOverrides"
    helpMsg_2[34] = "AddSkinOverrideTextureSet"
    helpMsg_2[35] = "ApplySkinOverrides"
    helpMsg_2[36] = "RemoveArmorAddonOverride (RemoveAAOverride)"
    helpMsg_2[37] = "StartDraggingObject"
    helpMsg_2[38] = "PrintArgsAsStrings"
    helpMsg_2[39] = "AddPackageOverride"
    helpMsg_2[40] = "RemovePackageOverride"
    helpMsg_2[41] = "CountPackageOverride"
    helpMsg_2[42] = "ClearPackageOverride"
    helpMsg_2[43] = "RemoveAllPackageOverride"
    helpMsg_2[44] = "SetChargeTimeAll"
    helpMsg_2[45] = "SpellFlagHelp"
    helpMsg_2[46] = "GetWorldFieldOfView"
    helpMsg_2[47] = "GetWorldFOV"
    helpMsg_2[48] = "SetWorldFieldOfView"
    helpMsg_2[49] = "SetWorldFOV"
    helpMsg_2[50] = "GetFirstPersonFieldOfView"
    helpMsg_2[51] = "GetFirstPersonFOV"
    helpMsg_2[52] = "SetFirstPersonFieldOfView"
    helpMsg_2[53] = "SetFirstPersonFOV"
    helpMsg_2[54] = "SetClipBoardText"
    helpMsg_2[55] = "SetDescription"
    helpMsg_2[56] = "ResetDescription"
    helpMsg_2[57] = "GetPackageTemplate"
    helpMsg_2[58] = "GetSeasonOverride"
    helpMsg_2[59] = "SetSeasonOverride"
    helpMsg_2[60] = "ClearSeasonOverride"
    helpMsg_2[61] = "MenuHelp"
    helpMsg_2[62] = "CreateUICallback"
    helpMsg_2[63] = "VampireFeed"
    helpMsg_2[64] = "BlockActivation"
    helpMsg_2[65] = "VCSAddPerk (vcsap)"
    helpMsg_2[66] = "VCSRemovePerk (vcsrp)"
    helpMsg_2[67] = "AllowPCDialogue"
    helpMsg_2[68] = "MakePlayerFriend"
    helpMsg_2[69] = "PreventDetection"
    helpMsg_2[70] = "RegenerateHead"
    helpMsg_2[71] = "KillSilent"
    helpMsg_2[72] = "KillEssential"
    helpMsg_2[73] = "PathToReference"
    helpMsg_2[74] = "ClearForcedMovement"
    helpMsg_2[75] = "SetUnconscious"
    helpMsg_2[76] = "GetNthHeadPart"
    helpMsg_2[77] = "SetNthHeadPart"
    helpMsg_2[78] = "SetDoorDestination (SetDestination)"
    helpMsg_2[79] = "Duplicate"
    helpMsg_2[80] = "SetLinkedRef"
    helpMsg_2[81] = "RemAllItems"
    helpMsg_2[82] = "GetFormsWithScriptAttached"
    helpMsg_2[83] = "GetAliasesWithScriptAttached"
    helpMsg_2[84] = "GetRefAliasesWithScriptAttached"
    helpMsg_2[85] = "GetLastMenuOpened"
    helpMsg_2[86] = "CreateFormList"
    helpMsg_2[87] = "CreateKeyword"
    helpMsg_2[88] = "CreateConstructibleObject"
    helpMsg_2[89] = "CreateTextureSet"
    helpMsg_2[90] = "GetAllConstructibleObjects"
    helpMsg_2[91] = "GetActorPlayableSpells (GetPlayableSpells)"
    helpMsg_2[92] = "GetAshPileLinkedRef"
    helpMsg_2[93] = "RemoveAllInventoryEventFilters"
    helpMsg_2[94] = "SetActorOwner"
    helpMsg_2[95] = "SetHarvested"
    helpMsg_2[96] = "SetOpen"
    helpMsg_2[97] = "GetCurrentScene"
    helpMsg_2[98] = "FreezeActor"
    helpMsg_2[99] = "GetMaterialType"
    helpMsg_2[100] = "GetActiveGamebryoAnimation"
    helpMsg_2[101] = "NiOverrideHelp"
    helpMsg_2[102] = "SetHeadpartValidRaces (SetHDPTValidRaces)"
    helpMsg_2[103] = "GetKeywords"
    helpMsg_2[104] = "LearnEnchantment"
    helpMsg_2[105] = "GetAllRefsInGrid"
    helpMsg_2[106] = "GetButtonForDXScanCode"
    helpMsg_2[107] = "CalmActor (Calm)"
    helpMsg_2[108] = "EnableSurvivalFeature"
    helpMsg_2[109] = "DisableSurvivalFeature"
    helpMsg_2[110] = "RestoreColdLevel"
    helpMsg_2[111] = "RestoreHungerLevel"
    helpMsg_2[112] = "RestoreExhaustionLevel"
    helpMsg_2[113] = "StartCannibal"
    helpMsg_2[114] = "GetButtonForDXScanCode"
    helpMsg_2[115] = "CalmActor (Calm)"
    helpMsg_2[116] = "GetQuality"
    helpMsg_2[117] = "SetQuality"
    helpMsg_2[118] = "CastEnchantment"
    helpMsg_2[119] = "CastPotion"
    helpMsg_2[120] = "CastIngredient"
    helpMsg_2[121] = "SetRefAsNoAIAcquire"
    helpMsg_2[122] = "TrainWith"
    helpMsg_2[123] = "QueryStat"
    helpMsg_2[124] = "SetMiscStat"
    helpMsg_2[125] = "HeadpartHelp"
    helpMsg_2[126] = "CollisionHelp"
    helpMsg_2[127] = "FactionFlagHelp"
    
  String[] helpMsg_3 = new String[128]
    helpMsg_3[0] = "GetSkillLegendaryLevel"
    helpMsg_3[1] = "SetSkillLegendaryLevel"
    helpMsg_3[2] = "AVHelp"
    helpMsg_3[3] = "GetSlowTimeMult"
    helpMsg_3[4] = "SetSlowTimeMult"
    helpMsg_3[5] = "ApplyMeleeHit"
    helpMsg_3[6] = "ApplyHit"
    helpMsg_3[7] = "TemperEquipment (Temper)"
    helpMsg_3[8] = "TemperWornEquipment (TemperWorn)"
    helpMsg_3[9] = "MagicEffectHelp"
    helpMsg_3[10] = "GetFootstepSet"
    helpMsg_3[11] = "SetFootstepSet"
    helpMsg_3[12] = "RaceHelp"
    helpMsg_3[13] = "SetRecordFlag"
    helpMsg_3[14] = "ClearRecordFlag"
    helpMsg_3[15] = "IsRecordFlagSet"
    helpMsg_3[16] = "FormRecordHelp"
    helpMsg_3[17] = "SetObjectRefFlag"
    helpMsg_3[18] = "GetRace"
    helpMsg_3[19] = "FormHelp"
    helpMsg_3[20] = "GetActiveQuests"
    helpMsg_3[21] = "PlayDebugShader"
    helpMsg_3[22] = "GetMapMarkerIconType"
    helpMsg_3[23] = "SetMapMarkerIconType"
    helpMsg_3[24] = "GetMapMarkerName"
    helpMsg_3[25] = "SetMapMarkerName"
    helpMsg_3[26] = "GetCellOrWorldSpaceOriginForRef"
    helpMsg_3[27] = "SetCellOrWorldSpaceOriginForRef"
    helpMsg_3[28] = "GetCurrentMapMarkerRefs"
    helpMsg_3[29] = "GetAllMapMarkerRefs"
    helpMsg_3[30] = "GetItemHealthPercent"
    helpMsg_3[31] = "HasNodeOverride"
    helpMsg_3[32] = "AddNodeOverrideFloat"
    helpMsg_3[33] = "AddNodeOverrideInt"
    helpMsg_3[34] = "AddNodeOverrideBool"
    helpMsg_3[35] = "AddNodeOverrideString"
    helpMsg_3[36] = "AddNodeOverrideTextureSet"
    helpMsg_3[37] = "GetNodeOverrideFloat"
    helpMsg_3[38] = "GetNodeOverrideInt"
    helpMsg_3[39] = "GetNodeOverrideBool"
    helpMsg_3[40] = "GetNodeOverrideString"
    helpMsg_3[41] = "GetNodeOverrideTextureSet"
    helpMsg_3[42] = "GetNodePropertyFloat"
    helpMsg_3[43] = "GetNodePropertyInt"
    helpMsg_3[44] = "GetNodePropertyBool"
    helpMsg_3[45] = "GetNodePropertyString"
    helpMsg_3[46] = "ApplyNodeOverrides"
    helpMsg_3[47] = "DrawWeapon"
    helpMsg_3[48] = "SheatheWeapon"
    helpMsg_3[49] = "IdleHelp"
    helpMsg_3[50] = "PlayIdle (PI)"
    helpMsg_3[51] = "PlayIdleWithTarget (PIWT)"
    helpMsg_3[52] = "PlaySubGraphAnimation (PSGA)"
    helpMsg_3[53] = "SetShaderType"
    helpMsg_3[54] = "IsScriptAttachedToForm"
    helpMsg_3[55] = "GetScriptsAttachedToForm"
    helpMsg_3[56] = "RemoveMagicEffectFromSpell (RMGEF)"
    helpMsg_3[57] = "GetSpellType"
    helpMsg_3[58] = "SetSpellCastingType"
    helpMsg_3[59] = "SetSpellDeliveryType"
    helpMsg_3[60] = "SetSpellType"
    helpMsg_3[61] = "SetSpellMagicEffect"
    helpMsg_3[62] = "GetOutfit"
    helpMsg_3[63] = "SetHeight"
    helpMsg_3[64] = "GetHeight"
    helpMsg_3[65] = "GetCurrentMusicType"
    helpMsg_3[66] = "GetNumberOfTracksInMusicType"
    helpMsg_3[67] = "GetMusicTypeTrackIndex"
    helpMsg_3[68] = "SetMusicTypeTrackIndex"
    helpMsg_3[69] = "GetMusicTypePriority"
    helpMsg_3[70] = "SetMusicTypePriority"
    helpMsg_3[71] = "GetMusicTypeStatus"
    helpMsg_3[72] = "DispelEffect"
    helpMsg_3[73] = "BlendColorWithSkinTone"
    helpMsg_3[74] = "GetHeadPartTextureSet"
    helpMsg_3[75] = "GetEquippedArmorInSlot"
    helpMsg_3[76] = "SetHeadpartAlpha"
    helpMsg_3[77] = "SetActorRefraction"
    helpMsg_3[78] = "RevertSkinOverlays"
    helpMsg_3[79] = "RevertHeadOverlays"
    helpMsg_3[80] = "GetEquippedShout"
    helpMsg_3[81] = "GetEquippedShield"
    helpMsg_3[82] = "GetEquippedWeapon"
    helpMsg_3[83] = "GetEquippedSpell"
    helpMsg_3[84] = "GetLastPlayerActivatedRef"
    helpMsg_3[85] = "GetLastPlayerMenuActivatedRef"
    helpMsg_3[86] = "QueueNiNodeUpdate"
    helpMsg_3[87] = "GetActorbaseFaceTextureSet (GetABFaceTextureSet)"
    helpMsg_3[88] = "SetActorbaseFaceTextureSet (SetABFaceTextureSet)"
    helpMsg_3[89] = "GetActorbaseSkin (GetABSkin)"
    helpMsg_3[90] = "SetActorbaseSkin (SetABSkin)"
    helpMsg_3[91] = "GetCastTime"
    helpMsg_3[92] = "GetSpellMagicEffects"
    helpMsg_3[93] = "GetSpellEquipType"
    helpMsg_3[94] = "SetSpellEquipType"
    helpMsg_3[95] = "SetHitEffectArt"
    helpMsg_3[96] = "CombineSpells"
    helpMsg_3[97] = "RemoveFormFromFormlist (RemFromFLST)"
    helpMsg_3[98] = "SetMagicEffectSound (SetMGEFSound)"
    helpMsg_3[99] = "GetMagicEffectSound (GetMGEFSound)"
    helpMsg_3[100] = "CopySpellEquipType"
    helpMsg_3[101] = "GetOutfitNumParts"
    helpMsg_3[102] = "GetOutfitNthPart"
    helpMsg_3[103] = "AddFormToLeveledItem"
    helpMsg_3[104] = "RevertLeveledItem"
    helpMsg_3[105] = "GetLeveledItemChanceNone"
    helpMsg_3[106] = "SetLeveledItemChanceNone"
    helpMsg_3[107] = "GetLeveledItemChanceGlobal"
    helpMsg_3[108] = "SetLeveledItemChanceGlobal"
    helpMsg_3[109] = "GetLeveledItemNumForms"
    helpMsg_3[110] = "GetLeveledItemNthForm"
    helpMsg_3[111] = "GetLeveledItemNthLevel"
    helpMsg_3[112] = "SetLeveledItemNthLevel"
    helpMsg_3[113] = "GetLeveledItemNthCount"
    helpMsg_3[114] = "SetLeveledItemNthCount"
    helpMsg_3[115] = "UnsetOutfit"
    helpMsg_3[116] = "GetSlotMask"
    helpMsg_3[117] = "SetSlotMask"
    helpMsg_3[118] = "AddSlotToMask"
    helpMsg_3[119] = "RemoveSlotFromMask"
    helpMsg_3[120] = "GetMaskForSlot"
    helpMsg_3[121] = "GetArmorModelPath"
    helpMsg_3[122] = "SetArmorModelPath"
    helpMsg_3[123] = "GetArmorIconPath"
    helpMsg_3[124] = "SetArmorIconPath"
    helpMsg_3[125] = "GetArmorMessageIconPath"
    helpMsg_3[126] = "SetArmorMessageIconPath"
    helpMsg_3[127] = "GetArmorWeightClass"
    
  String[] helpMsg_4 = new String[128]
    helpMsg_4[0] = "SetArmorWeightClass"
    helpMsg_4[1] = "SendVampirismStateChanged"
    helpMsg_4[2] = "SendLycanthropyStateChanged"
    helpMsg_4[3] = "StartSneaking"
    helpMsg_4[4] = "SetAttackActorOnSight"
    helpMsg_4[5] = "SetDontMove"
    helpMsg_4[6] = "SlotHelp"
    helpMsg_4[7] = "GetActualWaterLevel"
    helpMsg_4[8] = "GetWaterLevel"
    helpMsg_4[9] = "GetFactionOwner"
    helpMsg_4[10] = "GetActorOwner"
    helpMsg_4[11] = "SetPublic"
    helpMsg_4[12] = "SetFogPower"
    helpMsg_4[13] = "SetFogPlanes"
    helpMsg_4[14] = "SetFogColor"
    helpMsg_4[15] = "GetArtModelPath"
    helpMsg_4[16] = "GetItemMaxCharge"
    helpMsg_4[17] = "SetActorbaseOutfit"
    helpMsg_4[18] = "UnsetActorbaseOutfit"
    helpMsg_4[19] = "PlaceDoor"
    helpMsg_4[20] = "GetWorldModelPath (GetWorldModel)"
    helpMsg_4[21] = "SetWorldModelPath (SetWorldModel)"
    helpMsg_4[22] = "CopyWorldModelPath (CopyWorldModel)"
    helpMsg_4[23] = "GetArmorEnchantment"
    helpMsg_4[24] = "GetWeaponEnchantment"
    helpMsg_4[25] = "GetABNumHeadParts"
    helpMsg_4[26] = "GetABNthHeadPart"
    helpMsg_4[27] = "SetABNthHeadPart"
    helpMsg_4[28] = "GetABIndexOfHeadPartByType"
    helpMsg_4[29] = "GetABNumOverlayHeadParts"
    helpMsg_4[30] = "GetABNthOverlayHeadPart"
    helpMsg_4[31] = "GetABIndexOfOverlayHeadPartByType"
    helpMsg_4[32] = "GetABFaceMorph"
    helpMsg_4[33] = "SetABFaceMorph"
    helpMsg_4[34] = "GetABFacePreset"
    helpMsg_4[35] = "SetABFacePreset"
    helpMsg_4[36] = "GetABSkinFar"
    helpMsg_4[37] = "SetABSkinFar"
    helpMsg_4[38] = "GetABTemplate"
    helpMsg_4[39] = "SetAutoLock"
    helpMsg_4[40] = "RemoveAllArmorReferenceOverrides (RemAllArmorRefOverrides)"
    helpMsg_4[41] = "RemoveAllNodeReferenceOverrides (RemAllNodeRefOverrides)"
    helpMsg_4[42] = "RemoveAllSkinReferenceOverrides (RemAllSkinRefOverrides)"
    helpMsg_4[43] = "RemoveAllWeaponReferenceOverrides (RemAllWeaponRefOverrides)"
    helpMsg_4[44] = "SetNthTexturePath"
    helpMsg_4[45] = "GetNthTexturePath"
    helpMsg_4[46] = "GetTextureSetNumPaths"
    helpMsg_4[47] = "GetMagicEffectLight (GetMGEFLight)"
    helpMsg_4[48] = "SetMagicEffectLight (SetMGEFLight)"
    helpMsg_4[49] = "AddKeyword"
    helpMsg_4[50] = "RemoveKeyword"
    helpMsg_4[51] = "ReplaceKeyword"
    helpMsg_4[52] = "GetTreeIngredient"
    helpMsg_4[53] = "SetTreeIngredient"
    helpMsg_4[54] = "IsKeyPressed"
    helpMsg_4[55] = "GetNumKeysPressed"
    helpMsg_4[56] = "GetNthKeyPressed"
    helpMsg_4[57] = "GetMappedKey"
    helpMsg_4[58] = "GetMappedControl"
    helpMsg_4[59] = "PrecacheCharGenClear"
    helpMsg_4[60] = "UpdateThirdPerson"
    helpMsg_4[61] = "ModObjectiveGlobal"
    helpMsg_4[62] = "GetQuestAliases"
    helpMsg_4[63] = "GetMagicEffectAssociatedSkill (GetMGEFAssociatedSkill)" 
    helpMsg_4[64] = "SetMagicEffectAssociatedSkill (SetMGEFAssociatedSkill)"
    helpMsg_4[65] = "GetMagicEffectResistance (GetMGEFResistance)"
    helpMsg_4[66] = "SetMagicEffectResistance (SetMGEFResistance)"
    helpMsg_4[67] = "GetMagicEffectImpactDataSet (GetMGEFImpactDataSet)"
    helpMsg_4[68] = "SetMagicEffectImpactDataSet (SetMGEFImpactDataSet)"
    helpMsg_4[69] = "GetMagicEffectImageSpaceMod (GetMGEFIMOD)"
    helpMsg_4[70] = "SetMagicEffectImageSpaceMod (SetMGEFIMOD)"
    helpMsg_4[71] = "GetMagicEffectPerk (GetMGEFPerk)"
    helpMsg_4[72] = "SetMagicEffectPerk (SetMGEFPerk)"
    helpMsg_4[73] = "GetMagicEffectEquipAbility (GetMGEFEquipAbility)"
    helpMsg_4[74] = "SetMagicEffectEquipAbility (SetMGEFEquipAbility)"
    helpMsg_4[75] = "SetEffectFlag"
    helpMsg_4[76] = "ClearEffectFlag"
    helpMsg_4[77] = "IsEffectFlagSet"
    helpMsg_4[78] = "GetMagicEffectExplosion"
    helpMsg_4[79] = "SetMagicEffectExplosion"
    helpMsg_4[80] = "GetMagicEffectProjectile"
    helpMsg_4[81] = "SetMagicEffectProjectile"
    helpMsg_4[82] = "GetMagicEffectSkillLevel"
    helpMsg_4[83] = "SetMagicEffectSkillLevel"
    helpMsg_4[84] = "GetMagicEffectBaseCost"
    helpMsg_4[85] = "SetMagicEffectBaseCost"
    helpMsg_4[86] = "GetMagicEffectCastTime"
    helpMsg_4[87] = "SetMagicEffectCastTime"
    helpMsg_4[88] = "GetMagicEffectArea"
    helpMsg_4[89] = "SetMagicEffectArea"
    helpMsg_4[90] = "GetIngredientNthEffectArea"
    helpMsg_4[91] = "SetIngredientNthEffectArea"
    helpMsg_4[92] = "GetIngredientNthEffectMagnitude"
    helpMsg_4[93] = "SetIngredientNthEffectMagnitude"
    helpMsg_4[94] = "GetIngredientNthEffectDuration"
    helpMsg_4[95] = "SetIngredientNthEffectDuration"
    helpMsg_4[96] = "SetRaceFlag"
    helpMsg_4[97] = "ClearRaceFlag"
    helpMsg_4[98] = "IsRaceFlagSet"
    helpMsg_4[99] = "GetRaceSkin"
    helpMsg_4[100] = "SetRaceSkin"
    helpMsg_4[101] = "GetRaceDefaultVoiceType"
    helpMsg_4[102] = "SetRaceDefaultVoiceType"
    helpMsg_4[103] = "GetActorValueInfoByName (GetAVIFByName)"
    helpMsg_4[104] = "GetArmorAddonModelPath (GetAAModelPath)"
    helpMsg_4[105] = "SetArmorAddonModelPath (SetAAModelPath)"
    helpMsg_4[106] = "GetConstructibleObjectResult (GetCOResult)"
    helpMsg_4[107] = "SetConstructibleObjectResult (SetCOResult)"
    helpMsg_4[108] = "GetConstructibleObjectResultQuantity (GetCOResultQuantity)"
    helpMsg_4[109] = "SetConstructibleObjectResultQuantity (SetCOResultQuantity)"
    helpMsg_4[110] = "GetConstructibleObjectNumIngredients (GetCONumIngredients)"
    helpMsg_4[111] = "GetConstructibleObjectNthIngredient (GetCONthIngredient)"
    helpMsg_4[112] = "SetConstructibleObjectNthIngredient (SetCONthIngredient)"
    helpMsg_4[113] = "GetConstructibleObjectNthIngredientQuantity (GetCONthIngredientQuantity)"
    helpMsg_4[114] = "SetConstructibleObjectNthIngredientQuantity (SetCONthIngredientQuantity)"
    helpMsg_4[115] = "GetConstructibleObjectWorkbenchKeyword (GetCOWorkbenchKeyword)"
    helpMsg_4[116] = "SetConstructibleObjectWorkbenchKeyword (SetCOWorkbenchKeyword)"
    helpMsg_4[117] = "GetFloraIngredient"
    helpMsg_4[118] = "SetFloraIngredient"
    helpMsg_4[119] = "GetPotionNthEffectArea"
    helpMsg_4[120] = "SetPotionNthEffectArea"
    helpMsg_4[121] = "GetPotionNthEffectMagnitude"
    helpMsg_4[122] = "SetPotionNthEffectMagnitude"
    helpMsg_4[123] = "GetPotionNthEffectDuration"
    helpMsg_4[124] = "SetPotionNthEffectDuration"
    helpMsg_4[125] = "GetHeadpartValidRaces (GetHDPTValidRaces)"
    helpMsg_4[126] = "GetHeadPartType (GetHDPTType)"
    helpMsg_4[127] = "GetAllHeadParts (GetHDPTs)"
    
  String[] helpMsg_5 = new String[128]
    helpMsg_5[0] = "GetABClass"
    helpMsg_5[1] = "SetABClass"
    helpMsg_5[2] = "GetABSpells"
    helpMsg_5[3] = "GetLocationCleared"
    helpMsg_5[4] = "SetLocationCleared"
    helpMsg_5[5] = "GetLocationParent"
    helpMsg_5[6] = "SetLocationParent"
    helpMsg_5[7] = "ClearCachedFactionFightReactions (CCFFR)"
    helpMsg_5[8] = "GetLocalGravity"
    helpMsg_5[9] = "FindForm (FF)"
    helpMsg_5[10] = "GetAddonModels"
    helpMsg_5[11] = "GetEffectShaderTotalCount"
    helpMsg_5[12] = "IsEffectShaderFlagSet"
    helpMsg_5[13] = "GetMembraneFillTexture"
    helpMsg_5[14] = "GetMembraneHolesTexture"
    helpMsg_5[15] = "GetMembranePaletteTexture"
    helpMsg_5[16] = "GetParticleFullCount"
    helpMsg_5[17] = "GetParticlePaletteTexture"
    helpMsg_5[18] = "GetParticleShaderTexture"
    helpMsg_5[19] = "GetParticlePersistentCount"
    helpMsg_5[20] = "SetAddonModels"
    helpMsg_5[21] = "ClearEffectShaderFlag"
    helpMsg_5[22] = "SetEffectShaderFlag"
    helpMsg_5[23] = "SetMembraneColorKeyData"
    helpMsg_5[24] = "SetMembraneFillTexture"
    helpMsg_5[25] = "SetMembraneHolesTexture"
    helpMsg_5[26] = "SetMembranePaletteTexture"
    helpMsg_5[27] = "SetParticleColorKeyData"
    helpMsg_5[28] = "SetParticlePaletteTexture"
    helpMsg_5[29] = "SetParticlePersistentCount"
    helpMsg_5[30] = "SetParticleShaderTexture"
    helpMsg_5[31] = "KnockAreaEffect"
    helpMsg_5[32] = "ResetReference"
    helpMsg_5[33] = "DeleteReference"
    helpMsg_5[34] = "DisableReference"
    helpMsg_5[35] = "PlayAnimation"
    helpMsg_5[36] = "PlayAnimationAndWait"
    helpMsg_5[37] = "PlayGamebryoAnimation"
    helpMsg_5[38] = "PlayImpactEffect"
    helpMsg_5[39] = "PlaySyncedAnimationSS"
    helpMsg_5[40] = "PlaySyncedAnimationAndWaitSS"
    helpMsg_5[41] = "PushActorAway"
    helpMsg_5[42] = "SetAnimationVariableBool"
    helpMsg_5[43] = "SetAnimationVariableInt"
    helpMsg_5[44] = "SetAnimationVariableFloat"
    helpMsg_5[45] = "ApplyHavokImpulse"
    helpMsg_5[46] = "MoveToNode"
    helpMsg_5[47] = "NodeHelp"
    helpMsg_5[48] = "BodyMorphHelp"
    helpMsg_5[49] = "MorphHelp"
    helpMsg_5[50] = "GetBodyMorph"
    helpMsg_5[51] = "SetBodyMorph"
    helpMsg_5[52] = "GetWornItemID"
    helpMsg_5[53] = "SendTrespassAlarm"
    helpMsg_5[54] = "ClearArrested"
    helpMsg_5[55] = "ClearExpressionOverride"
    helpMsg_5[56] = "ClearExtraArrows"
    helpMsg_5[57] = "ClearKeepOffsetFromActor"
    helpMsg_5[58] = "ClearLookAt"
    helpMsg_5[59] = "ForceMovementSpeed"
    helpMsg_5[60] = "ForceMovementRotationSpeed"
    helpMsg_5[61] = "ForceMovementSpeedRamp"
    helpMsg_5[62] = "ScaleObject3D"
    helpMsg_5[63] = "GetActorbaseDeadCount"
    helpMsg_5[64] = "GetActorbaseSex"
    helpMsg_5[65] = "SetActorbaseInvulnerable"
    helpMsg_5[66] = "GetKeyword"
    helpMsg_5[67] = "GetActorbaseVoiceType (GetABVT)"
    helpMsg_5[68] = "SetActorbaseVoiceType (SetABVT)"
    helpMsg_5[69] = "GetActorbaseCombatStyle (GetABCS)"
    helpMsg_5[70] = "SetActorbaseCombatStyle (SetABCS)"
    helpMsg_5[71] = "GetActorbaseWeight (GetABWeight)"
    helpMsg_5[72] = "SetActorbaseWeight (SetABWeight)"
    helpMsg_5[73] = "GetActorDialogueTarget (GetDialogueTarget)"
    helpMsg_5[74] = "SetCameraTarget"
    helpMsg_5[75] = "GetActorFactions (GetFactions)"
    helpMsg_5[76] = "GetFactionInformation (GetFactInfo)"
    helpMsg_5[77] = "GetMagicEffectAssociatedForm (GetMGEFForm)"
    helpMsg_5[78] = "GetHazardArt"
    helpMsg_5[79] = "GetHazardIMOD"
    helpMsg_5[80] = "GetHazardIMODRadius"
    helpMsg_5[81] = "GetHazardIPDS"
    helpMsg_5[82] = "GetHazardLifetime"
    helpMsg_5[83] = "GetHazardLight"
    helpMsg_5[84] = "GetHazardLimit"
    helpMsg_5[85] = "GetHazardRadius"
    helpMsg_5[86] = "GetHazardSound"
    helpMsg_5[87] = "GetHazardSpell"
    helpMsg_5[88] = "GetHazardTargetInterval"
    helpMsg_5[89] = "IsHazardFlagSet"
    helpMsg_5[90] = "ClearHazardFlag"
    helpMsg_5[91] = "SetHazardArt"
    helpMsg_5[92] = "SetHazardFlag"
    helpMsg_5[93] = "SetHazardIMOD"
    helpMsg_5[94] = "SetHazardIMODRadius"
    helpMsg_5[95] = "SetHazardIPDS"
    helpMsg_5[96] = "SetHazardLifetime"
    helpMsg_5[97] = "SetHazardLight"
    helpMsg_5[98] = "SetHazardLimit"
    helpMsg_5[99] = "SetHazardRadius"
    helpMsg_5[100] = "SetHazardSound"
    helpMsg_5[101] = "SetHazardSpell"
    helpMsg_5[102] = "SetHazardTargetInterval"
    helpMsg_5[103] = "GetLightColor"
    helpMsg_5[104] = "GetLightFade"
    helpMsg_5[105] = "GetLightFOV"
    helpMsg_5[106] = "GetLightRadius"
    helpMsg_5[107] = "GetLightRGB"
    helpMsg_5[108] = "GetLightShadowDepthBias (GetLightSDB)"
    helpMsg_5[109] = "GetLightType"
    helpMsg_5[110] = "SetLightColor"
    helpMsg_5[111] = "SetLightFade"
    helpMsg_5[112] = "SetLightFOV"
    helpMsg_5[113] = "SetLightRadius"
    helpMsg_5[114] = "SetLightRGB"
    helpMsg_5[115] = "SetLightShadowDepthBias (SetLightSDB)"
    helpMsg_5[116] = "SetLightType"
    helpMsg_5[117] = "GetMagicEffectArchetype (GetMGEFArchetype)"
    helpMsg_5[118] = "GetMagicEffectPrimaryActorValue (GetMGEFPrimaryAV)"
    helpMsg_5[119] = "GetMagicEffectySecondaryActorValue (GetMGEFSecondaryAV)"
    helpMsg_5[120] = "SetSubGraphFloatVariable"
    helpMsg_5[121] = "GetWorldModelNthTextureSet"
    helpMsg_5[122] = "SetWorldModelNthTextureSet"
    helpMsg_5[123] = "GetWorldModelTextureSets"
    helpMsg_5[124] = "GetFormInfo (GFI)"
    helpMsg_5[125] = "SendModEvent (SMI)"
    helpMsg_5[126] = "GetReferenceInfo (GRI)"
    helpMsg_5[127] = "LearnIngredientEffect (LearnEffect)"
    
  String[] helpMsg_6 = new String[128]
    helpMsg_6[0] = "SayTopic"
    helpMsg_6[1] = "VCSUnequipItem (UnequipItemEx) (vcsui)"
    helpMsg_6[2] = "SetActorCalmed"
    helpMsg_6[3] = "GetKeycodeString"
    helpMsg_6[4] = "SwapEquipment"
    helpMsg_6[5] = "GetQuestMarker"
    helpMsg_6[6] = "FindAllArmorsForSlot"
    helpMsg_6[7] = "ForceStartScene"
    helpMsg_6[8] = "StartScene"
    helpMsg_6[9] = "StopScene"
    helpMsg_6[10] = "IsScenePlaying"
    helpMsg_6[11] = "GetArmorAddonModelNumTextureSets"
    helpMsg_6[12] = "GetArmorAddonModelNthTextureSet"
    helpMsg_6[13] = "SetArmorAddonModelNthTextureSet"
    helpMsg_6[14] = "GetArmorNumArmorAddons"
    helpMsg_6[15] = "GetArmorNthArmorAddon"
    helpMsg_6[16] = "GetArmorModelArmorAddons"
    helpMsg_6[17] = "GetArmorAddons"
    helpMsg_6[18] = "SetFreeCameraSpeed"
    helpMsg_6[19] = "GetFormsInFormList"
    helpMsg_6[20] = "GetGlobalVariable"
    helpMsg_6[21] = "GetFormMagicEffects"
    helpMsg_6[22] = "GetArmorAddonSlotMask"
    helpMsg_6[23] = "SetArmorAddonSlotMask"
    helpMsg_6[24] = "AddArmorAddonSlotToMask"
    helpMsg_6[25] = "RemoveArmorAddonSlotFromMask"
    helpMsg_6[26] = "GetWeaponModelPath"
    helpMsg_6[27] = "SetWeaponModelPath"
    helpMsg_6[28] = "GetWeaponIconPath"
    helpMsg_6[29] = "SetWeaponIconPath"
    helpMsg_6[30] = "GetWeaponMessageIconPath"
    helpMsg_6[31] = "SetWeaponMessageIconPath"
    helpMsg_6[32] = "GetArmorWarmthRating"
    helpMsg_6[33] = "GetArmorArmorRating"
    helpMsg_6[34] = "SetArmorArmorRating"
    helpMsg_6[35] = "FlattenLeveledList"
    helpMsg_6[36] = "GetRaceSlotMask"
    helpMsg_6[37] = "SetRaceSlotMask"
    helpMsg_6[38] = "AddRaceSlotToMask"
    helpMsg_6[39] = "SetLocalGravity"
    helpMsg_6[40] = "GetColorFormColor (GetCLFMColor)"
    helpMsg_6[41] = "SetColorFormColor (SetCLFMColor)"
    helpMsg_6[42] = "SetActorSex"
    helpMsg_6[43] = "GetVisualEffectArtObject (GetVEARTO)"
    helpMsg_6[44] = "SetVisualEffectArtObject (SetVEARTO)"
    helpMsg_6[45] = "SelectObjectUnderFeet"
    helpMsg_6[46] = "GetTNGBoolValue"
    helpMsg_6[47] = "SetTNGBoolValue"
    helpMsg_6[48] = "GetAllTNGAddonsCount"
    helpMsg_6[49] = "GetAllTNGPossibleAddons"
    helpMsg_6[50] = "GetTNGAddonStatus"
    helpMsg_6[51] = "SetTNGAddonStatus"
    helpMsg_6[52] = "GetTNGRgNames"
    helpMsg_6[53] = "GetTNGRgInfo"
    helpMsg_6[54] = "GetTNGRgAddons"
    helpMsg_6[55] = "GetTNGRgAddon"
    helpMsg_6[56] = "SetTNGRgAddon"
    helpMsg_6[57] = "GetTNGRgMult"
    helpMsg_6[58] = "SetTNGRgMult"
    helpMsg_6[59] = "CanModifyActorTNG"
    helpMsg_6[60] = "GetTNGActorAddons"
    helpMsg_6[61] = "GetTNGActorAddon"
    helpMsg_6[62] = "SetTNGActorAddon"
    helpMsg_6[63] = "GetTNGActorSize"
    helpMsg_6[64] = "SetTNGActorSize"
    helpMsg_6[65] = "TNGActorItemsInfo"
    helpMsg_6[66] = "TNGSwapRevealing"
    helpMsg_6[67] = "CheckTNGActors"
    helpMsg_6[68] = "GetTNGSlot52Mods"
    helpMsg_6[69] = "TNGSlot52ModBehavior"
    helpMsg_6[70] = "UpdateTNGSettings"
    helpMsg_6[71] = "UpdateTNGLogLvl"
    helpMsg_6[72] = "ShowTNGLogLocation"
    helpMsg_6[73] = "GetTNGErrDscr"
    helpMsg_6[74] = "TNGWhyProblem"
    helpMsg_6[75] = "GetCSOffensiveMult"
    helpMsg_6[76] = "GetCSDefensiveMult"
    helpMsg_6[77] = "GetCSGroupOffensiveMult"
    helpMsg_6[78] = "GetCSAvoidThreatChance"
    helpMsg_6[79] = "GetCSMeleeMult"
    helpMsg_6[80] = "GetCSRangedMult"
    helpMsg_6[81] = "GetCSMagicMult"
    helpMsg_6[82] = "GetCSShoutMult"
    helpMsg_6[83] = "GetCSStaffMult"
    helpMsg_6[84] = "GetCSUnarmedMult"
    helpMsg_6[85] = "SetCSOffensiveMult"
    helpMsg_6[86] = "SetCSDefensiveMult"
    helpMsg_6[87] = "SetCSGroupOffensiveMult"
    helpMsg_6[88] = "SetCSAvoidThreatChance"
    helpMsg_6[89] = "SetCSMeleeMult"
    helpMsg_6[90] = "SetCSRangedMult"
    helpMsg_6[91] = "SetCSMagicMult"
    helpMsg_6[92] = "SetCSShoutMult"
    helpMsg_6[93] = "SetCSStaffMult"
    helpMsg_6[94] = "SetCSUnarmedMult"
    helpMsg_6[95] = "GetCSMeleeAttackStaggeredMult"
    helpMsg_6[96] = "GetCSMeleePowerAttackStaggeredMult"
    helpMsg_6[97] = "GetCSMeleePowerAttackBlockingMult"
    helpMsg_6[98] = "GetCSMeleeBashMult"
    helpMsg_6[99] = "GetCSMeleeBashRecoiledMult"
    helpMsg_6[100] = "GetCSMeleeBashAttackMult"
    helpMsg_6[101] = "GetCSMeleeBashPowerAttackMult"
    helpMsg_6[102] = "GetCSMeleeSpecialAttackMult"
    helpMsg_6[103] = "GetCSAllowDualWielding"
    helpMsg_6[104] = "SetCSMeleeAttackStaggeredMult"
    helpMsg_6[105] = "SetCSMeleePowerAttackStaggeredMult"
    helpMsg_6[106] = "SetCSMeleePowerAttackBlockingMult"
    helpMsg_6[107] = "SetCSMeleeBashMult"
    helpMsg_6[108] = "SetCSMeleeBashRecoiledMult"
    helpMsg_6[109] = "SetCSMeleeBashAttackMult"
    helpMsg_6[110] = "SetCSMeleeBashPowerAttackMult"
    helpMsg_6[111] = "SetCSMeleeSpecialAttackMult"
    helpMsg_6[112] = "SetCSAllowDualWielding"
    helpMsg_6[113] = "GetCSCloseRangeDuelingCircleMult"
    helpMsg_6[114] = "GetCSCloseRangeDuelingFallbackMult"
    helpMsg_6[115] = "GetCSCloseRangeFlankingFlankDistance"
    helpMsg_6[116] = "GetCSCloseRangeFlankingStalkTime"
    helpMsg_6[117] = "SetCSCloseRangeDuelingCircleMult"
    helpMsg_6[118] = "SetCSCloseRangeDuelingFallbackMult"
    helpMsg_6[119] = "SetCSCloseRangeFlankingFlankDistance"
    helpMsg_6[120] = "SetCSCloseRangeFlankingStalkTime"
    helpMsg_6[121] = "GetCSLongRangeStrafeMult"
    helpMsg_6[122] = "SetCSLongRangeStrafeMult"
    helpMsg_6[123] = "GetCSFlightHoverChance"
    helpMsg_6[124] = "GetCSFlightDiveBombChance"
    helpMsg_6[125] = "GetCSFlightFlyingAttackChance"
    helpMsg_6[126] = "SetCSFlightHoverChance"
    helpMsg_6[127] = "SetCSFlightDiveBombChance"
  String[] helpMsg_7 = new String[128]
    helpMsg_7[0] = ""
    helpMsg_7[1] = ""
    helpMsg_7[2] = "SetSILNakedSlotMask"
    helpMsg_7[3] = "GetAnimationEventName"
    helpMsg_7[4] = "GetAnimationFileName"
    helpMsg_7[5] = "SetObjectiveText"
    helpMsg_7[6] = "RemoveInvalidConstructibleObjects (RemoveCOs)"
    helpMsg_7[7] = "GetAllOutfitParts"
    helpMsg_7[8] = "GetAllTexturePaths"
    helpMsg_7[9] = "GetAutorunLines"
    helpMsg_7[10] = "AddAutorunLine"
    helpMsg_7[11] = "RemoveAutorunLine"
    helpMsg_7[12] = "AddFormsToFormlist"
    helpMsg_7[13] = "AddFormToFormlists"
    helpMsg_7[14] = "CopyKeywords"
    helpMsg_7[15] = "AddKeywordsToForm"
    helpMsg_7[16] = "RemoveKeywordsFromForm"
    helpMsg_7[17] = "AddKeywordToForms"
    helpMsg_7[18] = "RemoveKeywordFromForms"
    helpMsg_7[19] = "FindEffectOnActor"
    helpMsg_7[20] = "FindKeywordOnForm"
    helpMsg_7[21] = "PlaceBefore"
    helpMsg_7[22] = "GetWornForms"
    helpMsg_7[23] = "RemoveDecals"
    helpMsg_7[24] = ""
    helpMsg_7[25] = "RefreshItemMenu"
    helpMsg_7[26] = "GetArtObjectNthTextureSet"
    helpMsg_7[27] = "SetArtObjectNthTextureSet"
    helpMsg_7[28] = "GetRaceSlotMask"
    helpMsg_7[29] = "SetRaceSlotMask"
    helpMsg_7[30] = "AddRaceSlotToMask"
    helpMsg_7[31] = "RemoveRaceSlotFromMask"
    helpMsg_7[32] = "GetAllArmorsForSlotMask"
    helpMsg_7[33] = "AddAdditionalRaceToArmorAddon"
    helpMsg_7[34] = "RemoveAdditionalRaceFromArmorAddon"
    helpMsg_7[35] = "RaceSlotMaskHasPartOf"
    helpMsg_7[36] = "ArmorSlotMaskHasPartOf"
    helpMsg_7[37] = "ArmorAddonSlotMaskHasPartOf"
    helpMsg_7[38] = "GetArmorAddonRaces"
    helpMsg_7[39] = "ArmorAddonHasRace"
    helpMsg_7[40] = "SetMapMarkerVisible"
    helpMsg_7[41] = "SetCanFastTravelToMarker"
    helpMsg_7[42] = "GetKnownEnchantments"
    helpMsg_7[43] = "Reload"
    helpMsg_7[44] = "GetRaceSlots"
    helpMsg_7[45] = "StartWhiterunAttack"
    helpMsg_7[46] = "OpenCustomSkillMenu"
    helpMsg_7[47] = "ShowCustomTrainingMenu"
    helpMsg_7[48] = "AdvanceCustomSkill (AdvCSkill)"
    helpMsg_7[49] = "IncrementCustomSkill (IncCSkill)"
    helpMsg_7[50] = "GetSkillName"
    helpMsg_7[51] = "GetSkillLevel"
    helpMsg_7[52] = "PacifyActor (Pacify)"
    helpMsg_7[53] = "WhyHostile"
    helpMsg_7[54] = "GetActorRefraction"
    helpMsg_7[55] = "ReplaceArmorTextureSet"
    helpMsg_7[56] = "GetLightingTemplate"
    helpMsg_7[57] = "SetLightingTemplate"
    helpMsg_7[58] = "GetVendorFactionContainer"
    helpMsg_7[59] = "GetRefNodeNames"
    helpMsg_7[60] = "SetExpressionPhoneme"
    helpMsg_7[61] = "SetExpressionModifier"
    helpMsg_7[62] = "ResetExpressionOverrides"
    helpMsg_7[63] = "ShowAsHelpMessage"
    helpMsg_7[64] = "ResetHelpMessage"
    helpMsg_7[65] = ""
    helpMsg_7[66] = ""
    helpMsg_7[67] = ""
    helpMsg_7[68] = ""
    helpMsg_7[69] = ""
    helpMsg_7[70] = ""
    helpMsg_7[71] = ""
    helpMsg_7[72] = ""
    helpMsg_7[73] = ""
    helpMsg_7[74] = ""
    helpMsg_7[75] = ""
    helpMsg_7[76] = ""
    helpMsg_7[77] = ""
    helpMsg_7[78] = ""
    helpMsg_7[79] = ""
    helpMsg_7[80] = ""
    helpMsg_7[81] = ""
    helpMsg_7[82] = ""
    helpMsg_7[83] = ""
    helpMsg_7[84] = ""
    helpMsg_7[85] = ""
    helpMsg_7[86] = ""
    helpMsg_7[87] = ""
    helpMsg_7[88] = ""
    helpMsg_7[89] = ""
    helpMsg_7[90] = ""
    helpMsg_7[91] = ""
    helpMsg_7[92] = ""
    helpMsg_7[93] = ""
    helpMsg_7[94] = ""
    helpMsg_7[95] = ""
    helpMsg_7[96] = ""
    helpMsg_7[97] = ""
    helpMsg_7[98] = ""
    helpMsg_7[99] = ""
    helpMsg_7[100] = ""
    helpMsg_7[101] = ""
    helpMsg_7[102] = ""
    helpMsg_7[103] = ""
    helpMsg_7[104] = ""
    helpMsg_7[105] = ""
    helpMsg_7[106] = ""
    helpMsg_7[107] = ""
    helpMsg_7[108] = ""
    helpMsg_7[109] = ""
    helpMsg_7[110] = ""
    helpMsg_7[111] = ""
    helpMsg_7[112] = ""
    helpMsg_7[113] = ""
    helpMsg_7[114] = ""
    helpMsg_7[115] = ""
    helpMsg_7[116] = ""
    helpMsg_7[117] = ""
    helpMsg_7[118] = ""
    helpMsg_7[119] = ""
    helpMsg_7[120] = ""
    helpMsg_7[121] = ""
    helpMsg_7[122] = ""
    helpMsg_7[123] = ""
    helpMsg_7[124] = ""
    helpMsg_7[125] = ""
    helpMsg_7[126] = ""
    helpMsg_7[127] = ""
  
  String searchTerm = self.StringFromSArgument(sArgument, 1)
  Bool found = false
  Int i = 0

  While i < 128
    If StringUtil.Find(helpMsg[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(helpMsg[i])
      found = true
    EndIf
    If StringUtil.Find(helpMsg_2[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(helpMsg_2[i])
      found = true
    EndIf
    If StringUtil.Find(helpMsg_3[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(helpMsg_3[i])
      found = true
    EndIf
    If StringUtil.Find(helpMsg_4[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(helpMsg_4[i])
      found = true
    EndIf
    If StringUtil.Find(helpMsg_5[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(helpMsg_5[i])
      found = true
    EndIf
    If StringUtil.Find(helpMsg_6[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(helpMsg_6[i])
      found = true
    EndIf
    If StringUtil.Find(helpMsg_7[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(helpMsg_7[i])
      found = true
    EndIf
    i += 1
  Endwhile

  if !found
    PrintMessage("No matching help message found")
  endif
  PrintMessage("======================================================================")

EndEvent

Event OnConsoleFormtypeHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("FormTypeHelp [<string helpString>]")
  
  String[] FormTypeFlags = new String[128]
  String[] FormTypeFlags_2 = new String[127]
  int i

  PrintMessage("FORMTYPES")
  PrintMessage("===========================")

  FormTypeFlags[0] = "FORMTYPES"
  FormTypeFlags[1] = "==========================="
  FormTypeFlags[2] = "kANIO = 83"
  FormTypeFlags[3] = "kARMA = 102"
  FormTypeFlags[4] = "kAcousticSpace = 16"
  FormTypeFlags[5] = "kAction = 6"
  FormTypeFlags[6] = "kActivator = 24"
  FormTypeFlags[7] = "kActorValueInfo = 95"
  FormTypeFlags[8] = "kAddonNode = 94"
  FormTypeFlags[9] = "kAmmo = 42"
  FormTypeFlags[10] = "kApparatus = 33"
  FormTypeFlags[11] = "kArmor = 26"
  FormTypeFlags[12] = "kArrowProjectile = 64"
  FormTypeFlags[13] = "kArt = 125"
  FormTypeFlags[14] = "kAssociationType = 123"
  FormTypeFlags[15] = "kBarrierProjectile = 69"
  FormTypeFlags[16] = "kBeamProjectile = 66"
  FormTypeFlags[17] = "kBodyPartData = 93"
  FormTypeFlags[18] = "kBook = 27"
  FormTypeFlags[19] = "kCameraPath = 97"
  FormTypeFlags[20] = "kCameraShot = 96"
  FormTypeFlags[21] = "kCell = 60"
  FormTypeFlags[22] = "kCharacter = 62"
  FormTypeFlags[23] = "kClass = 10"
  FormTypeFlags[24] = "kClimate = 55"
  FormTypeFlags[25] = "kCollisionLayer = 132"
  FormTypeFlags[26] = "kColorForm = 133"
  FormTypeFlags[27] = "kCombatStyle = 80"
  FormTypeFlags[28] = "kConeProjectile = 68"
  FormTypeFlags[29] = "kConstructibleObject = 49"
  FormTypeFlags[30] = "kContainer = 28"
  FormTypeFlags[31] = "kDLVW = 117"
  FormTypeFlags[32] = "kDebris = 88"
  FormTypeFlags[33] = "kDefaultObject = 107"
  FormTypeFlags[34] = "kDialogueBranch = 115"
  FormTypeFlags[35] = "kDoor = 29"
  FormTypeFlags[36] = "kDualCastData = 129"
  FormTypeFlags[37] = "kEffectSetting = 18"
  FormTypeFlags[38] = "kEffectShader = 85"
  FormTypeFlags[39] = "kEnchantment = 21"
  FormTypeFlags[40] = "kEncounterZone = 103"
  FormTypeFlags[41] = "kEquipSlot = 120"
  FormTypeFlags[42] = "kExplosion = 87"
  FormTypeFlags[43] = "kEyes = 13"
  FormTypeFlags[44] = "kFaction = 11"
  FormTypeFlags[45] = "kFlameProjectile = 67"
  FormTypeFlags[46] = "kFlora = 39"
  FormTypeFlags[47] = "kFootstep = 110"
  FormTypeFlags[48] = "kFootstepSet = 111"
  FormTypeFlags[49] = "kFurniture = 40"
  FormTypeFlags[50] = "kGMST = 3"
  FormTypeFlags[51] = "kGlobal = 9"
  FormTypeFlags[52] = "kGrass = 37"
  FormTypeFlags[53] = "kGrenadeProjectile = 65"
  FormTypeFlags[54] = "kGroup = 2"
  FormTypeFlags[55] = "kHazard = 51"
  FormTypeFlags[56] = "kHeadPart = 12"
  FormTypeFlags[57] = "kIdle = 78"
  FormTypeFlags[58] = "kIdleMarker = 47"
  FormTypeFlags[59] = "kImageSpace = 89"
  FormTypeFlags[60] = "kImageSpaceModifier = 90"
  FormTypeFlags[61] = "kImpactData = 100"
  FormTypeFlags[62] = "kProjectile = 101"
  FormTypeFlags[63] = "kIngredient = 30"
  FormTypeFlags[64] = "kKey = 45"
  FormTypeFlags[65] = "kKeyword = 4"
  FormTypeFlags[66] = "kLand = 72"
  FormTypeFlags[67] = "kLandTexture = 20"
  FormTypeFlags[68] = "kLeveledCharacter = 44"
  FormTypeFlags[69] = "kLeveledItem = 53"
  FormTypeFlags[70] = "kLeveledSpell = 82"
  FormTypeFlags[71] = "kLight = 31"
  FormTypeFlags[72] = "kLightingTemplate = 108"
  FormTypeFlags[73] = "kList = 91"
  FormTypeFlags[74] = "kLoadScreen = 81"
  FormTypeFlags[75] = "kLocation = 104"
  FormTypeFlags[76] = "kLocationRef = 5"
  FormTypeFlags[77] = "kMaterial = 126"
  FormTypeFlags[78] = "kMaterialType = 99"
  FormTypeFlags[79] = "kMenuIcon = 8"
  FormTypeFlags[80] = "kMessage = 105"
  FormTypeFlags[81] = "kMisc = 32"
  FormTypeFlags[82] = "kMissileProjectile = 63"
  FormTypeFlags[83] = "kMovableStatic = 36"
  FormTypeFlags[84] = "kMovementType = 127"
  FormTypeFlags[85] = "kMusicTrack = 116"
  FormTypeFlags[86] = "kMusicType = 109"
  FormTypeFlags[87] = "kNAVI = 59"
  FormTypeFlags[88] = "kNPC = 43"
  FormTypeFlags[89] = "kNavMesh = 73"
  FormTypeFlags[90] = "kNone = 0"
  FormTypeFlags[91] = "kNote = 48"
  FormTypeFlags[92] = "kOutfit = 124"
  FormTypeFlags[93] = "kPHZD = 70"
  FormTypeFlags[94] = "kPackage = 79"
  FormTypeFlags[95] = "kPerk = 92"
  FormTypeFlags[96] = "kPotion = 46"
  FormTypeFlags[97] = "kProjectile = 50"
  FormTypeFlags[98] = "kQuest = 77"
  FormTypeFlags[99] = "kRace = 14"
  FormTypeFlags[100] = "kRagdoll = 106"
  FormTypeFlags[101] = "kReference = 61"
  FormTypeFlags[102] = "kReferenceEffect = 57"
  FormTypeFlags[103] = "kRegion = 58"
  FormTypeFlags[104] = "kRelationship = 121"
  FormTypeFlags[105] = "kReverbParam = 134"
  FormTypeFlags[106] = "kScene = 122"
  FormTypeFlags[107] = "kScript = 19"
  FormTypeFlags[108] = "kScrollItem = 23"
  FormTypeFlags[109] = "kShaderParticleGeometryData = 56"
  FormTypeFlags[110] = "kShout = 119"
  FormTypeFlags[111] = "kSkill = 17"
  FormTypeFlags[112] = "kSoulGem = 52"
  FormTypeFlags[113] = "kSound = 15"
  FormTypeFlags[114] = "kSoundCategory = 130"
  FormTypeFlags[115] = "kSoundDescriptor = 128"
  FormTypeFlags[116] = "kSoundOutput = 131"
  FormTypeFlags[117] = "kSpell = 22"
  FormTypeFlags[118] = "kStatic = 34"
  FormTypeFlags[119] = "kStaticCollection = 35"
  FormTypeFlags[120] = "kStoryBranchNode = 112"
  FormTypeFlags[121] = "kStoryEventNode = 114"
  FormTypeFlags[122] = "kStoryQuestNode = 113"
  FormTypeFlags[123] = "kTES4 = 1"
  FormTypeFlags[124] = "kTLOD = 74"
  FormTypeFlags[125] = "kTOFT = 86"
  FormTypeFlags[126] = "kTalkingActivator = 25"
  FormTypeFlags[127] = "kTextureSet = 7"

  ; FormTypeFlags_2
  FormTypeFlags_2[0] = "kTopic = 75"
  FormTypeFlags_2[1] = "kTopicInfo = 76"
  FormTypeFlags_2[2] = "kTree = 38"
  FormTypeFlags_2[3] = "kVoiceType = 98"
  FormTypeFlags_2[4] = "kWater = 84"
  FormTypeFlags_2[5] = "kWeapon = 41"
  FormTypeFlags_2[6] = "kWeather = 54"
  FormTypeFlags_2[7] = "kWordOfPower = 118"
  FormTypeFlags_2[8] = "kWorldSpace = 71"
  
  i = 0
  while i < 128
      if (StringUtil.Find(FormTypeFlags[i], StringFromSArgument(sArgument, 1))) || (StringUtil.Find(sArgument, " ") == -1)
          PrintMessage(FormTypeFlags[i])
      endif
      if (StringUtil.Find(FormTypeFlags_2[i], StringFromSArgument(sArgument, 1))) || (StringUtil.Find(sArgument, " ") == -1)
          PrintMessage(FormTypeFlags_2[i])
      endif
      i += 1
  endWhile

EndEvent

Event OnConsoleReplaceArmorTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ReplaceArmorTextureSet(Actor akActor, Armor akArmor, TextureSet akSourceTXST, TextureSet akTargetTXST, int aiTextureType = -1") 
  PrintMessage("TEXTURE TYPE HELP")
  PrintMessage("============================================")
  PrintMessage("-1  All of the below")
  PrintMessage("0   Diffuse (Base color texture)")
  PrintMessage("1   Normal (Normal map for facial details)")
  PrintMessage("2   Mask (Specular/glossiness map)")
  PrintMessage("3   Tint (Tint mask for skin tone blending)")
  PrintMessage("============================================")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  int index

  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If akActor as Actor
    index = 0
  Else
    index = 1
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, index + 1) as Armor
  TextureSet akSourceTXST = self.FormFromSArgument(sArgument, index + 2) as TextureSet
  TextureSet akTargetTXST = self.FormFromSArgument(sArgument, index + 3) as TextureSet
  int aiTextureType = self.IntFromSArgument(sArgument, index + 4)
  
  If akActor == none || akArmor == none || akSourceTXST == none || akTargetTXST == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.ReplaceArmorTextureSet(akActor, akArmor, akSourceTXST, akTargetTXST, aiTextureType)
  PrintMessage("Replaced " + self.GetFullID(akArmor) + " texture set of " + self.GetFullID(akActor) + " from " + self.GetFullID(akSourceTXST) + " to " + self.GetFullID(akTargetTXST))
EndEvent

Event OnConsoleReplaceFaceTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ReplaceFaceTextureSet([Actor akActor = GetSelectedReference()], TextureSet akMaleTXST, TextureSet akFemaleTXST, int aiTextureType = -1)") 
  PrintMessage("TEXTURE TYPE HELP")
  PrintMessage("============================================")
  PrintMessage("-1  All of the below")
  PrintMessage("0   Diffuse (Base color texture)")
  PrintMessage("1   Normal (Normal map for facial details)")
  PrintMessage("2   Mask (Specular/glossiness map)")
  PrintMessage("3   Tint (Tint mask for skin tone blending)")
  PrintMessage("============================================")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  int index

  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If akActor as Actor
    index = 0
  Else
    akActor = self.FormFromSArgument(sArgument, 1) as Actor
    index = 1
  EndIf
  TextureSet akMaleTXST = self.FormFromSArgument(sArgument, index + 1) as TextureSet
  TextureSet akFemaleTXST = self.FormFromSArgument(sArgument, index + 2) as TextureSet
  int aiTextureType = self.IntFromSArgument(sArgument, index + 3)
  
  If akActor == none || akMaleTXST == none || akFemaleTXST == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.ReplaceFaceTextureSet(akActor, akMaleTXST, akFemaleTXST, aiTextureType)
  PrintMessage("Replaced face texture set of " + self.GetFullID(akActor) + " with " + self.GetFullID(akMaleTXST) + " and " + self.GetFullID(akFemaleTXST))
EndEvent

Event OnConsoleReplaceSkinTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ReplaceSkinTextureSet(Actor akActor, TextureSet akMaleTXST, TextureSet akFemaleTXST, int aiSlotMask, int aiTextureType = -1)")
  PrintMessage("TEXTURE TYPE HELP")
  PrintMessage("============================================")
  PrintMessage("-1  All of the below")
  PrintMessage("0   Diffuse (Base color texture)")
  PrintMessage("1   Normal (Normal map for facial details)")
  PrintMessage("2   Mask (Specular/glossiness map)")
  PrintMessage("3   Tint (Tint mask for skin tone blending)")
  PrintMessage("============================================")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  int index

  
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If akActor as Actor
    index = 0
  Else
    akActor = self.FormFromSArgument(sArgument, 1) as Actor
    index = 1
  EndIf
  TextureSet akMaleTXST = self.FormFromSArgument(sArgument, index + 1) as TextureSet
  TextureSet akFemaleTXST = self.FormFromSArgument(sArgument,index + 2) as TextureSet
  int aiSlotMask = self.IntFromSArgument(sArgument, index + 3)
  int aiTextureType = self.IntFromSArgument(sArgument, index + 4)

  If akActor == none || akMaleTXST == none || akFemaleTXST == none
    
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.ReplaceSkinTextureSet(akActor, akMaleTXST, akFemaleTXST, aiSlotMask, aiTextureType)
  PrintMessage("Replaced skin texture set of " + self.GetFullID(akActor) + " with " + self.GetFullID(akMaleTXST) + " and " + self.GetFullID(akFemaleTXST))

EndEvent

Event OnConsoleGetHairColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorHairColor(Actor akActor)")

  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor

  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  ColorForm akColor  = PO3_SKSEFunctions.GetHairColor(akActor)
  
  PrintMessage("Hair color of " + self.GetFullID(akActor) + " is " + self.GetFullID(akColor))
EndEvent

Event OnConsoleSetHairColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorHairColor(Actor akActor, [ColorForm akColorForm OR int colorR, int colorG, int colorB])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  int index
  If akActor as Actor
    index = 0
  Else
    akActor = self.FormFromSArgument(sArgument, 1) as Actor
    index = 1
  EndIf
  ColorForm akColor = self.FormFromSArgument(sArgument, index + 1) as ColorForm
  If akColor == none
    int colorR = self.IntFromSArgument(sArgument, index + 1)
    int colorG = self.IntFromSArgument(sArgument, index + 2)
    int colorB = self.IntFromSArgument(sArgument, index + 3)
    akColor = DbSKSEFunctions.CreateColorForm(DbColorFunctions.RGBToInt(colorR, colorG, colorB))
  EndIf

  If ProteusDLLUtils.IsDLLLoaded()
    ProteusDLLUtils.ProteusSetHairColor(akActor, akColor)
  Else
    PO3_SKSEFunctions.SetHairColor(akActor, akColor)
  EndIf
  PrintMessage("Set hair color of " + self.GetFullID(akActor) + " as " + self.GetFullID(akColor))
EndEvent

Event OnConsoleGetHeadPartTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHeadPartTextureSet(Actor akActor, int aiType)")
  PrintMessage("TYPE HELP")
  PrintMessage("==========")
  PrintMessage("0	Mouth")
  PrintMessage("1	Head")
  PrintMessage("2	Eyes")
  PrintMessage("3	Hair")
  PrintMessage("4	Beard")
  PrintMessage("5	Scar")
  PrintMessage("6	Brows")
  PrintMessage("==========")
  If self.StringFromSArgument(sArgument, 1) == "?"

    Return
  EndIf
  
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  int aiType = self.IntFromSArgument(sArgument, 1)

  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 

  TextureSet headpartTXST = PO3_SKSEFunctions.GetHeadPartTextureSet(akActor, aiType)
  PrintMessage("Head part texture set #" + aiType + " of " + self.GetFullID(akActor) + " is " + self.GetFullID(headpartTXST))
EndEvent

Event OnConsoleSetHeadPartTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHeadPartTextureSet(Actor akActor, TextureSet headpartTXST, int aiType)")
  PrintMessage("TYPE HELP")
  PrintMessage("==========")
  PrintMessage("0	Mouth")
  PrintMessage("1	Head")
  PrintMessage("2	Eyes")
  PrintMessage("3	Hair")
  PrintMessage("4	Beard")
  PrintMessage("5	Scar")
  PrintMessage("6	Brows")
  PrintMessage("==========")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  TextureSet headpartTXST = self.FormFromSArgument(sArgument, 1) as TextureSet
  int aiType = self.IntFromSArgument(sArgument, 2)

  If akActor == none || headpartTXST == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 

  PO3_SKSEFunctions.SetHeadPartTextureSet(akActor, headpartTXST, aiType)
  PrintMessage("Set head part texture set of " + self.GetFullID(akActor) + " as " + self.GetFullID(headpartTXST))
EndEvent

Event OnConsoleGetSkinColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSkinColor(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  ColorForm akColor = PO3_SKSEFunctions.GetSkinColor(akActor)

  PrintMessage("Skin color of " + self.GetFullID(akActor) + " is " + self.GetFullID(akColor))
EndEvent

Event OnConsoleSetSkinColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSkinColor(Actor akActor, [ColorForm akColorForm OR int colorR, int colorG, int colorB])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  int index
  If akActor as Actor
    index = 0
  Else
    akActor = self.FormFromSArgument(sArgument, 1) as Actor
    index = 1
  EndIf
  ColorForm akColor = self.FormFromSArgument(sArgument, index + 1) as ColorForm
  If akColor == none
    int colorR = self.IntFromSArgument(sArgument, 1)
    int colorG = self.IntFromSArgument(sArgument, 2)
    int colorB = self.IntFromSArgument(sArgument, 3)
    akColor = DbSKSEFunctions.CreateColorForm(DbColorFunctions.RGBToInt(colorR, colorG, colorB))
  EndIf
  
  If akActor == none || akColor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetSkinColor(akActor, akColor)
  PrintMessage("Set skin color of " + self.GetFullID(akActor) + " as " + self.GetFullID(akColor))
EndEvent

Event OnConsoleSetSkinAlpha(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSkinAlpha(Actor akActor, float afAlpha")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  float afAlpha = self.FloatFromSArgument(sArgument, 1)

  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetSkinAlpha(akActor, afAlpha)
  PrintMessage("Set skin alpha of " + self.GetFullID(akActor) + " as " + afAlpha)
EndEvent

Event OnConsoleSetKey(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetKey(ObjectReference akRef, Key akKey)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  Key akKey
  
  If QtyPars == 1
    akRef = ConsoleUtil.GetSelectedReference()
    akKey = self.FormFromSArgument(sArgument, 1) as Key
  ElseIf QtyPars == 2
    akRef = self.RefFromSArgument(sArgument, 1)
    akKey = self.FormFromSArgument(sArgument, 2) as Key
  EndIf

  If akRef == none || akKey == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetKey(akRef, akKey)
  PrintMessage("Set key of " + self.GetFullID(akRef) + " as " + self.GetFullID(akKey))
EndEvent

Event OnConsoleMarkItemAsFavorite(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: MarkItemAsFavorite(Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Form akForm = self.FormFromSArgument(sArgument, 1)

  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.MarkItemAsFavorite(akForm)
  PrintMessage("Marked item " + self.GetFullID(akForm) + " as favorite")
EndEvent

Event OnConsoleUnmarkItemAsFavorite(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: UnmarkItemAsFavorite(Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Form akForm = self.FormFromSArgument(sArgument, 1)

  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.UnmarkItemAsFavorite(akForm)
  PrintMessage("Unmarked item " + self.GetFullID(akForm) + " as favorite")
EndEvent

Event OnConsoleSetSoundDescriptor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSoundDescriptor(Sound akSound, SoundDescriptor akSoundDescriptor)")

  Sound akSound = self.FormFromSArgument(sArgument, 1) as Sound
  SoundDescriptor akSoundDescriptor = self.FormFromSArgument(sArgument, 2) as SoundDescriptor

  If akSound == none || akSoundDescriptor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetSoundDescriptor(akSound, akSoundDescriptor)
  PrintMessage("Set sound descriptor of sound " + self.GetFullID(akSound) + " as " + self.GetFullID(akSoundDescriptor))
EndEvent

Event OnConsoleCreateSoundMarker(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CreateSoundMarker()")

  Sound akSound = DbSKSEFunctions.CreateSoundMarker()

  If akSound == none
    PrintMessage("Failed to create sound marker")
    Return
  EndIf

  PrintMessage("Created sound marker with form ID " + self.GetFullID(akSound))
EndEvent


ActiveMagicEffect Function GetFirstActiveMagicEffectOfType(ObjectReference akRef, MagicEffect akMagicEffect)
  If PO3_SKSEFunctions.HasActiveMagicEffect(akRef as Actor, akMagicEffect)
    Return none
  EndIf
  
  ActiveMagicEffect[] ActiveEffects = PO3_SKSEFunctions.GetActiveMagicEffects(akRef, akMagicEffect)
  ; Return ActiveEffects.Find(akMagicEffect)
  int i = 0
  int L = ActiveEffects.Length
  If L > 0
    PrintMessage("Found " + L + " active magic effects")
  Else
    PrintMessage("No active magic effects found")
    Return none
  EndIf
  While i < L
    If ActiveEffects[i].GetBaseObject() == akMagicEffect
      Return ActiveEffects[i]
    EndIf
    i += 1
  EndWhile
EndFunction


Event OnConsolePlaySound(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlaySound(Sound akSound, [ObjectReference akSource = GetSeelectedReference()], float volume = 1.0, Form eventReceiverForm = none, Quest questForAlias, Alias eventReceiverAlias = none, MagicEffect eventReceiverActiveEffect = none)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("!! akSource is the selected reference")

  Sound akSound = self.FormFromSArgument(sArgument, 1) as Sound
  ObjectReference akSource = ConsoleUtil.GetSelectedReference()
  float volume = self.FloatFromSArgument(sArgument, 2, 1.0)
  Form eventReceiverForm = self.FormFromSArgument(sArgument, 3) as Form
  Quest questForAlias = self.FormFromSArgument(sArgument, 4) as Quest
  Alias eventReceiverAlias = questForAlias.GetAliasByName(StringFromSArgument(sArgument, 5))
  MagicEffect eventReceiverEffect = self.FormFromSArgument(sArgument, 6) as MagicEffect
  ActiveMagicEffect eventReceiverActiveEffect = ANDR_PapyrusFunctions.GetActiveMagicEffectFromActor(akSource as Actor, eventReceiverEffect)

  ; If volume == none
  ;   volume = 1.0
  ; EndIf

  If akSound == none || akSource == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  DbSKSEFunctions.PlaySound(akSound, akSource, volume, eventReceiverForm, eventReceiverAlias, eventReceiverActiveEffect)
  PrintMessage("Played sound " + self.GetFullID(akSound) + " from " + self.GetFullID(akSource))
EndEvent

Event OnConsolePlaySoundDescriptor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlaySoundDescriptor(SoundDescriptor akSoundDescriptor, [ObjectReference akSource], float volume = 1.0, Form eventReceiverForm = none, Alias eventReceiverAlias = none, activeMagicEffect eventReceiverActiveEffect = none)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("!! akSource is the selected reference")

  SoundDescriptor akSoundDescriptor
  ObjectReference akSource
  float volume
  Form eventReceiverForm
  Quest questForAlias
  Alias eventReceiverAlias
  MagicEffect eventReceiverEffect
  ActiveMagicEffect eventReceiverActiveEffect

  If QtyPars == 5
    akSoundDescriptor = self.FormFromSArgument(sArgument, 1) as SoundDescriptor
    akSource = ConsoleUtil.GetSelectedReference()
    volume = self.FloatFromSArgument(sArgument, 2)
    eventReceiverForm = self.FormFromSArgument(sArgument, 3) as Form
    questForAlias = self.FormFromSArgument(sArgument, 4) as Quest
    eventReceiverAlias = questForAlias.GetAliasByName(StringFromSArgument(sArgument, 5))
    eventReceiverEffect = self.FormFromSArgument(sArgument, 6) as MagicEffect
  ElseIf QtyPars == 6
    akSoundDescriptor = self.FormFromSArgument(sArgument, 1) as SoundDescriptor
    akSource = self.RefFromSArgument(sArgument, 2)
    volume = self.FloatFromSArgument(sArgument, 3)
    eventReceiverForm = self.FormFromSArgument(sArgument, 4) as Form
    questForAlias = self.FormFromSArgument(sArgument, 5) as Quest
    eventReceiverAlias = questForAlias.GetAliasByName(StringFromSArgument(sArgument, 6))
    eventReceiverEffect = self.FormFromSArgument(sArgument, 7) as MagicEffect
  EndIf

  eventReceiverActiveEffect = GetFirstActiveMagicEffectOfType(akSource, eventReceiverEffect)

  If akSoundDescriptor == none || akSource == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  DbSKSEFunctions.PlaySoundDescriptor(akSoundDescriptor, akSource, volume, eventReceiverForm, eventReceiverAlias, eventReceiverActiveEffect)
  PrintMessage("Played sound descriptor " + self.GetFullID(akSoundDescriptor) + " from " + self.GetFullID(akSource))
EndEvent

Event OnConsoleClearMagicEffects(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearMagicEffects(Form item)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Form item = self.FormFromSArgument(sArgument, 1)

  If item == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
      
  DynamicPersistentForms.ClearMagicEffects(item)
  
  PrintMessage("Cleared magic effects from " + self.GetFullID(item))
EndEvent

Event OnConsoleCopyMagicEffects(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CopyMagicEffectsForm akSource, Form akTarget, bool abPermanent = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Form akSource = self.FormFromSArgument(sArgument, 1)
  Form akTarget = self.FormFromSArgument(sArgument, 2)
  bool abPermanent = self.BoolFromSArgument(sArgument, 3, true)

  If akSource == none || akTarget == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If abPermanent
    DynamicPersistentForms.Track(akTarget)
  EndIf

  DynamicPersistentForms.CopyMagicEffects(akSource, akTarget)
  
  PrintMessage("Copied magic effects from " + self.GetFullID(akSource) + " to " + self.GetFullID(akTarget))
EndEvent

Event OnConsoleCopyAppearance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CopyAppearance(Form akSource, Form akTarget, bool abPermanent = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Form akSource = self.FormFromSArgument(sArgument, 1)
  Form akTarget = self.FormFromSArgument(sArgument, 2)
  bool abPermanent = self.BoolFromSArgument(sArgument, 3, true)

  If akSource == none || akTarget == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  DynamicPersistentForms.CopyAppearance(akSource, akTarget)

  If abPermanent
    DynamicPersistentForms.Track(akTarget)
  EndIf
  
  PrintMessage("Copied appearance from " + self.GetFullID(akSource) + " to " + self.GetFullID(akTarget))
EndEvent

Event OnConsoleSetSpellTomeSpell(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellTomeSpell(Book target, Spell teaches)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Book target = self.FormFromSArgument(sArgument, 1) as Book
  Spell teaches = self.FormFromSArgument(sArgument, 2) as Spell

  If target == none || teaches == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  DynamicPersistentForms.SetSpellTomeSpell(target, teaches)
  PrintMessage("Set " + self.GetFullID(target) + " to teach " + self.GetFullID(teaches))
EndEvent

Event OnConsoleSetSpellAutoCalculate(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellAutoCalculate(Spell spell, bool value = true)")

  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  bool value = self.BoolFromSArgument(sArgument, 2, true)

  If akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  DynamicPersistentForms.SetSpellAutoCalculate(akSpell, value)
  
  PrintMessage("Set " + self.GetFullID(akSpell) + " with autocalculate " + value)
EndEvent

Event OnConsoleSetSpellCostOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellCostOverride(Spell spell, int value)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  int value = self.IntFromSArgument(sArgument, 2)

  If akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  DynamicPersistentForms.SetSpellCostOverride(akSpell, value)
  
  PrintMessage("Set " + self.GetFullID(akSpell) + " with cost " + value)
EndEvent

Event OnConsoleSetSpellChargeTime(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellChargeTime(Spell spell, float value)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  float value = self.FloatFromSArgument(sArgument, 2)

  If akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  DynamicPersistentForms.SetSpellChargeTime(akSpell, value)
  
  PrintMessage("Set " + self.GetFullID(akSpell) + " with charge time " + value)
EndEvent

Event OnConsoleSetSpellCastDuration(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellCastDuration(Spell spell, int value)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  int value = self.IntFromSArgument(sArgument, 2)

  If akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  DynamicPersistentForms.SetSpellCastDuration(akSpell, value)
  
  PrintMessage("Set " + self.GetFullID(akSpell) + " with duration " + value)
EndEvent

Event OnConsoleSetSpellRange(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellRange(Spell spell, int value)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  int value = self.IntFromSArgument(sArgument, 2)
  If akSpell == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  DynamicPersistentForms.SetSpellRange(akSpell, value)
  
  PrintMessage("Set " + self.GetFullID(akSpell) + " with range " + value)
EndEvent

Event OnConsoleSetSpellCastingPerk(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellCastingPerk(Spell spell, Perk value)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  Perk value = self.FormFromSArgument(sArgument, 2) as Perk
  If akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  DynamicPersistentForms.SetSpellCastingPerk(akSpell, value)
  
  PrintMessage("Set " + self.GetFullID(akSpell) + " with casting perk " + self.GetFullID(value))
EndEvent

Event OnConsoleCreateColorForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CreateColorForm(int colorR, int colorG, int colorB)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  int colorR = self.IntFromSArgument(sArgument, 1)
  int colorG = self.IntFromSArgument(sArgument, 2)
  int colorB = self.IntFromSArgument(sArgument, 3)
  ColorForm result = DbSKSEFunctions.CreateColorForm(DbColorFunctions.RGBToInt(colorR, colorG, colorB))
  
  PrintMessage("Created ColorForm " + self.GetFullID(result))
EndEvent

Event OnConsoleTeleport(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: Teleport([Cell akDestination | ObjectReference akTarget | Quest akQuestToTarget])")

  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Form akForm  = self.FormFromSArgument(sArgument, 1)

  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PapyrusTweaks.DisableFastMode()
  
  Actor[] Passengers = PO3_SKSEFunctions.GetPlayerFollowers()
  int i = 0
  int L = Passengers.Length
  ImageSpaceModifier FadeToBlackImod = Game.GetFormEx(0xf756d) as ImageSpaceModifier
  ImageSpaceModifier FadeToBlackHoldImod = Game.GetFormEx(0xf756d) as ImageSpaceModifier
  
  If akForm as ObjectReference
    ObjectReference akTarget = akForm as ObjectReference
    While i < L
      If Passengers[i].GetDistance(PlayerREF) < 1024
        PlayTeleportEffect(Passengers[i], "out")
      EndIf
      i += 1
    EndWhile
    PlayTeleportEffect(PlayerREF, "out")

    Utility.Wait(2.5)
    FadeToBlackImod.PopTo(FadeToBlackHoldImod)
    PlayerRef.MoveTo(akTarget)
    Utility.Wait(1.0)
   
    FadeToBlackHoldImod.Remove()
    
    PlayTeleportEffect(PlayerREF, "in")
    
    While i < L
      Passengers[i].MoveTo(PlayerRef)
      PlayTeleportEffect(Passengers[i], "in")
      i += 1
    EndWhile

    Utility.Wait(1.0)
  ElseIf akForm as Cell
    
    While i < L
      If Passengers[i].GetDistance(PlayerREF) < 1024
        PlayTeleportEffect(Passengers[i], "out")
      EndIf
      i += 1
    EndWhile
    PlayTeleportEffect(PlayerREF, "out")
  
    Utility.Wait(2.5)
    FadeToBlackImod.PopTo(FadeToBlackHoldImod)
    Debug.CenterOnCellAndWait(PO3_SKSEFunctions.GetFormEditorID(akForm))
    Utility.Wait(1.0)
    
    FadeToBlackHoldImod.Remove()
    
    PlayTeleportEffect(PlayerREF, "in")
    
    While i < L
      Passengers[i].MoveTo(PlayerRef)
      PlayTeleportEffect(Passengers[i], "in")
      i += 1
    EndWhile

    Utility.Wait(1.0)
  ElseIf akForm as Quest

    While i < L
      If Passengers[i].GetDistance(PlayerREF) < 1024
        PlayTeleportEffect(Passengers[i], "out")
      EndIf
      i += 1
    EndWhile
    PlayTeleportEffect(PlayerREF, "out")
    
    Utility.Wait(2.5)
    FadeToBlackImod.PopTo(FadeToBlackHoldImod)
    PrintMessage("movetoqt " + PO3_SKSEFunctions.GetFormEditorID(akForm))
    ConsoleUtil.ExecuteCommand("movetoqt " + PO3_SKSEFunctions.GetFormEditorID(akForm))
    Utility.Wait(1.0)
    
    FadeToBlackHoldImod.Remove()
    
    PlayTeleportEffect(PlayerREF, "in")
    
    While i < L
      Passengers[i].MoveTo(PlayerRef)
      PlayTeleportEffect(Passengers[i], "in")
      i += 1
    EndWhile

    Utility.Wait(1.0)
  EndIf

  PrintMessage("Teleported to " + self.GetFullID(akForm))
EndEvent


Function PlayTeleportEffect(Actor akTarget, string akDirection)
  If !TP1_TeleportInApplier
    TP1_TeleportInApplier = PO3_SKSEFunctions.GetFormFromEditorID("TP1_TeleportInApplier") as Spell
    TP1_TeleportOutApplier = PO3_SKSEFunctions.GetFormFromEditorID("TP1_TeleportOutApplier") as Spell
  EndIf
  If akDirection == "in"
    TP1_TeleportInApplier.Cast(akTarget, akTarget)
  ElseIf akDirection == "out"
    TP1_TeleportOutApplier.Cast(akTarget, akTarget)
  EndIf
EndFunction


Event OnConsolePause(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SoundPause(SoundCategory akSoundCategory)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  SoundCategory akSoundCategory = self.FormFromSArgument(sArgument, 1) as SoundCategory
  If akSoundCategory == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akSoundCategory.Pause()
  PrintMessage("Paused " + self.GetFullID(akSoundCategory))
EndEvent

Event OnConsoleUnpause(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SoundUnpause(SoundCategory akSoundCategory)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  SoundCategory akSoundCategory = self.FormFromSArgument(sArgument, 1) as SoundCategory
  If akSoundCategory == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akSoundCategory.Unpause()
  PrintMessage("Unpaused " + self.GetFullID(akSoundCategory))
EndEvent

Event OnConsoleMute(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SoundMute(SoundCategory akSoundCategory)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  SoundCategory akSoundCategory = self.FormFromSArgument(sArgument, 1) as SoundCategory
  If akSoundCategory == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akSoundCategory.Mute()
  PrintMessage("Muted " + self.GetFullID(akSoundCategory))
EndEvent

Event OnConsoleUnmute(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SoundUnmute(SoundCategory akSoundCategory)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  SoundCategory akSoundCategory = self.FormFromSArgument(sArgument, 1) as SoundCategory
  If akSoundCategory == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akSoundCategory.Unmute()
  PrintMessage("Unmuted " + self.GetFullID(akSoundCategory))
EndEvent

Event OnConsoleSetVolume(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetVolume(SoundCategory akSoundCategory, float afVolume)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  SoundCategory akSoundCategory = self.FormFromSArgument(sArgument, 1) as SoundCategory
  If akSoundCategory == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  float afVolume = self.FloatFromSArgument(sArgument, 2)
  akSoundCategory.SetVolume(afVolume)
  PrintMessage("Set volume of " + self.GetFullID(akSoundCategory) + " as " + afVolume)
EndEvent

Event OnConsoleSaveEx(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SaveEx")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Game.RequestSave()
EndEvent

Event OnConsoleAutoSaveEx(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SaveEx")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Game.RequestAutoSave()
EndEvent

Event OnConsoleGetIDFromConsoleRef(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetEditorIDFromConsoleRef()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Selected reference is " + self.GetFullID(akRef))
  PrintMessage("Selected reference's form is " + self.GetFullID(akRef.GetBaseObject()))
EndEvent

Event OnConsoleDelete(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: Del [<ObjectReference akRef = GetSelectedReference()>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  If QtyPars == 0
    akRef = ConsoleUtil.GetSelectedReference()
  ElseIf QtyPars == 1
    akRef = RefFromSArgument(sArgument, 1)
  EndIf

  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  ConsoleUtil.PrintMessage("markfordelete")
  DbSKSEFunctions.ExecuteConsoleCommand("markfordelete", ConsoleUtil.GetSelectedReference())
  ConsoleUtil.PrintMessage("disable")
  akRef.DisableNoWait()
  ConsoleUtil.PrintMessage("setpos z -10000")
  DbSKSEFunctions.ExecuteConsoleCommand("setpos z 10000", ConsoleUtil.GetSelectedReference())
  PrintMessage("Disabled and deleted " + self.GetFullID(akRef))
EndEvent

Event OnConsoleAttachPapyrusScript(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AttachPapyrusScript([<ObjectReference akRef = GetSelectedReference()>], string scriptName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  string scriptn
  If QtyPars == 0
    akRef = ConsoleUtil.GetSelectedReference()
    scriptn = self.StringFromSArgument(sArgument, 1)
  ElseIf QtyPars == 1
    akRef = RefFromSArgument(sArgument, 1)
    scriptn = self.StringFromSArgument(sArgument, 2)
  EndIf

  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  DbMiscFunctions.AttachPapyrusScript(scriptn, akRef)
  PrintMessage("Added " + scriptn + " to " + self.GetFullID(akRef))
EndEvent

Event OnConsoleGetFormDescription(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFormDescription(Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  string formDesc = DbSKSEFunctions.GetFormDescription(akForm)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  If formDesc == ""
    DescriptionFramework.GetDescription(akForm)
    If formDesc == ""
      PrintMessage("No description found for " + self.GetFullID(akForm))
      Return
    EndIf
  EndIf
  PrintMessage("Description for " + self.GetFullID(akForm) + ":")
  PrintMessage(formDesc)
EndEvent

Event OnConsoleAddMagicEffectToSpell(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddMagicEffectToSpell(Spell akSpell, MagicEffect akMagicEffect, float afMagnitude, int aiArea, int aiDuration, float afCost = 0.0, String[] asConditionList)")
  PrintMessage("asConditionList should be a string with conditions split by ;")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 2) as MagicEffect
  float afMagnitude = self.FloatFromSArgument(sArgument, 3)
  int aiArea = self.IntFromSArgument(sArgument, 4)
  int aiDuration = self.IntFromSArgument(sArgument, 5)
  float afCost = self.FloatFromSArgument(sArgument, 6)
  String[] asConditionList = self.StringArrayFromSArgument(sArgument, 7)
  If akSpell == none || akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.AddMagicEffectToSpell(akSpell, akMagicEffect, afMagnitude, aiArea, aiDuration, afCost, asConditionList)
  PrintMessage("Added " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akSpell))
EndEvent

Event OnConsoleGetFormTypeAll(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFormTypeAll(Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  string formTypeStr = DbMiscFunctions.GetFormTypeStringAll(akForm)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("FormType for " + self.GetFullID(akForm) + " is " + formTypeStr)
EndEvent

Event OnConsoleCreateXMarkerRef(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CreateXMarkerRef(Bool PersistentRef = false, ObjectReference PlaceAtMeRef = none)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  bool PersistentRef = self.BoolFromSArgument(sArgument, 1)
  ObjectReference PlaceAtMeRef = self.RefFromSArgument(sArgument, 2)
  If PlaceAtMeRef == none
    PlaceAtMeRef = ConsoleUtil.GetSelectedReference()
  EndIf
  ObjectReference result = DbMiscFunctions.CreateXMarkerRef(PersistentRef, PlaceAtMeRef)
  If result == none
    PrintMessage("Failed to place marker")
    Return
  EndIf
  PrintMessage("Created XMarker at " + self.GetFullID(PlaceAtMeRef) + ": " + self.GetFullID(result))
EndEvent

Event OnConsoleGetEnchantArt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetEnchantArt(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage(self.GetFullID(akMagicEffect.GetEnchantArt()))
EndEvent

Event OnConsoleGetCastingArt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetCastingArt(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage(GetFullID(akMagicEffect.GetCastingArt()))
EndEvent

Event OnConsoleGetHitEffectArt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHitEffectArt(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage(GetFullID(akMagicEffect.GetHitEffectArt()))
EndEvent

Event OnConsoleGetEnchantShader(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetEnchantShader(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage(GetFullID(akMagicEffect.GetEnchantShader()))
EndEvent

Event OnConsoleGetHitShader(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHitShader(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage(GetFullID(akMagicEffect.GetHitShader()))
EndEvent

Event OnConsoleSetEnchantArt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetEnchantArt(MagicEffect akMagicEffect, Art akArt)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  Art akArt = self.FormFromSArgument(sArgument, 2) as Art
  If akMagicEffect == none || akArt == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akMagicEffect.SetEnchantArt(akArt)
  PrintMessage("Set " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akArt))
EndEvent

Event OnConsoleSetCastingArt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetCastingArt(MagicEffect akMagicEffect, Art akArt)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  Art akArt = self.FormFromSArgument(sArgument, 2) as Art
  If akMagicEffect == none || akArt == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akMagicEffect.SetCastingArt(akArt)
  PrintMessage("Set " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akArt))
EndEvent

Event OnConsoleSetHitEffectArt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHitEffectArt(MagicEffect akMagicEffect, Art akArt)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  Art akArt = self.FormFromSArgument(sArgument, 2) as Art
  If akMagicEffect == none || akArt == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akMagicEffect.SetHitEffectArt(akArt)
  PrintMessage("Set " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akArt))
EndEvent

Event OnConsoleSetEnchantShader(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetEnchantShader(MagicEffect akMagicEffect, EffectShader akEffectShader)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 2) as EffectShader
  If akMagicEffect == none || akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akMagicEffect.SetEnchantShader(akEffectShader)
  PrintMessage("Set " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akEffectShader))
EndEvent

Event OnConsoleSetHitShader(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHitShader(MagicEffect akMagicEffect, EffectShader akEffectShader)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 2) as EffectShader
  If akMagicEffect == none || akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akMagicEffect.SetHitShader(akEffectShader)
  PrintMessage("Set " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akEffectShader))
EndEvent

Event OnConsoleResetActor3D(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ResetActor3D(Actor akActor, String asFolderName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("PO3_TINT: resets tint, rebuilds facegen if actor is player")
  PrintMessage("PO3_ALPHA: resets skin alpha")
  PrintMessage("PO3_TXST: resets texture-sets with texturepaths containing folderName")
  PrintMessage("PO3_TOGGLE: unhides all children of nodes that were written to the extraData")
  PrintMessage("PO3_SHADER: recreates the original shader type (as close as possible, projectedUV params are not restored)")
  Actor akActor
  string asFolderName

  If QtyPars == 1
    akActor = ConsoleUtil.GetSelectedReference() as Actor
    asFolderName = self.StringFromSArgument(sArgument, 1)
  ElseIf QtyPars == 2
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    asFolderName = self.StringFromSArgument(sArgument, 2)
  EndIf

  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.ResetActor3D(akActor, asFolderName)
  PrintMessage("Reset " + self.GetFullID(akActor) + " to " + asFolderName)
EndEvent

Event OnConsoleGetPackageIdles(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHitShader(Package akPackage)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Package akPackage = self.FormFromSArgument(sArgument, 1) as Package
  If akPackage == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  Idle[] Idles = PO3_SKSEFunctions.GetPackageIdles(akPackage)
  Int i = 0
  Int L = Idles.Length
  If i > 0
    PrintMessage("Found " + i + " idles for " + self.GetFullID(akPackage))
  Else
    PrintMessage("No idles found for " + self.GetFullID(akPackage))
    Return
  EndIf
  While i < L
    PrintMessage("Idle #" + i + ": " + self.GetFullID(Idles[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleAddPackageIdle(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddPackageIdle(Package akPackage, Idle akIdle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Package akPackage = self.FormFromSArgument(sArgument, 1) as Package
  Idle akIdle = self.FormFromSArgument(sArgument, 2) as Idle
  If akPackage == none || akIdle == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.AddPackageIdle(akPackage, akIdle)
  PrintMessage("Added " + self.GetFullID(akPackage) + " to " + self.GetFullID(akIdle))
EndEvent

Event OnConsoleRemovePackageIdle(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemovePackageIdle(Package akPackage, Idle akIdle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Package akPackage = self.FormFromSArgument(sArgument, 1) as Package
  Idle akIdle = self.FormFromSArgument(sArgument, 2) as Idle
  If akPackage == none || akIdle == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.RemovePackageIdle(akPackage, akIdle)
  PrintMessage("Removed " + self.GetFullID(akPackage) + " from " + self.GetFullID(akIdle))
EndEvent

Event OnConsoleGetFormIDFromEditorID(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFormIDFromEditorID(String EditorID)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("FormID: " + self.GetFullID(akForm))
EndEvent

Event OnConsoleGetEDIDFromFormID(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetEditorIDFromFormID(Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("EditorID: " + PO3_SKSEFunctions.GetFormEditorID(akForm))
EndEvent

Event OnConsoleGetFormModName(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFormModName(Form akForm, bool abLastModified)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  bool abLastModified = self.BoolFromSArgument(sArgument, 2, false)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Modname: " + PO3_SKSEFunctions.GetFormModName(akForm, abLastModified))
EndEvent

Event OnConsoleGetScriptsAttachedToActiveEffect(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetScriptsAttachedToActiveEffect(ActiveMagicEffect akActiveEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  ActiveMagicEffect akActiveEffect = self.GetFirstActiveMagicEffectOfType(akActor, akMagicEffect)

  String[] scripts = PO3_SKSEFunctions.GetScriptsAttachedToActiveEffect(akActiveEffect)
  int i = 0
  int L = scripts.length

  If L > 0
    PrintMessage(L + " scripts attached to " + self.GetFullID(akActiveEffect.GetBaseObject()) + ":")
  Else
    PrintMessage("No scripts attached to " + self.GetFullID(akActiveEffect.GetBaseObject()))
    Return
  EndIf

  While i < L
    PrintMessage("Script #" + i + ": " + scripts[i])
    i += 1
  EndWhile
EndEvent

Event OnConsoleDismissAllSummons(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: DismissAllSummons(Actor akActor, bool recoverSoul)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Actor[] summons = PO3_SKSEFunctions.GetCommandedActors(akActor)
  bool recoverSoul = self.BoolFromSArgument(sArgument, 1)

  int i = 0
  int L = summons.Length
  If L > 0
    PrintMessage("Dismissing " + L + " summons")
  Else
    PrintMessage("No summons to dismiss")
    Return
  EndIf
  While i < L
    summons[i].KillSilent()
    If recoverSoul
      PO3_SKSEFunctions.SetSoulTrapped(summons[i], true)
    EndIf
    i += 1
  EndWhile
  PrintMessage("Dismissed " + L + " summons")
EndEvent

Event OnConsoleAddMagicEffectToEnchantment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddMagicEffectToEnchantment(Enchantment akEnchantment, MagicEffect akMagicEffect, float afMagnitude, int aiArea, int aiDuration, float afCost = 0.0, String[] asConditionList)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Enchantment akEnchantment = self.FormFromSArgument(sArgument, 1) as Enchantment
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 2) as MagicEffect
  float afMagnitude = self.FloatFromSArgument(sArgument, 3)
  int aiArea = self.IntFromSArgument(sArgument, 4)
  int aiDuration = self.IntFromSArgument(sArgument, 5)
  float afCost = self.FloatFromSArgument(sArgument, 6, 0.0)
  String[] asConditionList = self.StringArrayFromSArgument(sArgument, 7)
  If akEnchantment == none || akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.AddMagicEffectToEnchantment(akEnchantment, akMagicEffect, afMagnitude, aiArea, aiDuration, afCost, asConditionList)
  PrintMessage("Added " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akEnchantment))
EndEvent

Event OnConsoleRemoveMagicEffectFromEnchantment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveMagicEffectFromEnchantment(Enchantment akEnchantment, MagicEffect akMagicEffect, float afMagnitude, int aiArea, int aiDuration, float afCost = 0.0, String[] asConditionList)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Enchantment akEnchantment = self.FormFromSArgument(sArgument, 1) as Enchantment
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 2) as MagicEffect
  float afMagnitude = self.FloatFromSArgument(sArgument, 3)
  int aiArea = self.IntFromSArgument(sArgument, 4)
  int aiDuration = self.IntFromSArgument(sArgument, 5)
  float afCost = self.FloatFromSArgument(sArgument, 6)
  If akEnchantment == none || akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.RemoveMagicEffectFromEnchantment(akEnchantment, akMagicEffect, afMagnitude, aiArea, aiDuration, afCost)
  PrintMessage("Removed " + self.GetFullID(akMagicEffect) + " from " + self.GetFullID(akEnchantment))
EndEvent

Event OnConsoleGetConditionList(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetConditionList(Form akForm, int aiIndex = 0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  String[] conditions = PO3_SKSEFunctions.GetConditionList(akForm, aiIndex)
  int i = 0
  int L = conditions.Length
  If L > 0
    PrintMessage(L + " conditions for " + self.GetFullID(akForm) + ":")
  Else
    PrintMessage("No conditions found for " + self.GetFullID(akForm))
    Return
  EndIf
  While i < L
    PrintMessage(conditions[i])
    i += 1
  EndWhile
EndEvent

Event OnConsoleSetConditionList(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetConditionList(Form akForm, int aiIndex = 0, String[] asConditionList)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  String[] asConditionList = self.StringArrayFromSArgument(sArgument,3)
  int i = 0
  int L = asConditionList.Length
  If L > 0
    PrintMessage(L + " conditions for " + self.GetFullID(akForm) + ":")
  Else
    PrintMessage("No conditions found for " + self.GetFullID(akForm))
    Return
  EndIf
  While i < L
    PrintMessage("Attempting to set condition " + i + " as " + asConditionList[i] + " for index " + aiIndex)
    i += 1
  EndWhile
  PO3_SKSEFunctions.SetConditionList(akForm, aiIndex, asConditionList)
EndEvent

Event OnConsoleSleep(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PO3_SKSEFunctions.ToggleOpenSleepWaitMenu(true)
EndEvent

Event OnConsoleLaunchSpell(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: LaunchSpell(Actor akActor, Spell akSpell, int aiSource)")
  PrintMessage("SOURCE HELP")
  PrintMessage("==============")
  PrintMessage("0	Left hand")
  PrintMessage("1	Right hand")
  PrintMessage("2	Voice")
  PrintMessage("3	Instant")
  PrintMessage("==============")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  int aiSource = self.IntFromSArgument(sArgument, 2)
  If akActor == none || akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.LaunchSpell(akActor, akSpell, aiSource)
  PrintMessage(self.GetFullID(akActor) + " launched " + self.GetFullID(akSpell))
EndEvent

Event OnConsoleGetMenuContainer(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMenuContainer()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = PO3_SKSEFunctions.GetMenuContainer()
  If akRef == none
    PrintMessage("No container found")
    Return
  EndIf
  PrintMessage("Container is: " + self.GetFullID(akRef))
EndEvent

Event OnConsolerGetItemHealthPercent(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetItemHealthPercent [<ObjectReference akRef = GetSelectedReference()>])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  If QtyPars == 0
    akRef = ConsoleUtil.GetSelectedReference()
  ElseIf QtyPars == 1
    akRef = self.RefFromSArgument(sArgument, 1)
  EndIf
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  float health = akRef.GetItemHealthPercent()
  PrintMessage("Health of " + self.GetFullID(akRef) + " is " + health)
EndEvent

Event OnConsolerSetItemHealthPercent(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetItemHealthPercent ([ObjectReference akRef = GetSelectedReference()], float afHealth = 10.0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  float afHealth
  If QtyPars == 1
    akRef = ConsoleUtil.GetSelectedReference()
    afHealth = self.FloatFromSArgument(sArgument, 1, 10.0)
  ElseIf QtyPars == 2
    akRef = self.RefFromSArgument(sArgument, 1)
    afHealth = self.FloatFromSArgument(sArgument, 2, 10.0)
  EndIf
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akRef.SetItemHealthPercent(afHealth)
  PrintMessage("Set health of " + self.GetFullID(akRef) + " to " + afHealth)
EndEvent

Event OnConsoleSetReferenceDisplayName(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetReferenceDisplayName([ObjectReference akRef = GetSelectedReference()], String newName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  String newName
  akRef = ConsoleUtil.GetSelectedReference()
  newName = DbMiscFunctions.RemovePrefixFromString(sArgument, StringFromSArgument(sArgument, 0) + " ")
  
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akRef.SetDisplayName(newName)
  PrintMessage("Attempting to change name of " + self.GetFullID(akRef) + " to " + newName)
  
  if akRef.GetDisplayName() == newName
    PrintMessage("Display name of " + self.GetFullID(akRef) + " successfully changed to " + newName)
  else
    PrintMessage("Failed to change display name of " + self.GetFullID(akRef))
  endif
EndEvent

Event OnConsoleSetFormName(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetFormName([Form akForm = GetSelectedReference().GetBaseObject()], String newName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm
  string newName
  akForm = self.GetSelectedBase()
  newName = DbMiscFunctions.RemovePrefixFromString(sArgument, self.StringFromSArgument(sArgument, 0))
  
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akForm.SetName(newName)
  PrintMessage("Attempting to change name of " + self.GetFullID(akForm) + " to " + newName)
  
  if akForm.GetName() == newName
    PrintMessage("Form name of " + self.GetFullID(akForm) + " successfully changed to " + newName)
  else
    PrintMessage("Failed to change form name of " + self.GetFullID(akForm))
  endif
EndEvent

Event OnConsoleEnchantObject(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: EnchantObject(ObjectReference akRef, float maxCharge, MagicEffect[] effects, float[] magnitudes, int[] areas, int[] durations)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  float maxCharge = self.FloatFromSArgument(sArgument, 1)
  int enchants = ((fArgument as Int) - 3) / 4
  int i = 0

  DynamicMagicEffectArrays MagicEffectArrays = (GetOwningQuest() as form) as DynamicMagicEffectArrays
  
  MagicEffect[] effects = MagicEffectArrays.CreateArray(enchants)
  float[] magnitudes = Utility.CreateFloatArray(enchants)
  int[] areas = Utility.CreateIntArray(enchants)
  int[] durations = Utility.CreateIntArray(enchants)
  If enchants > 0
    PrintMessage("Enchanting " + enchants + " effects")
  EndIf
  While i < enchants
    effects[i] = self.FormFromSArgument(sArgument, 2 + i * 4) as MagicEffect
    magnitudes[i] = self.FloatFromSArgument(sArgument, 3 + i * 4)
    areas[i] = self.IntFromSArgument(sArgument, 4 + i * 4)
    durations[i] = self.IntFromSArgument(sArgument, 5 + i * 4)
    i += 1
  EndWhile
  If akRef == none || effects == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akRef.CreateEnchantment(maxCharge, effects, magnitudes, areas, durations)
  PrintMessage("Enchanted " + self.GetFullID(akRef) + " with " + enchants + " effects")
EndEvent

Event OnConsoleClearDestruction(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearDestruction()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akRef.ClearDestruction()
  PrintMessage("Cleared destruction data for " + self.GetFullID(akRef))
EndEvent

Event OnConsoleCCPlaceAroundReference(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlaceAroundReference(objectreference centerMarker, Form akForm, Float distance, Float angle, Float heightOffset)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  Form akForm = self.FormFromSArgument(sArgument, 1)
  ObjectReference buildMarker = PlayerRef.PlaceAtMe(PO3_SKSEFunctions.GetFormFromEditorID("XMarker"), 1, false, false)
  Float distance = self.FloatFromSArgument(sArgument, 2)
  Float angle = self.FloatFromSArgument(sArgument, 3)
  Float heightOffset = self.FloatFromSArgument(sArgument, 4)
  If akRef == none || akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  ccqdrsse002_globalfunctions.PlaceAroundReference(akRef, akForm, buildMarker, distance, angle, heightOffset)
  PrintMessage("Placed " + self.GetFullID(akForm) + " around " + self.GetFullID(akRef))
EndEvent

Event OnConsoleCharGenSaveCharacter(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SaveCharacter(string characterName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  string newName = self.StringFromSArgument(sArgument, 1)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  CharGen.SaveCharacterPreset(akActor, newName)
  PrintMessage("Saved " + self.GetFullID(akActor) + " as " + newName)
EndEvent

Event OnConsoleCharGenLoadCharacter(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: LoadCharacter(Actor akDestination, Race akRace, string newCharacter)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akDestination = ConsoleUtil.GetSelectedReference() as Actor
  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  string newName = self.StringFromSArgument(sArgument, 2)
  If akDestination == none || akRace == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
  EndIf
  CharGen.LoadCharacter(akDestination, akRace, newName)
  PrintMessage("Loaded " + newName + " onto " + self.GetFullID(akDestination))
EndEvent

Event OnConsoleRecordSignatureHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  String searchString = self.StringFromSArgument(sArgument, 1)

  String[] RSMsg
    PrintMessage("RECORD SIGNATURES")
    RSMsg = PapyrusUtil.PushString(RSMsg, "AACT - Action")
    RSMsg = PapyrusUtil.PushString(RSMsg, "ACHR - Placed NPC")
    RSMsg = PapyrusUtil.PushString(RSMsg, "ACTI - Activator")
    RSMsg = PapyrusUtil.PushString(RSMsg, "ADDN - Addon Node")
    RSMsg = PapyrusUtil.PushString(RSMsg, "ALCH - Ingestible")
    RSMsg = PapyrusUtil.PushString(RSMsg, "AMMO - Ammunition")
    RSMsg = PapyrusUtil.PushString(RSMsg, "ANIO - Animated Object")
    RSMsg = PapyrusUtil.PushString(RSMsg, "APPA - Alchemical Apparatus")
    RSMsg = PapyrusUtil.PushString(RSMsg, "ARMA - Armor Addon")
    RSMsg = PapyrusUtil.PushString(RSMsg, "ARMO - Armor")
    RSMsg = PapyrusUtil.PushString(RSMsg, "ARTO - Art Object")
    RSMsg = PapyrusUtil.PushString(RSMsg, "ASPC - Acoustic Space")
    RSMsg = PapyrusUtil.PushString(RSMsg, "ASTP - Association Type")
    RSMsg = PapyrusUtil.PushString(RSMsg, "AVIF - Actor Value Information")
    RSMsg = PapyrusUtil.PushString(RSMsg, "BOOK - Book")
    RSMsg = PapyrusUtil.PushString(RSMsg, "BPTD - Body Part Data")
    RSMsg = PapyrusUtil.PushString(RSMsg, "CAMS - Camera Shot")
    RSMsg = PapyrusUtil.PushString(RSMsg, "CELL - Cell")
    RSMsg = PapyrusUtil.PushString(RSMsg, "CLAS - Class")
    RSMsg = PapyrusUtil.PushString(RSMsg, "CLDC - CLDC")
    RSMsg = PapyrusUtil.PushString(RSMsg, "CLFM - Color")
    RSMsg = PapyrusUtil.PushString(RSMsg, "CLMT - Climate")
    RSMsg = PapyrusUtil.PushString(RSMsg, "COBL - Constructible Object")
    RSMsg = PapyrusUtil.PushString(RSMsg, "COLL - Collision Layer")
    RSMsg = PapyrusUtil.PushString(RSMsg, "CONT - Container")
    RSMsg = PapyrusUtil.PushString(RSMsg, "CPTH - Camera Path")
    RSMsg = PapyrusUtil.PushString(RSMsg, "CSTY - Combat Style")
    RSMsg = PapyrusUtil.PushString(RSMsg, "DEBR - Debris")
    RSMsg = PapyrusUtil.PushString(RSMsg, "DIAL - Dialog Topic")
    RSMsg = PapyrusUtil.PushString(RSMsg, "DILR - Dialog Branch")
    RSMsg = PapyrusUtil.PushString(RSMsg, "DLVW - Dialog View")
    RSMsg = PapyrusUtil.PushString(RSMsg, "DOBJ - Default Object Manager")
    RSMsg = PapyrusUtil.PushString(RSMsg, "DOOR - Door")
    RSMsg = PapyrusUtil.PushString(RSMsg, "DUAL - Dual Cast Data")
    RSMsg = PapyrusUtil.PushString(RSMsg, "ECZN - Encounter Zone")
    RSMsg = PapyrusUtil.PushString(RSMsg, "EFSH - Effect Shader")
    RSMsg = PapyrusUtil.PushString(RSMsg, "EQUIP - Equip Type")
    RSMsg = PapyrusUtil.PushString(RSMsg, "EXPL - Explosion")
    RSMsg = PapyrusUtil.PushString(RSMsg, "EYES - Eyes")
    RSMsg = PapyrusUtil.PushString(RSMsg, "FACT - Faction")
    RSMsg = PapyrusUtil.PushString(RSMsg, "FLOR - Flora")
    RSMsg = PapyrusUtil.PushString(RSMsg, "FLST - FormID List")
    RSMsg = PapyrusUtil.PushString(RSMsg, "FSTP - Footstep")
    RSMsg = PapyrusUtil.PushString(RSMsg, "FSTS - Footstep Set")
    RSMsg = PapyrusUtil.PushString(RSMsg, "FURN - Furniture")
    RSMsg = PapyrusUtil.PushString(RSMsg, "GLOB - Global")
    RSMsg = PapyrusUtil.PushString(RSMsg, "GMST - Game Setting")
    RSMsg = PapyrusUtil.PushString(RSMsg, "GRAS - Grass")
    RSMsg = PapyrusUtil.PushString(RSMsg, "HAIR - Hair")
    RSMsg = PapyrusUtil.PushString(RSMsg, "HAZD - Hazard")
    RSMsg = PapyrusUtil.PushString(RSMsg, "HDPT - Head Part")
    RSMsg = PapyrusUtil.PushString(RSMsg, "IDLE - Idle Animation")
    RSMsg = PapyrusUtil.PushString(RSMsg, "IDLM - Idle Marker")
    RSMsg = PapyrusUtil.PushString(RSMsg, "IMAD - Image Space Adapter")
    RSMsg = PapyrusUtil.PushString(RSMsg, "IMGS - Image Space")
    RSMsg = PapyrusUtil.PushString(RSMsg, "INFO - Dialog Response")
    RSMsg = PapyrusUtil.PushString(RSMsg, "INGR - Ingredient")
    RSMsg = PapyrusUtil.PushString(RSMsg, "IPCT - Impact")
    RSMsg = PapyrusUtil.PushString(RSMsg, "IPDS - Impact Data Set")
    RSMsg = PapyrusUtil.PushString(RSMsg, "KEYM - Key")
    RSMsg = PapyrusUtil.PushString(RSMsg, "KYWD - Keyword")
    RSMsg = PapyrusUtil.PushString(RSMsg, "LAND - Landscape")
    RSMsg = PapyrusUtil.PushString(RSMsg, "LCRT - Location Reference Type")
    RSMsg = PapyrusUtil.PushString(RSMsg, "LCTN - Location")
    RSMsg = PapyrusUtil.PushString(RSMsg, "LENS - Lens Flare")
    RSMsg = PapyrusUtil.PushString(RSMsg, "LGTM - Lighting Template")
    RSMsg = PapyrusUtil.PushString(RSMsg, "LIGH - Light")
    RSMsg = PapyrusUtil.PushString(RSMsg, "LSCR - Load Screen")
    RSMsg = PapyrusUtil.PushString(RSMsg, "LTEX - Landscape Texture")
    RSMsg = PapyrusUtil.PushString(RSMsg, "LVLI - Leveled Item")
    RSMsg = PapyrusUtil.PushString(RSMsg, "LVLN - Leveled NPC")
    RSMsg = PapyrusUtil.PushString(RSMsg, "LVSP - Leveled Spell")
    RSMsg = PapyrusUtil.PushString(RSMsg, "MATT - Material Type")
    RSMsg = PapyrusUtil.PushString(RSMsg, "MESG - Message")
    RSMsg = PapyrusUtil.PushString(RSMsg, "MGEF - Magic Effect")
    RSMsg = PapyrusUtil.PushString(RSMsg, "MISC - Misc. Item")
    RSMsg = PapyrusUtil.PushString(RSMsg, "MOVT - Movement Type")
    RSMsg = PapyrusUtil.PushString(RSMsg, "MSTT - Moveable Static")
    RSMsg = PapyrusUtil.PushString(RSMsg, "MUSC - Music Type")
    RSMsg = PapyrusUtil.PushString(RSMsg, "MUST - Music Track")
    RSMsg = PapyrusUtil.PushString(RSMsg, "NAVI - Navmesh Info Map")
    RSMsg = PapyrusUtil.PushString(RSMsg, "NAVM - Navmesh")
    RSMsg = PapyrusUtil.PushString(RSMsg, "NPC_ - Non-Player Character (Actor)")
    RSMsg = PapyrusUtil.PushString(RSMsg, "OTFT - Outfit")
    RSMsg = PapyrusUtil.PushString(RSMsg, "PACK - Package")
    RSMsg = PapyrusUtil.PushString(RSMsg, "PARW - Placed Arrow")
    RSMsg = PapyrusUtil.PushString(RSMsg, "PBAR - Placed Barrier")
    RSMsg = PapyrusUtil.PushString(RSMsg, "PBEA - Placed Beam")
    RSMsg = PapyrusUtil.PushString(RSMsg, "PCON - Placed Cone/Voice")
    RSMsg = PapyrusUtil.PushString(RSMsg, "PERK - Perk")
    RSMsg = PapyrusUtil.PushString(RSMsg, "PFLA - Placed Flame")
    RSMsg = PapyrusUtil.PushString(RSMsg, "PGRE - Placed Projectile")
    RSMsg = PapyrusUtil.PushString(RSMsg, "PHZD - Placed Hazard")
    RSMsg = PapyrusUtil.PushString(RSMsg, "PLYR - Player Reference")
    RSMsg = PapyrusUtil.PushString(RSMsg, "PMIS - Placed Missile")
    RSMsg = PapyrusUtil.PushString(RSMsg, "PROJ - Projectile")
    RSMsg = PapyrusUtil.PushString(RSMsg, "QUST - Quest")
    RSMsg = PapyrusUtil.PushString(RSMsg, "RACE - Race")
    RSMsg = PapyrusUtil.PushString(RSMsg, "REFR - Placed Object")
    RSMsg = PapyrusUtil.PushString(RSMsg, "REGN - Region")
    RSMsg = PapyrusUtil.PushString(RSMsg, "RELA - Relationship")
    RSMsg = PapyrusUtil.PushString(RSMsg, "REVB - Reverb Parameters")
    RSMsg = PapyrusUtil.PushString(RSMsg, "RFCT - Visual Effect")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SCEN - Scene")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SCOL - Static Collection")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SCPT - Script")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SCRL - Scroll")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SHOU - Shout")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SLGM - Soul Gem")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SMBN - Story Manager Branch Node")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SMEN - Story Manager Event Node")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SMQN - Story Manager Quest Node")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SNCT - Sound Category")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SNDR - Sound Descriptor")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SOUN - Sound")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SPEL - Spell")
    RSMsg = PapyrusUtil.PushString(RSMsg, "SPGD - Shader Particle Geometry")
    RSMsg = PapyrusUtil.PushString(RSMsg, "STAT - Static")
    RSMsg = PapyrusUtil.PushString(RSMsg, "TACT - Talking Activator")
    RSMsg = PapyrusUtil.PushString(RSMsg, "TES4 - TES4")
    RSMsg = PapyrusUtil.PushString(RSMsg, "TREE - Tree")
    RSMsg = PapyrusUtil.PushString(RSMsg, "TXST - Texture Set")
    RSMsg = PapyrusUtil.PushString(RSMsg, "VTYP - Voice Type")
    RSMsg = PapyrusUtil.PushString(RSMsg, "WATR - Water")
    RSMsg = PapyrusUtil.PushString(RSMsg, "WEAP - Weapon")
    RSMsg = PapyrusUtil.PushString(RSMsg, "WOOP - Word of Power")
    RSMsg = PapyrusUtil.PushString(RSMsg, "WRLD - Worldspace")
    RSMsg = PapyrusUtil.PushString(RSMsg, "WTHR - Weather")
  
  int i = 0
  int L = RSMsg.Length
  bool found = false
  
  While i < L
    If StringUtil.Find(RSMsg[i], searchString) != -1 || QtyPars == 0
        PrintMessage(RSMsg[i])
        found = true
    EndIf
    i += 1
  EndWhile

  If !found
    PrintMessage("No record signatures found")
    Return
  EndIf
  PrintMessage("===============================")
EndEvent

Event OnConsoleSpellGetEquipType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSpellEquipType()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  EquipSlot akEquipSlot = akSpell.GetEquipType()
  If akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Equip slot for " + self.GetFullID(akSpell) + " is " + self.GetFullID(akEquipSlot))
EndEvent

Event OnConsoleSpellSetEquipType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellEquipType(EquipSlot type)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  EquipSlot akEquipSlot = self.FormFromSArgument(sArgument, 2) as EquipSlot
  If akSpell == none || akEquipSlot == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akSpell.SetEquipType(akEquipSlot)
  PrintMessage("Equip slot for " + self.GetFullID(akSpell) + " set to " + self.GetFullID(akEquipSlot))
EndEvent

Event OnConsoleGetPlayerDialogueTarget(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetPlayerDialogueTarget()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = Game.GetDialogueTarget()
  If akRef == none
    PrintMessage("No dialogue target found")
    Return
  EndIf
  PrintMessage("Player is currently in dialogue with " + self.GetFullID(akRef))
EndEvent

Event OnConsoleForceFirstPerson(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ForceFirstPerson()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Game.ForceFirstPerson()
  PrintMessage("Forced first person")
EndEvent

Event OnConsoleForceThirdPerson(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ForceThirdPerson()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Game.ForceThirdPerson()
  PrintMessage("Forced third person")
EndEvent

Event OnConsoleSetPlayerAIDriven(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  Bool bAIDriven = self.BoolFromSArgument(sArgument, 1)
  PrintMessage("Format: SetPlayerAIDriven(bool bAIDriven)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Game.SetPlayerAIDriven(bAIDriven)
  PrintMessage("Set PlayerAIDriven to " + bAIDriven)
EndEvent

Event OnConsoleShowLimitedRaceMenu(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ShowLimitedRaceMenu()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Game.ShowLimitedRaceMenu()
  PrintMessage("ShowLimitedRaceMenu")
EndEvent

Event OnConsoleSetPlayersLastRiddenHorse(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetPlayersLastRiddenHorse(Actor akHorse)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akHorse = ConsoleUtil.GetSelectedReference() as Actor
  Game.SetPlayersLastRiddenHorse(akHorse)
  PrintMessage("Last ridden horse set to " + self.GetFullID(akHorse))
EndEvent

Event OnConsoleTriggerScreenBlood(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: TriggerScreenBlood(int aiValue)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int aiValue = self.IntFromSArgument(sArgument, 1)
  Game.TriggerScreenBlood(aiValue)
  PrintMessage("Screen blood set with value " + aiValue)
EndEvent


; ;Input
; ; holds down the specified key until released


Event OnConsoleInputTapKey(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: TapKey(int dxKeycode)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int dxKeycode = self.IntFromSArgument(sArgument, 1)
  Input.TapKey(dxKeycode)
  PrintMessage("TapKey " + dxKeycode)
EndEvent

Event OnConsoleInputHoldKey(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: HoldKey(int dxKeycode)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int dxKeycode = self.IntFromSArgument(sArgument, 1)
  Input.HoldKey(dxKeycode)
  PrintMessage("HoldKey " + dxKeycode)
EndEvent

Event OnConsoleInputReleaseKey(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ReleaseKey(int dxKeycode)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int dxKeycode = self.IntFromSArgument(sArgument, 1)
  Input.ReleaseKey(dxKeycode)
  PrintMessage("ReleaseKey " + dxKeycode)
EndEvent


; ;Keyword
; ; Sends this keyword as a story event to the story manager
; Function SendStoryEvent(Location akLoc = None, ObjectReference akRef1 = None, ObjectReference akRef2 = None, int aiValue1 = 0, \
;   int aiValue2 = 0) native

; ; -------------
; ; Location.psc
; ; -------------


Event OnConsoleLocationGetKeywordData(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLocationKeywordData(Location akLocation, Keyword akKeyword)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Location akLocation = self.FormFromSArgument(sArgument, 1) as Location
  Keyword akKeyword = self.FormFromSArgument(sArgument, 2) as Keyword
  
  If akKeyword == none
    akKeyword = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 2))
  EndIf

  If akLocation == none || akKeyword == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akLocation.GetKeywordData(akKeyword)
  PrintMessage("Location keyword data for " + self.GetFullID(akLocation) + " " + self.GetFullID(akKeyword) + " is " + akLocation.GetKeywordData(akKeyword))
EndEvent

Event OnConsoleLocationSetKeywordData(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLocationKeywordData(Location akLocation, Keyword akKeyword, float afData)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Location akLocation = self.FormFromSArgument(sArgument, 1) as Location
  Keyword akKeyword = self.FormFromSArgument(sArgument, 2) as Keyword
  float afData = self.FloatFromSArgument(sArgument, 3)
  If akLocation == none || akKeyword == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akLocation.SetKeywordData(akKeyword, afData)
  PrintMessage("Location keyword data for " + self.GetFullID(akLocation) + " " + self.GetFullID(akKeyword) + " set to " + afData)
EndEvent

Event OnConsoleSetItemMaxCharge(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetItemMaxCharge(float maxCharge)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  float maxCharge = self.FloatFromSArgument(sArgument, 1)
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akRef.SetItemCharge(maxCharge)
  PrintMessage("Item max charge of " + self.GetFullID(akRef) + " set to " + maxCharge)
EndEvent

Event OnConsoleGetItemMaxCharge(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetItemMaxCharge()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  float maxCharge = akRef.GetItemMaxCharge()
  PrintMessage("Item max charge of " + self.GetFullID(akRef) + " is " + maxCharge)
EndEvent

Event OnConsoleGetItemCharge(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetItemCharge()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  float charge = akRef.GetItemCharge()
  PrintMessage("Item charge of " + self.GetFullID(akRef) + " is " + charge)
EndEvent

Event OnConsoleSetItemCharge(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetItemCharge(float charge)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  float charge = self.FloatFromSArgument(sArgument, 1)
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akRef.SetItemCharge(charge)
  PrintMessage("Item charge of " + self.GetFullID(akRef) + " set to " + charge)
EndEvent


; ; --------------------
; ; Art.psc
; ; --------------------
Event OnConsoleArtGetModelPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArtModelPath(Art akArtObject)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Art akArtObject = self.FormFromSArgument(sArgument, 1) as Art
  If akArtObject == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  string Result = akArtObject.GetModelPath()
  PrintMessage("SetArtModelPath " + self.GetFullID(akArtObject) + " is " + Result)
EndEvent

Event OnConsoleArtSetModelPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetArtModelPath(Art akArtObject, string asPath)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Art akArtObject = self.FormFromSArgument(sArgument, 1) as Art
  string asPath = self.StringFromSArgument(sArgument, 2)
  If akArtObject == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akArtObject.SetModelPath(asPath)
  PrintMessage("SetArtModelPath " + self.GetFullID(akArtObject) + " to " + asPath)
EndEvent


; ; --------------------
; ; Cell.psc
; ; --------------------
Event OnConsoleSetFogColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetFogColor(int aiNearRed, int aiNearGreen, int aiNearBlue, int aiFarRed, int aiFarGreen, int aiFarBlue)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Cell akCell = self.FormFromSArgument(sArgument, 1) as Cell
  int aiNearRed = self.IntFromSArgument(sArgument, 2)
  int aiNearGreen = self.IntFromSArgument(sArgument, 3)
  int aiNearBlue = self.IntFromSArgument(sArgument, 4)
  int aiFarRed = self.IntFromSArgument(sArgument, 5)
  int aiFarGreen = self.IntFromSArgument(sArgument, 6)
  int aiFarBlue = self.IntFromSArgument(sArgument, 7)
  If akCell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akCell.SetFogColor(aiNearRed, aiNearGreen, aiNearBlue, aiFarRed, aiFarGreen, aiFarBlue)
  PrintMessage("SetFogColor " + self.GetFullID(akCell) + " to " + aiNearRed + " " + aiNearGreen + " " + aiNearBlue + " " + aiFarRed + " " + aiFarGreen + " " + aiFarBlue)
EndEvent

Event OnConsoleSetFogPlanes(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetFogPlanes(float afNear, float afFar)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Cell akCell = self.FormFromSArgument(sArgument, 1) as Cell
  float afNear = self.FloatFromSArgument(sArgument, 2)
  float afFar = self.FloatFromSArgument(sArgument, 3)
  If akCell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akCell.SetFogPlanes(afNear, afFar)
  PrintMessage("SetFogPlanes " + self.GetFullID(akCell) + " to " + afNear + " " + afFar)
EndEvent

Event OnConsoleSetFogPower(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetFogPower(float afPower)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Cell akCell = self.FormFromSArgument(sArgument, 1) as Cell
  float afPower = self.FloatFromSArgument(sArgument, 2)
  If akCell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akCell.SetFogPower(afPower)
  PrintMessage("SetFogPower " + self.GetFullID(akCell) + " to " + afPower)
EndEvent

Event OnConsoleSetPublic(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetPublic(bool abPublic = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Cell akCell = self.FormFromSArgument(sArgument, 1) as Cell
  bool abPublic = self.BoolFromSArgument(sArgument, 2, false)
  If akCell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akCell.SetPublic(abPublic)
  PrintMessage("SetPublic " + self.GetFullID(akCell) + " to " + abPublic)
EndEvent

Event OnConsoleGetActorOwner(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorOwner()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Cell akCell = self.FormFromSArgument(sArgument, 1) as Cell
  If akCell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  ActorBase akActor = akCell.GetActorOwner()
  PrintMessage("Actor owner of " + self.GetFullID(akCell) + " is " + self.GetFullID(akActor))
EndEvent

Event OnConsoleGetFactionOwner(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFactionOwner()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Cell akCell = self.FormFromSArgument(sArgument, 1) as Cell
  If akCell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Faction akFaction = akCell.GetFactionOwner()
  PrintMessage("Faction owner of " + self.GetFullID(akCell) + " is " + self.GetFullID(akFaction))
EndEvent

Event OnConsoleGetWaterLevel(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetWaterLevel()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Cell akCell = self.FormFromSArgument(sArgument, 1) as Cell
  If akCell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  float waterLevel = akCell.GetWaterLevel()
  PrintMessage("Water level of " + self.GetFullID(akCell) + " is " + waterLevel)
EndEvent

Event OnConsoleGetActualWaterLevel(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActualWaterLevel()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Cell akCell = self.FormFromSArgument(sArgument, 1) as Cell
  If akCell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  float waterLevel = akCell.GetActualWaterLevel()
  PrintMessage("Actual water level of " + self.GetFullID(akCell) + " is " + waterLevel)
EndEvent


; ; --------------------
; ; Armor.psc
; ; --------------------
Event OnConsoleSlotHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SlotHelp()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("SLOT MASK HELP")
  PrintMessage("============================")
    PrintMessage("kSlotMask30 =  0x00000001")
    PrintMessage("kSlotMask31 =  0x00000002")
    PrintMessage("kSlotMask32 =  0x00000004")
    PrintMessage("kSlotMask33 =  0x00000008")
    PrintMessage("kSlotMask34 =  0x00000010")
    PrintMessage("kSlotMask35 =  0x00000020")
    PrintMessage("kSlotMask36 =  0x00000040")
    PrintMessage("kSlotMask37 =  0x00000080")
    PrintMessage("kSlotMask38 =  0x00000100")
    PrintMessage("kSlotMask39 =  0x00000200")
    PrintMessage("kSlotMask40 =  0x00000400")
    PrintMessage("kSlotMask41 =  0x00000800")
    PrintMessage("kSlotMask42 =  0x00001000")
    PrintMessage("kSlotMask43 =  0x00002000")
    PrintMessage("kSlotMask44 =  0x00004000")
    PrintMessage("kSlotMask45 =  0x00008000")
    PrintMessage("kSlotMask46 =  0x00010000")
    PrintMessage("kSlotMask47 =  0x00020000")
    PrintMessage("kSlotMask48 =  0x00040000")
    PrintMessage("kSlotMask49 =  0x00080000")
    PrintMessage("kSlotMask50 =  0x00100000")
    PrintMessage("kSlotMask51 =  0x00200000")
    PrintMessage("kSlotMask52 =  0x00400000")
    PrintMessage("kSlotMask53 =  0x00800000")
    PrintMessage("kSlotMask54 =  0x01000000")
    PrintMessage("kSlotMask55 =  0x02000000")
    PrintMessage("kSlotMask56 =  0x04000000")
    PrintMessage("kSlotMask57 =  0x08000000")
    PrintMessage("kSlotMask58 =  0x10000000")
    PrintMessage("kSlotMask59 =  0x20000000")
    PrintMessage("kSlotMask60 =  0x40000000")
    PrintMessage("kSlotMask61 =  0x80000000")
  PrintMessage("===========================")
EndEvent

Event OnConsoleGetSlotMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSlotMask(Armor akArmor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int slotMask = akArmor.GetSlotMask()
  PrintMessage("Slot mask of " + self.GetFullID(akArmor) + " is " + slotMask)
EndEvent

Event OnConsoleSetSlotMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSlotMask(Armor akArmor, int slotMask)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  int slotMask = self.IntFromSArgument(sArgument, 2)
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akArmor.SetSlotMask(slotMask)
  PrintMessage("Slot mask of " + self.GetFullID(akArmor) + " set to " + slotMask)
EndEvent

Event OnConsoleAddSlotToMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddSlotToMask(Armor akArmor, int slotMask)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  int slotMask = self.IntFromSArgument(sArgument, 2)
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akArmor.AddSlotToMask(slotMask)
  PrintMessage("Slot mask of " + self.GetFullID(akArmor) + " added " + slotMask)
EndEvent 


Event OnConsoleRemoveSlotFromMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveSlotFromMask(Armor akArmor, int slotMask)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  int slotMask = self.IntFromSArgument(sArgument, 2)
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akArmor.RemoveSlotFromMask(slotMask)
  PrintMessage("Slot mask of " + self.GetFullID(akArmor) + " removed " + slotMask)
EndEvent

Event OnConsoleGetMaskForSlot(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMaskForSlot(int slot)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int slot = self.IntFromSArgument(sArgument, 1)
  int mask = Armor.GetMaskForSlot(slot)
  PrintMessage("Mask for slot " + slot + " is " + mask)
EndEvent

Event OnConsoleGetArmorModelPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorModelPath(Armor akArmor, bool bFemalePath)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  bool bFemalePath = self.BoolFromSArgument(sArgument, 2)
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  string Result = akArmor.GetModelPath(bFemalePath)
  PrintMessage("Model path of " + self.GetFullID(akArmor) + " is " + Result)
EndEvent

Event OnConsoleSetArmorModelPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetArmorModelPath(Armor akArmor, string path, bool bFemalePath)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  string path = DbMiscFunctions.RemovePrefixFromString(sArgument, StringFromSArgument(sArgument, 0) + " " + StringFromSArgument(sArgument, 1) + " ")
  bool bFemalePath = self.BoolFromSArgument(sArgument, 3)
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akArmor.SetModelPath(path, bFemalePath)
  PrintMessage("Model path of " + self.GetFullID(akArmor) + " set to " + path)
EndEvent

Event OnConsoleGetArmorIconPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorIconPath(bool bFemalePath)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  bool bFemalePath = self.BoolFromSArgument(sArgument, 2)
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  string Result = akArmor.GetIconPath(bFemalePath)
  PrintMessage("Icon path of " + self.GetFullID(akArmor) + " is " + Result)
EndEvent

Event OnConsoleSetArmorIconPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetIconPath(string path, bool bFemalePath)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  string path = DbMiscFunctions.RemovePrefixFromString(sArgument, StringFromSArgument(sArgument, 0) + " " + StringFromSArgument(sArgument, 1) + " ")
  bool bFemalePath = self.BoolFromSArgument(sArgument, 3)
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akArmor.SetIconPath(path, bFemalePath)
  PrintMessage("Icon path of " + self.GetFullID(akArmor) + " set to " + path)
EndEvent

Event OnConsoleGetArmorMessageIconPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMessageIconPath(bool bFemalePath)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  bool bFemalePath = self.BoolFromSArgument(sArgument, 2)
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  string Result = akArmor.GetMessageIconPath(bFemalePath)
  PrintMessage("Message icon path of " + self.GetFullID(akArmor) + " is " + Result)
EndEvent

Event OnConsoleSetArmorMessageIconPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMessageIconPath(string path, bool bFemalePath)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  string path = DbMiscFunctions.RemovePrefixFromString(sArgument, StringFromSArgument(sArgument, 0) + " " + StringFromSArgument(sArgument, 1) + " ")
  bool bFemalePath = self.BoolFromSArgument(sArgument, 3)
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akArmor.SetMessageIconPath(path, bFemalePath)
  PrintMessage("Message icon path of " + self.GetFullID(akArmor) + " set to " + path)
EndEvent

Event OnConsoleGetArmorWeightClass(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorWeightClass()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("0 = Light Armor; 1 = Heavy Armor; 2 = Clothing")
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int weightClass = akArmor.GetWeightClass()
  PrintMessage("Weight class of " + self.GetFullID(akArmor) + " is " + weightClass)
EndEvent

Event OnConsoleSetArmorWeightClass(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetArmorWeightClass(int weightClass)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  int weightClass = self.IntFromSArgument(sArgument, 2)
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Attempting to change the weight class of " + self.GetFullID(akArmor) + " to " + weightClass)
  akArmor.SetWeightClass(weightClass)
  int returnedWeightClass = akArmor.GetWeightClass()
  PrintMessage("Weight class of " + self.GetFullID(akArmor) + " set to " + returnedWeightClass)
EndEvent



; ; --------------------
; ; Actor.psc
; ; --------------------
Event OnConsoleSendVampirismStateChanged(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SendVampirismStateChanged(bool abIsVampire)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  bool abIsVampire = self.BoolFromSArgument(sArgument, 1)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.SendVampirismStateChanged(abIsVampire)
  PrintMessage("Sent vampirism state changed for " + self.GetFullID(akActor) + " to " + abIsVampire)
EndEvent

Event OnConsoleSendLycanthropyStateChanged(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SendLycanthropyStateChanged(bool abIsVampire)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  bool abIsVampire = self.BoolFromSArgument(sArgument, 1)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.SendLycanthropyStateChanged(abIsVampire)
  PrintMessage("Sent lycanthropy state changed for " + self.GetFullID(akActor) + " to " + abIsVampire)
EndEvent

Event OnConsoleSetAttackActorOnSight(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetAttackActorOnSight(bool abAttackOnSight = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  bool abAttackOnSight = self.BoolFromSArgument(sArgument, 1)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.SetAttackActorOnSight(abAttackOnSight)
  PrintMessage("Set attack actor on sight for " + self.GetFullID(akActor) + " to " + abAttackOnSight)
EndEvent

Event OnConsoleSetDontMove(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetDontMove(bool abDontMove = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  bool abDontMove = self.BoolFromSArgument(sArgument, 1)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.SetDontMove(abDontMove)
  PrintMessage("Set dont move for " + self.GetFullID(akActor) + " to " + abDontMove)
EndEvent

; ; Attach the actor to (or detach it from) a horse, cart, or other vehicle.
; ; akVehicle is the vehicle ref.  To detach the actor from its current vehicle, set akVehicle to None (or to the Actor itself). 
; Function SetVehicle( ObjectReference akVehicle ) native
Event OnConsoleShowGiftMenu(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ShowGiftMenu(bool abGivingGift, NOT IMPLEMENTED FormList apFilterList = None, bool abShowStolenItems = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  bool abGivingGift = self.BoolFromSArgument(sArgument, 1)
  bool abShowStolenItems = self.BoolFromSArgument(sArgument, 2, false)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ShowGiftMenu(abGivingGift, none, abShowStolenItems)
  PrintMessage("Showing gift menu of " + self.GetFullID(akActor) + " with giving gift " + abGivingGift)
EndEvent

; ; Starts Cannibal with the target 
; Function StartCannibal(Actor akTarget) native
Event OnConsoleStartCannibal(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: StartCannibal([Actor akActor = GetSelectedReference()], Actor akTarget)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Actor akTarget = self.RefFromSArgument(sArgument, 1) as Actor
  If akActor == none || akTarget == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.StartCannibal(akTarget)
  PrintMessage(self.GetFullID(akActor) + " is cannibalizing " + self.GetFullID(akTarget))
EndEvent

Event OnConsoleStartSneaking(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: StartSneaking([Actor akActor = GetSelectedReference()])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If !akActor
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.StartSneaking()
  PrintMessage(self.GetFullID(akActor) + " is sneaking")
EndEvent

Event OnConsoleGetActorbaseOutfit(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorbaseOutfit([Actorbase akActorbase = GetSelectedReference().GetActorBase()], bool abSleepOutfit = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  bool abSleepOutfit = self.BoolFromSArgument(sArgument, 1, false)
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  Outfit akOutfit =  akActorbase.GetOutfit(abSleepOutfit)
  If abSleepOutfit
    PrintMessage("Sleeping outfit of " + self.GetFullID(akActorbase) + " is " + self.GetFullID(akOutfit))
  Else
    PrintMessage("Outfit of " + self.GetFullID(akActorbase) + " is " + self.GetFullID(akOutfit))
  EndIf
EndEvent

Event OnConsoleSetActorOutfit(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorOutfit([Actor akActor = GetSelectedReference()], Outfit akOutfit, bool abSleepOutfit = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Outfit akOutfit = self.FormFromSArgument(sArgument, 1) as Outfit
  bool abSleepOutfit = self.BoolFromSArgument(sArgument, 2, false)
  If akActor == none || akOutfit == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.SetOutfit(akOutfit, abSleepOutfit)
  If abSleepOutfit
    PrintMessage("Set sleeping outfit of " + self.GetFullID(akActor) + " to " + self.GetFullID(akOutfit))
  Else
    PrintMessage("Set outfit of " + self.GetFullID(akActor) + " to " + self.GetFullID(akOutfit))
  EndIf
EndEvent

Event OnConsoleUnsetActorOutfit(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: UnsetActorOutfit([Actor akActor = GetSelectedReference()], bool abSleepOutfit = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Outfit EmptyOutfit
  If Game.IsPluginInstalled("V_EmptyOutfit.esp")
    EmptyOutfit = Game.GetFormFromFile(0x800,"V_EmptyOutfit.esp") as Outfit
  Else
    PrintMessage("This function requires V_EmptyOutfit.esp to be installed")
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  bool abSleepOutfit = self.BoolFromSArgument(sArgument, 2, false)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.SetOutfit(EmptyOutfit, abSleepOutfit)
  If abSleepOutfit
    PrintMessage("Unset sleeping outfit of " + self.GetFullID(akActor))
  Else
    PrintMessage("Unset outfit of " + self.GetFullID(akActor))
  EndIf
EndEvent

Event OnConsoleSetActorbaseOutfit(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorbaseOutfit([Actor akActor = GetSelectedReference().GetActorBase()], Outfit akOutfit, bool abSleepOutfit = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  Outfit akOutfit = self.FormFromSArgument(sArgument, 1) as Outfit
  bool abSleepOutfit = self.BoolFromSArgument(sArgument, 2, false)
  If akActorbase == none || akOutfit == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActorbase.SetOutfit(akOutfit, abSleepOutfit)
  If abSleepOutfit
    PrintMessage("Set sleeping outfit of " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akOutfit))
  Else
    PrintMessage("Set outfit of " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akOutfit))
  EndIf
EndEvent

Event OnConsoleUnsetActorbaseOutfit(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: UnsetActorbaseOutfit([Actor akActor = GetSelectedReference().GetActorBase()], bool abSleepOutfit = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Outfit EmptyOutfit
  If Game.IsPluginInstalled("V_EmptyOutfit.esp")
    EmptyOutfit = Game.GetFormFromFile(0x800,"V_EmptyOutfit.esp") as Outfit
  Else
    PrintMessage("This function requires V_EmptyOutfit.esp to be installed")
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  bool abSleepOutfit = self.BoolFromSArgument(sArgument, 2, false)
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActorbase.SetOutfit(EmptyOutfit, abSleepOutfit)
  If abSleepOutfit
    PrintMessage("Unset sleeping outfit of " + self.GetFullID(akActorbase))
  Else
    PrintMessage("Unset outfit of " + self.GetFullID(akActorbase))
  EndIf
EndEvent

Event OnConsoleVCSEquipItemEx(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: VCSEquipItem(Form akForm, int aiEquipSlot = 0, bool preventUnequip = false, bool equipSound = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Form akForm = self.FormFromSArgument(sArgument, 1)
  int aiEquipSlot = self.IntFromSArgument(sArgument, 2)
  bool preventUnequip = self.BoolFromSArgument(sArgument, 3, false)
  bool equipSound = self.BoolFromSArgument(sArgument, 4, true)
  If akActor == none || akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.EquipItemEx(akForm, aiEquipSlot, preventUnequip, equipSound)
  PrintMessage("Equipped " + self.GetFullID(akForm) + " to " + self.GetFullID(akActor))
EndEvent

Event OnConsoleVCSUnequipItemEx(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: VCSUnequipItem(Form akForm, int aiEquipSlot = 0, bool preventEquip = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Form akForm = self.FormFromSArgument(sArgument, 1)
  int aiEquipSlot = self.IntFromSArgument(sArgument, 2)
  bool preventEquip = self.BoolFromSArgument(sArgument, 3, false)
  If akActor == none || akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.UnequipItemEx(akForm, aiEquipSlot, preventEquip)
  PrintMessage("Unequipped " + self.GetFullID(akForm) + " from " + self.GetFullID(akActor))
EndEvent

Event OnConsoleVCSEquipShout(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: VCSEquipShout(Shout akShout)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Shout akShout = self.FormFromSArgument(sArgument, 1) as Shout
  If akActor == none || akShout == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.EquipShout(akShout)
  PrintMessage("VCSEquipShout " + self.GetFullID(akActor) + " " + self.GetFullID(akShout))
EndEvent

Event OnConsoleVCSEquipSpell(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: VCSEquipSpell(Spell akSpell, int aiSource)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  int aiSource = self.IntFromSArgument(sArgument, 2)
  If akActor == none || akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.EquipSpell(akSpell, aiSource)
  PrintMessage("VCSEquipSpell " + self.GetFullID(akActor) + " " + self.GetFullID(akSpell))
EndEvent

Event OnConsoleSetRestrained(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetRestrained(bool abRestrained = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  bool abRestrained = self.BoolFromSArgument(sArgument, 1, true)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.SetRestrained(abRestrained)
  PrintMessage("SetRestrained " + self.GetFullID(akActor) + " to " + abRestrained)
EndEvent

Event OnConsoleRemoveAllArmorRefOverrides(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAllArmorRefOverrides(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.RemoveAllReferenceOverrides(akActor)
  PrintMessage("Removed all armor overrides from " + self.GetFullID(akActor))
EndEvent

Event OnConsoleRemoveAllPerks(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAllPerks(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int result = ProteusDLLUtils.RemoveAllPerks(akActor)
  if result == 0
    PrintMessage("Failed to remove all perks from " + self.GetFullID(akActor))
    Return
  EndIf
  PrintMessage("All perks removed from " + self.GetFullID(akActor))
EndEvent

Event OnConsoleRemoveAllVisiblePerks(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAllVisiblePerks(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int result = ProteusDLLUtils.RemoveAllVisiblePerks(akActor)
  If result == 0
    PrintMessage("Failed to remove all visible perks from " + self.GetFullID(akActor))
    Return
  EndIf
  PrintMessage("All visible perks removed from " + self.GetFullID(akActor))
EndEvent

Event OnConsoleRemoveAllSpells(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAllSpells(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  ProteusDLLUtils.RemoveAllSpells(akActor)
  PrintMessage("RemoveAllSpells " + self.GetFullID(akActor))
EndEvent

Event OnConsoleRGBToInt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RGBToInt(Int R, Int G, Int B)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int R = self.IntFromSArgument(sArgument, 1)
  int G = self.IntFromSArgument(sArgument, 2)
  int B = self.IntFromSArgument(sArgument, 3)
  ; If R == none || G == none || B == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  int result = DbColorFunctions.RGBToInt(R, G, B)
  PrintMessage("Color is " + result)
EndEvent


;
; NiOverride.psc
;

;; UniqueID
Event OnConsoleGetItemUniqueID(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetItemUniqueID(ObjectReference akActor, int weaponSlot, int slotMask, bool makeUnique = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  int weaponSlot = self.IntFromSArgument(sArgument, 1)
  int slotMask = self.IntFromSArgument(sArgument, 2)
  bool makeUnique = self.BoolFromSArgument(sArgument, 3, true)
  int itemUID = NiOverride.GetItemUniqueID(akActor as ObjectReference, weaponSlot, slotMask, makeUnique)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Made item in weapon slot " + weaponSlot + " slot mask " + slotMask + " with id " + itemUID + " to owner " + self.GetFullID(akActor))
EndEvent

Event OnConsoleGetObjectUniqueID(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetObjectUniqueID(ObjectReference akObject, bool makeUnique = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akObject = ConsoleUtil.GetSelectedReference()
  bool makeUnique = self.BoolFromSArgument(sArgument, 3, true)
  If akObject == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int ObjectUID = NiOverride.GetObjectUniqueID(akObject, makeUnique)
  PrintMessage("Getting object " + self.GetFullID(akObject) + " with id " + ObjectUID)
EndEvent

Event OnConsoleGetItemDyeColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetItemDyeColor(int uniqueId, int maskIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int maskIndex = self.IntFromSArgument(sArgument, 2)
  int color = NiOverride.GetItemDyeColor(uniqueId, maskIndex)
  ; If uniqueId == none || maskIndex == none || color == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  PrintMessage("GetItemDyeColor " + uniqueId + " " + maskIndex + ": " + IntToHex(color))
EndEvent


;; DyeColor
;;; Item DyeColor
Event OnConsoleSetItemDyeColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetItemDyeColor(int uniqueId, int maskIndex, Int R, Int G, Int B)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int maskIndex = self.IntFromSArgument(sArgument, 2)
  int R = self.IntFromSArgument(sArgument, 3)
  int G = self.IntFromSArgument(sArgument, 4)
  int B = self.IntFromSArgument(sArgument, 5)
  int color = DbColorFunctions.RGBToInt(R, G, B)
  ; If uniqueId == none || maskIndex == none || color == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  NiOverride.SetItemDyeColor(uniqueId, maskIndex, color)
  PrintMessage("SetItemDyeColor " + uniqueId + " " + maskIndex + " " + color)
EndEvent

Event OnConsoleClearItemDyeColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearItemDyeColor(int uniqudId, int maskIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int maskIndex = self.IntFromSArgument(sArgument, 2)
  ; If uniqueId == none || maskIndex == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  NiOverride.ClearItemDyeColor(uniqueId, maskIndex)
  PrintMessage("Cleared dye color of item " + uniqueID + " of mask index " + maskIndex)
EndEvent

Event OnConsoleUpdateItemDyeColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: UpdateItemDyeColor(ObjectReference akActor, int uniqueId)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.UpdateItemDyeColor(akActor, uniqueId)
  PrintMessage("Updated item " + uniqueID + " of actor " + self.GetFullID(akActor))
EndEvent

;;; Texture DyeColor
Event OnConsoleSetItemTextureLayerColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetItemTextureLayerColor(int uniqueId, int textureIndex, int layer, int R, Int G, Int B)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int textureIndex = self.IntFromSArgument(sArgument, 2)
  int layer = self.IntFromSArgument(sArgument, 3)
  int R = self.IntFromSArgument(sArgument, 4)
  int G = self.IntFromSArgument(sArgument, 5)
  int B = self.IntFromSArgument(sArgument, 6)
  int color = DbColorFunctions.RGBToInt(R, G, B)
  ; If uniqueId == none || textureIndex == none || layer == none || color == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  NiOverride.SetItemTextureLayerColor(uniqueId, textureIndex, layer, color)
  PrintMessage("SetItemTextureLayerColor " + uniqueId + " " + textureIndex + " " + layer + " " + color)
EndEvent

Event OnConsoleGetItemTextureLayerColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetItemTextureLayerColor(int uniqueId, int textureIndex, int layer)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int textureIndex = self.IntFromSArgument(sArgument, 2)
  int layer = self.IntFromSArgument(sArgument, 3)
  ; If uniqueId == none || textureIndex == none || layer == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  int color = NiOverride.GetItemTextureLayerColor(uniqueId, textureIndex, layer)
  PrintMessage("GetItemTextureLayerColor " + uniqueId + " " + textureIndex + " " + layer + " " + color)
EndEvent

Event OnConsoleClearItemTextureLayerColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearItemTextureLayerColor(int uniqueId, int textureIndex, int layer)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int textureIndex = self.IntFromSArgument(sArgument, 2)
  int layer = self.IntFromSArgument(sArgument, 3)
  ; If uniqueId == none || textureIndex == none || layer == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  NiOverride.ClearItemTextureLayerColor(uniqueId, textureIndex, layer)
  PrintMessage("ClearItemTextureLayerColor " + uniqueId + " " + textureIndex + " " + layer)
EndEvent

Event OnConsoleSetItemTextureLayerType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetItemTextureLayerType(int uniqueId, int textureIndex, int layer, int type)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int textureIndex = self.IntFromSArgument(sArgument, 2)
  int layer = self.IntFromSArgument(sArgument, 3)
  int type = self.IntFromSArgument(sArgument, 4)
  ; If uniqueId == none || textureIndex == none || layer == none || type == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  NiOverride.SetItemTextureLayerType(uniqueId, textureIndex, layer, type)
  PrintMessage("SetItemTextureLayerType " + uniqueId + " " + textureIndex + " " + layer + " " + type)
EndEvent

Event OnConsoleGetItemTextureLayerType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetItemTextureLayerType(int uniqueId, int textureIndex, int layer)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int textureIndex = self.IntFromSArgument(sArgument, 2)
  int layer = self.IntFromSArgument(sArgument, 3)
  ; If uniqueId == none || textureIndex == none || layer == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  int type = NiOverride.GetItemTextureLayerType(uniqueId, textureIndex, layer)
  PrintMessage("GetItemTextureLayerType " + uniqueId + " " + textureIndex + " " + layer + " " + type)
EndEvent

Event OnConsoleClearItemTextureLayerType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearItemTextureLayerType(int uniqueId, int textureIndex, int layer)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int textureIndex = self.IntFromSArgument(sArgument, 2)
  int layer = self.IntFromSArgument(sArgument, 3)
  ; If uniqueId == none || textureIndex == none || layer == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  NiOverride.ClearItemTextureLayerType(uniqueId, textureIndex, layer)
  PrintMessage("ClearItemTextureLayerType " + uniqueId + " " + textureIndex + " " + layer)
EndEvent

Event OnConsoleSetItemTextureLayerTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetItemTextureLayerTexture(int uniqueId, int textureIndex, int layer, string texture)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int textureIndex = self.IntFromSArgument(sArgument, 2)
  int layer = self.IntFromSArgument(sArgument, 3)
  string texture = self.StringFromSArgument(sArgument, 4)
  ; If uniqueId == none || textureIndex == none || layer == none || texture == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  NiOverride.SetItemTextureLayerTexture(uniqueId, textureIndex, layer, texture)
  PrintMessage("SetItemTextureLayerTexture " + uniqueId + " " + textureIndex + " " + layer + " " + texture)
EndEvent

Event OnConsoleGetItemTextureLayerTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetItemTextureLayerTexture(int uniqueId, int textureIndex, int layer)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int textureIndex = self.IntFromSArgument(sArgument, 2)
  int layer = self.IntFromSArgument(sArgument, 3)
  ; If uniqueId == none || textureIndex == none || layer == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  string texture = NiOverride.GetItemTextureLayerTexture(uniqueId, textureIndex, layer)
  PrintMessage("GetItemTextureLayerTexture " + uniqueId + " " + textureIndex + " " + layer + " " + texture)
EndEvent

Event OnConsoleClearItemTextureLayerTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearItemTextureLayerTexture(int uniqueId, int textureIndex, int layer)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int textureIndex = self.IntFromSArgument(sArgument, 2)
  int layer = self.IntFromSArgument(sArgument, 3)
  ; If uniqueId == none || textureIndex == none || layer == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  NiOverride.ClearItemTextureLayerTexture(uniqueId, textureIndex, layer)
  PrintMessage("ClearItemTextureLayerTexture " + uniqueId + " " + textureIndex + " " + layer)
EndEvent

Event OnConsoleSetItemTextureLayerBlendMode(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetItemTextureLayerBlendMode(int uniqueId, int textureIndex, int layer, string blendMode)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int textureIndex = self.IntFromSArgument(sArgument, 2)
  int layer = self.IntFromSArgument(sArgument, 3)
  string blendMode = self.StringFromSArgument(sArgument, 4)
  ; If uniqueId == none || textureIndex == none || layer == none || blendMode == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  NiOverride.SetItemTextureLayerBlendMode(uniqueId, textureIndex, layer, blendMode)
  PrintMessage("SetItemTextureLayerBlendMode " + uniqueId + " " + textureIndex + " " + layer + " " + blendMode)
EndEvent

Event OnConsoleGetItemTextureLayerBlendMode(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetItemTextureLayerBlendMode(int uniqueId, int textureIndex, int layer)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int textureIndex = self.IntFromSArgument(sArgument, 2)
  int layer = self.IntFromSArgument(sArgument, 3)
  ; If uniqueId == none || textureIndex == none || layer == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  string blendMode = NiOverride.GetItemTextureLayerBlendMode(uniqueId, textureIndex, layer)
  PrintMessage("GetItemTextureLayerBlendMode " + uniqueId + " " + textureIndex + " " + layer + " " + blendMode)
EndEvent

Event OnConsoleClearItemTextureLayerBlendMode(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearItemTextureLayerBlendMode(int uniqueId, int textureIndex, int layer)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int uniqueId = self.IntFromSArgument(sArgument, 1)
  int textureIndex = self.IntFromSArgument(sArgument, 2)
  int layer = self.IntFromSArgument(sArgument, 3)
  ; If uniqueId == none || textureIndex == none || layer == none
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  NiOverride.ClearItemTextureLayerBlendMode(uniqueId, textureIndex, layer)
  PrintMessage("ClearItemTextureLayerBlendMode " + uniqueId + " " + textureIndex + " " + layer)
EndEvent

Event OnConsoleUpdateItemTextureLayers(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: UpdateItemTextureLayers(ObjectReference akActor, int uniqueId)")

  ObjectReference akActor = self.RefFromSArgument(sArgument, 1)
  int uniqueId
  If QtyPars == 1
    akActor = ConsoleUtil.GetSelectedReference()
    uniqueId = self.IntFromSArgument(sArgument, 1)
  ElseIf QtyPars == 2
    akActor = self.RefFromSArgument(sArgument, 1)
    uniqueId = self.IntFromSArgument(sArgument, 2)
  EndIf
  If akActor == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.UpdateItemTextureLayers(akActor, uniqueId)
  PrintMessage("UpdateItemTextureLayers " + akActor + " " + uniqueId)
EndEvent


;; Overlays
Event OnConsoleRevertOverlays(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RevertOverlays(ObjectReference akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.RevertOverlays(akActor)
  PrintMessage("RevertOverlays" + self.GetFullID(akActor))
EndEvent

Event OnConsoleAddWeaponOverrideTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddWeaponOverrideTextureSet([ObjectReference akActor = GetSelectedReference()], bool isFemale, bool firstPerson, Weapon akWeapon, string node, int key, int index, TextureSet akTXST, bool persist = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  bool isFemale
  bool firstPerson
  Weapon akWeapon
  string node
  int keyid

  int index
  TextureSet akTXST

  bool persist
    akActor = ConsoleUtil.GetSelectedReference() as Actor
    isFemale = self.BoolFromSArgument(sArgument, 1)
    firstPerson = self.BoolFromSArgument(sArgument, 2)
    akWeapon = self.FormFromSArgument(sArgument, 3) as Weapon
    node = self.StringFromSArgument(sArgument, 4)
    keyid = self.IntFromSArgument(sArgument, 5)
    index = self.IntFromSArgument(sArgument, 6)
    akTXST = self.FormFromSArgument(sArgument, 7) as TextureSet
    persist = self.BoolFromSArgument(sArgument, 8, true)

  If QtyPars == 9 
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    isFemale = self.BoolFromSArgument(sArgument, 2)
    firstPerson = self.BoolFromSArgument(sArgument, 3)
    akWeapon = self.FormFromSArgument(sArgument, 4) as Weapon
    node = self.StringFromSArgument(sArgument, 5)
    keyid = self.IntFromSArgument(sArgument, 6)
    index = self.IntFromSArgument(sArgument, 7)
    akTXST = self.FormFromSArgument(sArgument, 8) as TextureSet
    persist = self.BoolFromSArgument(sArgument, 9, true)
  EndIf
  If akActor == none || akTXST == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.AddWeaponOverrideTextureSet(akActor, isFemale, firstPerson, akWeapon, node, keyid, index, akTXST, persist)
  PrintMessage("AddWeaponOverrideTextureSet " + self.GetFullID(akActor))
EndEvent

Event OnConsoleApplyWeaponOverrides(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ApplyWeaponOverrides(ObjectReference akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.ApplyWeaponOverrides(akActor)
  PrintMessage("ApplyWeaponOverrides " + self.GetFullID(akActor))
EndEvent

Event OnConsoleAddSkinOverrideTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: AddSkinOverrideTextureSet([ObjectReference akActor = GetSelectedReference()], bool isFemale, bool firstPerson, int slotMask, int key, int index, TextureSet akTXST, bool persist)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    PrintMessage("")
    PrintMessage("Shader Property IDs and Types:")
    PrintMessage("======================================================================================")
    PrintMessage("ID   | TYPE        | Name")
    PrintMessage("-----|-------------|----------------------------------------")
    PrintMessage("0    | int         | ShaderEmissiveColor")
    PrintMessage("1    | float       | ShaderEmissiveMultiple")
    PrintMessage("2    | float       | ShaderGlossiness")
    PrintMessage("3    | float       | ShaderSpecularStrength")
    PrintMessage("4    | float       | ShaderLightingEffect1")
    PrintMessage("5    | float       | ShaderLightingEffect2")
    PrintMessage("6    | TextureSet  | ShaderTextureSet")
    PrintMessage("7    | int         | ShaderTintColor")
    PrintMessage("8    | float       | ShaderAlpha")
    PrintMessage("9    | string      | ShaderTexture (index 0-8)")
    PrintMessage("20   | float       | ControllerStartStop (-1.0 for stop, any other akTXST for start time)")
    PrintMessage("21   | float       | ControllerStartTime")
    PrintMessage("22   | float       | ControllerStopTime")
    PrintMessage("23   | float       | ControllerFrequency")
    PrintMessage("24   | float       | ControllerPhase")
    PrintMessage("======================================================================================")
    Return
  EndIf
  
  Actor akActor
  bool isFemale
  bool firstPerson
  int slotMask
  int keyid
  int index
  TextureSet akTXST
  bool persist

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  isFemale = self.BoolFromSArgument(sArgument, 1)
  firstPerson = self.BoolFromSArgument(sArgument, 2)
  slotMask = self.IntFromSArgument(sArgument, 3)
  keyid = self.IntFromSArgument(sArgument, 4)
  index = self.IntFromSArgument(sArgument, 5)
  akTXST = self.FormFromSArgument(sArgument, 6) as TextureSet
  persist = self.BoolFromSArgument(sArgument, 7, true)
  If QtyPars == 8
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    isFemale = self.BoolFromSArgument(sArgument, 2)
    firstPerson = self.BoolFromSArgument(sArgument, 4)
    slotMask = self.IntFromSArgument(sArgument, 4)
    keyid = self.IntFromSArgument(sArgument, 5)
    index = self.IntFromSArgument(sArgument, 6)
    akTXST = self.FormFromSArgument(sArgument, 7) as TextureSet
    persist = self.BoolFromSArgument(sArgument, 8, true)
  EndIf

  ; Retrieve and validate arguments

  ; Check for critical errors
  If akActor == none || akTXST == none
    PrintMessage("ERROR: Unable to retrieve required Actor or TextureSet. Ensure the selected reference is valid and the TextureSet is correctly specified")
    Return
  EndIf

  ; Apply the texture set override
  NiOverride.AddSkinOverrideTextureSet(akActor, isFemale, firstPerson, slotMask, keyid, index, akTXST, persist)
  
  ; Verify if the texture set was applied successfully
  TextureSet appliedTextureSet = NiOverride.GetSkinOverrideTextureSet(akActor, isFemale, firstPerson, slotMask, keyid, index)
  
  If appliedTextureSet == akTXST
    PrintMessage("Successfully applied TextureSet override to actor: " + self.GetFullID(akActor))
    PrintMessage("Details:")
    PrintMessage("- Actor: " + akActor.GetDisplayName())
    PrintMessage("- Gender: " + IfElse(isFemale, "Female", "Male"))
    PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
    PrintMessage("- Slot Mask: " + slotMask)
    PrintMessage("- Key ID: " + keyid)
    PrintMessage("- Index: " + index)
    PrintMessage("- TextureSet: " + self.GetFullID(akTXST))
    PrintMessage("- Persist: " + IfElse(persist, "Yes", "No"))
  Else
    PrintMessage("WARNING: TextureSet override may not have been applied successfully")
    PrintMessage("Expected TextureSet: " + self.GetFullID(akTXST))
    PrintMessage("Applied TextureSet: " + IfElse(appliedTextureSet, self.GetFullID(appliedTextureSet), "None"))
  EndIf
EndEvent

Event OnConsoleApplySkinOverrides(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ApplySkinOverrides(ObjectReference akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.ApplySkinOverrides(akActor)
  PrintMessage("ApplySkinOverrides " + self.GetFullID(akActor))
EndEvent

Event OnConsoleGetOverrideTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetOverrideTextureSet([ObjectReference akActor = GetSelectedReference()], bool isFemale, Armor akArmor, ArmorAddon akAddon, string node, int key, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  bool isFemale
  Armor akArmor
  ArmorAddon akAddon
  string node
  int keyid
  int index
  If QtyPars == 6
    akActor = ConsoleUtil.GetSelectedReference() as Actor
    isFemale = self.BoolFromSArgument(sArgument, 1)
    akArmor = self.FormFromSArgument(sArgument, 2) as Armor
    akAddon = self.FormFromSArgument(sArgument, 3) as ArmorAddon
    node = self.StringFromSArgument(sArgument, 4)
    keyid = self.IntFromSArgument(sArgument, 5)
    index = self.IntFromSArgument(sArgument, 6)
  ElseIf  QtyPars == 7
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    isFemale = self.BoolFromSArgument(sArgument, 2)
    akArmor = self.FormFromSArgument(sArgument, 3) as Armor
    akAddon = self.FormFromSArgument(sArgument, 4) as ArmorAddon
    node = self.StringFromSArgument(sArgument, 5)
    keyid = self.IntFromSArgument(sArgument, 6)
    index = self.IntFromSArgument(sArgument, 7)
  EndIf
  If akActor == none || akArmor == none || akAddon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  TextureSet result = NiOverride.GetOverrideTextureSet(akActor, isFemale, akArmor, akAddon, node, keyid, index)
  PrintMessage("Override TextureSet for actor " + self.GetFullID(akActor) + " is " + self.GetFullID(result))
EndEvent

Event OnConsoleRemoveAAOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAAOverride([ObjectReference akActor = GetSelectedReference()], bool isFemale, Armor akArmor, ArmorAddon akAddon, string node, int key, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  bool isFemale = self.BoolFromSArgument(sArgument, 1)
  Armor akArmor = self.FormFromSArgument(sArgument, 2) as Armor
  ArmorAddon akAddon = self.FormFromSArgument(sArgument, 3) as ArmorAddon
  string node = self.StringFromSArgument(sArgument, 4)
  int keyid = self.IntFromSArgument(sArgument, 5)
  int index = self.IntFromSArgument(sArgument, 6)
  If akActor == none || akArmor == none || akAddon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.RemoveOverride(akActor, isFemale, akArmor, akAddon, node, keyid, index)
  PrintMessage("RemoveAAOverride " + self.GetFullID(akActor))
EndEvent

;;
; Object Manipulation Overhaul
;;
Event OnConsoleStartDraggingObject(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: StartDraggingObject(ObjectReference akRef)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  ObjectManipulationOverhaul.StartDraggingObject(akRef)
  PrintMessage("Started dragging " + self.GetFullID(akRef))
EndEvent

;;
;; WornObject.psc
;;
Event OnConsoleAddPackageOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddPackageOverride(Actor targetActor, Package targetPackage, int priority = 30, int flags = 0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor targetActor
  Package targetPackage
  If QtyPars == 1
    targetActor = ConsoleUtil.GetSelectedReference() as Actor
    targetPackage = self.FormFromSArgument(sArgument, 1) as Package
  ElseIf QtyPars == 2
    targetActor = self.FormFromSArgument(sArgument, 1) as Actor
    targetPackage = self.FormFromSArgument(sArgument, 2) as Package
  EndIf
  If targetActor == none || targetPackage == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int priority = self.IntFromSArgument(sArgument, 3, 30)
  int flags = self.IntFromSArgument(sArgument, 4, 0)
  ActorUtil.AddPackageOverride(targetActor, targetPackage, priority, flags)
  PrintMessage("AddPackageOverride Actor:" + targetActor + " Package:" + targetPackage + " Priority:" + priority + " Flags:" + flags)
EndEvent

Event OnConsoleRemovePackageOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemovePackageOverride(Actor targetActor, Package targetPackage)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor targetActor
  Package targetPackage
  If QtyPars == 1
    targetActor = ConsoleUtil.GetSelectedReference() as Actor
    targetPackage = self.FormFromSArgument(sArgument, 1) as Package
  ElseIf QtyPars == 2
    targetActor = self.FormFromSArgument(sArgument, 1) as Actor
    targetPackage = self.FormFromSArgument(sArgument, 2) as Package
  EndIf
  If targetActor == none || targetPackage == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  bool result = ActorUtil.RemovePackageOverride(targetActor, targetPackage)
  PrintMessage("RemovePackageOverride " + targetActor + " " + targetPackage + " Result: " + result)
EndEvent

Event OnConsoleCountPackageOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CountPackageOverride(Actor targetActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor targetActor
  
  If QtyPars == 0
    targetActor = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    targetActor = self.FormFromSArgument(sArgument, 1) as Actor
  EndIf

  If targetActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  int count = ActorUtil.CountPackageOverride(targetActor)
  PrintMessage("CountPackageOverride " + targetActor + " Count: " + count)
EndEvent

Event OnConsoleClearPackageOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearPackageOverride(Actor targetActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor targetActor
  
  If QtyPars == 0
    targetActor = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    targetActor = self.FormFromSArgument(sArgument, 1) as Actor
  EndIf

  If targetActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  int result = ActorUtil.ClearPackageOverride(targetActor)
  PrintMessage("ClearPackageOverride " + targetActor + " Result: " + result)
EndEvent

Event OnConsoleRemoveAllPackageOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAllPackageOverride(Package targetPackage)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  ; If QtyPars != 1
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  Package targetPackage = self.FormFromSArgument(sArgument, 1) as Package
  If targetPackage == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int result = ActorUtil.RemoveAllPackageOverride(targetPackage)
  PrintMessage("RemoveAllPackageOverride " + targetPackage + " Result: " + result)
EndEvent

;; 
;; _SE_SpellExtender
;;
Event OnConsoleSetSpellCost(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellCost(Spell akSpell, int aiCost)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  int aiCost = self.IntFromSArgument(sArgument, 2)
  If akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  _SE_SpellExtender.SetSpellCost(akSpell, aiCost)

  _SE_SpellExtender.Process()
  PrintMessage("SetSpellCost " + self.GetFullID(akSpell) + " " + aiCost)
EndEvent

Event OnConsoleSetChargeTimeAll(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetChargeTimeAll(Spell akSpell, float afTime)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ; If QtyPars != 2
  ;   PrintMessage("FATAL ERROR: FormID retrieval failed")
  ;   Return
  ; EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  float afTime = self.FloatFromSArgument(sArgument, 2)
  If akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  _SE_SpellExtender.SetChargeTimeAll(akSpell, afTime)

  _SE_SpellExtender.Process()
  PrintMessage("SetChargeTimeAll " + self.GetFullID(akSpell) + " to " + afTime)
EndEvent

Event OnConsoleSetSpellFlag(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellFlag(Spell akSpell, int aiFlag, bool abValue)")
  PrintMessage("SPELL FLAG HELP")
  PrintMessage("========================================")
  PrintMessage("- No Auto- Calc 0")
  PrintMessage("- Ignore Resistance 19")
  PrintMessage("- Area Effect Ignores Line of Sight 20")
  PrintMessage("- Disallow Spell Absorb/Reflect 21")
  PrintMessage("- No Dual Cast Modifications 23")
  PrintMessage("- PC Start Spell 17")
  PrintMessage("========================================")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ; If QtyPars != 3
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  int aiFlag = self.IntFromSArgument(sArgument, 2)
  bool abValue = self.BoolFromSArgument(sArgument, 3)
  If akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  _SE_SpellExtender.SetSpellFlag(akSpell, aiFlag, abValue as int)

  _SE_SpellExtender.Process()
  PrintMessage("SetSpellFlag " + self.GetFullID(akSpell) + " " + aiFlag + " " + abValue)
EndEvent

Event OnConsoleSpellFlagHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  PrintMessage("Format: SpellHelp")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("Valid Flags: Int Flag")
  PrintMessage("- No Auto-Calc: 0")
  PrintMessage("- Ignore Resistance: 19")
  PrintMessage("- Area Effect Ignores Line of Sight: 20")
  PrintMessage("- Disallow Spell Absorb/Reflect: 21")
  PrintMessage("- No Dual Cast Modifications: 23")
  PrintMessage("- PC Start Spell: 17")
EndEvent

;;
;; Camera
;;
Event OnConsoleGetWorldFOV(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetWorldFOV()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  float fov = Camera.GetWorldFOV()
  PrintMessage("GetWorldFOV Result: " + fov)
EndEvent

Event OnConsoleSetWorldFOV(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetWorldFOV(float fov)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ; If QtyPars != 1
  ;   PrintMessage("Syntax error")
  ;   Return
  ; EndIf
  float fov = self.FloatFromSArgument(sArgument, 1)
  Camera.SetWorldFOV(fov)
  PrintMessage("SetWorldFOV " + fov)
EndEvent

Event OnConsoleGetFirstPersonFOV(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFirstPersonFOV()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  float fov = Camera.GetFirstPersonFOV()
  PrintMessage("GetFirstPersonFOV Result: " + fov)
EndEvent

Event OnConsoleSetFirstPersonFOV(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetFirstPersonFOV(float fov)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  float fov = self.FloatFromSArgument(sArgument, 1)
  Camera.SetFirstPersonFOV(fov)
  PrintMessage("SetFirstPersonFOV " + fov)
EndEvent


;; 
;; DbSkseFunctions
;; 
Event OnConsoleSetClipBoardText(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetClipBoardText(string text)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  string result = DbMiscFunctions.RemovePrefixFromString(sArgument, StringFromSArgument(sArgument, 0) + " ")
  DbSkseFunctions.SetClipBoardText(result)
  PrintMessage("Set clipboard text to: " + result)
EndEvent

;; 
;; DescriptionFramework
;; 
Event OnConsoleSetDescription(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetDescription(Form akObject, string akDesc)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akObject = self.FormFromSArgument(sArgument, 1)
  string result = self.StringFromSArgument(sArgument, 2)
  DescriptionFramework.SetDescription(akObject, result)
  PrintMessage("Set description of " + GetFullID(akObject) + " as:")
  PrintMessage(result)
EndEvent

Event OnConsoleResetDescription(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ResetDescription(Form akObject)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akObject = self.FormFromSArgument(sArgument, 1)
  DescriptionFramework.ResetDescription(akObject)
  PrintMessage("ResetDescription " + self.GetFullID(akObject))
EndEvent

;;
;; Package
;;
Event OnConsolePackageGetTemplate(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetPackageTemplate(Package akPackage)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Package akPackage = self.FormFromSArgument(sArgument, 1) as Package
  string template = akPackage.GetTemplate()
  PrintMessage("GetPackageTemplate: " + template)
EndEvent

;;
;; SeasonsOfSkyrim
;;
Event OnConsoleGetSeasonOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSeasonOverride()")
  PrintMessage("SEASON HELP")
  PrintMessage("============")
  PrintMessage("Winter = 1")
  PrintMessage("Spring = 2")
  PrintMessage("Summer = 3")
  PrintMessage("Autumn = 4")
  PrintMessage("============")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  string season = SeasonsOfSkyrim.GetSeasonOverride()
  PrintMessage("GetSeasonOverride: " + season)
EndEvent

Event OnConsoleSetSeasonOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSeasonOverride(int aiSeason)")
  PrintMessage("============")
  PrintMessage("Winter = 1")
  PrintMessage("Spring = 2")
  PrintMessage("Summer = 3")
  PrintMessage("Autumn = 4")
  PrintMessage("============")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int aiSeason = self.IntFromSArgument(sArgument, 1)
  PrintMessage("SetSeasonOverride: " + aiSeason)
  SeasonsOfSkyrim.SetSeasonOverride(aiSeason)
EndEvent

Event OnConsoleClearSeasonOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearSeasonOverride()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  SeasonsOfSkyrim.ClearSeasonOverride()
  PrintMessage("Cleared season override")
EndEvent

Event OnConsoleMenuHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: MenuHelp()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  String[] MenuNames = new String[36]
    MenuNames[0] = "InventoryMenu"
    MenuNames[1] = "Console"
    MenuNames[2] = "Dialogue Menu"
    MenuNames[3] = "HUD Menu"
    MenuNames[4] = "Main Menu"
    MenuNames[5] = "MessageBoxMenu"
    MenuNames[6] = "Cursor Menu"
    MenuNames[7] = "Fader Menu"
    MenuNames[8] = "MagicMenu"
    MenuNames[9] = "Top Menu"
    MenuNames[10] = "Overlay Menu"
    MenuNames[11] = "Overlay Interaction Menu"
    MenuNames[12] = "Loading Menu"
    MenuNames[13] = "TweenMenu"
    MenuNames[14] = "BarterMenu"
    MenuNames[15] = "GiftMenu"
    MenuNames[16] = "Debug Text Menu"
    MenuNames[17] = "MapMenu"
    MenuNames[18] = "Lockpicking Menu"
    MenuNames[19] = "Quantity Menu"
    MenuNames[20] = "StatsMenu"
    MenuNames[21] = "ContainerMenu"
    MenuNames[22] = "Sleep/Wait Menu"
    MenuNames[23] = "LevelUp Menu"
    MenuNames[24] = "Journal Menu"
    MenuNames[25] = "Book Menu"
    MenuNames[26] = "FavoritesMenu"
    MenuNames[27] = "RaceSex Menu"
    MenuNames[28] = "Crafting Menu"
    MenuNames[29] = "Training Menu"
    MenuNames[30] = "Mist Menu"
    MenuNames[31] = "Tutorial Menu"
    MenuNames[32] = "Credits Menu"
    MenuNames[33] = "TitleSequence Menu"
    MenuNames[34] = "Console Native UI Menu"
    MenuNames[35] = "Kinect Menu"

  int i = 0
  While i < 36
    PrintMessage(MenuNames[i])
    i += 1
  EndWhile
EndEvent

;;
;; UI
;;


Event OnConsoleOpenCustomMenu(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: OpenCustomMenu(string swfPath, int aiFlags = 0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  string swfPath = self.StringFromSArgument(sArgument, 1)
  int aiFlags = self.IntFromSArgument(sArgument, 2)
  UI.OpenCustomMenu(swfPath, aiFlags)
  PrintMessage("Custom UI with path " + swfPath + " launched with flags " + aiFlags)
EndEvent

Event OnConsoleCloseCustomMenu(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CloseCustomMenu()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  UI.CloseCustomMenu()
  PrintMessage("Closed custom UI")
EndEvent

;;
;; UICallback
;;
Event OnConsoleCreateUICallback(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: UICallbackCreate(string asCallback, string asFunction)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  string asCallback = self.StringFromSArgument(sArgument, 1)
  string asFunction = self.StringFromSArgument(sArgument, 2)
  int handle = UICallback.Create(asCallback, asFunction)
  PrintMessage("UICallbackCreate " + asCallback + " " + asFunction + " Handle: " + handle)
EndEvent


;;
;; VampireFeedProxy
;;

Event OnConsoleVampireFeed(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: VampireFeed([Actor akTarget]) or VampireFeed([Actor akActor] [Actor akTarget])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akTarget = ConsoleUtil.GetSelectedReference() as Actor
  Actor akActor
  If QtyPars == 1
    akTarget = self.RefFromSArgument(sArgument, 1) as Actor
    If akActor == none
      PrintMessage("FATAL ERROR: FormID retrieval failed")
      Return
    EndIf
    VampireFeedProxy.VampireFeed(akTarget)
  ElseIf QtyPars == 2
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    akTarget = self.RefFromSArgument(sArgument, 2) as Actor
    If akActor == none || akTarget == none
      PrintMessage("FATAL ERROR: FormID retrieval failed")
      Return
    EndIf
    VampireFeedProxy.AnyVampireFeed(akActor, akTarget)
  EndIf
  
EndEvent


;;
;; ObjectReference
;;
Event OnConsoleBlockActivation(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: BlockActivation(ObjectReference akref, bool abBlock)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  bool abBlock = self.BoolFromSArgument(sArgument, 1)
  akRef.BlockActivation(abBlock)
  If abBlock
    PrintMessage("Blocking activation for " + self.GetFullID(akRef))
  Else
    PrintMessage("Unblocking activation for " + self.GetFullID(akRef))
  EndIf
EndEvent


;;
;; Actor Functions
;;

Event OnConsoleVCSAddPerk(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: VCSAddPerk(Actor akActor, Perk akPerk)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Perk akPerk = self.FormFromSArgument(sArgument, 1) as Perk
  If akActor == none || akPerk == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  If akActor.HasPerk(akPerk)
    PrintMessage(self.GetFullID(akActor) + " already has " + self.GetFullID(akPerk))
    Return
  Else
    akActor.AddPerk(akPerk)
    PrintMessage(self.GetFullID(akActor) + " successfully acquired " + self.GetFullID(akPerk))
  EndIf
EndEvent

Event OnConsoleVCSRemovePerk(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: VCSRemovePerk(Actor akActor, Perk akPerk)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Perk akPerk = self.FormFromSArgument(sArgument, 1) as Perk
  If akActor == none || akPerk == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  If akActor.HasPerk(akPerk)
    akActor.RemovePerk(akPerk)
    PrintMessage(self.GetFullID(akActor) + " successfully removed " + self.GetFullID(akPerk))
  Else
    PrintMessage(self.GetFullID(akActor) + " already does not have " + self.GetFullID(akPerk))
    Return
  EndIf
EndEvent

Event OnConsoleVCSAddBasePerk(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: VCSAddBasePerk(Actor akActor, Perk akPerk)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Perk akPerk = self.FormFromSArgument(sArgument, 1) as Perk
  If akActor == none || akPerk == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  bool result = PO3_SKSEFunctions.AddBasePerk(akActor, akPerk)
  If result
    PrintMessage(self.GetFullID(akActor) + " successfully Addd " + self.GetFullID(akPerk))
  Else 
    PrintMessage(self.GetFullID(akActor) + " failed to Add " + self.GetFullID(akPerk))
  EndIf
EndEvent

Event OnConsoleVCSAddBaseSpell(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: VCSAddBaseSpell(Actor akActor, Spell akSpell)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  If akActor == none || akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  bool result = PO3_SKSEFunctions.AddBaseSpell(akActor, akSpell)
  If result
    PrintMessage(self.GetFullID(akActor) + " successfully Addd " + self.GetFullID(akSpell))
  Else 
    PrintMessage(self.GetFullID(akActor) + " failed to Add " + self.GetFullID(akSpell))
  EndIf
EndEvent

Event OnConsoleVCSRemoveBasePerk(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: VCSRemoveBasePerk(Actor akActor, Perk akPerk)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Perk akPerk = self.FormFromSArgument(sArgument, 1) as Perk
  If akActor == none || akPerk == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  bool result = PO3_SKSEFunctions.RemoveBasePerk(akActor, akPerk)
  If result
    PrintMessage(self.GetFullID(akActor) + " successfully removed " + self.GetFullID(akPerk))
  Else 
    PrintMessage(self.GetFullID(akActor) + " failed to remove " + self.GetFullID(akPerk))
  EndIf
EndEvent

Event OnConsoleVCSRemoveBaseSpell(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: VCSRemoveBaseSpell(Actor akActor, Spell akSpell)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  If akActor == none || akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  bool result = PO3_SKSEFunctions.RemoveBaseSpell(akActor, akSpell)
  If result
    PrintMessage(self.GetFullID(akActor) + " successfully removed " + self.GetFullID(akSpell))
  Else 
    PrintMessage(self.GetFullID(akActor) + " failed to remove " + self.GetFullID(akSpell))
  EndIf
EndEvent

Event OnConsoleAllowPCDialogue(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AllowPCDialogue(bool abTalk)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  bool abTalk = self.BoolFromSArgument(sArgument, 1, true)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.AllowPCDialogue(abTalk)
  PrintMessage("Allowed PC dialogue for " + self.GetFullID(akActor))
EndEvent

Event OnConsoleMakePlayerFriend(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: MakePlayerFriend(bool abTalk)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.MakePlayerFriend()
  PrintMessage("Made " + self.GetFullID(akActor) + " a friend")
EndEvent

Event OnConsolePreventDetection(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PreventDetection [<Actor akActor>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.PreventActorDetection(akActor)
  PrintMessage("Prevented detection of " + self.GetFullID(akActor))
EndEvent

Event OnConsoleRegenerateHead(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RegenerateHead [<Actor akActor>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.RegenerateHead()
  PrintMessage("Regenerated head of " + self.GetFullID(akActor))
EndEvent

Event OnConsoleKillSilent(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: KillSilent [<Actor akActor>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.KillSilent()
  PrintMessage("Killed " + self.GetFullID(akActor))
EndEvent

Event OnConsoleKillEssential(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: KillEssential [<Actor akActor>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.KillEssential()
  PrintMessage("Killed " + self.GetFullID(akActor))
EndEvent

Event OnConsolePathToReference(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PathToReference [<Actor akActor>] <ObjectReference akRef> <float afWalkRunPercent>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  ObjectReference akRef
  float afWalkRunPercent
  If QtyPars == 2
    akActor = ConsoleUtil.GetSelectedReference() as Actor
    akRef = self.RefFromSArgument(sArgument, 1)
    afWalkRunPercent = self.FloatFromSArgument(sArgument, 2)
  ElseIf QtyPars == 3
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    akRef = self.RefFromSArgument(sArgument, 2)
    afWalkRunPercent = self.FloatFromSArgument(sArgument, 3)
  EndIf
  If akActor == none || akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.PathToReference(akRef,afWalkRunPercent)
  PrintMessage("Pathed " + self.GetFullID(akActor) + " to " + self.GetFullID(akRef) + " at " + afWalkRunPercent + " speed")
EndEvent

Event OnConsoleClearForcedMovement(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearForcedMovement [<Actor akActor>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ClearForcedMovement()
  PrintMessage("Cleared forced movement for " + self.GetFullID(akActor))
EndEvent

Event OnConsoleSetUnconscious(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetUnconscious [<Actor akActor>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.SetUnconscious()
  PrintMessage("Set " + self.GetFullID(akActor) + " unconscious")
EndEvent

Event OnConsoleGetNthHeadPart(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNthHeadPart [<Actorbase akActorbase>] <int slotPart>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetBaseObject() as ActorBase
  int slotPart
  If QtyPars == 1
    slotPart = self.IntFromSArgument(sArgument, 1)
  Else
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
    slotPart = self.IntFromSArgument(sArgument, 2)
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("Headpart " + slotPart + " of " + self.GetFullID(akActorBase) + " is " + self.GetFullID(akActorbase.GetNthHeadPart(slotPart)))
EndEvent

Event OnConsoleSetNthHeadPart(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetNthHeadPart [<Actorbase akActorbase>] <int slotPart> <HeadPart akHeadPart>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetBaseObject() as ActorBase
  Headpart akHeadPart
  int slotPart
  If QtyPars == 2
    slotPart = self.IntFromSArgument(sArgument, 1)
    akHeadPart = self.FormFromSArgument(sArgument, 2) as HeadPart
  Else
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
    slotPart = self.IntFromSArgument(sArgument, 2)
    akHeadPart = self.FormFromSArgument(sArgument, 3) as HeadPart
  EndIf
  If akActorbase == none || akHeadPart == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Headpart akOldHeadpart = akActorbase.GetNthHeadPart(slotPart)
  PrintMessage("Headpart " + slotPart + " of " + self.GetFullID(akActorBase) + " is currently " + self.GetFullID(akOldHeadpart) + ". Attempting to change to " + self.GetFullID(akHeadPart))
  akActorBase.SetNthHeadPart(akHeadPart, slotPart)
  HeadPart akNewHeadpart = akActorbase.GetNthHeadPart(slotPart)
  If akHeadPart == akNewHeadpart
    PrintMessage("Success!")
  EndIf
  PrintMessage("Headpart " + slotPart + " of " + self.GetFullID(akActorBase) + " is now " + self.GetFullID(akNewHeadpart))
EndEvent

Event OnConsoleGetDoorDestination(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetDoorDestination(<ObjectReference akDoor = GetSelectedReference()>)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("Must be used with a selected reference")
  ObjectReference akDoor = ConsoleUtil.GetSelectedReference()
  If akDoor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  ObjectReference akDestination = PO3_SKSEFunctions.GetDoorDestination(akDoor)
  PrintMessage("Destination of " + self.GetFullID(akDoor) + " is " + self.GetFullID(akDestination))
EndEvent

Event OnConsoleSetDoorDestination(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetDoorDestination([<ObjectReference akDoor = GetSelectedReference()>], ObjectReference akDestination)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("Must be used with a selected reference")
  ObjectReference akDoor = ConsoleUtil.GetSelectedReference()
  If !IsLoadDoor(akDoor)
    PrintMessage(self.GetFullID(akDoor) + " is not a load door. This must be set in CreationKit")
    PrintMessage("You might want to try attaching a teleport script to it instead")
    Return
  EndIf
  ObjectReference akDestination = self.RefFromSArgument(sArgument, 1)
  If akDoor == none || akDestination == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  bool success = PO3_SKSEFunctions.SetDoorDestination(akDestination, akDoor)
  ObjectReference finalDestination = PO3_SKSEFunctions.GetDoorDestination(akDoor) ; :O
  If success
    PrintMessage("Successfully set destination of door " + self.GetFullID(akDoor) + " to " + self.GetFullID(finalDestination))
  Else
    PrintMessage("Failed to set " + self.GetFullID(akDoor) + " destination to " + self.GetFullID(akDestination))
    PrintMessage("Destination of door " + self.GetFullID(akDoor) + " is still " + self.GetFullID(finalDestination))
  EndIf
EndEvent

Event OnConsoleDuplicate(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: Duplicate([bool abAtMe = false], [bool abStartMoving = true])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("Must be used with a selected reference")
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  bool abAtMe = self.BoolFromSArgument(sArgument, 1, false)
  bool abStartMoving = self.BoolFromSArgument(sArgument, 2, true)
  Form akForm = akRef.GetBaseObject()
  ObjectReference newRef
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  If abAtMe
    newRef = PlayerRef.PlaceAtMe(akForm)
    PrintMessage("Duplicated " + self.GetFullID(akForm) + " as " + self.GetFullID(newRef) + " at player")
  Else
    newRef = akRef.PlaceAtMe(akForm)
    PrintMessage("Duplicated " + self.GetFullID(akForm) + " as " + self.GetFullID(newRef) + " at " + self.GetFullID(akRef))
  EndIf
  If abStartMoving
    ObjectManipulationOverhaul.StartDraggingObject(newRef)
  EndIf
EndEvent

Event OnConsoleSetLinkedRef(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLinkedRef(ObjectReference akRef, ObjectReference akTargetRef, Keyword akKeyword = None)")
  PrintMessage("Pass None into akTargetRef to unset the linked ref")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("Must be used with a selected reference")
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  ObjectReference akTargetRef = self.RefFromSArgument(sArgument, 1)
  Keyword akKeyword = self.FormFromSArgument(sArgument, 2) as Keyword
  
  If akKeyword == none
    akKeyword = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 2))
  EndIf

  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  If akTargetRef == none
    PO3_SKSEFunctions.SetLinkedRef(akRef, none)
    PrintMessage("Unset linked refs to " + self.GetFullID(akRef))
  Else
    PO3_SKSEFunctions.SetLinkedRef(akRef, akTargetRef, akKeyword)
    PrintMessage("Set " + self.GetFullID(akRef) + " linked to " + self.GetFullID(akTargetRef) + " with keyword " + self.GetFullID(akKeyword))
  EndIf
EndEvent

Event OnConsoleRemoveAllItems(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAllItems(ObjectReference Ref, ObjectReference otherContainer = none, bool abSilent = true, float delay = 0.01, bool abNoEquipped = false, bool abNoFavorited = false, bool abNoQuestItem = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  ObjectReference Ref = ConsoleUtil.GetSelectedReference()
  ObjectReference otherContainer = self.RefFromSArgument(sArgument, 2) as ObjectReference
  bool abSilent = self.BoolFromSArgument(sArgument, 3, true)
  float delay = self.FloatFromSArgument(sArgument, 4, 0.01)
  bool abNoEquipped = self.BoolFromSArgument(sArgument, 5, false)
  bool abNoFavorited = self.BoolFromSArgument(sArgument, 6, false)
  bool abNoQuestItem = self.BoolFromSArgument(sArgument, 7, true)
  
  If Ref == none
      PrintMessage("FATAL ERROR: FormID retrieval failed")
      Return
  EndIf
  
  DbMiscFunctions.RemoveAllItems(Ref, otherContainer, abSilent, delay, abNoEquipped, abNoFavorited, abNoQuestItem)
  PrintMessage("Removed all items from " + self.GetFullID(Ref))
EndEvent

Event OnConsoleGetAllFormsWithScriptAttached(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllFormsWithScriptAttached(string sScriptName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  String sScriptName = self.StringFromSArgument(sArgument, 1)
  
  Form[] forms = DbSKSEFunctions.GetAllFormsWithScriptAttached(sScriptName)
  
  Int i = 0
  While i < forms.Length
      PrintMessage("Form: " + self.GetFullID(forms[i]))
      i += 1
  EndWhile
EndEvent

Event OnConsoleGetAllAliasesWithScriptAttached(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllAliasesWithScriptAttached(string sScriptName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  String sScriptName = self.StringFromSArgument(sArgument, 1)
  
  Alias[] aliases = DbSKSEFunctions.GetAllAliasesWithScriptAttached(sScriptName)
  
  Int i = 0
  While i < aliases.Length
      PrintMessage("Alias: " + aliases[i].GetName() + " from quest " + aliases[i].GetOwningQuest())
      i += 1
  EndWhile
EndEvent

Event OnConsoleGetAllRefAliasesWithScriptAttached(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllRefAliasesWithScriptAttached(string sScriptName, bool onlyQuestObjects = false, bool onlyFilled = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  String sScriptName = self.StringFromSArgument(sArgument, 1)
  bool onlyQuestObjects = self.BoolFromSArgument(sArgument, 2, false)
  bool onlyFilled = self.BoolFromSArgument(sArgument, 3, false)
  
  ReferenceAlias[] refAliases = DbSKSEFunctions.GetAllRefAliasesWithScriptAttached(sScriptName, onlyQuestObjects, onlyFilled)
  
  Int i = 0
  While i < refAliases.Length
      PrintMessage("Reference Alias: " + refAliases[i].GetName() + " from quest " + refAliases[i].GetOwningQuest())
      i += 1
  EndWhile
EndEvent

Event OnConsoleGetLastMenuOpened(String EventName, String sArgument, Float fArgument, Form Sender)
    Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
    String lastMenu = DbSKSEFunctions.GetLastMenuOpened()
    If lastMenu == "" 
      PrintMessage("No menu found")
      Return
    EndIf
    PrintMessage("The last menu that was found is " + lastMenu)
EndEvent

Event OnConsoleActorValueHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("ActorValueHelp [<string helpString>]")

  PrintMessage("Actor Value Help")
  PrintMessage("======================================================================")

  String[] AVHelp = new String[128]
  AVHelp[0] = "Aggression"
  AVHelp[1] = "Confidence"
  AVHelp[2] = "Energy"
  AVHelp[3] = "Morality"
  AVHelp[4] = "Mood"
  AVHelp[5] = "Assistance"
  AVHelp[6] = "OneHanded"
  AVHelp[7] = "TwoHanded"
  AVHelp[8] = "Marksman"
  AVHelp[9] = "Block"
  AVHelp[10] = "Smithing"
  AVHelp[11] = "HeavyArmor"
  AVHelp[12] = "LightArmor"
  AVHelp[13] = "Pickpocket"
  AVHelp[14] = "Lockpicking"
  AVHelp[15] = "Sneak"
  AVHelp[16] = "Alchemy"
  AVHelp[17] = "Speechcraft"
  AVHelp[18] = "Alteration"
  AVHelp[19] = "Conjuration"
  AVHelp[20] = "Destruction"
  AVHelp[21] = "Illusion"
  AVHelp[22] = "Restoration"
  AVHelp[23] = "Enchanting"
  AVHelp[24] = "Health"
  AVHelp[25] = "Magicka"
  AVHelp[26] = "Stamina"
  AVHelp[27] = "HealRate"
  AVHelp[28] = "MagickaRate"
  AVHelp[29] = "StaminaRate"
  AVHelp[30] = "SpeedMult"
  AVHelp[31] = "InventoryWeight"
  AVHelp[32] = "carryWeight"
  AVHelp[33] = "criticalChance"
  AVHelp[34] = "meleeDamage"
  AVHelp[35] = "unarmedDamage"
  AVHelp[36] = "mass"
  AVHelp[37] = "Voicepoints"
  AVHelp[38] = "VoiceRate"
  AVHelp[39] = "DamageResist"
  AVHelp[40] = "PoisonResist"
  AVHelp[41] = "ResistFire"
  AVHelp[42] = "ResistShock"
  AVHelp[43] = "ResistFrost"
  AVHelp[44] = "ResistMagic"
  AVHelp[45] = "ResistDisease"
  AVHelp[46] = "perceptionCondition"
  AVHelp[47] = "enduranceCondition"
  AVHelp[48] = "leftAttackCondition"
  AVHelp[49] = "rightAttackCondition"
  AVHelp[50] = "leftMobilityCondition"
  AVHelp[51] = "rightMobilityCondition"
  AVHelp[52] = "brainCondition"
  AVHelp[53] = "paralysis"
  AVHelp[54] = "invisibility"
  AVHelp[55] = "nighteye"
  AVHelp[56] = "detectliferange"
  AVHelp[57] = "waterbreathing"
  AVHelp[58] = "waterwalking"
  AVHelp[59] = "ignorecrippledlimbs"
  AVHelp[60] = "fame"
  AVHelp[61] = "infamy"
  AVHelp[62] = "jumpingBonus"
  AVHelp[63] = "wardPower"
  AVHelp[64] = "rightItemCharge"
  AVHelp[65] = "ArmorPerks"
  AVHelp[66] = "shieldPerks"
  AVHelp[67] = "warddeflection"
  AVHelp[68] = "Variable01"
  AVHelp[69] = "Variable02 (HungerStaminaPenaltyAV)"
  AVHelp[70] = "Variable03 (ExhaustionMagickaPenaltyAV)"
  AVHelp[71] = "Variable04 (ColdHealthPenaltyAV)"
  AVHelp[72] = "Variable05"
  AVHelp[73] = "Variable06"
  AVHelp[74] = "Variable07"
  AVHelp[75] = "Variable08"
  AVHelp[76] = "Variable09 (WarmthRatingAV)"
  AVHelp[77] = "Variable10"
  AVHelp[78] = "bowSpeedBonus"
  AVHelp[79] = "favoractive"
  AVHelp[80] = "favorsPerDay"
  AVHelp[81] = "favorsPerDaytimer"
  AVHelp[82] = "leftItemCharge"
  AVHelp[83] = "absorbChance"
  AVHelp[84] = "blindness"
  AVHelp[85] = "weaponSpeedMult"
  AVHelp[86] = "shoutrecoveryMult"
  AVHelp[87] = "bowStaggerBonus"
  AVHelp[88] = "telekinesis"
  AVHelp[89] = "favorpointsBonus"
  AVHelp[90] = "lastbribedintimidated"
  AVHelp[91] = "lastflattered"
  AVHelp[92] = "movementNoiseMult"
  AVHelp[93] = "bypassvendorstolencheck"
  AVHelp[94] = "bypassvendorkeywordcheck"
  AVHelp[95] = "waitingforplayer"
  AVHelp[96] = "oneHandedModifier"
  AVHelp[97] = "twoHandedModifier"
  AVHelp[98] = "marksmanModifier"
  AVHelp[99] = "blockModifier"
  AVHelp[100] = "smithingModifier"
  AVHelp[101] = "HeavyArmorModifier"
  AVHelp[102] = "LightArmorModifier"
  AVHelp[103] = "pickpocketModifier"
  AVHelp[104] = "lockpickingModifier"
  AVHelp[105] = "sneakingModifier"
  AVHelp[106] = "alchemyModifier"
  AVHelp[107] = "speechcraftModifier"
  AVHelp[108] = "alterationModifier"
  AVHelp[109] = "conjurationModifier"
  AVHelp[110] = "destructionModifier"
  AVHelp[111] = "illusionModifier"
  AVHelp[112] = "restorationModifier"
  AVHelp[113] = "enchantingModifier"
  AVHelp[114] = "oneHandedSkillAdvance"
  AVHelp[115] = "twoHandedSkillAdvance"
  AVHelp[116] = "marksmanSkillAdvance"
  AVHelp[117] = "blockSkillAdvance"
  AVHelp[118] = "smithingSkillAdvance"
  AVHelp[119] = "HeavyArmorSkillAdvance"
  AVHelp[120] = "LightArmorSkillAdvance"
  AVHelp[121] = "pickpocketSkillAdvance"
  AVHelp[122] = "lockpickingSkillAdvance"
  AVHelp[123] = "sneakingSkillAdvance"
  AVHelp[124] = "alchemySkillAdvance"
  AVHelp[125] = "speechcraftSkillAdvance"
  AVHelp[126] = "alterationSkillAdvance"
  AVHelp[127] = "conjurationSkillAdvance"
  
  String[] AVHelp_2 = new String[128]
  AVHelp_2[0] = "destructionSkillAdvance"
  AVHelp_2[1] = "illusionSkillAdvance"
  AVHelp_2[2] = "restorationSkillAdvance"
  AVHelp_2[3] = "enchantingSkillAdvance"
  AVHelp_2[4] = "leftweaponSpeedMultiply"
  AVHelp_2[5] = "dragonsouls"
  AVHelp_2[6] = "combathealthregenMultiply"
  AVHelp_2[7] = "oneHandedPowerModifier"
  AVHelp_2[8] = "twoHandedPowerModifier"
  AVHelp_2[9] = "marksmanPowerModifier"
  AVHelp_2[10] = "blockPowerModifier"
  AVHelp_2[11] = "smithingPowerModifier"
  AVHelp_2[12] = "HeavyArmorPowerModifier"
  AVHelp_2[13] = "LightArmorPowerModifier"
  AVHelp_2[14] = "pickpocketPowerModifier"
  AVHelp_2[15] = "lockpickingPowerModifier"
  AVHelp_2[16] = "sneakingPowerModifier"
  AVHelp_2[17] = "alchemyPowerModifier"
  AVHelp_2[18] = "speechcraftPowerModifier"
  AVHelp_2[19] = "alterationPowerModifier"
  AVHelp_2[20] = "conjurationPowerModifier"
  AVHelp_2[21] = "destructionPowerModifier"
  AVHelp_2[22] = "illusionPowerModifier"
  AVHelp_2[23] = "restorationPowerModifier"
  AVHelp_2[24] = "enchantingPowerModifier"
  AVHelp_2[25] = "dragonrend"
  AVHelp_2[26] = "AttackDamageMult"
  AVHelp_2[27] = "healRateMult"
  AVHelp_2[28] = "MagickaRate"
  AVHelp_2[29] = "staminaRate"
  AVHelp_2[30] = "werewolfPerks"
  AVHelp_2[31] = "vampirePerks"
  AVHelp_2[32] = "grabactoroffset"
  AVHelp_2[33] = "grabbed"
  AVHelp_2[34] = "deprecated05"
  AVHelp_2[35] = "reflectDamage"
  String searchTerm = self.StringFromSArgument(sArgument, 1)
  Bool found = false
  Int i = 0

  While i < 128
    If StringUtil.Find(AVHelp[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(AVHelp[i])
      found = true
    EndIf
    If StringUtil.Find(AVHelp_2[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(AVHelp_2[i])
      found = true
    EndIf
    i += 1
  Endwhile

  if !found
    PrintMessage("No matching actor value found")
  endif
  PrintMessage("======================================================================")

EndEvent

Event OnConsoleCreateFormList(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CreateFormList(FormList fillerList = none)")

  FormList akFormList = DbSKSEFunctions.CreateFormList()

  If akFormList == none
    PrintMessage("Failed to create formlist")
    Return
  EndIf

  PrintMessage("Created formlist with form ID " + self.GetFullID(akFormList))
EndEvent

Event OnConsoleCreateKeyword(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CreateKeyword()")

  Keyword akKeyword = DbSKSEFunctions.CreateKeyword()

  If akKeyword == none
    PrintMessage("Failed to create keyword")
    Return
  EndIf

  PrintMessage("Created Keyword with form ID " + self.GetFullID(akKeyword))
EndEvent

Event OnConsoleCreateConstructibleObject(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CreateConstructibleObject()")

  ConstructibleObject akConstructible = DbSKSEFunctions.CreateConstructibleObject()

  If akConstructible == none
    PrintMessage("Failed to create ConstructibleObject")
    Return
  EndIf

  PrintMessage("Created ConstructibleObject with form ID " + self.GetFullID(akConstructible))
EndEvent

Event OnConsoleCreateTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CreateTextureSet()")

  TextureSet akTextureSet = DbSKSEFunctions.CreateTextureSet()

  If akTextureSet == none
    PrintMessage("Failed to create TextureSet")
    Return
  EndIf

  PrintMessage("Created TextureSet as " + self.GetFullID(akTextureSet))
EndEvent

Event OnConsoleGetAllConstructibleObjects(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllConstructibleObjects(Form akCreatedObject)")

  Form akCreatedObject = self.FormFromSArgument(sArgument, 1)
  If akCreatedObject == none
    akCreatedObject = self.GetSelectedBase()
  EndIf

  ConstructibleObject[] ConObjs = DbSkseFunctions.GetAllConstructibleObjects(akCreatedObject)

  Int i = 0
  While i < ConObjs.Length
      PrintMessage("ConstructibleObject #" + i + ": " + self.GetFullID(ConObjs[i]))
      i += 1
  EndWhile
EndEvent

Event OnConsoleGetAllActorPlayableSpells(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetPlayableSpells([Actor akActor = GetSelectedReference()])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  If QtyPars == 0
    akActor = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  PrintMessage("Getting spells for " + self.GetFullID(akActor))
  Spell[] ActorSpells = PO3_SKSEFunctions.GetAllActorPlayableSpells(akActor)
  int i = 0
  int L = ActorSpells.Length
  If L > 0
    PrintMessage("Found " + L + " spells")
  EndIf
  While i < ActorSpells.Length
    PrintMessage("Spell #" + i + ": " + ActorSpells[i])
    i += 1
  EndWhile
EndEvent

Event OnConsoleGetAshPileLinkedRef(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAshPileLinkedRef(ObjectReference akRef) ")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Ash pile is linked to " + self.GetFullID(GetAshPileLinkedRef(akRef)))
EndEvent

Event OnConsoleRemoveAllInventoryEventFilters(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAllInventoryEventFilters([ObjectReference akRef = GetSelectedReference()]) ")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akRef.RemoveAllInventoryEventFilters()
  PrintMessage("Inventory event filters removed from " + self.GetFullID(akRef))
EndEvent

Event OnConsoleSetActorOwner(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorOwner([ObjectReference akRef = GetSelectedReference()], ActorBase akActorBase) ")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  ActorBase akActorBase = self.FormFromSArgument(sArgument, 1) as ActorBase
  If akRef == none || akActorBase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akRef.SetActorOwner(akActorBase)
  PrintMessage(self.GetFullID(akActorBase) + " is now owner of " + self.GetFullID(akRef))
EndEvent

Event OnConsoleSetHarvested(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHarvested([ObjectReference akRef = GetSelectedReference()], bool abHarvested = false) ")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  bool abHarvested = self.BoolFromSArgument(sArgument, 1, false)
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akRef.SetHarvested(abHarvested)
  PrintMessage(self.GetFullID(akRef) + " is harvested: " + abHarvested)
EndEvent

Event OnConsoleSetOpen(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetOpen([ObjectReference akRef = GetSelectedReference()], bool abOpen = false) ")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  bool abOpen = self.BoolFromSArgument(sArgument, 1, false)
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akRef.SetOpen(abOpen)
  PrintMessage(self.GetFullID(akRef) + " is opened: " + abOpen)
EndEvent

Event OnConsoleGetCurrentScene(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetCurrentScene(ObjectReference akRef) ")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Actor " + self.GetFullID(akRef) + " is playing the scene " + self.GetFullID(akRef.GetCurrentScene()))
EndEvent

Event OnConsoleFreezeActor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: FreezeActor(Actor akActor, int aiType, bool abFreeze = true)")
  PrintMessage("TYPE HELP")
  PrintMessage("==========================================")
  PrintMessage("0  Disables AI (freeze in place)")
  PrintMessage("1  Paralyze (Paralyze with stiff ragdoll)")
  PrintMessage("==========================================")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  int aiType = self.IntFromSArgument(sArgument, 1)
  bool abFreeze = self.BoolFromSArgument(sArgument, 1, true)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.FreezeActor(akActor, aiType, abFreeze)
  PrintMessage(self.GetFullID(akActor) + " is frozen: " + abFreeze)
EndEvent

Event OnConsoleGetMaterialType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMaterialType(ObjectReference akRef, String asNodeName = \"\")")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  String asNodeName = self.StringFromSArgument(sArgument, 1)
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  String[] MaterialTypes = PO3_SKSEFunctions.GetMaterialType(akRef, asNodeName)
  Int i = 0
  Int L = MaterialTypes.Length
  If L > 0
    PrintMessage("Found " + L + " material types")
  Else
    PrintMessage("Found no material types")
    Return
  EndIf
  While i < L
    PrintMessage("Material type #" + i + ": " + MaterialTypes[i])
    i += 1
  EndWhile
EndEvent

Event OnConsoleGetActiveGamebryoAnimation(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActiveGamebryoAnimation(ObjectReference akRef)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  String animation = PO3_SKSEFunctions.GetActiveGamebryoAnimation(akRef)
  If animation == ""
    PrintMessage("Couldn't find animation. " + self.GetFullID(akRef) + " might not be playing anything")
    Return
  EndIf
  PrintMessage(self.GetFullID(akRef) + " is playing " + animation)
EndEvent

Event OnConsoleGetFootstepSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFootstepSet(ArmorAddon akArma)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ArmorAddon akArma = FormFromSArgument(sArgument, 1) as ArmorAddon

  If !akArma
    PrintMessage("Form retrieval failure")
    Return
  EndIf

  FootStepSet akFSS = PO3_SKSEFunctions.GetFootstepSet(akArma)
  PrintMessage("Footstep set is " + self.GetFullID(akFSS))
EndEvent

Event OnConsoleSetFootstepSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetFootstepSet(ArmorAddon akArma, FootstepSet akFootstepSet)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ArmorAddon akArma = FormFromSArgument(sArgument, 1) as ArmorAddon
  FootStepSet akOldFSS = PO3_SKSEFunctions.GetFootstepSet(akArma)
  FootStepSet akTargetFSS = FormFromSArgument(sArgument, 2) as FootStepSet

  If akArma == none || akNewFSS == none
    PrintMessage("Form retrieval failure")
    Return
  EndIf

  PrintMessage("Footstep set is " + self.GetFullID(akOldFSS))
  
  PrintMessage("Attempting to change it to " + self.GetFullID(akTargetFSS))

  PO3_SKSEFunctions.SetFootstepSet(akArma, akTargetFSS)
  
  FootStepSet akNewFSS = PO3_SKSEFunctions.GetFootstepSet(akArma)
  
  PrintMessage("Footstep set is now " + self.GetFullID(akNewFSS))

EndEvent

Event OnConsoleNiOverrideHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: NiOverrideHelp()")
  PrintMessage("Ni Override Types")
  PrintMessage("===========================================")
  PrintMessage("00 - integer    -       ShaderEmissiveColor")
  PrintMessage("01 - float      -       ShaderEmissiveMultiple")
  PrintMessage("02 - float      -       ShaderGlossiness")
  PrintMessage("03 - float      -       ShaderSpecularStrength")
  PrintMessage("04 - float      -       ShaderLightingEffect1")
  PrintMessage("05 - float      -       ShaderLightingEffect2")
  PrintMessage("06 - TextureSet -       ShaderTextureSet")
  PrintMessage("07 - integer    -       ShaderTintColor")
  PrintMessage("08 - float      -       ShaderAlpha")
  PrintMessage("09 - string     -       ShaderTexture (index 0-8)")
  PrintMessage("20 - float      -       ControllerStartStop (-1.0 for stop, anything else indicates start time)")
  PrintMessage("21 - float      -       ControllerStartTime")
  PrintMessage("22 - float      -       ControllerStopTime")
  PrintMessage("23 - float      -       ControllerFrequency")
  PrintMessage("24 - float      -       ControllerPhase")
EndEvent

Event OnConsoleSetHeadPartValidRaces(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHDPTValidRaces(HeadPart akHeadPart, FormList vRaces)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  HeadPart akHeadPart = self.FormFromSArgument(sArgument, 1) as HeadPart
  FormList vRaces = self.FormFromSArgument(sArgument, 2) as FormList
  If akHeadPart == none || vRaces == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
  EndIf
  akHeadPart.SetValidRaces(vRaces)
  PrintMessage(self.GetFullID(vRaces) + " set as valid races for " + self.GetFullID(akHeadPart))
EndEvent

Event OnConsoleGetKeywords(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetKeywords(Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  If !akForm
    akForm = self.GetSelectedBase()
  EndIf
  
  If akForm == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  Keyword[] result = akForm.GetKeywords()
  int L = result.Length
  If L > 0
    PrintMessage("Found " + L + " keywords")
  Else
    PrintMessage("Form does not have keywords")
    Return
  EndIf
  Int i = 0
  While i < L
    PrintMessage("Keyword #" + i + ": " + self.GetFullID(result[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleLearnEnchantment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: LearnEnchantment(Enchantment akEnchantment, bool abForget)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Enchantment akEnchantment = self.FormFromSArgument(sArgument, 1) as Enchantment
  bool abForget = self.BoolFromSArgument(sArgument, 2, false)
  If !akEnchantment
    akEnchantment = ConsoleUtil.GetSelectedReference().GetEnchantment()
    abForget = self.BoolFromSArgument(sArgument, 1, false)
  EndIf
  
  If akEnchantment == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  akEnchantment.SetPlayerKnows(!abForget)
  If akEnchantment.PlayerKnows()
    PrintMessage("Player now knows " + self.GetFullID(akEnchantment))
  Else
    PrintMessage("Player now does not know " + self.GetFullID(akEnchantment))
  EndIf
EndEvent

Event OnConsoleEnableSurvivalFeature(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: EnableSurvivalFeature(int aiFeature)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("HUD_INDICATORS    = 0")
  PrintMessage("INVENTORY_UI      = 1")
  PrintMessage("SLEEP_TO_LEVEL_UP = 2")
  PrintMessage("ARROW_WEIGHT      = 3")
  PrintMessage("LOCKPICK_WEIGHT   = 4")
  int aiFeature = self.IntFromSArgument(sArgument, 1)
  Survival.ForceEnable(aiFeature)
  PrintMessage("Enabled feature " + aiFeature)
EndEvent

Event OnConsoleDisableSurvivalFeature(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: DisableSurvivalFeature(int aiFeature)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("HUD_INDICATORS    = 0")
  PrintMessage("INVENTORY_UI      = 1")
  PrintMessage("SLEEP_TO_LEVEL_UP = 2")
  PrintMessage("ARROW_WEIGHT      = 3")
  PrintMessage("LOCKPICK_WEIGHT   = 4")
  int aiFeature = self.IntFromSArgument(sArgument, 1)
  Survival.UserDisable(aiFeature)
  PrintMessage("Disabled feature " + aiFeature)
EndEvent

Event OnConsoleRestoreColdLevel(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RestoreColdLevel(float coldRestoreAmount)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Float coldRestoreAmount = self.FloatFromSArgument(sArgument, 1)
  SurvivalModeImprovedApi.RestoreColdLevel(coldRestoreAmount)
  PrintMessage("Restored cold level by " + coldRestoreAmount + " points")
EndEvent

Event OnConsoleRestoreHungerLevel(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RestoreHungerLevel(float hungerRestoreAmount)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Float hungerRestoreAmount = self.FloatFromSArgument(sArgument, 1)
  SurvivalModeImprovedApi.RestoreHungerLevel(hungerRestoreAmount)
  PrintMessage("Restored hunger level by " + hungerRestoreAmount + " points")
EndEvent

Event OnConsoleRestoreExhaustionLevel(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RestoreExhaustionLevel(float exhaustionRestoreAmount)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Float exhaustionRestoreAmount = self.FloatFromSArgument(sArgument, 1)
  SurvivalModeImprovedApi.RestoreExhaustionLevel(exhaustionRestoreAmount)
  PrintMessage("Restored exhaustion level by " + exhaustionRestoreAmount + " points")
EndEvent

Event OnConsoleGetAllRefsInGrid(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllRefsInGrid()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference[] refs = SkyPal_References.Grid()
  Int i = 0
  Int L = refs.Length
  If L > 0
    PrintMessage("Found " + L + " references")
  Else
    PrintMessage("Found no references")
    Return
  EndIf
  While i < L
    PrintMessage("Reference #" + i + ": " + self.GetFullID(refs[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleGetButtonForDXScanCode(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetButtonForDXScanCode(int aiCode)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int aiCode = self.IntFromSArgument(sArgument, 1)
  String keyName = PyramidUtils.GetButtonForDXScanCode(aiCode)
  PrintMessage("Key is " + keyName)
EndEvent

Event OnConsoleCalmActor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CalmActor(Actor akActor, bool abDoCalm = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  bool abDoCalm = self.BoolFromSArgument(sArgument, 1, true)
  If akActor == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  If abDoCalm
    PrintMessage(self.GetFullID(akActor) + " was calmed")
  Else
    PrintMessage(self.GetFullID(akActor) + " is not calmed")
  EndIf
EndEvent

Event OnConsoleGetQuality(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetQuality(Apparatus akApparatus)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Apparatus akApparatus = self.FormFromSArgument(sArgument, 1) as Apparatus
  If akApparatus == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Quality of " + akApparatus + " is " + akApparatus.GetQuality())
EndEvent

Event OnConsoleSetQuality(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetQuality(Apparatus akApparatus, Int aiQuality)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Apparatus akApparatus = self.FormFromSArgument(sArgument, 1) as Apparatus
  If akApparatus == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Int aiQuality = self.IntFromSArgument(sArgument, 2)
  PrintMessage("Quality of " + akApparatus + " is " + akApparatus.GetQuality())
  PrintMessage("Attempting to change to " + aiQuality)
  akApparatus.SetQuality(aiQuality)
  PrintMessage("Quality of " + akApparatus + " is now " + akApparatus.GetQuality())
EndEvent

Event OnConsoleCastEnchantment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CastEnchantment(Actor akSource, Enchantment akEnchantment, Actor akTarget)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akSource
  Enchantment akEnchantment
  Actor akTarget
  If QtyPars == 2
    akSource = ConsoleUtil.GetSelectedReference() as Actor
    akEnchantment = self.FormFromSArgument(sArgument, 1) as Enchantment
    akTarget = self.FormFromSArgument(sArgument, 2) as Actor
  ElseIf QtyPars == 3
    akSource = self.FormFromSArgument(sArgument, 1) as Actor
    akEnchantment = self.FormFromSArgument(sArgument, 2) as Enchantment
    akTarget = self.FormFromSArgument(sArgument, 3) as Actor
  EndIf
  If akSource == none || akEnchantment == none || akTarget == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  ANDR_PapyrusFunctions.CastEnchantment(akSource, akEnchantment, akTarget)
  PrintMessage(self.GetFullID(akSource) + " cast enchantment " + self.GetFullID(akEnchantment) + " at " + self.GetFullID(akTarget))
EndEvent

Event OnConsoleCastPotion(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CastPotion(Actor akSource, Potion akPotion, Actor akTarget)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akSource
  Potion akPotion
  Actor akTarget
  If QtyPars == 2
    akSource = ConsoleUtil.GetSelectedReference() as Actor
    akPotion = self.FormFromSArgument(sArgument, 1) as Potion
    akTarget = self.FormFromSArgument(sArgument, 2) as Actor
  ElseIf QtyPars == 3
    akSource = self.FormFromSArgument(sArgument, 1) as Actor
    akPotion = self.FormFromSArgument(sArgument, 2) as Potion
    akTarget = self.FormFromSArgument(sArgument, 3) as Actor
  EndIf
  If akSource == none || akPotion == none || akTarget == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  ANDR_PapyrusFunctions.CastPotion(akSource, akPotion, akTarget)
  PrintMessage(self.GetFullID(akSource) + " cast potion " + self.GetFullID(akPotion) + " at " + self.GetFullID(akTarget))
EndEvent

Event OnConsoleCastIngredient(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CastIngredient(Actor akSource, Ingredient akIngedient, Actor akTarget)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akSource
  Ingredient akIngedient
  Actor akTarget
  If QtyPars == 2
    akSource = ConsoleUtil.GetSelectedReference() as Actor
    akIngedient = self.FormFromSArgument(sArgument, 1) as Ingredient
    akTarget = self.FormFromSArgument(sArgument, 2) as Actor
  ElseIf QtyPars == 3
    akSource = self.FormFromSArgument(sArgument, 1) as Actor
    akIngedient = self.FormFromSArgument(sArgument, 2) as Ingredient
    akTarget = self.FormFromSArgument(sArgument, 3) as Actor
  EndIf
  If akSource == none || akIngedient == none || akTarget == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  ANDR_PapyrusFunctions.CastIngredient(akSource, akIngedient, akTarget)
  PrintMessage(self.GetFullID(akSource) + " cast ingredient " + self.GetFullID(akIngedient) + " at " + self.GetFullID(akTarget))
EndEvent

Event OnConsoleSetRefAsNoAIAcquire(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetRefAsNoAIAcquire(ObjectReference akObject, Bool SetNoAIAquire = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akObject
  Bool SetNoAIAquire
  If QtyPars == 0
    akObject = ConsoleUtil.GetSelectedReference()
    SetNoAIAquire = self.BoolFromSArgument(sArgument, 1, true)
  Else
    akObject = self.RefFromSArgument(sArgument, 1)
    SetNoAIAquire = self.BoolFromSArgument(sArgument, 2, true)
  EndIf
  If akObject == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  ANDR_PapyrusFunctions.SetRefAsNoAIAcquire(akObject, SetNoAIAquire)

EndEvent

Event OnConsoleTrainWith(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: TrainWith(Actor akTrainer)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akTrainer
  If QtyPars == 0
    akTrainer = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    akTrainer = self.FormFromSArgument(sArgument, 1) as Actor
  EndIf
  If akTrainer == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Game.ShowTrainingMenu(akTrainer)
EndEvent

Event OnConsoleQueryStat(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: QueryStat(string asStat)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  string asStat = self.StringFromSArgument(sArgument, 1)
  Game.QueryStat(asStat)
EndEvent

Event OnConsoleSetMiscStat(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMiscStat(String asName, Int aiValue)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  String asName = self.StringFromSArgument(sArgument, 1)
  Int aiValue = self.IntFromSArgument(sArgument, 2)
  Game.SetMiscStat(asName, aiValue)
EndEvent

Event OnConsoleHeadpartHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: HeadpartHelp()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("HEADPART HELP")
  PrintMessage("=====================")
  PrintMessage("Type_Misc         = 0")
  PrintMessage("Type_Face         = 1")
  PrintMessage("Type_Eyes         = 2")
  PrintMessage("Type_Hair         = 3")
  PrintMessage("Type_FacialHair   = 4")
  PrintMessage("Type_Scar         = 5")
  PrintMessage("Type_Brows        = 6")
  PrintMessage("=====================")
EndEvent

Event OnConsoleCollisionHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CollisionHelp()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("COLLISION LAYER TYPE HELP")
  PrintMessage("====================================")
  PrintMessage("k_UNIDENTIFIED                  =  0")
  PrintMessage("k_STATIC                        =  1")
  PrintMessage("k_ANIMATED_STATIC               =  2")
  PrintMessage("k_TRANSPARENT                   =  3")
  PrintMessage("k_CLUTTER                       =  4")
  PrintMessage("k_WEAPON                        =  5")
  PrintMessage("k_PROJECTILE                    =  6")
  PrintMessage("k_SPELL                         =  7")
  PrintMessage("k_BIPED                         =  8")
  PrintMessage("k_TREES                         =  9")
  PrintMessage("k_PROPS                         = 10")
  PrintMessage("k_WATER                         = 11")
  PrintMessage("k_TRIGGER                       = 12")
  PrintMessage("k_TERRAIN                       = 13")
  PrintMessage("k_TRAP                          = 14")
  PrintMessage("k_NON_COLLIDABLE                = 15")
  PrintMessage("k_CLOUD_TRAP                    = 16")
  PrintMessage("k_GROUND                        = 17")
  PrintMessage("k_PORTAL                        = 18")
  PrintMessage("k_SMALL_DEBRIS                  = 19")
  PrintMessage("k_LARGE_DEBRIS                  = 20")
  PrintMessage("k_ACOUSTIC_SPACE                = 21")
  PrintMessage("k_ACTOR_ZONE                    = 22")
  PrintMessage("k_PROJECTILE_ZONE               = 23")
  PrintMessage("k_GAS_TRAP                      = 24")
  PrintMessage("k_SHELL_CASING                  = 25")
  PrintMessage("k_SMALL_TRANSPARENT             = 26")
  PrintMessage("k_INVISIBLE_WALL                = 27")
  PrintMessage("k_SMALL_ANIMATED_TRANSPARENT    = 28")
  PrintMessage("k_WARD                          = 29")
  PrintMessage("k_CHARACTER_CONTROLLER          = 30")
  PrintMessage("k_STAIR_HELPER                  = 31")
  PrintMessage("k_DEAD_BIPED                    = 32")
  PrintMessage("k_NO_CHARACTER_CONTROLLER_BIPED = 33")
  PrintMessage("k_AVOID_BOX                     = 34")
  PrintMessage("k_COLLISION_BOX                 = 35")
  PrintMessage("k_CAMERA_SPHERE                 = 36")
  PrintMessage("k_DOOR_DETECTION                = 37")
  PrintMessage("k_CONE_PROJECTILE               = 38")
  PrintMessage("k_CAMERA                        = 39")
  PrintMessage("k_ITEM_PICKER                   = 40")
  PrintMessage("k_LINE_OF_SIGHT                 = 41")
  PrintMessage("k_PATH_PICKER                   = 42")
  PrintMessage("k_CUSTOM_PICKER_1               = 43")
  PrintMessage("k_CUSTOM_PICKER_2               = 44")
  PrintMessage("k_SPELL_EXPLOSION               = 45")
  PrintMessage("k_DROP_PICKER                   = 46")
  PrintMessage("k_DEAD_ACTOR_ZONE               = 47")
  PrintMessage("k_FALLING_TRAP_TRIGGER          = 48")
  PrintMessage("k_NAVCUT                        = 49")
  PrintMessage("k_CRITTER                       = 50")
  PrintMessage("k_SPELL_TRIGGER                 = 51")
  PrintMessage("k_LIVING_AND_DEAD_ACTORS        = 52")
  PrintMessage("k_DETECTION                     = 53")
  PrintMessage("k_TRAP_TRIGGER                  = 54")
  PrintMessage("====================================")
EndEvent

Event OnConsoleFactionFlagHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: FactionFlagHelp()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("FACTION FLAG HELP")
  PrintMessage("============================================")
  PrintMessage("kFaction_HiddenFromNPC          = 0x00000001")
  PrintMessage("kFaction_SpecialCombat          = 0x00000002")
  PrintMessage("kFaction_TrackCrime             = 0x00000010")
  PrintMessage("kFaction_IgnoreMurder           = 0x00000020")
  PrintMessage("kFaction_IgnoreAssault          = 0x00000040")
  PrintMessage("kFaction_IgnoreStealing         = 0x00000080")
  PrintMessage("kFaction_IgnoreTrespass         = 0x00000100")
  PrintMessage("kFaction_NoReportCrime          = 0x00000200")
  PrintMessage("kFaction_CrimeGoldDefaults      = 0x00000400")
  PrintMessage("kFaction_IgnorePickpocket       = 0x00000800")
  PrintMessage("kFaction_Vendor                 = 0x00001000")
  PrintMessage("kFaction_CanBeOwner             = 0x00002000")
  PrintMessage("kFaction_IgnoreWerewolf         = 0x00004000")
  PrintMessage("============================================")
EndEvent

Event OnConsoleGetSkillLegendaryLevel(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSkillLegendaryLevel(ActorValueInfo akAVInfo)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ActorValueInfo akAVInfo = self.FormFromSArgument(sArgument, 1) as ActorValueInfo
  If akAVInfo == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Legendary level of skill " + self.GetFullID(akAVInfo) + " is " + akAVInfo.GetSkillLegendaryLevel())
EndEvent

Event OnConsoleSetSkillLegendaryLevel(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSkillLegendaryLevel(ActorValueInfo akAVInfo, Int aiLevel)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ActorValueInfo akAVInfo = self.FormFromSArgument(sArgument, 1) as ActorValueInfo
  Int aiLevel = self.IntFromSArgument(sArgument, 2)
  PrintMessage("Legendary level of skill " + self.GetFullID(akAVInfo) + " is " + akAVInfo.GetSkillLegendaryLevel())
  PrintMessage("Attempting to change to " + akAVInfo.GetSkillLegendaryLevel())
  akAVInfo.SetSkillLegendaryLevel(aiLevel)
  PrintMessage("Legendary level of skill " + self.GetFullID(akAVInfo) + " is now " + akAVInfo.GetSkillLegendaryLevel())
EndEvent

Event OnConsoleGetSlowTimeMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSlowTimeMult(bool _GetWorldTimeMult = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  bool _GetWorldTimeMult = self.BoolFromSArgument(sArgument, 1, true)
  float TimeMult = Trash_Function.GetSlowTimeMult(_GetWorldTimeMult)
  PrintMessage("Current time multiplier is " + TimeMult)
EndEvent

Event OnConsoleSetSlowTimeMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSlowTimeMult(float _WorldTimeMult = 0.0, float _PlayerOnlyTimeMult = 1.0, bool _Setter = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  float _WorldTimeMult = self.FloatFromSArgument(sArgument, 1, 0.0)
  float _PlayerOnlyTimeMult = self.FloatFromSArgument(sArgument, 2, 1.0)
  bool _Setter = self.BoolFromSArgument(sArgument, 3, true)

  float WorldTimeMult = Trash_Function.GetSlowTimeMult(true)
  float PlayerTimeMult = Trash_Function.GetSlowTimeMult(true)
  PrintMessage("Current world time multiplier is " + WorldTimeMult)
  PrintMessage("Current player time multiplier is " + PlayerTimeMult)
  PrintMessage("Atempting to change to " + _WorldTimeMult + " and " + _PlayerOnlyTimeMult)
  Trash_Function.SetSlowTimeMult(_WorldTimeMult, _PlayerOnlyTimeMult, _Setter)
  

  WorldTimeMult = Trash_Function.GetSlowTimeMult(true)
  PlayerTimeMult = Trash_Function.GetSlowTimeMult(true)
  PrintMessage("Tried. Current world time multiplier is " + WorldTimeMult)
  PrintMessage("Tried. Current player time multiplier is " + PlayerTimeMult)
EndEvent

Event OnConsoleApplyMeleeHit(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ApplyMeleeHit(Actor _attacker, Actor _victim, bool lefthand = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor _attacker = self.FormFromSArgument(sArgument, 1) as Actor
  Actor _victim = self.FormFromSArgument(sArgument, 2) as Actor
  bool lefthand = self.BoolFromSArgument(sArgument, 3, false)
  If _attacker == none || _victim == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  Trash_Function.ApplyMeleeHit(_attacker, _victim, lefthand)
EndEvent

Event OnConsoleApplyHit(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ApplyHit(Actor _attacker, Actor _victim, Weapon _weapon, bool _applyench = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor _attacker = self.FormFromSArgument(sArgument, 1) as Actor
  Actor _victim = self.FormFromSArgument(sArgument, 2) as Actor
  Weapon _weapon = self.FormFromSArgument(sArgument, 3) as Weapon
  bool _applyench = self.BoolFromSArgument(sArgument, 4, false)
  If _attacker == none || _victim == none || _weapon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  Trash_Function.ApplyHit(_attacker, _victim, _weapon, _applyench)
EndEvent

Event OnConsoleTemperEquipment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: TemperEquipment([Actor tmpActor = GetSelectedReference()], Form equipment, float minHealth, float maxHealth)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
    Actor tmpActor
    Form equipment
    float minHealth
    float maxHealth 
  If QtyPars == 3
    tmpActor = ConsoleUtil.GetSelectedReference() as Actor
    equipment = self.FormFromSArgument(sArgument, 2) 
    minHealth = self.FloatFromSArgument(sArgument, 3, 0.0)
    maxHealth = self.FloatFromSArgument(sArgument, 4, 0.0)
  ElseIf QtyPars == 4
    tmpActor = self.FormFromSArgument(sArgument, 1) as Actor
    equipment = self.FormFromSArgument(sArgument, 2) 
    minHealth = self.FloatFromSArgument(sArgument, 3, 0.0)
    maxHealth = self.FloatFromSArgument(sArgument, 4, 0.0)
  EndIf

  If tmpActor == none || equipment == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  sztkUtil.TemperEquipment(tmpActor, equipment, minHealth, maxHealth)
EndEvent

Event OnConsoleTemperWornEquipment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: TemperWornEquipment(Actor aActor, float minHealth, float maxHealth, FormList excludeKeywordList = none)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor aActor
  float minHealth
  float maxHealth
  FormList excludeKeywordList
  If QtyPars == 3
    aActor = ConsoleUtil.GetSelectedReference() as Actor
    minHealth = self.FloatFromSArgument(sArgument, 1, 0.0)
    maxHealth = self.FloatFromSArgument(sArgument, 2, 0.0)
    excludeKeywordList = self.FormFromSArgument(sArgument, 3) as FormList
  ElseIf QtyPars == 4
    aActor = self.FormFromSArgument(sArgument, 1) as Actor
    minHealth = self.FloatFromSArgument(sArgument, 2, 0.0)
    maxHealth = self.FloatFromSArgument(sArgument, 3, 0.0)
    excludeKeywordList = self.FormFromSArgument(sArgument, 4) as FormList
  EndIf
  If aActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  sztkUtil.TemperWornEquipment(aActor, minHealth, maxHealth, excludeKeywordList)
EndEvent

Event OnConsoleMagicEffectHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: MagicEffectHelp()")
  PrintMessage("MAGIC EFFECT FLAGS")
  PrintMessage("============================")
  PrintMessage("Hostile:          0x00000001")
  PrintMessage("Recover  		    	0x00000002")
  PrintMessage("Detrimental     	0x00000004")
  PrintMessage("NoHitEvent  	    0x00000010")
  PrintMessage("DispelKeywords  	0x00000100")
  PrintMessage("NoDuration  	  	0x00000200")
  PrintMessage("NoMagnitude    		0x00000400")
  PrintMessage("NoArea  		    	0x00000800")
  PrintMessage("FXPersist  	    	0x00001000")
  PrintMessage("GloryVisuals    	0x00004000")
  PrintMessage("HideInUI  	    	0x00008000")
  PrintMessage("NoRecast  	    	0x00020000")
  PrintMessage("Magnitude  	    	0x00200000")
  PrintMessage("Duration  	    	0x00400000")
  PrintMessage("Painless  	    	0x04000000")
  PrintMessage("NoHitEffect   		0x08000000")
  PrintMessage("NoDeathDispel   	0x10000000")
  PrintMessage("============================")
EndEvent

Event OnConsoleRaceHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RaceHelp()")
  PrintMessage("RACE FLAGS")
  PrintMessage("================================================")
  PrintMessage("kRace_Playable											= 0x00000001")
  PrintMessage("kRace_FaceGenHead										= 0x00000002")
  PrintMessage("kRace_Child													= 0x00000004")
  PrintMessage("kRace_TiltFrontBack									= 0x00000008")
  PrintMessage("kRace_TiltLeftRight									= 0x00000010")
  PrintMessage("kRace_NoShadow											= 0x00000020")
  PrintMessage("kRace_Swims													= 0x00000040")
  PrintMessage("kRace_Flies													= 0x00000080")
  PrintMessage("kRace_Walks													= 0x00000100")
  PrintMessage("kRace_Immobile											= 0x00000200")
  PrintMessage("kRace_NotPushable										= 0x00000400")
  PrintMessage("kRace_NoCombatInWater								= 0x00000800")
  PrintMessage("kRace_NoRotatingToHeadTrack					= 0x00001000")
  PrintMessage("kRace_UseHeadTrackAnim							= 0x00008000")
  PrintMessage("kRace_SpellsAlignWithMagicNode			= 0x00010000")
  PrintMessage("kRace_UseWorldRaycasts							= 0x00020000")
  PrintMessage("kRace_AllowRagdollCollision					= 0x00040000")
  PrintMessage("kRace_CantOpenDoors									= 0x00100000")
  PrintMessage("kRace_AllowPCDialogue								= 0x00200000")
  PrintMessage("kRace_NoKnockdowns									= 0x00400000")
  PrintMessage("kRace_AllowPickpocket								= 0x00800000")
  PrintMessage("kRace_AlwaysUseProxyController			= 0x01000000")
  PrintMessage("kRace_AllowMultipleMembraneShaders	= 0x20000000")
  PrintMessage("kRace_AvoidsRoads										= 0x80000000")
  PrintMessage("================================================")
EndEvent

Event OnConsoleSetRecordFlag(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetRecordFlag(Form akForm, int aiFlag, bool abSkipChecks = false)")
  PrintMessage("Type the flag number in hex format (0x is not required)")
  
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("RECORD FLAG HELP")
    PrintMessage("===============================================")
      PrintMessage("0x00000001	(TES4) Master (ESM) file")
      PrintMessage("0x00000010	Deleted Group (bugged, see Groups)")
      PrintMessage("0x00000020	Deleted Record")
      PrintMessage("0x00000040	(GLOB) Constant")
      PrintMessage("            (REFR) Hidden From Local Map (Needs Confirmation: Related to shields)")
      PrintMessage("0x00000080	(TES4) Localized")
      PrintMessage("0x00000100	Must Update Anims")
      PrintMessage("            (REFR) Inaccessible")
      PrintMessage("0x00000200	(TES4) Light Master (ESL) File. Data File")
      PrintMessage("            (REFR) Hidden from local map")
      PrintMessage("            (ACHR) Starts dead")
      PrintMessage("            (REFR) MotionBlurCastsShadows")
      PrintMessage("0x00000400	Quest item")
      PrintMessage("            Persistent reference")
      PrintMessage("            (LSCR) Displays in Main Menu")
      PrintMessage("0x00000800	Initially disabled")
      PrintMessage("0x00001000	Ignored")
      PrintMessage("0x00008000	Visible when distant")
      PrintMessage("0x00010000	(ACTI) Random Animation Start")
      PrintMessage("0x00020000	(ACTI) Dangerous")
      PrintMessage("            Off limits (Interior cell)")
      PrintMessage("            Dangerous Can't be set without Ignore Object Interaction")
      PrintMessage("0x00040000	Data is compressed")
      PrintMessage("0x00080000	Can't wait")
      PrintMessage("0x00100000	(ACTI) Ignore Object Interaction")
      PrintMessage("            Ignore Object Interaction Sets Dangerous Automatically")
      PrintMessage("0x00800000	Is Marker")
      PrintMessage("0x02000000	(ACTI) Obstacle")
      PrintMessage("            (REFR) No AI Acquire")
      PrintMessage("0x04000000	NavMesh Gen - Filter")
      PrintMessage("0x08000000	NavMesh Gen - Bounding Box")
      PrintMessage("0x10000000	(FURN) Must Exit to Talk")
      PrintMessage("            (REFR) Reflected By Auto Water")
      PrintMessage("0x20000000	(FURN/IDLM) Child Can Use")
      PrintMessage("            (REFR) Don't Havok Settle")
      PrintMessage("0x40000000	NavMesh Gen - Ground")
      PrintMessage("            (REFR) NoRespawn")
      PrintMessage("0x80000000	(REFR) MultiBound")
    PrintMessage("===============================================")
    Return
  EndIf

  Form akForm = self.FormFromSArgument(sArgument, 1)
  Int aiFlag = self.IntFromSArgumentHex(sArgument, 2)
  Bool abSkipChecks = self.BoolFromSArgument(sArgument, 3, false) ; Default to false if not provided

  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If aiFlag < 0 || aiFlag > 27
    PrintMessage("FATAL ERROR: Invalid flag number provided. Run " + DoubleQuotes("SetRecordFlag ?") + " to check valid values")
    Return
  EndIf

  ; Skip checks if abSkipChecks is true
  If !abSkipChecks
    ; Perform type checks based on the flag
    If aiFlag == 3 || aiFlag == 6 || aiFlag == 9
      If !(akForm as Static == none)
        PrintMessage("ERROR: Flag " + aiFlag + " can only be set on Static forms")
        Return
      EndIf
    ElseIf aiFlag == 5
      If !(akForm as Door == none)
        PrintMessage("ERROR: Flag " + aiFlag + " can only be set on Door forms")
        Return
      EndIf
    ElseIf aiFlag == 7 || aiFlag == 13 || aiFlag == 16 || aiFlag == 19
      If !(akForm as Actor == none)
        PrintMessage("ERROR: Flag " + aiFlag + " can only be set on Actor forms")
        Return
      EndIf
    ElseIf aiFlag == 15
      If !(akForm as TreeObject == none)
        PrintMessage("ERROR: Flag " + aiFlag + " can only be set on Tree forms")
        Return
      EndIf
    ElseIf aiFlag == 17
      If !(akForm as Light == none)
        PrintMessage("ERROR: Flag " + aiFlag + " can only be set on Light forms")
        Return
      EndIf
    EndIf
  EndIf

  ; Set the record flag
  SetRecordFlag(akForm, aiFlag)
EndEvent

Event OnConsoleClearRecordFlag(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearRecordFlag(Form akForm, int aiFlag)")
  If self.StringFromSArgument(sArgument, 1) == "?"
      PrintMessage("0x00000001	(TES4) Master (ESM) file")
      PrintMessage("0x00000010	Deleted Group (bugged, see Groups)")
      PrintMessage("0x00000020	Deleted Record")
      PrintMessage("0x00000040	(GLOB) Constant")
      PrintMessage("            (REFR) Hidden From Local Map (Needs Confirmation: Related to shields)")
      PrintMessage("0x00000080	(TES4) Localized")
      PrintMessage("0x00000100	Must Update Anims")
      PrintMessage("            (REFR) Inaccessible")
      PrintMessage("0x00000200	(TES4) Light Master (ESL) File. Data File")
      PrintMessage("            (REFR) Hidden from local map")
      PrintMessage("            (ACHR) Starts dead")
      PrintMessage("            (REFR) MotionBlurCastsShadows")
      PrintMessage("0x00000400	Quest item")
      PrintMessage("            Persistent reference")
      PrintMessage("            (LSCR) Displays in Main Menu")
      PrintMessage("0x00000800	Initially disabled")
      PrintMessage("0x00001000	Ignored")
      PrintMessage("0x00008000	Visible when distant")
      PrintMessage("0x00010000	(ACTI) Random Animation Start")
      PrintMessage("0x00020000	(ACTI) Dangerous")
      PrintMessage("            Off limits (Interior cell)")
      PrintMessage("            Dangerous Can't be set without Ignore Object Interaction")
      PrintMessage("0x00040000	Data is compressed")
      PrintMessage("0x00080000	Can't wait")
      PrintMessage("0x00100000	(ACTI) Ignore Object Interaction")
      PrintMessage("            Ignore Object Interaction Sets Dangerous Automatically")
      PrintMessage("0x00800000	Is Marker")
      PrintMessage("0x02000000	(ACTI) Obstacle")
      PrintMessage("            (REFR) No AI Acquire")
      PrintMessage("0x04000000	NavMesh Gen - Filter")
      PrintMessage("0x08000000	NavMesh Gen - Bounding Box")
      PrintMessage("0x10000000	(FURN) Must Exit to Talk")
      PrintMessage("            (REFR) Reflected By Auto Water")
      PrintMessage("0x20000000	(FURN/IDLM) Child Can Use")
      PrintMessage("            (REFR) Don't Havok Settle")
      PrintMessage("0x40000000	NavMesh Gen - Ground")
      PrintMessage("            (REFR) NoRespawn")
      PrintMessage("0x80000000	(REFR) MultiBound")
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  Int aiFlag = self.IntFromSArgumentHex(sArgument, 2)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  ClearRecordFlag(akForm, aiFlag)
EndEvent

Event OnConsoleIsRecordFlagSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: IsRecordFlagSet(Form akForm, int aiFlag)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("FORM RECORD FLAGS")
    PrintMessage("================================================")
      PrintMessage("0x00000001	(TES4) Master (ESM) file")
      PrintMessage("0x00000010	Deleted Group (bugged, see Groups)")
      PrintMessage("0x00000020	Deleted Record")
      PrintMessage("0x00000040	(GLOB) Constant")
      PrintMessage("            (REFR) Hidden From Local Map (Needs Confirmation: Related to shields)")
      PrintMessage("0x00000080	(TES4) Localized")
      PrintMessage("0x00000100	Must Update Anims")
      PrintMessage("            (REFR) Inaccessible")
      PrintMessage("0x00000200	(TES4) Light Master (ESL) File. Data File")
      PrintMessage("            (REFR) Hidden from local map")
      PrintMessage("            (ACHR) Starts dead")
      PrintMessage("            (REFR) MotionBlurCastsShadows")
      PrintMessage("0x00000400	Quest item")
      PrintMessage("            Persistent reference")
      PrintMessage("            (LSCR) Displays in Main Menu")
      PrintMessage("0x00000800	Initially disabled")
      PrintMessage("0x00001000	Ignored")
      PrintMessage("0x00008000	Visible when distant")
      PrintMessage("0x00010000	(ACTI) Random Animation Start")
      PrintMessage("0x00020000	(ACTI) Dangerous")
      PrintMessage("            Off limits (Interior cell)")
      PrintMessage("            Dangerous Can't be set without Ignore Object Interaction")
      PrintMessage("0x00040000	Data is compressed")
      PrintMessage("0x00080000	Can't wait")
      PrintMessage("0x00100000	(ACTI) Ignore Object Interaction")
      PrintMessage("            Ignore Object Interaction Sets Dangerous Automatically")
      PrintMessage("0x00800000	Is Marker")
      PrintMessage("0x02000000	(ACTI) Obstacle")
      PrintMessage("            (REFR) No AI Acquire")
      PrintMessage("0x04000000	NavMesh Gen - Filter")
      PrintMessage("0x08000000	NavMesh Gen - Bounding Box")
      PrintMessage("0x10000000	(FURN) Must Exit to Talk")
      PrintMessage("            (REFR) Reflected By Auto Water")
      PrintMessage("0x20000000	(FURN/IDLM) Child Can Use")
      PrintMessage("            (REFR) Don't Havok Settle")
      PrintMessage("0x40000000	NavMesh Gen - Ground")
      PrintMessage("            (REFR) NoRespawn")
      PrintMessage("0x80000000	(REFR) MultiBound")
    PrintMessage("================================================")
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  Int aiFlag = self.IntFromSArgumentHex(sArgument, 2)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  bool flagSet = IsRecordFlagSet(akForm, aiFlag)
  PrintMessage("IsRecordFlagSet: " + flagSet)
EndEvent

Event OnConsoleFormRecordHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: FormRecordHelp()")
  PrintMessage("FORM RECORD FLAGS")
  PrintMessage("================================================")
    PrintMessage("0x00000001	(TES4) Master (ESM) file")
    PrintMessage("0x00000010	Deleted Group (bugged, see Groups)")
    PrintMessage("0x00000020	Deleted Record")
    PrintMessage("0x00000040	(GLOB) Constant")
    PrintMessage("            (REFR) Hidden From Local Map (Needs Confirmation: Related to shields)")
    PrintMessage("0x00000080	(TES4) Localized")
    PrintMessage("0x00000100	Must Update Anims")
    PrintMessage("            (REFR) Inaccessible")
    PrintMessage("0x00000200	(TES4) Light Master (ESL) File. Data File")
    PrintMessage("            (REFR) Hidden from local map")
    PrintMessage("            (ACHR) Starts dead")
    PrintMessage("            (REFR) MotionBlurCastsShadows")
    PrintMessage("0x00000400	Quest item")
    PrintMessage("            Persistent reference")
    PrintMessage("            (LSCR) Displays in Main Menu")
    PrintMessage("0x00000800	Initially disabled")
    PrintMessage("0x00001000	Ignored")
    PrintMessage("0x00008000	Visible when distant")
    PrintMessage("0x00010000	(ACTI) Random Animation Start")
    PrintMessage("0x00020000	(ACTI) Dangerous")
    PrintMessage("            Off limits (Interior cell)")
    PrintMessage("            Dangerous Can't be set without Ignore Object Interaction")
    PrintMessage("0x00040000	Data is compressed")
    PrintMessage("0x00080000	Can't wait")
    PrintMessage("0x00100000	(ACTI) Ignore Object Interaction")
    PrintMessage("            Ignore Object Interaction Sets Dangerous Automatically")
    PrintMessage("0x00800000	Is Marker")
    PrintMessage("0x02000000	(ACTI) Obstacle")
    PrintMessage("            (REFR) No AI Acquire")
    PrintMessage("0x04000000	NavMesh Gen - Filter")
    PrintMessage("0x08000000	NavMesh Gen - Bounding Box")
    PrintMessage("0x10000000	(FURN) Must Exit to Talk")
    PrintMessage("            (REFR) Reflected By Auto Water")
    PrintMessage("0x20000000	(FURN/IDLM) Child Can Use")
    PrintMessage("            (REFR) Don't Havok Settle")
    PrintMessage("0x40000000	NavMesh Gen - Ground")
    PrintMessage("            (REFR) NoRespawn")
    PrintMessage("0x80000000	(REFR) MultiBound")
  PrintMessage("================================================")
EndEvent

Event OnConsoleGetRace(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRace(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If akActor == none
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf 
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  PrintMessage(self.GetFullID(akActor) + "'s ' race is: " + MiscUtil.GetActorRaceEditorID(akActor))
EndEvent

Event OnConsoleFormHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("FormHelp(string sFormName, int nameMatchMode = 0, int[] formTypes = none, int formTypeMatchMode = 0)")

  PrintMessage("nameMatchMode: 0 = exact match, 1 = name contains sFormName")

  PrintMessage("formTypeMatchModes:")
  PrintMessage("1 = forms that have a type in formTypes")
  PrintMessage("0 = forms that do not have a type in formTypes")
  PrintMessage("-1 = filter is ignored completely, get all forms regardless of type that match (or contain)")

  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  PrintMessage("FORM HELP")
  PrintMessage("======================================================================")

  Form[] formResults
  string sFormName = self.StringFromSArgument(sArgument, 1)
  If sFormName == "(null)"
    sFormName = ""
  EndIf
  int nameMatchMode = self.IntFromSArgument(sArgument, 2, 0)
  string formTypeStr = self.StringFromSArgument(sArgument, 3)
  int[] formTypes = DbMiscFunctions.SplitAsInt(formTypes, -1, ",")
  int formTypeMatchMode = self.IntFromSArgument(sArgument, 4, 0)

  formResults = DbSKSEFunctions.GetAllFormsWithName(sFormName, nameMatchMode, formTypes, formTypeMatchMode)
  Int i = 0
  Int L = formResults.Length
  PrintMessage(L + " results found")
  If L == 0
    Return
  EndIf
  string messages

  While i < L
    messages += (self.GetFullID(formResults[i])) + "\n"
    i += 1
  Endwhile
  PrintMessage(messages)
  PrintMessage("======================================================================")

EndEvent

Event OnConsoleGetActiveQuests(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("GetActiveQuests()")

  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  PrintMessage("Form Help")
  PrintMessage("======================================================================")

  Quest[] questResults = DbSKSEFunctions.GetAllActiveQuests()

  Int i = 0
  Int L = questResults.Length
  PrintMessage(L + " results found")
  If L == 0
    Return
  EndIf

  While i < L
    PrintMessage(self.GetFullID(questResults[i]))
    i += 1
  Endwhile
  PrintMessage("======================================================================")

EndEvent

Event OnConsolePlayDebugShader(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlayDebugShader(ObjectReference akRef, int colorR, int colorG, int colorB)")

  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  Float[] afRGBA = new Float[4]
    afRGBA[0] = self.IntFromSArgument(sArgument, 1)
    afRGBA[1] = self.IntFromSArgument(sArgument, 2)
    afRGBA[2] = self.IntFromSArgument(sArgument, 3)
    afRGBA[3] = self.IntFromSArgument(sArgument, 4)

  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PO3_SKSEFunctions.PlayDebugShader(akRef, afRGBA)
  PrintMessage("Playing debug shader on " + self.GetFullID(akRef))
EndEvent

Event OnConsoleGetMapMarkerIconType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMapMarkerIconType(ObjectReference MapMarker)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("kNone = 0")
    PrintMessage("kCity = 1")
    PrintMessage("kTown = 2")
    PrintMessage("kSettlement = 3")
    PrintMessage("kCave = 4")
    PrintMessage("kCamp = 5")
    PrintMessage("kFort = 6")
    PrintMessage("kNordicRuins = 7")
    PrintMessage("kDwemerRuin = 8")
    PrintMessage("kShipwreck = 9")
    PrintMessage("kGrove = 10")
    PrintMessage("kLandmark = 11")
    PrintMessage("kDragonLair = 12")
    PrintMessage("kFarm = 13")
    PrintMessage("kWoodMill = 14")
    PrintMessage("kMine = 15")
    PrintMessage("kImperialCamp = 16")
    PrintMessage("kStormcloakCamp = 17")
    PrintMessage("kDoomstone = 18")
    PrintMessage("kWheatMill = 19")
    PrintMessage("kSmelter = 20")
    PrintMessage("kStable = 21")
    PrintMessage("kImperialTower = 22")
    PrintMessage("kClearing = 23")
    PrintMessage("kPass = 24")
    PrintMessage("kAlter = 25")
    PrintMessage("kRock = 26")
    PrintMessage("kLighthouse = 27")
    PrintMessage("kOrcStronghold = 28")
    PrintMessage("kGiantCamp = 29")
    PrintMessage("kShack = 30")
    PrintMessage("kNordicTower = 31")
    PrintMessage("kNordicDwelling = 32")
    PrintMessage("kDocks = 33")
    PrintMessage("kShrine = 34")
    PrintMessage("kRiftenCastle = 35")
    PrintMessage("kRiftenCapitol = 36")
    PrintMessage("kWindhelmCastle = 37")
    PrintMessage("kWindhelmCapitol = 38")
    PrintMessage("kWhiterunCastle = 39")
    PrintMessage("kWhiterunCapitol = 40")
    PrintMessage("kSolitudeCastle = 41")
    PrintMessage("kSolitudeCapitol = 42")
    PrintMessage("kMarkarthCastle = 43")
    PrintMessage("kMarkarthCapitol = 44")
    PrintMessage("kWinterholdCastle = 45")
    PrintMessage("kWinterholdCapitol = 46")
    PrintMessage("kMorthalCastle = 47")
    PrintMessage("kMorthalCapitol = 48")
    PrintMessage("kFalkreathCastle = 49")
    PrintMessage("kFalkreathCapitol = 50")
    PrintMessage("kDawnstarCastle = 51")
    PrintMessage("kDawnstarCapitol = 52")
    PrintMessage("kDLC02_TempleOfMiraak = 53")
    PrintMessage("kDLC02_RavenRock = 54")
    PrintMessage("kDLC02_BeastStone = 55")
    PrintMessage("kDLC02_TelMithryn = 56")
    PrintMessage("kDLC02_ToSkyrim = 57")
    PrintMessage("kDLC02_ToSolstheim = 58")
    PrintMessage("Big Cave = 59")
    PrintMessage("60 = none")
    PrintMessage("Lock = 61")
    PrintMessage("Flashing Arrow = 62")
    PrintMessage("Flashing quest marker = 63 (don't use, it'll get stuck)")
    PrintMessage("3 flashing arrows = 64")
    PrintMessage("blue arrow = 65")
    PrintMessage("player flashing arrow = 66")
    PrintMessage("Big circle = any other value")
    Return
  EndIf
  ObjectReference MapMarker = self.RefFromSArgument(sArgument, 1)
  int iconType = DbSKSEFunctions.GetMapMarkerIconType(MapMarker)
  PrintMessage("Map Marker Icon Type: " + iconType)
EndEvent

Event OnConsoleSetMapMarkerIconType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMapMarkerIconType(ObjectReference MapMarker, int iconType)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference MapMarker = self.RefFromSArgument(sArgument, 1)
  Int iconType = self.IntFromSArgument(sArgument, 2)
  If MapMarker == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf
  DbSKSEFunctions.SetMapMarkerIconType(MapMarker, iconType)
EndEvent

Event OnConsoleGetMapMarkerName(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMapMarkerName(ObjectReference MapMarker)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference MapMarker = self.RefFromSArgument(sArgument, 1)
  String Name = DbSKSEFunctions.GetMapMarkerName(MapMarker)
  PrintMessage("Map Marker Name: " + Name)
EndEvent

Event OnConsoleSetMapMarkerName(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMapMarkerName(ObjectReference MapMarker, String Name)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference MapMarker = self.RefFromSArgument(sArgument, 1)
  String Name = self.StringFromSArgument(sArgument, 2)
  If MapMarker == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf
  DbSKSEFunctions.SetMapMarkerName(MapMarker, Name)
EndEvent

Event OnConsoleGetCellOrWorldSpaceOriginForRef(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetCellOrWorldSpaceOriginForRef(ObjectReference ref)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = self.RefFromSArgument(sArgument, 1)
  Form Origin = DbSKSEFunctions.GetCellOrWorldSpaceOriginForRef(ref)
  PrintMessage("Cell/World Space Origin: " + Origin)
EndEvent

Event OnConsoleSetCellOrWorldSpaceOriginForRef(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetCellOrWorldSpaceOriginForRef(ObjectReference ref, Form cellOrWorldSpace)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = self.RefFromSArgument(sArgument, 1)
  Form cellOrWorldSpace = self.FormFromSArgument(sArgument, 2)
  If ref == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf
  DbSKSEFunctions.SetCellOrWorldSpaceOriginForRef(ref, cellOrWorldSpace)
EndEvent

Event OnConsoleGetCurrentMapMarkerRefs(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetCurrentMapMarkerRefs(int visibleFilter = -1, int canTravelToFilter = -1)")
  Int visibleFilter = self.IntFromSArgument(sArgument, 1)
  Int canTravelToFilter = self.IntFromSArgument(sArgument, 2)
  ObjectReference[] refs = DbSKSEFunctions.GetCurrentMapMarkerRefs(visibleFilter, canTravelToFilter)
  Int i = 0
  Int L = refs.length

  If L > 0
    PrintMessage(L + " map markers found:")
  Else
    PrintMessage("No map markers found")
    Return
  EndIf

  While i < L
    PrintMessage("Marker #" + i + ": " + refs[i])
    i += 1
  EndWhile
EndEvent

Event OnConsoleGetAllMapMarkerRefs(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllMapMarkerRefs(int visibleFilter = -1, int canTravelToFilter = -1)")
  Int visibleFilter = self.IntFromSArgument(sArgument, 1)
  Int canTravelToFilter = self.IntFromSArgument(sArgument, 2)
  ObjectReference[] refs = DbSKSEFunctions.GetAllMapMarkerRefs(visibleFilter, canTravelToFilter)
  Int i = 0
  Int L = refs.length

  If L > 0
    PrintMessage(L + " map markers found:")
  Else
    PrintMessage("No map markers found")
    Return
  EndIf

  While i < L
    PrintMessage("Marker #" + i + ": " + refs[i])
    i += 1
  EndWhile
EndEvent

Event OnConsoleHasNodeOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: HasNodeOverride(ObjectReference ref, bool isFemale, string node, int key, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool isFemale = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  bool result = NiOverride.HasNodeOverride(ref, isFemale, node, keynumber, index)
  PrintMessage("HasNodeOverride: " + result)
EndEvent

Event OnConsoleAddNodeOverrideFloat(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddNodeOverrideFloat(ObjectReference ref, bool isFemale, string node, int key, int index, float value, bool persist)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool isFemale = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  float value = self.FloatFromSArgument(sArgument, 5)
  bool persist = self.BoolFromSArgument(sArgument, 6, true)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.AddNodeOverrideFloat(ref, isFemale, node, keynumber, index, value, persist)
  PrintMessage("AddNodeOverrideFloat " + self.GetFullID(ref))
EndEvent

Event OnConsoleAddNodeOverrideInt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddNodeOverrideInt(ObjectReference ref, bool isFemale, string node, int key, int index, int value, bool persist)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool isFemale = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  int value = self.IntFromSArgument(sArgument, 5)
  bool persist = self.BoolFromSArgument(sArgument, 6, true)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.AddNodeOverrideInt(ref, isFemale, node, keynumber, index, value, persist)
  PrintMessage("AddNodeOverrideInt " + self.GetFullID(ref))
EndEvent

Event OnConsoleAddNodeOverrideBool(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddNodeOverrideBool(ObjectReference ref, bool isFemale, string node, int key, int index, bool value, bool persist)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool isFemale = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  bool value = self.BoolFromSArgument(sArgument, 5)
  bool persist = self.BoolFromSArgument(sArgument, 6, true)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.AddNodeOverrideBool(ref, isFemale, node, keynumber, index, value, persist)
  PrintMessage("AddNodeOverrideBool " + self.GetFullID(ref))
EndEvent

Event OnConsoleAddNodeOverrideString(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddNodeOverrideString(ObjectReference ref, bool isFemale, string node, int key, int index, string value, bool persist)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool isFemale = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  string value = self.StringFromSArgument(sArgument, 5)
  bool persist = self.BoolFromSArgument(sArgument, 6, true)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.AddNodeOverrideString(ref, isFemale, node, keynumber, index, value, persist)
  PrintMessage("AddNodeOverrideString " + self.GetFullID(ref))
EndEvent

Event OnConsoleAddNodeOverrideTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddNodeOverrideTextureSet(ObjectReference ref, bool isFemale, string node, int key, int index, TextureSet value, bool persist)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool isFemale = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  TextureSet value = self.FormFromSArgument(sArgument, 5) as TextureSet
  bool persist = self.BoolFromSArgument(sArgument, 6, true)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.AddNodeOverrideTextureSet(ref, isFemale, node, keynumber, index, value, persist)
  PrintMessage("AddNodeOverrideTextureSet " + self.GetFullID(ref))
EndEvent

Event OnConsoleGetNodeOverrideFloat(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNodeOverrideFloat(ObjectReference ref, bool isFemale, string node, int key, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool isFemale = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  float result = NiOverride.GetNodeOverrideFloat(ref, isFemale, node, keynumber, index)
  PrintMessage("GetNodeOverrideFloat: " + result)
EndEvent

Event OnConsoleGetNodeOverrideInt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNodeOverrideInt(ObjectReference ref, bool isFemale, string node, int key, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool isFemale = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int result = NiOverride.GetNodeOverrideInt(ref, isFemale, node, keynumber, index)
  PrintMessage("GetNodeOverrideInt: " + result)
EndEvent

Event OnConsoleGetNodeOverrideBool(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNodeOverrideBool(ObjectReference ref, bool isFemale, string node, int key, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool isFemale = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  bool result = NiOverride.GetNodeOverrideBool(ref, isFemale, node, keynumber, index)
  PrintMessage("GetNodeOverrideBool: " + result)
EndEvent

Event OnConsoleGetNodeOverrideString(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNodeOverrideString(ObjectReference ref, bool isFemale, string node, int key, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool isFemale = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  string result = NiOverride.GetNodeOverrideString(ref, isFemale, node, keynumber, index)
  PrintMessage("GetNodeOverrideString: " + result)
EndEvent

Event OnConsoleGetNodeOverrideTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNodeOverrideTextureSet(ObjectReference ref, bool isFemale, string node, int key, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool isFemale = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  TextureSet result = NiOverride.GetNodeOverrideTextureSet(ref, isFemale, node, keynumber, index)
  PrintMessage("GetNodeOverrideTextureSet: " + result)
EndEvent

Event OnConsoleGetNodePropertyFloat(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNodePropertyFloat(ObjectReference ref, bool firstPerson, string node, int key, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool firstPerson = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  float result = NiOverride.GetNodePropertyFloat(ref, firstPerson, node, keynumber, index)
  PrintMessage("GetNodePropertyFloat: " + result)
EndEvent

Event OnConsoleGetNodePropertyInt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNodePropertyInt(ObjectReference ref, bool firstPerson, string node, int key, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool firstPerson = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int result = NiOverride.GetNodePropertyInt(ref, firstPerson, node, keynumber, index)
  PrintMessage("GetNodePropertyInt: " + result)
EndEvent

Event OnConsoleGetNodePropertyBool(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNodePropertyBool(ObjectReference ref, bool firstPerson, string node, int key, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool firstPerson = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  bool result = NiOverride.GetNodePropertyBool(ref, firstPerson, node, keynumber, index)
  PrintMessage("GetNodePropertyBool: " + result)
EndEvent

Event OnConsoleGetNodePropertyString(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNodePropertyString(ObjectReference ref, bool firstPerson, string node, int key, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  bool firstPerson = self.BoolFromSArgument(sArgument, 1)
  string node = self.StringFromSArgument(sArgument, 2)
  int keyNumber = self.IntFromSArgument(sArgument, 3)
  int index = self.IntFromSArgument(sArgument, 4)
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  string result = NiOverride.GetNodePropertyString(ref, firstPerson, node, keynumber, index)
  PrintMessage("GetNodePropertyString: " + result)
EndEvent

Event OnConsoleApplyNodeOverrides(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ApplyNodeOverrides(ObjectReference ref)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference ref = ConsoleUtil.GetSelectedReference() as ObjectReference
  If ref == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.ApplyNodeOverrides(ref)
  PrintMessage("ApplyNodeOverrides " + self.GetFullID(ref))
EndEvent

Event OnConsoleDrawWeapon(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: DrawWeapon()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Debug.SendAnimationEvent(akActor, "weaponDraw")
EndEvent

Event OnConsoleSheatheWeapon(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SheatheWeapon()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Debug.SendAnimationEvent(akActor, "weaponSheathe")
EndEvent

Event OnConsoleIdleHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: IdleHelp()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  PrintMessage("Idle Help")
  PrintMessage("=====================================")
  string[] IdleMsg = new String[128]
  string[] IdleMsg_2 = new String[128]
    IdleMsg_2[0] = "IdleTake"
    IdleMsg_2[1] = "IdleLookFar"
    IdleMsg_2[2] = "IdleNoteRead"
    IdleMsg_2[3] = "IdleCO2Ceremony1Welcome"
    IdleMsg_2[4] = "IdleComeThisWay"
    IdleMsg_2[5] = "IdleKneeling"
    IdleMsg_2[6] = "IdleApplaud5"
    IdleMsg_2[7] = "IdleHandCut"
    IdleMsg_2[8] = "idlepointclose"
    IdleMsg_2[9] = "ragdoll"
    IdleMsg_2[10] = "IdleCannibalFeedStanding"
    IdleMsg_2[11] = "idleUncontrollableCough"
    IdleMsg_2[12] = "HorseIdleRearUp"
    IdleMsg_2[13] = "recoil"
    IdleMsg_2[14] = "recoilLarge"
    IdleMsg_2[15] = "bashStart"
    IdleMsg_2[16] = "blockStop"
    IdleMsg_2[17] = "attackStart"
    IdleMsg_2[18] = "IdleBookSitting_Reading"
    IdleMsg_2[19] = "IdleBookSitting_TurnManyPages"
    IdleMsg_2[20] = "IdleBook_Reading"
    IdleMsg_2[21] = "IdleBook_TurnManyPages"
    IdleMsg_2[22] = "IdleStop_Loose"
    IdleMsg_2[23] = "IdleWarmArms"
    IdleMsg_2[24] = "IdleSearchingChest"
    IdleMsg_2[25] = "IdleWipeBrow"
    IdleMsg_2[26] = "IdleWarmHandsCrouched"
    IdleMsg_2[27] = "TG05_KnockOut"
    IdleMsg_2[28] = "TG05_GetUp"
    IdleMsg_2[29] = "PrinceCast"
    IdleMsg_2[30] = "PrinceBigCast"
    IdleMsg_2[31] = "PrinceBigCastEnd"
    IdleMsg_2[32] = "RF_MoodChangeGuarded"
    IdleMsg_2[33] = "RF_MoodChangeOpen"
    IdleMsg_2[34] = "RF_MoodChangeSerious"
    IdleMsg_2[35] = "RF_MoodChangePlayful"
    IdleMsg_2[36] = "IdleMesmerize"
    IdleMsg_2[37] = "IdleMesmerizeStop"
    IdleMsg_2[38] = "OffsetCarryMQ201DrinkR"
    IdleMsg_2[39] = "OffsetStop"
    IdleMsg_2[40] = "pPa_KillMoveDLC1SeranaHoldsVyrthur"
    IdleMsg_2[41] = "BatSprintStart"
    IdleMsg_2[42] = "gripIdle"
    IdleMsg_2[43] = "SpecialFeeding"
    IdleMsg_2[44] = "PrisonerIdle"
    IdleMsg_2[45] = "IdleVampireTransformation"
    IdleMsg_2[46] = "pa_VampireLordChangePlayer"
    IdleMsg_2[47] = "DLC1PairEnd"
    IdleMsg_2[48] = "idleReadElderScroll"
    IdleMsg_2[49] = "IdleDLC02TentacleWordBurnExit"
    IdleMsg_2[50] = "IdleDLC02TentacleWordBurnBegin"
    IdleMsg_2[51] = "idleFreaReactionStart"
    IdleMsg_2[52] = "DLC2FallOnKnees"
    IdleMsg_2[53] = "BoatRideAnim"
    IdleMsg_2[54] = "IdlePickaxeExit"
    IdleMsg_2[55] = "PickaxeExit"
    IdleMsg_2[56] = "IdlePickaxeFloorExit"
    IdleMsg_2[57] = "IdlePickaxeTableExit"
    IdleMsg_2[58] = "AddToInventory"
    IdleMsg_2[59] = "mIdle"
    IdleMsg_2[60] = "Backward"
    IdleMsg_2[61] = "Forward"
    IdleMsg_2[62] = "Left"
    IdleMsg_2[63] = "Right"
    IdleMsg_2[64] = "IdleDLC02MiraakDeathFinish"
    IdleMsg_2[65] = "pKnockdown"
    IdleMsg_2[66] = "Backstab"
    IdleMsg_2[67] = "Wounded02"
    IdleMsg_2[68] = "Dodge_Left"
    IdleMsg_2[69] = "Dodge_Back"
    IdleMsg_2[70] = "Dodge_Right"
    IdleMsg_2[71] = "pIdlePresentSkeletonKey"
    IdleMsg_2[72] = "EBO_IDLE_ChairDrinkingStart"
    IdleMsg_2[73] = "IdleAlchemyEnter"
    IdleMsg_2[74] = "IdleSitCrossLeggedEnter"
    IdleMsg_2[75] = "IdleDialogueDefensiveHandGesture"
    IdleMsg_2[76] = "ExitCartBegin"
    IdleMsg_2[77] = "ExitCartEnd"
    IdleMsg_2[78] = "IdleCartExitInstant"
    IdleMsg_2[79] = "IdleCartDriverIdle"
    IdleMsg_2[80] = "IdleGreybeardMeditateEnterInstant"
    IdleMsg_2[81] = "IdleGreybeardMeditateExit"
    IdleMsg_2[82] = "WakeUp"
    IdleMsg_2[83] = "MRh_SelfChargeStart"
    IdleMsg_2[84] = "MLh_AimedChargeEnter"
    IdleMsg_2[85] = "MRh_AimedChargeEnter"
    IdleMsg_2[86] = "MLh_SpellRelease_Event"
    IdleMsg_2[87] = "MRh_SpellRelease_Event"
    IdleMsg_2[88] = "bWantCastLeft"
    IdleMsg_2[89] = "bWantCastRight"
    IdleMsg_2[90] = "AO_IdleTake"
    IdleMsg_2[91] = "AO_IdleLockPick"
    IdleMsg_2[92] = "idlesilentbow"
    IdleMsg_2[93] = "idlesearchchestenter"
    IdleMsg_2[94] = "OffsetStop"
    IdleMsg_2[95] = "idlewave"
    IdleMsg_2[96] = "idlesalute"
    IdleMsg_2[97] = "idleapplaud2"
    IdleMsg_2[98] = "idlewoodpickupenter"
    IdleMsg_2[99] = "idleTG03UseMeadBarrel"
    IdleMsg_2[100] = "idlepickup_ground"
    IdleMsg_2[101] = "idlecarrybucketpourenter"
    IdleMsg_2[102] = "IdleCombatStretchingStart"
    IdleMsg_2[103] = "HoverIdle"
    IdleMsg_2[104] = "FlightHovering"
    IdleMsg_2[105] = "MillLogIdleReset"
    IdleMsg_2[106] = "BlacksmithSharpeningWheelIdle"
    IdleMsg_2[107] = "IdleHoe"
    IdleMsg_2[108] = "IdleStop"
    IdleMsg_2[109] = "IdleCraftingCookingPotAddIngredient"
    IdleMsg_2[110] = "IdleFurnitureExit"
    IdleMsg_2[111] = "IdleCartPlayerIdle"
    IdleMsg_2[112] = "IdleCartPlayerExit"
    IdleMsg_2[113] = "ForceIdle"
    IdleMsg_2[114] = "AttackLeft"
    IdleMsg_2[115] = "AttackLeftFar"
    IdleMsg_2[116] = "AttackLeftNear"
    IdleMsg_2[117] = "AttackRight"
    IdleMsg_2[118] = "AttackRightFar"
    IdleMsg_2[119] = "AttackRightNear"
    IdleMsg_2[120] = "Die"
    IdleMsg_2[121] = "IdleSparse"
    IdleMsg_2[122] = "IdleFull"
    IdleMsg_2[123] = "IdleEmpty"
    IdleMsg_2[124] = "IdleGive"
    IdleMsg_2[125] = "idlereadyharvested"
    IdleMsg_2[126] = "Harvest"
    IdleMsg_2[127] = "TG05GetUp"
    
  String searchTerm = self.StringFromSArgument(sArgument, 1)
  Bool found = false
  Int i = 0

  While i < 128
    If StringUtil.Find(IdleMsg[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(IdleMsg[i])
      found = true
    EndIf
    i += 1
  Endwhile
  While i < 128
    If StringUtil.Find(IdleMsg_2[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(IdleMsg_2[i])
      found = true
    EndIf
    i += 1
  Endwhile

  if !found
    PrintMessage("No matching help message found")
  endif
  PrintMessage("======================================================================")

EndEvent

Event OnConsolePlayIdle(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlayIdle([Actor akTarget = GetSelectedReference()], Idle akIdle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Idle akIdle = self.FormFromSArgument(sArgument, 1) as Idle
  If akActor == none || akIdle == none
    PrintMessage("FATAL ERROR: Form retrieval error")
    Return
  EndIf
  bool result = akActor.PlayIdle(akIdle)
  PrintMessage("PlayIdle: " + result)
EndEvent

Event OnConsolePlayIdleWithTarget(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlayIdleWithTarget([Actor akActor = GetSelectedReference()], ObjectReference akTarget, Idle akIdle, ObjectReference akTarget)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  ObjectReference akTarget = self.RefFromSArgument(sArgument, 1)
  Idle akIdle = self.FormFromSArgument(sArgument, 2) as Idle
  If akActor == none || akIdle == none || akTarget == none
    PrintMessage("FATAL ERROR: Form retrieval error")
    Return
  EndIf
  bool result = akActor.PlayIdleWithTarget(akIdle, akTarget)
  PrintMessage(self.GetFullID(akActor) +  " is now playing" + self.GetFullID(akIdle) + " with " + self.GetFullID(akTarget))
EndEvent

Event OnConsolePlaySubGraphAnimation(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlaySubGraphAnimation([Actor akActor = GetSelectedReference()], string asEventName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  string asEventName = self.StringFromSArgument(sArgument, 1)
  If akActor == none
    PrintMessage("FATAL ERROR: Form retrieval error")
    Return
  EndIf
  akActor.PlaySubGraphAnimation(asEventName)
  PrintMessage("PlaySubGraphAnimation: " + asEventName)
EndEvent

Event OnConsoleSetShaderType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetShaderType(ObjectReference akRef, ObjectReference akTemplate, String asDiffusePath, int aiShaderType, int aiTextureType, bool abNoWeapons, bool abNoAlphaProperty)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("SHADER TYPE HELP")
    PrintMessage("=============================")
    PrintMessage("kDefault									 0")
    PrintMessage("kEnvironmentMap						 1")
    PrintMessage("kGlowMap									 2")
    PrintMessage("kParallax		 						 	 3")
    PrintMessage("kFaceGen									 4")
    PrintMessage("kFaceGenRGBTint					   5")
    PrintMessage("kHairTint									 6")
    PrintMessage("kParallaxOcc							 7")
    PrintMessage("kMultiTexLand						 	 8")
    PrintMessage("kLODLand									 9")
    PrintMessage("kMultilayerParallax				11")
    PrintMessage("kTreeAnim									12")
    PrintMessage("kMultiIndexTriShapeSnow		14")
    PrintMessage("kLODObjectsHD							15")
    PrintMessage("kEye											16")
    PrintMessage("kCloud										17")
    PrintMessage("kLODLandNoise							18")
    PrintMessage("kMultiTexLandLODBlend			19")
    PrintMessage("=============================")
    Return
  EndIf

  ObjectReference akRef = ConsoleUtil.GetSelectedReference() as ObjectReference
  ObjectReference akTemplate = self.RefFromSArgument(sArgument, 1)
  String asDiffusePath = self.StringFromSArgument(sArgument, 2)
  int aiShaderType = self.IntFromSArgument(sArgument, 3)
  int aiTextureType = self.IntFromSArgument(sArgument, 4)
  bool abNoWeapons = self.BoolFromSArgument(sArgument, 5)
  bool abNoAlphaProperty = self.BoolFromSArgument(sArgument, 6)

  If akRef == none || akTemplate == none
    PrintMessage("FATAL ERROR: Reference or Template retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetShaderType(akRef, akTemplate, asDiffusePath, aiShaderType, aiTextureType, abNoWeapons, abNoAlphaProperty)
  PrintMessage("SetShaderType applied to " + self.GetFullID(akRef) + " using template " + akTemplate)
EndEvent

Event OnConsoleIsScriptAttachedToForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: IsScriptAttachedToForm(Form akForm, String asScriptName)")
  PrintMessage("Note: If asScriptName is empty, it will return if the form has any non-base scripts attached")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Form akForm = self.FormFromSArgument(sArgument, 1)
  String asScriptName = self.StringFromSArgument(sArgument, 2)

  If akForm == none
    PrintMessage("FATAL ERROR: Form retrieval failed")
    Return
  EndIf

  bool result = PO3_SKSEFunctions.IsScriptAttachedToForm(akForm, asScriptName)
  PrintMessage("IsScriptAttachedToForm: " + result)
EndEvent

Event OnConsoleGetScriptsAttachedToForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetScriptsAttachedToForm(Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)

  String[] scripts = PO3_SKSEFunctions.GetScriptsAttachedToForm(akForm)
  int i = 0
  int L = scripts.length

  If L > 0
    PrintMessage(L + " scripts attached to " + self.GetFullID(akForm) + ":")
  Else
    PrintMessage("No scripts attached to " + self.GetFullID(akForm))
    Return
  EndIf

  While i < L
    PrintMessage("Script #" + i + ": " + scripts[i])
    i += 1
  EndWhile
EndEvent

Event OnConsoleRemoveMagicEffectFromSpell(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveMagicEffectFromSpell(Spell akSpell, MagicEffect akMagicEffect, float afMagnitude, int aiArea, int aiDuration, float afCost = 0.0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 2) as MagicEffect
  float afMagnitude = self.FloatFromSArgument(sArgument, 3)
  int aiArea = self.IntFromSArgument(sArgument, 4)
  int aiDuration = self.IntFromSArgument(sArgument, 5)
  float afCost = self.FloatFromSArgument(sArgument, 6)
  If akSpell == none || akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.RemoveMagicEffectFromSpell(akSpell, akMagicEffect, afMagnitude, aiArea, aiDuration, afCost)
  PrintMessage("Removed " + self.GetFullID(akMagicEffect) + " from " + self.GetFullID(akSpell))
EndEvent

Event OnConsoleGetSpellType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSpellType(Spell akSpell)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("SPELL TYPE HELP")
    PrintMessage("=================")
    PrintMessage("01 None")
    PrintMessage("02 Spell")
    PrintMessage("03 Disease")
    PrintMessage("04 Power")
    PrintMessage("05 LesserPower")
    PrintMessage("06 Ability")
    PrintMessage("07 Poison")
    PrintMessage("08 Enchantment")
    PrintMessage("09 Potion")
    PrintMessage("10 Ingredient")
    PrintMessage("11 LeveledSpell")
    PrintMessage("12 Addiction")
    PrintMessage("13 Voice")
    PrintMessage("=================")
    Return
  EndIf

  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell

  If akSpell == none
    PrintMessage("FATAL ERROR: Spell retrieval failed")
    Return
  EndIf

  int spellType = PO3_SKSEFunctions.GetSpellType(akSpell)
  String spellTypeName = ""
  
  if spellType == -1
    spellTypeName = "None"
  ElseIf spellType == 0
    spellTypeName = "Spell"
  ElseIf spellType == 1
    spellTypeName = "Disease"
  ElseIf spellType == 2
    spellTypeName = "Power"
  ElseIf spellType == 3
    spellTypeName = "LesserPower"
  ElseIf spellType == 4
    spellTypeName = "Ability"
  ElseIf spellType == 5
    spellTypeName = "Poison"
  ElseIf spellType == 6
    spellTypeName = "Enchantment"
  ElseIf spellType == 7
    spellTypeName = "Potion"
  ElseIf spellType == 8
    spellTypeName = "Ingredient"
  ElseIf spellType == 9
    spellTypeName = "LeveledSpell"
  ElseIf spellType == 10
    spellTypeName = "Addiction"
  ElseIf spellType == 11
    spellTypeName = "Voice"
  Else
    spellTypeName = "Unknown"
  EndIf

  PrintMessage("Spell type of " + self.GetFullID(akSpell) + " is " + spellType + " (" + spellTypeName + ")")
EndEvent

Event OnConsoleSetSpellCastingType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellCastingType(Spell akSpell, int aiType)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("CASTING TYPE HELP")
    PrintMessage("==================")
    PrintMessage("0 Constant Effect")
    PrintMessage("1 Fire and Forget")
    PrintMessage("2 Concentration")
    PrintMessage("==================")
    Return
  EndIf

  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  int aiType = self.IntFromSArgument(sArgument, 2)  
  String castingTypeName = ""
  
  If aiType == 0
    castingTypeName = "Constant Effect"
  ElseIf aiType == 1
    castingTypeName = "Fire and Forget"
  ElseIf aiType == 2
    castingTypeName = "Concentration"
  EndIf

  If akSpell == none
    PrintMessage("FATAL ERROR: Spell retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetSpellCastingType(akSpell, aiType)
  PrintMessage("Spell casting type of " + self.GetFullID(akSpell) + " is now " + aiType + "(" + castingTypeName + ")")
EndEvent

Event OnConsoleSetSpellDeliveryType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellDeliveryType(Spell akSpell, int aiType)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("DELIVERY TYPE HELP")
    PrintMessage("==================")
    PrintMessage("0 Self")
    PrintMessage("1 Touch")
    PrintMessage("2 Aimed")
    PrintMessage("3 Target Actor")
    PrintMessage("4 Target Location")
    PrintMessage("==================")
    Return
  EndIf

  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  int aiType = self.IntFromSArgument(sArgument, 2)
  String deliveryTypeName = ""
  
  If aiType == 0
    deliveryTypeName = "Self"
  ElseIf aiType == 1
    deliveryTypeName = "Touch"
  ElseIf aiType == 2
    deliveryTypeName = "Aimed"
  ElseIf aiType == 3
    deliveryTypeName = "Target Actor"
  ElseIf aiType == 4
    deliveryTypeName = "Target Location"
  EndIf

  If akSpell == none
    PrintMessage("FATAL ERROR: Spell retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetSpellDeliveryType(akSpell, aiType)
  PrintMessage("Delivery type of " + self.GetFullID(akSpell) + " is now " + aiType + "(" + deliveryTypeName + ")")
EndEvent

Event OnConsoleSetSpellType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellType(Spell akSpell, int aiType)")
  PrintMessage("SPELL TYPE HELP")
  PrintMessage("=================")
  PrintMessage("-1  None")
  PrintMessage("0   Spell")
  PrintMessage("1   Disease")
  PrintMessage("2   Power")
  PrintMessage("3   LesserPower")
  PrintMessage("4   Ability")
  PrintMessage("5   Poison")
  PrintMessage("6   Enchantment")
  PrintMessage("7   Potion")
  PrintMessage("8   Ingredient")
  PrintMessage("9   LeveledSpell")
  PrintMessage("10  Addiction")
  PrintMessage("11  Voice")
  PrintMessage("=================")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  int aiType = self.IntFromSArgument(sArgument, 2)

  If akSpell == none
    PrintMessage("FATAL ERROR: Spell retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetSpellType(akSpell, aiType)
  PrintMessage("Spell type of " + self.GetFullID(akSpell) + " is now " + aiType)
EndEvent

Event OnConsoleSetSpellMagicEffect(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellMagicEffect(Spell akSpell, MagicEffect akMagicEffect, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 2) as MagicEffect
  int aiIndex = self.IntFromSArgument(sArgument, 3)

  If akSpell == none || akMagicEffect == none
    PrintMessage("FATAL ERROR: Spell or MagicEffect retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetSpellMagicEffect(akSpell, akMagicEffect, aiIndex)
  PrintMessage(self.GetFullID(akSpell) + "'s magic effect was replaced with " + self.GetFullID(akMagicEffect))
EndEvent

Event OnConsoleGetLastPlayerActivatedRef(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLastPlayerActivatedRef()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  ObjectReference akRef = DbSKSEFunctions.GetLastPlayerActivatedRef()

  If !akRef
    PrintMessage("No reference found")
  Else
    PrintMessage("Last player activated reference was " + self.GetFullID(akRef))
  EndIf
EndEvent

Event OnConsoleGetLastPlayerMenuActivatedRef(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLastPlayerMenuActivatedRef()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  ObjectReference akRef = DbSKSEFunctions.GetLastPlayerMenuActivatedRef()

  If !akRef
    PrintMessage("No reference found")
  Else
    PrintMessage("Last player menu activated reference was " + self.GetFullID(akRef))
  EndIf
EndEvent

Event OnConsoleSetObjectRefFlag(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetObjectRefFlag(ObjectReference akObject, Int aiFlag, Bool abTurnOn = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("RECORD FLAG HELP")
    PrintMessage("===============================================")
    PrintMessage("0 kIsGroundPiece")
    PrintMessage("1 kCollisionsDisabled -> unknown?")
    PrintMessage("2 kDeleted")
    PrintMessage("3 kHiddenFromLocalMap -> only for statics!")
    PrintMessage("4 kTurnOffFire")
    PrintMessage("5 kInaccessible -> only for doors!")
    PrintMessage("6 kLODRespectsEnableState  -> only for statics!")
    PrintMessage("7 kStartsDead  -> only for actors!")
    PrintMessage("8 kDoesntLightWater")
    PrintMessage("9 kMotionBlur  -> only for statics!")
    PrintMessage("10 kPersistent")
    PrintMessage("11 kInitiallyDisabled")
    PrintMessage("12 kIgnored")
    PrintMessage("13 kStartUnconscious  -> only for actors!")
    PrintMessage("14 kSkyMarker")
    PrintMessage("15 kHarvested   -> only for trees!")
    PrintMessage("16 kIsFullLOD   -> only for actors!")
    PrintMessage("17 kNeverFades   -> only for lights!")
    PrintMessage("18 kDoesntLightLandscape")
    PrintMessage("19 kIgnoreFriendlyHits   -> only for actors!")
    PrintMessage("20 kNoAIAcquire")
    PrintMessage("21 kCollisionGeometry_Filter")
    PrintMessage("22 kCollisionGeometry_BoundingBox")
    PrintMessage("23 kReflectedByAutoWater")
    PrintMessage("24 kDontHavokSettle")
    PrintMessage("25 kGround")
    PrintMessage("26 kRespawns")
    PrintMessage("27 kMultibound")
    PrintMessage("===============================================")
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  Int aiFlag = self.IntFromSArgument(sArgument, 2)
  Bool abTurnOn = self.BoolFromSArgument(sArgument, 3, true)
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  PrintMessage("This function is currently a work in progress")
  ; ANDR_PapyrusFunctions.SetObjectRefFlag(akRef, aiFlag, abTurnOn)
  ; If abTurnOn
  ;   PrintMessage("Flag " + aiFlag + " for reference " + self.GetFullID(akRef) + " was turned on")
  ; Else
  ;   PrintMessage("Flag " + aiFlag + " for reference " + self.GetFullID(akRef) + " was turned off")
  ; EndIf
EndEvent

Event OnConsoleGetNthOutfitPart(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNthOutfitPart(Outfit akOutfit, int n)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Outfit akOutfit = self.FormFromSArgument(sArgument, 1) as Outfit
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  
  If akOutfit == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("Part " + aiIndex + " of " + self.GetFullID(akOutfit) + " is " + self.GetFullID(akOutfit.GetNthPart(aiIndex)))
EndEvent

Event OnConsoleGetActorbaseHeight(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorbaseHeight [<Actorbase>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase
  float Height
  If QtyPars == 0
    akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  ElseIf QtyPars == 1
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  Height = akActorbase.GetHeight() ; 1 is first argument, which is second term in sArgument
  PrintMessage("Height of " + self.GetFullID(akActorbase) + " is " + Height as String)
EndEvent

Event OnConsoleSetActorbaseHeight(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorbaseHeight [<Actorbase>] <float Height>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase
  float Height
  If QtyPars == 1
    akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
    Height = self.FloatFromSArgument(sArgument, 1) as float
  ElseIf QtyPars == 2
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
    Height = self.FloatFromSArgument(sArgument, 2) as float
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  akActorbase.SetHeight(Height) ; 1 is first argument, which is second term in sArgument
  PrintMessage("Height of " + self.GetFullID(akActorbase) + " set to " + Height as String)
EndEvent

Event OnConsoleGetCurrentMusicType(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetCurrentMusicType()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PrintMessage("Current music type is " + DbSKSEFunctions.GetCurrentMusicType())
EndEvent

Event OnConsoleGetNumberOfTracksInMusicType(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNumberOfTracksInMusicType(MusicType akMusicType)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MusicType akMusicType = FormFromSArgument(sArgument, 1) as MusicType
  If akMusicType == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  PrintMessage("Current music type is " + DbSKSEFunctions.GetNumberOfTracksInMusicType(akMusicType))
EndEvent

Event OnConsoleGetMusicTypeTrackIndex(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMusicTypeTrackIndex(MusicType akMusicType)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MusicType akMusicType = FormFromSArgument(sArgument, 1) as MusicType
  If akMusicType == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  PrintMessage("Current music type is " + DbSKSEFunctions.GetMusicTypeTrackIndex(akMusicType))
EndEvent

Event OnConsoleSetMusicTypeTrackIndex(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMusicTypeTrackIndex(MusicType akMusicType, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MusicType akMusicType = FormFromSArgument(sArgument, 1) as MusicType
  If akMusicType == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  int aiIndex = IntFromSArgument(sArgument, 1)
  PrintMessage("Current music type track index is " + DbSKSEFunctions.GetMusicTypeTrackIndex(akMusicType))
  PrintMessage("Attempting to update..")
  DbSKSEFunctions.SetMusicTypeTrackIndex(akMusicType, aiIndex)
  PrintMessage("New music type track index  is " + DbSKSEFunctions.GetMusicTypeTrackIndex(akMusicType))
EndEvent

Event OnConsoleGetMusicTypePriority(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMusicTypePriority(MusicType akMusicType)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MusicType akMusicType = FormFromSArgument(sArgument, 1) as MusicType
  If akMusicType == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  PrintMessage("Current music type is " + DbSKSEFunctions.GetMusicTypePriority(akMusicType))
EndEvent

Event OnConsoleSetMusicTypePriority(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMusicTypePriority(MusicType akMusicType, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MusicType akMusicType = FormFromSArgument(sArgument, 1) as MusicType
  If akMusicType == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  int aiIndex = IntFromSArgument(sArgument, 1)
  PrintMessage("Current music type priority is " + DbSKSEFunctions.GetMusicTypePriority(akMusicType))
  PrintMessage("Attempting to update..")
  DbSKSEFunctions.SetMusicTypePriority(akMusicType, aiIndex)
  PrintMessage("New music type priority is " + DbSKSEFunctions.GetMusicTypePriority(akMusicType))
EndEvent

Event OnConsoleGetMusicTypeStatus(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMusicTypeStatus(MusicType akMusicType)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MusicType akMusicType = FormFromSArgument(sArgument, 1) as MusicType
  If akMusicType == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  int iMTStatus = DbSKSEFunctions.GetMusicTypeStatus(akMusicType)
  string sMTStatus

  If iMTStatus == 0
    sMTStatus = "kInactive"
  ElseIf iMTStatus == 1
    sMTStatus = "kPlaying"
  ElseIf iMTStatus == 2
    sMTStatus = "kPaused"
  ElseIf iMTStatus == 3
    sMTStatus = "kFinishing"
  ElseIf iMTStatus == 4
    sMTStatus = "kFinished"
  EndIf

  PrintMessage("Current music type is " + iMTStatus + " ( " + sMTStatus + ")")
EndEvent

Event OnConsoleDispelEffect(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: DispelMagicEffectOnRef(ObjectReference akRef, MagicEffect akMagicEffect, Form akMagicSource = none)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  MagicEffect akMagicEffect
  Form akMagicSource
  If QtyPars == 2
    akRef = ConsoleUtil.GetSelectedReference()
    akMagicEffect = FormFromSArgument(sArgument, 1) as MagicEffect
    akMagicSource = FormFromSArgument(sArgument, 2)
  ElseIf QtyPars == 3
    akRef = self.RefFromSArgument(sArgument, 1)
    akMagicEffect = FormFromSArgument(sArgument, 2) as MagicEffect
    akMagicSource = FormFromSArgument(sArgument, 3)
  EndIf
  If akRef == none || akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  DbSKSEFunctions.DispelMagicEffectOnRef(akRef, akMagicEffect, akMagicSource)
EndEvent

Event OnConsoleBlendColorWithSkinTone(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: BlendColorWithSkinTone([Actor akActor = GetSelectedReference()], ColorForm akColor, int aiBlendMode = 1, bool abAutoLuminance = true, float afOpacity = 1.0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("BLEND MODE HELP")
    PrintMessage("==================")
    PrintMessage("Darken					0")
    PrintMessage("Multiply				1")
    PrintMessage("ColorBurn				2")
    PrintMessage("LinearBurn			3")
    PrintMessage("DarkerColor			4")
    PrintMessage("Lighten					5")
    PrintMessage("Screen					6")
    PrintMessage("ColorDodge			7")
    PrintMessage("LinearDodge			8")
    PrintMessage("LighterColor		9")
    PrintMessage("Overlay					10")
    PrintMessage("SoftLight				11")
    PrintMessage("HardLight				12")
    PrintMessage("VividLight			13")
    PrintMessage("LinearLight			14")
    PrintMessage("PinLight				15")
    PrintMessage("HardMix					16")
    PrintMessage("Difference			17")
    PrintMessage("Exclusion				18")
    PrintMessage("Subtract				19")
    PrintMessage("Divide					20")
    PrintMessage("==================")
    Return
  EndIf
  Actor akActor
  ColorForm akColor
  int aiBlendMode
  bool abAutoLuminance
  float afOpacity
  If QtyPars == 4
    akActor = ConsoleUtil.GetSelectedReference() as Actor
    akColor = FormFromSArgument(sArgument, 1) as ColorForm
    aiBlendMode = IntFromSargument(sArgument, 2, 1)
    abAutoLuminance = BoolFromSArgument(sArgument, 3, true)
    afOpacity = FloatFromSArgument(sArgument, 4, 1.0)
  ElseIf QtyPars == 5
    akActor = RefFromSArgument(sArgument, 1) as Actor
    akColor = FormFromSArgument(sArgument, 2) as ColorForm
    aiBlendMode = IntFromSargument(sArgument, 3, 1)
    abAutoLuminance = BoolFromSArgument(sArgument, 4, true)
    afOpacity = FloatFromSArgument(sArgument, 5, 1.0)
  EndIf
  If akActor == none || akColor == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  PO3_SKSEFunctions.BlendColorWithSkinTone(akActor, akColor, aiBlendMode, abAutoLuminance, afOpacity)
EndEvent

Event OnConsoleGetEquippedArmorInSlot(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetEquippedArmorInSlot(Actor akActor, int aiSlot)")
  PrintMessage("Leaving aiSlot empty or setting it to 0 will print all equipped armor in slots 30-60")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Armor equippedArmor
  int aiSlot = self.IntFromSArgument(sArgument, 1)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  If aiSlot == 0
    int i = 30
    While i < 61
      equippedArmor = akActor.GetEquippedArmorInSlot(i)
      If equippedArmor != none
        PrintMessage("Equipped armor in slot " + i + ": " + self.GetFullID(equippedArmor))
      Else
        PrintMessage("No armor equipped in slot " + i)
      EndIf
      i += 1
    EndWhile
  Else
    equippedArmor = akActor.GetEquippedArmorInSlot(aiSlot)
    If equippedArmor != none
      PrintMessage("Equipped armor in slot " + aiSlot + ": " + self.GetFullID(equippedArmor))
    Else
      PrintMessage("No armor equipped in slot " + aiSlot)
    EndIf
  EndIf
EndEvent

Event OnConsoleSetHeadpartAlpha(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHeadpartAlpha(Actor akActor, int aiPartType, float afAlpha)") 
  PrintMessage("PARTTYPE HELP")
  PrintMessage("==========")
  PrintMessage("0	Mouth")
  PrintMessage("1	Head")
  PrintMessage("2	Eyes")
  PrintMessage("3	Hair")
  PrintMessage("4	Beard")
  PrintMessage("5	Scar")
  PrintMessage("6	Brows")
  PrintMessage("==========")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  int aiPartType = self.IntFromSArgument(sArgument, 1)
  float afAlpha = self.FloatFromSArgument(sArgument, 2)

  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHeadpartAlpha(akActor, aiPartType, afAlpha)
  PrintMessage("Set skin alpha of headpart type #" + aiPartType + " from " + self.GetFullID(akActor) + " to opacity " + afAlpha)
EndEvent

Event OnConsoleGetActorRefraction(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorRefraction(Actor akActor)") 
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor

  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  float Refraction = PO3_SKSEFunctions.GetActorRefraction(akActor)
  PrintMessage("Refraction of " + self.GetFullID(akActor) + " is " + Refraction)
EndEvent

Event OnConsoleSetActorRefraction(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorRefraction(Actor akActor, float afRefraction)") 
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  float afRefraction = self.FloatFromSArgument(sArgument, 1)

  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetActorRefraction(akActor, afRefraction)
  PrintMessage("Set refraction of " + self.GetFullID(akActor) + " to " + afRefraction)
EndEvent

Event OnConsoleRevertSkinOverlays(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RevertSkinOverlays [<Actor akActor>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.RevertOverlays(akActor)
  PrintMessage("Reverted skin overlays of " + self.GetFullID(akActor))
EndEvent

Event OnConsoleRevertHeadOverlays(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RevertHeadOverlays [<Actor akActor>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.RevertHeadOverlays(akActor)
  PrintMessage("Reverted head overlays of " + self.GetFullID(akActor))
EndEvent

Event OnConsoleGetEquippedShout(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetEquippedShout(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If akActor == none
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf 
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  PrintMessage(self.GetFullID(akActor) + "'s ' equipped shout is " + akActor.GetEquippedShout())
EndEvent

Event OnConsoleGetEquippedShield(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetEquippedShield(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If akActor == none
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf 
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  PrintMessage(self.GetFullID(akActor) + "'s ' equipped shout is " + self.GetFullID(akActor.GetEquippedShield()))
EndEvent

Event OnConsoleGetEquippedWeapon(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetEquippedWeapon(Actor akActor, bool abLeftHand = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  bool abLeftHand = self.BoolFromSArgument(sArgument, 1)
  If akActor == none
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    abLeftHand = self.BoolFromSArgument(sArgument, 2)
  EndIf 
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  string handText = "right hand"
  If abLeftHand
    handText = "left hand"
  EndIf
  PrintMessage(self.GetFullID(akActor) + "'s ' equipped " + handText + " weapon is " + self.GetFullID(akActor.GetEquippedWeapon(abLeftHand)))
EndEvent

Event OnConsoleGetEquippedSpell(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetEquippedSpell(Actor akActor, int aiSource = 0)")
  PrintMessage("SOURCE HELP")
  PrintMessage("===============")
  PrintMessage("0 - Left Hand")
  PrintMessage("1 - Right Hand")
  PrintMessage("2 - Other")
  PrintMessage("3 - Instant")
  PrintMessage("===============")
  
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  int aiSource = self.IntFromSArgument(sArgument, 1)
  If akActor == none
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    aiSource = self.IntFromSArgument(sArgument, 2)
  EndIf 
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  string handText
  If aiSource == 0
    handText = "left hand"
  ElseIf aiSource == 1
    handText = "right hand"
  ElseIf aiSource == 2
    handText = "other"
  ElseIf aiSource == 3
    handText = "instant"
  EndIf
  PrintMessage(self.GetFullID(akActor) + "'s ' equipped " + handText + " spell is " + self.GetFullID(akActor.GetEquippedSpell(aiSource)))
EndEvent

Event OnConsoleGetNthTexturePath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNthTexturePath [<TextureSet akTXST>] <int aiN>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  TextureSet akTXST = self.FormFromSArgument(sArgument, 1) as TextureSet
  int aiN
  If QtyPars == 1
    aiN = self.IntFromSArgument(sArgument, 1)
  Else
    akTXST = self.FormFromSArgument(sArgument, 1) as TextureSet
    aiN = self.IntFromSArgument(sArgument, 2)
  EndIf
  If akTXST == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("Texture " + aiN + " of " + self.GetFullID(akTXST) + " is " + akTXST.GetNthTexturePath(aiN))
EndEvent

Event OnConsoleSetNthTexturePath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetNthTexturePath <TextureSet akTXST> <int aiN> <string asPath>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  TextureSet akTXST = self.FormFromSArgument(sArgument, 1) as TextureSet
  int aiN = self.IntFromSArgument(sArgument, 2)
  string asPath = DbMiscFunctions.RemovePrefixFromString(sArgument, self.StringFromSArgument(sArgument, 0) + " " +  self.StringFromSArgument(sArgument, 1) + " " + self.StringFromSArgument(sArgument, 2) + " ")
  If akTXST == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("Texture " + aiN + " of " + self.GetFullID(akTXST) + " was " + akTXST.GetNthTexturePath(aiN))
  akTXST.SetNthTexturePath(aiN, asPath)
  
  PrintMessage("Texture " + aiN + " of " + self.GetFullID(akTXST) + " is now " + akTXST.GetNthTexturePath(aiN))
EndEvent

Event OnConsoleQueueNiNodeUpdate(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: QueueNiNodeUpdate [<Actor akActor>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  If akActor.IsOnMount()
    PrintMessage("FATAL ERROR: Actor is on mount. Cannot use QueueNiNodeUpdate.")
    Return
  EndIf
  akActor.QueueNiNodeUpdate()
  PrintMessage("Queued NiNodeUpdate of " + self.GetFullID(akActor))
EndEvent

Event OnConsoleGetABFaceTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorbaseFaceTextureSet([Actorbase akActorbase = GetSelectedReference().GetActorBase()])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  TextureSet akTXST =  akActorbase.GetFaceTextureSet()
  PrintMessage("Face texture of " + self.GetFullID(akActorbase) + " is " + self.GetFullID(akTXST))
EndEvent

Event OnConsoleSetABFaceTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorbaseFaceTextureSet([Actor akActor = GetSelectedReference()], TextureSet akNewTXST)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  TextureSet akNewTXST = self.FormFromSArgument(sArgument, 1) as TextureSet
  If akActorbase == none || akNewTXST == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Face texture of " + self.GetFullID(akActorbase) + " is " + self.GetFullID(akActorbase.GetFaceTextureSet()))
  akActorbase.SetFaceTextureSet(akNewTXST)
  If akNewTXST == akActorbase.GetFaceTextureSet()
    PrintMessage("Successfully set face texture of " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akNewTXST))
  Else
    PrintMessage("Failed to set face texture of " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akNewTXST))
    PrintMessage("Face texture of " + self.GetFullID(akActorbase) + " is still " + self.GetFullID(akActorbase.GetFaceTextureSet()))
  EndIf
EndEvent

Event OnConsoleGetActorbaseSkin(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorbaseSkin([Actorbase akActorbase = GetSelectedReference().GetActorBase()])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  Armor akSkin = akActorbase.GetSkin()
  PrintMessage("Skin of " + self.GetFullID(akActorbase) + " is " + self.GetFullID(akSkin))
EndEvent

Event OnConsoleSetActorbaseSkin(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSkin([Actor akActor = GetSelectedReference()], Armor akNewSkin)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  Armor akNewSkin = self.FormFromSArgument(sArgument, 1) as Armor
  If akActorbase == none || akNewSkin == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Skin of " + self.GetFullID(akActorbase) + " is " + self.GetFullID(akActorbase.GetSkin()))
  akActorbase.SetSkin(akNewSkin)
  If akNewSkin == akActorbase.GetSkin()
    PrintMessage("Successfully set skin of " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akNewSkin))
  Else
    PrintMessage("Failed to set skin of " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akNewSkin))
    PrintMessage("Skin of " + self.GetFullID(akActorbase) + " is still " + self.GetFullID(akActorbase.GetSkin()))
  EndIf
EndEvent

Event OnConsoleGetActorbaseSkinFar(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorbaseSkinFar([Actorbase akActorbase = GetSelectedReference().GetActorBase()])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  Armor akSkinFar = akActorbase.GetSkinFar()
  PrintMessage("Far skin of " + self.GetFullID(akActorbase) + " is " + self.GetFullID(akSkinFar))
EndEvent

Event OnConsoleSetActorbaseSkinFar(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorbaseSkinFar([Actor akActor = GetSelectedReference()], Armor akNewSkinFar)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  Armor akNewSkinFar = self.FormFromSArgument(sArgument, 1) as Armor
  If akActorbase == none || akNewSkinFar == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Far skin of " + self.GetFullID(akActorbase) + " is " + self.GetFullID(akActorbase.GetSkinFar()))
  akActorbase.SetSkinFar(akNewSkinFar)
  If akNewSkinFar == akActorbase.GetSkinFar()
    PrintMessage("Successfully set SkinFar of " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akNewSkinFar))
  Else
    PrintMessage("Failed to set SkinFar of " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akNewSkinFar))
    PrintMessage("SkinFar of " + self.GetFullID(akActorbase) + " is still " + self.GetFullID(akActorbase.GetSkinFar()))
  EndIf
EndEvent

Event OnConsoleGetSpellCastTime(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSpellCastTime(Spell akSpell)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  If akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Cast time of " + self.GetFullID(akSpell) + " is " + akSpell.GetCastTime())
EndEvent

Event OnConsoleGetSpellMagicEffects(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSpellMagicEffects(Spell akSpell)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  MagicEffect[] result = akSpell.GetMagicEffects()
  int i = 0
  int L = result.Length
  If L > 0
    PrintMessage("Found " + L + " magic effects")
  Else
    PrintMessage("No magic effects found")
    Return
  EndIf
  While i < L
    PrintMessage("Magic effect #" + i + ": " + self.GetFullID(result[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleGetSpellEquipType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSpellEquipType(Spell akSpell)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  If akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Equip type for spell " + self.GetFullID(akSpell) + " is " + akSpell.GetEquipType())
EndEvent

Event OnConsoleSetSpellEquipType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellEquipType(Spell akSpell, EquipSlot akType)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  EquipSlot akType = self.FormFromSArgument(sArgument, 2) as EquipSlot
  If akSpell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Equip type for spell " + self.GetFullID(akSpell) + " was " + akSpell.GetEquipType())
  akSpell.SetEquipType(akType)
  PrintMessage("Equip type for spell " + self.GetFullID(akSpell) + " is now " + akSpell.GetEquipType())
EndEvent

Event OnConsoleCopySpellEquipType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSpellEquipType(Spell akSource, Spell akTarget)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akSource = self.FormFromSArgument(sArgument, 1) as Spell
  Spell akTarget = self.FormFromSArgument(sArgument, 2) as Spell
  If akSource == none || akTarget == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  EquipSlot akType = akSource.GetEquipType()
  PrintMessage("Equip type for spell " + self.GetFullID(akTarget) + " was " + akTarget.GetEquipType())
  akTarget.SetEquipType(akType)
  PrintMessage("Equip type for spell " + self.GetFullID(akTarget) + " is now " + akTarget.GetEquipType())
EndEvent

Event OnConsoleCombineSpells(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CombineSpells(Spell akBase, Spell[] spells, String asName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akBase = self.FormFromSArgument(sArgument, 1) as Spell
  Spell[] spells = new Spell[1]
  spells[0] = self.FormFromSArgument(sArgument, 2) as Spell
  String asName = self.StringFromSArgument(sArgument, 3)

  If akBase == none || spells[0] == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  bool result = _SE_SpellExtender.combineSpells(akBase, spells, asName)

  _SE_SpellExtender.Process()

  If result
    PrintMessage(self.GetFullID(akBase) + " was successfully combined with " + self.GetFullID(spells[0]))
  EndIf
EndEvent

Event OnConsoleRemoveFormFromFormlist(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveFormFromFormlist(Formlist akFormList, Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Formlist akFormList = self.FormFromSArgument(sArgument, 1) as Formlist
  Form akForm = self.FormFromSArgument(sArgument, 2) as Form

  If akFormList == none || akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If akFormList.HasForm(akForm)
    PrintMessage("Form detected. Attempting to remove it..")
    akFormList.RemoveAddedForm(akForm)
    If akFormList.HasForm(akForm)
      PrintMessage("Form still detected. This function can only remove forms that were added by a script")
      PrintMessage("Try to remove the form using Creation Kit or SSEEdit")
    Else
      PrintMessage("Form removed successfully")
    EndIf
  Else
    PrintMessage("Formlist already doesn`t contain the form")
  EndIf
    
EndEvent

Event OnConsoleGetMagicEffectSound(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectSound(MagicEffect akMagicEffect, int aiType)")
  PrintMessage("MAGIC EFFECT SOUND TYPE HELP")
  PrintMessage("==============================")
  PrintMessage("Draw/Sheathe	0")
  PrintMessage("Charge	1")
  PrintMessage("Ready	2")
  PrintMessage("Release	3")
  PrintMessage("Concentration Cast Loop	4")
  PrintMessage("On Hit	5")
  PrintMessage("==============================")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  int aiType = self.IntFromSArgument(sArgument, 2)

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("Sound " + aiType + " of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(PO3_SKSEFunctions.GetMagicEffectSound(akMagicEffect, aiType)))
    
EndEvent

Event OnConsoleSetMagicEffectSound(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectSound(MagicEffect akMagicEffect, SoundDescriptor akSoundDescriptor, int aiType)")
  PrintMessage("MAGIC EFFECT SOUND TYPE HELP")
  PrintMessage("==============================")
  PrintMessage("Draw/Sheathe	0")
  PrintMessage("Charge	1")
  PrintMessage("Ready	2")
  PrintMessage("Release	3")
  PrintMessage("Concentration Cast Loop	4")
  PrintMessage("On Hit	5")
  PrintMessage("==============================")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  SoundDescriptor akSoundDescriptor = self.FormFromSArgument(sArgument, 2) as SoundDescriptor
  int aiType = self.IntFromSArgument(sArgument, 3)

  If akMagicEffect == none || akSoundDescriptor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PO3_SKSEFunctions.SetMagicEffectSound(akMagicEffect, akSoundDescriptor, aiType)
  PrintMessage("Sound " + aiType + " of " + self.GetFullID(akMagicEffect) + " was " + self.GetFullID(PO3_SKSEFunctions.GetMagicEffectSound(akMagicEffect, aiType)))
  PrintMessage("Set sound " + aiType + " of " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akSoundDescriptor))
  PrintMessage("Sound " + aiType + " of " + self.GetFullID(akMagicEffect) + " is now " + self.GetFullID(PO3_SKSEFunctions.GetMagicEffectSound(akMagicEffect, aiType)))
    
EndEvent

Event OnConsoleGetOutfitNumParts(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetOutfitNumParts(Outfit akOutfit)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Outfit akOutfit = self.FormFromSArgument(sArgument, 1) as Outfit
  If akOutfit == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int numParts = akOutfit.GetNumParts()
  PrintMessage("Number of parts in outfit " + self.GetFullID(akOutfit) + " is " + numParts)
EndEvent

Event OnConsoleGetOutfitNthPart(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetOutfitNthPart(Outfit akOutfit, int n)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Outfit akOutfit = self.FormFromSArgument(sArgument, 1) as Outfit
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  If akOutfit == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Form nthPart = akOutfit.GetNthPart(aiIndex)
  PrintMessage("Part " + aiIndex + " of outfit " + self.GetFullID(akOutfit) + " is " + self.GetFullID(nthPart))
EndEvent

Event OnConsoleAddFormToLeveledItem(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddFormToLeveledItem(LeveledItem akLeveledItem, Form apForm, int aiLevel, int aiCount)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledItem = self.FormFromSArgument(sArgument, 1) as LeveledItem
  Form apForm = self.FormFromSArgument(sArgument, 2)
  int aiLevel = self.IntFromSArgument(sArgument, 3)
  int aiCount = self.IntFromSArgument(sArgument, 4)
  If akLeveledItem == none || apForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akLeveledItem.AddForm(apForm, aiLevel, aiCount)
  PrintMessage("Added form " + self.GetFullID(apForm) + " to leveled item " + self.GetFullID(akLeveledItem) + " at level " + aiLevel + " with count " + aiCount)
EndEvent

Event OnConsoleRevertLeveledItem(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RevertLeveledItem(LeveledItem akLeveledItem)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledItem = self.FormFromSArgument(sArgument, 1) as LeveledItem
  If akLeveledItem == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akLeveledItem.Revert()
  PrintMessage("Reverted leveled item " + self.GetFullID(akLeveledItem))
EndEvent

Event OnConsoleGetLeveledItemChanceNone(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLeveledItemChanceNone(LeveledItem akLeveledItem)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledItem = self.FormFromSArgument(sArgument, 1) as LeveledItem
  If akLeveledItem == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int chanceNone = akLeveledItem.GetChanceNone()
  PrintMessage("Chance none for leveled item " + self.GetFullID(akLeveledItem) + " is " + chanceNone)
EndEvent

Event OnConsoleSetLeveledItemChanceNone(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLeveledItemChanceNone(LeveledItem akLeveledItem, int chance)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledItem = self.FormFromSArgument(sArgument, 1) as LeveledItem
  int chance = self.IntFromSArgument(sArgument, 2)
  If akLeveledItem == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akLeveledItem.SetChanceNone(chance)
  PrintMessage("Set chance none for leveled item " + self.GetFullID(akLeveledItem) + " to " + chance)
EndEvent

Event OnConsoleGetLeveledItemChanceGlobal(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLeveledItemChanceGlobal(LeveledItem akLeveledItem)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledItem = self.FormFromSArgument(sArgument, 1) as LeveledItem
  If akLeveledItem == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  GlobalVariable chanceGlobal = akLeveledItem.GetChanceGlobal()
  PrintMessage("Chance global for leveled item " + self.GetFullID(akLeveledItem) + " is " + self.GetFullID(chanceGlobal))
EndEvent

Event OnConsoleSetLeveledItemChanceGlobal(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLeveledItemChanceGlobal(LeveledItem akLeveledItem, GlobalVariable glob)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledItem = self.FormFromSArgument(sArgument, 1) as LeveledItem
  GlobalVariable glob = self.FormFromSArgument(sArgument, 2) as GlobalVariable
  If akLeveledItem == none || glob == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akLeveledItem.SetChanceGlobal(glob)
  PrintMessage("Set chance global for leveled item " + self.GetFullID(akLeveledItem) + " to " + self.GetFullID(glob))
EndEvent

Event OnConsoleGetLeveledItemNumForms(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLeveledItemNumForms(LeveledItem akLeveledItem)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledItem = self.FormFromSArgument(sArgument, 1) as LeveledItem
  If akLeveledItem == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int numForms = akLeveledItem.GetNumForms()
  PrintMessage("Number of forms in leveled item " + self.GetFullID(akLeveledItem) + " is " + numForms)
EndEvent

Event OnConsoleGetLeveledItemNthForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLeveledItemNthForm(LeveledItem akLeveledItem, int n)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledItem = self.FormFromSArgument(sArgument, 1) as LeveledItem
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  If akLeveledItem == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Form nthForm = akLeveledItem.GetNthForm(aiIndex)
  PrintMessage("Form " + aiIndex + " in leveled item " + self.GetFullID(akLeveledItem) + " is " + self.GetFullID(nthForm))
EndEvent

Event OnConsoleGetLeveledItemthLevel(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLeveledItemNthLevel(LeveledItem akLeveledItem, int n)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledItem = self.FormFromSArgument(sArgument, 1) as LeveledItem
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  If akLeveledItem == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int nthLevel = akLeveledItem.GetNthLevel(aiIndex)
  PrintMessage("Level " + aiIndex + " in leveled item " + self.GetFullID(akLeveledItem) + " is " + nthLevel)
EndEvent

Event OnConsoleSetLeveledItemNthLevel(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLeveledItemNthLevel(LeveledItem akLeveledItem, int n, int level)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledItem = self.FormFromSArgument(sArgument, 1) as LeveledItem
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  int level = self.IntFromSArgument(sArgument, 3)
  If akLeveledItem == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akLeveledItem.SetNthLevel(aiIndex, level)
  PrintMessage("Set level " + aiIndex + " in leveled item " + self.GetFullID(akLeveledItem) + " to " + level)
EndEvent

Event OnConsoleGetLeveledItemNthCount(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLeveledItemNthCount(LeveledItem akLeveledItem, int n)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledItem = self.FormFromSArgument(sArgument, 1) as LeveledItem
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  If akLeveledItem == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int nthCount = akLeveledItem.GetNthCount(aiIndex)
  PrintMessage("Count " + aiIndex + " in leveled item " + self.GetFullID(akLeveledItem) + " is " + nthCount)
EndEvent

Event OnConsoleSetLeveledItemNthCount(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLeveledItemNthCount(LeveledItem akLeveledItem, int n, int count)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledItem = self.FormFromSArgument(sArgument, 1) as LeveledItem
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  int count = self.IntFromSArgument(sArgument, 3)
  If akLeveledItem == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akLeveledItem.SetNthCount(aiIndex, count)
  PrintMessage("Set count " + aiIndex + " in leveled item " + self.GetFullID(akLeveledItem) + " to " + count)
EndEvent

Event OnConsolePlaceDoor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlaceDoor(Door akDoor, ObjectReference akDestination)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Door akDoor = self.FormFromSArgument(sArgument, 1) as Door
  ObjectReference akDestination = self.RefFromSArgument(sArgument, 2)
  If akDoor == none || akDestination == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  ; Place the door in front of the player
  ObjectReference placedDoor = playerRef.PlaceAtMe(akDoor, 1, false, true)

  ; Attach the VMAG_SetDoorDestination script to the placed door
  VMAG_SetDoorDestination doorScript = placedDoor as VMAG_SetDoorDestination
  If doorScript == none
    DbMiscFunctions.AttachPapyrusScript("VMAG_SetDoorDestination", placedDoor)
    doorScript = placedDoor as VMAG_SetDoorDestination
  EndIf

  ; Set the HiddenLoadDoor property on the script
  If doorScript != none
    doorScript.HiddenLoadDoor = akDestination
    PrintMessage("Successfully placed door " + self.GetFullID(placedDoor) + " and set its destination to " + self.GetFullID(akDestination))
  Else
    PrintMessage("Failed to attach VMAG_SetDoorDestination script to the door")
  EndIf
EndEvent

Event OnConsoleGetWorldModelPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetWorldModelPath(Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  string Result = akForm.GetWorldModelPath()
  PrintMessage("World model path of" + self.GetFullID(akForm) + " is " + Result)
EndEvent

Event OnConsoleSetWorldModelPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetWorldModelPath(Form akForm, string asPath)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1)
  string asPath = DbMiscFunctions.RemovePrefixFromString(sArgument, self.StringFromSArgument(sArgument, 0) + " " + self.StringFromSArgument(sArgument, 1) + " ")
  If akForm == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akForm.SetWorldModelPath(asPath)
  PrintMessage("Set world model path of " + self.GetFullID(akForm) + " to " + asPath)
EndEvent

Event OnConsoleCopyWorldModelPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CopyWorldModelPath(Form akSource, Form akTarget)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akSource = self.FormFromSArgument(sArgument, 1)
  Form akTarget = self.FormFromSArgument(sArgument, 2)
  If akSource == none || akTarget == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  String sPath = akSource.GetWorldModelPath()
  akTarget.SetWorldModelPath(sPath)
  PrintMessage("Set world model path of " + self.GetFullID(akTarget) + " to " + sPath)
EndEvent

Event OnConsoleGetArmorEnchantment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorEnchantment [<Armor akArmor>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  Endif
  PrintMessage("Enchantment of object " + self.GetFullID(akArmor) + " is " + self.GetFullID(akArmor.GetEnchantment()))
EndEvent

Event OnConsoleGetWeaponEnchantment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetWeaponEnchantment [<Weapon akWeapon>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Weapon akWeapon = self.FormFromSArgument(sArgument, 1) as Weapon
  If akWeapon == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  Endif
  PrintMessage("Enchantment of object " + self.GetFullID(akWeapon) + " is " + self.GetFullID(akWeapon.GetEnchantment()))
EndEvent

Event OnConsoleHasSkinOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: HasSkinOverride([ObjectReference akActor = GetSelectedReference()], bool isFemale, bool firstPerson, int slotMask, int key, int index)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool isFemale
  bool firstPerson
  int slotMask
  int keyid
  int index

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  isFemale = self.BoolFromSArgument(sArgument, 1)
  firstPerson = self.BoolFromSArgument(sArgument, 2)
  slotMask = self.IntFromSArgument(sArgument, 3)
  keyid = self.IntFromSArgument(sArgument, 4)
  index = self.IntFromSArgument(sArgument, 5)
  If QtyPars == 6
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    isFemale = self.BoolFromSArgument(sArgument, 2)
    firstPerson = self.BoolFromSArgument(sArgument, 3)
    slotMask = self.IntFromSArgument(sArgument, 4)
    keyid = self.IntFromSArgument(sArgument, 5)
    index = self.IntFromSArgument(sArgument, 6)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Check if the override exists
  bool hasOverride = NiOverride.HasSkinOverride(akActor, isFemale, firstPerson, slotMask, keyid, index)
  
  ; Print the result
  PrintMessage("Override exists for actor " + self.GetFullID(akActor) + ": " + IfElse(hasOverride, "Yes", "No"))
  PrintMessage("Details:")
  PrintMessage("- Actor: " + self.GetFullID(akActor))
  PrintMessage("- Gender: " + IfElse(isFemale, "Female", "Male"))
  PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
  PrintMessage("- Slot Mask: " + slotMask)
  PrintMessage("- Key ID: " + keyid)
  PrintMessage("- Index: " + index)
EndEvent

Event OnConsoleAddSkinOverrideFloat(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: AddSkinOverrideFloat([ObjectReference akActor = GetSelectedReference()], bool isFemale, bool firstPerson, int slotMask, int key, int index, float value, bool persist)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool isFemale
  bool firstPerson
  int slotMask
  int keyid
  int index
  float value
  bool persist

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  isFemale = self.BoolFromSArgument(sArgument, 1)
  firstPerson = self.BoolFromSArgument(sArgument, 2)
  slotMask = self.IntFromSArgument(sArgument, 3)
  keyid = self.IntFromSArgument(sArgument, 4)
  index = self.IntFromSArgument(sArgument, 5)
  value = self.FloatFromSArgument(sArgument, 6)
  persist = self.BoolFromSArgument(sArgument, 7, true)
  If QtyPars == 8
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    isFemale = self.BoolFromSArgument(sArgument, 2)
    firstPerson = self.BoolFromSArgument(sArgument, 3)
    slotMask = self.IntFromSArgument(sArgument, 4)
    keyid = self.IntFromSArgument(sArgument, 5)
    index = self.IntFromSArgument(sArgument, 6)
    value = self.FloatFromSArgument(sArgument, 7)
    persist = self.BoolFromSArgument(sArgument, 8, true)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Apply the float override
  NiOverride.AddSkinOverrideFloat(akActor, isFemale, firstPerson, slotMask, keyid, index, value, persist)
  
  ; Verify if the override was applied successfully
  float appliedValue = NiOverride.GetSkinOverrideFloat(akActor, isFemale, firstPerson, slotMask, keyid, index)
  
  If appliedValue == value
    PrintMessage("Successfully applied float override to actor: " + self.GetFullID(akActor))
    PrintMessage("Details:")
    PrintMessage("- Actor: " + akActor.GetDisplayName())
    PrintMessage("- Gender: " + IfElse(isFemale, "Female", "Male"))
    PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
    PrintMessage("- Slot Mask: " + slotMask)
    PrintMessage("- Key ID: " + keyid)
    PrintMessage("- Index: " + index)
    PrintMessage("- Value: " + value)
    PrintMessage("- Persist: " + IfElse(persist, "Yes", "No"))
  Else
    PrintMessage("WARNING: Float override may not have been applied successfully")
    PrintMessage("Expected Value: " + value)
    PrintMessage("Applied Value: " + appliedValue)
  EndIf
EndEvent

Event OnConsoleGetSkinOverrideFloat(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: GetSkinOverrideFloat([ObjectReference akActor = GetSelectedReference()], bool isFemale, bool firstPerson, int slotMask, int key, int index)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool isFemale
  bool firstPerson
  int slotMask
  int keyid
  int index

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  isFemale = self.BoolFromSArgument(sArgument, 1)
  firstPerson = self.BoolFromSArgument(sArgument, 2)
  slotMask = self.IntFromSArgument(sArgument, 3)
  keyid = self.IntFromSArgument(sArgument, 4)
  index = self.IntFromSArgument(sArgument, 5)
  If QtyPars == 6
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    isFemale = self.BoolFromSArgument(sArgument, 2)
    firstPerson = self.BoolFromSArgument(sArgument, 3)
    slotMask = self.IntFromSArgument(sArgument, 4)
    keyid = self.IntFromSArgument(sArgument, 5)
    index = self.IntFromSArgument(sArgument, 6)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Retrieve the float override
  float value = NiOverride.GetSkinOverrideFloat(akActor, isFemale, firstPerson, slotMask, keyid, index)
  
  ; Print the result
  PrintMessage("Retrieved float override for actor " + self.GetFullID(akActor) + ": " + value)
  PrintMessage("Details:")
  PrintMessage("- Actor: " + self.GetFullID(akActor))
  PrintMessage("- Gender: " + IfElse(isFemale, "Female", "Male"))
  PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
  PrintMessage("- Slot Mask: " + slotMask)
  PrintMessage("- Key ID: " + keyid)
  PrintMessage("- Index: " + index)
EndEvent

Event OnConsoleGetSkinPropertyFloat(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: GetSkinPropertyFloat([ObjectReference akActor = GetSelectedReference()], bool firstPerson, int slotMask, int key, int index)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool firstPerson
  int slotMask
  int keyid
  int index

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  firstPerson = self.BoolFromSArgument(sArgument, 1)
  slotMask = self.IntFromSArgument(sArgument, 2)
  keyid = self.IntFromSArgument(sArgument, 3)
  index = self.IntFromSArgument(sArgument, 4)
  If QtyPars == 5
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    firstPerson = self.BoolFromSArgument(sArgument, 2)
    slotMask = self.IntFromSArgument(sArgument, 3)
    keyid = self.IntFromSArgument(sArgument, 4)
    index = self.IntFromSArgument(sArgument, 5)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Retrieve the property value
  float value = NiOverride.GetSkinPropertyFloat(akActor, firstPerson, slotMask, keyid, index)
  
  ; Print the result
  PrintMessage("Retrieved skin property float for actor " + self.GetFullID(akActor) + ": " + value)
  PrintMessage("Details:")
  PrintMessage("- Actor: " + self.GetFullID(akActor))
  PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
  PrintMessage("- Slot Mask: " + slotMask)
  PrintMessage("- Key ID: " + keyid)
  PrintMessage("- Index: " + index)
EndEvent

Event OnConsoleAddSkinOverrideInt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: AddSkinOverrideInt([ObjectReference akActor = GetSelectedReference()], bool isFemale, bool firstPerson, int slotMask, int key, int index, int value, bool persist)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool isFemale
  bool firstPerson
  int slotMask
  int keyid
  int index
  int value
  bool persist

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  isFemale = self.BoolFromSArgument(sArgument, 1)
  firstPerson = self.BoolFromSArgument(sArgument, 2)
  slotMask = self.IntFromSArgument(sArgument, 3)
  keyid = self.IntFromSArgument(sArgument, 4)
  index = self.IntFromSArgument(sArgument, 5)
  value = self.IntFromSArgument(sArgument, 6)
  persist = self.BoolFromSArgument(sArgument, 7, true)
  If QtyPars == 8
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    isFemale = self.BoolFromSArgument(sArgument, 2)
    firstPerson = self.BoolFromSArgument(sArgument, 3)
    slotMask = self.IntFromSArgument(sArgument, 4)
    keyid = self.IntFromSArgument(sArgument, 5)
    index = self.IntFromSArgument(sArgument, 6)
    value = self.IntFromSArgument(sArgument, 7)
    persist = self.BoolFromSArgument(sArgument, 8, true)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Apply the integer override
  NiOverride.AddSkinOverrideInt(akActor, isFemale, firstPerson, slotMask, keyid, index, value, persist)
  
  ; Verify if the override was applied successfully
  int appliedValue = NiOverride.GetSkinOverrideInt(akActor, isFemale, firstPerson, slotMask, keyid, index)
  
  If appliedValue == value
    PrintMessage("Successfully applied integer override to actor: " + self.GetFullID(akActor))
    PrintMessage("Details:")
    PrintMessage("- Actor: " + akActor.GetDisplayName())
    PrintMessage("- Gender: " + IfElse(isFemale, "Female", "Male"))
    PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
    PrintMessage("- Slot Mask: " + slotMask)
    PrintMessage("- Key ID: " + keyid)
    PrintMessage("- Index: " + index)
    PrintMessage("- Value: " + value)
    PrintMessage("- Persist: " + IfElse(persist, "Yes", "No"))
  Else
    PrintMessage("WARNING: Integer override may not have been applied successfully")
    PrintMessage("Expected Value: " + value)
    PrintMessage("Applied Value: " + appliedValue)
  EndIf
EndEvent

Event OnConsoleAddSkinOverrideBool(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: AddSkinOverrideBool([ObjectReference akActor = GetSelectedReference()], bool isFemale, bool firstPerson, int slotMask, int key, int index, bool value, bool persist)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool isFemale
  bool firstPerson
  int slotMask
  int keyid
  int index
  bool value
  bool persist

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  isFemale = self.BoolFromSArgument(sArgument, 1)
  firstPerson = self.BoolFromSArgument(sArgument, 2)
  slotMask = self.IntFromSArgument(sArgument, 3)
  keyid = self.IntFromSArgument(sArgument, 4)
  index = self.IntFromSArgument(sArgument, 5)
  value = self.BoolFromSArgument(sArgument, 6)
  persist = self.BoolFromSArgument(sArgument, 7, true)
  If QtyPars == 8
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    isFemale = self.BoolFromSArgument(sArgument, 2)
    firstPerson = self.BoolFromSArgument(sArgument, 3)
    slotMask = self.IntFromSArgument(sArgument, 4)
    keyid = self.IntFromSArgument(sArgument, 5)
    index = self.IntFromSArgument(sArgument, 6)
    value = self.BoolFromSArgument(sArgument, 7)
    persist = self.BoolFromSArgument(sArgument, 8, true)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Apply the boolean override
  NiOverride.AddSkinOverrideBool(akActor, isFemale, firstPerson, slotMask, keyid, index, value, persist)
  
  ; Verify if the override was applied successfully
  bool appliedValue = NiOverride.GetSkinOverrideBool(akActor, isFemale, firstPerson, slotMask, keyid, index)
  
  If appliedValue == value
    PrintMessage("Successfully applied boolean override to actor: " + self.GetFullID(akActor))
    PrintMessage("Details:")
    PrintMessage("- Actor: " + akActor.GetDisplayName())
    PrintMessage("- Gender: " + IfElse(isFemale, "Female", "Male"))
    PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
    PrintMessage("- Slot Mask: " + slotMask)
    PrintMessage("- Key ID: " + keyid)
    PrintMessage("- Index: " + index)
    PrintMessage("- Value: " + IfElse(value, "True", "False"))
    PrintMessage("- Persist: " + IfElse(persist, "Yes", "No"))
  Else
    PrintMessage("WARNING: Boolean override may not have been applied successfully")
    PrintMessage("Expected Value: " + IfElse(value, "True", "False"))
    PrintMessage("Applied Value: " + IfElse(appliedValue, "True", "False"))
  EndIf
EndEvent

Event OnConsoleAddSkinOverrideString(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: AddSkinOverrideString([ObjectReference akActor = GetSelectedReference()], bool isFemale, bool firstPerson, int slotMask, int key, int index, string value, bool persist)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool isFemale
  bool firstPerson
  int slotMask
  int keyid
  int index
  string value
  bool persist

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  isFemale = self.BoolFromSArgument(sArgument, 1)
  firstPerson = self.BoolFromSArgument(sArgument, 2)
  slotMask = self.IntFromSArgument(sArgument, 3)
  keyid = self.IntFromSArgument(sArgument, 4)
  index = self.IntFromSArgument(sArgument, 5)
  value = self.StringFromSArgument(sArgument, 6)
  persist = self.BoolFromSArgument(sArgument, 7, true)
  If QtyPars == 8
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    isFemale = self.BoolFromSArgument(sArgument, 2)
    firstPerson = self.BoolFromSArgument(sArgument, 3)
    slotMask = self.IntFromSArgument(sArgument, 4)
    keyid = self.IntFromSArgument(sArgument, 5)
    index = self.IntFromSArgument(sArgument, 6)
    value = self.StringFromSArgument(sArgument, 7)
    persist = self.BoolFromSArgument(sArgument, 8, true)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Apply the string override
  NiOverride.AddSkinOverrideString(akActor, isFemale, firstPerson, slotMask, keyid, index, value, persist)
  
  ; Verify if the override was applied successfully
  string appliedValue = NiOverride.GetSkinOverrideString(akActor, isFemale, firstPerson, slotMask, keyid, index)
  
  If appliedValue == value
    PrintMessage("Successfully applied string override to actor: " + self.GetFullID(akActor))
    PrintMessage("Details:")
    PrintMessage("- Actor: " + akActor.GetDisplayName())
    PrintMessage("- Gender: " + IfElse(isFemale, "Female", "Male"))
    PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
    PrintMessage("- Slot Mask: " + slotMask)
    PrintMessage("- Key ID: " + keyid)
    PrintMessage("- Index: " + index)
    PrintMessage("- Value: " + value)
    PrintMessage("- Persist: " + IfElse(persist, "Yes", "No"))
  Else
    PrintMessage("WARNING: String override may not have been applied successfully")
    PrintMessage("Expected Value: " + value)
    PrintMessage("Applied Value: " + appliedValue)
  EndIf
EndEvent

Event OnConsoleGetSkinOverrideInt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: GetSkinOverrideInt([ObjectReference akActor = GetSelectedReference()], bool isFemale, bool firstPerson, int slotMask, int key, int index)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool isFemale
  bool firstPerson
  int slotMask
  int keyid
  int index

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  isFemale = self.BoolFromSArgument(sArgument, 1)
  firstPerson = self.BoolFromSArgument(sArgument, 2)
  slotMask = self.IntFromSArgument(sArgument, 3)
  keyid = self.IntFromSArgument(sArgument, 4)
  index = self.IntFromSArgument(sArgument, 5)
  If QtyPars == 6
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    isFemale = self.BoolFromSArgument(sArgument, 2)
    firstPerson = self.BoolFromSArgument(sArgument, 3)
    slotMask = self.IntFromSArgument(sArgument, 4)
    keyid = self.IntFromSArgument(sArgument, 5)
    index = self.IntFromSArgument(sArgument, 6)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Retrieve the integer override
  int value = NiOverride.GetSkinOverrideInt(akActor, isFemale, firstPerson, slotMask, keyid, index)
  
  ; Print the result
  PrintMessage("Retrieved integer override for actor " + self.GetFullID(akActor) + ": " + value)
  PrintMessage("Details:")
  PrintMessage("- Actor: " + self.GetFullID(akActor))
  PrintMessage("- Gender: " + IfElse(isFemale, "Female", "Male"))
  PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
  PrintMessage("- Slot Mask: " + slotMask)
  PrintMessage("- Key ID: " + keyid)
  PrintMessage("- Index: " + index)
EndEvent

Event OnConsoleGetSkinOverrideBool(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: GetSkinOverrideBool([ObjectReference akActor = GetSelectedReference()], bool isFemale, bool firstPerson, int slotMask, int key, int index)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool isFemale
  bool firstPerson
  int slotMask
  int keyid
  int index

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  isFemale = self.BoolFromSArgument(sArgument, 1)
  firstPerson = self.BoolFromSArgument(sArgument, 2)
  slotMask = self.IntFromSArgument(sArgument, 3)
  keyid = self.IntFromSArgument(sArgument, 4)
  index = self.IntFromSArgument(sArgument, 5)
  If QtyPars == 6
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    isFemale = self.BoolFromSArgument(sArgument, 2)
    firstPerson = self.BoolFromSArgument(sArgument, 3)
    slotMask = self.IntFromSArgument(sArgument, 4)
    keyid = self.IntFromSArgument(sArgument, 5)
    index = self.IntFromSArgument(sArgument, 6)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Retrieve the boolean override
  bool value = NiOverride.GetSkinOverrideBool(akActor, isFemale, firstPerson, slotMask, keyid, index)
  
  ; Print the result
  PrintMessage("Retrieved boolean override for actor " + self.GetFullID(akActor) + ": " + IfElse(value, "True", "False"))
  PrintMessage("Details:")
  PrintMessage("- Actor: " + self.GetFullID(akActor))
  PrintMessage("- Gender: " + IfElse(isFemale, "Female", "Male"))
  PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
  PrintMessage("- Slot Mask: " + slotMask)
  PrintMessage("- Key ID: " + keyid)
  PrintMessage("- Index: " + index)
EndEvent

Event OnConsoleGetSkinOverrideString(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: GetSkinOverrideString([ObjectReference akActor = GetSelectedReference()], bool isFemale, bool firstPerson, int slotMask, int key, int index)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool isFemale
  bool firstPerson
  int slotMask
  int keyid
  int index

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  isFemale = self.BoolFromSArgument(sArgument, 1)
  firstPerson = self.BoolFromSArgument(sArgument, 2)
  slotMask = self.IntFromSArgument(sArgument, 3)
  keyid = self.IntFromSArgument(sArgument, 4)
  index = self.IntFromSArgument(sArgument, 5)
  If QtyPars == 6
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    isFemale = self.BoolFromSArgument(sArgument, 2)
    firstPerson = self.BoolFromSArgument(sArgument, 3)
    slotMask = self.IntFromSArgument(sArgument, 4)
    keyid = self.IntFromSArgument(sArgument, 5)
    index = self.IntFromSArgument(sArgument, 6)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Retrieve the string override
  string value = NiOverride.GetSkinOverrideString(akActor, isFemale, firstPerson, slotMask, keyid, index)
  
  ; Print the result
  PrintMessage("Retrieved string override for actor " + self.GetFullID(akActor) + ": " + value)
  PrintMessage("Details:")
  PrintMessage("- Actor: " + self.GetFullID(akActor))
  PrintMessage("- Gender: " + IfElse(isFemale, "Female", "Male"))
  PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
  PrintMessage("- Slot Mask: " + slotMask)
  PrintMessage("- Key ID: " + keyid)
  PrintMessage("- Index: " + index)
EndEvent

Event OnConsoleGetSkinPropertyInt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: GetSkinPropertyInt([ObjectReference akActor = GetSelectedReference()], bool firstPerson, int slotMask, int key, int index)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool firstPerson
  int slotMask
  int keyid
  int index

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  firstPerson = self.BoolFromSArgument(sArgument, 1)
  slotMask = self.IntFromSArgument(sArgument, 2)
  keyid = self.IntFromSArgument(sArgument, 3)
  index = self.IntFromSArgument(sArgument, 4)
  If QtyPars == 5
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    firstPerson = self.BoolFromSArgument(sArgument, 2)
    slotMask = self.IntFromSArgument(sArgument, 3)
    keyid = self.IntFromSArgument(sArgument, 4)
    index = self.IntFromSArgument(sArgument, 5)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Retrieve the property value
  int value = NiOverride.GetSkinPropertyInt(akActor, firstPerson, slotMask, keyid, index)
  
  ; Print the result
  PrintMessage("Retrieved skin property integer for actor " + self.GetFullID(akActor) + ": " + value)
  PrintMessage("Details:")
  PrintMessage("- Actor: " + self.GetFullID(akActor))
  PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
  PrintMessage("- Slot Mask: " + slotMask)
  PrintMessage("- Key ID: " + keyid)
  PrintMessage("- Index: " + index)
EndEvent

Event OnConsoleGetSkinPropertyBool(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: GetSkinPropertyBool([ObjectReference akActor = GetSelectedReference()], bool firstPerson, int slotMask, int key, int index)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool firstPerson
  int slotMask
  int keyid
  int index

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  firstPerson = self.BoolFromSArgument(sArgument, 1)
  slotMask = self.IntFromSArgument(sArgument, 2)
  keyid = self.IntFromSArgument(sArgument, 3)
  index = self.IntFromSArgument(sArgument, 4)
  If QtyPars == 5
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    firstPerson = self.BoolFromSArgument(sArgument, 2)
    slotMask = self.IntFromSArgument(sArgument, 3)
    keyid = self.IntFromSArgument(sArgument, 4)
    index = self.IntFromSArgument(sArgument, 5)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Retrieve the property value
  bool value = NiOverride.GetSkinPropertyBool(akActor, firstPerson, slotMask, keyid, index)
  
  ; Print the result
  PrintMessage("Retrieved skin property boolean for actor " + self.GetFullID(akActor) + ": " + IfElse(value, "True", "False"))
  PrintMessage("Details:")
  PrintMessage("- Actor: " + self.GetFullID(akActor))
  PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
  PrintMessage("- Slot Mask: " + slotMask)
  PrintMessage("- Key ID: " + keyid)
  PrintMessage("- Index: " + index)
EndEvent

Event OnConsoleGetSkinPropertyString(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  
  ; Print usage instructions if the user requests help
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Usage: GetSkinPropertyString([ObjectReference akActor = GetSelectedReference()], bool firstPerson, int slotMask, int key, int index)")
    PrintMessage("Note: Indexes are for controller index (0-255). Use -1 for properties not requiring a controller index")
    Return
  EndIf
  
  Actor akActor
  bool firstPerson
  int slotMask
  int keyid
  int index

  akActor = ConsoleUtil.GetSelectedReference() as Actor
  firstPerson = self.BoolFromSArgument(sArgument, 1)
  slotMask = self.IntFromSArgument(sArgument, 2)
  keyid = self.IntFromSArgument(sArgument, 3)
  index = self.IntFromSArgument(sArgument, 4)
  If QtyPars == 5
    akActor =  self.RefFromSArgument(sArgument, 1) as Actor
    firstPerson = self.BoolFromSArgument(sArgument, 2)
    slotMask = self.IntFromSArgument(sArgument, 3)
    keyid = self.IntFromSArgument(sArgument, 4)
    index = self.IntFromSArgument(sArgument, 5)
  EndIf

  ; Check for critical errors
  If akActor == none
    PrintMessage("ERROR: Unable to retrieve required Actor. Ensure the selected reference is valid")
    Return
  EndIf

  ; Retrieve the property value
  string value = NiOverride.GetSkinPropertyString(akActor, firstPerson, slotMask, keyid, index)
  
  ; Print the result
  PrintMessage("Retrieved skin property string for actor " + self.GetFullID(akActor) + ": " + value)
  PrintMessage("Details:")
  PrintMessage("- Actor: " + self.GetFullID(akActor))
  PrintMessage("- Perspective: " + IfElse(firstPerson, "First Person", "Third Person"))
  PrintMessage("- Slot Mask: " + slotMask)
  PrintMessage("- Key ID: " + keyid)
  PrintMessage("- Index: " + index)
EndEvent

Event OnConsoleGetABNumHeadParts(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABNumHeadParts([Actorbase akActorbase = GetSelectedReference().GetActorBase()])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int numHeadParts = akActorbase.GetNumHeadParts()
  PrintMessage("Number of head parts for " + self.GetFullID(akActorbase) + " is " + numHeadParts)
EndEvent

Event OnConsoleGetABNthHeadPart(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABNthHeadPart([Actorbase akActorbase = GetSelectedReference().GetActorBase()], int slotPart)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  int slotPart = self.IntFromSArgument(sArgument, 1)
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  HeadPart nthHeadPart = akActorbase.GetNthHeadPart(slotPart)
  PrintMessage("Head part " + slotPart + " for " + self.GetFullID(akActorbase) + " is " + self.GetFullID(nthHeadPart))
EndEvent

Event OnConsoleSetABNthHeadPart(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetABNthHeadPart([Actorbase akActorbase = GetSelectedReference().GetActorBase()], HeadPart akHeadPart, int slotPart)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  HeadPart akHeadPart = self.FormFromSArgument(sArgument, 1) as HeadPart
  int slotPart = self.IntFromSArgument(sArgument, 2)
  If akActorbase == none || akHeadPart == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActorbase.SetNthHeadPart(akHeadPart, slotPart)
  PrintMessage("Set head part " + slotPart + " for " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akHeadPart))
EndEvent

Event OnConsoleGetABIndexOfHeadPartByType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABIndexOfHeadPartByType([Actorbase akActorbase = GetSelectedReference().GetActorBase()], int type)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  int type = self.IntFromSArgument(sArgument, 1)
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int index = akActorbase.GetIndexOfHeadPartByType(type)
  PrintMessage("Index of head part type " + type + " for " + self.GetFullID(akActorbase) + " is " + index)
EndEvent

Event OnConsoleGetABNumOverlayHeadParts(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABNumOverlayHeadParts([Actorbase akActorbase = GetSelectedReference().GetActorBase()])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int numOverlayHeadParts = akActorbase.GetNumOverlayHeadParts()
  PrintMessage("Number of overlay head parts for " + self.GetFullID(akActorbase) + " is " + numOverlayHeadParts)
EndEvent

Event OnConsoleGetABNthOverlayHeadPart(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABNthOverlayHeadPart([Actorbase akActorbase = GetSelectedReference().GetActorBase()], int slotPart)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  int slotPart = self.IntFromSArgument(sArgument, 1)
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  HeadPart nthOverlayHeadPart = akActorbase.GetNthOverlayHeadPart(slotPart)
  PrintMessage("Overlay head part " + slotPart + " for " + self.GetFullID(akActorbase) + " is " + self.GetFullID(nthOverlayHeadPart))
EndEvent

Event OnConsoleGetABIndexOfOverlayHeadPartByType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABIndexOfOverlayHeadPartByType([Actorbase akActorbase = GetSelectedReference().GetActorBase()], int type)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  int type = self.IntFromSArgument(sArgument, 1)
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int index = akActorbase.GetIndexOfOverlayHeadPartByType(type)
  PrintMessage("Index of overlay head part type " + type + " for " + self.GetFullID(akActorbase) + " is " + index)
EndEvent

Event OnConsoleGetABFaceMorph(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABFaceMorph([Actorbase akActorbase = GetSelectedReference().GetActorBase()], int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  int index = self.IntFromSArgument(sArgument, 1)
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  float faceMorph = akActorbase.GetFaceMorph(index)
  PrintMessage("Face morph " + index + " for " + self.GetFullID(akActorbase) + " is " + faceMorph)
EndEvent

Event OnConsoleSetABFaceMorph(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetABFaceMorph([Actorbase akActorbase = GetSelectedReference().GetActorBase()], float value, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  float value = self.FloatFromSArgument(sArgument, 1)
  int index = self.IntFromSArgument(sArgument, 2)
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActorbase.SetFaceMorph(value, index)
  PrintMessage("Set face morph " + index + " for " + self.GetFullID(akActorbase) + " to " + value)
EndEvent

Event OnConsoleGetABFacePreset(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABFacePreset([Actorbase akActorbase = GetSelectedReference().GetActorBase()], int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  int index = self.IntFromSArgument(sArgument, 1)
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int facePreset = akActorbase.GetFacePreset(index)
  PrintMessage("Face preset " + index + " for " + self.GetFullID(akActorbase) + " is " + facePreset)
EndEvent

Event OnConsoleSetABFacePreset(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetABFacePreset([Actorbase akActorbase = GetSelectedReference().GetActorBase()], int value, int index)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  int value = self.IntFromSArgument(sArgument, 1)
  int index = self.IntFromSArgument(sArgument, 2)
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActorbase.SetFacePreset(value, index)
  PrintMessage("Set face preset " + index + " for " + self.GetFullID(akActorbase) + " to " + value)
EndEvent

Event OnConsoleGetABSkinFar(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABSkinFar([Actorbase akActorbase = GetSelectedReference().GetActorBase()])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Armor skinFar = akActorbase.GetSkinFar()
  PrintMessage("Far skin for " + self.GetFullID(akActorbase) + " is " + self.GetFullID(skinFar))
EndEvent

Event OnConsoleSetABSkinFar(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetABSkinFar([Actorbase akActorbase = GetSelectedReference().GetActorBase()], Armor skin)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  Armor skin = self.FormFromSArgument(sArgument, 1) as Armor
  If akActorbase == none || skin == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActorbase.SetSkinFar(skin)
  PrintMessage("Set far skin for " + self.GetFullID(akActorbase) + " to " + self.GetFullID(skin))
EndEvent

Event OnConsoleGetABTemplate(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABTemplate([Actorbase akActorbase = GetSelectedReference().GetActorBase()])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  ActorBase template = akActorbase.GetTemplate()
  PrintMessage("Template for " + self.GetFullID(akActorbase) + " is " + self.GetFullID(template))
EndEvent

Event OnConsoleSetAutoLock(String EventName, String sArgument, Float fArgument, Form Sender)
    Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
    PrintMessage("Format: SetAutoLock(ObjectReference akRef, abLockAuto = true)")
    If self.StringFromSArgument(sArgument, 1) == "?"
        Return
    EndIf

    ObjectReference akRef = ConsoleUtil.GetSelectedReference()
    bool abLockAuto

    ; Parse arguments
    ; If QtyPars == 0
    ;     akRef = ConsoleUtil.GetSelectedReference()  ; Use the currently selected reference
    ; ElseIf QtyPars == 1
    ;     akRef = ConsoleUtil.GetSelectedReference()  ; Use the currently selected reference
    ;     abLockAuto = self.BoolFromSArgument(sArgument, 1, true)
    ; ElseIf QtyPars == 2
    ;     akRef = self.RefFromSArgument(sArgument, 1)  ; Use the reference from the argument
    ;     abLockAuto = self.BoolFromSArgument(sArgument, 2, true)
    ; EndIf

    ; Validate the reference
    If akRef == None
        PrintMessage("FATAL ERROR: No valid reference selected or provided")
        Return
    EndIf

    ; Ensure the reference is a door
    ; If akRef.GetBaseObject().GetType() != 34  ; Type 34 is a door
    ;     PrintMessage("FATAL ERROR: The selected reference is not a door")
    ;     Return
    ; EndIf

    ; Attach the script
    DbMiscFunctions.AttachPapyrusScript("VCS_LockDoorOnCellChange", akRef)
    PrintMessage("Attached LockDoorOnCellChange script to " + self.GetFullID(akRef))
EndEvent

Event OnConsoleRemoveAllNodeRefOverrides(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAllNodeRefOverrides(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.RemoveAllReferenceNodeOverrides(akActor)
  PrintMessage("Removed all node overrides from " + self.GetFullID(akActor))
EndEvent

Event OnConsoleRemoveAllSkinRefOverrides(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAllSkinRefOverrides(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.RemoveAllReferenceSkinOverrides(akActor)
  PrintMessage("Removed all skin overrides from " + self.GetFullID(akActor))
EndEvent

Event OnConsoleRemoveAllWeaponRefOverrides(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAllWeaponRefOverrides(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NiOverride.RemoveAllReferenceWeaponOverrides(akActor)
  PrintMessage("Removed all weapon overrides from " + self.GetFullID(akActor))
EndEvent

Event OnConsoleGetTextureSetNumPaths(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetTextureSetNumPaths(TextureSet akTextureSet)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  TextureSet akTextureSet = self.FormFromSArgument(sArgument, 1) as TextureSet
  If akTextureSet == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int numPaths = akTextureSet.GetNumTexturePaths()
  PrintMessage("Number of paths in TextureSet " + self.GetFullID(akTextureSet) + " is " + numPaths)
EndEvent

Event OnConsoleGetMagicEffectLight(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectLight(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  Light result = akMagicEffect.GetLight()
  
  PrintMessage("Light of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(result))
    
EndEvent

Event OnConsoleSetMagicEffectLight(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectLight(MagicEffect akMagicEffect, Light akLight)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  Light akLight = self.FormFromSArgument(sArgument, 2) as Light

  If akMagicEffect == none || akLight == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  

  PrintMessage("Light of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(akMagicEffect.GetLight()))
  PrintMessage("Attempting to set light of " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akLight))
  
  akMagicEffect.SetLight(akLight)
  
  PrintMessage("Light of " + self.GetFullID(akMagicEffect) + " is now " + self.GetFullID(akMagicEffect.GetLight()))
    
EndEvent

Event OnConsoleAddKeyword(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddKeyword <Form akForm | ObjectReference akRef = GetSelectedReference()> <Keyword akKeyword>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm
  Keyword akKeyword
  If QtyPars == 1
    akForm = ConsoleUtil.GetSelectedReference()
    akKeyword = self.FormFromSArgument(sArgument, 1) as Keyword
    
    If akKeyword == none
      akKeyword = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 1))
    EndIf
  ElseIf QtyPars == 2
    akForm = self.FormFromSArgument(sArgument, 1)
    akKeyword = self.FormFromSArgument(sArgument, 2) as Keyword
    
    If akKeyword == none
      akKeyword = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 2))
    EndIf
  EndIf
  If akForm == none || akKeyword == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  If akForm as ObjectReference
    PO3_SKSEFunctions.AddKeywordToRef(akForm as ObjectReference, akKeyword)
    PrintMessage("Keyword " + self.GetFullID(akKeyword) + " added to reference " + self.GetFullID(akForm))
  Else
    PO3_SKSEFunctions.AddKeywordToForm(akForm, akKeyword)
    PrintMessage("Keyword " + self.GetFullID(akKeyword) + " added to form " + self.GetFullID(akForm))
  EndIf
EndEvent

Event OnConsoleRemoveKeyword(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveKeyword <Form akForm | ObjectReference akRef = GetSelectedReference()> <Keyword akKeyword>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm
  Keyword akKeyword
  If QtyPars == 1
    akForm = ConsoleUtil.GetSelectedReference()
    akKeyword = self.FormFromSArgument(sArgument, 1) as Keyword
    
    If akKeyword == none
      akKeyword = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 1))
    EndIf
  ElseIf QtyPars == 2
    akForm = self.FormFromSArgument(sArgument, 1)
    akKeyword = self.FormFromSArgument(sArgument, 2) as Keyword
    
    If akKeyword == none
      akKeyword = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 2))
    EndIf
  EndIf
  If akForm == none || akKeyword == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  If akForm as ObjectReference
    PO3_SKSEFunctions.RemoveKeywordFromRef(akForm as ObjectReference, akKeyword)
    PrintMessage("Keyword " + self.GetFullID(akKeyword) + " removed from reference " + self.GetFullID(akForm))
  Else
    PO3_SKSEFunctions.RemoveKeywordOnForm(akForm, akKeyword)
    PrintMessage("Keyword " + self.GetFullID(akKeyword) + " removed from form " + self.GetFullID(akForm))
  EndIf
EndEvent

Event OnConsoleReplaceKeyword(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ReplaceKeyword <Form akForm | ObjectReference akRef = GetSelectedReference()> <Keyword akKeywordAdd> <Keyword akKeywordRemove>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Form akForm
  Keyword akKeywordAdd
  Keyword akKeywordRemove

  If QtyPars == 2
    akForm = ConsoleUtil.GetSelectedReference()
    akKeywordAdd = self.FormFromSArgument(sArgument, 1) as Keyword
    akKeywordRemove = self.FormFromSArgument(sArgument, 2) as Keyword
    
    If akKeywordAdd == none
      akKeywordAdd = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 1))
    EndIf
      
    If akKeywordRemove == none
      akKeywordRemove = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 2))
    EndIf
  ElseIf QtyPars == 3
    akForm = self.FormFromSArgument(sArgument, 1)
    akKeywordAdd = self.FormFromSArgument(sArgument, 2) as Keyword
    akKeywordRemove = self.FormFromSArgument(sArgument, 3) as Keyword
    
    If akKeywordAdd == none
      akKeywordAdd = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 2))
    EndIf
      
    If akKeywordRemove == none
      akKeywordRemove = Keyword.GetKeyword(self.StringFromSArgument(sArgument, 3))
    EndIf
  EndIf

  If akForm == none || akKeywordAdd == none || akKeywordRemove == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf

  
  If akForm as ObjectReference
    PO3_SKSEFunctions.ReplaceKeywordOnRef(akForm as ObjectReference, akKeywordAdd, akKeywordRemove)
    PrintMessage("Keyword " + self.GetFullID(akKeywordRemove) + " replaced for " + self.GetFullID(akKeywordAdd) + " in reference " + self.GetFullID(akForm))
  Else
    PO3_SKSEFunctions.ReplaceKeywordOnForm(akForm, akKeywordAdd, akKeywordRemove)
    PrintMessage("Keyword " + self.GetFullID(akKeywordRemove) + " replaced for " + self.GetFullID(akKeywordAdd) + " in form " + self.GetFullID(akForm))
  EndIf

  PrintMessage("Keyword " + self.GetFullID(akKeywordRemove) + " replaced with " + self.GetFullID(akKeywordAdd) + " on form " + self.GetFullID(akForm))
EndEvent

Event OnConsoleGetTreeIngredient(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetTreeIngredient(TreeObject akTreeObject)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  TreeObject akTreeObject = self.FormFromSArgument(sArgument, 1) as TreeObject

  If akTreeObject == none
    PrintMessage("FATAL ERROR: Form retrieval error")
    Return
  EndIf

  Form currentIngredient = akTreeObject.GetIngredient()
  PrintMessage("Current ingredient is " + self.GetFullID(currentIngredient))
EndEvent

Event OnConsoleSetTreeIngredient(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetTreeIngredient(TreeObject akTreeObject, Ingredient akIngredient)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  TreeObject akTreeObject = self.FormFromSArgument(sArgument, 1) as TreeObject
  Ingredient akIngredient = self.FormFromSArgument(sArgument, 2) as Ingredient
  

  If akTreeObject == none || akIngredient == none
    PrintMessage("FATAL ERROR: Form retrieval error")
    Return
  EndIf

  Form oldIngredient = akTreeObject.GetIngredient()
  PrintMessage("Tree ingredient is " + self.GetFullID(oldIngredient))
  
  PrintMessage("Attempting to change it to " + self.GetFullID(akIngredient))

  akTreeObject.SetIngredient(akIngredient)
  
  Form newIngredient = akTreeObject.GetIngredient()

  If (newIngredient as Ingredient) == akIngredient
    PrintMessage("Success!")
  EndIf
  
  PrintMessage("Tree ingredient is now " + self.GetFullID(newIngredient))

EndEvent

Event OnConsoleIsKeyPressed(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: IsKeyPressed <Int dxKeycode>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  int dxKeycode = self.IntFromSArgument(sArgument, 1)

  bool result = Input.IsKeyPressed(dxKeycode)
  PrintMessage("IsKeyPressed: " + result)
EndEvent

Event OnConsoleGetNumKeysPressed(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNumKeysPressed")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  int result = Input.GetNumKeysPressed()
  PrintMessage("GetNumKeysPressed: " + result)
EndEvent

Event OnConsoleGetNthKeyPressed(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetNthKeyPressed <Int n>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  int aiIndex = self.IntFromSArgument(sArgument, 1)

  int result = Input.GetNthKeyPressed(aiIndex)
  PrintMessage("GetNthKeyPressed: " + result)
EndEvent

Event OnConsoleGetMappedKey(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMappedKey <String control> <Int deviceType = 0xFF>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  string control = self.StringFromSArgument(sArgument, 1)
  int deviceType = 0xFF
  if QtyPars > 1
    deviceType = self.IntFromSArgument(sArgument, 2)
  EndIf

  int result = Input.GetMappedKey(control, deviceType)
  PrintMessage("GetMappedKey: " + result)
EndEvent

Event OnConsoleGetMappedControl(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMappedControl <Int keycode>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  int keycode = self.IntFromSArgument(sArgument, 1)

  string result = Input.GetMappedControl(keycode)
  PrintMessage("GetMappedControl: " + result)
EndEvent

Event OnConsolePrecacheCharGenClear(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PrecacheCharGenClear()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Game.PrecacheCharGenClear()
  PrintMessage("CharGen precache cleared")
EndEvent

Event OnConsoleUpdateThirdPerson(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: UpdateThirdPerson()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Game.UpdateThirdPerson()
  PrintMessage("Updated third person")
EndEvent

Event OnConsoleSetFormlistAsPapyrusQuestVar(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetFormlistAsPapyrusQuestVar(Quest akQuest, string asVarname, Formlist akFLST)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Quest akQuest = FormFromSArgument(sArgument, 1) as Quest
  string asVarname = StringFromSArgument(sArgument, 2)
  Formlist akFLST = FormFromSArgument(sArgument, 3) as Formlist
  Form[] newArray = FormlistToArray(akFLST)
  PrintMessage("SetFormlistAsPapyrusQuestVar")
  PrintMessage("-  Quest: " + self.GetFullID(akQuest))
  PrintMessage("-  Varname: " + asVarname)
  PrintMessage("-  Formlist: " + self.GetFullID(akFLST))
EndEvent

Event OnConsoleModObjectiveGlobal(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ModObjectiveGlobal <Quest akQuest> <float afModValue> <GlobalVariable aModGlobal> [int aiObjectiveID = -1] [float afTargetValue = -1.0] [bool abCountingUp = true] [bool abCompleteObjective = true] [bool abRedisplayObjective = true]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("Optional parameters:")
    PrintMessage("aiObjectiveID = objective ID to redisplay")
    PrintMessage("afTargetValue = value you're counting up (or down) towards -- if included, function will return TRUE when the global reaches the target value")
    PrintMessage("abCountingUp = by default, function assumes you're counting up towards the target value; make this false to count DOWN towards target value")
    PrintMessage("abCompleteObjective = by default, function assumes you're completing the objective once you reach the target value; make this false to FAIL the objective")
    PrintMessage("abRedisplayObjective = by default, function assumes you want to redisplay the objective every time the global is incremented; make this FALSE to only display the objectives on complete or failure")
    Return
  EndIf

  Quest akQuest = self.FormFromSArgument(sArgument, 1) as Quest
  float afModValue = self.FloatFromSArgument(sArgument, 2)
  GlobalVariable aModGlobal = self.FormFromSArgument(sArgument, 3) as GlobalVariable
  int aiObjectiveID = self.IntFromSArgument(sArgument, 4, -1)
  float afTargetValue = self.FloatFromSArgument(sArgument, 5, -1.0)
  bool abCountingUp = self.BoolFromSArgument(sArgument, 6, true)
  bool abCompleteObjective = self.BoolFromSArgument(sArgument, 7, true)
  bool abRedisplayObjective = self.BoolFromSArgument(sArgument, 8, true)

  If akQuest == none || aModGlobal == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf

  bool result = akQuest.ModObjectiveGlobal(afModValue, aModGlobal, aiObjectiveID, afTargetValue, abCountingUp, abCompleteObjective, abRedisplayObjective)
  PrintMessage("ModObjectiveGlobal: " + result)
EndEvent

Event OnConsoleGetQuestAliases(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetQuestAliases [<Quest akQuest>]")

  Quest akQuest = self.FormFromSArgument(sArgument, 1) as Quest

  If akQuest == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  Alias[] aliases = akQuest.GetAliases()
  int i = 0
  int L = aliases.Length
  If L > 0
    PrintMessage("Found " + L + " aliases for quest " + self.GetFullID(akQuest))
  Else
    PrintMessage("No aliases found")
    Return
  EndIf
  While i < L
    PrintMessage("Alias #" + aliases[i].GetID() + ": " + aliases[i].GetName())
    i += 1
  EndWhile
EndEvent

Event OnConsoleGetMagicEffectAssociatedSkill(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectAssociatedSkill(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  string result = akMagicEffect.GetAssociatedSkill()
  
  PrintMessage("Associated skill of " + self.GetFullID(akMagicEffect) + " is " + result)
    
EndEvent

Event OnConsoleSetMagicEffectAssociatedSkill(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectAssociatedSkill(MagicEffect akMagicEffect, string asAssociatedSkill)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  string asAssociatedSkill = self.StringFromSArgument(sArgument, 2)

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  

  PrintMessage("Associated skill of " + self.GetFullID(akMagicEffect) + " is " + akMagicEffect.GetAssociatedSkill())
  PrintMessage("Attempting to set associated skill of " + self.GetFullID(akMagicEffect) + " to " + asAssociatedSkill)
  
  akMagicEffect.SetAssociatedSkill(asAssociatedSkill)
  
  PrintMessage("Associated skill of " + self.GetFullID(akMagicEffect) + " is now " + akMagicEffect.GetAssociatedSkill())
    
EndEvent

Event OnConsoleGetMagicEffectResistance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectResistance(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  string result = akMagicEffect.GetResistance()
  
  PrintMessage("Resistance of " + self.GetFullID(akMagicEffect) + " is " + result)
    
EndEvent

Event OnConsoleSetMagicEffectResistance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectResistance(MagicEffect akMagicEffect, string asResistanceSkill)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  string asResistance = self.StringFromSArgument(sArgument, 2)

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  

  PrintMessage("Resistance of " + self.GetFullID(akMagicEffect) + " is " + akMagicEffect.GetResistance())
  PrintMessage("Attempting to set resistance of " + self.GetFullID(akMagicEffect) + " to " + asResistance)
  
  akMagicEffect.SetResistance(asResistance)
  
  PrintMessage("Resistance of " + self.GetFullID(akMagicEffect) + " is now " + akMagicEffect.GetResistance())
    
EndEvent

Event OnConsoleGetMagicEffectImpactDataSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectImpactDataSet(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  ImpactDataSet result = akMagicEffect.GetImpactDataSet()
  
  PrintMessage("ImpactDataSet of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(result))
    
EndEvent

Event OnConsoleSetMagicEffectImpactDataSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectImpactDataSet(MagicEffect akMagicEffect, ImpactDataSet akImpactDataSet)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  ImpactDataSet akImpactDataSet = self.FormFromSArgument(sArgument, 2) as ImpactDataSet

  If akMagicEffect == none || akImpactDataSet == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  

  PrintMessage("Impact set of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(akMagicEffect.GetImpactDataSet()))
  PrintMessage("Attempting to set ImpactDataSet of " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akImpactDataSet))
  
  akMagicEffect.SetImpactDataSet(akImpactDataSet)
  
  PrintMessage("Impact set of " + self.GetFullID(akMagicEffect) + " is now " + self.GetFullID(akMagicEffect.GetImpactDataSet()))
    
EndEvent

Event OnConsoleGetMagicEffectImageSpaceMod(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectImageSpaceMod(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  ImageSpaceModifier result = akMagicEffect.GetImageSpaceMod()
  
  PrintMessage("Imagespace modifier of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(result))
    
EndEvent

Event OnConsoleSetMagicEffectImageSpaceMod(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectImageSpaceMod(MagicEffect akMagicEffect, ImageSpaceModifier akImageSpaceMod)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  ImageSpaceModifier akImageSpaceMod = self.FormFromSArgument(sArgument, 2) as ImageSpaceModifier

  If akMagicEffect == none || akImageSpaceMod == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  

  PrintMessage("Imagespace modifier of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(akMagicEffect.GetImageSpaceMod()))
  PrintMessage("Attempting to set imagespace modifier of " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akImageSpaceMod))
  
  akMagicEffect.SetImageSpaceMod(akImageSpaceMod)
  
  PrintMessage("Imagespace modifier of " + self.GetFullID(akMagicEffect) + " is now " + self.GetFullID(akMagicEffect.GetImageSpaceMod()))
    
EndEvent

Event OnConsoleGetMagicEffectPerk(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectPerk(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  Perk result = akMagicEffect.GetPerk()
  
  PrintMessage("Imagespace modifier of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(result))
    
EndEvent

Event OnConsoleSetMagicEffectPerk(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectPerk(MagicEffect akMagicEffect, Perk akPerk)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  Perk akPerk = self.FormFromSArgument(sArgument, 2) as Perk

  If akMagicEffect == none || akPerk == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  

  PrintMessage("Imagespace modifier of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(akMagicEffect.GetPerk()))
  PrintMessage("Attempting to set imagespace modifier of " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akPerk))
  
  akMagicEffect.SetPerk(akPerk)
  
  PrintMessage("Imagespace modifier of " + self.GetFullID(akMagicEffect) + " is now " + self.GetFullID(akMagicEffect.GetPerk()))
    
EndEvent

Event OnConsoleGetMagicEffectEquipAbility(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectEquipAbility(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  Spell result = akMagicEffect.GetEquipAbility()
  
  PrintMessage("Imagespace modifier of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(result))
    
EndEvent

Event OnConsoleSetMagicEffectEquipAbility(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectEquipAbility(MagicEffect akMagicEffect, Spell akEquipAbility)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  Spell akEquipAbility = self.FormFromSArgument(sArgument, 2) as Spell

  If akMagicEffect == none || akEquipAbility == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  

  PrintMessage("Imagespace modifier of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(akMagicEffect.GetEquipAbility()))
  PrintMessage("Attempting to set imagespace modifier of " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akEquipAbility))
  
  akMagicEffect.SetEquipAbility(akEquipAbility)
  
  PrintMessage("Imagespace modifier of " + self.GetFullID(akMagicEffect) + " is now " + self.GetFullID(akMagicEffect.GetEquipAbility()))
    
EndEvent

Event OnConsoleSetEffectFlag(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetEffectFlag(MagicEffect akMagicEffect, int aiFlag)")
  
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("MAGIC EFFECT FLAGS")
    PrintMessage("FLAG           |    HEX     |       INT")
    PrintMessage("========================================")
    PrintMessage("Hostile        | 0x00000001 |         1")
    PrintMessage("Recover        | 0x00000002 |         2")
    PrintMessage("Detrimental    | 0x00000004 |         4")
    PrintMessage("NoHitEvent     | 0x00000010 |        16")
    PrintMessage("DispelKeywords | 0x00000100 |       256")
    PrintMessage("NoDuration     | 0x00000200 |       512")
    PrintMessage("NoMagnitude    | 0x00000400 |      1024")
    PrintMessage("NoArea         | 0x00000800 |      2048")
    PrintMessage("FXPersist      | 0x00001000 |      4096")
    PrintMessage("GloryVisuals   | 0x00004000 |     16384")
    PrintMessage("HideInUI       | 0x00008000 |     32768")
    PrintMessage("NoRecast       | 0x00020000 |    131072")
    PrintMessage("Magnitude      | 0x00200000 |   2097152")
    PrintMessage("Duration       | 0x00400000 |   4194304")
    PrintMessage("Painless       | 0x04000000 |  67108864")
    PrintMessage("NoHitEffect    | 0x08000000 | 134217728")
    PrintMessage("NoDeathDispel  | 0x10000000 | 268435456")
    PrintMessage("========================================")
    Return
  EndIf

  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  Int aiFlag = self.IntFromSArgument(sArgument, 2)

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If aiFlag < 1 || aiFlag > 27
    PrintMessage("FATAL ERROR: Invalid flag number provided. Run " + DoubleQuotes("SetRecordFlag ?") + " to check valid values")
    Return
  EndIf

  ; Set the record flag
  akMagicEffect.SetEffectFlag(aiFlag)
EndEvent

Event OnConsoleClearEffectFlag(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearEffectFlag(MagicEffect akMagicEffect, int aiFlag)")
  
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("MAGIC EFFECT FLAGS")
    PrintMessage("FLAG           |    HEX     |       INT")
    PrintMessage("========================================")
    PrintMessage("Hostile        | 0x00000001 |         1")
    PrintMessage("Recover        | 0x00000002 |         2")
    PrintMessage("Detrimental    | 0x00000004 |         4")
    PrintMessage("NoHitEvent     | 0x00000010 |        16")
    PrintMessage("DispelKeywords | 0x00000100 |       256")
    PrintMessage("NoDuration     | 0x00000200 |       512")
    PrintMessage("NoMagnitude    | 0x00000400 |      1024")
    PrintMessage("NoArea         | 0x00000800 |      2048")
    PrintMessage("FXPersist      | 0x00001000 |      4096")
    PrintMessage("GloryVisuals   | 0x00004000 |     16384")
    PrintMessage("HideInUI       | 0x00008000 |     32768")
    PrintMessage("NoRecast       | 0x00020000 |    131072")
    PrintMessage("Magnitude      | 0x00200000 |   2097152")
    PrintMessage("Duration       | 0x00400000 |   4194304")
    PrintMessage("Painless       | 0x04000000 |  67108864")
    PrintMessage("NoHitEffect    | 0x08000000 | 134217728")
    PrintMessage("NoDeathDispel  | 0x10000000 | 268435456")
    PrintMessage("========================================")
    Return
  EndIf

  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  Int aiFlag = self.IntFromSArgument(sArgument, 2)

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If aiFlag < 1 || aiFlag > 27
    PrintMessage("FATAL ERROR: Invalid flag number provided. Run " + DoubleQuotes("ClearRecordFlag ?") + " to check valid values")
    Return
  EndIf

  ; Clear the record flag
  akMagicEffect.ClearEffectFlag(aiFlag)
EndEvent

Event OnConsoleIsEffectFlagSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: IsEffectFlagSet(MagicEffect akMagicEffect, int aiFlag)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  Int aiFlag = self.IntFromSArgument(sArgument, 2)
  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 

  If aiFlag < 1 || aiFlag > 27
    PrintMessage("FATAL ERROR: Invalid flag number provided. Run " + DoubleQuotes("ClearRecordFlag ?") + " to check valid values")
    Return
  EndIf

  bool flagSet = akMagicEffect.IsEffectFlagSet(aiFlag)
  PrintMessage("IsEffectFlagSet: " + flagSet)
EndEvent

Event OnConsoleGetMagicEffectExplosion(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectExplosion(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  Explosion result = akMagicEffect.GetExplosion()
  
  PrintMessage("Explosion of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(result))
    
EndEvent

Event OnConsoleSetMagicEffectExplosion(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectExplosion(MagicEffect akMagicEffect, Explosion akExplosion)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  Explosion akExplosion = self.FormFromSArgument(sArgument, 2) as Explosion

  If akMagicEffect == none || akExplosion == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  

  PrintMessage("Explosion of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(akMagicEffect.GetExplosion()))
  PrintMessage("Attempting to set explosion of " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akExplosion))
  
  akMagicEffect.SetExplosion(akExplosion)
  
  PrintMessage("Explosion of " + self.GetFullID(akMagicEffect) + " is now " + self.GetFullID(akMagicEffect.GetExplosion()))
    
EndEvent

Event OnConsoleGetMagicEffectProjectile(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectProjectile(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  Projectile result = akMagicEffect.GetProjectile()
  
  PrintMessage("Projectile of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(result))
    
EndEvent

Event OnConsoleSetMagicEffectProjectile(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectProjectile(MagicEffect akMagicEffect, Projectile akProjectile)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  Projectile akProjectile = self.FormFromSArgument(sArgument, 2) as Projectile

  If akMagicEffect == none || akProjectile == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  

  PrintMessage("Projectile of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(akMagicEffect.GetProjectile()))
  PrintMessage("Attempting to set projectile of " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akProjectile))
  
  akMagicEffect.SetProjectile(akProjectile)
  
  PrintMessage("Projectile of " + self.GetFullID(akMagicEffect) + " is now " + self.GetFullID(akMagicEffect.GetProjectile()))
    
EndEvent

Event OnConsoleGetMagicEffectSkillLevel(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectSkillLevel(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  float result = akMagicEffect.GetSkillLevel()
  
  PrintMessage("Skill level of " + self.GetFullID(akMagicEffect) + " is " + result)
    
EndEvent

Event OnConsoleSetMagicEffectSkillLevel(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectSkillLevel(MagicEffect akMagicEffect, int aiLevel)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  int aiLevel = self.IntFromSArgument(sArgument, 2)

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  

  PrintMessage("Skill level of " + self.GetFullID(akMagicEffect) + " is " + akMagicEffect.GetSkillLevel())
  PrintMessage("Attempting to set Skill level of " + self.GetFullID(akMagicEffect) + " to " + aiLevel)
  
  akMagicEffect.SetSkillLevel(aiLevel)
  
  PrintMessage("Skill level of " + self.GetFullID(akMagicEffect) + " is now " + akMagicEffect.GetSkillLevel())
    
EndEvent

Event OnConsoleGetMagicEffectBaseCost(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectBaseCost(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  float result = akMagicEffect.GetBaseCost()
  
  PrintMessage("Base cost of " + self.GetFullID(akMagicEffect) + " is " + result)
    
EndEvent

Event OnConsoleSetMagicEffectBaseCost(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectBaseCost(MagicEffect akMagicEffect, float afMult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  float afMult = self.FloatFromSArgument(sArgument, 2)

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  

  PrintMessage("Base cost of " + self.GetFullID(akMagicEffect) + " is " + akMagicEffect.GetBaseCost())
  PrintMessage("Attempting to set Base cost of " + self.GetFullID(akMagicEffect) + " to " + afMult)
  
  akMagicEffect.SetBaseCost(afMult)
  
  PrintMessage("Base cost of " + self.GetFullID(akMagicEffect) + " is now " + akMagicEffect.GetBaseCost())
    
EndEvent

Event OnConsoleGetMagicEffectCastTime(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectCastTime(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  float result = akMagicEffect.GetCastTime()
  
  PrintMessage("Cast time of " + self.GetFullID(akMagicEffect) + " is " + result)
    
EndEvent

Event OnConsoleSetMagicEffectCastTime(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectCastTime(MagicEffect akMagicEffect, float afCastTime)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  float afCastTime = self.FloatFromSArgument(sArgument, 2)

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  

  PrintMessage("Cast time of " + self.GetFullID(akMagicEffect) + " is " + akMagicEffect.GetCastTime())
  PrintMessage("Attempting to set Cast time of " + self.GetFullID(akMagicEffect) + " to " + afCastTime)
  
  akMagicEffect.SetCastTime(afCastTime)
  
  PrintMessage("Cast time of " + self.GetFullID(akMagicEffect) + " is now " + akMagicEffect.GetCastTime())
    
EndEvent

Event OnConsoleGetMagicEffectArea(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectArea(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("Area of " + self.GetFullID(akMagicEffect) + " is " + akMagicEffect.GetArea())
    
EndEvent

Event OnConsoleSetMagicEffectArea(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectArea(MagicEffect akMagicEffect, int aiArea)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  int aiArea = self.IntFromSArgument(sArgument, 2)

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  

  PrintMessage("Area of " + self.GetFullID(akMagicEffect) + " is " + akMagicEffect.GetArea())
  PrintMessage("Attempting to set Area of " + self.GetFullID(akMagicEffect) + " to " + aiArea)
  
  akMagicEffect.SetArea(aiArea)
  
  PrintMessage("Area of " + self.GetFullID(akMagicEffect) + " is now " + akMagicEffect.GetArea())
    
EndEvent

Event OnConsoleGetIngredientNthEffectArea(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetIngredientNthEffectArea(Ingredient akIngredient, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Ingredient akIngredient = self.FormFromSArgument(sArgument, 1) as Ingredient
  int aiIndex = self.IntFromSArgument(sArgument, 2)

  If akIngredient == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("NthEffectArea of " + self.GetFullID(akIngredient) + " is " + akIngredient.GetNthEffectArea(aiIndex))
    
EndEvent

Event OnConsoleSetIngredientNthEffectArea(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetIngredientNthEffectArea(Ingredient akIngredient, int aiIndex, int aiNthEffectArea)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Ingredient akIngredient = self.FormFromSArgument(sArgument, 1) as Ingredient
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  int aiNthEffectArea = self.IntFromSArgument(sArgument, 3)

  If akIngredient == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  

  PrintMessage("NthEffectArea of " + self.GetFullID(akIngredient) + " is " + akIngredient.GetNthEffectArea(aiIndex))
  PrintMessage("Attempting to set NthEffectArea of " + self.GetFullID(akIngredient) + " to " + aiNthEffectArea)
  
  akIngredient.SetNthEffectArea(aiIndex, aiNthEffectArea)
  
  PrintMessage("NthEffectArea of " + self.GetFullID(akIngredient) + " is now " + akIngredient.GetNthEffectArea(aiIndex))
    
EndEvent

Event OnConsoleGetIngredientNthEffectMagnitude(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetIngredientNthEffectMagnitude(Ingredient akIngredient, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Ingredient akIngredient = self.FormFromSArgument(sArgument, 1) as Ingredient
  int aiIndex = self.IntFromSArgument(sArgument, 2)

  If akIngredient == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("NthEffectMagnitude of " + self.GetFullID(akIngredient) + " is " + akIngredient.GetNthEffectMagnitude(aiIndex))
    
EndEvent

Event OnConsoleSetIngredientNthEffectMagnitude(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetIngredientNthEffectMagnitude(Ingredient akIngredient, int aiIndex, float afMagnitude)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Ingredient akIngredient = self.FormFromSArgument(sArgument, 1) as Ingredient
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  float afMagnitude = self.IntFromSArgument(sArgument, 3)

  If akIngredient == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  

  PrintMessage("NthEffectMagnitude of " + self.GetFullID(akIngredient) + " is " + akIngredient.GetNthEffectMagnitude(aiIndex))
  PrintMessage("Attempting to set NthEffectMagnitude of " + self.GetFullID(akIngredient) + " to " + afMagnitude)
  
  akIngredient.SetNthEffectMagnitude(aiIndex, afMagnitude)
  
  PrintMessage("NthEffectMagnitude of " + self.GetFullID(akIngredient) + " is now " + akIngredient.GetNthEffectMagnitude(aiIndex))
    
EndEvent

Event OnConsoleGetIngredientNthEffectDuration(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetIngredientNthEffectDuration(Ingredient akIngredient, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Ingredient akIngredient = self.FormFromSArgument(sArgument, 1) as Ingredient
  int aiIndex = self.IntFromSArgument(sArgument, 2)

  If akIngredient == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("NthEffectDuration of " + self.GetFullID(akIngredient) + " is " + akIngredient.GetNthEffectDuration(aiIndex))
    
EndEvent

Event OnConsoleSetIngredientNthEffectDuration(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetIngredientNthEffectDuration(Ingredient akIngredient, int aiIndex, int aiDuration)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Ingredient akIngredient = self.FormFromSArgument(sArgument, 1) as Ingredient
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  int aiDuration = self.IntFromSArgument(sArgument, 3)

  If akIngredient == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  

  PrintMessage("NthEffectDuration of " + self.GetFullID(akIngredient) + " is " + akIngredient.GetNthEffectDuration(aiIndex))
  PrintMessage("Attempting to set NthEffectDuration of " + self.GetFullID(akIngredient) + " to " + aiDuration)
  
  akIngredient.SetNthEffectDuration(aiIndex, aiDuration)
  
  PrintMessage("NthEffectDuration of " + self.GetFullID(akIngredient) + " is now " + akIngredient.GetNthEffectDuration(aiIndex))
    
EndEvent

Event OnConsoleSetRaceFlag(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetRaceFlag(Race akRace, int aiFlag)")
  
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("RACE FLAGS")
    PrintMessage("================================================")
    PrintMessage("kRace_Playable											= 0x00000001")
    PrintMessage("kRace_FaceGenHead										= 0x00000002")
    PrintMessage("kRace_Child													= 0x00000004")
    PrintMessage("kRace_TiltFrontBack									= 0x00000008")
    PrintMessage("kRace_TiltLeftRight									= 0x00000010")
    PrintMessage("kRace_NoShadow											= 0x00000020")
    PrintMessage("kRace_Swims													= 0x00000040")
    PrintMessage("kRace_Flies													= 0x00000080")
    PrintMessage("kRace_Walks													= 0x00000100")
    PrintMessage("kRace_Immobile											= 0x00000200")
    PrintMessage("kRace_NotPushable										= 0x00000400")
    PrintMessage("kRace_NoCombatInWater								= 0x00000800")
    PrintMessage("kRace_NoRotatingToHeadTrack					= 0x00001000")
    PrintMessage("kRace_UseHeadTrackAnim							= 0x00008000")
    PrintMessage("kRace_SpellsAlignWithMagicNode			= 0x00010000")
    PrintMessage("kRace_UseWorldRaycasts							= 0x00020000")
    PrintMessage("kRace_AllowRagdollCollision					= 0x00040000")
    PrintMessage("kRace_CantOpenDoors									= 0x00100000")
    PrintMessage("kRace_AllowPCDialogue								= 0x00200000")
    PrintMessage("kRace_NoKnockdowns									= 0x00400000")
    PrintMessage("kRace_AllowPickpocket								= 0x00800000")
    PrintMessage("kRace_AlwaysUseProxyController			= 0x01000000")
    PrintMessage("kRace_AllowMultipleMembraneShaders	= 0x20000000")
    PrintMessage("kRace_AvoidsRoads										= 0x80000000")
    PrintMessage("================================================")
    Return
  EndIf

  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  Int aiFlag = self.IntFromSArgument(sArgument, 2)

  If akRace == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If aiFlag < 1 || aiFlag > 27
    PrintMessage("FATAL ERROR: Invalid flag number provided. Run " + DoubleQuotes("SetRecordFlag ?") + " to check valid values")
    Return
  EndIf

  ; Set the record flag
  akRace.SetRaceFlag(aiFlag)
EndEvent

Event OnConsoleClearRaceFlag(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearRaceFlag(Race akRace, int aiFlag)")
  
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("RACE FLAGS")
    PrintMessage("================================================")
    PrintMessage("kRace_Playable											= 0x00000001")
    PrintMessage("kRace_FaceGenHead										= 0x00000002")
    PrintMessage("kRace_Child													= 0x00000004")
    PrintMessage("kRace_TiltFrontBack									= 0x00000008")
    PrintMessage("kRace_TiltLeftRight									= 0x00000010")
    PrintMessage("kRace_NoShadow											= 0x00000020")
    PrintMessage("kRace_Swims													= 0x00000040")
    PrintMessage("kRace_Flies													= 0x00000080")
    PrintMessage("kRace_Walks													= 0x00000100")
    PrintMessage("kRace_Immobile											= 0x00000200")
    PrintMessage("kRace_NotPushable										= 0x00000400")
    PrintMessage("kRace_NoCombatInWater								= 0x00000800")
    PrintMessage("kRace_NoRotatingToHeadTrack					= 0x00001000")
    PrintMessage("kRace_UseHeadTrackAnim							= 0x00008000")
    PrintMessage("kRace_SpellsAlignWithMagicNode			= 0x00010000")
    PrintMessage("kRace_UseWorldRaycasts							= 0x00020000")
    PrintMessage("kRace_AllowRagdollCollision					= 0x00040000")
    PrintMessage("kRace_CantOpenDoors									= 0x00100000")
    PrintMessage("kRace_AllowPCDialogue								= 0x00200000")
    PrintMessage("kRace_NoKnockdowns									= 0x00400000")
    PrintMessage("kRace_AllowPickpocket								= 0x00800000")
    PrintMessage("kRace_AlwaysUseProxyController			= 0x01000000")
    PrintMessage("kRace_AllowMultipleMembraneShaders	= 0x20000000")
    PrintMessage("kRace_AvoidsRoads										= 0x80000000")
    PrintMessage("================================================")
    Return
  EndIf

  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  Int aiFlag = self.IntFromSArgument(sArgument, 2)

  If akRace == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If aiFlag < 1 || aiFlag > 27
    PrintMessage("FATAL ERROR: Invalid flag number provided. Run " + DoubleQuotes("ClearRecordFlag ?") + " to check valid values")
    Return
  EndIf

  ; Clear the record flag
  akRace.ClearRaceFlag(aiFlag)
EndEvent

Event OnConsoleIsRaceFlagSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: IsRaceFlagSet(Race akRace, int aiFlag)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    PrintMessage("RACE FLAGS")
    PrintMessage("================================================")
    PrintMessage("kRace_Playable											= 0x00000001")
    PrintMessage("kRace_FaceGenHead										= 0x00000002")
    PrintMessage("kRace_Child													= 0x00000004")
    PrintMessage("kRace_TiltFrontBack									= 0x00000008")
    PrintMessage("kRace_TiltLeftRight									= 0x00000010")
    PrintMessage("kRace_NoShadow											= 0x00000020")
    PrintMessage("kRace_Swims													= 0x00000040")
    PrintMessage("kRace_Flies													= 0x00000080")
    PrintMessage("kRace_Walks													= 0x00000100")
    PrintMessage("kRace_Immobile											= 0x00000200")
    PrintMessage("kRace_NotPushable										= 0x00000400")
    PrintMessage("kRace_NoCombatInWater								= 0x00000800")
    PrintMessage("kRace_NoRotatingToHeadTrack					= 0x00001000")
    PrintMessage("kRace_UseHeadTrackAnim							= 0x00008000")
    PrintMessage("kRace_SpellsAlignWithMagicNode			= 0x00010000")
    PrintMessage("kRace_UseWorldRaycasts							= 0x00020000")
    PrintMessage("kRace_AllowRagdollCollision					= 0x00040000")
    PrintMessage("kRace_CantOpenDoors									= 0x00100000")
    PrintMessage("kRace_AllowPCDialogue								= 0x00200000")
    PrintMessage("kRace_NoKnockdowns									= 0x00400000")
    PrintMessage("kRace_AllowPickpocket								= 0x00800000")
    PrintMessage("kRace_AlwaysUseProxyController			= 0x01000000")
    PrintMessage("kRace_AllowMultipleMembraneShaders	= 0x20000000")
    PrintMessage("kRace_AvoidsRoads										= 0x80000000")
    PrintMessage("================================================")
    Return
  EndIf
  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  Int aiFlag = self.IntFromSArgument(sArgument, 2)
  If akRace == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 

  If aiFlag < 1 || aiFlag > 27
    PrintMessage("FATAL ERROR: Invalid flag number provided. Run " + DoubleQuotes("ClearRecordFlag ?") + " to check valid values")
    Return
  EndIf

  bool flagSet = akRace.IsRaceFlagSet(aiFlag)
  PrintMessage("IsRaceFlagSet: " + flagSet)
EndEvent

Event OnConsoleGetRaceSkin(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRaceSkin(Race akRace)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  If akRace == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  Armor akRaceSkin = akRace.GetSkin()
  PrintMessage("RaceSkin of " + self.GetFullID(akRace) + " is " + self.GetFullID(akRaceSkin))
EndEvent

Event OnConsoleSetRaceSkin(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetRaceSkin(Race akRace, Armor akNewRaceSkin)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  Armor akNewRaceSkin = self.FormFromSArgument(sArgument,2) as Armor
  If akRace == none || akNewRaceSkin == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("RaceSkin of " + self.GetFullID(akRace) + " is " + self.GetFullID(akRace.GetSkin()))
  akRace.SetSkin(akNewRaceSkin)
  If akNewRaceSkin == akRace.GetSkin()
    PrintMessage("Successfully set RaceSkin of " + self.GetFullID(akRace) + " to " + self.GetFullID(akNewRaceSkin))
  Else
    PrintMessage("Failed to set RaceSkin of " + self.GetFullID(akRace) + " to " + self.GetFullID(akNewRaceSkin))
    PrintMessage("RaceSkin of " + self.GetFullID(akRace) + " is still " + self.GetFullID(akRace.GetSkin()))
  EndIf
EndEvent

Event OnConsoleGetRaceDefaultVoiceType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRaceDefaultVoiceType(Race akRace, bool abFemale = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  bool abFemale = self.BoolFromSArgument(sArgument, 1, false)
  If akRace == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  VoiceType akRaceDefaultVoiceType = akRace.GetDefaultVoiceType(abFemale)
  PrintMessage("RaceDefaultVoiceType of " + self.GetFullID(akRace) + " is " + self.GetFullID(akRaceDefaultVoiceType))
EndEvent

Event OnConsoleSetRaceDefaultVoiceType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetRaceDefaultVoiceType(Race akRace, bool abFemale = false, VoiceType akNewVoiceType)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  bool abFemale = self.BoolFromSArgument(sArgument, 2, false)
  VoiceType akNewVoiceType = self.FormFromSArgument(sArgument, 3) as VoiceType
  If akRace == none || akNewVoiceType == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("RaceDefaultVoiceType of " + self.GetFullID(akRace) + " is " + self.GetFullID(akRace.GetDefaultVoiceType(abFemale)))
  akRace.SetDefaultVoiceType(abFemale, akNewVoiceType)
  If akNewVoiceType == akRace.GetDefaultVoiceType(abFemale)
    PrintMessage("Successfully set RaceDefaultVoiceType of " + self.GetFullID(akRace) + " to " + self.GetFullID(akNewVoiceType))
  Else
    PrintMessage("Failed to set RaceDefaultVoiceType of " + self.GetFullID(akRace) + " to " + self.GetFullID(akNewVoiceType))
    PrintMessage("RaceDefaultVoiceType of " + self.GetFullID(akRace) + " is still " + self.GetFullID(akRace.GetDefaultVoiceType(abFemale)))
  EndIf
EndEvent

Event OnConsoleGetActorValueInfoByName(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAVIByName(String asName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  String asName = self.StringFromSArgument(sArgument, 1)
  ActorValueInfo result = ActorValueInfo.GetAVIByName(asName)
  If result == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("Actor value info is " + self.GetFullID(result))
EndEvent

Event OnConsoleGetArmorAddonModelPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorAddonModelPath(ArmorAddon akArmorAddon, bool abFemale = false, bool abFirstPerson = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ArmorAddon akArmorAddon = self.FormFromSArgument(sArgument, 1) as ArmorAddon
  bool abFemale = self.BoolFromSArgument(sArgument, 2, false)
  bool abFirstPerson = self.BoolFromSArgument(sArgument, 3, false)
  If akArmorAddon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  string Result = akArmorAddon.GetModelPath(abFemale, abFirstPerson)
  PrintMessage("GetArmorAddonModelPath " + self.GetFullID(akArmorAddon) + " is " + Result)
EndEvent

Event OnConsoleSetArmorAddonModelPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetArmorAddonModelPath(ArmorAddon akArmorAddon, bool abFemale, bool abFirstPerson, string asPath)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ArmorAddon akArmorAddon = self.FormFromSArgument(sArgument, 1) as ArmorAddon
  bool abFemale = self.BoolFromSArgument(sArgument, 2, false)
  bool abFirstPerson = self.BoolFromSArgument(sArgument, 3, false)
  string asPath = DbMiscFunctions.RemovePrefixFromString(sArgument, self.StringFromSArgument(sArgument, 0) + " " + self.StringFromSArgument(sArgument, 1) + " " + self.StringFromSArgument(sArgument, 2) + self.StringFromSArgument(sArgument, 3) + " ")
  If akArmorAddon == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akArmorAddon.SetModelPath(abFemale, abFirstPerson, asPath)
  PrintMessage("SetArmorAddonModelPath " + self.GetFullID(akArmorAddon) + " to " + asPath)
EndEvent

Event OnConsoleGetConstructibleObjectResult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetConstructibleObjectResult <ConstructibleObject akConstructibleObject>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ConstructibleObject akConstructibleObject = self.FormFromSArgument(sArgument, 1) as ConstructibleObject

  If akConstructibleObject == none
    PrintMessage("FATAL ERROR: ConstructibleObject retrieval failed")
    Return
  EndIf

  Form result = akConstructibleObject.GetResult()
  PrintMessage("GetResult: " + self.GetFullID(result))
EndEvent

Event OnConsoleSetConstructibleObjectResult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetConstructibleObjectResult <ConstructibleObject akConstructibleObject> <Form akResult>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ConstructibleObject akConstructibleObject = self.FormFromSArgument(sArgument, 1) as ConstructibleObject
  Form akResult = self.FormFromSArgument(sArgument, 2)

  If akConstructibleObject == none || akResult == none
    PrintMessage("FATAL ERROR: ConstructibleObject or result retrieval failed")
    Return
  EndIf

  akConstructibleObject.SetResult(akResult)
  PrintMessage("Result of " + self.GetFullID(akConstructibleObject) + " set as " + self.GetFullID(akResult))
EndEvent

Event OnConsoleGetConstructibleObjectResultQuantity(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetConstructibleObjectResultQuantity <ConstructibleObject akConstructibleObject>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ConstructibleObject akConstructibleObject = self.FormFromSArgument(sArgument, 1) as ConstructibleObject

  If akConstructibleObject == none
    PrintMessage("FATAL ERROR: ConstructibleObject retrieval failed")
    Return
  EndIf

  int quantity = akConstructibleObject.GetResultQuantity()
  PrintMessage("GetResultQuantity: " + quantity)
EndEvent

Event OnConsoleSetConstructibleObjectResultQuantity(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetConstructibleObjectResultQuantity <ConstructibleObject akConstructibleObject> <int quantity>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ConstructibleObject akConstructibleObject = self.FormFromSArgument(sArgument, 1) as ConstructibleObject
  int quantity = self.IntFromSArgument(sArgument, 2)

  If akConstructibleObject == none
    PrintMessage("FATAL ERROR: ConstructibleObject retrieval failed")
    Return
  EndIf

  akConstructibleObject.SetResultQuantity(quantity)
  PrintMessage("SetResultQuantity applied to " + akConstructibleObject)
EndEvent

Event OnConsoleGetConstructibleObjectNumIngredients(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetConstructibleObjectNumIngredients <ConstructibleObject akConstructibleObject>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ConstructibleObject akConstructibleObject = self.FormFromSArgument(sArgument, 1) as ConstructibleObject

  If akConstructibleObject == none
    PrintMessage("FATAL ERROR: ConstructibleObject retrieval failed")
    Return
  EndIf

  int numIngredients = akConstructibleObject.GetNumIngredients()
  PrintMessage("GetNumIngredients: " + numIngredients)
EndEvent

Event OnConsoleGetConstructibleObjectNthIngredient(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetConstructibleObjectNthIngredient <ConstructibleObject akConstructibleObject> <int n>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ConstructibleObject akConstructibleObject = self.FormFromSArgument(sArgument, 1) as ConstructibleObject
  int aiIndex = self.IntFromSArgument(sArgument, 2)

  If akConstructibleObject == none
    PrintMessage("FATAL ERROR: ConstructibleObject retrieval failed")
    Return
  EndIf

  Form result = akConstructibleObject.GetNthIngredient(aiIndex)
  PrintMessage("GetNthIngredient: " + self.GetFullID(result))
EndEvent

Event OnConsoleSetConstructibleObjectNthIngredient(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetConstructibleObjectNthIngredient <ConstructibleObject akConstructibleObject> <Form required> <int n>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ConstructibleObject akConstructibleObject = self.FormFromSArgument(sArgument, 1) as ConstructibleObject
  Form required = self.FormFromSArgument(sArgument, 2)
  int aiIndex = self.IntFromSArgument(sArgument, 3)

  If akConstructibleObject == none || required == none
    PrintMessage("FATAL ERROR: ConstructibleObject or required form retrieval failed")
    Return
  EndIf

  akConstructibleObject.SetNthIngredient(required, aiIndex)
  PrintMessage("SetNthIngredient applied to " + self.GetFullID(akConstructibleObject))
EndEvent

Event OnConsoleGetConstructibleObjectNthIngredientQuantity(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetConstructibleObjectNthIngredientQuantity <ConstructibleObject akConstructibleObject> <int n>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ConstructibleObject akConstructibleObject = self.FormFromSArgument(sArgument, 1) as ConstructibleObject
  int aiIndex = self.IntFromSArgument(sArgument, 2)

  If akConstructibleObject == none
    PrintMessage("FATAL ERROR: ConstructibleObject retrieval failed")
    Return
  EndIf

  int quantity = akConstructibleObject.GetNthIngredientQuantity(aiIndex)
  PrintMessage("GetNthIngredientQuantity: " + quantity)
EndEvent

Event OnConsoleSetConstructibleObjectNthIngredientQuantity(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetConstructibleObjectNthIngredientQuantity <ConstructibleObject akConstructibleObject> <int value> <int n>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ConstructibleObject akConstructibleObject = self.FormFromSArgument(sArgument, 1) as ConstructibleObject
  int value = self.IntFromSArgument(sArgument, 2)
  int aiIndex = self.IntFromSArgument(sArgument, 3)

  If akConstructibleObject == none
    PrintMessage("FATAL ERROR: ConstructibleObject retrieval failed")
    Return
  EndIf

  akConstructibleObject.SetNthIngredientQuantity(value, aiIndex)
  PrintMessage("SetNthIngredientQuantity applied to " + akConstructibleObject)
EndEvent

Event OnConsoleGetConstructibleObjectWorkbenchKeyword(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetConstructibleObjectWorkbenchKeyword <ConstructibleObject akConstructibleObject>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ConstructibleObject akConstructibleObject = self.FormFromSArgument(sArgument, 1) as ConstructibleObject

  If akConstructibleObject == none
    PrintMessage("FATAL ERROR: ConstructibleObject retrieval failed")
    Return
  EndIf

  Keyword result = akConstructibleObject.GetWorkbenchKeyword()
  PrintMessage("GetWorkbenchKeyword: " + self.GetFullID(result))
EndEvent

Event OnConsoleSetConstructibleObjectWorkbenchKeyword(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetConstructibleObjectWorkbenchKeyword <ConstructibleObject akConstructibleObject> <Keyword aKeyword>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ConstructibleObject akConstructibleObject = self.FormFromSArgument(sArgument, 1) as ConstructibleObject
  Keyword aKeyword = self.FormFromSArgument(sArgument, 2) as Keyword

  If akConstructibleObject == none || aKeyword == none
    PrintMessage("FATAL ERROR: ConstructibleObject or Keyword retrieval failed")
    Return
  EndIf

  akConstructibleObject.SetWorkbenchKeyword(aKeyword)
  PrintMessage("SetWorkbenchKeyword applied to " + self.GetFullID(akConstructibleObject))
EndEvent

Event OnConsoleGetFloraIngredient(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFloraIngredient(Flora akFlora)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Flora akFlora = self.FormFromSArgument(sArgument, 1) as Flora

  If akFlora == none
    PrintMessage("FATAL ERROR: Form retrieval error")
    Return
  EndIf

  Form currentIngredient = akFlora.GetIngredient()
  PrintMessage("Current ingredient is " + self.GetFullID(currentIngredient))
EndEvent

Event OnConsoleSetFloraIngredient(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetFloraIngredient(Flora akFlora, Ingredient akIngredient)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Flora akFlora = self.FormFromSArgument(sArgument, 1) as Flora
  Ingredient akIngredient = self.FormFromSArgument(sArgument, 2) as Ingredient
  

  If akFlora == none || akIngredient == none
    PrintMessage("FATAL ERROR: Form retrieval error")
    Return
  EndIf

  Form oldIngredient = akFlora.GetIngredient()
  PrintMessage("Flora ingredient is " + self.GetFullID(oldIngredient))
  
  PrintMessage("Attempting to change it to " + self.GetFullID(akIngredient))

  akFlora.SetIngredient(akIngredient)
  
  Form newIngredient = akFlora.GetIngredient()

  If (newIngredient as Ingredient) == akIngredient
    PrintMessage("Success!")
  EndIf
  
  PrintMessage("Flora ingredient is now " + self.GetFullID(newIngredient))

EndEvent

Event OnConsoleGetPotionNthEffectArea(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetPotionNthEffectArea(Potion akPotion, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Potion akPotion = self.FormFromSArgument(sArgument, 1) as Potion
  int aiIndex = self.IntFromSArgument(sArgument, 2)

  If akPotion == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("NthEffectArea of " + self.GetFullID(akPotion) + " is " + akPotion.GetNthEffectArea(aiIndex))
    
EndEvent

Event OnConsoleSetPotionNthEffectArea(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetPotionNthEffectArea(Potion akPotion, int aiIndex, int aiNthEffectArea)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Potion akPotion = self.FormFromSArgument(sArgument, 1) as Potion
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  int aiNthEffectArea = self.IntFromSArgument(sArgument, 3)

  If akPotion == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  

  PrintMessage("NthEffectArea of " + self.GetFullID(akPotion) + " is " + akPotion.GetNthEffectArea(aiIndex))
  PrintMessage("Attempting to set NthEffectArea of " + self.GetFullID(akPotion) + " to " + aiNthEffectArea)
  
  akPotion.SetNthEffectArea(aiIndex, aiNthEffectArea)
  
  PrintMessage("NthEffectArea of " + self.GetFullID(akPotion) + " is now " + akPotion.GetNthEffectArea(aiIndex))
    
EndEvent

Event OnConsoleGetPotionNthEffectMagnitude(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetPotionNthEffectMagnitude(Potion akPotion, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Potion akPotion = self.FormFromSArgument(sArgument, 1) as Potion
  int aiIndex = self.IntFromSArgument(sArgument, 2)

  If akPotion == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("NthEffectMagnitude of " + self.GetFullID(akPotion) + " is " + akPotion.GetNthEffectMagnitude(aiIndex))
    
EndEvent

Event OnConsoleSetPotionNthEffectMagnitude(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetPotionNthEffectMagnitude(Potion akPotion, int aiIndex, float afMagnitude)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Potion akPotion = self.FormFromSArgument(sArgument, 1) as Potion
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  float afMagnitude = self.IntFromSArgument(sArgument, 3)

  If akPotion == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  

  PrintMessage("NthEffectMagnitude of " + self.GetFullID(akPotion) + " is " + akPotion.GetNthEffectMagnitude(aiIndex))
  PrintMessage("Attempting to set NthEffectMagnitude of " + self.GetFullID(akPotion) + " to " + afMagnitude)
  
  akPotion.SetNthEffectMagnitude(aiIndex, afMagnitude)
  
  PrintMessage("NthEffectMagnitude of " + self.GetFullID(akPotion) + " is now " + akPotion.GetNthEffectMagnitude(aiIndex))
    
EndEvent

Event OnConsoleGetPotionNthEffectDuration(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetPotionNthEffectDuration(Potion akPotion, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Potion akPotion = self.FormFromSArgument(sArgument, 1) as Potion
  int aiIndex = self.IntFromSArgument(sArgument, 2)

  If akPotion == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("NthEffectDuration of " + self.GetFullID(akPotion) + " is " + akPotion.GetNthEffectDuration(aiIndex))
    
EndEvent

Event OnConsoleSetPotionNthEffectDuration(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetPotionNthEffectDuration(Potion akPotion, int aiIndex, int aiDuration)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Potion akPotion = self.FormFromSArgument(sArgument, 1) as Potion
  int aiIndex = self.IntFromSArgument(sArgument, 2)
  int aiDuration = self.IntFromSArgument(sArgument, 3)

  If akPotion == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  

  PrintMessage("NthEffectDuration of " + self.GetFullID(akPotion) + " is " + akPotion.GetNthEffectDuration(aiIndex))
  PrintMessage("Attempting to set NthEffectDuration of " + self.GetFullID(akPotion) + " to " + aiDuration)
  
  akPotion.SetNthEffectDuration(aiIndex, aiDuration)
  
  PrintMessage("NthEffectDuration of " + self.GetFullID(akPotion) + " is now " + akPotion.GetNthEffectDuration(aiIndex))
    
EndEvent

Event OnConsoleGetHeadPartValidRaces(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHeadpartValidRaces(HeadPart akHeadPart)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  HeadPart akHeadPart = self.FormFromSArgument(sArgument, 1) as HeadPart
  If akHeadPart == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
  EndIf
  FormList vRaces = akHeadPart.GetValidRaces()
  int i = 0
  int L = vRaces.GetSize()
  If L > 0
    PrintMessage(self.GetFullID(akHeadPart) + " valid races are: ")
    While i < L
      PrintMessage("Race #" + i + ": " + self.GetFullID(vRaces.GetAt(i)))
      i += 1
    EndWhile
  Else
    PrintMessage("No valid races found for " + self.GetFullID(akHeadPart))
    EndIf
EndEvent

Event OnConsoleGetHeadPartType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHeadPartType(HeadPart akHeadPart)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  HeadPart akHeadPart = self.FormFromSArgument(sArgument, 1) as HeadPart
  If akHeadPart == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
  EndIf
  int type = akHeadPart.GetType()
  string typeStr 

  If type == 0
    typeStr = "Misc"
  ElseIf type == 1
    typeStr = "Face"
  ElseIf type == 2
    typeStr = "Eyes"
  ElseIf type == 3
    typeStr = "Hair"
  ElseIf type == 4
    typeStr = "FacialHair"
  ElseIf type == 5
    typeStr = "Scar"
  ElseIf type == 6
    typeStr = "Brows"
  EndIf

  PrintMessage(self.GetFullID(akHeadPart) + " type is " + type + " (" + typeStr + ")")
EndEvent

Event OnConsoleGetAllHeadParts(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllHeadParts [<Actorbase akActorbase>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase
  If QtyPars == 0
    akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetBaseObject() as ActorBase
  Else
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  int totalSlots = akActorBase.GetNumHeadParts()
  int slotPart = 0

  If totalSlots <= 0
    PrintMessage("No headparts found for " + self.GetFullID(akActorBase))
    Return
  Else
    PrintMessage(totalslots + " headparts found for " + self.GetFullID(akActorBase))
  EndIf
  
  While slotPart < totalSlots
    PrintMessage("Headpart " + slotPart + " of " + self.GetFullID(akActorBase) + " is " + self.GetFullID(akActorbase.GetNthHeadPart(slotPart)))
    slotPart += 1
  EndWhile
EndEvent

Event OnConsoleGetAllOverlayHeadParts(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllOverlayHeadParts [<Actorbase akActorbase>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase
  If QtyPars == 0
    akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetBaseObject() as ActorBase
  Else
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  int totalSlots = akActorBase.GetNumOverlayHeadParts()
  int slotPart = 0

  If totalSlots <= 0
    PrintMessage("No overlay headparts found for " + self.GetFullID(akActorBase))
    Return
  Else
    PrintMessage(totalslots + " overlay headparts found for " + self.GetFullID(akActorBase))
  EndIf
  
  While slotPart < totalSlots
    PrintMessage("Headpart " + slotPart + " of " + self.GetFullID(akActorBase) + " is " + self.GetFullID(akActorbase.GetNthOverlayHeadPart(slotPart)))
    slotPart += 1
  EndWhile
EndEvent

Event OnConsoleGetABClass(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABClass [<Actorbase akActorbase>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetBaseObject() as ActorBase
  If QtyPars == 1
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("Class of " + self.GetFullID(akActorBase) + " is " + self.GetFullID(akActorbase.GetClass()))
EndEvent

Event OnConsoleSetABClass(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetABClass [<Actorbase akActorbase>] <int slotPart> <Class akClass>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetBaseObject() as ActorBase
  Class akClass

  If QtyPars == 1
    akClass = self.FormFromSArgument(sArgument, 1) as Class
  Else
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
    akClass = self.FormFromSArgument(sArgument, 2) as Class
  EndIf
  If akActorbase == none || akClass == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Class akOldClass = akActorbase.GetClass()
  PrintMessage("Class of " + self.GetFullID(akActorBase) + " is currently " + self.GetFullID(akOldClass) + ". Attempting to change to " + self.GetFullID(akClass))
  akActorBase.SetClass(akClass)
  Class akNewClass = akActorbase.GetClass()
  If akClass == akNewClass
    PrintMessage("Success!")
  EndIf
  PrintMessage("Class of " + self.GetFullID(akActorBase) + " is now " + self.GetFullID(akNewClass))
EndEvent

Event OnConsoleGetABSpells(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABSpells [<Actorbase akActorbase>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase
  If QtyPars == 0
    akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetBaseObject() as ActorBase
  Else
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  int totalSlots = akActorBase.GetSpellCount()
  int slotPart = 0

  If totalSlots <= 0
    PrintMessage("No base spells found for " + self.GetFullID(akActorBase))
    Return
  Else
    PrintMessage(totalslots + " base spells found for " + self.GetFullID(akActorBase))
  EndIf

  
  While slotPart < totalSlots
    PrintMessage("Base spell #" + slotPart + ": " + self.GetFullID(akActorbase.GetNthSpell(slotPart)))
    slotPart += 1
  EndWhile
EndEvent

Event OnConsoleGetLocationCleared(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLocationCleared(Location akLocation)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Location akLocation = self.FormFromSArgument(sArgument, 1) as Location
  If akLocation == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  bool cleared = akLocation.IsCleared()

  If cleared
    PrintMessage("Location " + self.GetFullID(akLocation) + " is set as cleared")
  Else
    PrintMessage("Location " + self.GetFullID(akLocation) + " is not set as cleared")
  EndIf
EndEvent

Event OnConsoleSetLocationCleared(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLocationCleared(Location akLocation, bool abCleared = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"

    Return
  EndIf
  Location akLocation = self.FormFromSArgument(sArgument, 1) as Location
  bool abCleared = self.BoolFromSArgument(sArgument, 2, true)
  If akLocation == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  akLocation.SetCleared(abCleared)

  If abCleared
    PrintMessage("Location " + self.GetFullID(akLocation) + " set as cleared")
  Else
    PrintMessage("Location " + self.GetFullID(akLocation) + " set as not cleared")
  EndIf
EndEvent

Event OnConsoleGetLocationParent(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLocationParent(Location akLocation)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Location akLocation = self.FormFromSArgument(sArgument, 1) as Location
  If akLocation == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  Location locationParent = akLocation.GetParent()
  
  If locationParent == none
    PrintMessage("Location " + self.GetFullID(akLocation) + " has no location parent")
  Else
    PrintMessage("Parent location of " + self.GetFullID(akLocation) + " is " + self.GetFullID(locationParent))
  EndIf
EndEvent

Event OnConsoleSetLocationParent(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLocationParent(Location akLocation, Location akNewParent)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Location akLocation = self.FormFromSArgument(sArgument, 1) as Location
  Location akNewParent = self.FormFromSArgument(sArgument, 2) as Location
  If akLocation == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  endif

  PO3_SKSEFunctions.SetParentLocation(akLocation, akNewParent)
  
  If akLocation.GetParent() == akNewParent
    PrintMessage("Successfully set parent location of " + self.GetFullID(akLocation) + " to " + self.GetFullID(akNewParent))
  Else
    PrintMessage("Failed to set parent location of " + self.GetFullID(akLocation) + " to " + self.GetFullID(akNewParent))
    PrintMessage("Current parent location is " + akLocation.GetParent())
  EndIf
EndEvent

Event OnConsoleClearCachedFactionFightReactions(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearCachedFactionFightReactions()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  PO3_SKSEFunctions.ClearCachedFactionFightReactions()
  PrintMessage("Cleared cache faction fight reactions")
EndEvent

Event OnConsoleGetLocalGravity(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLocalGravity()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  PrintMessage("Local gravity is " + PO3_SKSEFunctions.GetLocalGravity())
EndEvent

Event OnConsoleFindForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: FindForm(int aiFormType, Keyword[] akKeywords = None)")
  PrintMessage("akKeywords example: ActorTypeUndead,ActorTypeNPC,FE015329")
  PrintMessage("Check FormTypeHelp for valid form types")
  
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ; Get the form type as a string from the user input
  ; String formTypeString = self.StringFromSArgument(sArgument, 1)

  ; Fuzzy match the form type string to the closest valid form type
  ; int aiFormType = MatchFormType(formTypeString)
  int aiFormType = IntFromSArgument(sArgument, 1)

  If aiFormType == -1
    PrintMessage("Invalid form type: " + aiFormType)
    Return
  EndIf

  ; Print the interpreted form type and its integer value
  PrintMessage("Form type interpreted as: " + DbMiscFunctions.GetFormTypeString(aiFormType) + " (" + aiFormType + ")")

  Form[] akForms = self.FormArrayFromSArgument(sArgument, 2)

  If aiFormType > 134 || aiFormType < 1
    PrintMessage("Invalid formtype number")
    Return
  EndIf

  int i = 0
  int L1 = akForms.Length
  int j
  int L2

  Form[] formResults

  While i < L1
    Keyword[] partialKeywords = new Keyword[1]
    partialKeywords[0] = akForms[i] as Keyword
    formResults = PO3_SKSEFunctions.GetAllForms(aiFormType, partialKeywords)
    j = 0
    L2 = formResults.Length
    If L2 <= 0
      PrintMessage("No matching forms found for keyword " + self.GetFullID(partialKeywords[0]))
    Else
      PrintMessage("Found " + L2 + " matching forms")
    EndIf
    While j < L2
      PrintMessage("Form #" + j + ": " + self.GetFullID(formResults[j]))
      j += 1
    EndWhile
    i += 1
  EndWhile

EndEvent

Event OnConsoleGetAddonModels(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAddonModels <EffectShader akEffectShader>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  Debris akDebris = PO3_SKSEFunctions.GetAddonModels(akEffectShader)
  If akDebris
    PrintMessage("Addon models for " + self.GetFullID(akEffectShader) + ": " + self.GetFullID(akDebris))
  Else
    PrintMessage("No addon models found for " + self.GetFullID(akEffectShader))
  EndIf
EndEvent

Event OnConsoleGetEffectShaderTotalCount(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetEffectShaderTotalCount <EffectShader akEffectShader> <bool abActive>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  Bool abActive = self.BoolFromSArgument(sArgument, 2)
  
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  Int totalCount = PO3_SKSEFunctions.GetEffectShaderTotalCount(akEffectShader, abActive)
  PrintMessage("Total count for " + self.GetFullID(akEffectShader) + ": " + totalCount)
EndEvent

Event OnConsoleIsEffectShaderFlagSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: IsEffectShaderFlagSet <EffectShader akEffectShader> <int aiFlag>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  Int aiFlag = self.IntFromSArgument(sArgument, 2)
  
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  Bool isFlagSet = PO3_SKSEFunctions.IsEffectShaderFlagSet(akEffectShader, aiFlag)
  PrintMessage("Flag " + aiFlag + " for " + self.GetFullID(akEffectShader) + " is set: " + isFlagSet)
EndEvent

Event OnConsoleGetMembraneFillTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMembraneFillTexture <EffectShader akEffectShader>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  String textureName = PO3_SKSEFunctions.GetMembraneFillTexture(akEffectShader)
  PrintMessage("Membrane fill texture for " + self.GetFullID(akEffectShader) + ": " + textureName)
EndEvent

Event OnConsoleGetMembraneHolesTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMembraneHolesTexture <EffectShader akEffectShader>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  String textureName = PO3_SKSEFunctions.GetMembraneHolesTexture(akEffectShader)
  PrintMessage("Membrane Holes texture for " + self.GetFullID(akEffectShader) + ": " + textureName)
EndEvent

Event OnConsoleGetMembranePaletteTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMembranePaletteTexture <EffectShader akEffectShader>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  String textureName = PO3_SKSEFunctions.GetMembranePaletteTexture(akEffectShader)
  PrintMessage("Membrane Palette texture for " + self.GetFullID(akEffectShader) + ": " + textureName)
EndEvent

Event OnConsoleGetParticleFullCount(String EventName, String sArgument, Float fArgument, Form Sender)
  float QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetParticleFullCount <EffectShader akEffectShader>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  float FullCount = PO3_SKSEFunctions.GetParticleFullCount(akEffectShader)
  PrintMessage("Total count for " + self.GetFullID(akEffectShader) + ": " + FullCount)
EndEvent

Event OnConsoleGetParticlePaletteTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetParticlePaletteTexture <EffectShader akEffectShader>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  String textureName = PO3_SKSEFunctions.GetParticlePaletteTexture(akEffectShader)
  PrintMessage("Particle Palette texture for " + self.GetFullID(akEffectShader) + ": " + textureName)
EndEvent

Event OnConsoleGetParticleShaderTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetParticleShaderTexture <EffectShader akEffectShader>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  String textureName = PO3_SKSEFunctions.GetParticleShaderTexture(akEffectShader)
  PrintMessage("Particle Shader texture for " + self.GetFullID(akEffectShader) + ": " + textureName)
EndEvent

Event OnConsoleGetParticlePersistentCount(String EventName, String sArgument, Float fArgument, Form Sender)
  float QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetParticlePersistentCount <EffectShader akEffectShader>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  float PersistentCount = PO3_SKSEFunctions.GetParticlePersistentCount(akEffectShader)
  PrintMessage("Persistent count for " + self.GetFullID(akEffectShader) + ": " + PersistentCount)
EndEvent

Event OnConsoleSetAddonModels(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetAddonModels <EffectShader akEffectShader> <Debris akDebris>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  Debris akDebris = self.FormFromSArgument(sArgument, 2) as Debris
  
  If akEffectShader == none || akDebris == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PO3_SKSEFunctions.SetAddonModels(akEffectShader, akDebris)
  PrintMessage("Set addon models for " + self.GetFullID(akEffectShader) + " to " + self.GetFullID(akDebris))
EndEvent

Event OnConsoleClearEffectShaderFlag(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearEffectShaderFlag <EffectShader akEffectShader> <int aiFlag>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  Int aiFlag = self.IntFromSArgument(sArgument, 2)
  
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PO3_SKSEFunctions.ClearEffectShaderFlag(akEffectShader, aiFlag)
  PrintMessage("Clear flag " + aiFlag + " for " + self.GetFullID(akEffectShader))
EndEvent

Event OnConsoleSetEffectShaderFlag(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetEffectShaderFlag <EffectShader akEffectShader> <int aiFlag>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  Int aiFlag = self.IntFromSArgument(sArgument, 2)
  
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PO3_SKSEFunctions.SetEffectShaderFlag(akEffectShader, aiFlag)
  PrintMessage("Set flag " + aiFlag + " for " + self.GetFullID(akEffectShader))
EndEvent

Event OnConsoleSetMembraneColorKeyData(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMembraneColorKeyData <EffectShader akEffectShader> <int aiColorKey> <int aiColorR> <int aiColorG> <int aiColorB> <float afAlpha> <float afTime>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  Int aiColorKey = self.IntFromSArgument(sArgument, 2)
  Int aiColorR = self.IntFromSArgument(sArgument, 3)
  Int aiColorG = self.IntFromSArgument(sArgument, 4)
  Int aiColorB = self.IntFromSArgument(sArgument, 5)
  float afAlpha = self.FloatFromSArgument(sArgument, 6)
  float afTime = self.FloatFromSArgument(sArgument, 7)

  Int[] aiColor
  aiColor[0] = aiColorR
  aiColor[1] = aiColorG
  aiColor[2] = aiColorB
  
  If akEffectShader == none
    PrintMessage("FATAL ERROR: Invalid arguments")
    Return
  EndIf
  
  PO3_SKSEFunctions.SetMembraneColorKeyData(akEffectShader, aiColorKey, aiColor, afAlpha, afTime)
  PrintMessage("Set membrane color key " + aiColorKey + " data for " + self.GetFullID(akEffectShader) + " to ARGB(" + afAlpha + "," + aiColorR + "," + aiColorB + "," + aiColorB + " with time" + afTime)
EndEvent

Event OnConsoleSetMembraneFillTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMembraneFillTexture <EffectShader akEffectShader> <String asTextureName>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  String asTextureName = self.StringFromSArgument(sArgument, 2)
  
  If akEffectShader == none || asTextureName == ""
    PrintMessage("FATAL ERROR: Invalid arguments")
    Return
  EndIf
  
  PO3_SKSEFunctions.SetMembraneFillTexture(akEffectShader, asTextureName)
  PrintMessage("Set membrane fill texture for " + self.GetFullID(akEffectShader) + " to " + asTextureName)
EndEvent

Event OnConsoleSetMembraneHolesTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMembraneHolesTexture <EffectShader akEffectShader> <String asTextureName>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  String asTextureName = self.StringFromSArgument(sArgument, 2)
  
  If akEffectShader == none || asTextureName == ""
    PrintMessage("FATAL ERROR: Invalid arguments")
    Return
  EndIf
  
  PO3_SKSEFunctions.SetMembraneHolesTexture(akEffectShader, asTextureName)
  PrintMessage("Set membrane Holes texture for " + self.GetFullID(akEffectShader) + " to " + asTextureName)
EndEvent

Event OnConsoleSetMembranePaletteTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMembranePaletteTexture <EffectShader akEffectShader> <String asTextureName>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  String asTextureName = self.StringFromSArgument(sArgument, 2)
  
  If akEffectShader == none || asTextureName == ""
    PrintMessage("FATAL ERROR: Invalid arguments")
    Return
  EndIf
  
  PO3_SKSEFunctions.SetMembranePaletteTexture(akEffectShader, asTextureName)
  PrintMessage("Set membrane Palette texture for " + self.GetFullID(akEffectShader) + " to " + asTextureName)
EndEvent

Event OnConsoleSetParticleColorKeyData(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetParticleColorKeyData <EffectShader akEffectShader> <int aiColorKey> <int aiColorR> <int aiColorG> <int aiColorB> <float afAlpha> <float afTime>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  Int aiColorKey = self.IntFromSArgument(sArgument, 2)
  Int aiColorR = self.IntFromSArgument(sArgument, 3)
  Int aiColorG = self.IntFromSArgument(sArgument, 4)
  Int aiColorB = self.IntFromSArgument(sArgument, 5)
  float afAlpha = self.FloatFromSArgument(sArgument, 6)
  float afTime = self.FloatFromSArgument(sArgument, 7)
  
  Int[] aiColor
  aiColor[0] = aiColorR
  aiColor[1] = aiColorG
  aiColor[2] = aiColorB

  
  If akEffectShader == none
    PrintMessage("FATAL ERROR: Invalid arguments")
    Return
  EndIf
  
  PO3_SKSEFunctions.SetParticleColorKeyData(akEffectShader, aiColorKey, aiColor, afAlpha, afTime)
  PrintMessage("Set particle color key " + aiColorKey + " data for " + self.GetFullID(akEffectShader) + " to ARGB(" + afAlpha + "," + aiColorR + "," + aiColorB + "," + aiColorB + " with time" + afTime)
EndEvent

Event OnConsoleSetParticlePaletteTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetParticlePaletteTexture <EffectShader akEffectShader> <String asTextureName>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  String asTextureName = self.StringFromSArgument(sArgument, 2)
  
  If akEffectShader == none || asTextureName == ""
    PrintMessage("FATAL ERROR: Invalid arguments")
    Return
  EndIf
  
  PO3_SKSEFunctions.SetParticlePaletteTexture(akEffectShader, asTextureName)
  PrintMessage("Set Particle Palette texture for " + self.GetFullID(akEffectShader) + " to " + asTextureName)
EndEvent

Event OnConsoleSetParticlePersistentCount(String EventName, String sArgument, Float fArgument, Form Sender)
  float QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetParticlePersistentCount <EffectShader akEffectShader> <float afNewCount>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  float afNewCount = self.FloatFromSArgument(sArgument, 2)
  
  If akEffectShader == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PO3_SKSEFunctions.SetParticlePersistentCount(akEffectShader, afNewCount)
  PrintMessage("Persistent count for " + self.GetFullID(akEffectShader) + " is now " + PO3_SKSEFunctions.GetParticlePersistentCount(akEffectShader))
EndEvent

Event OnConsoleSetParticleShaderTexture(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetParticleShaderTexture <EffectShader akEffectShader> <String asTextureName>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  
  EffectShader akEffectShader = self.FormFromSArgument(sArgument, 1) as EffectShader
  String asTextureName = self.StringFromSArgument(sArgument, 2)
  
  If akEffectShader == none || asTextureName == ""
    PrintMessage("FATAL ERROR: Invalid arguments")
    Return
  EndIf
  
  PO3_SKSEFunctions.SetParticleShaderTexture(akEffectShader, asTextureName)
  PrintMessage("Set Particle Shader texture for " + self.GetFullID(akEffectShader) + " to " + asTextureName)
EndEvent

Event OnConsoleAddEffectItemToEnchantment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddEffectItemToEnchantment(Enchantment akEnchantment, Enchantment akEnchantmentToCopyFrom, int aiIndex, float afCost = -1.0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Enchantment akEnchantment = self.FormFromSArgument(sArgument, 1) as Enchantment
  Enchantment akEnchantmentToCopyFrom = self.FormFromSArgument(sArgument, 2) as Enchantment
  int aiIndex = self.IntFromSArgument(sArgument, 3)
  float afCost = self.FloatFromSArgument(sArgument, 4, 0.0)
  If akEnchantment == none || akEnchantmentToCopyFrom == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.AddEffectItemToEnchantment(akEnchantment, akEnchantmentToCopyFrom, aiIndex, afCost)
  PrintMessage("Added " + self.GetFullID(akEnchantmentToCopyFrom) + " to " + self.GetFullID(akEnchantment))
EndEvent

Event OnConsoleRemoveEffectItemFromEnchantment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveEffectItemFromEnchantment(Enchantment akEnchantment, Enchantment akEnchantmentToMatchFrom, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Enchantment akEnchantment = self.FormFromSArgument(sArgument, 1) as Enchantment
  Enchantment akEnchantmentToMatchFrom = self.FormFromSArgument(sArgument, 2) as Enchantment
  int aiIndex = self.IntFromSArgument(sArgument, 3)
  If akEnchantment == none || akEnchantmentToMatchFrom == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.RemoveEffectItemFromEnchantment(akEnchantment, akEnchantmentToMatchFrom, aiIndex)
  PrintMessage("Removed " + self.GetFullID(akEnchantmentToMatchFrom) + " from " + self.GetFullID(akEnchantment))
EndEvent

Event OnConsoleSetEnchantmentMagicEffect(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetEnchantmentMagicEffect(Enchantment akEnchantment, MagicEffect akMagicEffect, float afMagnitude, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Enchantment akEnchantment = self.FormFromSArgument(sArgument, 1) as Enchantment
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 2) as MagicEffect
  int aiIndex = self.IntFromSArgument(sArgument, 3)
  If akEnchantment == none || akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.SetEnchantmentMagicEffect(akEnchantment, akMagicEffect, aiIndex)
  PrintMessage("Set " + self.GetFullID(akMagicEffect) + " as magic effect #" + aiIndex + " of " + self.GetFullID(akEnchantment))
EndEvent

Event OnConsoleAddEffectItemToSpell(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddEffectItemToSpell(Spell akSpell, Spell akSpellToCopyFrom, int aiIndex, float afCost = -1.0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  Spell akSpellToCopyFrom = self.FormFromSArgument(sArgument, 2) as Spell
  int aiIndex = self.IntFromSArgument(sArgument, 3)
  float afCost = self.FloatFromSArgument(sArgument, 4, 0.0)
  If akSpell == none || akSpellToCopyFrom == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.AddEffectItemToSpell(akSpell, akSpellToCopyFrom, aiIndex, afCost)
  PrintMessage("Added " + self.GetFullID(akSpellToCopyFrom) + " to " + self.GetFullID(akSpell))
EndEvent

Event OnConsoleRemoveEffectItemFromSpell(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveEffectItemFromSpell(Spell akSpell, Spell akSpellToMatchFrom, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Spell akSpell = self.FormFromSArgument(sArgument, 1) as Spell
  Spell akSpellToMatchFrom = self.FormFromSArgument(sArgument, 2) as Spell
  int aiIndex = self.IntFromSArgument(sArgument, 3)
  If akSpell == none || akSpellToMatchFrom == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.RemoveEffectItemFromSpell(akSpell, akSpellToMatchFrom, aiIndex)
  PrintMessage("Removed " + self.GetFullID(akSpellToMatchFrom) + " from " + self.GetFullID(akSpell))
EndEvent



Event OnConsoleGetFurnitureType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFurnitureType(Furniture akFurniture)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Furniture akFurniture = self.FormFromSArgument(sArgument, 1) as Furniture
  If akFurniture == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("Furniture type for  " + self.GetFullID(akFurniture) + " is " + PO3_SKSEFunctions.GetFurnitureType(akFurniture))
EndEvent

Event OnConsoleGetGoldValue(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetGoldValue [<Form akForm = GetSelectedBase()>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm
  int GoldValue
  If QtyPars == 0
    akForm = GetSelectedBase()
  ElseIf QtyPars == 1
    akForm = self.FormFromSArgument(sArgument, 1) as Form
  EndIf
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  GoldValue = akForm.GetGoldValue() ; 1 is first argument, which is second term in sArgument
  PrintMessage("Gold value of " + self.GetFullID(akForm) + " is " + GoldValue)
EndEvent

Event OnConsoleSetGoldValue(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetGoldValue [<Form akForm = GetSelectedBase()>] <int aiGoldValue>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm
  int aiGoldValue
  If QtyPars == 1
    akForm = GetSelectedBase()
    aiGoldValue = self.IntFromSArgument(sArgument, 1)
  ElseIf QtyPars == 2
    akForm = self.FormFromSArgument(sArgument, 1) as Form
    aiGoldValue = self.IntFromSArgument(sArgument, 2)
  EndIf
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  akForm.SetGoldValue(aiGoldValue) ; 1 is first argument, which is second term in sArgument
  PrintMessage("Gold value of " + self.GetFullID(akForm) + " set to " + aiGoldValue)
EndEvent

Event OnConsoleKnockAreaEffect(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: KnockAreaEffect(ObjectReference akRef, float afMagnitude, float afRadius)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  float afMagnitude
  float afRadius
  If QtyPars == 2
    akRef = ConsoleUtil.GetSelectedReference()
    afMagnitude = FloatFromSArgument(sArgument, 1)
    afRadius = FloatFromSArgument(sArgument, 2)
  Else
    akRef = RefFromSArgument(sArgument, 1)
    afMagnitude = FloatFromSArgument(sArgument, 2)
    afRadius = FloatFromSArgument(sArgument, 3)
  EndIf
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf 
  akRef.KnockAreaEffect(afMagnitude, afRadius)
EndEvent

Event OnConsoleResetReference(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ResetReference <ObjectReference akRef> [ObjectReference akTarget = None]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  ObjectReference akTarget = None
  if QtyPars > 1
    akTarget = self.FormFromSArgument(sArgument, 2) as ObjectReference
  EndIf

  If akRef == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf

  akRef.Reset(akTarget)
  PrintMessage("ResetReference applied to " + self.GetFullID(akRef))
EndEvent

Event OnConsoleDeleteReference(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: DeleteReference <ObjectReference akRef>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference

  If akRef == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf

  akRef.Delete()
  PrintMessage("ORDelete applied to " + self.GetFullID(akRef))
EndEvent

Event OnConsoleDisableReference(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: Disable <ObjectReference akRef> [bool abFadeOut = false]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  bool abFadeOut = self.BoolFromSArgument(sArgument, 2, false)

  If akRef == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf

  akRef.Disable(abFadeOut)
  PrintMessage("ORDisable applied to " + self.GetFullID(akRef))
EndEvent

Event OnConsolePlayAnimation(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlayAnimation <ObjectReference akRef> <string asAnimation>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  string asAnimation = self.StringFromSArgument(sArgument, 2)

  If akRef == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf

  bool result = akRef.PlayAnimation(asAnimation)
  PrintMessage("ORPlayAnimation: " + result)
EndEvent

Event OnConsolePlayAnimationAndWait(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlayAnimationAndWait <ObjectReference akRef> <string asAnimation> <string asEventName>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  string asAnimation = self.StringFromSArgument(sArgument, 2)
  string asEventName = self.StringFromSArgument(sArgument, 3)

  If akRef == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf

  bool result = akRef.PlayAnimationAndWait(asAnimation, asEventName)
  PrintMessage("ORPlayAnimationAndWait: " + result)
EndEvent

Event OnConsolePlayGamebryoAnimation(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlayGamebryoAnimation <ObjectReference akRef> <string asAnimation> [bool abStartOver = false] [float afEaseInTime = 0.0]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  string asAnimation = self.StringFromSArgument(sArgument, 2)
  bool abStartOver = self.BoolFromSArgument(sArgument, 3, false)
  float afEaseInTime = self.FloatFromSArgument(sArgument, 4, 0.0)

  If akRef == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf

  bool result = akRef.PlayGamebryoAnimation(asAnimation, abStartOver, afEaseInTime)
  PrintMessage("ORPlayGamebryoAnimation: " + result)
EndEvent

Event OnConsolePlayImpactEffect(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlayImpactEffect <ObjectReference akRef> <ImpactDataSet akImpactEffect> [string asNodeName] [float afPickDirX = 0.0] [float afPickDirY = 0.0] [float afPickDirZ = -1.0] [float afPickLength = 512.0] [bool abApplyNodeRotation = false] [bool abUseNodeLocalRotation = false]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  ImpactDataSet akImpactEffect = self.FormFromSArgument(sArgument, 2) as ImpactDataSet
  string asNodeName = self.StringFromSArgument(sArgument, 3)
  float afPickDirX = self.FloatFromSArgument(sArgument, 4, 0.0)
  float afPickDirY = self.FloatFromSArgument(sArgument, 5, 0.0)
  float afPickDirZ = self.FloatFromSArgument(sArgument, 6, -1.0)
  float afPickLength = self.FloatFromSArgument(sArgument, 7, 512.0)
  bool abApplyNodeRotation = self.BoolFromSArgument(sArgument, 8, false)
  bool abUseNodeLocalRotation = self.BoolFromSArgument(sArgument, 9, false)

  If akRef == none || akImpactEffect == none
    PrintMessage("FATAL ERROR: ObjectReference or ImpactDataSet retrieval failed")
    Return
  EndIf

  bool result = akRef.PlayImpactEffect(akImpactEffect, asNodeName, afPickDirX, afPickDirY, afPickDirZ, afPickLength, abApplyNodeRotation, abUseNodeLocalRotation)
  PrintMessage("ORPlayImpactEffect: " + result)
EndEvent

Event OnConsolePlaySyncedAnimationSS(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlaySyncedAnimationSS <ObjectReference akRef> <string asAnimation1> <ObjectReference akObj2> <string asAnimation2>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  string asAnimation1 = self.StringFromSArgument(sArgument, 2)
  ObjectReference akObj2 = self.FormFromSArgument(sArgument, 3) as ObjectReference
  string asAnimation2 = self.StringFromSArgument(sArgument, 4)

  If akRef == none || akObj2 == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf

  bool result = akRef.PlaySyncedAnimationSS(asAnimation1, akObj2, asAnimation2)
  PrintMessage("ORPlaySyncedAnimationSS: " + result)
EndEvent

Event OnConsolePlaySyncedAnimationAndWaitSS(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlaySyncedAnimationAndWaitSS <ObjectReference akRef> <string asAnimation1> <string asEvent1> <ObjectReference akObj2> <string asAnimation2> <string asEvent2>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  string asAnimation1 = self.StringFromSArgument(sArgument, 2)
  string asEvent1 = self.StringFromSArgument(sArgument, 3)
  ObjectReference akObj2 = self.FormFromSArgument(sArgument, 4) as ObjectReference
  string asAnimation2 = self.StringFromSArgument(sArgument, 5)
  string asEvent2 = self.StringFromSArgument(sArgument, 6)

  If akRef == none || akObj2 == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf

  bool result = akRef.PlaySyncedAnimationAndWaitSS(asAnimation1, asEvent1, akObj2, asAnimation2, asEvent2)
  PrintMessage("ORPlaySyncedAnimationAndWaitSS: " + result)
EndEvent

Event OnConsolePushActorAway(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PushActorAway <ObjectReference akRef> <Actor akActorToPush> <float aiKnockbackForce>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  Actor akActorToPush = self.FormFromSArgument(sArgument, 2) as Actor
  float aiKnockbackForce = self.FloatFromSArgument(sArgument, 3)

  If akRef == none || akActorToPush == none
    PrintMessage("FATAL ERROR: ObjectReference or Actor retrieval failed")
    Return
  EndIf

  akRef.PushActorAway(akActorToPush, aiKnockbackForce)
  PrintMessage("ORPushActorAway applied to " + self.GetFullID(akRef))
EndEvent

Event OnConsoleSetAnimationVariableBool(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetAnimationVariableBool <ObjectReference akRef> <string arVariableName> <bool abNewValue>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  string arVariableName = self.StringFromSArgument(sArgument, 2)
  bool abNewValue = self.BoolFromSArgument(sArgument, 3)

  If akRef == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf

  akRef.SetAnimationVariableBool(arVariableName, abNewValue)
  PrintMessage("ORSetAnimationVariableBool applied to " + self.GetFullID(akRef))
EndEvent

Event OnConsoleSetAnimationVariableInt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetAnimationVariableInt <ObjectReference akRef> <string arVariableName> <int aiNewValue>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  string arVariableName = self.StringFromSArgument(sArgument, 2)
  int aiNewValue = self.IntFromSArgument(sArgument, 3)

  If akRef == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf

  akRef.SetAnimationVariableInt(arVariableName, aiNewValue)
  PrintMessage("ORSetAnimationVariableInt applied to " + self.GetFullID(akRef))
EndEvent

Event OnConsoleSetAnimationVariableFloat(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetAnimationVariableFloat <ObjectReference akRef> <string arVariableName> <float afNewValue>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  string arVariableName = self.StringFromSArgument(sArgument, 2)
  float afNewValue = self.FloatFromSArgument(sArgument, 3)

  If akRef == none
    PrintMessage("FATAL ERROR: ObjectReference retrieval failed")
    Return
  EndIf

  akRef.SetAnimationVariableFloat(arVariableName, afNewValue)
  PrintMessage("ORSetAnimationVariableFloat applied to " + self.GetFullID(akRef))
EndEvent

Event OnConsoleApplyHavokImpulse(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ApplyHavokImpulse(float afX, float afY, float afZ, float afMagnitude)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akRef = self.FormFromSArgument(sArgument, 1) as ObjectReference
  float afX = self.FloatFromSArgument(sArgument, 2)
  float afY = self.FloatFromSArgument(sArgument, 3)
  float afZ = self.FloatFromSArgument(sArgument, 4)
  float afMagnitude = self.FloatFromSArgument(sArgument, 5)

  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  akRef.ApplyHavokImpulse(afX, afY, afZ, afMagnitude)
  PrintMessage("ApplyHavokImpulse applied to " + self.GetFullID(akRef))
EndEvent

Event OnConsoleNodeHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: BodyMorphHelp [<string asSearchString>]")

  PrintMessage("XPMSE SKELETON MORPH NAMES")
  PrintMessage("===================================")
  
  String[] NodeMsg = new String[128]
  NodeMsg[0] = "NPC Root [Root]"
  NodeMsg[1] = "x_NPC LookNode [Look]"
  NodeMsg[2] = "x_NPC Translate [Pos ]"
  NodeMsg[3] = "x_NPC Rotate [Rot ]"
  NodeMsg[4] = "NPC COM [COM ]"
  NodeMsg[5] = "NPC Pelvis [Pelv]"
  NodeMsg[6] = "NPC L Thigh [LThg]"
  NodeMsg[7] = "NPC L Calf [LClf]"
  NodeMsg[8] = "NPC L Foot [Lft ]"
  NodeMsg[9] = "NPC R Thigh [RThg]"
  NodeMsg[10] = "NPC R Calf [RClf]"
  NodeMsg[11] = "NPC R Foot [Rft ]"
  NodeMsg[12] = "SkirtRBone01"
  NodeMsg[13] = "SkirtRBone02"
  NodeMsg[14] = "SkirtRBone03"
  NodeMsg[15] = "SkirtLBone01"
  NodeMsg[16] = "SkirtLBone02"
  NodeMsg[17] = "SkirtLBone03"
  NodeMsg[18] = "SkirtBBone01"
  NodeMsg[19] = "SkirtBBone02"
  NodeMsg[20] = "SkirtBBone03"
  NodeMsg[21] = "SkirtFBone01"
  NodeMsg[22] = "SkirtFBone02"
  NodeMsg[23] = "SkirtFBone03"
  NodeMsg[24] = "NPC Spine [Spn0]"
  NodeMsg[25] = "NPC Spine1 [Spn1]"
  NodeMsg[26] = "NPC Spine2 [Spn2]"
  NodeMsg[27] = "NPC L Clavicle [LClv]"
  NodeMsg[28] = "NPC L UpperArm [LUar]"
  NodeMsg[29] = "NPC L Forearm [LLar]"
  NodeMsg[30] = "NPC R Clavicle [RClv]"
  NodeMsg[31] = "NPC R UpperArm [RUar]"
  NodeMsg[32] = "NPC R Forearm [RLar]"
  NodeMsg[33] = "AnimObjectA"
  NodeMsg[34] = "AnimObjectB"
  NodeMsg[35] = "NPC Neck [Neck]"
  NodeMsg[36] = "NPC Head [Head]"
  NodeMsg[37] = "NPCEyeBone"
  NodeMsg[38] = "NPC L Hand [LHnd]"
  NodeMsg[39] = "NPC R Hand [RHnd]"
  NodeMsg[40] = "AnimObjectL"
  NodeMsg[41] = "AnimObjectR"
  NodeMsg[42] = "Shield"
  NodeMsg[43] = "Weapon"
  NodeMsg[44] = "NPC L Pauldron"
  NodeMsg[45] = "NPC R Pauldron"
  NodeMsg[46] = "MagicEffectsNode"
  NodeMsg[47] = "NPC L MagicNode [LMag]"
  NodeMsg[48] = "NPC R MagicNode [RMag]"
  NodeMsg[49] = "NPC Head MagicNode [Hmag]"
  NodeMsg[50] = "NPC L Toe0 [LToe]"
  NodeMsg[51] = "NPC R Toe0 [RToe]"
  NodeMsg[52] = "NPC L ForearmTwist1 [LLt1]"
  NodeMsg[53] = "NPC L ForearmTwist2 [LLt2]"
  NodeMsg[54] = "NPC L UpperarmTwist1 [LUt1]"
  NodeMsg[55] = "NPC L UpperarmTwist2 [LUt2]"
  NodeMsg[56] = "NPC R ForearmTwist1 [RLt1]"
  NodeMsg[57] = "NPC R ForearmTwist2 [RLt2]"
  NodeMsg[58] = "NPC R UpperarmTwist1 [RUt1]"
  NodeMsg[59] = "NPC R UpperarmTwist2 [RUt2]"
  NodeMsg[60] = "Quiver"
  NodeMsg[61] = "WeaponAxe"
  NodeMsg[62] = "WeaponBack"
  NodeMsg[63] = "WeaponBow"
  NodeMsg[64] = "WeaponDagger"
  NodeMsg[65] = "WeaponMace"
  NodeMsg[66] = "WeaponSword"
  NodeMsg[67] = "NPC L Finger00 [LF00]"
  NodeMsg[68] = "NPC L Finger01 [LF01]"
  NodeMsg[69] = "NPC L Finger02 [LF02]"
  NodeMsg[70] = "NPC L Finger10 [LF10]"
  NodeMsg[71] = "NPC L Finger11 [LF11]"
  NodeMsg[72] = "NPC L Finger12 [LF12]"
  NodeMsg[73] = "NPC L Finger20 [LF20]"
  NodeMsg[74] = "NPC L Finger21 [LF21]"
  NodeMsg[75] = "NPC L Finger22 [LF22]"
  NodeMsg[76] = "NPC L Finger30 [LF30]"
  NodeMsg[77] = "NPC L Finger31 [LF31]"
  NodeMsg[78] = "NPC L Finger32 [LF32]"
  NodeMsg[79] = "NPC L Finger40 [LF40]"
  NodeMsg[80] = "NPC L Finger41 [LF41]"
  NodeMsg[81] = "NPC L Finger42 [LF42]"
  NodeMsg[82] = "NPC R Finger00 [RF00]"
  NodeMsg[83] = "NPC R Finger01 [RF01]"
  NodeMsg[84] = "NPC R Finger02 [RF02]"
  NodeMsg[85] = "NPC R Finger10 [RF10]"
  NodeMsg[86] = "NPC R Finger11 [RF11]"
  NodeMsg[87] = "NPC R Finger12 [RF12]"
  NodeMsg[88] = "NPC R Finger20 [RF20]"
  NodeMsg[89] = "NPC R Finger21 [RF21]"
  NodeMsg[90] = "NPC R Finger22 [RF22]"
  NodeMsg[91] = "NPC R Finger30 [RF30]"
  NodeMsg[92] = "NPC R Finger31 [RF31]"
  NodeMsg[93] = "NPC R Finger32 [RF32]"
  NodeMsg[94] = "NPC R Finger40 [RF40]"
  NodeMsg[95] = "NPC R Finger41 [RF41]"
  NodeMsg[96] = "NPC R Finger42 [RF42]"
  NodeMsg[97] = "Camera3rd [Cam3]"
  NodeMsg[98] = "Camera Control"
  NodeMsg[99] = "NPC L Item01"
  NodeMsg[100] = "NPC L Item02"
  NodeMsg[101] = "NPC L Item03"
  NodeMsg[102] = "NPC R Item01"
  NodeMsg[103] = "NPC R Item02"
  NodeMsg[104] = "NPC R Item03"
  NodeMsg[105] = "LeftWing1"
  NodeMsg[106] = "LeftWing2"
  NodeMsg[107] = "LeftWing3"
  NodeMsg[108] = "LeftWing4"
  NodeMsg[109] = "LeftWing5"
  NodeMsg[110] = "RightWing1"
  NodeMsg[111] = "RightWing2"
  NodeMsg[112] = "RightWing3"
  NodeMsg[113] = "RightWing4"
  NodeMsg[114] = "RightWing5"
  NodeMsg[115] = "Belly"
  NodeMsg[116] = "NPC Anus Deep1"
  NodeMsg[117] = "NPC RB Anus1"
  NodeMsg[118] = "NPC LB Anus1"
  NodeMsg[119] = "NPC LT Anus1"
  NodeMsg[120] = "NPC RT Anus1"
  NodeMsg[121] = "NPC Anus Deep2"
  NodeMsg[122] = "NPC RB Anus2"
  NodeMsg[123] = "NPC LB Anus2"
  NodeMsg[124] = "NPC LT Anus2"
  NodeMsg[125] = "NPC RT Anus2"
    
  String searchTerm = self.StringFromSArgument(sArgument, 1)
  Bool found = false
  Int i = 0

  While i < 128
    If StringUtil.Find(NodeMsg[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(NodeMsg[i])
      found = true
    EndIf
    i += 1
  EndWhile

  If !found
    PrintMessage("No matching node names found")
  EndIf
  PrintMessage("===================================")
EndEvent
  
Event OnConsoleMoveToNode(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: MoveToNode [<ObjectReference akRef>] <ObjectReference akTarget> <string asNodeName>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef
  ObjectReference akTarget
  string asNodeName
  If QtyPars == 2
    akRef = ConsoleUtil.GetSelectedReference()
    akTarget = self.RefFromSArgument(sArgument, 1)
    asNodeName = self.StringFromSArgument(sArgument, 2)
  Else
    akRef = self.RefFromSArgument(sArgument, 1)
    akTarget = self.RefFromSArgument(sArgument, 2)
    asNodeName = self.StringFromSArgument(sArgument, 3)
  EndIf
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  If !NetImmerse.HasNode(akTarget, asNodeName, false)
    PrintMessage("FATAL ERROR: Target does not have node " + asNodeName)
    Return
  EndIf
  akRef.MoveToNode(akTarget, asNodeName)
  PrintMessage(self.GetFullID(akRef) + " was moved to " + self.GetFullID(akTarget) + "'s " + asNodeName + "node")
EndEvent

Event OnConsoleBodyMorphHelp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: BodyMorphHelp [<string asSearchString>]")

  PrintMessage("CBBE BODY MORPH NAMES")
  PrintMessage("===================================")
  
	String[] morphs     = new String[128]
    morphs[0] = "Innieoutie"
    morphs[1] = "LabiaNeat_v2"
    morphs[2] = "LabiaTightUp"
    morphs[3] = "Labiapuffyness"
    morphs[4] = "LabiaMorePuffyness_v2"
    morphs[5] = "Labiaprotrude"
    morphs[6] = "Labiaprotrude2"
    morphs[7] = "Labiaprotrudeback"
    morphs[8] = "Labiaspread"
    morphs[9] = "LabiaCrumpled_v2"
    morphs[10] = "LabiaBulgogi_v2"
    morphs[11] = "Vaginasize"
    morphs[12] = "VaginaHole"
    morphs[13] = "Clit"
    morphs[14] = "ClitSwell_v2"
    morphs[15] = "Cutepuffyness"
    morphs[16] = "CBPC"
    morphs[17] = "CrotchGap"
    morphs[18] = "AnalLoose_v2"
    morphs[19] = "AnalPosition_v2"
    morphs[20] = "AnalTexPos_v2"
    morphs[21] = "AnalTexPosRe_v2"
    morphs[22]  = "7B Lower"
    morphs[23]  = "7B Upper"
    morphs[24]  = "VanillaSSEHi"
    morphs[25]  = "VanillaSSELo"
    morphs[26]  = "OldBaseShape"
    morphs[27]  = "Breasts"
    morphs[28]  = "BreastsSmall"
    morphs[29]  = "BreastsSmall2"
    morphs[30]  = "DoubleMelon"
    morphs[31]  = "BreastCleavage"
    morphs[32] = "BreastsTogether"
    morphs[33] = "BreastsConverage_v2"
    morphs[34] = "PushUp"
    morphs[35] = "BreastGravity2"
    morphs[36] = "BreastHeight"
    morphs[37] = "BreastPerkiness"
    morphs[38] = "BreastWidth"
    morphs[39] = "BreastTopSlope"
    morphs[40] = "BreastCenter"
    morphs[41] = "BreastCenterBig"
    morphs[42] = "BreastFlatness"
    morphs[43] = "BreastFlatness2"
    morphs[44] = "BreastsFantasy"
    morphs[45] = "BreastsNewSH"
    morphs[46] = "BreastsNewSHSymmetry"
    morphs[47] = "BreastsGone"
    morphs[48] = "BreastSideShape"
    morphs[49] = "BreastUnderDepth"
    morphs[50] = "BreastsPressed_v2"
    morphs[51] = "NippleSize"
    morphs[52] = "AreolaSize"
    morphs[53] = "AreolaPull_v2"
    morphs[54] = "NippleLength"
    morphs[55] = "NippleSquash1_v2"
    morphs[56] = "NippleSquash2_v2"
    morphs[57] = "NippleManga"
    morphs[58] = "NipplePerkiness"
    morphs[59] = "NipplePerkManga"
    morphs[60] = "NipplePuffy_v2"
    morphs[61] = "NippleShy_v2"
    morphs[62] = "NippleDistance"
    morphs[63] = "NippleTip"
    morphs[64] = "NippleTipManga"
    morphs[65] = "NippleThicc_v2"
    morphs[66] = "NippleTube_v2"
    morphs[67] = "NippleDown"
    morphs[68] = "NippleUp"
    morphs[69] = "NippleDip"
    morphs[70] = "NippleCrease_v2"
    morphs[71] = "NippleCrumpled_v2"
    morphs[72] = "NippleBump_v2"
    morphs[73] = "NipBGone"
    morphs[74] = "NippleInvert_v2"
    morphs[75] = "Clavicle_v2"
    morphs[76] = "BigTorso"
    morphs[77] = "ChestDepth"
    morphs[78] = "ChestWidth"
    morphs[79] = "SternumDepth"
    morphs[80] = "SternumHeight"
    morphs[81] = "RibsProminance"
    morphs[82] = "RibsMore_v2"
    morphs[83] = "NavelEven"
    morphs[84] = "Waist"
    morphs[85] = "WaistHeight"
    morphs[86] = "WideWaistLine"
    morphs[87] = "ChubbyWaist"
    morphs[88] = "Back"
    morphs[89] = "BackArch"
    morphs[90] = "BackValley_v2"
    morphs[91] = "BackWing_v2"
    morphs[92] = "Butt"
    morphs[93] = "BigButt"
    morphs[94] = "ButtSmall"
    morphs[95] = "ChubbyButt"
    morphs[96] = "AppleCheeks"
    morphs[97] = "ButtDimples"
    morphs[98] = "ButtUnderFold"
    morphs[99] = "RoundAss"
    morphs[100] = "ButtSaggy_v2"
    morphs[101] = "ButtPressed_v2"
    morphs[102] = "ButtNarrow_v2"
    morphs[103] = "ButtClassic"
    morphs[104] = "ButtShape2"
    morphs[105] = "ButtCrack"
    morphs[106] = "Groin"
    morphs[107] = "CrotchBack"
    morphs[108] = "7BLeg_v2"
    morphs[109] = "Thighs"
    morphs[110] = "ThighOutsideThicc_v2"
    morphs[111] = "ThighInsideThicc_v2"
    morphs[112] = "ThighFBThicc_v2"
    morphs[113] = "SlimThighs"
    morphs[114] = "LegsThin"
    morphs[115] = "ChubbyLegs"
    morphs[116] = "LegShapeClassic"
    morphs[117] = "LegSpread_v2"
    morphs[118] = "KneeHeight"
    morphs[119] = "KneeShape"
    morphs[120] = "KneeTogether_v2"
    morphs[121] = "CalfSize"
    morphs[122] = "CalfSmooth"
    morphs[123] = "CalfFBThicc_v2"
    morphs[124] = "FeetFeminine"
    morphs[125] = "AnkleSize"
    morphs[126] = "MuscleAbs"
    morphs[127] = "MuscleMoreAbs_v2"

	
	String[] morphs2    = new String[128]
    morphs2[0] = "MuscleArms"
    morphs2[1] = "MuscleMoreArms_v2"
    morphs2[2] = "MuscleButt"
    morphs2[3] = "MuscleLegs"
    morphs2[4] = "MuscleMoreLegs_v2"
    morphs2[5] = "MusclePecs"
    morphs2[6] = "MuscleBack_v2"
    morphs2[7] = "Hips"
    morphs2[8] = "HipBone"
    morphs2[9] = "HipUpperWidth"
    morphs2[10] = "HipCarved"
    morphs2[11] = "HipForward"
    morphs2[12] = "HipNarrow_v2"
    morphs2[13] = "UNPHip_v2"
    morphs2[14] = "Arms"
    morphs2[15] = "ChubbyArms"
    morphs2[16] = "ForearmSize"
    morphs2[17] = "ArmpitShape_v2"
    morphs2[18] = "WristSize"
    morphs2[19] = "ShoulderWidth"
    morphs2[20] = "ShoulderSmooth"
    morphs2[21] = "ShoulderTweak"
    morphs2[22] = "Belly"
    morphs2[23] = "BigBelly"
    morphs2[24] = "BellyFrontUpFat_v2"
    morphs2[25] = "BellyFrontDownFat_v2"
    morphs2[26] = "BellySideUpFat_v2"
    morphs2[27] = "BellySideDownFat_v2"
    morphs2[28] = "BellyUnder_v2"
    morphs2[29] = "TummyTuck"
    morphs2[30] = "PregnancyBelly"

  String[] HIMBOMorphs = new String[128]
    
    HIMBOMorphs[0] = "Chubby"
    HIMBOMorphs[1] = "Lean"
    HIMBOMorphs[2] = "Muscle"
    HIMBOMorphs[3] = "SOSLike"

    HIMBOMorphs[4] = "PecsClavicle"
    HIMBOMorphs[5] = "PecsSize"
    HIMBOMorphs[6] = "PecsMass"
    HIMBOMorphs[7] = "PecsSaggy"
    HIMBOMorphs[8] = "PecsWidth"
    HIMBOMorphs[9] = "PecsFlatten"
    HIMBOMorphs[10] = "PecsPosV"
    HIMBOMorphs[11] = "PecsPosH"
    HIMBOMorphs[12] = "PecsSide"
    HIMBOMorphs[13] = "PecsPush"
    HIMBOMorphs[14] = "PecsLowerSide"
    HIMBOMorphs[15] = "PecsDecrease"
    HIMBOMorphs[16] = "PecsCrease"

    HIMBOMorphs[17] = "NipsAreola"
    HIMBOMorphs[18] = "NipsTips"
    HIMBOMorphs[19] = "NipsLength"
    HIMBOMorphs[20] = "NipsRound"
    HIMBOMorphs[21] = "NipsAngle"
    HIMBOMorphs[22] = "NipsPuffy"
    HIMBOMorphs[23] = "NipsLower"

    HIMBOMorphs[24] = "ButtBooty"
    HIMBOMorphs[25] = "ButtRoundy"
    HIMBOMorphs[26] = "ButtSaggy"
    HIMBOMorphs[27] = "ButtCleft"
    HIMBOMorphs[28] = "ButtSide"
    HIMBOMorphs[29] = "ButtCenterPush"
    HIMBOMorphs[30] = "ButtCurve"
    HIMBOMorphs[31] = "ButtDimpleDeepen"
    HIMBOMorphs[32] = "ButtDimpleFatten"

    HIMBOMorphs[33] = "TorsoSterHeight"
    HIMBOMorphs[34] = "TorsoSterDepth"
    HIMBOMorphs[35] = "TorsoSterWidth"
    HIMBOMorphs[36] = "TorsoBackSize"
    HIMBOMorphs[37] = "TorsoBackSlope"
    HIMBOMorphs[38] = "TorsoBackShape"
    HIMBOMorphs[39] = "TorsoBackCenter"
    HIMBOMorphs[40] = "TorsoBackSerratusMid"
    HIMBOMorphs[41] = "TorsoBackObliques"
    HIMBOMorphs[42] = "TorsoMass"
    HIMBOMorphs[43] = "TorsoWidth"
    HIMBOMorphs[44] = "TorsoLower"
    HIMBOMorphs[45] = "TorsoWaistSize"
    HIMBOMorphs[46] = "TorsoWaistHeight"
    HIMBOMorphs[47] = "TorsoHip"
    HIMBOMorphs[48] = "TorsoFlatAbs"
    HIMBOMorphs[49] = "TorsoRibsDefinition"
    HIMBOMorphs[50] = "TorsoVLine"
    HIMBOMorphs[51] = "TorsoBelly"
    HIMBOMorphs[52] = "TorsoBellyChub"
    HIMBOMorphs[53] = "TorsoBellyLHandles"
    HIMBOMorphs[54] = "TorsoSpine"

    HIMBOMorphs[55] = "ArmsTraps"
    HIMBOMorphs[56] = "ArmsTrapsMeat"
    HIMBOMorphs[57] = "ArmsTrapsPush"
    HIMBOMorphs[58] = "ArmsTrapsValleys"
    HIMBOMorphs[59] = "ArmsClavicleCurve"
    HIMBOMorphs[60] = "ArmsShoulders"
    HIMBOMorphs[61] = "ArmsDelts"
    HIMBOMorphs[62] = "ArmsDeltsBack"
    HIMBOMorphs[63] = "ArmsDeltsUpper"
    HIMBOMorphs[64] = "ArmsDeltsLower"
    HIMBOMorphs[65] = "ArmsBiceps"
    HIMBOMorphs[66] = "ArmsBicepsBack"
    HIMBOMorphs[67] = "ArmsSide"
    HIMBOMorphs[68] = "ArmsBrachio"
    HIMBOMorphs[69] = "ArmsFore"

    HIMBOMorphs[70] = "LegsSize"
    HIMBOMorphs[71] = "LegsThigh"
    HIMBOMorphs[72] = "LegsThinner"
    HIMBOMorphs[73] = "LegsChubby"
    HIMBOMorphs[74] = "LegsGlutes"

    HIMBOMorphs[75] = "LegsFemurUpper"
    HIMBOMorphs[76] = "LegsFemurLower"
    HIMBOMorphs[77] = "LegsFemurSide"
    HIMBOMorphs[78] = "LegsFemurBack"

    HIMBOMorphs[79] = "LegsKneePit"

    HIMBOMorphs[80] = "LegsCalfSize"
    HIMBOMorphs[81] = "LegsCalfWidth"
    HIMBOMorphs[82] = "LegsCalfUpper"
    HIMBOMorphs[83] = "LegsCalfLower"
    HIMBOMorphs[84] = "LegsCalfFlatten"

    HIMBOMorphs[85] = "LegsShinCrease"

    HIMBOMorphs[86] = "FemmeT"
    HIMBOMorphs[87] = "FemmeB"
    
    HIMBOMorphs[88] = "TorsoHipLarge"
    
    HIMBOMorphs[89] = "LegsThighUpperSide"
    
    HIMBOMorphs[90] = "TorsoShoulderInc"
    HIMBOMorphs[91] = "TorsoShoulderDec"
    
    HIMBOMorphs[92] = "LegsVastusMReduction"
    
    HIMBOMorphs[93] = "ArmsDeltsShape"
    
    HIMBOMorphs[94] = "PecsMinor"
    HIMBOMorphs[95] = "PecsLower"
    HIMBOMorphs[96] = "BodyMass"
    HIMBOMorphs[97] = "BellyPot"
    HIMBOMorphs[98] = "BellySmooth"
    HIMBOMorphs[99] = "ButtTailbone"
    HIMBOMorphs[100] = "ButtUpper"
    HIMBOMorphs[101] = "BubbleButt"
    
    HIMBOMorphs[102] = "SSBBW butt growth"
    HIMBOMorphs[103] = "SSBBW2 boobs growth"
    
    HIMBOMorphs[104] = "SamuelLike"
    
    HIMBOMorphs[105] = "ButtLower"
    HIMBOMorphs[106] = "FemmeBooba"
    HIMBOMorphs[107] = "FemmeBoobaBig"
    HIMBOMorphs[108] = "BellyButtonPush"
    HIMBOMorphs[109] = "BellyRounder"
    HIMBOMorphs[110] = "BellyUpper"
    HIMBOMorphs[111] = "TorsoBackDefinition"
    HIMBOMorphs[112] = "LegsThighInnerSide"
    HIMBOMorphs[113] = "LegsKneeInner"
    HIMBOMorphs[114] = "LegsKneeOuter"
    HIMBOMorphs[115] = "LegsThighIn"
    HIMBOMorphs[116] = "LegsCalfSideIn"
    HIMBOMorphs[117] = "LegsCalfOut"
    HIMBOMorphs[118] = "ButtTighten"
    HIMBOMorphs[119] = "LegsThighSmoothCurve"
    HIMBOMorphs[120] = "ButtScrapeUpper"
    HIMBOMorphs[121] = "TorsoMassSmooth"
    HIMBOMorphs[122] = "TorsoHipSmooth"

    HIMBOMorphs[123] = "PregnancyBelly"
    HIMBOMorphs[124] = "Belly Button Match"
    HIMBOMorphs[125] = "ChestUV"
    
  String searchTerm = self.StringFromSArgument(sArgument, 1)
  Bool found = false
  Int i = 0

  While i < 128
    If StringUtil.Find(morphs[i], searchTerm) != -1 || QtyPars == 0 || searchTerm == "CBBE"
      PrintMessage(morphs[i])
      found = true
    EndIf
    If StringUtil.Find(morphs2[i], searchTerm) != -1 || QtyPars == 0 || searchTerm == "CBBE"
      PrintMessage(morphs2[i])
      found = true
    Endif
    i += 1
  Endwhile

  if !found
    PrintMessage("No matching CBBE morph names found")
  EndIf
  PrintMessage("===================================")
  PrintMessage("HIMBO MORPH NAMES")
  PrintMessage("===================================")
  While i < 128
    If StringUtil.Find(HIMBOMorphs[i], searchTerm) != -1 || QtyPars == 0 || searchTerm == "HIMBO"
      PrintMessage(HIMBOMorphs[i])
      found = true
    Endif
    i += 1
  Endwhile

  if !found
    PrintMessage("No matching HIMBO morph names found")
  endif
  PrintMessage("===================================")
EndEvent

Event OnConsoleGetBodyMorph(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetBodyMorph(ObjectReference ref, string asMorphName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = GetSelectedReference()
  string asMorphName = self.StringFromSArgument(sArgument, 1)
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  float bodyMorph = NIOverride.GetMorphValue(akRef, asMorphName)
  PrintMessage("Body morph " + asMorphName + " for " + self.GetFullID(akRef) + " is " + bodyMorph)
EndEvent

Event OnConsoleSetBodyMorph(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetBodyMorph(ObjectReference ref, string asMorphName, float afValue)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = GetSelectedReference()
  string asMorphName = self.StringFromSArgument(sArgument, 1)
  float afValue = self.FloatFromSArgument(sArgument, 2)
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  NIOverride.SetMorphValue(akRef, asMorphName, afValue)
  PrintMessage("Set body morph " + asMorphName + " for " + self.GetFullID(akRef) + " to " + afValue)
EndEvent

Event OnConsoleGetWornItemID(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetWornItemID(Actor akActor, int aiSlot)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = GetSelectedReference() as Actor
  int aiSlot = IntFromSArgument(sArgument, 1)
  int SlotMask = Armor.GetMaskForSlot(aiSlot)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int WornItemID = akActor.GetWornItemID(SlotMask)
  PrintMessage("Worn item ID in slot " + aiSlot + " for " + self.GetFullID(akActor) + " is " + WornItemID)
EndEvent

Event OnConsoleGetABGiftFilter(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABGiftFilter [<Actorbase akActorbase>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetBaseObject() as ActorBase
  If QtyPars == 1
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("Gift filter of " + self.GetFullID(akActorBase) + " is " + self.GetFullID(akActorbase.GetGiftFilter()))
EndEvent

Event OnConsoleSendTrespassAlarm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SendTrespassAlarm(Actor akInformant, Actor akTrespasser)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akInformant = ConsoleUtil.GetSelectedReference() as Actor
  Actor akTrespasser = FormFromSArgument(sArgument, 1) as Actor
  If akInformant == none || akTrespasser == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akInformant.SendTrespassAlarm(akTrespasser)
  PrintMessage("Sent trespass alarm for " + self.GetFullID(akTrespasser) + " via " + self.GetFullID(akInformant))
EndEvent

Event OnConsoleClearArrested(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearArrested(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ClearArrested()
  PrintMessage("Cleared arrest for " + self.GetFullID(akActor))
EndEvent

Event OnConsoleClearExpressionOverride(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearExpressionOverride(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ClearExpressionOverride()
  PrintMessage("Cleared expression override for " + self.GetFullID(akActor))
EndEvent

Event OnConsoleClearExtraArrows(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearExtraArrows(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ClearExtraArrows()
  PrintMessage("Cleared extra arrows from " + self.GetFullID(akActor))
EndEvent

Event OnConsoleClearKeepOffsetFromActor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearKeepOffsetFromActor(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ClearKeepOffsetFromActor()
  PrintMessage("Cleared offset from actor for " + self.GetFullID(akActor))
EndEvent

Event OnConsoleClearLookAt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearLookAt(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ClearLookAt()
  PrintMessage("Cleared look-at settings for " + self.GetFullID(akActor))
EndEvent

Event OnConsoleOpenInventory(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: OpenInventory(Actor akActor, bool abForceOpen = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  bool abForceOpen = BoolFromSArgument(sArgument, 1, false)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.OpenInventory(abForceOpen)
  PrintMessage("Opening inventory for " + self.GetFullID(akActor) + IfElse(abForceOpen, " with force.", ""))
EndEvent

Event OnConsoleForceMovementSpeed(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ForceMovementSpeed(Actor akActor, float afSpeedMult)")
  PrintMessage("afSpeedMult is a speed multiplier based on the current max speeds")
  PrintMessage("- 0 -> 1 Scales between 0 and the Walk speed")
  PrintMessage("- 1 -> 2 Scales between Walk speed and Run Speed")
  PrintMessage("- 2 and above is a multiplier of the run speed (less 1.0 since Run is 2.0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  float afSpeedMult = FloatFromSArgument(sArgument, 1)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ForceMovementSpeed(afSpeedMult)
  PrintMessage("Forcing movement speed of " + self.GetFullID(akActor) + " to " + afSpeedMult)
EndEvent

Event OnConsoleForceMovementRotationSpeed(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ForceMovementRotationSpeed(float afXMult = 0.0, float afYMult = 0.0, float afZMult = 0.0)")
  PrintMessage("afSpeedMult is a speed multiplier based on the current max speeds")
  PrintMessage("- 0 -> 1 Scales between 0 and the Walk speed")
  PrintMessage("- 1 -> 2 Scales between Walk speed and Run Speed")
  PrintMessage("- 2 and above is a multiplier of the run speed (less 1.0 since Run is 2.0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  float afXMult = FloatFromSArgument(sArgument, 1, 0.0)
  float afYMult = FloatFromSArgument(sArgument, 2, 0.0)
  float afZMult = FloatFromSArgument(sArgument, 3, 0.0)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ForceMovementRotationSpeed(afXMult, afYMult, afZMult)
  PrintMessage("Forcing movement rotation speed of " + self.GetFullID(akActor) + " to:")
  PrintMessage("-  X: " + afXMult)
  PrintMessage("-  Y: " + afYMult)
  PrintMessage("-  Z: " + afZMult)
EndEvent

Event OnConsoleForceMovementSpeedRamp(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ForceMovementSpeedRamp(Actor akActor, float afSpeedMult, float afRampTime = 0.1)")
  PrintMessage("afSpeedMult is a speed multiplier based on the current max speeds")
  PrintMessage("- 0 -> 1 Scales between 0 and the Walk speed")
  PrintMessage("- 1 -> 2 Scales between Walk speed and Run Speed")
  PrintMessage("- 2 and above is a multiplier of the run speed (less 1.0 since Run is 2.0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  float afSpeedMult = FloatFromSArgument(sArgument, 1)
  float afRampTime = FloatFromSArgument(sArgument, 2, 0.1)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ForceMovementSpeedRamp(afSpeedMult, afRampTime)
  PrintMessage("Forcing movement speed of " + self.GetFullID(akActor) + " to " + afSpeedMult + " ramping over " + afRampTime + " seconds")
EndEvent

Event OnConsoleScaleObject3D(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ScaleObject3D([ObjectReference akRef = GetSelectedReference(), String asNodeName, float afScale)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()
  String asNodeName = StringFromSArgument(sArgument, 1)
  float afScale = FloatFromSArgument(sArgument, 2, 1)
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.ScaleObject3D(akRef, asNodeName, afScale)
  PrintMessage("Setting scale of  " + self.GetFullID(akRef) + "'s " + asNodeName + " node to " + afScale)
EndEvent

Event OnConsoleGetActorbaseDeadCount(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABDeadCount [<Actorbase akActorbase>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetBaseObject() as ActorBase
  If QtyPars == 1
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  PrintMessage("Dead count  of " + self.GetFullID(akActorBase) + " is " + akActorbase.GetDeadCount())
EndEvent

Event OnConsoleGetActorbaseSex(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetABSex [<Actorbase akActorbase>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetBaseObject() as ActorBase
  If QtyPars == 1
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int sex = akActorbase.GetSex()
  string sexString
  If sex == -1
    sexString = "None"
  ElseIf sex == 0
    sexString = "Male"
  ElseIf sex == 1
    sexString = "Female"
  EndIf
  
  PrintMessage("Sex of " + self.GetFullID(akActorBase) + " is " + sexString + Paren(sex))
EndEvent

Event OnConsoleSetActorbaseInvulnerable(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetABInvulnerable [<Actorbase akActorbase>] [bool abInvulnerable = true]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase
  bool abInvulnerable
  If QtyPars == 1
    akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetBaseObject() as ActorBase
  ElseIf QtyPars == 2
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
    abInvulnerable = BoolFromSArgument(sArgument, 2, true)
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActorbase.SetInvulnerable(abInvulnerable)
  If abInvulnerable
    PrintMessage(GetFullID(akActorbase) + " is invulnerable")
  Else
    PrintMessage(GetFullID(akActorbase) + " is not invulnerable")
  EndIf
EndEvent

Event OnConsoleGetKeyword(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetKeyword [<String asKey>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  String asKey = StringFromSArgument(sArgument, 1)
  Keyword result = Keyword.GetKeyword(asKey) 
  If result == none
    PrintMessage("No keyword found with string " + asKey)
    Return
  EndIf
  PrintMessage("Keyword: " + self.GetFullID(result))
EndEvent

Event OnConsoleGetActorbaseVoiceType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorbaseVoiceType([Actorbase akActorbase = GetSelectedReference().GetActorBase()])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  VoiceType akVoiceType =  akActorbase.GetVoiceType()
  PrintMessage("voice type of " + self.GetFullID(akActorbase) + " is " + self.GetFullID(akVoiceType))
EndEvent

Event OnConsoleSetActorbaseVoiceType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorbaseVoiceType([Actor akActor = GetSelectedReference()], VoiceType akNewTXST)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  VoiceType akNewTXST = self.FormFromSArgument(sArgument, 1) as VoiceType
  If akActorbase == none || akNewTXST == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("voice type of " + self.GetFullID(akActorbase) + " is " + self.GetFullID(akActorbase.GetVoiceType()))
  akActorbase.SetVoiceType(akNewTXST)
  If akNewTXST == akActorbase.GetVoiceType()
    PrintMessage("Successfully set voice type of " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akNewTXST))
  Else
    PrintMessage("Failed to set voice type of " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akNewTXST))
    PrintMessage("voice type of " + self.GetFullID(akActorbase) + " is still " + self.GetFullID(akActorbase.GetVoiceType()))
  EndIf
EndEvent

Event OnConsoleGetActorbaseCombatStyle(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorbaseCombatStyle([Actorbase akActorbase = GetSelectedReference().GetActorBase()])")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  CombatStyle akCombatStyle =  akActorbase.GetCombatStyle()
  PrintMessage("combat style of " + self.GetFullID(akActorbase) + " is " + self.GetFullID(akCombatStyle))
EndEvent

Event OnConsoleSetActorbaseCombatStyle(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorbaseCombatStyle([Actor akActor = GetSelectedReference()], CombatStyle akNewTXST)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  CombatStyle akNewTXST = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akActorbase == none || akNewTXST == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PrintMessage("combat style of " + self.GetFullID(akActorbase) + " is " + self.GetFullID(akActorbase.GetCombatStyle()))
  akActorbase.SetCombatStyle(akNewTXST)
  If akNewTXST == akActorbase.GetCombatStyle()
    PrintMessage("Successfully set combat style of " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akNewTXST))
  Else
    PrintMessage("Failed to set combat style of " + self.GetFullID(akActorbase) + " to " + self.GetFullID(akNewTXST))
    PrintMessage("combat style of " + self.GetFullID(akActorbase) + " is still " + self.GetFullID(akActorbase.GetCombatStyle()))
  EndIf
EndEvent

Event OnConsoleGetActorbaseWeight(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorbaseWeight [<Actorbase>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase
  float Weight
  If QtyPars == 0
    akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
  ElseIf QtyPars == 1
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  Weight = akActorbase.GetWeight() ; 1 is first argument, which is second term in sArgument
  PrintMessage("Weight of " + self.GetFullID(akActorbase) + " is " + Weight as String)
EndEvent

Event OnConsoleSetActorbaseWeight(String EventName, String sArgument, float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorbaseWeight [<Actorbase>] <float Weight>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actorbase akActorbase
  float Weight
  If QtyPars == 1
    akActorbase = (ConsoleUtil.GetSelectedReference() as Actor).GetActorBase()
    Weight = self.FloatFromSArgument(sArgument, 1) as float
  ElseIf QtyPars == 2
    akActorbase = self.FormFromSArgument(sArgument, 1) as Actorbase
    Weight = self.FloatFromSArgument(sArgument, 2) as float
  EndIf
  If akActorbase == none
    PrintMessage("FATAL ERROR: FormID retrieval error")
    Return
  EndIf
  akActorbase.SetWeight(Weight) ; 1 is first argument, which is second term in sArgument
  PrintMessage("Weight of " + self.GetFullID(akActorbase) + " set to " + Weight as String)
EndEvent

Event OnConsoleGetActorDialogueTarget(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorDialogueTarget(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  ObjectReference Ref = akActor.GetDialogueTarget()
  If akActor == none
    PrintMessage("No dialogue target found")
    Return
  EndIf
  PrintMessage(self.GetFullID(akActor) + " is currently in dialogue with " + self.GetFullID(Ref))
EndEvent

Event OnConsoleSetCameraTarget(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetCameraTarget(Actor akTarget)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akTarget = ConsoleUtil.GetSelectedReference() as Actor
  If akTarget == none
    PrintMessage("No dialogue target found")
    Return
  EndIf
  Game.SetCameraTarget(akTarget)
  PrintMessage(self.GetFullID(akTarget) + " set as camera target")
EndEvent

Event OnConsoleGetActorFactions(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorFactions [<Actor akActor>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  If QtyPars == 0
    akActor = ConsoleUtil.GetSelectedReference() as Actor
  ElseIf QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  
  Faction[] result = akActor.GetFactions(-128, 127)
  int i = 0
  int L = result.Length
  If L > 0
    PrintMessage("Found " + L + " factions")
  Else
    PrintMessage("No faction found")
    Return
  EndIf
  While i < L
    PrintMessage("Faction #" + i + ": " + self.GetFullID(result[i]))
    PrintMessage("  - Rank: " + akActor.GetFactionRank(result[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleGetFactionInformation(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFactionInformation [<Faction akFaction>] <bool abStats = true> <bool abReactions = true>")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Faction akFaction = self.FormFromSArgument(sArgument, 1) as Faction
  bool abStats = self.BoolFromSArgument(sArgument, 2, true)
  bool abReactions = self.BoolFromSArgument(sArgument, 3, true)
    ; Player
    ; Faction PlayerFaction = PO3_SKSEFunctions.GetFormFromEditorID("PlayerFaction") as Faction
    ; Faction PlayerWerewolfFaction = PO3_SKSEFunctions.GetFormFromEditorID("PlayerWerewolfFaction") as Faction
    ; Faction PlayerVampireFaction = PO3_SKSEFunctions.GetFormFromEditorID("VampirePCFaction") as Faction
    ; Faction PlayerVampireLordFaction = PO3_SKSEFunctions.GetFormFromEditorID("DLC1PlayerVampireLordFaction") as Faction

    ; ; Guards
    ; Faction IsGuardFaction = PO3_SKSEFunctions.GetFormFromEditorID("IsGuardFaction") as Faction
    ; Faction DawnguardFaction = PO3_SKSEFunctions.GetFormFromEditorID("DLC1DawnguardFaction") as Faction
    ; Faction VigilantOfStendarrFaction = PO3_SKSEFunctions.GetFormFromEditorID("VigilantOfStendarrFaction") as Faction
    ; Faction SilverHandFaction = PO3_SKSEFunctions.GetFormFromEditorID("SilverHandFaction") as Faction

    ; ; Others
    ; Faction DarkBrotherhoodFaction = PO3_SKSEFunctions.GetFormFromEditorID("DarkBrotherhoodFaction") as Faction
    ; Faction CollegeofWinterholdFaction = PO3_SKSEFunctions.GetFormFromEditorID("CollegeofWinterholdFaction") as Faction
    ; Faction DragonFaction = PO3_SKSEFunctions.GetFormFromEditorID("DragonFaction") as Faction  
    ; Faction FalmerFaction = PO3_SKSEFunctions.GetFormFromEditorID("FalmerFaction") as Faction
    ; Faction PrisonerFaction = PO3_SKSEFunctions.GetFormFromEditorID("dunPrisonerFaction") as Faction
    ; Faction DraugrFaction = PO3_SKSEFunctions.GetFormFromEditorID("DraugrFaction") as Faction
    ; Faction DragonPriestFaction = PO3_SKSEFunctions.GetFormFromEditorID("DragonPriestFaction") as Faction
    ; Faction ForswornFaction = PO3_SKSEFunctions.GetFormFromEditorID("ForswornFaction") as Faction
    ; Faction HagravenFaction = PO3_SKSEFunctions.GetFormFromEditorID("HagravenFaction") as Faction
    ; Faction GiantFaction = PO3_SKSEFunctions.GetFormFromEditorID("GiantFaction") as Faction
    ; Faction NecromancerFaction = PO3_SKSEFunctions.GetFormFromEditorID("NecromancerFaction") as Faction
    ; Faction OrcFriendFaction = PO3_SKSEFunctions.GetFormFromEditorID("OrcFriendFaction") as Faction
    ; Faction WerewolfFaction = PO3_SKSEFunctions.GetFormFromEditorID("WerewolfFaction") as Faction
    ; Faction BanditFaction = PO3_SKSEFunctions.GetFormFromEditorID("BanditFaction") as Faction
    ; Faction VolkiharFaction = PO3_SKSEFunctions.GetFormFromEditorID("DLC1VampireFaction") as Faction
    ; Faction CompanionsFaction = PO3_SKSEFunctions.GetFormFromEditorID("CompanionsFaction") as Faction
    ; Faction VampireFaction = PO3_SKSEFunctions.GetFormFromEditorID("VampireFaction") as Faction
    ; Faction SkeletonFaction = PO3_SKSEFunctions.GetFormFromEditorID("SkeletonFaction") as Faction
    ; Faction ThievesGuildFaction = PO3_SKSEFunctions.GetFormFromEditorID("ThievesGuildFaction") as Faction
    ; Faction BladesFaction = PO3_SKSEFunctions.GetFormFromEditorID("BladesFaction") as Faction
    ; Faction EastEmpireFaction = PO3_SKSEFunctions.GetFormFromEditorID("TG04EastEmpireFaction") as Faction
    ; Faction CreatureFaction = PO3_SKSEFunctions.GetFormFromEditorID("CreatureFaction") as Faction
    ; Faction WarlockFaction = PO3_SKSEFunctions.GetFormFromEditorID("WarlockFaction") as Faction
    ; Faction DaedraFaction = PO3_SKSEFunctions.GetFormFromEditorID("DaedraFaction") as Faction

    ; ; Stormcloaks
    ; Faction StormcloakFaction = PO3_SKSEFunctions.GetFormFromEditorID("CWSonsFaction") as Faction
    ; Faction StormcloakAllyFaction = PO3_SKSEFunctions.GetFormFromEditorID("CWSonsAlly") as Faction
    ; Faction StormcloakGovFaction = PO3_SKSEFunctions.GetFormFromEditorID("GovSons") as Faction
    ; Faction StormcloakNPCFaction = PO3_SKSEFunctions.GetFormFromEditorID("CWSonsFactionNPC") as Faction

    ; ; Imperials
    ; Faction ImperialFaction = PO3_SKSEFunctions.GetFormFromEditorID("CWImperialFactionNPC") as Faction
    ; Faction ImperialJusticiarFaction = PO3_SKSEFunctions.GetFormFromEditorID("ImperialJusticiarFaction") as Faction
    ; Faction PenintusOculatusFaction = PO3_SKSEFunctions.GetFormFromEditorID("PenitusOculatusFaction") as Faction
    ; Faction ImperialGovFaction = PO3_SKSEFunctions.GetFormFromEditorID("GovImperial") as Faction

    ; ; Thalmor
    ; Faction ThalmorFaction = PO3_SKSEFunctions.GetFormFromEditorID("ThalmorFaction") as Faction

    ; ; Crime factions
    ; Faction CrimeFactionPale = PO3_SKSEFunctions.GetFormFromEditorID("CrimeFactionPale") as Faction
    ; Faction CrimeFactionReach = PO3_SKSEFunctions.GetFormFromEditorID("CrimeFactionReach") as Faction
    ; Faction CrimeFactionRift = PO3_SKSEFunctions.GetFormFromEditorID("CrimeFactionRift") as Faction
    ; Faction CrimeFactionThievesGuild = PO3_SKSEFunctions.GetFormFromEditorID("CrimeFactionThievesGuild") as Faction
    ; Faction CrimeFactionOrcs = PO3_SKSEFunctions.GetFormFromEditorID("CrimeFactionOrcs") as Faction
    ; Faction CrimeFactionRavenRock = PO3_SKSEFunctions.GetFormFromEditorID("DLC2CrimeRavenRockFaction") as Faction
    ; Faction CrimeFactionSons = PO3_SKSEFunctions.GetFormFromEditorID("CrimeFactionSons") as Faction
    ; Faction CrimeFactionImperial = PO3_SKSEFunctions.GetFormFromEditorID("CrimeFactionImperial") as Faction
    ; Faction CrimeFactionGreybeard = PO3_SKSEFunctions.GetFormFromEditorID("CrimeFactionGreybeard") as Faction
    ; Faction CrimeFactionCidhnaMine = PO3_SKSEFunctions.GetFormFromEditorID("CrimeFactionCidhnaMine") as Faction
    ; Faction CrimeFactionEastmarch = PO3_SKSEFunctions.GetFormFromEditorID("CrimeFactionEastmarch") as Faction
    ; Faction CrimeFactionHaafingar = PO3_SKSEFunctions.GetFormFromEditorID("CrimeFactionHaafingar") as Faction

  PrintMessage("FACTION")
  
  PrintMessage(self.GetFullID(akFaction))

  PrintMessage("FACTION STATS")
  PrintMessage("  MEMBERSHIP")
  PrintMessage("    - Rank: " + PlayerRef.GetFactionRank(akFaction))
  PrintMessage("    - Expelled: " + IfElse(akFaction.IsPlayerExpelled(), "true", "false"))
  PrintMessage("  CRIME GOLD")
  PrintMessage("    - Crime gold: " + akFaction.GetCrimeGold())
  PrintMessage("        - Non-violent: " + akFaction.GetCrimeGoldNonViolent())
  PrintMessage("        - Violent: " + akFaction.GetCrimeGoldViolent())
  PrintMessage("    - Accumulated crime gold: " + akFaction.GetInfamy())
  PrintMessage("        - Non-violent: " + akFaction.GetInfamyNonViolent())
  PrintMessage("        - Violent: " + akFaction.GetInfamyViolent())
  PrintMessage("    - Witnessed stolen item value: " + akFaction.GetStolenItemValueCrime())
  PrintMessage("    - Unwitnessed stolen item value: " + akFaction.GetStolenItemValueNoCrime())
  PrintMessage("  MISC")
  PrintMessage("    - Is vendor: " + IfElse(akFaction.IsVendor(), "true", "false"))
  PrintMessage("    - Faction flags")
  PrintMessage("        - Hidden from NPC: " + akFaction.IsFactionFlagSet(0x00000001))
  PrintMessage("        - Special combat: " + akFaction.IsFactionFlagSet(0x00000002))
  PrintMessage("        - Tracks crime: " + akFaction.IsFactionFlagSet(0x00000010))
  PrintMessage("        - Ignores murder: " + akFaction.IsFactionFlagSet(0x00000020))
  PrintMessage("        - Ignores assault: " + akFaction.IsFactionFlagSet(0x00000040))
  PrintMessage("        - Ignores stealing: " + akFaction.IsFactionFlagSet(0x00000080))
  PrintMessage("        - Ignores trespass: " + akFaction.IsFactionFlagSet(0x00000100))
  PrintMessage("        - Ignores pickpocketing: " + akFaction.IsFactionFlagSet(0x00000800))
  PrintMessage("        - Ignores werewolfs: " + akFaction.IsFactionFlagSet(0x00004000))
  PrintMessage("        - Doesn't report crime: " + akFaction.IsFactionFlagSet(0x00000200))
  PrintMessage("        - Can be owner: " + akFaction.IsFactionFlagSet(0x00002000))
  PrintMessage("    - Vendor info")
  PrintMessage("        - Only buys stolen items: " + akFaction.OnlyBuysStolenItems())
  PrintMessage("        - Opening hour: " + akFaction.GetVendorStartHour())
  PrintMessage("        - Closing hour: " + akFaction.GetVendorEndHour())
  PrintMessage("        - Radius: " + akFaction.GetVendorRadius())
  PrintMessage("        - Container: " + GetFullID(akFaction.GetMerchantContainer()))
  PrintMessage("        - " + IfElse(akFaction.IsNotSellBuy(), "Buys all except: ", "Buys: ") + GetFullID(akFaction.GetBuySellList()))
  PrintMessage("")
  PrintMessage("")
  PrintMessage("FACTION REACTIONS")
  PrintMessage("  PLAYER FACTIONS")
  PrintMessage("    - Player: " + akFaction.GetReaction(PlayerFaction))
  PrintMessage("    - Werewolf: " + akFaction.GetReaction(PlayerWerewolfFaction))
  PrintMessage("    - Vampire: " + akFaction.GetReaction(PlayerVampireFaction))
  PrintMessage("    - Vampire Lord: " + akFaction.GetReaction(PlayerVampireLordFaction))
  PrintMessage("    - Follower: " + akFaction.GetReaction(CurrentFollowerFaction))
  PrintMessage("  ")  
  PrintMessage("  CRIME FACTIONS")
  PrintMessage("    - All Guards: " + akFaction.GetReaction(IsGuardFaction))
  PrintMessage("    - Pale: " + akFaction.GetReaction(CrimeFactionPale))
  PrintMessage("    - Reach: " + akFaction.GetReaction(CrimeFactionReach))
  PrintMessage("    - Rift: " + akFaction.GetReaction(CrimeFactionRift))
  PrintMessage("    - Thieves Guild: " + akFaction.GetReaction(CrimeFactionThievesGuild))
  PrintMessage("    - Orcs: " + akFaction.GetReaction(CrimeFactionOrcs))
  PrintMessage("    - Raven Rock: " + akFaction.GetReaction(CrimeFactionRavenRock))
  PrintMessage("    - Pale: " + akFaction.GetReaction(CrimeFactionPale))
  PrintMessage("    - Sons: " + akFaction.GetReaction(CrimeFactionSons))
  PrintMessage("    - Imperial: " + akFaction.GetReaction(CrimeFactionImperial))
  PrintMessage("    - Greybeard: " + akFaction.GetReaction(CrimeFactionGreybeard))
  PrintMessage("    - Cidhna Mine: " + akFaction.GetReaction(CrimeFactionCidhnaMine))
  PrintMessage("    - Eastmarch: " + akFaction.GetReaction(CrimeFactionEastmarch))
  PrintMessage("    - Haafingar: " + akFaction.GetReaction(CrimeFactionHaafingar))
  PrintMessage("  ")  
  PrintMessage("  INSTITUTIONAL FACTIONS")
  PrintMessage("    - Dark Brotherhood: " + akFaction.GetReaction(DarkBrotherhoodFaction))
  PrintMessage("    - College of Winterhold: " + akFaction.GetReaction(CollegeofWinterholdFaction))
  PrintMessage("    - Volkihar Vampires: " + akFaction.GetReaction(VolkiharFaction))
  PrintMessage("    - Companions: " + akFaction.GetReaction(CompanionsFaction))
  PrintMessage("    - Imperials: " + akFaction.GetReaction(ImperialFaction))
  PrintMessage("    - Thalmor: " + akFaction.GetReaction(ThalmorFaction))
  PrintMessage("    - Dawnguard: " + akFaction.GetReaction(DawnguardFaction))
  PrintMessage("    - Blades: " + akFaction.GetReaction(BladesFaction))
  PrintMessage("    - Stormcloak: " + akFaction.GetReaction(StormcloakFaction))
  PrintMessage("    - Orcs: " + akFaction.GetReaction(OrcFriendFaction))
  PrintMessage("    - Silver Hand: " + akFaction.GetReaction(SilverHandFaction))
  PrintMessage("    - Vigilants of Stendarr: " + akFaction.GetReaction(VigilantOfStendarrFaction))
  PrintMessage("    - East Empire: " + akFaction.GetReaction(EastEmpireFaction))
  PrintMessage("  ")  
  PrintMessage("  BANDIT/MONSTER FACTIONS")
  PrintMessage("    - Dragons: " + akFaction.GetReaction(DragonFaction))
  PrintMessage("    - Falmer: " + akFaction.GetReaction(FalmerFaction))
  PrintMessage("    - Draugr: " + akFaction.GetReaction(DraugrFaction))
  PrintMessage("    - Dragon Priest: " + akFaction.GetReaction(DragonPriestFaction))
  PrintMessage("    - Forsworn: " + akFaction.GetReaction(ForswornFaction))
  PrintMessage("    - Hagraven: " + akFaction.GetReaction(HagravenFaction))
  PrintMessage("    - Giants: " + akFaction.GetReaction(GiantFaction))
  PrintMessage("    - Bandits: " + akFaction.GetReaction(BanditFaction))
  PrintMessage("    - Necromancer: " + akFaction.GetReaction(NecromancerFaction))
  PrintMessage("    - Werewolves: " + akFaction.GetReaction(WerewolfFaction))
  PrintMessage("    - Vampires: " + akFaction.GetReaction(VampireFaction))
  PrintMessage("    - Skeletons: " + akFaction.GetReaction(SkeletonFaction))
  PrintMessage("    - Giants: " + akFaction.GetReaction(GiantFaction))
  PrintMessage("    - Warlocks: " + akFaction.GetReaction(WarlockFaction))
  PrintMessage("    - Daedra: " + akFaction.GetReaction(DaedraFaction))
EndEvent

Event OnConsoleGetMagicEffectAssociatedForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectForm(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  Form result = PO3_SKSEFunctions.GetAssociatedForm(akMagicEffect)
  
  PrintMessage("Form of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(result))
    
EndEvent

Event OnConsoleSetMagicEffectForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicEffectForm(MagicEffect akMagicEffect, Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect
  Form akForm = self.FormFromSArgument(sArgument, 2) as Form

  If akMagicEffect == none || akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  Form oldForm = PO3_SKSEFunctions.GetAssociatedForm(akMagicEffect)

  PrintMessage("Form of " + self.GetFullID(akMagicEffect) + " is " + self.GetFullID(oldForm))
  PrintMessage("Attempting to set form of " + self.GetFullID(akMagicEffect) + " to " + self.GetFullID(akForm))
  
  PO3_SKSEFunctions.SetAssociatedForm(akMagicEffect, akForm)

  Form newForm = PO3_SKSEFunctions.GetAssociatedForm(akMagicEffect)
  
  PrintMessage("Form of " + self.GetFullID(akMagicEffect) + " is now " + self.GetFullID(newForm))
    
EndEvent

Event OnConsoleGetHazardArt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHazardArt(Hazard akHazard)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  String result = PO3_SKSEFunctions.GetHazardArt(akHazard)
  PrintMessage("GetHazardArt: " + result)
EndEvent

Event OnConsoleGetHazardIMOD(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHazardIMOD(Hazard akHazard)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  ImageSpaceModifier result = PO3_SKSEFunctions.GetHazardIMOD(akHazard)
  PrintMessage("GetHazardIMOD: " + result)
EndEvent

Event OnConsoleGetHazardIMODRadius(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHazardIMODRadius(Hazard akHazard)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  float result = PO3_SKSEFunctions.GetHazardIMODRadius(akHazard)
  PrintMessage("GetHazardIMODRadius: " + result)
EndEvent

Event OnConsoleGetHazardIPDS(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHazardIPDS(Hazard akHazard)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  ImpactDataSet result = PO3_SKSEFunctions.GetHazardIPDS(akHazard)
  PrintMessage("GetHazardIPDS: " + result)
EndEvent

Event OnConsoleGetHazardLifetime(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHazardLifetime(Hazard akHazard)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  float result = PO3_SKSEFunctions.GetHazardLifetime(akHazard)
  PrintMessage("GetHazardLifetime: " + result)
EndEvent

Event OnConsoleGetHazardLight(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHazardLight(Hazard akHazard)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  Light result = PO3_SKSEFunctions.GetHazardLight(akHazard)
  PrintMessage("GetHazardLight: " + result)
EndEvent

Event OnConsoleGetHazardLimit(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHazardLimit(Hazard akHazard)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  int result = PO3_SKSEFunctions.GetHazardLimit(akHazard)
  PrintMessage("GetHazardLimit: " + result)
EndEvent

Event OnConsoleGetHazardRadius(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHazardRadius(Hazard akHazard)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  float result = PO3_SKSEFunctions.GetHazardRadius(akHazard)
  PrintMessage("GetHazardRadius: " + result)
EndEvent

Event OnConsoleGetHazardSound(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHazardSound(Hazard akHazard)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  SoundDescriptor result = PO3_SKSEFunctions.GetHazardSound(akHazard)
  PrintMessage("GetHazardSound: " + result)
EndEvent

Event OnConsoleGetHazardSpell(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHazardSpell(Hazard akHazard)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  Spell result = PO3_SKSEFunctions.GetHazardSpell(akHazard)
  PrintMessage("GetHazardSpell: " + result)
EndEvent

Event OnConsoleGetHazardTargetInterval(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetHazardTargetInterval(Hazard akHazard)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  float result = PO3_SKSEFunctions.GetHazardTargetInterval(akHazard)
  PrintMessage("GetHazardTargetInterval: " + result)
EndEvent

Event OnConsoleIsHazardFlagSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: IsHazardFlagSet(Hazard akHazard, int aiFlag)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  int aiFlag = self.IntFromSArgument(sArgument, 2)

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  bool result = PO3_SKSEFunctions.IsHazardFlagSet(akHazard, aiFlag)
  PrintMessage("IsHazardFlagSet: " + result)
EndEvent

Event OnConsoleClearHazardFlag(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ClearHazardFlag(Hazard akHazard, int aiFlag)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  int aiFlag = self.IntFromSArgument(sArgument, 2)

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.ClearHazardFlag(akHazard, aiFlag)
  PrintMessage("ClearHazardFlag applied to " + akHazard)
EndEvent

Event OnConsoleSetHazardArt(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHazardArt(Hazard akHazard, String asPath)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  String asPath = self.StringFromSArgument(sArgument, 2)

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHazardArt(akHazard, asPath)
  PrintMessage("SetHazardArt applied to " + akHazard)
EndEvent

Event OnConsoleSetHazardFlag(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHazardFlag(Hazard akHazard, int aiFlag)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  int aiFlag = self.IntFromSArgument(sArgument, 2)

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHazardFlag(akHazard, aiFlag)
  PrintMessage("SetHazardFlag applied to " + akHazard)
EndEvent

Event OnConsoleSetHazardIMOD(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHazardIMOD(Hazard akHazard, ImageSpaceModifier akIMOD)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  ImageSpaceModifier akIMOD = self.FormFromSArgument(sArgument, 2) as ImageSpaceModifier

  If akHazard == none || akIMOD == none
    PrintMessage("FATAL ERROR: Hazard or IMOD retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHazardIMOD(akHazard, akIMOD)
  PrintMessage("SetHazardIMOD applied to " + akHazard)
EndEvent

Event OnConsoleSetHazardIMODRadius(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHazardIMODRadius(Hazard akHazard, float afRadius)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  float afRadius = self.FloatFromSArgument(sArgument, 2)

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHazardIMODRadius(akHazard, afRadius)
  PrintMessage("SetHazardIMODRadius applied to " + akHazard)
EndEvent

Event OnConsoleSetHazardIPDS(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHazardIPDS(Hazard akHazard, ImpactDataSet akIPDS)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  ImpactDataSet akIPDS = self.FormFromSArgument(sArgument, 2) as ImpactDataSet

  If akHazard == none || akIPDS == none
    PrintMessage("FATAL ERROR: Hazard or IPDS retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHazardIPDS(akHazard, akIPDS)
  PrintMessage("SetHazardIPDS applied to " + akHazard)
EndEvent

Event OnConsoleSetHazardLifetime(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHazardLifetime(Hazard akHazard, float afLifetime)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  float afLifetime = self.FloatFromSArgument(sArgument, 2)

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHazardLifetime(akHazard, afLifetime)
  PrintMessage("SetHazardLifetime applied to " + akHazard)
EndEvent

Event OnConsoleSetHazardLight(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHazardLight(Hazard akHazard, Light akLight)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  Light akLight = self.FormFromSArgument(sArgument, 2) as Light

  If akHazard == none || akLight == none
    PrintMessage("FATAL ERROR: Hazard or Light retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHazardLight(akHazard, akLight)
  PrintMessage("SetHazardLight applied to " + akHazard)
EndEvent

Event OnConsoleSetHazardLimit(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHazardLimit(Hazard akHazard, int aiLimit)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  int aiLimit = self.IntFromSArgument(sArgument, 2)

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHazardLimit(akHazard, aiLimit)
  PrintMessage("SetHazardLimit applied to " + akHazard)
EndEvent

Event OnConsoleSetHazardRadius(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHazardRadius(Hazard akHazard, float afRadius)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  float afRadius = self.FloatFromSArgument(sArgument, 2)

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHazardRadius(akHazard, afRadius)
  PrintMessage("SetHazardRadius applied to " + akHazard)
EndEvent

Event OnConsoleSetHazardSound(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHazardSound(Hazard akHazard, SoundDescriptor akSound)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  SoundDescriptor akSound = self.FormFromSArgument(sArgument, 2) as SoundDescriptor

  If akHazard == none || akSound == none
    PrintMessage("FATAL ERROR: Hazard or Sound retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHazardSound(akHazard, akSound)
  PrintMessage("SetHazardSound applied to " + akHazard)
EndEvent

Event OnConsoleSetHazardSpell(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHazardSpell(Hazard akHazard, Spell akSpell)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  Spell akSpell = self.FormFromSArgument(sArgument, 2) as Spell

  If akHazard == none || akSpell == none
    PrintMessage("FATAL ERROR: Hazard or Spell retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHazardSpell(akHazard, akSpell)
  PrintMessage("SetHazardSpell applied to " + akHazard)
EndEvent

Event OnConsoleSetHazardTargetInterval(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetHazardTargetInterval(Hazard akHazard, float afInterval)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Hazard akHazard = self.FormFromSArgument(sArgument, 1) as Hazard
  float afInterval = self.FloatFromSArgument(sArgument, 2)

  If akHazard == none
    PrintMessage("FATAL ERROR: Hazard retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetHazardTargetInterval(akHazard, afInterval)
  PrintMessage("SetHazardTargetInterval applied to " + akHazard)
EndEvent

Event OnConsoleGetLightColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLightColor(Light akLight)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Light akLight = self.FormFromSArgument(sArgument, 1) as Light

  If akLight == none
    PrintMessage("FATAL ERROR: Light retrieval failed")
    Return
  EndIf

  ColorForm result = PO3_SKSEFunctions.GetLightColor(akLight)
  PrintMessage("GetLightColor: " + result)
EndEvent

Event OnConsoleGetLightFade(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLightFade(Light akLight)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Light akLight = self.FormFromSArgument(sArgument, 1) as Light

  If akLight == none
    PrintMessage("FATAL ERROR: Light retrieval failed")
    Return
  EndIf

  float result = PO3_SKSEFunctions.GetLightFade(akLight)
  PrintMessage("GetLightFade: " + result)
EndEvent

Event OnConsoleGetLightFOV(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLightFOV(Light akLight)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Light akLight = self.FormFromSArgument(sArgument, 1) as Light

  If akLight == none
    PrintMessage("FATAL ERROR: Light retrieval failed")
    Return
  EndIf

  float result = PO3_SKSEFunctions.GetLightFOV(akLight)
  PrintMessage("GetLightFOV: " + result)
EndEvent

Event OnConsoleGetLightRadius(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLightRadius(Light akLight)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Light akLight = self.FormFromSArgument(sArgument, 1) as Light

  If akLight == none
    PrintMessage("FATAL ERROR: Light retrieval failed")
    Return
  EndIf

  float result = PO3_SKSEFunctions.GetLightRadius(akLight)
  PrintMessage("GetLightRadius: " + result)
EndEvent

Event OnConsoleGetLightRGB(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLightRGB(Light akLight)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Light akLight = self.FormFromSArgument(sArgument, 1) as Light

  If akLight == none
    PrintMessage("FATAL ERROR: Light retrieval failed")
    Return
  EndIf

  int[] result = PO3_SKSEFunctions.GetLightRGB(akLight)
  PrintMessage("GetLightRGB: " + result)
EndEvent

Event OnConsoleGetLightShadowDepthBias(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLightShadowDepthBias(ObjectReference akLightObject)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akLightObject = self.FormFromSArgument(sArgument, 1) as ObjectReference

  If akLightObject == none
    PrintMessage("FATAL ERROR: Light Object retrieval failed")
    Return
  EndIf

  float result = PO3_SKSEFunctions.GetLightShadowDepthBias(akLightObject)
  PrintMessage("GetLightShadowDepthBias: " + result)
EndEvent

Event OnConsoleGetLightType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLightType(Light akLight)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Light akLight = self.FormFromSArgument(sArgument, 1) as Light

  If akLight == none
    PrintMessage("FATAL ERROR: Light retrieval failed")
    Return
  EndIf

  int result = PO3_SKSEFunctions.GetLightType(akLight)
  PrintMessage("GetLightType: " + result)
EndEvent

Event OnConsoleSetLightColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLightColor(Light akLight, ColorForm akColorform)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Light akLight = self.FormFromSArgument(sArgument, 1) as Light
  ColorForm akColorform = self.FormFromSArgument(sArgument, 2) as ColorForm

  If akLight == none || akColorform == none
    PrintMessage("FATAL ERROR: Light or Colorform retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetLightColor(akLight, akColorform)
  PrintMessage("SetLightColor applied to " + akLight)
EndEvent

Event OnConsoleSetLightFade(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLightFade(Light akLight, float afRange)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Light akLight = self.FormFromSArgument(sArgument, 1) as Light
  float afRange = self.FloatFromSArgument(sArgument, 2)

  If akLight == none
    PrintMessage("FATAL ERROR: Light retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetLightFade(akLight, afRange)
  PrintMessage("SetLightFade applied to " + akLight)
EndEvent

Event OnConsoleSetLightFOV(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLightFOV(Light akLight, float afFOV)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Light akLight = self.FormFromSArgument(sArgument, 1) as Light
  float afFOV = self.FloatFromSArgument(sArgument, 2)

  If akLight == none
    PrintMessage("FATAL ERROR: Light retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetLightFOV(akLight, afFOV)
  PrintMessage("SetLightFOV applied to " + akLight)
EndEvent

Event OnConsoleSetLightRadius(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLightRadius(Light akLight, float afRadius)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Light akLight = self.FormFromSArgument(sArgument, 1) as Light
  float afRadius = self.FloatFromSArgument(sArgument, 2)

  If akLight == none
    PrintMessage("FATAL ERROR: Light retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetLightRadius(akLight, afRadius)
  PrintMessage("SetLightRadius applied to " + akLight)
EndEvent

Event OnConsoleSetLightRGB(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLightRGB(Light akLight, int aiColorR, int aiColorG, int aiColorB)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Light akLight = self.FormFromSArgument(sArgument, 1) as Light
  
  Int aiColorR = self.IntFromSArgument(sArgument, 3)
  Int aiColorG = self.IntFromSArgument(sArgument, 4)
  Int aiColorB = self.IntFromSArgument(sArgument, 5)

  Int[] aiColor
  aiColor[0] = aiColorR
  aiColor[1] = aiColorG
  aiColor[2] = aiColorB

  If akLight == none
    PrintMessage("FATAL ERROR: Light retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetLightRGB(akLight, aiColor)
  PrintMessage("SetLightRGB applied to " + akLight)
EndEvent

Event OnConsoleSetLightShadowDepthBias(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLightShadowDepthBias(ObjectReference akLightObject, float afDepthBias)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference akLightObject = self.FormFromSArgument(sArgument, 1) as ObjectReference
  float afDepthBias = self.FloatFromSArgument(sArgument, 2)

  If akLightObject == none
    PrintMessage("FATAL ERROR: Light Object retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetLightShadowDepthBias(akLightObject, afDepthBias)
  PrintMessage("SetLightShadowDepthBias applied to " + akLightObject)
EndEvent

Event OnConsoleSetLightType(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLightType(Light akLight, int aiLightType)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Light akLight = self.FormFromSArgument(sArgument, 1) as Light
  int aiLightType = self.IntFromSArgument(sArgument, 2)

  If akLight == none
    PrintMessage("FATAL ERROR: Light retrieval failed")
    Return
  EndIf

  PO3_SKSEFunctions.SetLightType(akLight, aiLightType)
  PrintMessage("SetLightType applied to " + akLight)
EndEvent

Event OnConsoleGetMagicEffectArchetype(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectArchetype(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  int result = PO3_SKSEFunctions.GetEffectArchetypeAsInt(akMagicEffect)
  string strResult = PO3_SKSEFunctions.GetEffectArchetypeAsString(akMagicEffect)
  
  PrintMessage("Archetype of " + self.GetFullID(akMagicEffect) + " is " + strResult + Paren(result))
    
EndEvent

Event OnConsoleGetMagicEffectPrimaryActorValue(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectPrimaryActorValue(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  string result = PO3_SKSEFunctions.GetPrimaryActorValue(akMagicEffect)
  
  PrintMessage("Archetype of " + self.GetFullID(akMagicEffect) + " is " + result)
    
EndEvent

Event OnConsoleGetMagicEffectySecondaryActorValue(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicEffectSecondaryActorValue(MagicEffect akMagicEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  MagicEffect akMagicEffect = self.FormFromSArgument(sArgument, 1) as MagicEffect

  If akMagicEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  string result = PO3_SKSEFunctions.GetSecondaryActorValue(akMagicEffect)
  
  PrintMessage("Archetype of " + self.GetFullID(akMagicEffect) + " is " + result)
    
EndEvent

Event OnConsoleSetSubGraphFloatVariable(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSubGraphFloatVariable([Actor akActor = GetSelectedReference()], string asVariableName, float afValue = 0.0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  string asVariableName = self.StringFromSArgument(sArgument, 1)
  float afValue = FloatFromSArgument(sArgument, 2)
  If akActor == none
    PrintMessage("FATAL ERROR: Form retrieval error")
    Return
  EndIf
  akActor.SetSubGraphFloatVariable(asVariableName, afValue)
  PrintMessage("SetSubGraphFloatVariable: " + asVariableName + " to " + afValue)
EndEvent

Event OnConsoleGetWorldModelNumTextureSets(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetWorldModelNumTextureSets(Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = FormFromSArgument(sArgument, 1)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  int num =  akForm.GetWorldModelNumTextureSets()
  PrintMessage("Number of world texture sets of " + self.GetFullID(akForm) + " is " + num)
EndEvent

Event OnConsoleGetWorldModelNthTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetWorldModelNthTextureSet(Form akForm, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = FormFromSArgument(sArgument, 1)
  int aiIndex = IntFromSArgument(sArgument, 2)
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  TextureSet TXST =  akForm.GetWorldModelNthTextureSet(aiIndex)
  PrintMessage("World texture set #" + aiIndex + " of " + self.GetFullID(akForm) + " is " + self.GetFullID(TXST))
EndEvent

Event OnConsoleSetWorldModelNthTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetWorldModelNthTextureSet(Form akForm, int aiIndex, TextureSet akTXST)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = FormFromSArgument(sArgument, 1)
  int aiIndex = IntFromSArgument(sArgument, 2)
  TextureSet akTXST = FormFromSArgument(sArgument, 3) as TextureSet
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  TextureSet oldTXST = akForm.GetWorldModelNthTextureSet(aiIndex)
  
  PrintMessage("World texture set #" + aiIndex + " of " + self.GetFullID(akForm) + " is " + self.GetFullID(oldTXST))
  
  PrintMessage("Attempting to set it to " + self.GetFullID(akTXST))

  akForm.SetWorldModelNthTextureSet(akTXST, aiIndex)

  TextureSet newTXST = akForm.GetWorldModelNthTextureSet(aiIndex)
  
  PrintMessage("World texture set #" + aiIndex + " of " + self.GetFullID(akForm) + " is " + self.GetFullID(newTXST))
EndEvent

Event OnConsoleGetWorldModelTextureSets(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetWorldModelTextureSets(Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm
  If QtyPars == 0
    akForm = (ConsoleUtil.GetSelectedReference() as Actor).GetBaseObject()
  Else
    akForm = self.FormFromSArgument(sArgument, 1)
  EndIf
  If akForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  int txSets = akForm.GetWorldModelNumTextureSets()
  int txSet = 0

  If txSets <= 0
    PrintMessage("No world model texture sets found for " + self.GetFullID(akForm))
    Return
  Else
    PrintMessage(txSets + " world model texture sets found for " + self.GetFullID(akForm))
  EndIf
  
  While txSet < txSets
    PrintMessage("TextureSet #" + txSet + ": " + self.GetFullID(akForm.GetWorldModelNthTextureSet(txSet)))
    txSet += 1
  EndWhile
EndEvent

Event OnConsoleGetFormInfo(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFormInfo(Form akForm)")
  Form akForm = FormFromSArgument(sArgument, 1)
  
  If akForm == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  String FID = ""
  String EDID = ""
  String FT = DbMiscFunctions.GetFormTypeStringAll(akForm)

  If PO3_SKSEFunctions.IntToString(akForm.GetFormId(), true) != ""
    FID = PO3_SKSEFunctions.IntToString(akForm.GetFormId(), true)
  ElseIf DbMiscFunctions.GetFormIDHex(akForm) != ""
    FID = DbMiscFunctions.GetFormIDHex(akForm)
  Else
    FID = "unk. FormID"
  EndIf
  If PO3_SKSEFunctions.GetFormEditorId(akForm) != ""
    EDID = PO3_SKSEFunctions.GetFormEditorId(akForm)
  Else
    EDID = DbSKSEFunctions.GetFormEditorID(akForm, "unk. EDID")
  EndIf
  String Result = DoubleQuotes(EDID + " [" + FT + ": " + FID + "]")
  String DN = (akForm as ObjectReference).GetDisplayName()
  
  PrintMessage("FORM IDENTIFICATION")
  PrintMessage("  - FormID (Hex): " + FID)
  PrintMessage("  - FormID (Decimal): " + akForm.GetFormID())
  PrintMessage("  - EditorID: " + EDID)
  PrintMessage("  - Display Name: " + (akForm as ObjectReference).GetDisplayName())
  PrintMessage("  - Type: " + akForm.GetType())
  PrintMessage("  - Type Name (DbMiscFunctions.GetFormTypeString): " + DbMiscFunctions.GetFormTypeString(akForm.GetType()))
  PrintMessage("  - Type Name (DbMiscFunctions.GetFormTypeStringAll): " + DbMiscFunctions.GetFormTypeStringAll(akForm))
  PrintMessage("  - Weight: " + akForm.GetWeight())
  PrintMessage("  - Gold Value: " + akForm.GetGoldValue())
  PrintMessage("  - Known to Player: " + akForm.PlayerKnows())
  PrintMessage("WORLD MODEL" + akForm.GetWorldModelPath())
  PrintMessage("  - Path: " + akForm.GetWorldModelPath())
  PrintMessage("  - TextureSets:")
  
    int txSets = akForm.GetWorldModelNumTextureSets()
    int txSet = 0

    If txSets <= 0
      PrintMessage("    - None found")
    EndIf
    While txSet < txSets
      PrintMessage("    - TextureSet #" + txSet + ": " + self.GetFullID(akForm.GetWorldModelNthTextureSet(txSet)))
      txSet += 1
    EndWhile
  
  PrintMessage("FORM KEYWORDS")
  Keyword[] keywords = akForm.GetKeywords()
  int i = 0
  int L = keywords.Length
  If L > 5
    PrintMessage("  - Found " + L + " keywords. Displaying only five. Use GetKeywords to see the rest")
  EndIf
  L = PapyrusUtil.ClampInt(L, 0, 5)
  While i < L
    PrintMessage("  - Keyword #" + i + ": " + self.GetFullID(keywords[i]))
    i += 1
  EndWhile

  PrintMessage("")

  
  PrintMessage("FORM RECORD FLAGS")
  PrintMessage("0x00000001	(TES4) Master (ESM) file: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm,0x00000001))
  PrintMessage("0x00000010	Deleted Group (bugged, see Groups): " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000010))
  PrintMessage("0x00000020	Deleted Record: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000020))
  PrintMessage("0x00000040	(GLOB) Constant: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000040))
  PrintMessage("            (REFR) Hidden From Local Map (Needs Confirmation: Related to shields): " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000040))
  PrintMessage("0x00000080	(TES4) Localized: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000080))
  PrintMessage("0x00000100	Must Update Anims: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000100))
  PrintMessage("            (REFR) Inaccessible: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000100))
  PrintMessage("0x00000200	(TES4) Light Master (ESL) File. Data File: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000200))
  PrintMessage("            (REFR) Hidden from local map: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000200))
  PrintMessage("            (ACHR) Starts dead: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000200))
  PrintMessage("            (REFR) MotionBlurCastsShadows: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000200))
  PrintMessage("0x00000400	Quest item: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000400))
  PrintMessage("            Persistent reference: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000400))
  PrintMessage("            (LSCR) Displays in Main Menu: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000400))
  PrintMessage("0x00000800	Initially disabled: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00000800))
  PrintMessage("0x00001000	Ignored: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00001000))
  PrintMessage("0x00008000	Visible when distant: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00008000))
  PrintMessage("0x00010000	(ACTI) Random Animation Start: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00010000))
  PrintMessage("0x00020000	(ACTI) Dangerous: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00020000))
  PrintMessage("            Off limits (Interior cell): " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00020000))
  PrintMessage("            NOTE: Dangerous Can't be set without Ignore Object Interaction")
  PrintMessage("0x00040000	Data is compressed: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00040000))
  PrintMessage("0x00080000	Can't wait: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00080000))
  PrintMessage("0x00100000	(ACTI) Ignore Object Interaction: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00100000))
  PrintMessage("            Ignore Object Interaction Sets Dangerous Automatically: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00100000))
  PrintMessage("0x00800000	Is Marker: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x00800000))
  PrintMessage("0x02000000	(ACTI) Obstacle: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x02000000))
  PrintMessage("            (REFR) No AI Acquire: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x02000000))
  PrintMessage("0x04000000	NavMesh Gen - Filter: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x04000000))
  PrintMessage("0x08000000	NavMesh Gen - Bounding Box: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x08000000))
  PrintMessage("0x10000000	(FURN) Must Exit to Talk: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x10000000))
  PrintMessage("            (REFR) Reflected By Auto Water: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x10000000))
  PrintMessage("0x20000000	(FURN/IDLM) Child Can Use: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x20000000))
  PrintMessage("            (REFR) Don't Havok Settle: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x20000000))
  PrintMessage("0x40000000	NavMesh Gen - Ground: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x40000000))
  PrintMessage("            (REFR) NoRespawn: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x40000000))
  PrintMessage("0x80000000	(REFR) MultiBound: " + PO3_SKSEFunctions.IsRecordFlagSet(akForm, 0x80000000))
EndEvent

Event OnConsoleGetReferenceInfo(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetReferenceInfo(ObjectReference akRef)")
  ObjectReference akRef = ConsoleUtil.GetSelectedReference()

  If QtyPars == 1
    akRef = RefFromSArgument(sArgument, 1)
  EndIf
  
  If akRef == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PrintMessage("REFERENCE IDENTIFICATION")
  PrintMessage(GetFullID(akRef))
  
  PrintMessage("POSITION")
  PrintMessage("  - Off Limits: " + akRef.IsOffLimits())
  PrintMessage("  - Worldspace: " + akRef.GetWorldSpace())
  PrintMessage("  - Cell: " + akRef.GetParentCell())
  PrintMessage("  - X: " + akRef.GetPositionX())
  PrintMessage("  - Y: " + akRef.GetPositionY())
  PrintMessage("  - Z: " + akRef.GetPositionZ())
  PrintMessage("  - Angle X: " + akRef.GetAngleX())
  PrintMessage("  - Angle Y: " + akRef.GetAngleY())
  PrintMessage("  - Angle Z: " + akRef.GetAngleZ())
  PrintMessage("")
  PrintMessage("PHYSICAL PROPERTIES")
  PrintMessage("  - Mass: " + akRef.GetMass())
  PrintMessage("  - Scale: " + akRef.GetScale())
  PrintMessage("  - Height: " + akRef.GetHeight())
  PrintMessage("  - Width: " + akRef.GetWidth())
  PrintMessage("  - Length: " + akRef.GetLength())
  PrintMessage("  - Destruction Stage: " + akRef.GetCurrentDestructionStage())
  PrintMessage("")  
  PrintMessage("CONTAINER PROPERTIES")
  PrintMessage("  - Empty: " + akRef.IsContainerEmpty())
  PrintMessage("  - Open State: " + akRef.GetOpenState())
  PrintMessage("  - Lock State: " + akRef.IsLocked())
  PrintMessage("  - Number of Items: " + akRef.GetNumItems())
  PrintMessage("  - Total Weight: " + akRef.GetTotalItemWeight())
  PrintMessage("")  
  PrintMessage("TEMPERING, POISON & ENCHANTMENT PROPERTIES")
  PrintMessage("  - Tempering (%): " + akRef.GetItemHealthPercent())
  PrintMessage("  - Enchantment: " + GetFullID(akRef.GetEnchantment()))
  PrintMessage("      - Current Charges: " + akRef.GetItemCharge())
  PrintMessage("      - Max Charges: " + akRef.GetItemMaxCharge())
  PrintMessage("  - Poison: " + GetFullID(akRef.GetPoison()))
  PrintMessage("")  
  PrintMessage("MISC PROPERTIES")
  PrintMessage("  - 3D Loaded: " + akRef.Is3DLoaded())
  PrintMessage("  - Deleted: " + akRef.IsDeleted())
  PrintMessage("  - Disabled: " + akRef.IsDisabled())
  PrintMessage("  - Actor Owner: " + akRef.GetActorOwner())
  PrintMessage("  - Faction Owner: " + akRef.GetFactionOwner())
  PrintMessage("  - Scene: " + GetFullID(akRef.GetCurrentScene()))
  PrintMessage("  - Activation Blocked: " + akRef.IsActivationBlocked())
  PrintMessage("")
  If (akRef as Actor) != none
    Actor akActor = akRef as Actor
    PrintMessage("ACTOR PROPERTIES")
    PrintMessage("Actor Value Information")
    PrintMessage("  - Health: " + akActor.GetAV("Health") + " / " + akActor.GetAVMax("Health"))
    PrintMessage("    - Regen: " + akActor.GetAV("HealRate") + " / " + akActor.GetAVMax("HealRate"))
    PrintMessage("  - Magicka: " + akActor.GetAV("Magicka") + " / " + akActor.GetAVMax("Magicka"))
    PrintMessage("    - Regen: " + akActor.GetAV("MagickaRate") + " / " + akActor.GetAVMax("MagickaRate"))
    PrintMessage("  - Stamina: " + akActor.GetAV("Stamina") + " / " + akActor.GetAVMax("Stamina"))
    PrintMessage("    - Regen: " + akActor.GetAV("StaminaRate") + " / " + akActor.GetAVMax("StaminaRate"))
    PrintMessage("  - Warmth (Variable09): " + akActor.GetAV("Variable09"))
    PrintMessage("  - Warmth (WarmthRatingAV): " +  akActor.GetAV("WarmthRatingAV"))
    PrintMessage("  - Movement Speed: " + akActor.GetAV("SpeedMult") + " / " + akActor.GetAVMax("SpeedMult"))
    PrintMessage("  - Carrying Capacity: " + akActor.GetAV("CarryWeight") + " / " + akActor.GetAVMax("CarryWeight"))
    PrintMessage("  - Inventory Weight: " + akActor.GetAV("InventoryWeight") + " / " + akActor.GetAVMax("InventoryWeight"))
    PrintMessage("")  
    PrintMessage("Fixed Stats")
    PrintMessage("  - Crime Faction: " + GetFullID(akActor.GetCrimeFaction()))
    PrintMessage("  - Actor Base: " + GetFullID(akActor.GetActorBase()))
    PrintMessage("  - Race: " + akActor.GetRace())
    PrintMessage("  - Outfit: " + akActor.GetActorBase().GetOutfit())
    PrintMessage("  - Price to Bribe: " + akActor.GetBribeAmount())
    PrintMessage("")  
    PrintMessage("Current States")
    PrintMessage("  - Dead: " + akActor.IsDead())
    PrintMessage("  - Ghost: " + akActor.IsGhost())
    PrintMessage("  - Combat: " + VCSMisc.GetCombatState(akActor))
    PrintMessage("    - Target: " + GetFullID(akActor.GetCombatTarget()))
    PrintMessage("  - Current Package: " + GetFullID(akActor.GetCurrentPackage()))
    PrintMessage("  - Dialogue Target: " + GetFullID(akActor.GetDialogueTarget()))
    PrintMessage("  - Flying: " + VCSMisc.GetFlyingState(akActor))
    PrintMessage("  - Sitting: " + VCSMisc.GetSitState(akActor))
    PrintMessage("  - Sleeping: " + VCSMisc.GetSleepState(akActor))
    PrintMessage("  - Alarmed: " + akActor.IsAlarmed())
    PrintMessage("  - Alert: " + akActor.IsAlerted())
    PrintMessage("  - Allowed to Fly: " + akActor.IsAllowedToFly())
    PrintMessage("  - Arrested: " + akActor.IsArrested())
    PrintMessage("  - Arresting: " + akActor.IsArrestingTarget())
    PrintMessage("  - Ridden: " + akActor.IsBeingRidden())
    PrintMessage("  - Mounted: " + akActor.IsOnMount())
    PrintMessage("  - Bleeding Out: " + akActor.IsBleedingOut())
    PrintMessage("")  
    PrintMessage("Weapon & Spell Information")
    PrintMessage("  - Shield: " + GetFullID(akActor.GetEquippedShield()))
    PrintMessage("  - Weapon")
    PrintMessage("    - Left: " + GetFullID(akActor.GetEquippedWeapon(abLeftHand = true)))
    PrintMessage("    - Right: " + GetFullID(akActor.GetEquippedWeapon(abLeftHand = false)))
    PrintMessage("  - Spell")
    PrintMessage("    - Left: " + GetFullID(akActor.GetEquippedSpell(0)))
    PrintMessage("    - Right: " + GetFullID(akActor.GetEquippedSpell(1)))
    PrintMessage("    - Other: " + GetFullID(akActor.GetEquippedSpell(2)))
    PrintMessage("    - Instant: " + GetFullID(akActor.GetEquippedSpell(3)))
    PrintMessage("  - Shout: " + GetFullID(akActor.GetEquippedShout()))
    
    PrintMessage("")  
  EndIf
  PrintMessage("REFERENCE ALIASES")
  Alias[] aliases = PO3_SKSEFunctions.GetRefAliases(akRef)
  int i = 0
  int L = aliases.Length
  If L > 5
    PrintMessage("  - Found " + L + " aliases. Displaying only five. Use GetReferenceAliases to see the rest")
  EndIf
  L = PapyrusUtil.ClampInt(L, 0, 5)
  While i < L
    PrintMessage("  - Alias #" + aliases[i].GetID() + " of quest " + self.GetFullID(aliases[i].GetOwningQuest()) + ": " + aliases[i].GetName())
    i += 1
  EndWhile
  PrintMessage("")  
  PrintMessage("REFERENCE KEYWORDS")
  Keyword[] keywords = akRef.GetKeywords()
  int j = 0
  int L2 = keywords.Length
  If L2 > 5
    PrintMessage("  - Found " + L2 + " keywords. Displaying only five. Use GetKeywords to see the rest")
  EndIf
  L2 = PapyrusUtil.ClampInt(L2, 0, 5)
  While i < L
    PrintMessage("  - Keyword #" + j + ": " + self.GetFullID(keywords[j]))
    j += 1
  EndWhile

EndEvent

Event OnConsoleSendModEvent(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SendModEvent(Form akForm, String asEventName, String asStrArg = " + DoubleQuotes("") + ", Float afNumArg = 0.0)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = FormFromSArgument(sArgument, 1)
  String asEventName = StringFromSArgument(sArgument, 1)
  String asStrArg = StringFromSArgument(sArgument, 2)
  Float afNumArg = FloatFromSArgument(sArgument, 2)
  If akForm == none
    PrintMessage("FATAL ERROR: Form retrieval error")
    Return
  EndIf
  akForm.SendModEvent(asEventName, afNumArg)
  PrintMessage("Mod event sent to " + self.GetFullID(akForm))
  PrintMessage("  - Event name: " + asEventName)
  PrintMessage("  - String argument: " + asStrArg)
  PrintMessage("  - Numeric argument: " + afNumArg)
EndEvent

Event OnConsoleLearnIngredientEffect(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: LearnIngredientEffect(Ingredient akIngredient, int aiIndex = -1)")
  PrintMessage("Index -1 means all effects")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Ingredient akIngredient = self.FormFromSArgument(sArgument, 1) as Ingredient
  int aiIndex = self.IntFromSArgument(sArgument, 2, -1)

  If akIngredient == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If aiIndex == -1
    akIngredient.LearnAllEffects()
  ElseIf aiIndex < akIngredient.GetNumEffects()
    akIngredient.LearnEffect(aiIndex)
  EndIf

  
  PrintMessage("Player now knows " + self.GetFullID(akIngredient) + "'s #" + aiIndex + " effect")
EndEvent

Event OnConsoleGetSpellInfo(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSpellInfo(Spell akSpell, Actor akCaster = PlayerRef)")
  PrintMessage("Caster is solely to get the Magicka Cost taking into account the relevant perks")
  Spell akSpell = FormFromSArgument(sArgument, 1) as Spell
  Actor akCaster = RefFromSArgument(sArgument, 2) as Actor

  If akCaster == none
    akCaster = PlayerRef
  EndIf

  If akSpell == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  PrintMessage("SPELL IDENTIFICATION")
  PrintMessage(GetFullID(akSpell))

  PrintMessage("SPELL STATS")
  PrintMessage("  - Cast Time: " + akSpell.GetCastTime())
  PrintMessage("  - Magicka Cost: " + akSpell.GetMagickaCost())
  PrintMessage("  - Magicka Cost (" + akCaster.GetName() + "): " + akSpell.GetEffectiveMagickaCost(akCaster))
  PrintMessage("  - Associated Perk: " + GetFullID(akSpell.GetPerk()))
  PrintMessage("  - Num. of Effects: " + akSpell.GetNumEffects())
  PrintMessage("  - Equip Slot: " + GetFullID(akSpell.GetEquipType()))
  
  PrintMessage("MAGIC EFFECTS")
  Int NumEffects = akSpell.GetNumEffects()
  Int CurrEffect = 0

  While NumEffects < CurrEffect
    PrintMessage("MGEF  #" + CurrEffect + ": " + akSpell.GetNthEffectMagicEffect(CurrEffect))
    PrintMessage("  - Magnitude: " + akSpell.GetNthEffectMagnitude(CurrEffect))
    PrintMessage("  - Area: " + akSpell.GetNthEffectArea(CurrEffect))
    PrintMessage("  - Duration: " + akSpell.GetNthEffectDuration(CurrEffect))
    CurrEffect += 1
  EndWhile
  
EndEvent

Event OnConsoleSayTopic(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SayTopic(ObjectReference akSpeaker, Topic akTopicToSay, Actor akActorToSpeakAs = None, bool abSpeakInPlayersHead = false)")
  ObjectReference akSpeaker = ConsoleUtil.GetSelectedReference()
  Topic akTopicToSay = FormFromSArgument(sArgument, 1) as Topic
  Actor akActorToSpeakAs = RefFromSArgument(sArgument, 2) as Actor
  bool abSpeakInPlayersHead = BoolFromSArgument(sArgument, 3, false)

  If akSpeaker == none || akTopicToSay == none || akActorToSpeakAs == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  akSpeaker.Say(akTopicToSay, akActorToSpeakAs, abSpeakInPlayersHead)
  PrintMessage("Say order sent")
  PrintMessage("  - akTopicToSay: " + GetFullID(akTopicToSay))
  PrintMessage("  - akActorToSpeakAs: " + GetFullID(akActorToSpeakAs))
  PrintMessage("  - abSpeakInPlayersHead: " + abSpeakInPlayersHead)

EndEvent

Event OnConsoleSetActorCalmed(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorCalmed(Actor akActor, bool abDoCalm = true)")
  PrintMessage("Index -1 means all effects")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  bool abDoCalm
  If QtyPars == 1
    akActor = ConsoleUtil.GetSelectedReference() as Actor
    abDoCalm = self.BoolFromSArgument(sArgument, 1, True)
  ElseIf QtyPars == 2
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
    abDoCalm = self.BoolFromSArgument(sArgument, 2, True)
  EndIf

  If akActor == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  SPE_Actor.SetActorCalmed(akActor, abDoCalm)
  
  PrintMessage(GetFullID(akActor) + " is now " + IfElse(abDoCalm, "", "not") + " calmed")
EndEvent

Event OnConsoleGetKeycodeString(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetKeyCodeString(Int aiKeyCode)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int aiKeyCode = self.IntFromSArgument(sArgument, 1)
  string keyName =  DbMiscFunctions.GetKeyCodeString(aiKeyCode)
  If keyName != ""
    PrintMessage("Key " + aiKeyCode + " is " + DbMiscFunctions.GetKeyCodeString(aiKeyCode))
  Else
    PrintMessage("Key " + aiKeyCode + " was not found")
  EndIf
EndEvent

Event OnConsoleSwapEquipment(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SwapEquipment(Actor akActorA, Actor akActorB)")
  PrintMessage("Index -1 means all effects")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActorA
  Actor akActorB
  If QtyPars == 1
    akActorA = ConsoleUtil.GetSelectedReference() as Actor
    akActorB = self.RefFromSArgument(sArgument, 1) as Actor
  ElseIf QtyPars == 2
    akActorA = self.RefFromSArgument(sArgument, 1) as Actor
    akActorB = self.RefFromSArgument(sArgument, 2) as Actor
  EndIf

  If akActorA == none || akActorB == none 
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  DbMiscFunctions.SwapEquipment(akActorA, akActorB)
  
  PrintMessage(GetFullID(akActorA) + " and " + (GetFullID(akActorB) + " swapped equipment"))
EndEvent

Event OnConsoleGetQuestMarker(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetQuestMarker(Quest akQuest)")
  PrintMessage("Index -1 means all effects")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Quest akQuest = self.FormFromSArgument(sArgument, 1) as Quest
  If akQuest == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  ObjectReference result = SPE_Quest.GetQuestMarker(akQuest)
  
  If akQuest == none
    PrintMessage("No quest marker found for " + GetFullID(akQuest))
  Else
    PrintMessage("Quest marker for " + GetFullID(akQuest) + " is " + GetFullID(result))
  EndIf
EndEvent

Event OnConsoleFindAllArmorsForSlot(String EventName, String sArgument, Float fArgument, Form Sender)
  ; Print the format for the command
  PrintMessage("Format: FindAllArmorsForSlot(int aiSlot, bool playable = true, bool ignoreTemplates = true, bool ignoreEnchantments = true, bool onlyEnchanted = false, bool ignoreSkin = false)")
  
  ; Parse the arguments
  int aiSlot = self.IntFromSArgument(sArgument, 1) ; Slot number
  bool playable = self.BoolFromSArgument(sArgument, 2, true) ; Default: true
  bool ignoreTemplates = self.BoolFromSArgument(sArgument, 3, true) ; Default: true
  bool ignoreEnchantments = self.BoolFromSArgument(sArgument, 4, true) ; Default: true
  bool onlyEnchanted = self.BoolFromSArgument(sArgument, 5, false) ; Default: false
  bool ignoreSkin = self.BoolFromSArgument(sArgument, 6, false) ; Default: false

  ; Validate the slot number
  If aiSlot < 0 || aiSlot > 63 ; Assuming slot numbers are between 0 and 63
    PrintMessage("Invalid slot number. Slot must be between 0 and 63")
    Return
  EndIf

  ; Get the slot mask for the given slot
  int aiSlotMask = Armor.GetMaskForSlot(aiSlot)

  ; Get all armors using GameData.GetAllArmor
  Form[] allArmors = GameData.GetAllArmor("", None, playable, ignoreTemplates, ignoreEnchantments, onlyEnchanted, ignoreSkin)

  ; Filter the armors by slot mask using SPE_Utility.FilterBySlotmask
  Armor[] filteredArmors = SPE_Utility.FilterBySlotmask(allArmors, aiSlotMask, false) ; false = match any slot in the mask

  ; Print the results
  int i = 0
  int L = filteredArmors.Length
  If L > 0
    PrintMessage("Found " + L + " armors for slot " + aiSlot)
  Else
    PrintMessage("No armors found for slot " + aiSlot)
    Return
  EndIf

  ; Iterate through the filtered armors and print their details
  While i < L
    Armor currentArmor = filteredArmors[i]
    If currentArmor
      PrintMessage("Armor #" + i + ": " + self.GetFullID(currentArmor))
    EndIf
    i += 1
  EndWhile
EndEvent

Event OnConsoleForceStartScene(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ForceStartScene(Scene akScene)")
  PrintMessage("Index -1 means all effects")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Scene akScene = self.FormFromSArgument(sArgument, 1) as Scene
  If akScene == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  akScene.ForceStart()
  
  PrintMessage("Force starting scene " + GetFullID(akScene))
EndEvent

Event OnConsoleStartScene(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: StartScene(Scene akScene)")
  PrintMessage("Index -1 means all effects")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Scene akScene = self.FormFromSArgument(sArgument, 1) as Scene
  If akScene == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  akScene.Start()
  
  PrintMessage("Starting scene " + GetFullID(akScene))
EndEvent

Event OnConsoleStopScene(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: StopScene(Scene akScene)")
  PrintMessage("Index -1 means all effects")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Scene akScene = self.FormFromSArgument(sArgument, 1) as Scene
  If akScene == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  akScene.Stop()
  
  PrintMessage("Stoping scene " + GetFullID(akScene))
EndEvent

Event OnConsoleIsScenePlaying(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: IsScenePlaying(Scene akScene)")
  PrintMessage("Index -1 means all effects")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Scene akScene = self.FormFromSArgument(sArgument, 1) as Scene
  If akScene == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  If akScene.IsPlaying()
    PrintMessage("Scene " + GetFullID(akScene) + " is playing")
  Else
    PrintMessage("Scene " + GetFullID(akScene) + " is not playing")
  EndIf
EndEvent

Event OnConsoleGetArmorAddonModelNumTextureSets(String EventName, String sArgument, Float fArgument, ArmorAddon Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorAddonModelNumTextureSets(ArmorAddon akArmorAddon, bool abFirstPerson, bool abIsFemale)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ArmorAddon akArmorAddon = FormFromSArgument(sArgument, 1) as ArmorAddon
  bool abFirstPerson = BoolFromSArgument(sArgument, 2, false)
  bool abIsFemale = BoolFromSArgument(sArgument, 3, false)
  If akArmorAddon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  int num =  akArmorAddon.GetModelNumTextureSets(abFirstPerson, abIsFemale)
  PrintMessage("Number of armor addon texture sets of " + self.GetFullID(akArmorAddon) + " is " + num)
EndEvent

Event OnConsoleGetArmorAddonModelNthTextureSet(String EventName, String sArgument, Float fArgument, ArmorAddon Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorAddonModelNthTextureSet(ArmorAddon akArmorAddon, int aiIndex, bool abFirstPerson, bool abIsFemale)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ArmorAddon akArmorAddon = FormFromSArgument(sArgument, 1) as ArmorAddon
  int aiIndex = IntFromSArgument(sArgument, 2)
  bool abFirstPerson = BoolFromSArgument(sArgument, 3, false)
  bool abIsFemale = BoolFromSArgument(sArgument, 4, false)
  If akArmorAddon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  TextureSet TXST =  akArmorAddon.GetModelNthTextureSet(aiIndex, abFirstPerson, abIsFemale)
  PrintMessage("Armor addon texture set #" + aiIndex + " of " + self.GetFullID(akArmorAddon) + " is " + self.GetFullID(TXST))
EndEvent

Event OnConsoleSetArmorAddonModelNthTextureSet(String EventName, String sArgument, Float fArgument, ArmorAddon Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetArmorAddonModelNthTextureSet(ArmorAddon akArmorAddon, int aiIndex, bool abFirstPerson, bool abIsFemale, TextureSet akTXST)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ArmorAddon akArmorAddon = FormFromSArgument(sArgument, 1) as ArmorAddon
  int aiIndex = IntFromSArgument(sArgument, 2)
  bool abFirstPerson = BoolFromSArgument(sArgument, 3, false)
  bool abIsFemale = BoolFromSArgument(sArgument, 4, false)
  TextureSet akTXST = FormFromSArgument(sArgument, 5) as TextureSet
  If akArmorAddon == none || akTXST == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  TextureSet oldTXST = akArmorAddon.GetModelNthTextureSet(aiIndex, abFirstPerson, abIsFemale)
  
  PrintMessage("Armor addon texture set #" + aiIndex + " of " + self.GetFullID(akArmorAddon) + " is " + self.GetFullID(oldTXST))
  
  PrintMessage("Attempting to set it to " + self.GetFullID(akTXST))

  akArmorAddon.SetModelNthTextureSet(akTXST, aiIndex, abFirstPerson, abIsFemale)

  TextureSet newTXST = akArmorAddon.GetModelNthTextureSet(aiIndex, abFirstPerson, abIsFemale)
  
  PrintMessage("Armor addon texture set #" + aiIndex + " of " + self.GetFullID(akArmorAddon) + " is " + self.GetFullID(newTXST))
EndEvent

Event OnConsoleGetArmorNumArmorAddons(String EventName, String sArgument, Float fArgument, Armor Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorNumArmorAddons(Armor akArmor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = FormFromSArgument(sArgument, 1) as Armor
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  int num =  akArmor.GetNumArmorAddons()
  PrintMessage("Number of armor addons of " + self.GetFullID(akArmor) + " is " + num)
EndEvent

Event OnConsoleGetArmorNthArmorAddon(String EventName, String sArgument, Float fArgument, Armor Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorNthArmorAddon(Armor akArmor, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = FormFromSArgument(sArgument, 1) as Armor
  int aiIndex = IntFromSArgument(sArgument, 2)
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  ArmorAddon AAddon =  akArmor.GetNthArmorAddon(aiIndex)
  PrintMessage("Armor addon #" + aiIndex + " of " + self.GetFullID(akArmor) + " is " + self.GetFullID(AAddon))
EndEvent

Event OnConsoleGetArmorAddons(String EventName, String sArgument, Float fArgument, Armor Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorAddons(Armor akArmor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  If akArmor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  int AAddons = akArmor.GetNumArmorAddons()
  int AAddon = 0

  If AAddons <= 0
    PrintMessage("No armor addon armor addons found for " + self.GetFullID(akArmor))
    Return
  Else
    PrintMessage(AAddons + " armor addon armor addons found for " + self.GetFullID(akArmor))
  EndIf
  
  While AAddon < AAddons
    PrintMessage("Armor addon #" + AAddon + ": " + self.GetFullID(akArmor.GetNthArmorAddon(AAddon)))
    AAddon += 1
  EndWhile
EndEvent

Event OnConsoleSetFreeCameraSpeed(String EventName, String sArgument, Float fArgument, Armor Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetFreeCameraSpeed(float afSpeed)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  float afSpeed = FloatFromSArgument(sArgument, 1)
  If afSpeed < 0.1
    PrintMessage("FATAL ERROR: Invalid speed")
    Return
  EndIf
  MiscUtil.SetFreeCameraSpeed(afSpeed)
EndEvent

Event OnConsoleGetFormsInFormList(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFormsInFormList(Formlist akFormList)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Formlist akFormList = self.FormFromSArgument(sArgument, 1) as Formlist
  If akFormList == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Form[] forms = akFormlist.ToArray()
  int i = 0
  int L = forms.Length
  If L > 0
    PrintMessage("Found " + L + " forms in " + self.GetFullID(akFormList))
  Else
    PrintMessage("No forms found in " + self.GetFullID(akFormList))
    Return
  EndIf
  While i < L
    PrintMessage("Form #" + i + ": " + self.GetFullID(forms[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleGetGlobalVariable(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetGlobalVariable [<String asKey>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  String asKey = StringFromSArgument(sArgument, 1)
  GlobalVariable result = SPE_GlobalVariable.GetGlobal(asKey) 
  If result == none
    PrintMessage("No GlobalVariable found with string " + asKey)
    Return
  EndIf
  PrintMessage("GlobalVariable: " + self.GetFullID(result))
EndEvent

Event OnConsoleGetFormMagicEffects(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format:  GetMagicEffectsForForm(Form akForm)]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = FormFromSArgument(sArgument, 1)
  If akForm == none
    PrintMessage("FATAL ERROR: Form retrieval error")
    Return
  EndIf
  MagicEffect[] effects = DbSKSEFunctions.GetMagicEffectsForForm(akForm)
  Int i = 0
  Int L = effects.Length
  If L > 0
    PrintMessage("Found " + L + " magic effects for " + self.GetFullID(akForm))
  Else
    PrintMessage("No magic effects found for " + self.GetFullID(akForm))
    Return
  EndIf
  While i < L
    PrintMessage("Magic Effect #" + i + ": " + self.GetFullID(effects[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleFlattenLeveledList(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: FlattenLeveledList(LeveledItem akLeveledList)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  LeveledItem akLeveledList = self.FormFromSArgument(sArgument, 1) as LeveledItem
  If akLeveledList == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Form[] forms = SPE_Form.FlattenLeveledList(akLeveledList)
  Int i = 0
  Int L = forms.Length
  If L > 0
    PrintMessage("Found " + L + " forms in " + self.GetFullID(akLeveledList))
  Else
    PrintMessage("No forms found in " + self.GetFullID(akLeveledList))
    Return
  EndIf
  While i < L
    PrintMessage("Form #" + i + ": " + self.GetFullID(forms[i]))
    i += 1
  EndWhile
EndEvent

Event OnConsoleGetArmorAddonSlotMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorAddonSlotMask(ArmorAddon akArmorAddon)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ArmorAddon akArmorAddon = self.FormFromSArgument(sArgument, 1) as ArmorAddon
  If akArmorAddon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int slotMask = akArmorAddon.GetSlotMask()
  PrintMessage("Slot mask of " + self.GetFullID(akArmorAddon) + " is " + slotMask)
EndEvent

Event OnConsoleSetArmorAddonSlotMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetArmorAddonSlotMask(ArmorAddon akArmorAddon, int slotMask)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ArmorAddon akArmorAddon = self.FormFromSArgument(sArgument, 1) as ArmorAddon
  int slotMask = self.IntFromSArgument(sArgument, 2)
  If akArmorAddon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akArmorAddon.SetSlotMask(slotMask)
  PrintMessage("Slot mask of " + self.GetFullID(akArmorAddon) + " set to " + slotMask)
EndEvent

Event OnConsoleAddArmorAddonSlotToMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddArmorAddonSlotToMask(ArmorAddon akArmorAddon, int slotMask)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ArmorAddon akArmorAddon = self.FormFromSArgument(sArgument, 1) as ArmorAddon
  int slotMask = self.IntFromSArgument(sArgument, 2)
  If akArmorAddon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akArmorAddon.AddSlotToMask(slotMask)
  PrintMessage("Slot mask of " + self.GetFullID(akArmorAddon) + " added " + slotMask)
EndEvent 


Event OnConsoleRemoveArmorAddonSlotFromMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveArmorAddonSlotFromMask(ArmorAddon akArmorAddon, int slotMask)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ArmorAddon akArmorAddon = self.FormFromSArgument(sArgument, 1) as ArmorAddon
  int slotMask = self.IntFromSArgument(sArgument, 2)
  If akArmorAddon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akArmorAddon.RemoveSlotFromMask(slotMask)
  PrintMessage("Slot mask of " + self.GetFullID(akArmorAddon) + " removed " + slotMask)
EndEvent

Event OnConsoleGetArmorAddonMaskForSlot(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorAddonMaskForSlot(int slot)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  int slot = self.IntFromSArgument(sArgument, 1)
  int mask = ArmorAddon.GetMaskForSlot(slot)
  PrintMessage("Mask for slot " + slot + " is " + mask)
EndEvent

Event OnConsoleGetWeaponModelPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetWeaponModelPath(Weapon akWeapon)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Weapon akWeapon = self.FormFromSArgument(sArgument, 1) as Weapon

  If akWeapon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  string Result = akWeapon.GetModelPath()
  PrintMessage("Model path of " + self.GetFullID(akWeapon) + " is " + Result)
EndEvent

Event OnConsoleSetWeaponModelPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetWeaponModelPath(Weapon akWeapon, string path)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Weapon akWeapon = self.FormFromSArgument(sArgument, 1) as Weapon
  string path = DbMiscFunctions.RemovePrefixFromString(sArgument, StringFromSArgument(sArgument, 0) + " " + StringFromSArgument(sArgument, 1) + " ")

  If akWeapon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akWeapon.SetModelPath(path)
  PrintMessage("Model path of " + self.GetFullID(akWeapon) + " set to " + path)
EndEvent

Event OnConsoleGetWeaponIconPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetWeaponIconPath(bool )")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Weapon akWeapon = self.FormFromSArgument(sArgument, 1) as Weapon

  If akWeapon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  string Result = akWeapon.GetIconPath()
  PrintMessage("Icon path of " + self.GetFullID(akWeapon) + " is " + Result)
EndEvent

Event OnConsoleSetWeaponIconPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetIconPath(string path)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Weapon akWeapon = self.FormFromSArgument(sArgument, 1) as Weapon
  string path = DbMiscFunctions.RemovePrefixFromString(sArgument, StringFromSArgument(sArgument, 0) + " " + StringFromSArgument(sArgument, 1) + " ")

  If akWeapon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akWeapon.SetIconPath(path)
  PrintMessage("Icon path of " + self.GetFullID(akWeapon) + " set to " + path)
EndEvent

Event OnConsoleGetWeaponMessageIconPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMessageIconPath(bool )")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Weapon akWeapon = self.FormFromSArgument(sArgument, 1) as Weapon

  If akWeapon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  string Result = akWeapon.GetMessageIconPath()
  PrintMessage("Message icon path of " + self.GetFullID(akWeapon) + " is " + Result)
EndEvent

Event OnConsoleSetWeaponMessageIconPath(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMessageIconPath(string path)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Weapon akWeapon = self.FormFromSArgument(sArgument, 1) as Weapon
  string path = DbMiscFunctions.RemovePrefixFromString(sArgument, StringFromSArgument(sArgument, 0) + " " + StringFromSArgument(sArgument, 1) + " ")
  If akWeapon == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akWeapon.SetMessageIconPath(path)
  PrintMessage("Message icon path of " + self.GetFullID(akWeapon) + " set to " + path)
EndEvent

Event OnConsoleSetLocalGravity(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLocalGravity(float afX, float afY, float afZ)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  float afX = self.FloatFromSArgument(sArgument, 1)
  float afY = self.FloatFromSArgument(sArgument, 2)
  float afZ = self.FloatFromSArgument(sArgument, 3)

  PO3_SKSEFunctions.SetLocalGravity(afX, afY, afZ)
  PrintMessage("Local gravity set to X: " + afX + ", Y: " + afY + ", Z: " + afZ)
EndEvent

Event OnConsoleGetColorFormColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetColorFormColor(ColorForm akColorForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ColorForm akColorForm = self.FormFromSArgument(sArgument, 1) as ColorForm
  If akColorForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int color = akColorForm.GetColor()
  PrintMessage("Color of " + self.GetFullID(akColorForm) + " is " + color)
EndEvent

Event OnConsoleSetColorFormColor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetColorFormColor(ColorForm akColorForm, int color)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ColorForm akColorForm = self.FormFromSArgument(sArgument, 1) as ColorForm
  int color = self.IntFromSArgument(sArgument, 2)
  If akColorForm == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akColorForm.SetColor(color)
  PrintMessage("Color of " + self.GetFullID(akColorForm) + " set to " + color)
EndEvent

Event OnConsoleSetActorSex(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSex(Actor akActor, int aiSex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = self.FormFromSArgument(sArgument, 1) as Actor
  int aiSex = self.IntFromSArgument(sArgument,2)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  ProteusDLLUtils.SetSex(akActor, aiSex)
EndEvent

Event OnConsoleRefreshItemMenu(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RefreshItemMenu()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  DbSKSEFunctions.RefreshItemMenu()
EndEvent

Event OnConsoleGetArtObjectNthTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArtObjectNthTextureSet(Art akArtObject, int aiIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Art akArtObject = FormFromSArgument(sArgument, 1) as Art
  int aiIndex = IntFromSArgument(sArgument, 2)
  If akArtObject == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  TextureSet TXST =  DbSKSEFunctions.GetArtObjectNthTextureSet(akArtObject, aiIndex)
  PrintMessage("World texture set #" + aiIndex + " of " + self.GetFullID(akArtObject) + " is " + self.GetFullID(TXST))
EndEvent

Event OnConsoleSetArtObjectNthTextureSet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetArtObjectNthTextureSet(Art akArtObject, int aiIndex, TextureSet akTXST)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Art akArtObject = FormFromSArgument(sArgument, 1) as Art
  int aiIndex = IntFromSArgument(sArgument, 2)
  TextureSet akTXST = FormFromSArgument(sArgument, 3) as TextureSet
  If akArtObject == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  TextureSet oldTXST =  DbSKSEFunctions.GetArtObjectNthTextureSet(akArtObject, aiIndex)
  
  PrintMessage("World texture set #" + aiIndex + " of " + self.GetFullID(akArtObject) + " is " + self.GetFullID(oldTXST))
  
  PrintMessage("Attempting to set it to " + self.GetFullID(akTXST))

  DbSKSEFunctions.SetArtObjectNthTextureSet(akArtObject, akTXST, aiIndex)

  TextureSet newTXST = DbSKSEFunctions.GetArtObjectNthTextureSet(akArtObject, aiIndex)
  
  PrintMessage("World texture set #" + aiIndex + " of " + self.GetFullID(akArtObject) + " is " + self.GetFullID(newTXST))
EndEvent

Event OnConsoleGetVisualEffectArtObject(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetVisualEffectArtObject(VisualEffect akVisualEffect)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  VisualEffect akVisualEffect = self.FormFromSArgument(sArgument, 1) as VisualEffect
  If akVisualEffect == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Art artObject = PO3_SKSEFunctions.GetArtObject(akVisualEffect)
  PrintMessage("Art object of " + self.GetFullID(akVisualEffect) + " is " +  self.GetFullID(artObject))
EndEvent

Event OnConsoleSetVisualEffectArtObject(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetVisualEffectArtObject(VisualEffect akVisualEffect, Art akArt)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  VisualEffect akVisualEffect = self.FormFromSArgument(sArgument, 1) as VisualEffect
  Art akArt = self.FormFromSArgument(sArgument, 2) as Art
  If akVisualEffect == none || akArt == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.SetArtObject(akVisualEffect, akArt)
  PrintMessage("Art object of " + self.GetFullID(akVisualEffect) + " set to " +  self.GetFullID(akArt))
EndEvent

Event OnConsoleSelectObjectUnderFeet(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SelectObjectUnderFeet(Actor akActor = PlayerRef)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = self.RefFromSArgument(sArgument, 1) as Actor
  If akActor == none
    akActor = PlayerRef
    PrintMessage("Defaulting to akActor = PlayerRef")
    Return
  EndIf
  ConsoleUtil.SetSelectedReference(PO3_SKSEFunctions.GetObjectUnderFeet(akActor))
EndEvent

Event OnConsoleGetTNGBoolValue(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetBoolValue(Int aiID)")
  PrintMessage("0: Exclude player")
  PrintMessage("1: Check player addon after load")
  PrintMessage("2: Check NPCs addon after load")
  PrintMessage("3: RSV Compatiblity (Used internally)")
  PrintMessage("4: Mark mods with slot 52 as revealing by default")
  PrintMessage("5: Allow user to choose the behavior of mods with slot 52")
  PrintMessage("6: Randomize Male addons among the active ones")
  PrintMessage("7: UIExtensions compatibility (Used internally)")
  PrintMessage("8: Show all races in the MCM")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Int aiID = self.IntFromSArgument(sArgument, 1)
  Bool result = TNG_PapyrusUtil.GetBoolValue(aiID)
  PrintMessage("GetBoolValue: " + result)
EndEvent

Event OnConsoleSetTNGBoolValue(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetBoolValue(Int aiID, Bool abValue)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Int aiID = self.IntFromSArgument(sArgument, 1)
  Bool abValue = self.BoolFromSArgument(sArgument, 2)
  TNG_PapyrusUtil.SetBoolValue(aiID, abValue)
  PrintMessage("SetBoolValue applied to " + aiID)
EndEvent

Event OnConsoleGetAllTNGAddonsCount(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllAddonsCount(Bool abIsFemale)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Bool abIsFemale = self.BoolFromSArgument(sArgument, 1)
  Int result = TNG_PapyrusUtil.GetAllAddonsCount(abIsFemale)
  PrintMessage("GetAllAddonsCount: " + result)
EndEvent

Event OnConsoleGetAllTNGPossibleAddons(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllPossibleAddons(Bool abIsFemale)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Bool abIsFemale = self.BoolFromSArgument(sArgument, 1)
  String[] result = TNG_PapyrusUtil.GetAllPossibleAddons(abIsFemale)
  PrintMessage("GetAllPossibleAddons: " + result)
EndEvent

Event OnConsoleGetTNGAddonStatus(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAddonStatus(Bool abIsFemale, Int aiAddon)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Bool abIsFemale = self.BoolFromSArgument(sArgument, 1)
  Int aiAddon = self.IntFromSArgument(sArgument, 2)
  Bool result = TNG_PapyrusUtil.GetAddonStatus(abIsFemale, aiAddon)
  PrintMessage("GetAddonStatus: " + result)
EndEvent

Event OnConsoleSetTNGAddonStatus(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetAddonStatus(Bool abIsFemale, Int aiAddon, Bool abStatus)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Bool abIsFemale = self.BoolFromSArgument(sArgument, 1)
  Int aiAddon = self.IntFromSArgument(sArgument, 2)
  Bool abStatus = self.BoolFromSArgument(sArgument, 3)
  TNG_PapyrusUtil.SetAddonStatus(abIsFemale, aiAddon, abStatus)
  PrintMessage("SetAddonStatus applied to " + aiAddon)
EndEvent

Event OnConsoleGetTNGRgNames(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRgNames()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  String[] result = TNG_PapyrusUtil.GetRgNames()
  PrintMessage("GetRgNames: " + result)
EndEvent

Event OnConsoleGetTNGRgInfo(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRgInfo(Int aiRgIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Int aiRgIndex = self.IntFromSArgument(sArgument, 1)
  String result = TNG_PapyrusUtil.GetRgInfo(aiRgIndex)
  PrintMessage("GetRgInfo: " + result)
EndEvent

Event OnConsoleGetTNGRgAddons(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRgAddons(Int aiRgIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Int aiRgIndex = self.IntFromSArgument(sArgument, 1)
  String[] result = TNG_PapyrusUtil.GetRgAddons(aiRgIndex)
  PrintMessage("GetRgAddons: " + result)
EndEvent

Event OnConsoleGetTNGRgAddon(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRgAddon(Int aiRgIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Int aiRgIndex = self.IntFromSArgument(sArgument, 1)
  Int result = TNG_PapyrusUtil.GetRgAddon(aiRgIndex)
  PrintMessage("GetRgAddon: " + result)
EndEvent

Event OnConsoleSetTNGRgAddon(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetRgAddon(Int aiRgIndex, Int aiChoice)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Int aiRgIndex = self.IntFromSArgument(sArgument, 1)
  Int aiChoice = self.IntFromSArgument(sArgument, 2)
  TNG_PapyrusUtil.SetRgAddon(aiRgIndex, aiChoice)
  PrintMessage("SetRgAddon applied to " + aiRgIndex)
EndEvent

Event OnConsoleGetTNGRgMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRgMult(Int aiRgIndex)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Int aiRgIndex = self.IntFromSArgument(sArgument, 1)
  Float result = TNG_PapyrusUtil.GetRgMult(aiRgIndex)
  PrintMessage("GetRgMult: " + result)
EndEvent

Event OnConsoleSetTNGRgMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetRgMult(Int aiRgIndex, Float afMult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Int aiRgIndex = self.IntFromSArgument(sArgument, 1)
  Float afMult = self.FloatFromSArgument(sArgument, 2)
  TNG_PapyrusUtil.SetRgMult(aiRgIndex, afMult)
  PrintMessage("SetRgMult applied to " + aiRgIndex)
EndEvent

Event OnConsoleCanModifyActorTNG(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CanModifyActor(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Actor akActor = self.FormFromSArgument(sArgument, 1) as Actor
  Int result = TNG_PapyrusUtil.CanModifyActor(akActor)
  PrintMessage("CanModifyActor: " + result)
EndEvent

Event OnConsoleGetTNGActorAddons(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorAddons(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Actor akActor = self.FormFromSArgument(sArgument, 1) as Actor
  String[] result = TNG_PapyrusUtil.GetActorAddons(akActor)
  PrintMessage("GetActorAddons: " + result)
EndEvent

Event OnConsoleGetTNGActorAddon(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorAddon(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Actor akActor = self.FormFromSArgument(sArgument, 1) as Actor
  Armor result = TNG_PapyrusUtil.GetActorAddon(akActor)
  PrintMessage("GetActorAddon: " + result)
EndEvent

Event OnConsoleSetTNGActorAddon(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorAddon(Actor akActor, Int aiChoice)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Actor akActor = self.FormFromSArgument(sArgument, 1) as Actor
  Int aiChoice = self.IntFromSArgument(sArgument, 2)
  TNG_PapyrusUtil.SetActorAddon(akActor, aiChoice)
  PrintMessage("SetActorAddon applied to " + akActor)
EndEvent

Event OnConsoleGetTNGActorSize(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetActorSize(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Actor akActor = self.FormFromSArgument(sArgument, 1) as Actor
  Int result = TNG_PapyrusUtil.GetActorSize(akActor)
  PrintMessage("GetActorSize: " + result)
EndEvent

Event OnConsoleSetTNGActorSize(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetActorSize(Actor akActor, Int aiSizeCat)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Actor akActor = self.FormFromSArgument(sArgument, 1) as Actor
  Int aiSizeCat = self.IntFromSArgument(sArgument, 2)
  TNG_PapyrusUtil.SetActorSize(akActor, aiSizeCat)
  PrintMessage("SetActorSize applied to " + akActor)
EndEvent

Event OnConsoleTNGActorItemsInfo(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ActorItemsInfo(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Actor akActor = self.FormFromSArgument(sArgument, 1) as Actor
  String[] result = TNG_PapyrusUtil.ActorItemsInfo(akActor)
  PrintMessage("ActorItemsInfo: " + result)
EndEvent

Event OnConsoleTNGSwapRevealing(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SwapRevealing(Actor akActor, Int aiChoice)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Actor akActor = self.FormFromSArgument(sArgument, 1) as Actor
  Int aiChoice = self.IntFromSArgument(sArgument, 2)
  Bool result = TNG_PapyrusUtil.SwapRevealing(akActor, aiChoice)
  PrintMessage("SwapRevealing: " + result)
EndEvent

Event OnConsoleCheckTNGActors(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CheckActors()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Actor[] result = TNG_PapyrusUtil.CheckActors()
  PrintMessage("CheckActors: " + result)
EndEvent

Event OnConsoleGetTNGSlot52Mods(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSlot52Mods()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  String[] result = TNG_PapyrusUtil.GetSlot52Mods()
  PrintMessage("GetSlot52Mods: " + result)
EndEvent

Event OnConsoleTNGSlot52ModBehavior(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: Slot52ModBehavior(String asModName, Int aiBehavior)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  String asModName = self.StringFromSArgument(sArgument, 1)
  Int aiBehavior = self.IntFromSArgument(sArgument, 2)
  Bool result = TNG_PapyrusUtil.Slot52ModBehavior(asModName, aiBehavior)
  PrintMessage("Slot52ModBehavior: " + result)
EndEvent

Event OnConsoleUpdateTNGSettings(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: UpdateSettings()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  TNG_PapyrusUtil.UpdateSettings()
  PrintMessage("UpdateSettings applied")
EndEvent

Event OnConsoleUpdateTNGLogLvl(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: UpdateLogLvl(Int aiLogLevel)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Int aiLogLevel = self.IntFromSArgument(sArgument, 1)
  Int result = TNG_PapyrusUtil.UpdateLogLvl(aiLogLevel)
  PrintMessage("UpdateLogLvl: " + result)
EndEvent

Event OnConsoleShowTNGLogLocation(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ShowLogLocation()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  String result = TNG_PapyrusUtil.ShowLogLocation()
  PrintMessage("ShowLogLocation: " + result)
EndEvent

Event OnConsoleGetTNGErrDscr(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetErrDscr(Int aiErrCode)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Int aiErrCode = self.IntFromSArgument(sArgument, 1)
  String result = TNG_PapyrusUtil.GetErrDscr(aiErrCode)
  PrintMessage("GetErrDscr: " + result)
EndEvent

Event OnConsoleTNGWhyProblem(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: WhyProblem(Actor akActor, Int aiIssueID)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Actor akActor = self.FormFromSArgument(sArgument, 1) as Actor
  Int aiIssueID = self.IntFromSArgument(sArgument, 2)
  String result = TNG_PapyrusUtil.WhyProblem(akActor, aiIssueID)
  PrintMessage("WhyProblem: " + result)
EndEvent

Event OnConsoleDisenchant(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: Disenchant(Form akForm)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Form akForm = self.FormFromSArgument(sArgument, 1)
  f314FD_Utils.Disenchant(akForm)
  PrintMessage("Attempted to disenchant " + GetFullID(akForm))
EndEvent

Event OnConsoleStartPhysics(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: StartPhysics(Actor akActor, String asNodeName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Actor akActor = self.FormFromSArgument(sArgument, 1) as Actor
  String asNodeName = self.StringFromSArgument(sArgument, 2)
  CBPCPluginScript.StartPhysics(akActor, asNodeName)
  PrintMessage("Started physics in " + GetFullID(akActor) + "'s " + asNodeName)
EndEvent

Event OnConsoleStopPhysics(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: StopPhysics(Actor akActor, String asNodeName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Actor akActor = self.FormFromSArgument(sArgument, 1) as Actor
  String asNodeName = self.StringFromSArgument(sArgument, 2)
  CBPCPluginScript.StopPhysics(akActor, asNodeName)
  PrintMessage("Stopped physics in " + GetFullID(akActor) + "'s " + asNodeName)
EndEvent

Event OnConsoleGetOffensiveMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetOffensiveMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetOffensiveMult()
  PrintMessage("Offensive Mult: " + result)
EndEvent

Event OnConsoleGetDefensiveMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetDefensiveMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetDefensiveMult()
  PrintMessage("Defensive Mult: " + result)
EndEvent

Event OnConsoleGetGroupOffensiveMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetGroupOffensiveMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetGroupOffensiveMult()
  PrintMessage("Group Offensive Mult: " + result)
EndEvent

Event OnConsoleGetAvoidThreatChance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAvoidThreatChance(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetAvoidThreatChance()
  PrintMessage("Avoid Threat Chance: " + result)
EndEvent

Event OnConsoleGetMeleeMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMeleeMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetMeleeMult()
  PrintMessage("Melee Mult: " + result)
EndEvent

Event OnConsoleGetRangedMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRangedMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetRangedMult()
  PrintMessage("Ranged Mult: " + result)
EndEvent

Event OnConsoleGetMagicMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMagicMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetMagicMult()
  PrintMessage("Magic Mult: " + result)
EndEvent

Event OnConsoleGetShoutMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetShoutMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetShoutMult()
  PrintMessage("Shout Mult: " + result)
EndEvent

Event OnConsoleGetStaffMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetStaffMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetStaffMult()
  PrintMessage("Staff Mult: " + result)
EndEvent

Event OnConsoleGetUnarmedMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetUnarmedMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetUnarmedMult()
  PrintMessage("Unarmed Mult: " + result)
EndEvent

Event OnConsoleSetOffensiveMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetOffensiveMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetOffensiveMult(mult)
  PrintMessage("Set Offensive Mult to: " + mult)
EndEvent

Event OnConsoleSetDefensiveMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetDefensiveMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetDefensiveMult(mult)
  PrintMessage("Set Defensive Mult to: " + mult)
EndEvent

Event OnConsoleSetGroupOffensiveMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetGroupOffensiveMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetGroupOffensiveMult(mult)
  PrintMessage("Set Group Offensive Mult to: " + mult)
EndEvent

Event OnConsoleSetAvoidThreatChance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetAvoidThreatChance(CombatStyle akCombatStyle, Float chance)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float chance = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetAvoidThreatChance(chance)
  PrintMessage("Set Avoid Threat Chance to: " + chance)
EndEvent

Event OnConsoleSetMeleeMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMeleeMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetMeleeMult(mult)
  PrintMessage("Set Melee Mult to: " + mult)
EndEvent

Event OnConsoleSetRangedMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetRangedMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetRangedMult(mult)
  PrintMessage("Set Ranged Mult to: " + mult)
EndEvent

Event OnConsoleSetMagicMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMagicMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetMagicMult(mult)
  PrintMessage("Set Magic Mult to: " + mult)
EndEvent

Event OnConsoleSetShoutMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetShoutMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetShoutMult(mult)
  PrintMessage("Set Shout Mult to: " + mult)
EndEvent

Event OnConsoleSetStaffMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetStaffMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetStaffMult(mult)
  PrintMessage("Set Staff Mult to: " + mult)
EndEvent

Event OnConsoleSetUnarmedMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetUnarmedMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetUnarmedMult(mult)
  PrintMessage("Set Unarmed Mult to: " + mult)
EndEvent

Event OnConsoleGetMeleeAttackStaggeredMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMeleeAttackStaggeredMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetMeleeAttackStaggeredMult()
  PrintMessage("Melee Attack Staggered Mult: " + result)
EndEvent

Event OnConsoleGetMeleePowerAttackStaggeredMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMeleePowerAttackStaggeredMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetMeleePowerAttackStaggeredMult()
  PrintMessage("Melee Power Attack Staggered Mult: " + result)
EndEvent

Event OnConsoleGetMeleePowerAttackBlockingMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMeleePowerAttackBlockingMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetMeleePowerAttackBlockingMult()
  PrintMessage("Melee Power Attack Blocking Mult: " + result)
EndEvent

Event OnConsoleGetMeleeBashMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMeleeBashMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetMeleeBashMult()
  PrintMessage("Melee Bash Mult: " + result)
EndEvent

Event OnConsoleGetMeleeBashRecoiledMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMeleeBashRecoiledMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetMeleeBashRecoiledMult()
  PrintMessage("Melee Bash Recoiled Mult: " + result)
EndEvent

Event OnConsoleGetMeleeBashAttackMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMeleeBashAttackMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetMeleeBashAttackMult()
  PrintMessage("Melee Bash Attack Mult: " + result)
EndEvent

Event OnConsoleGetMeleeBashPowerAttackMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMeleeBashPowerAttackMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetMeleeBashPowerAttackMult()
  PrintMessage("Melee Bash Power Attack Mult: " + result)
EndEvent

Event OnConsoleGetMeleeSpecialAttackMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetMeleeSpecialAttackMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetMeleeSpecialAttackMult()
  PrintMessage("Melee Special Attack Mult: " + result)
EndEvent

Event OnConsoleGetAllowDualWielding(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllowDualWielding(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Bool result = akCombatStyle.GetAllowDualWielding()
  PrintMessage("Allow Dual Wielding: " + result)
EndEvent

Event OnConsoleSetMeleeAttackStaggeredMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMeleeAttackStaggeredMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetMeleeAttackStaggeredMult(mult)
  PrintMessage("Set Melee Attack Staggered Mult to: " + mult)
EndEvent

Event OnConsoleSetMeleePowerAttackStaggeredMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMeleePowerAttackStaggeredMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetMeleePowerAttackStaggeredMult(mult)
  PrintMessage("Set Melee Power Attack Staggered Mult to: " + mult)
EndEvent

Event OnConsoleSetMeleePowerAttackBlockingMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMeleePowerAttackBlockingMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetMeleePowerAttackBlockingMult(mult)
  PrintMessage("Set Melee Power Attack Blocking Mult to: " + mult)
EndEvent

Event OnConsoleSetMeleeBashMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMeleeBashMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetMeleeBashMult(mult)
  PrintMessage("Set Melee Bash Mult to: " + mult)
EndEvent

Event OnConsoleSetMeleeBashRecoiledMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMeleeBashRecoiledMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetMeleeBashRecoiledMult(mult)
  PrintMessage("Set Melee Bash Recoiled Mult to: " + mult)
EndEvent

Event OnConsoleSetMeleeBashAttackMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMeleeBashAttackMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetMeleeBashAttackMult(mult)
  PrintMessage("Set Melee Bash Attack Mult to: " + mult)
EndEvent

Event OnConsoleSetMeleeBashPowerAttackMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMeleeBashPowerAttackMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetMeleeBashPowerAttackMult(mult)
  PrintMessage("Set Melee Bash Power Attack Mult to: " + mult)
EndEvent

Event OnConsoleSetMeleeSpecialAttackMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMeleeSpecialAttackMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetMeleeSpecialAttackMult(mult)
  PrintMessage("Set Melee Special Attack Mult to: " + mult)
EndEvent

Event OnConsoleSetAllowDualWielding(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetAllowDualWielding(CombatStyle akCombatStyle, Bool allow)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Bool allow = self.BoolFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetAllowDualWielding(allow)
  PrintMessage("Set Allow Dual Wielding to: " + allow)
EndEvent

Event OnConsoleGetCloseRangeDuelingCircleMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetCloseRangeDuelingCircleMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetCloseRangeDuelingCircleMult()
  PrintMessage("Close Range Dueling Circle Mult: " + result)
EndEvent

Event OnConsoleGetCloseRangeDuelingFallbackMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetCloseRangeDuelingFallbackMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetCloseRangeDuelingFallbackMult()
  PrintMessage("Close Range Dueling Fallback Mult: " + result)
EndEvent

Event OnConsoleGetCloseRangeFlankingFlankDistance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetCloseRangeFlankingFlankDistance(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetCloseRangeFlankingFlankDistance()
  PrintMessage("Close Range Flanking Flank Distance: " + result)
EndEvent

Event OnConsoleGetCloseRangeFlankingStalkTime(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetCloseRangeFlankingStalkTime(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetCloseRangeFlankingStalkTime()
  PrintMessage("Close Range Flanking Stalk Time: " + result)
EndEvent

Event OnConsoleSetCloseRangeDuelingCircleMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetCloseRangeDuelingCircleMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetCloseRangeDuelingCircleMult(mult)
  PrintMessage("Set Close Range Dueling Circle Mult to: " + mult)
EndEvent

Event OnConsoleSetCloseRangeDuelingFallbackMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetCloseRangeDuelingFallbackMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetCloseRangeDuelingFallbackMult(mult)
  PrintMessage("Set Close Range Dueling Fallback Mult to: " + mult)
EndEvent

Event OnConsoleSetCloseRangeFlankingFlankDistance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetCloseRangeFlankingFlankDistance(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetCloseRangeFlankingFlankDistance(mult)
  PrintMessage("Set Close Range Flanking Flank Distance to: " + mult)
EndEvent

Event OnConsoleSetCloseRangeFlankingStalkTime(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetCloseRangeFlankingStalkTime(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetCloseRangeFlankingStalkTime(mult)
  PrintMessage("Set Close Range Flanking Stalk Time to: " + mult)
EndEvent

Event OnConsoleGetLongRangeStrafeMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLongRangeStrafeMult(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetLongRangeStrafeMult()
  PrintMessage("Long Range Strafe Mult: " + result)
EndEvent

Event OnConsoleSetLongRangeStrafeMult(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLongRangeStrafeMult(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetLongRangeStrafeMult(mult)
  PrintMessage("Set Long Range Strafe Mult to: " + mult)
EndEvent

Event OnConsoleGetFlightHoverChance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFlightHoverChance(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetFlightHoverChance()
  PrintMessage("Flight Hover Chance: " + result)
EndEvent

Event OnConsoleGetFlightDiveBombChance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFlightDiveBombChance(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetFlightDiveBombChance()
  PrintMessage("Flight Dive Bomb Chance: " + result)
EndEvent

Event OnConsoleGetFlightFlyingAttackChance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetFlightFlyingAttackChance(CombatStyle akCombatStyle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  If akCombatStyle == none
    Return
  EndIf
  Float result = akCombatStyle.GetFlightFlyingAttackChance()
  PrintMessage("Flight Flying Attack Chance: " + result)
EndEvent

Event OnConsoleSetFlightHoverChance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetFlightHoverChance(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetFlightHoverChance(mult)
  PrintMessage("Set Flight Hover Chance to: " + mult)
EndEvent

Event OnConsoleSetFlightDiveBombChance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetFlightDiveBombChance(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetFlightDiveBombChance(mult)
  PrintMessage("Set Flight Dive Bomb Chance to: " + mult)
EndEvent

Event OnConsoleSetFlightFlyingAttackChance(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetFlightFlyingAttackChance(CombatStyle akCombatStyle, Float mult)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  CombatStyle akCombatStyle = self.FormFromSArgument(sArgument, 1) as CombatStyle
  Float mult = self.FloatFromSArgument(sArgument, 2)
  If akCombatStyle == none
    Return
  EndIf
  akCombatStyle.SetFlightFlyingAttackChance(mult)
  PrintMessage("Set Flight Flying Attack Chance to: " + mult)
EndEvent

Event OnConsoleSetSILNakedSlotMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetSILNakedSlotMask(Actor akActor, int aiMask, bool abWig=false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = FormFromSArgument(sArgument, 1) as Actor
  int aiMask = IntFromSArgument(sArgument, 2)
  bool abWig = BoolFromSArgument(sArgument, 3)
  SILFollower.SetNakedSlotMask(akActor, aiMask, abWig)
  PrintMessage("Changed slot mask to " + aiMask)
EndEvent

Event OnConsoleGetAnimationEventName(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAnimationEventName(Idle akIdle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Idle akIdle = FormFromSArgument(sArgument, 1) as Idle
  PrintMessage("Animation event name is " + PO3_SKSEFunctions.GetAnimationEventName(akIdle))
EndEvent

Event OnConsoleGetAnimationFileName(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAnimationFileName(Idle akIdle)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Idle akIdle = FormFromSArgument(sArgument, 1) as Idle
  PrintMessage("Animation event name is " + PO3_SKSEFunctions.GetAnimationFileName(akIdle))
EndEvent

Event OnConsoleSetObjectiveText(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetObjectiveText(Quest akQuest, int aiIndex, string asText)")
  PrintMessage("This function does NOT require using quotes to pass string asText with spaces")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Quest akQuest = FormFromSArgument(sArgument, 1) as Quest
  Int aiIndex = IntFromSArgument(sArgument, 2)
  String asText = DbMiscFunctions.RemovePrefixFromString(sArgument, StringFromSArgument(sArgument, 1) + " " + StringFromSArgument(sArgument, 2) + " ")
  
  If akQuest == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.SetObjectiveText(akQuest, asText, aiIndex)
  PrintMessage("Attempted to change name of " + self.GetFullID(akQuest) + "'s " + aiIndex + " objective to: ")
  PrintMessage(asText)
EndEvent

Event OnConsoleRemoveInvalidConstructibleObjects(String EventName, String sArgument, Float fArgument, Form Sender)
    ; Print usage instructions if no arguments are provided
    Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
    If QtyPars == 0
        PrintMessage("Usage: RemoveInvalidConstructibleObjects()")
        Return
    EndIf

    ; Get all ConstructibleObject forms
    ConstructibleObject[] ConObjs = DbSkseFunctions.GetAllConstructibleObjects(none)
    If !ConObjs
        PrintMessage("Failed to retrieve ConstructibleObject forms")
        Return
    EndIf

    ; Iterate through all ConstructibleObject forms
    Int i = 0
    Int InvalidCount = 0
    While i < ConObjs.Length
        ConstructibleObject ConObj = ConObjs[i]
        If ConObj && (ConObj.GetResult() as Form) == none
            ; Log the invalid form
            PrintMessage("Removing invalid ConstructibleObject: " + self.GetFullID(ConObj))

            ; Disable the ConstructibleObject
            ConObj.SetWorkbenchKeyword(none) ; Remove workbench association
            PO3_SKSEFunctions.SetRecordFlag(ConObj, 0x00001000) ; Mark as deleted or invalid

            InvalidCount += 1
        EndIf
        i += 1
    EndWhile

    ; Report results
    PrintMessage("Removed " + InvalidCount + " invalid ConstructibleObject forms")
EndEvent

Event OnConsoleGetAllOutfitParts(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllOutfitParts [<Outfit akOutfit>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Outfit akOutfit = self.FormFromSArgument(sArgument, 1) as Outfit
  If akOutfit == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  int totalSlots = akOutfit.GetNumParts()
  int slotPart = 0

  If totalSlots <= 0
    PrintMessage("No outfit parts found for " + self.GetFullID(akOutfit))
    Return
  Else
    PrintMessage(totalslots + " outfit parts found for " + self.GetFullID(akOutfit))
  EndIf
  
  While slotPart < totalSlots
    PrintMessage("#" + slotPart + ": " + self.GetFullID(akOutfit.GetNthPart(slotPart)))
    slotPart += 1
  EndWhile
EndEvent

Event OnConsoleGetAllTexturePaths(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllTexturePaths [<TextureSet akTextureSet>]")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  TextureSet akTextureSet = self.FormFromSArgument(sArgument, 1) as TextureSet
  If akTextureSet == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  int totalSlots = akTextureSet.GetNumTexturePaths()
  int slotPart = 0

  If totalSlots <= 0
    PrintMessage("No texture paths found for " + self.GetFullID(akTextureSet))
    Return
  Else
    PrintMessage(totalslots + " texture paths found for " + self.GetFullID(akTextureSet))
  EndIf
  
  While slotPart < totalSlots
    PrintMessage("#" + slotPart + ": " + akTextureSet.GetNthTexturePath(slotPart))
    slotPart += 1
  EndWhile
EndEvent

Event OnConsoleGetAutorunLines(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAutorunLines")
  
  ; Define the file path
  String filePath = "Data/Autorun.txt"
  
  ; Check if the file exists
  If !FileExists(filePath)
    PrintMessage("FATAL ERROR: File does not exist: " + filePath)
    Return
  EndIf
  
  ; Read the entire file content
  String fileContent = ReadFromFile(filePath)
  
  ; Split the content into lines and display them
  String[] lines = StringUtil.Split(fileContent, "\n")
  Int lineNumber = 0
  While lineNumber < lines.Length
    PrintMessage("#" + lineNumber + ": " + lines[lineNumber])
    lineNumber += 1
  EndWhile
  
  PrintMessage("Total lines read: " + lineNumber)
EndEvent

Event OnConsoleAddAutorunLine(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddAutorunLine <line to add>")
  
  ; Check if the line to add is provided
  String lineToAdd = self.StringFromSArgument(sArgument, 1)
  If lineToAdd == ""
    PrintMessage("FATAL ERROR: No line provided to add")
    Return
  EndIf
  
  ; Define the file path
  String filePath = "Data/Autorun.txt"
  
  ; Append the line to the file
  Bool success = WriteToFile(filePath, lineToAdd + "\n", true, false) ; Append mode, no timestamp
  
  If success
    PrintMessage("Line added: " + lineToAdd)
  Else
    PrintMessage("FATAL ERROR: Failed to write to file: " + filePath)
  EndIf
EndEvent

Event OnConsoleRemoveAutorunLine(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAutorunLine <line number>")
  
  ; Check if the line number is provided
  Int lineNumber = self.IntFromSArgument(sArgument, 1)
  If lineNumber < 0
    PrintMessage("FATAL ERROR: Invalid line number")
    Return
  EndIf
  
  ; Define the file path
  String filePath = "Data/Autorun.txt"
  
  ; Check if the file exists
  If !FileExists(filePath)
    PrintMessage("FATAL ERROR: File does not exist: " + filePath)
    Return
  EndIf
  
  ; Read the entire file content
  String fileContent = ReadFromFile(filePath)
  
  ; Split the content into lines
  String[] lines = StringUtil.Split(fileContent, "\n")
  
  ; Check if the line number is valid
  If lineNumber >= lines.Length
    PrintMessage("FATAL ERROR: Line number out of range")
    Return
  EndIf
  
  ; Remove the specified line
  lines[lineNumber] = ""
  
  ; Rebuild the file content without the removed line
  String newContent = ""
  Int i = 0
  While i < lines.Length
    If lines[i] != ""
      newContent += lines[i] + "\n"
    EndIf
    i += 1
  EndWhile
  
  ; Write the new content back to the file
  Bool success = WriteToFile(filePath, newContent, false, false) ; Overwrite mode, no timestamp
  
  If success
    PrintMessage("Line " + lineNumber + " removed")
  Else
    PrintMessage("FATAL ERROR: Failed to write to file: " + filePath)
  EndIf
EndEvent

Event OnConsoleAddFormsToFormlist(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddFormsToFormlist(Formlist akFormList, Form akForm1, Form akForm2, Form akForm3, Form akForm4)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Formlist akFormList = self.FormFromSArgument(sArgument, 1) as Formlist
  Form akForm1 = self.FormFromSArgument(sArgument, 2) as Form
  Form akForm2 = self.FormFromSArgument(sArgument, 3) as Form
  Form akForm3 = self.FormFromSArgument(sArgument, 4) as Form
  Form akForm4 = self.FormFromSArgument(sArgument, 5) as Form

  If akFormList == none || (akForm1 == none && akForm2 == none && akForm3 == none && akForm4 == none)
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  
  If akForm1 != none
    akFormList.AddForm(akForm1)
    PrintMessage("Added " + self.GetFullID(akForm1) + " to " + self.GetFullID(akFormList))
  EndIf
  
  If akForm2 != none
    akFormList.AddForm(akForm2)
    PrintMessage("Added " + self.GetFullID(akForm2) + " to " + self.GetFullID(akFormList))
  EndIf
  
  If akForm3 != none
    akFormList.AddForm(akForm3)
    PrintMessage("Added " + self.GetFullID(akForm3) + " to " + self.GetFullID(akFormList))
  EndIf
  
  If akForm4 != none
    akFormList.AddForm(akForm4)
    PrintMessage("Added " + self.GetFullID(akForm4) + " to " + self.GetFullID(akFormList))
  EndIf
    
EndEvent

Event OnConsoleAddFormToFormlists(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddFormsToFormlists(Form akForm, Formlist akFormList1, Formlist akFormList2, Formlist akFormList3, Formlist akFormList4)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1) as Form
  Formlist akFormList1 = self.FormFromSArgument(sArgument, 2) as Formlist
  Formlist akFormList2 = self.FormFromSArgument(sArgument, 3) as Formlist
  Formlist akFormList3 = self.FormFromSArgument(sArgument, 4) as Formlist
  Formlist akFormList4 = self.FormFromSArgument(sArgument, 5) as Formlist

  If akForm == none || (akFormList1 == none && akFormList2 == none && akFormList3 == none && akFormList4 == none)
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If akFormList1 != none
    akFormList1.AddForm(akForm)
    PrintMessage("Added " + self.GetFullID(akForm) + " to " + self.GetFullID(akFormList1))
  EndIf
  
  If akFormList2 != none
    akFormList2.AddForm(akForm)
    PrintMessage("Added " + self.GetFullID(akForm) + " to " + self.GetFullID(akFormList2))
  EndIf
  
  If akFormList3 != none
    akFormList3.AddForm(akForm)
    PrintMessage("Added " + self.GetFullID(akForm) + " to " + self.GetFullID(akFormList3))
  EndIf
  
  If akFormList4 != none
    akFormList4.AddForm(akForm)
    PrintMessage("Added " + self.GetFullID(akForm) + " to " + self.GetFullID(akFormList4))
  EndIf
  
    
EndEvent

Event OnConsoleCopyKeywords(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: CopyKeywords(Form akSource, Form akTarget)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akSource = self.FormFromSArgument(sArgument, 1) as Form
  Form akTarget = self.FormFromSArgument(sArgument, 2) as Form

  If akSource == none || akTarget == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  Keyword[] sourceKeywords = akSource.GetKeywords()
  If sourceKeywords.Length == 0
    PrintMessage("Source " + self.GetFullID(akSource) +  "has no keywords ")
    Return
  EndIf

  Int i = 0
  While i < sourceKeywords.Length
    PO3_SKSEFunctions.AddKeywordToForm(akTarget, sourceKeywords[i])
    i += 1
  EndWhile

  PrintMessage("Copied " + sourceKeywords.Length + " keywords from " + self.GetFullID(akSource) + " to " + self.GetFullID(akTarget))
EndEvent

Event OnConsoleAddKeywordsToForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddKeywordsToForm(Form akForm, Keyword akKeyword1, Keyword akKeyword2, Keyword akKeyword3, Keyword akKeyword4)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1) as Form
  Keyword akKeyword1 = self.FormFromSArgument(sArgument, 2) as Keyword
  Keyword akKeyword2 = self.FormFromSArgument(sArgument, 3) as Keyword
  Keyword akKeyword3 = self.FormFromSArgument(sArgument, 4) as Keyword
  Keyword akKeyword4 = self.FormFromSArgument(sArgument, 5) as Keyword

  If akForm == none || (akKeyword1 == none && akKeyword2 == none && akKeyword3 == none && akKeyword4 == none)
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If akKeyword1 != none
    PO3_SKSEFunctions.AddKeywordToForm(akForm, akKeyword1)
    PrintMessage("Added " + self.GetFullID(akKeyword1) + " to " + self.GetFullID(akForm))
  EndIf

  If akKeyword2 != none
    PO3_SKSEFunctions.AddKeywordToForm(akForm, akKeyword2)
    PrintMessage("Added " + self.GetFullID(akKeyword2) + " to " + self.GetFullID(akForm))
  EndIf

  If akKeyword3 != none
    PO3_SKSEFunctions.AddKeywordToForm(akForm, akKeyword3)
    PrintMessage("Added " + self.GetFullID(akKeyword3) + " to " + self.GetFullID(akForm))
  EndIf

  If akKeyword4 != none
    PO3_SKSEFunctions.AddKeywordToForm(akForm, akKeyword4)
    PrintMessage("Added " + self.GetFullID(akKeyword4) + " to " + self.GetFullID(akForm))
  EndIf
      
EndEvent

Event OnConsoleRemoveKeywordsFromForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveKeywordsFromForm(Form akForm, Keyword akKeyword1, Keyword akKeyword2, Keyword akKeyword3, Keyword akKeyword4)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = self.FormFromSArgument(sArgument, 1) as Form
  Keyword akKeyword1 = self.FormFromSArgument(sArgument, 2) as Keyword
  Keyword akKeyword2 = self.FormFromSArgument(sArgument, 3) as Keyword
  Keyword akKeyword3 = self.FormFromSArgument(sArgument, 4) as Keyword
  Keyword akKeyword4 = self.FormFromSArgument(sArgument, 5) as Keyword

  If akForm == none || (akKeyword1 == none && akKeyword2 == none && akKeyword3 == none && akKeyword4 == none)
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If akKeyword1 != none
    PO3_SKSEFunctions.RemoveKeywordOnForm(akForm, akKeyword1)
    PrintMessage("Removed " + self.GetFullID(akKeyword1) + " from " + self.GetFullID(akForm))
  EndIf

  If akKeyword2 != none
    PO3_SKSEFunctions.RemoveKeywordOnForm(akForm, akKeyword2)
    PrintMessage("Removed " + self.GetFullID(akKeyword2) + " from " + self.GetFullID(akForm))
  EndIf

  If akKeyword3 != none
    PO3_SKSEFunctions.RemoveKeywordOnForm(akForm, akKeyword3)
    PrintMessage("Removed " + self.GetFullID(akKeyword3) + " from " + self.GetFullID(akForm))
  EndIf

  If akKeyword4 != none
    PO3_SKSEFunctions.RemoveKeywordOnForm(akForm, akKeyword4)
    PrintMessage("Removed " + self.GetFullID(akKeyword4) + " from " + self.GetFullID(akForm))
  EndIf
EndEvent

Event OnConsoleAddKeywordToForms(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddKeywordToForms(Keyword akKeyword, Form akForm1, Form akForm2, Form akForm3, Form akForm4)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Keyword akKeyword = self.FormFromSArgument(sArgument, 1) as Keyword
  Form akForm1 = self.FormFromSArgument(sArgument, 2) as Form
  Form akForm2 = self.FormFromSArgument(sArgument, 3) as Form
  Form akForm3 = self.FormFromSArgument(sArgument, 4) as Form
  Form akForm4 = self.FormFromSArgument(sArgument, 5) as Form

  If akKeyword == none || (akForm1 == none && akForm2 == none && akForm3 == none && akForm4 == none)
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If akForm1 != none
    PO3_SKSEFunctions.AddKeywordToForm(akForm1, akKeyword)
    PrintMessage("Added " + self.GetFullID(akKeyword) + " to " + self.GetFullID(akForm1))
  EndIf
  
  If akForm2 != none
    PO3_SKSEFunctions.AddKeywordToForm(akForm2, akKeyword)
    PrintMessage("Added " + self.GetFullID(akKeyword) + " to " + self.GetFullID(akForm2))
  EndIf
  
  If akForm3 != none
    PO3_SKSEFunctions.AddKeywordToForm(akForm3, akKeyword)
    PrintMessage("Added " + self.GetFullID(akKeyword) + " to " + self.GetFullID(akForm3))
  EndIf
  
  If akForm4 != none
    PO3_SKSEFunctions.AddKeywordToForm(akForm4, akKeyword)
    PrintMessage("Added " + self.GetFullID(akKeyword) + " to " + self.GetFullID(akForm4))
  EndIf

EndEvent

Event OnConsoleRemoveKeywordFromForms(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveKeywordFromForms(Keyword akKeyword, Form akForm1, Form akForm2, Form akForm3, Form akForm4)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Keyword akKeyword = self.FormFromSArgument(sArgument, 1) as Keyword
  Form akForm1 = self.FormFromSArgument(sArgument, 2) as Form
  Form akForm2 = self.FormFromSArgument(sArgument, 3) as Form
  Form akForm3 = self.FormFromSArgument(sArgument, 4) as Form
  Form akForm4 = self.FormFromSArgument(sArgument, 5) as Form

  If akKeyword == none || (akForm1 == none && akForm2 == none && akForm3 == none && akForm4 == none)
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  If akForm1 != none
    PO3_SKSEFunctions.RemoveKeywordOnForm(akForm1, akKeyword)
    PrintMessage("Removed " + self.GetFullID(akKeyword) + " from " + self.GetFullID(akForm1))
  EndIf
  
  If akForm2 != none
    PO3_SKSEFunctions.RemoveKeywordOnForm(akForm2, akKeyword)
    PrintMessage("Removed " + self.GetFullID(akKeyword) + " from " + self.GetFullID(akForm2))
  EndIf
  
  If akForm3 != none
    PO3_SKSEFunctions.RemoveKeywordOnForm(akForm3, akKeyword)
    PrintMessage("Removed " + self.GetFullID(akKeyword) + " from " + self.GetFullID(akForm3))
  EndIf
  
  If akForm4 != none
    PO3_SKSEFunctions.RemoveKeywordOnForm(akForm4, akKeyword)
    PrintMessage("Removed " + self.GetFullID(akKeyword) + " from " + self.GetFullID(akForm4))
  EndIf

EndEvent

Event OnConsoleFindEffectOnActor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: FindEffectOnActor(Actor akActor, String asName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor
  String asName
  If QtyPars == 1
    akActor = GetSelectedReference() as Actor
    asName = StringFromSArgument(sArgument, 1)
  ElseIf QtyPars == 2
    akActor = self.FormFromSArgument(sArgument, 1) as Actor
    asName = StringFromSArgument(sArgument, 2)
  EndIf
  
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  MagicEffect[] MGEFs = PO3_SKSEFunctions.GetActiveEffects(akActor)
  If MGEFs.Length == 0
    PrintMessage("No active effects found on " + self.GetFullID(akActor))
    Return
  EndIf

  Int i = 0
  While i < MGEFs.Length
    If StringUtil.Find(MGEFs[i].GetName(), asName) != -1
      PrintMessage("Found " + self.GetFullID(MGEFs[i]) + " on " + self.GetFullID(akActor))
      ActiveMagicEffect[] AMEs = PO3_SKSEFunctions.GetActiveMagicEffects(akActor, MGEFs[i])
      Int j = 0
      While j < AMEs.Length
        PrintMessage("  - Instance " + j + ":")
        PrintMessage("  - Magnitude: " + AMEs[j].GetMagnitude())
        PrintMessage("  - Caster: " + AMEs[j].GetCasterActor())
        string[] scripts = PO3_SKSEFunctions.GetScriptsAttachedToActiveEffect(AMEs[j])
        PrintMessage("  - Attached scripts: ")
        Int k = 0
        While k < scripts.Length
          PrintMessage("    - " + scripts[k])
          k += 1
        EndWhile
        j += 1
      EndWhile
    EndIf
    i += 1
  EndWhile
EndEvent

Event OnConsoleFindKeywordOnForm(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: FindKeywordOnForm(Form akForm, String asName)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm
  String asName
  If QtyPars == 1
    akForm = GetSelectedBase()
    asName = StringFromSArgument(sArgument, 1)
  ElseIf QtyPars == 2
    akForm = self.FormFromSArgument(sArgument, 1)
    asName = StringFromSArgument(sArgument, 2)
  EndIf
  Keyword[] keywords = akForm.GetKeywords()

  If keywords.Length == 0
    PrintMessage("No keywords found on " + self.GetFullID(akForm))
    Return
  EndIf

  Int i = 0
  While i < keywords.Length
    If StringUtil.Find(keywords[i].GetName(), asName) != -1
      PrintMessage("Found " + self.GetFullID(keywords[i]) + " on " + self.GetFullID(akForm))
    EndIf
    i += 1
  EndWhile

EndEvent

Event OnConsolePlaceBefore(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: PlaceBefore(Form akForm = GetSelectedBase(), ObjectReference akRef = PlayerRef, int aiDistance = 1, abFadeIn = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Form akForm = FormFromSArgument(sArgument, 1, GetSelectedBase())
  ObjectReference akRef = RefFromSArgument(sArgument, 2, PlayerRef)
  Int aiDistance = IntFromSArgument(sArgument, 3, 1)
  Bool abFadeIn = BoolFromSArgument(sArgument, 4, true)
  If akForm == none || akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  aiDistance = PapyrusUtil.ClampInt(aiDistance, 0, 100)
  ObjectReference newRef = RPDefault_Utility.PlaceInFrontOfMe(akForm, akRef, 1)
  PrintMessage("Duplicated " + self.GetFullID(akForm) + " as " + self.GetFullID(newRef) + " at " + self.GetFullID(akRef))
EndEvent

Event OnConsoleGetWornForms(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetWornForms(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Form[] wornForms = SPE_Actor.GetWornForms(akActor)
  If wornForms.Length == 0
    PrintMessage("No worn forms found on " + self.GetFullID(akActor))
    Return
  EndIf
  Int i = 0
  While i < wornForms.Length
    PrintMessage("#" + i + ": " + self.GetFullID(wornForms[i]))
    i += 1
  EndWhile

EndEvent

Event OnConsoleRemoveDecals(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveDecals(Actor akActor, Bool abIncludeWeapon = true)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = ConsoleUtil.GetSelectedReference() as Actor
  Bool abIncludeWeapon = BoolFromSArgument(sArgument, 1, true)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  SPE_ObjectRef.RemoveDecals(akActor, abIncludeWeapon)
EndEvent

Event OnConsoleGetRaceSlotMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRaceSlotMask(Race akRace)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  If akRace == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  int slotMask = DbSKSEFunctions.GetRaceSlotMask(akRace)
  PrintMessage("Slot mask of " + self.GetFullID(akRace) + " is " + slotMask)
EndEvent

Event OnConsoleSetRaceSlotMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetRaceSlotMask(Race akRace, int slotMask)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  int slotMask = self.IntFromSArgument(sArgument, 2)
  If akRace == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  DbSKSEFunctions.SetRaceSlotMask(akRace, slotMask)
  PrintMessage("Slot mask of " + self.GetFullID(akRace) + " set to " + slotMask)
EndEvent

Event OnConsoleAddRaceSlotToMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddSlotToMask(Race akRace, int slotMask)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  int slotMask = self.IntFromSArgument(sArgument, 2)
  If akRace == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  DbSKSEFunctions.AddRaceSlotToMask(akRace, slotMask)
  PrintMessage("Slot mask of " + self.GetFullID(akRace) + " added " + slotMask)
EndEvent 

Event OnConsoleRemoveRaceSlotFromMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveRaceSlotFromMask(Race akRace, int slotMask)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  int slotMask = self.IntFromSArgument(sArgument, 2)
  If akRace == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  DbSKSEFunctions.RemoveRaceSlotFromMask(akRace, slotMask)
  PrintMessage("Slot mask of " + self.GetFullID(akRace) + " removed " + slotMask)
EndEvent

Event OnConsoleGetAllArmorsForSlotMask(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetAllArmorsForSlotMask(Int aiSlot)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Int aiSlot = self.IntFromSArgument(sArgument, 1)
  Int slotMask = Armor.GetMaskForSlot(aiSlot)
  Armor[] armors = DbSKSEFunctions.GetAllArmorsForSlotMask(slotMask)
  If armors.Length == 0
    PrintMessage("No armors found for slot.")
    Return
  EndIf
  Int i = 0
  While i < armors.Length
    PrintMessage("#" + i + ": " + self.GetFullID(armors[i]))
    i += 1
  EndWhile

EndEvent

Event OnConsoleAddAdditionalRaceToArmorAddon(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AddAdditionalRaceToArmorAddon(ArmorAddon akArmorAddon, Race akRace)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ArmorAddon akArmorAddon = self.FormFromSArgument(sArgument, 1) as ArmorAddon
  Race akRace = self.FormFromSArgument(sArgument, 2) as Race
  If akArmorAddon == none || akRace == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  DbSKSEFunctions.AddAdditionalRaceToArmorAddon(akArmorAddon, akRace)
  PrintMessage("Added " + self.GetFullID(akRace) + " to " + self.GetFullID(akArmorAddon))
EndEvent

Event OnConsoleRemoveAdditionalRaceFromArmorAddon(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RemoveAdditionalRaceFromArmorAddon(ArmorAddon akArmorAddon, Race akRace)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  ArmorAddon akArmorAddon = self.FormFromSArgument(sArgument, 1) as ArmorAddon
  Race akRace = self.FormFromSArgument(sArgument, 2) as Race
  If akArmorAddon == none || akRace == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  DbSKSEFunctions.RemoveAdditionalRaceFromArmorAddon(akArmorAddon, akRace)
  PrintMessage("Remove " + self.GetFullID(akRace) + " from " + self.GetFullID(akArmorAddon))
EndEvent

Event OnConsoleRaceSlotMaskHasPartOf(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: RaceSlotMaskHasPartOf(Race akRace, int slotMask)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  Int slotMask = self.IntFromSArgument(sArgument, 2)

  If akRace == none
    PrintMessage("FATAL ERROR: Race retrieval failed.")
    Return
  EndIf

  Bool result = DbSKSEFunctions.RaceSlotMaskHasPartOf(akRace, slotMask)
  PrintMessage("RaceSlotMaskHasPartOf: " + result)
EndEvent

Event OnConsoleArmorSlotMaskHasPartOf(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ArmorSlotMaskHasPartOf(Armor akArmor, int slotMask)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  Armor akArmor = self.FormFromSArgument(sArgument, 1) as Armor
  Int slotMask = self.IntFromSArgument(sArgument, 2)

  If akArmor == none
    PrintMessage("FATAL ERROR: Armor retrieval failed.")
    Return
  EndIf

  Bool result = DbSKSEFunctions.ArmorSlotMaskHasPartOf(akArmor, slotMask)
  PrintMessage("ArmorSlotMaskHasPartOf: " + result)
EndEvent

Event OnConsoleArmorAddonSlotMaskHasPartOf(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ArmorAddonSlotMaskHasPartOf(ArmorAddon akArmorAddon, int slotMask)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ArmorAddon akArmorAddon = self.FormFromSArgument(sArgument, 1) as ArmorAddon
  Int slotMask = self.IntFromSArgument(sArgument, 2)

  If akArmorAddon == none
    PrintMessage("FATAL ERROR: ArmorAddon retrieval failed.")
    Return
  EndIf

  Bool result = DbSKSEFunctions.ArmorAddonSlotMaskHasPartOf(akArmorAddon, slotMask)
  PrintMessage("ArmorAddonSlotMaskHasPartOf: " + result)
EndEvent

Event OnConsoleGetArmorAddonRaces(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetArmorAddonRaces(ArmorAddon akArmorAddon)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ArmorAddon akArmorAddon = self.FormFromSArgument(sArgument, 1) as ArmorAddon

  If akArmorAddon == none
    PrintMessage("FATAL ERROR: ArmorAddon retrieval failed.")
    Return
  EndIf

  Race[] result = DbSKSEFunctions.GetArmorAddonRaces(akArmorAddon)
  PrintMessage("GetArmorAddonRaces: " + result)
EndEvent

Event OnConsoleArmorAddonHasRace(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ArmorAddonHasRace(ArmorAddon akArmorAddon, Race akRace)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ArmorAddon akArmorAddon = self.FormFromSArgument(sArgument, 1) as ArmorAddon
  Race akRace = self.FormFromSArgument(sArgument, 2) as Race

  If akArmorAddon == none || akRace == none
    PrintMessage("FATAL ERROR: ArmorAddon or Race retrieval failed.")
    Return
  EndIf

  Bool result = DbSKSEFunctions.ArmorAddonHasRace(akArmorAddon, akRace)
  PrintMessage("ArmorAddonHasRace: " + result)
EndEvent

Event OnConsoleSetMapMarkerVisible(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetMapMarkerVisible(ObjectReference MapMarker, bool visible)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference MapMarker = self.FormFromSArgument(sArgument, 1) as ObjectReference
  Bool visible = self.BoolFromSArgument(sArgument, 2)

  If MapMarker == none
    PrintMessage("FATAL ERROR: MapMarker retrieval failed.")
    Return
  EndIf

  Bool result = DbSKSEFunctions.SetMapMarkerVisible(MapMarker, visible)
  PrintMessage("SetMapMarkerVisible: " + result)
EndEvent

Event OnConsoleSetCanFastTravelToMarker(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetCanFastTravelToMarker(ObjectReference MapMarker, bool canTravelTo)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  ObjectReference MapMarker = self.FormFromSArgument(sArgument, 1) as ObjectReference
  Bool canTravelTo = self.BoolFromSArgument(sArgument, 2)

  If MapMarker == none
    PrintMessage("FATAL ERROR: MapMarker retrieval failed.")
    Return
  EndIf

  Bool result = DbSKSEFunctions.SetCanFastTravelToMarker(MapMarker, canTravelTo)
  PrintMessage("SetCanFastTravelToMarker: " + result)
EndEvent

Event OnConsoleGetKnownEnchantments(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetKnownEnchantments()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Enchantment[] enchs = DbSKSEFunctions.GetKnownEnchantments()
  If enchs.Length == 0
    PrintMessage("No armors found for slot.")
    Return
  EndIf
  Int i = 0
  While i < enchs.Length
    PrintMessage("#" + i + ": " + self.GetFullID(enchs[i]))
    i += 1
  EndWhile

EndEvent

Event OnConsoleReload(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: Reload()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf  
  DbSKSEFunctions.LoadMostRecentSaveGame()
EndEvent

Event OnConsoleGetRaceSlots(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRaceSlots(Race akRace)")
  If self.StringFromSArgument(sArgument, 1) == "?"
      Return
  EndIf
  
  Race akRace = self.FormFromSArgument(sArgument, 1) as Race
  If akRace == none
      PrintMessage("FATAL ERROR: FormID retrieval failed")
      Return
  EndIf
  
  int slotMask = DbSKSEFunctions.GetRaceSlotMask(akRace)
  PrintMessage("Slot mask of " + self.GetFullID(akRace) + " is " + slotMask)
  
  ; Print the individual slots that are set
  PrintMessage("Active slots:")
  bool anySlot = false
  
  ; Check each slot from 30 to 61
  int currentSlot = 30
  while currentSlot <= 61
      int mask = Math.LeftShift(1, currentSlot - 30) ; Calculate the mask for this slot
      if Math.LogicalAnd(slotMask, mask) != 0
          PrintMessage("  Slot " + currentSlot + " is active")
          anySlot = true
      endif
      currentSlot += 1
  endWhile
  
  if !anySlot
      PrintMessage("  No slots are active")
  endif
EndEvent

Event OnConsoleStartWhiterunAttack(String EventName, String sArgument, Float fArgument, Form Sender)
    Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
    PrintMessage("Format: StartWhiterunAttack()")
    If self.StringFromSArgument(sArgument, 1) == "?"
        Return
    EndIf
    Quest CW03 = PO3_SKSEFunctions.GetFormFromEditorID("CW03") as Quest
    if CW03 == none
        PrintMessage("FATAL ERROR: CW03 retrieval failed")
        Return
    EndIf
    (CW03 as CW03Script).StartWhiterunAttack()
    PrintMessage("Started Whiterun attack")
EndEvent

Event OnConsoleOpenCustomSkillMenu(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: OpenCustomSkillMenu(string asSkillId)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  String asSkillId = self.StringFromSArgument(sArgument, 1)
  CustomSkills.OpenCustomSkillMenu(asSkillId)
  PrintMessage("Opened custom skill menu for skill: " + asSkillId)
EndEvent

Event OnConsoleShowTrainingMenu(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ShowTrainingMenu(string asSkillId, int aiMaxLevel, Actor akTrainer)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  String asSkillId = self.StringFromSArgument(sArgument, 1)
  Int aiMaxLevel = self.IntFromSArgument(sArgument, 2)
  Actor akTrainer = self.FormFromSArgument(sArgument, 3) as Actor

  If akTrainer == none
    PrintMessage("FATAL ERROR: Trainer retrieval failed.")
    Return
  EndIf

  CustomSkills.ShowTrainingMenu(asSkillId, aiMaxLevel, akTrainer)
  PrintMessage("Displayed training menu for skill: " + asSkillId + " with max level: " + aiMaxLevel + " and trainer: " + self.GetFullID(akTrainer))
EndEvent

Event OnConsoleAdvanceSkill(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: AdvanceSkill(string asSkillId, float afMagnitude)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  String asSkillId = self.StringFromSArgument(sArgument, 1)
  Float afMagnitude = self.FloatFromSArgument(sArgument, 2)

  CustomSkills.AdvanceSkill(asSkillId, afMagnitude)
  PrintMessage("Advanced skill: " + asSkillId + " by magnitude: " + afMagnitude)
EndEvent

Event OnConsoleIncrementSkill(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: IncrementSkill(string asSkillId, int aiCount)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  String asSkillId = self.StringFromSArgument(sArgument, 1)
  Int aiCount = self.IntFromSArgument(sArgument, 2, 1)

  CustomSkills.IncrementSkillBy(asSkillId, aiCount)
  PrintMessage("Incremented skill: " + asSkillId + " by " + aiCount + " points")
EndEvent

Event OnConsoleGetSkillName(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSkillName(string asSkillId)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  String asSkillId = self.StringFromSArgument(sArgument, 1)
  String result = CustomSkills.GetSkillName(asSkillId)
  PrintMessage("Skill name for ID " + asSkillId + " is: " + result)
EndEvent

Event OnConsoleGetSkillLevel(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetSkillLevel(string asSkillId)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf

  String asSkillId = self.StringFromSArgument(sArgument, 1)
  Int result = CustomSkills.GetSkillLevel(asSkillId)
  PrintMessage("Skill level for ID " + asSkillId + " is: " + result)
EndEvent

Event OnConsoleSetInChargen(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetInChargen(bool abDisableSaving = false, bool abDisableWaiting = false, bool abShowControlsDisabledMessage = false)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  bool abDisableSaving = self.BoolFromSArgument(sArgument, 1, false)
  bool abDisableWaiting = self.BoolFromSArgument(sArgument, 2, false)
  bool abShowControlsDisabledMessage = self.BoolFromSArgument(sArgument, 3, false)
  Game.SetInChargen(abDisableSaving, abDisableWaiting, abShowControlsDisabledMessage)
  PrintMessage("Set in chargen")
EndEvent

Event OnConsolePacifyActor(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: Pacify(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = GetSelectedReference() as Actor
  If QtyPars > 0
    akActor = self.FormFromSArgument(sArgument, 1) as Actor
  EndIf
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.StopCombat()
  akActor.StopCombatAlarm()
  Faction[] factions = akActor.GetFactions(-128, 127)
  if PlayerFaction == none
    PrintMessage("FATAL ERROR: PlayerFaction retrieval failed")
    Return
  EndIf
  Int i = 0
  Int L = factions.Length
  While i < L
    if factions[i].GetReaction(PlayerFaction) < 0
      akActor.RemoveFromFaction(factions[i])
      PrintMessage("Removed " + self.GetFullID(akActor) + " from " + self.GetFullID(factions[i]))
    EndIf
    i += 1
  EndWhile
  PrintMessage("Pacified " + self.GetFullID(akActor))
EndEvent

Event OnConsoleWhyHostile(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: WhyHostile(Actor akReference = PlayerRef, Actor akHostile = GetConsoleReference())")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akHostile = GetSelectedReference() as Actor
  Actor akReference = Game.GetPlayer()
  If QtyPars == 1
    akReference = self.FormFromSArgument(sArgument, 1) as Actor
  ElseIf QtyPars == 2
    akReference = self.FormFromSArgument(sArgument, 1) as Actor
    akHostile = self.FormFromSArgument(sArgument, 2) as Actor
  EndIf

  If akHostile.GetRelationshipRank(akReference) < 0
    PrintMessage("Relationship rank is " + akHostile.GetRelationshipRank(Game.GetPlayer()) )
  EndIf
  
  Faction[] factions = akHostile.GetFactions(-128, 127)
  if PlayerFaction == none
    PrintMessage("FATAL ERROR: PlayerFaction retrieval failed")
    Return
  EndIf
  Int i = 0
  Int L = factions.Length
  While i < L
    if factions[i].GetReaction(PlayerFaction) < 0
      PrintMessage(self.GetFullID(akHostile) + " is on hostile faction " + self.GetFullID(factions[i]))
    EndIf
    i += 1
  EndWhile

EndEvent

Event OnConsoleGetLightingTemplate(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetLightingTemplate(Cell akCell)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Cell akCell = self.FormFromSArgument(sArgument, 1) as Cell
  if akCell == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  LightingTemplate template = PO3_SKSEFunctions.GetLightingTemplate(akCell)
  PrintMessage("Lighting template: " + self.GetFullID(template))
EndEvent

Event OnConsoleSetLightingTemplate(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetLightingTemplate(Cell akCell, LightingTemplate akTemplate)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Cell akCell = self.FormFromSArgument(sArgument, 1) as Cell
  LightingTemplate akTemplate = self.FormFromSArgument(sArgument, 2) as LightingTemplate
  if akCell == none || akTemplate == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  PO3_SKSEFunctions.SetLightingTemplate(akCell, akTemplate)
  PrintMessage("Set lighting template " + self.GetFullID(akTemplate) + " on " + self.GetFullID(akCell))
EndEvent

Event OnConsoleGetVendorFactionContainer(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetVendorFactionContainer(Actor akActor)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = GetSelectedReference() as Actor
  If QtyPars == 1
    akActor = self.RefFromSArgument(sArgument, 1) as Actor
  EndIf
  if akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  Faction resultFaction = PO3_SKSEFunctions.GetVendorFaction(akActor)
  ObjectReference result = PO3_SKSEFunctions.GetVendorFactionContainer(resultFaction)
  PrintMessage("Vendor faction container: " + self.GetFullID(result))
EndEvent



Event OnConsoleGetRefNodeNames(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: GetRefNodeNames(ObjectReference akRef = GetSelectedReference(), String asSearchString, bool abFirstPerson = false)")

  PrintMessage("NODE NAMES")
  PrintMessage("===================================")
  ObjectReference akRef = GetSelectedReference()
  String searchTerm = self.StringFromSArgument(sArgument, 1)
  Bool abFirstPerson = self.BoolFromSArgument(sArgument, 2, false)
  If QtyPars == 3
    akRef = self.RefFromSArgument(sArgument, 1) as ObjectReference
    searchTerm = self.StringFromSArgument(sArgument, 2)
    abFirstPerson = self.BoolFromSArgument(sArgument, 3, false)
  EndIf
  If akRef == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  String[] nodeNames = DbSKSEFunctions.GetAll3DNodeNamesForRef(akRef, abFirstPerson)
  Bool found = false
  Int i = 0

  While i < nodeNames.Length
    If StringUtil.Find(nodeNames[i], searchTerm) != -1 || QtyPars == 0
      PrintMessage(nodeNames[i])
      found = true
    EndIf
    i += 1
  Endwhile

  if !found
    PrintMessage("No matching node names found")
  EndIf
  PrintMessage("===================================")
EndEvent

Event OnConsoleSetExpressionPhoneme(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetExpressionPhoneme(int aiIndex, float afValue)")
    PrintMessage("EXPRESSION PHONEME INDEX")
    PrintMessage("===================")
    PrintMessage("0 - Aah")
    PrintMessage("1 - BigAah")
    PrintMessage("2 - BMP")
    PrintMessage("3 - ChJSh")
    PrintMessage("4 - DST")
    PrintMessage("5 - Eee")
    PrintMessage("6 - Eh")
    PrintMessage("7 - FV")
    PrintMessage("8 - I")
    PrintMessage("9 - K")
    PrintMessage("10 - N")
    PrintMessage("11 - Oh")
    PrintMessage("12 - OohQ")
    PrintMessage("13 - R")
    PrintMessage("14 - Th")
    PrintMessage("15 - W")
    PrintMessage("===================")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = GetSelectedReference() as Actor
  Int aiIndex = self.IntFromSArgument(sArgument, 1)
  Float afValue = self.FloatFromSArgument(sArgument, 2, 0.0)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf

  akActor.SetExpressionPhoneme(aiIndex, afValue)
  PrintMessage("Set expression phoneme override " + aiIndex + " on " + self.GetFullID(akActor))
EndEvent

Event OnConsoleSetExpressionModifier(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: SetExpressionModifier(int aiIndex, float afValue)")
    PrintMessage("EXPRESSION MODIFIER NDEX")
    PrintMessage("===================")
    PrintMessage("0 - BlinkLeft")
    PrintMessage("1 - BlinkRight")
    PrintMessage("2 - BrowDownLeft")
    PrintMessage("3 - BrowDownRight")
    PrintMessage("4 - BrowInLeft")
    PrintMessage("5 - BrowInRight")
    PrintMessage("6 - BrowUpLeft")
    PrintMessage("7 - BrowUpRight")
    PrintMessage("8 - LookDown")
    PrintMessage("9 - LookLeft")
    PrintMessage("10 - LookRight")
    PrintMessage("11 - LookUp")
    PrintMessage("12 - SquintLeft")
    PrintMessage("13 - SquintRight")
    PrintMessage("14 - HeadPitch")
    PrintMessage("15 - HeadRoll")
    PrintMessage("16 - HeadYaw")
    PrintMessage("===================")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = GetSelectedReference() as Actor
  Int aiIndex = self.IntFromSArgument(sArgument, 1)
  Float afValue = self.FloatFromSArgument(sArgument, 2, 0.0)
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.SetExpressionModifier(aiIndex, afValue)
  PrintMessage("Set expression modifier override " + aiIndex + " on " + self.GetFullID(akActor))
EndEvent

Event OnConsoleResetExpressionOverrides(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ResetExpressionOverrides()")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  Actor akActor = GetSelectedReference() as Actor
  If akActor == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  akActor.ResetExpressionOverrides()
  PrintMessage("Reset expression overrides on " + self.GetFullID(akActor))
EndEvent

Event OnConsoleShowAsHelpMessage(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ShowAsHelpMessage(Message afMessage, String asEvent, float afDuration, float afInterval, int aiMaxTimes)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  Endif
  Message afMessage = self.FormFromSArgument(sArgument, 1) as Message
  String asEvent = self.StringFromSArgument(sArgument, 2)
  Float afDuration = self.FloatFromSArgument(sArgument, 3, 0.0)
  Float afInterval = self.FloatFromSArgument(sArgument, 4, 0.0)
  Int aiMaxTimes = self.IntFromSArgument(sArgument, 5, 0)
  If afMessage == none
    PrintMessage("FATAL ERROR: FormID retrieval failed")
    Return
  EndIf
  afMessage.ShowAsHelpMessage(asEvent, afDuration, afInterval, aiMaxTimes)
  PrintMessage("Showed help message: " + asEvent)
EndEvent

Event OnConsoleResetHelpMessage(String EventName, String sArgument, Float fArgument, Form Sender)
  Int QtyPars = GetDebug(EventName, sArgument, fArgument, Sender)
  PrintMessage("Format: ResetHelpMessage(String asEvent)")
  If self.StringFromSArgument(sArgument, 1) == "?"
    Return
  EndIf
  String asEvent = self.StringFromSArgument(sArgument, 1)
  Message.ResetHelpMessage(asEvent)
  PrintMessage("Reset help message")
EndEvent


;
; Misc
;

String Function DoubleQuote()
  
  Return "\""
EndFunction
