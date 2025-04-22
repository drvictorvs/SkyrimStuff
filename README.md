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

Implemented Functions
===


|Term                                        |Type   |Topics                                      |
|:-------------------------------------------|:------|:-------------------------------------------|
|GetActorWarmthRating                        |Getter |Actor                                       |
|ResetActor3D                                |Action |Actor                                       |
|SetActorOwner                               |Setter |Actor                                       |
|FreezeActor                                 |Action |Actor                                       |
|CalmActor                                   |Action |Actor                                       |
|CalmActor                                   |Action |Actor                                       |
|SetAttackActorOnSight                       |Setter |Actor                                       |
|GetActorOwner                               |Getter |Actor                                       |
|PushActorAway                               |Action |Actor                                       |
|ClearKeepOffsetFromActor                    |Action |Actor                                       |
|GetActorbaseDeadCount                       |Getter |Actor                                       |
|GetActorbaseSex                             |Getter |Actor                                       |
|SetActorbaseInvulnerable                    |Setter |Actor                                       |
|GetActorbaseVoiceType                       |Getter |Actor                                       |
|SetActorbaseVoiceType                       |Setter |Actor                                       |
|GetActorbaseCombatStyle                     |Getter |Actor                                       |
|SetActorbaseCombatStyle                     |Setter |Actor                                       |
|GetActorDialogueTarget                      |Getter |Actor                                       |
|SetActorCalmed                              |Setter |Actor                                       |
|SetActorSex                                 |Setter |Actor                                       |
|FindEffectOnActor                           |Action |Actor                                       |
|PacifyActor                                 |Action |Actor                                       |
|GetActorbaseSkin                            |Getter |Actor, Customization                        |
|SetActorbaseSkin                            |Setter |Actor, Customization                        |
|GetActorbaseWeight                          |Getter |Actor, Customization                        |
|SetActorbaseWeight                          |Setter |Actor, Customization                        |
|CanModifyActorTNG                           |Action |Actor, Customization                        |
|GetTNGActorAddons                           |Getter |Actor, Customization                        |
|GetTNGActorAddon                            |Getter |Actor, Customization                        |
|SetTNGActorAddon                            |Setter |Actor, Customization                        |
|GetTNGActorSize                             |Getter |Actor, Customization                        |
|SetTNGActorSize                             |Setter |Actor, Customization                        |
|CheckTNGActors                              |Action |Actor, Customization                        |
|TNGActorItemsInfo                           |Action |Actor, Customization, Debug                 |
|SetActorbaseOutfit                          |Setter |Actor, Customization, Outfit                |
|UnsetActorbaseOutfit                        |Action |Actor, Customization, Outfit                |
|GetActorValueInfoByName                     |Getter |Actor, Debug                                |
|GetActorFactions                            |Getter |Actor, Faction                              |
|GetMagicEffectPrimaryActorValue             |Getter |Actor, Magic Effect                         |
|GetMagicEffectySecondaryActorValue          |Getter |Actor, Magic Effect                         |
|SetActorRefraction                          |Setter |Actor, Reference                            |
|GetActorRefraction                          |Getter |Actor, Reference                            |
|GetActorPlayableSpells                      |Getter |Actor, Spell                                |
|GetActorbaseFaceTextureSet                  |Getter |Actor, TextureSet                           |
|SetActorbaseFaceTextureSet                  |Setter |Actor, TextureSet                           |
|GetABFacePreset                             |Getter |ActorBase                                   |
|SetABFacePreset                             |Setter |ActorBase                                   |
|GetABTemplate                               |Getter |ActorBase                                   |
|GetABFaceMorph                              |Getter |ActorBase, Body                             |
|SetABFaceMorph                              |Setter |ActorBase, Body                             |
|GetABClass                                  |Getter |ActorBase, Class                            |
|SetABClass                                  |Setter |ActorBase, Class                            |
|GetABSkinFar                                |Getter |ActorBase, Customization                    |
|SetABSkinFar                                |Setter |ActorBase, Customization                    |
|GetABNumOverlayHeadParts                    |Getter |ActorBase, Customization, HeadPart          |
|GetABNthOverlayHeadPart                     |Getter |ActorBase, Customization, HeadPart          |
|GetABIndexOfOverlayHeadPartByType           |Getter |ActorBase, Customization, HeadPart          |
|GetABNumHeadParts                           |Getter |ActorBase, HeadPart                         |
|GetABNthHeadPart                            |Getter |ActorBase, HeadPart                         |
|SetABNthHeadPart                            |Setter |ActorBase, HeadPart                         |
|GetABIndexOfHeadPartByType                  |Getter |ActorBase, HeadPart                         |
|GetABSpells                                 |Getter |ActorBase, Spell                            |
|RestoreColdLevel                            |Action |ActorValue                                  |
|RestoreHungerLevel                          |Action |ActorValue                                  |
|RestoreExhaustionLevel                      |Action |ActorValue                                  |
|QueryStat                                   |Action |ActorValue                                  |
|SetMiscStat                                 |Getter |ActorValue                                  |
|SendLycanthropyStateChanged                 |Action |ActorValue                                  |
|AdvanceCustomSkill                          |Action |ActorValue                                  |
|IncrementCustomSkill                        |Action |ActorValue                                  |
|GetTNGAddonStatus                           |Getter |ActorValue, Customization                   |
|SetTNGAddonStatus                           |Setter |ActorValue, Customization                   |
|GetMusicTypeStatus                          |Getter |ActorValue, Music                           |
|OpenCustomSkillMenu                         |Action |ActorValue, UI                              |
|SendVampirismStateChanged                   |Getter |ActorValue, Vampire                         |
|GetPotionNthEffectArea                      |Getter |Alchemy                                     |
|SetPotionNthEffectArea                      |Setter |Alchemy                                     |
|GetPotionNthEffectMagnitude                 |Getter |Alchemy                                     |
|SetPotionNthEffectMagnitude                 |Setter |Alchemy                                     |
|GetPotionNthEffectDuration                  |Getter |Alchemy                                     |
|SetPotionNthEffectDuration                  |Setter |Alchemy                                     |
|CastPotion                                  |Action |Alchemy, Spell                              |
|PlayIdleWithTarget                          |Action |Animation                                   |
|GetActiveGamebryoAnimation                  |Getter |Animation                                   |
|PlayIdle                                    |Action |Animation                                   |
|PlayIdleWithTarget                          |Action |Animation                                   |
|PlaySubGraphAnimation                       |Action |Animation                                   |
|PlayAnimation                               |Action |Animation                                   |
|PlayAnimationAndWait                        |Action |Animation                                   |
|PlayGamebryoAnimation                       |Action |Animation                                   |
|PlaySyncedAnimationSS                       |Action |Animation                                   |
|PlaySyncedAnimationAndWaitSS                |Action |Animation                                   |
|SetAnimationVariableBool                    |Setter |Animation                                   |
|SetAnimationVariableInt                     |Setter |Animation                                   |
|SetAnimationVariableFloat                   |Setter |Animation                                   |
|SetSubGraphFloatVariable                    |Setter |Animation                                   |
|GetAnimationEventName                       |Getter |Animation                                   |
|GetAnimationFileName                        |Getter |Animation                                   |
|AddPackageIdle                              |Setter |Animation, Package                          |
|RemovePackageIdle                           |Setter |Animation, Package                          |
|IdleHelp                                    |Action |Animation, Reference                        |
|GetSlotMask                                 |Getter |Armor                                       |
|SetSlotMask                                 |Setter |Armor                                       |
|AddSlotToMask                               |Setter |Armor                                       |
|RemoveSlotFromMask                          |Setter |Armor                                       |
|GetMaskForSlot                              |Getter |Armor                                       |
|GetArmorModelPath                           |Getter |Armor                                       |
|SetArmorModelPath                           |Setter |Armor                                       |
|GetArmorIconPath                            |Getter |Armor                                       |
|SetArmorIconPath                            |Setter |Armor                                       |
|GetArmorMessageIconPath                     |Getter |Armor                                       |
|SetArmorMessageIconPath                     |Setter |Armor                                       |
|GetArmorWarmthRating                        |Getter |Armor                                       |
|GetArmorArmorRating                         |Getter |Armor                                       |
|SetArmorArmorRating                         |Setter |Armor                                       |
|SetSILNakedSlotMask                         |Setter |Armor                                       |
|ArmorSlotMaskHasPartOf                      |Getter |Armor                                       |
|GetArmorAddonModelPath                      |Getter |Armor Addon, Armor                          |
|SetArmorAddonModelPath                      |Setter |Armor Addon, Armor                          |
|GetArmorNumArmorAddons                      |Getter |Armor Addon, Armor                          |
|GetArmorNthArmorAddon                       |Getter |Armor Addon, Armor                          |
|GetArmorModelArmorAddons                    |Getter |Armor Addon, Armor                          |
|GetArmorAddons                              |Getter |Armor Addon, Armor                          |
|GetArmorAddonSlotMask                       |Getter |Armor Addon, Armor                          |
|SetArmorAddonSlotMask                       |Setter |Armor Addon, Armor                          |
|AddArmorAddonSlotToMask                     |Setter |Armor Addon, Armor                          |
|RemoveArmorAddonSlotFromMask                |Setter |Armor Addon, Armor                          |
|ArmorAddonSlotMaskHasPartOf                 |Getter |Armor Addon, Armor                          |
|RemoveArmorAddonOverride                    |Setter |Armor Addon, Armor, NiOverride              |
|AddAdditionalRaceToArmorAddon               |Setter |Armor Addon, Armor, Race                    |
|RemoveAdditionalRaceFromArmorAddon          |Setter |Armor Addon, Armor, Race                    |
|GetArmorAddonRaces                          |Getter |Armor Addon, Armor, Race                    |
|ArmorAddonHasRace                           |Getter |Armor Addon, Armor, Race                    |
|GetArmorAddonModelNumTextureSets            |Getter |Armor Addon, Armor, TextureSet              |
|GetArmorAddonModelNthTextureSet             |Getter |Armor Addon, Armor, TextureSet              |
|SetArmorAddonModelNthTextureSet             |Setter |Armor Addon, Armor, TextureSet              |
|GetArmorWeightClass                         |Getter |Armor, Class, Customization                 |
|SetArmorWeightClass                         |Setter |Armor, Class, Customization                 |
|GetTNGSlot52Mods                            |Getter |Armor, Customization                        |
|TNGSlot52ModBehavior                        |Action |Armor, Customization                        |
|FindAllArmorsForSlot                        |Action |Armor, Debug                                |
|GetAllArmorsForSlotMask                     |Getter |Armor, Debug                                |
|RemoveAllArmorReferenceOverrides            |Setter |Armor, Debug, NiOverride, Reference         |
|GetArmorEnchantment                         |Getter |Armor, Enchantment                          |
|GetRaceSlotMask                             |Getter |Armor, Race                                 |
|SetRaceSlotMask                             |Setter |Armor, Race                                 |
|AddRaceSlotToMask                           |Setter |Armor, Race                                 |
|GetRaceSlotMask                             |Getter |Armor, Race                                 |
|SetRaceSlotMask                             |Setter |Armor, Race                                 |
|AddRaceSlotToMask                           |Setter |Armor, Race                                 |
|RemoveRaceSlotFromMask                      |Setter |Armor, Race                                 |
|RaceSlotMaskHasPartOf                       |Getter |Armor, Race                                 |
|GetRaceSlots                                |Getter |Armor, Race                                 |
|SlotHelp                                    |Action |Armor, Reference                            |
|ReplaceArmorTextureSet                      |Setter |Armor, TextureSet                           |
|GetEquippedArmorInSlot                      |Getter |Armor, UI                                   |
|StopArtObject                               |Action |Art Model                                   |
|SetArtObject                                |Setter |Art Model                                   |
|GetHitEffectArt                             |Getter |Art Model                                   |
|SetArtModelPath                             |Setter |Art Model                                   |
|SetHitEffectArt                             |Setter |Art Model                                   |
|GetArtModelPath                             |Getter |Art Model                                   |
|GetVisualEffectArtObject                    |Getter |Art Model                                   |
|SetVisualEffectArtObject                    |Getter |Art Model                                   |
|GetAllArtObjects                            |Getter |Art Model, Debug                            |
|GetEnchantArt                               |Getter |Art Model, Enchantment                      |
|SetEnchantArt                               |Setter |Art Model, Enchantment                      |
|GetHazardArt                                |Getter |Art Model, Hazard                           |
|SetHazardArt                                |Setter |Art Model, Hazard                           |
|GetCastingArt                               |Getter |Art Model, Spell                            |
|SetCastingArt                               |Setter |Art Model, Spell                            |
|GetArtObjectNthTextureSet                   |Getter |Art Model, TextureSet                       |
|SetArtObjectNthTextureSet                   |Setter |Art Model, TextureSet                       |
|ToggleChildNode                             |Action |Body                                        |
|GetNodePropertyFloat                        |Getter |Body                                        |
|GetNodePropertyInt                          |Getter |Body                                        |
|GetNodePropertyBool                         |Getter |Body                                        |
|GetNodePropertyString                       |Getter |Body                                        |
|QueueNiNodeUpdate                           |Action |Body                                        |
|MoveToNode                                  |Action |Body                                        |
|GetBodyMorph                                |Getter |Body                                        |
|SetBodyMorph                                |Setter |Body                                        |
|RemoveAllNodeReferenceOverrides             |Setter |Body, Debug, NiOverride, Reference          |
|HasNodeOverride                             |Getter |Body, NiOverride                            |
|AddNodeOverrideFloat                        |Setter |Body, NiOverride                            |
|AddNodeOverrideInt                          |Setter |Body, NiOverride                            |
|AddNodeOverrideBool                         |Setter |Body, NiOverride                            |
|AddNodeOverrideString                       |Setter |Body, NiOverride                            |
|GetNodeOverrideFloat                        |Getter |Body, NiOverride                            |
|GetNodeOverrideInt                          |Getter |Body, NiOverride                            |
|GetNodeOverrideBool                         |Getter |Body, NiOverride                            |
|GetNodeOverrideString                       |Getter |Body, NiOverride                            |
|ApplyNodeOverrides                          |Action |Body, NiOverride                            |
|AddNodeOverrideTextureSet                   |Setter |Body, NiOverride, TextureSet                |
|GetNodeOverrideTextureSet                   |Getter |Body, NiOverride, TextureSet                |
|NodeHelp                                    |Action |Body, Reference                             |
|BodyMorphHelp                               |Action |Body, Reference                             |
|MorphHelp                                   |Action |Body, Reference                             |
|GetRefNodeNames                             |Getter |Body, Reference                             |
|ForceFirstPerson                            |Action |Camera                                      |
|ForceThirdPerson                            |Action |Camera                                      |
|GetWorldFieldOfView                         |Getter |Camera                                      |
|GetWorldFOV                                 |Getter |Camera                                      |
|SetWorldFieldOfView                         |Setter |Camera                                      |
|SetWorldFOV                                 |Setter |Camera                                      |
|GetFirstPersonFieldOfView                   |Getter |Camera                                      |
|GetFirstPersonFOV                           |Getter |Camera                                      |
|SetFirstPersonFieldOfView                   |Setter |Camera                                      |
|SetFirstPersonFOV                           |Setter |Camera                                      |
|UpdateThirdPerson                           |Action |Camera                                      |
|SetCameraTarget                             |Setter |Camera                                      |
|SetFreeCameraSpeed                          |Setter |Camera                                      |
|GetLightFOV                                 |Getter |Camera, Light                               |
|SetLightFOV                                 |Setter |Camera, Light                               |
|GetMapMarkerIconType                        |Getter |Cell/Worldspace                             |
|SetMapMarkerIconType                        |Setter |Cell/Worldspace                             |
|GetMapMarkerName                            |Getter |Cell/Worldspace                             |
|SetMapMarkerName                            |Setter |Cell/Worldspace                             |
|GetActualWaterLevel                         |Getter |Cell/Worldspace                             |
|GetWaterLevel                               |Getter |Cell/Worldspace                             |
|SetMapMarkerVisible                         |Getter |Cell/Worldspace                             |
|SetCanFastTravelToMarker                    |Setter |Cell/Worldspace                             |
|GetAllMapMarkerRefs                         |Getter |Cell/Worldspace, Debug, Reference           |
|GetQuestMarker                              |Getter |Cell/Worldspace, Quest                      |
|CreateXMarkerRef                            |Action |Cell/Worldspace, Reference                  |
|GetCellOrWorldSpaceOriginForRef             |Getter |Cell/Worldspace, Reference                  |
|SetCellOrWorldSpaceOriginForRef             |Setter |Cell/Worldspace, Reference                  |
|GetCurrentMapMarkerRefs                     |Getter |Cell/Worldspace, Reference                  |
|CreateSoundMarker                           |Action |Cell/Worldspace, Sound                      |
|GetSlowTimeMult                             |Getter |Combat Style                                |
|SetSlowTimeMult                             |Setter |Combat Style                                |
|GetCSOffensiveMult                          |Getter |Combat Style                                |
|GetCSDefensiveMult                          |Getter |Combat Style                                |
|GetCSGroupOffensiveMult                     |Getter |Combat Style                                |
|GetCSAvoidThreatChance                      |Getter |Combat Style                                |
|GetCSMeleeMult                              |Getter |Combat Style                                |
|GetCSRangedMult                             |Getter |Combat Style                                |
|GetCSShoutMult                              |Getter |Combat Style                                |
|GetCSStaffMult                              |Getter |Combat Style                                |
|GetCSUnarmedMult                            |Getter |Combat Style                                |
|SetCSOffensiveMult                          |Setter |Combat Style                                |
|SetCSDefensiveMult                          |Setter |Combat Style                                |
|SetCSGroupOffensiveMult                     |Setter |Combat Style                                |
|SetCSAvoidThreatChance                      |Setter |Combat Style                                |
|SetCSMeleeMult                              |Setter |Combat Style                                |
|SetCSRangedMult                             |Setter |Combat Style                                |
|SetCSShoutMult                              |Setter |Combat Style                                |
|SetCSStaffMult                              |Setter |Combat Style                                |
|SetCSUnarmedMult                            |Setter |Combat Style                                |
|GetCSMeleeAttackStaggeredMult               |Getter |Combat Style                                |
|GetCSMeleePowerAttackStaggeredMult          |Getter |Combat Style                                |
|GetCSMeleePowerAttackBlockingMult           |Getter |Combat Style                                |
|GetCSMeleeBashMult                          |Getter |Combat Style                                |
|GetCSMeleeBashRecoiledMult                  |Getter |Combat Style                                |
|GetCSMeleeBashAttackMult                    |Getter |Combat Style                                |
|GetCSMeleeBashPowerAttackMult               |Getter |Combat Style                                |
|GetCSMeleeSpecialAttackMult                 |Getter |Combat Style                                |
|SetCSMeleeAttackStaggeredMult               |Setter |Combat Style                                |
|SetCSMeleePowerAttackStaggeredMult          |Setter |Combat Style                                |
|SetCSMeleePowerAttackBlockingMult           |Setter |Combat Style                                |
|SetCSMeleeBashMult                          |Setter |Combat Style                                |
|SetCSMeleeBashRecoiledMult                  |Setter |Combat Style                                |
|SetCSMeleeBashAttackMult                    |Setter |Combat Style                                |
|SetCSMeleeBashPowerAttackMult               |Setter |Combat Style                                |
|SetCSMeleeSpecialAttackMult                 |Setter |Combat Style                                |
|GetCSCloseRangeDuelingCircleMult            |Getter |Combat Style                                |
|GetCSCloseRangeFlankingFlankDistance        |Getter |Combat Style                                |
|GetCSCloseRangeFlankingStalkTime            |Getter |Combat Style                                |
|SetCSCloseRangeDuelingCircleMult            |Setter |Combat Style                                |
|SetCSCloseRangeFlankingFlankDistance        |Getter |Combat Style                                |
|SetCSCloseRangeFlankingStalkTime            |Setter |Combat Style                                |
|GetCSLongRangeStrafeMult                    |Getter |Combat Style                                |
|SetCSLongRangeStrafeMult                    |Setter |Combat Style                                |
|GetTNGRgMult                                |Getter |Combat Style, Customization                 |
|SetTNGRgMult                                |Setter |Combat Style, Customization                 |
|GetCSAllowDualWielding                      |Getter |Combat Style, Debug                         |
|SetCSAllowDualWielding                      |Setter |Combat Style, Debug                         |
|GetCSCloseRangeDuelingFallbackMult          |Getter |Combat Style, Debug                         |
|SetCSCloseRangeDuelingFallbackMult          |Setter |Combat Style, Debug                         |
|GetCSFlightHoverChance                      |Getter |Combat Style, Light                         |
|GetCSFlightDiveBombChance                   |Getter |Combat Style, Light                         |
|GetCSFlightFlyingAttackChance               |Getter |Combat Style, Light                         |
|SetCSFlightHoverChance                      |Setter |Combat Style, Light                         |
|SetCSFlightDiveBombChance                   |Setter |Combat Style, Light                         |
|GetCSMagicMult                              |Getter |Combat Style, Magic Effect                  |
|SetCSMagicMult                              |Setter |Combat Style, Magic Effect                  |
|VCSAddPerk                                  |Setter |Combat Style, Perk                          |
|VCSRemovePerk                               |Setter |Combat Style, Perk                          |
|VCSHelp                                     |Action |Combat Style, Reference                     |
|VCSEquipSpell                               |Action |Combat Style, Spell, UI                     |
|VCSEquipItem                                |Action |Combat Style, UI                            |
|VCSEquipShout                               |Action |Combat Style, UI                            |
|VCSUnequipItem                              |Action |Combat Style, UI                            |
|CreateConstructibleObject                   |Action |Constructible Object                        |
|GetConstructibleObjectResult                |Getter |Constructible Object                        |
|SetConstructibleObjectResult                |Setter |Constructible Object                        |
|GetConstructibleObjectResultQuantity        |Getter |Constructible Object                        |
|SetConstructibleObjectResultQuantity        |Setter |Constructible Object                        |
|RemoveInvalidConstructibleObjects           |Setter |Constructible Object                        |
|GetAllConstructibleObjects                  |Getter |Constructible Object, Debug                 |
|GetConstructibleObjectWorkbenchKeyword      |Getter |Constructible Object, Enchantment, Keyword  |
|SetConstructibleObjectWorkbenchKeyword      |Setter |Constructible Object, Enchantment, Keyword  |
|GetConstructibleObjectNumIngredients        |Getter |Constructible Object, Ingredient            |
|GetConstructibleObjectNthIngredient         |Getter |Constructible Object, Ingredient            |
|SetConstructibleObjectNthIngredient         |Setter |Constructible Object, Ingredient            |
|GetConstructibleObjectNthIngredientQuantity |Getter |Constructible Object, Ingredient            |
|SetConstructibleObjectNthIngredientQuantity |Setter |Constructible Object, Ingredient            |
|GetMappedControl                            |Getter |Container                                   |
|GetVendorFactionContainer                   |Getter |Container, Faction                          |
|GetMenuContainer                            |Getter |Container, UI                               |
|UpdateWeight                                |Action |Customization                               |
|SetHairColor                                |Setter |Customization                               |
|SetSkinColor                                |Setter |Customization                               |
|SetSkinAlpha                                |Setter |Customization                               |
|CreateColorForm                             |Action |Customization                               |
|RevertOverlays                              |Action |Customization                               |
|SetHeight                                   |Setter |Customization                               |
|GetHeight                                   |Getter |Customization                               |
|BlendColorWithSkinTone                      |Action |Customization                               |
|RevertSkinOverlays                          |Action |Customization                               |
|RevertHeadOverlays                          |Action |Customization                               |
|SetFogColor                                 |Setter |Customization                               |
|SetMembraneColorKeyData                     |Setter |Customization                               |
|GetColorFormColor                           |Getter |Customization                               |
|SetColorFormColor                           |Setter |Customization                               |
|GetTNGBoolValue                             |Getter |Customization                               |
|SetTNGBoolValue                             |Setter |Customization                               |
|GetTNGRgNames                               |Getter |Customization                               |
|GetTNGRgAddons                              |Getter |Customization                               |
|GetTNGRgAddon                               |Getter |Customization                               |
|SetTNGRgAddon                               |Setter |Customization                               |
|TNGSwapRevealing                            |Action |Customization                               |
|UpdateTNGSettings                           |Setter |Customization                               |
|UpdateTNGLogLvl                             |Action |Customization                               |
|ShowTNGLogLocation                          |Action |Customization                               |
|GetTNGErrDscr                               |Getter |Customization                               |
|GetAllTNGAddonsCount                        |Getter |Customization, Debug                        |
|GetAllTNGPossibleAddons                     |Getter |Customization, Debug                        |
|GetTNGRgInfo                                |Getter |Customization, Debug                        |
|TNGWhyProblem                               |Action |Customization, Debug                        |
|RemoveAllSkinReferenceOverrides             |Setter |Customization, Debug, NiOverride, Reference |
|GetAllOutfitParts                           |Getter |Customization, Debug, Outfit                |
|GetLightColor                               |Getter |Customization, Light                        |
|SetLightColor                               |Setter |Customization, Light                        |
|SetItemDyeColor                             |Setter |Customization, NiOverride                   |
|ClearItemDyeColor                           |Action |Customization, NiOverride                   |
|UpdateItemDyeColor                          |Action |Customization, NiOverride                   |
|GetItemDyeColor                             |Getter |Customization, NiOverride                   |
|ApplySkinOverrides                          |Action |Customization, NiOverride                   |
|SetItemTextureLayerColor                    |Setter |Customization, NiOverride, TextureSet       |
|GetItemTextureLayerColor                    |Getter |Customization, NiOverride, TextureSet       |
|ClearItemTextureLayerColor                  |Action |Customization, NiOverride, TextureSet       |
|AddSkinOverrideTextureSet                   |Setter |Customization, NiOverride, TextureSet       |
|SetOutfit                                   |Setter |Customization, Outfit                       |
|GetOutfit                                   |Getter |Customization, Outfit                       |
|GetOutfitNumParts                           |Getter |Customization, Outfit                       |
|GetOutfitNthPart                            |Getter |Customization, Outfit                       |
|UnsetOutfit                                 |Action |Customization, Outfit                       |
|GetRaceSkin                                 |Getter |Customization, Race                         |
|SetRaceSkin                                 |Setter |Customization, Race                         |
|ReplaceSkinTextureSet                       |Setter |Customization, TextureSet                   |
|SetParticleColorKeyData                     |Setter |Customization, Visual Effects               |
|GetFormTypeAll                              |Getter |Debug                                       |
|DismissAllSummons                           |Getter |Debug                                       |
|SetChargeTimeAll                            |Setter |Debug                                       |
|AllowPCDialogue                             |Action |Debug                                       |
|RemAllItems                                 |Action |Debug                                       |
|RemoveAllInventoryEventFilters              |Setter |Debug                                       |
|GetFormInfo                                 |Getter |Debug                                       |
|WhyHostile                                  |Action |Debug                                       |
|StopAllShaders                              |Action |Debug, Effect Shader                        |
|GetAllEffectShaders                         |Getter |Debug, Effect Shader                        |
|GetFactionInformation                       |Getter |Debug, Faction                              |
|GetAllHeadParts                             |Getter |Debug, HeadPart                             |
|RemoveAllPackageOverride                    |Setter |Debug, NiOverride, Package                  |
|RemoveAllWeaponReferenceOverrides           |Setter |Debug, NiOverride, Reference, Weapon        |
|RemoveAllPerks                              |Setter |Debug, Perk                                 |
|RemoveAllPerks                              |Setter |Debug, Perk                                 |
|RemoveAllVisiblePerks                       |Getter |Debug, Perk                                 |
|FindAllReferencesOfFormType                 |Action |Debug, Reference                            |
|FindAllReferencesOfType                     |Action |Debug, Reference                            |
|GetAllRefsInGrid                            |Getter |Debug, Reference                            |
|GetReferenceInfo                            |Getter |Debug, Reference                            |
|RemoveAllSpells                             |Setter |Debug, Spell                                |
|GetAllTexturePaths                          |Getter |Debug, TextureSet                           |
|CreateUICallback                            |Action |Debug, UI                                   |
|SetDoorDestination                          |Setter |Door                                        |
|PlaceDoor                                   |Action |Door                                        |
|StartDraggingObject                         |Action |Dragon                                      |
|ApplyMaterialShader                         |Action |Effect Shader                               |
|GetHitShader                                |Getter |Effect Shader                               |
|SetHitShader                                |Setter |Effect Shader                               |
|PlayDebugShader                             |Action |Effect Shader                               |
|SetShaderType                               |Setter |Effect Shader                               |
|GetEffectShaderTotalCount                   |Getter |Effect Shader                               |
|IsEffectShaderFlagSet                       |Getter |Effect Shader                               |
|ClearEffectShaderFlag                       |Action |Effect Shader                               |
|SetEffectShaderFlag                         |Setter |Effect Shader                               |
|GetEnchantShader                            |Getter |Effect Shader, Enchantment                  |
|SetEnchantShader                            |Setter |Effect Shader, Enchantment                  |
|GetParticleShaderTexture                    |Getter |Effect Shader, TextureSet, Visual Effects   |
|SetParticleShaderTexture                    |Setter |Effect Shader, TextureSet, Visual Effects   |
|GetEnchantment                              |Getter |Enchantment                                 |
|SetEnchantment                              |Setter |Enchantment                                 |
|EnchantObject                               |Action |Enchantment                                 |
|LearnEnchantment                            |Action |Enchantment                                 |
|GetKnownEnchantments                        |Getter |Enchantment                                 |
|AddMagicEffectToEnchantment                 |Setter |Enchantment, Magic Effect                   |
|RemoveMagicEffectFromEnchantment            |Setter |Enchantment, Magic Effect                   |
|CastEnchantment                             |Action |Enchantment, Spell                          |
|GetWeaponEnchantment                        |Getter |Enchantment, Weapon                         |
|GetFactionOwner                             |Getter |Faction                                     |
|ClearCachedFactionFightReactions            |Action |Faction                                     |
|FactionFlagHelp                             |Action |Faction, Reference                          |
|GetFootstepSet                              |Getter |Footstep                                    |
|SetFootstepSet                              |Setter |Footstep                                    |
|Dismount                                    |Getter |General                                     |
|AddToMap                                    |Setter |General                                     |
|SelectCrosshair                             |Action |General                                     |
|CreatePersistentForm                        |Getter |General                                     |
|MarkFavorite                                |Action |General                                     |
|UnmarkFavorite                              |Action |General                                     |
|CopyAppearance                              |Action |General                                     |
|Teleport                                    |Action |General                                     |
|SaveEx                                      |Action |General                                     |
|Del                                         |Action |General                                     |
|GetFormIDFromEditorID                       |Getter |General                                     |
|GetEDIDFromFormID                           |Getter |General                                     |
|GetFormModName                              |Getter |General                                     |
|GetConditionList                            |Getter |General                                     |
|Sleep                                       |Action |General                                     |
|SetItemHealthPercent                        |Setter |General                                     |
|SetDisplayName                              |Getter |General                                     |
|ClearDestruction                            |Action |General                                     |
|SaveCharacter                               |Action |General                                     |
|LoadCharacter                               |Action |General                                     |
|GetDialogueTarget                           |Getter |General                                     |
|TriggerScreenBlood                          |Action |General                                     |
|SetItemMaxCharge                            |Setter |General                                     |
|SetItemCharge                               |Setter |General                                     |
|SetRestrained                               |Setter |General                                     |
|RGBToInt                                    |Action |General                                     |
|PrintArgsAsStrings                          |Action |General                                     |
|SetClipBoardText                            |Setter |General                                     |
|BlockActivation                             |Action |General                                     |
|PreventDetection                            |Action |General                                     |
|RegenerateHead                              |Action |General                                     |
|KillSilent                                  |Action |General                                     |
|KillEssential                               |Action |General                                     |
|ClearForcedMovement                         |Action |General                                     |
|SetUnconscious                              |Setter |General                                     |
|Duplicate                                   |Action |General                                     |
|CreateFormList                              |Getter |General                                     |
|SetHarvested                                |Setter |General                                     |
|SetOpen                                     |Setter |General                                     |
|GetMaterialType                             |Getter |General                                     |
|GetButtonForDXScanCode                      |Getter |General                                     |
|EnableSurvivalFeature                       |Action |General                                     |
|DisableSurvivalFeature                      |Getter |General                                     |
|StartCannibal                               |Action |General                                     |
|GetButtonForDXScanCode                      |Getter |General                                     |
|GetQuality                                  |Getter |General                                     |
|SetQuality                                  |Setter |General                                     |
|TrainWith                                   |Action |General                                     |
|GetSkillLegendaryLevel                      |Getter |General                                     |
|SetSkillLegendaryLevel                      |Setter |General                                     |
|ApplyMeleeHit                               |Action |General                                     |
|ApplyHit                                    |Action |General                                     |
|SetRecordFlag                               |Setter |General                                     |
|ClearRecordFlag                             |Action |General                                     |
|IsRecordFlagSet                             |Getter |General                                     |
|GetItemHealthPercent                        |Getter |General                                     |
|RemoveFormFromFormlist                      |Getter |General                                     |
|StartSneaking                               |Action |General                                     |
|SetDontMove                                 |Setter |General                                     |
|SetPublic                                   |Setter |General                                     |
|SetFogPower                                 |Setter |General                                     |
|SetFogPlanes                                |Setter |General                                     |
|GetItemMaxCharge                            |Getter |General                                     |
|GetWorldModelPath                           |Getter |General                                     |
|SetWorldModelPath                           |Setter |General                                     |
|CopyWorldModelPath                          |Action |General                                     |
|SetAutoLock                                 |Setter |General                                     |
|PrecacheCharGenClear                        |Action |General                                     |
|ModObjectiveGlobal                          |Action |General                                     |
|SetEffectFlag                               |Setter |General                                     |
|ClearEffectFlag                             |Action |General                                     |
|IsEffectFlagSet                             |Getter |General                                     |
|GetLocationCleared                          |Getter |General                                     |
|SetLocationCleared                          |Setter |General                                     |
|GetLocationParent                           |Getter |General                                     |
|SetLocationParent                           |Setter |General                                     |
|GetLocalGravity                             |Getter |General                                     |
|FindForm                                    |Action |General                                     |
|GetAddonModels                              |Getter |General                                     |
|SetAddonModels                              |Setter |General                                     |
|KnockAreaEffect                             |Action |General                                     |
|PlayImpactEffect                            |Action |General                                     |
|ApplyHavokImpulse                           |Action |General                                     |
|GetWornItemID                               |Getter |General                                     |
|SendTrespassAlarm                           |Action |General                                     |
|ClearArrested                               |Action |General                                     |
|ClearExtraArrows                            |Action |General                                     |
|ClearLookAt                                 |Action |General                                     |
|ForceMovementSpeed                          |Action |General                                     |
|ForceMovementRotationSpeed                  |Action |General                                     |
|ForceMovementSpeedRamp                      |Action |General                                     |
|ScaleObject3D                               |Action |General                                     |
|SendModEvent                                |Action |General                                     |
|SayTopic                                    |Action |General                                     |
|GetFormsInFormList                          |Getter |General                                     |
|GetGlobalVariable                           |Getter |General                                     |
|SetLocalGravity                             |Setter |General                                     |
|SelectObjectUnderFeet                       |Action |General                                     |
|SetObjectiveText                            |Setter |General                                     |
|GetAutorunLines                             |Getter |General                                     |
|AddAutorunLine                              |Setter |General                                     |
|RemoveAutorunLine                           |Setter |General                                     |
|AddFormsToFormlist                          |Getter |General                                     |
|AddFormToFormlists                          |Getter |General                                     |
|PlaceBefore                                 |Action |General                                     |
|GetWornForms                                |Getter |General                                     |
|RemoveDecals                                |Setter |General                                     |
|Reload                                      |Action |General                                     |
|StartWhiterunAttack                         |Action |General                                     |
|GetSkillName                                |Getter |General                                     |
|GetSkillLevel                               |Getter |General                                     |
|SetExpressionPhoneme                        |Setter |General                                     |
|SetExpressionModifier                       |Setter |General                                     |
|GetHazardIMOD                               |Getter |Hazard                                      |
|GetHazardIMODRadius                         |Getter |Hazard                                      |
|GetHazardIPDS                               |Getter |Hazard                                      |
|GetHazardLifetime                           |Getter |Hazard                                      |
|GetHazardLimit                              |Getter |Hazard                                      |
|GetHazardRadius                             |Getter |Hazard                                      |
|GetHazardTargetInterval                     |Getter |Hazard                                      |
|IsHazardFlagSet                             |Getter |Hazard                                      |
|ClearHazardFlag                             |Action |Hazard                                      |
|SetHazardFlag                               |Setter |Hazard                                      |
|SetHazardIMOD                               |Setter |Hazard                                      |
|SetHazardIMODRadius                         |Setter |Hazard                                      |
|SetHazardIPDS                               |Setter |Hazard                                      |
|SetHazardLifetime                           |Setter |Hazard                                      |
|SetHazardLimit                              |Setter |Hazard                                      |
|SetHazardRadius                             |Setter |Hazard                                      |
|SetHazardTargetInterval                     |Setter |Hazard                                      |
|GetHazardLight                              |Getter |Hazard, Light                               |
|SetHazardLight                              |Setter |Hazard, Light                               |
|GetHazardSound                              |Getter |Hazard, Sound                               |
|SetHazardSound                              |Setter |Hazard, Sound                               |
|GetHazardSpell                              |Getter |Hazard, Spell                               |
|SetHazardSpell                              |Setter |Hazard, Spell                               |
|SetHeadpartAlpha                            |Setter |Head Part                                   |
|SetHeadpartValidRaces                       |Setter |Head Part, Race                             |
|GetHeadpartValidRaces                       |Getter |Head Part, Race                             |
|HeadpartHelp                                |Action |Head Part, Reference                        |
|ReplaceHeadPart                             |Action |HeadPart                                    |
|ChangeHeadPart                              |Action |HeadPart                                    |
|GetNthHeadPart                              |Getter |HeadPart                                    |
|SetNthHeadPart                              |Setter |HeadPart                                    |
|GetHeadPartType                             |Getter |HeadPart                                    |
|SetHeadPartTextureSet                       |Setter |HeadPart, TextureSet                        |
|GetHeadPartTextureSet                       |Getter |HeadPart, TextureSet                        |
|GetTreeIngredient                           |Getter |Ingredient                                  |
|SetTreeIngredient                           |Setter |Ingredient                                  |
|GetIngredientNthEffectArea                  |Getter |Ingredient                                  |
|SetIngredientNthEffectArea                  |Setter |Ingredient                                  |
|GetIngredientNthEffectMagnitude             |Getter |Ingredient                                  |
|SetIngredientNthEffectMagnitude             |Setter |Ingredient                                  |
|GetIngredientNthEffectDuration              |Getter |Ingredient                                  |
|SetIngredientNthEffectDuration              |Setter |Ingredient                                  |
|GetFloraIngredient                          |Getter |Ingredient                                  |
|SetFloraIngredient                          |Setter |Ingredient                                  |
|LearnIngredientEffect                       |Action |Ingredient                                  |
|CastIngredient                              |Action |Ingredient, Spell                           |
|TapKey                                      |Action |Input                                       |
|HoldKey                                     |Action |Input                                       |
|ReleaseKey                                  |Action |Input                                       |
|IsKeyPressed                                |Getter |Input                                       |
|GetNumKeysPressed                           |Getter |Input                                       |
|GetNthKeyPressed                            |Getter |Input                                       |
|GetMappedKey                                |Getter |Input                                       |
|GetKeycodeString                            |Getter |Input                                       |
|AddKeyIfNeeded                              |Setter |Key                                         |
|SetKey                                      |Setter |Key                                         |
|AddKeywordToForm                            |Setter |Keyword                                     |
|RemoveKeywordFromForm                       |Setter |Keyword                                     |
|GetLocationKeywordData                      |Getter |Keyword                                     |
|SetLocationKeywordData                      |Setter |Keyword                                     |
|CreateKeyword                               |Action |Keyword                                     |
|GetKeywords                                 |Getter |Keyword                                     |
|AddKeyword                                  |Setter |Keyword                                     |
|RemoveKeyword                               |Setter |Keyword                                     |
|ReplaceKeyword                              |Action |Keyword                                     |
|GetKeyword                                  |Getter |Keyword                                     |
|CopyKeywords                                |Action |Keyword                                     |
|AddKeywordsToForm                           |Setter |Keyword                                     |
|RemoveKeywordsFromForm                      |Setter |Keyword                                     |
|AddKeywordToForms                           |Setter |Keyword                                     |
|RemoveKeywordFromForms                      |Setter |Keyword                                     |
|FindKeywordOnForm                           |Action |Keyword                                     |
|AddKeywordToRef                             |Setter |Keyword, Reference                          |
|RemoveKeywordFromRef                        |Setter |Keyword, Reference                          |
|AddFormToLeveledItem                        |Setter |Leveled Item                                |
|RevertLeveledItem                           |Action |Leveled Item                                |
|GetLeveledItemChanceNone                    |Getter |Leveled Item                                |
|SetLeveledItemChanceNone                    |Setter |Leveled Item                                |
|GetLeveledItemChanceGlobal                  |Getter |Leveled Item                                |
|SetLeveledItemChanceGlobal                  |Setter |Leveled Item                                |
|GetLeveledItemNumForms                      |Getter |Leveled Item                                |
|GetLeveledItemNthForm                       |Getter |Leveled Item                                |
|GetLeveledItemNthLevel                      |Getter |Leveled Item                                |
|SetLeveledItemNthLevel                      |Setter |Leveled Item                                |
|GetLeveledItemNthCount                      |Getter |Leveled Item                                |
|SetLeveledItemNthCount                      |Setter |Leveled Item                                |
|FlattenLeveledList                          |Getter |Leveled List                                |
|GetLightFade                                |Getter |Light                                       |
|GetLightRadius                              |Getter |Light                                       |
|GetLightRGB                                 |Getter |Light                                       |
|GetLightShadowDepthBias                     |Getter |Light                                       |
|GetLightType                                |Getter |Light                                       |
|SetLightFade                                |Setter |Light                                       |
|SetLightRadius                              |Setter |Light                                       |
|SetLightRGB                                 |Setter |Light                                       |
|SetLightShadowDepthBias                     |Setter |Light                                       |
|SetLightType                                |Setter |Light                                       |
|GetLightingTemplate                         |Getter |Light                                       |
|SetLightingTemplate                         |Setter |Light                                       |
|GetMagicEffectLight                         |Getter |Light, Magic Effect                         |
|SetMagicEffectLight                         |Setter |Light, Magic Effect                         |
|AddMagicEffect                              |Setter |Magic Effect                                |
|ClearMagicEffects                           |Action |Magic Effect                                |
|CopyMagicEffects                            |Action |Magic Effect                                |
|GetMagicEffectAssociatedSkill               |Getter |Magic Effect                                |
|SetMagicEffectAssociatedSkill               |Setter |Magic Effect                                |
|GetMagicEffectResistance                    |Getter |Magic Effect                                |
|SetMagicEffectResistance                    |Getter |Magic Effect                                |
|GetMagicEffectImpactDataSet                 |Getter |Magic Effect                                |
|SetMagicEffectImpactDataSet                 |Setter |Magic Effect                                |
|GetMagicEffectImageSpaceMod                 |Getter |Magic Effect                                |
|SetMagicEffectImageSpaceMod                 |Setter |Magic Effect                                |
|GetMagicEffectExplosion                     |Getter |Magic Effect                                |
|SetMagicEffectExplosion                     |Setter |Magic Effect                                |
|GetMagicEffectProjectile                    |Getter |Magic Effect                                |
|SetMagicEffectProjectile                    |Setter |Magic Effect                                |
|GetMagicEffectSkillLevel                    |Getter |Magic Effect                                |
|SetMagicEffectSkillLevel                    |Setter |Magic Effect                                |
|GetMagicEffectBaseCost                      |Getter |Magic Effect                                |
|SetMagicEffectBaseCost                      |Setter |Magic Effect                                |
|GetMagicEffectArea                          |Getter |Magic Effect                                |
|SetMagicEffectArea                          |Setter |Magic Effect                                |
|GetMagicEffectAssociatedForm                |Getter |Magic Effect                                |
|GetMagicEffectArchetype                     |Getter |Magic Effect                                |
|GetFormMagicEffects                         |Getter |Magic Effect                                |
|GetMagicEffectPerk                          |Getter |Magic Effect, Perk                          |
|SetMagicEffectPerk                          |Setter |Magic Effect, Perk                          |
|MagicEffectHelp                             |Action |Magic Effect, Reference                     |
|SetMagicEffectSound                         |Setter |Magic Effect, Sound                         |
|GetMagicEffectSound                         |Getter |Magic Effect, Sound                         |
|AddMagicEffectToSpell                       |Setter |Magic Effect, Spell                         |
|RemoveMagicEffectFromSpell                  |Setter |Magic Effect, Spell                         |
|SetSpellMagicEffect                         |Setter |Magic Effect, Spell                         |
|GetSpellMagicEffects                        |Getter |Magic Effect, Spell                         |
|GetMagicEffectCastTime                      |Getter |Magic Effect, Spell                         |
|SetMagicEffectCastTime                      |Setter |Magic Effect, Spell                         |
|GetMagicEffectEquipAbility                  |Getter |Magic Effect, UI                            |
|SetMagicEffectEquipAbility                  |Setter |Magic Effect, UI                            |
|GetCurrentMusicType                         |Getter |Music                                       |
|GetNumberOfTracksInMusicType                |Getter |Music                                       |
|GetMusicTypeTrackIndex                      |Getter |Music                                       |
|SetMusicTypeTrackIndex                      |Setter |Music                                       |
|GetMusicTypePriority                        |Getter |Music                                       |
|SetMusicTypePriority                        |Setter |Music                                       |
|SetPlayerAIDriven                           |Setter |NiOverride                                  |
|SetPlayersLastRiddenHorse                   |Setter |NiOverride                                  |
|GetItemUniqueID                             |Getter |NiOverride                                  |
|GetObjectUniqueID                           |Getter |NiOverride                                  |
|GetSeasonOverride                           |Getter |NiOverride                                  |
|SetSeasonOverride                           |Setter |NiOverride                                  |
|ClearSeasonOverride                         |Action |NiOverride                                  |
|MakePlayerFriend                            |Action |NiOverride                                  |
|ClearExpressionOverride                     |Action |NiOverride                                  |
|ResetExpressionOverrides                    |Action |NiOverride                                  |
|AddPackageOverride                          |Setter |NiOverride, Package                         |
|RemovePackageOverride                       |Setter |NiOverride, Package                         |
|CountPackageOverride                        |Action |NiOverride, Package                         |
|ClearPackageOverride                        |Action |NiOverride, Package                         |
|NiOverrideHelp                              |Action |NiOverride, Reference                       |
|GetLastPlayerActivatedRef                   |Getter |NiOverride, Reference                       |
|GetLastPlayerMenuActivatedRef               |Getter |NiOverride, Reference, UI                   |
|SetSpellCostOverride                        |Setter |NiOverride, Spell                           |
|SetItemTextureLayerType                     |Setter |NiOverride, TextureSet                      |
|GetItemTextureLayerType                     |Getter |NiOverride, TextureSet                      |
|ClearItemTextureLayerType                   |Action |NiOverride, TextureSet                      |
|SetItemTextureLayerTexture                  |Setter |NiOverride, TextureSet                      |
|GetItemTextureLayerTexture                  |Getter |NiOverride, TextureSet                      |
|ClearItemTextureLayerTexture                |Action |NiOverride, TextureSet                      |
|SetItemTextureLayerBlendMode                |Setter |NiOverride, TextureSet                      |
|GetItemTextureLayerBlendMode                |Getter |NiOverride, TextureSet                      |
|ClearItemTextureLayerBlendMode              |Action |NiOverride, TextureSet                      |
|UpdateItemTextureLayers                     |Action |NiOverride, TextureSet                      |
|AddWeaponOverrideTextureSet                 |Setter |NiOverride, TextureSet, Weapon              |
|ApplyWeaponOverrides                        |Action |NiOverride, Weapon                          |
|MoveToPackageLocation                       |Action |Package                                     |
|GetRunningPackage                           |Getter |Package                                     |
|GetPackageTemplate                          |Getter |Package                                     |
|SetSpellCastingPerk                         |Setter |Perk, Spell                                 |
|ForceAddRagdollToWorld                      |Setter |Physics                                     |
|ForceRemoveRagdollFromWorld                 |Setter |Physics                                     |
|GetActiveQuests                             |Getter |Quest                                       |
|GetQuestAliases                             |Getter |Quest                                       |
|GetRefAliases                               |Getter |Quest, Reference                            |
|GetRefAliasesWithScriptAttached             |Getter |Quest, Reference, Script                    |
|GetAliasesWithScriptAttached                |Getter |Quest, Script                               |
|GetRace                                     |Getter |Race                                        |
|SetRaceFlag                                 |Setter |Race                                        |
|ClearRaceFlag                               |Action |Race                                        |
|IsRaceFlagSet                               |Getter |Race                                        |
|GetRaceDefaultVoiceType                     |Getter |Race                                        |
|SetRaceDefaultVoiceType                     |Setter |Race                                        |
|RaceHelp                                    |Action |Race, Reference                             |
|ShowLimitedRaceMenu                         |Action |Race, UI                                    |
|FormTypeHelp                                |Action |Reference                                   |
|PlaceAroundReference                        |Action |Reference                                   |
|RecordSignatureHelp                         |Action |Reference                                   |
|PathToReference                             |Action |Reference                                   |
|SetLinkedRef                                |Setter |Reference                                   |
|GetAshPileLinkedRef                         |Getter |Reference                                   |
|CollisionHelp                               |Getter |Reference                                   |
|AVHelp                                      |Action |Reference                                   |
|FormRecordHelp                              |Action |Reference                                   |
|SetObjectRefFlag                            |Setter |Reference                                   |
|FormHelp                                    |Action |Reference                                   |
|ResetReference                              |Action |Reference                                   |
|DeleteReference                             |Action |Reference                                   |
|DisableReference                            |Getter |Reference                                   |
|ShowAsHelpMessage                           |Action |Reference                                   |
|ResetHelpMessage                            |Action |Reference                                   |
|SpellFlagHelp                               |Action |Reference, Spell                            |
|MenuHelp                                    |Action |Reference, UI                               |
|SetRefAsNoAIAcquire                         |Setter |Reference, UI                               |
|RefreshItemMenu                             |Action |Reference, UI                               |
|GetCurrentScene                             |Getter |Scene                                       |
|ForceStartScene                             |Action |Scene                                       |
|StartScene                                  |Action |Scene                                       |
|StopScene                                   |Action |Scene                                       |
|IsScenePlaying                              |Getter |Scene                                       |
|AttachPapyrusScript                         |Action |Script                                      |
|GetFormDescription                          |Getter |Script                                      |
|GetScriptsAttachedToActiveEffect            |Getter |Script                                      |
|SetDescription                              |Setter |Script                                      |
|ResetDescription                            |Action |Script                                      |
|GetFormsWithScriptAttached                  |Getter |Script                                      |
|IsScriptAttachedToForm                      |Getter |Script                                      |
|GetScriptsAttachedToForm                    |Getter |Script                                      |
|SetSoundDescriptor                          |Setter |Script, Sound                               |
|PlaySoundDescriptor                         |Action |Script, Sound                               |
|PlaySound                                   |Action |Sound                                       |
|SoundPause                                  |Action |Sound                                       |
|SoundUnpause                                |Action |Sound                                       |
|SoundMute                                   |Action |Sound                                       |
|SoundUnmute                                 |Action |Sound                                       |
|SetVolume                                   |Setter |Sound                                       |
|SetSpellTomeSpell                           |Setter |Spell                                       |
|SetSpellAutoCalculate                       |Setter |Spell                                       |
|SetSpellChargeTime                          |Setter |Spell                                       |
|SetSpellCastDuration                        |Setter |Spell                                       |
|SetSpellRange                               |Setter |Spell                                       |
|LaunchSpell                                 |Action |Spell                                       |
|GetSpellType                                |Getter |Spell                                       |
|SetSpellCastingType                         |Setter |Spell                                       |
|SetSpellDeliveryType                        |Setter |Spell                                       |
|SetSpellType                                |Setter |Spell                                       |
|DispelEffect                                |Getter |Spell                                       |
|GetCastTime                                 |Getter |Spell                                       |
|CombineSpells                               |Action |Spell                                       |
|GetEquippedSpell                            |Getter |Spell, UI                                   |
|GetSpellEquipType                           |Getter |Spell, UI                                   |
|SetSpellEquipType                           |Setter |Spell, UI                                   |
|CopySpellEquipType                          |Action |Spell, UI                                   |
|SetEyeTexture                               |Setter |TextureSet                                  |
|ReplaceFaceTextureSet                       |Setter |TextureSet                                  |
|CreateTextureSet                            |Setter |TextureSet                                  |
|SetNthTexturePath                           |Setter |TextureSet                                  |
|GetNthTexturePath                           |Getter |TextureSet                                  |
|GetTextureSetNumPaths                       |Getter |TextureSet                                  |
|GetMembraneFillTexture                      |Getter |TextureSet                                  |
|GetMembraneHolesTexture                     |Getter |TextureSet                                  |
|GetMembranePaletteTexture                   |Getter |TextureSet                                  |
|SetMembraneFillTexture                      |Setter |TextureSet                                  |
|SetMembraneHolesTexture                     |Setter |TextureSet                                  |
|SetMembranePaletteTexture                   |Setter |TextureSet                                  |
|GetWorldModelNthTextureSet                  |Getter |TextureSet                                  |
|SetWorldModelNthTextureSet                  |Setter |TextureSet                                  |
|GetWorldModelTextureSets                    |Getter |TextureSet                                  |
|GetParticlePaletteTexture                   |Getter |TextureSet, Visual Effects                  |
|SetParticlePaletteTexture                   |Setter |TextureSet, Visual Effects                  |
|ShowGiftMenu                                |Action |UI                                          |
|ShowBarterMenu                              |Action |UI                                          |
|ShowMenu                                    |Action |UI                                          |
|HideMenu                                    |Action |UI                                          |
|ToggleOpenSleepWaitMenu                     |Action |UI                                          |
|GetEquipType                                |Getter |UI                                          |
|SetEquipType                                |Setter |UI                                          |
|GetLastMenuOpened                           |Getter |UI                                          |
|TemperEquipment                             |Action |UI                                          |
|TemperWornEquipment                         |Action |UI                                          |
|GetEquippedShout                            |Getter |UI                                          |
|GetEquippedShield                           |Getter |UI                                          |
|SwapEquipment                               |Action |UI                                          |
|ShowCustomTrainingMenu                      |Action |UI                                          |
|GetEquippedWeapon                           |Getter |UI, Weapon                                  |
|SetVampire                                  |Setter |Vampire                                     |
|Bite                                        |Action |Vampire                                     |
|TurnVampire                                 |Action |Vampire                                     |
|TurnBetterVampire                           |Action |Vampire                                     |
|VampireFeed                                 |Action |Vampire                                     |
|GetParticleFullCount                        |Getter |Visual Effects                              |
|GetParticlePersistentCount                  |Getter |Visual Effects                              |
|SetParticlePersistentCount                  |Getter |Visual Effects                              |
|DrawWeapon                                  |Action |Weapon                                      |
|SheatheWeapon                               |Action |Weapon                                      |
|GetWeaponModelPath                          |Getter |Weapon                                      |
|SetWeaponModelPath                          |Setter |Weapon                                      |
|GetWeaponIconPath                           |Getter |Weapon                                      |
|SetWeaponIconPath                           |Setter |Weapon                                      |
|GetWeaponMessageIconPath                    |Getter |Weapon                                      |
|SetWeaponMessageIconPath                    |Setter |Weapon                                      |

License
===
To whatever extent I may be able to free this code to the wildest reaches of the Internet, it is free to use and redistribute with attribution in whatever means one decides.
