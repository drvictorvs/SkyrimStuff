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


|Term                                        |Type   |Topics                                     |
|:-------------------------------------------|:------|:------------------------------------------|
|GetActorWarmthRating                        |Getter |Actor                                      |
|ResetActor3D                                |Action |Actor                                      |
|SetActorOwner                               |Setter |Actor                                      |
|FreezeActor                                 |Action |Actor                                      |
|CalmActor                                   |Action |Actor                                      |
|CalmActor                                   |Action |Actor                                      |
|GetActorbaseSkin                            |Getter |Actor                                      |
|SetActorbaseSkin                            |Setter |Actor                                      |
|SetAttackActorOnSight                       |Setter |Actor                                      |
|GetActorOwner                               |Getter |Actor                                      |
|SetActorbaseOutfit                          |Setter |Actor                                      |
|UnsetActorbaseOutfit                        |Action |Actor                                      |
|PushActorAway                               |Action |Actor                                      |
|ClearKeepOffsetFromActor                    |Action |Actor                                      |
|GetActorbaseDeadCount                       |Getter |Actor                                      |
|GetActorbaseSex                             |Getter |Actor                                      |
|SetActorbaseInvulnerable                    |Setter |Actor                                      |
|GetActorbaseVoiceType                       |Getter |Actor                                      |
|SetActorbaseVoiceType                       |Setter |Actor                                      |
|GetActorbaseCombatStyle                     |Getter |Actor                                      |
|SetActorbaseCombatStyle                     |Setter |Actor                                      |
|GetActorDialogueTarget                      |Getter |Actor                                      |
|SetActorCalmed                              |Setter |Actor                                      |
|SetActorSex                                 |Setter |Actor                                      |
|CanModifyActorTNG                           |Action |Actor                                      |
|GetTNGActorAddons                           |Getter |Actor                                      |
|GetTNGActorAddon                            |Getter |Actor                                      |
|SetTNGActorAddon                            |Setter |Actor                                      |
|GetTNGActorSize                             |Getter |Actor                                      |
|SetTNGActorSize                             |Setter |Actor                                      |
|CheckTNGActors                              |Action |Actor                                      |
|FindEffectOnActor                           |Action |Actor                                      |
|PacifyActor                                 |Action |Actor                                      |
|GetActorbaseWeight                          |Getter |Actor, Customization                       |
|SetActorbaseWeight                          |Setter |Actor, Customization                       |
|GetActorValueInfoByName                     |Getter |Actor, Debug                               |
|TNGActorItemsInfo                           |Action |Actor, Debug                               |
|GetActorFactions                            |Getter |Actor, Faction                             |
|GetMagicEffectPrimaryActorValue             |Getter |Actor, Magic Effect                        |
|GetMagicEffectySecondaryActorValue          |Getter |Actor, Magic Effect                        |
|SetActorRefraction                          |Setter |Actor, Reference                           |
|GetActorRefraction                          |Getter |Actor, Reference                           |
|GetActorPlayableSpells                      |Getter |Actor, Spell                               |
|GetActorbaseFaceTextureSet                  |Getter |Actor, TextureSet                          |
|SetActorbaseFaceTextureSet                  |Setter |Actor, TextureSet                          |
|RestoreColdLevel                            |Action |ActorValue                                 |
|RestoreHungerLevel                          |Action |ActorValue                                 |
|RestoreExhaustionLevel                      |Action |ActorValue                                 |
|QueryStat                                   |Action |ActorValue                                 |
|SetMiscStat                                 |Getter |ActorValue                                 |
|SendLycanthropyStateChanged                 |Action |ActorValue                                 |
|GetTNGAddonStatus                           |Getter |ActorValue                                 |
|SetTNGAddonStatus                           |Setter |ActorValue                                 |
|GetMusicTypeStatus                          |Getter |ActorValue, Music                          |
|SendVampirismStateChanged                   |Getter |ActorValue, Vampire                        |
|GetPotionNthEffectArea                      |Getter |Alchemy                                    |
|SetPotionNthEffectArea                      |Setter |Alchemy                                    |
|GetPotionNthEffectMagnitude                 |Getter |Alchemy                                    |
|SetPotionNthEffectMagnitude                 |Setter |Alchemy                                    |
|GetPotionNthEffectDuration                  |Getter |Alchemy                                    |
|SetPotionNthEffectDuration                  |Setter |Alchemy                                    |
|CastPotion                                  |Action |Alchemy, Spell                             |
|PlayIdleWithTarget                          |Action |Animation                                  |
|GetActiveGamebryoAnimation                  |Getter |Animation                                  |
|PlayIdle                                    |Action |Animation                                  |
|PlayIdleWithTarget                          |Action |Animation                                  |
|PlaySubGraphAnimation                       |Action |Animation                                  |
|PlayAnimation                               |Action |Animation                                  |
|PlayAnimationAndWait                        |Action |Animation                                  |
|PlayGamebryoAnimation                       |Action |Animation                                  |
|PlaySyncedAnimationSS                       |Action |Animation                                  |
|PlaySyncedAnimationAndWaitSS                |Action |Animation                                  |
|SetAnimationVariableBool                    |Setter |Animation                                  |
|SetAnimationVariableInt                     |Setter |Animation                                  |
|SetAnimationVariableFloat                   |Setter |Animation                                  |
|SetSubGraphFloatVariable                    |Setter |Animation                                  |
|GetAnimationEventName                       |Getter |Animation                                  |
|GetAnimationFileName                        |Getter |Animation                                  |
|AddPackageIdle                              |Setter |Animation, Package                         |
|RemovePackageIdle                           |Setter |Animation, Package                         |
|IdleHelp                                    |Action |Animation, Reference                       |
|GetSlotMask                                 |Getter |Armor                                      |
|SetSlotMask                                 |Setter |Armor                                      |
|AddSlotToMask                               |Setter |Armor                                      |
|RemoveSlotFromMask                          |Setter |Armor                                      |
|GetMaskForSlot                              |Getter |Armor                                      |
|GetArmorModelPath                           |Getter |Armor                                      |
|SetArmorModelPath                           |Setter |Armor                                      |
|GetArmorIconPath                            |Getter |Armor                                      |
|SetArmorIconPath                            |Setter |Armor                                      |
|GetArmorMessageIconPath                     |Getter |Armor                                      |
|SetArmorMessageIconPath                     |Setter |Armor                                      |
|GetArmorAddonModelPath                      |Getter |Armor                                      |
|SetArmorAddonModelPath                      |Setter |Armor                                      |
|GetArmorNumArmorAddons                      |Getter |Armor                                      |
|GetArmorNthArmorAddon                       |Getter |Armor                                      |
|GetArmorModelArmorAddons                    |Getter |Armor                                      |
|GetArmorAddons                              |Getter |Armor                                      |
|GetArmorAddonSlotMask                       |Getter |Armor                                      |
|SetArmorAddonSlotMask                       |Setter |Armor                                      |
|AddArmorAddonSlotToMask                     |Setter |Armor                                      |
|RemoveArmorAddonSlotFromMask                |Setter |Armor                                      |
|GetArmorWarmthRating                        |Getter |Armor                                      |
|GetArmorArmorRating                         |Getter |Armor                                      |
|SetArmorArmorRating                         |Setter |Armor                                      |
|GetTNGSlot52Mods                            |Getter |Armor                                      |
|TNGSlot52ModBehavior                        |Action |Armor                                      |
|SetSILNakedSlotMask                         |Setter |Armor                                      |
|ArmorSlotMaskHasPartOf                      |Getter |Armor                                      |
|ArmorAddonSlotMaskHasPartOf                 |Getter |Armor                                      |
|GetArmorWeightClass                         |Getter |Armor, Class, Customization                |
|SetArmorWeightClass                         |Setter |Armor, Class, Customization                |
|FindAllArmorsForSlot                        |Action |Armor, Debug                               |
|GetAllArmorsForSlotMask                     |Getter |Armor, Debug                               |
|RemoveAllArmorReferenceOverrides            |Setter |Armor, Debug, NiOverride, Reference        |
|GetArmorEnchantment                         |Getter |Armor, Enchantment                         |
|RemoveArmorAddonOverride                    |Setter |Armor, NiOverride                          |
|GetRaceSlotMask                             |Getter |Armor, Race                                |
|SetRaceSlotMask                             |Setter |Armor, Race                                |
|AddRaceSlotToMask                           |Setter |Armor, Race                                |
|GetRaceSlotMask                             |Getter |Armor, Race                                |
|SetRaceSlotMask                             |Setter |Armor, Race                                |
|AddRaceSlotToMask                           |Setter |Armor, Race                                |
|RemoveRaceSlotFromMask                      |Setter |Armor, Race                                |
|AddAdditionalRaceToArmorAddon               |Setter |Armor, Race                                |
|RemoveAdditionalRaceFromArmorAddon          |Setter |Armor, Race                                |
|RaceSlotMaskHasPartOf                       |Getter |Armor, Race                                |
|GetArmorAddonRaces                          |Getter |Armor, Race                                |
|ArmorAddonHasRace                           |Getter |Armor, Race                                |
|GetRaceSlots                                |Getter |Armor, Race                                |
|SlotHelp                                    |Action |Armor, Reference                           |
|GetArmorAddonModelNumTextureSets            |Getter |Armor, TextureSet                          |
|GetArmorAddonModelNthTextureSet             |Getter |Armor, TextureSet                          |
|SetArmorAddonModelNthTextureSet             |Setter |Armor, TextureSet                          |
|ReplaceArmorTextureSet                      |Setter |Armor, TextureSet                          |
|GetEquippedArmorInSlot                      |Getter |Armor, UI                                  |
|StopArtObject                               |Action |Art Model                                  |
|SetArtObject                                |Setter |Art Model                                  |
|GetHitEffectArt                             |Getter |Art Model                                  |
|SetArtModelPath                             |Setter |Art Model                                  |
|SetHitEffectArt                             |Setter |Art Model                                  |
|GetArtModelPath                             |Getter |Art Model                                  |
|GetVisualEffectArtObject                    |Getter |Art Model                                  |
|SetVisualEffectArtObject                    |Getter |Art Model                                  |
|GetAllArtObjects                            |Getter |Art Model, Debug                           |
|GetEnchantArt                               |Getter |Art Model, Enchantment                     |
|SetEnchantArt                               |Setter |Art Model, Enchantment                     |
|GetHazardArt                                |Getter |Art Model, Hazard                          |
|SetHazardArt                                |Setter |Art Model, Hazard                          |
|GetCastingArt                               |Getter |Art Model, Spell                           |
|SetCastingArt                               |Setter |Art Model, Spell                           |
|GetArtObjectNthTextureSet                   |Getter |Art Model, TextureSet                      |
|SetArtObjectNthTextureSet                   |Setter |Art Model, TextureSet                      |
|ToggleChildNode                             |Action |Body                                       |
|GetNodePropertyFloat                        |Getter |Body                                       |
|GetNodePropertyInt                          |Getter |Body                                       |
|GetNodePropertyBool                         |Getter |Body                                       |
|GetNodePropertyString                       |Getter |Body                                       |
|QueueNiNodeUpdate                           |Action |Body                                       |
|GetABFaceMorph                              |Getter |Body                                       |
|SetABFaceMorph                              |Setter |Body                                       |
|MoveToNode                                  |Action |Body                                       |
|GetBodyMorph                                |Getter |Body                                       |
|SetBodyMorph                                |Setter |Body                                       |
|RemoveAllNodeReferenceOverrides             |Setter |Body, Debug, NiOverride, Reference         |
|HasNodeOverride                             |Getter |Body, NiOverride                           |
|AddNodeOverrideFloat                        |Setter |Body, NiOverride                           |
|AddNodeOverrideInt                          |Setter |Body, NiOverride                           |
|AddNodeOverrideBool                         |Setter |Body, NiOverride                           |
|AddNodeOverrideString                       |Setter |Body, NiOverride                           |
|GetNodeOverrideFloat                        |Getter |Body, NiOverride                           |
|GetNodeOverrideInt                          |Getter |Body, NiOverride                           |
|GetNodeOverrideBool                         |Getter |Body, NiOverride                           |
|GetNodeOverrideString                       |Getter |Body, NiOverride                           |
|ApplyNodeOverrides                          |Action |Body, NiOverride                           |
|AddNodeOverrideTextureSet                   |Setter |Body, NiOverride, TextureSet               |
|GetNodeOverrideTextureSet                   |Getter |Body, NiOverride, TextureSet               |
|NodeHelp                                    |Action |Body, Reference                            |
|BodyMorphHelp                               |Action |Body, Reference                            |
|MorphHelp                                   |Action |Body, Reference                            |
|GetRefNodeNames                             |Getter |Body, Reference                            |
|ForceFirstPerson                            |Action |Camera                                     |
|ForceThirdPerson                            |Action |Camera                                     |
|GetWorldFieldOfView                         |Getter |Camera                                     |
|SetWorldFieldOfView                         |Setter |Camera                                     |
|GetFirstPersonFieldOfView                   |Getter |Camera                                     |
|GetFirstPersonFOV                           |Getter |Camera                                     |
|SetFirstPersonFieldOfView                   |Setter |Camera                                     |
|SetFirstPersonFOV                           |Setter |Camera                                     |
|UpdateThirdPerson                           |Action |Camera                                     |
|SetCameraTarget                             |Setter |Camera                                     |
|SetFreeCameraSpeed                          |Setter |Camera                                     |
|GetMapMarkerIconType                        |Getter |Cell/Worldspace                            |
|SetMapMarkerIconType                        |Setter |Cell/Worldspace                            |
|GetMapMarkerName                            |Getter |Cell/Worldspace                            |
|SetMapMarkerName                            |Setter |Cell/Worldspace                            |
|GetActualWaterLevel                         |Getter |Cell/Worldspace                            |
|GetWaterLevel                               |Getter |Cell/Worldspace                            |
|SetMapMarkerVisible                         |Getter |Cell/Worldspace                            |
|SetCanFastTravelToMarker                    |Setter |Cell/Worldspace                            |
|CreateXMarkerRef                            |Action |Cell/Worldspace, Creature, Reference       |
|CreateSoundMarker                           |Action |Cell/Worldspace, Creature, Sound           |
|GetAllMapMarkerRefs                         |Getter |Cell/Worldspace, Debug, Reference          |
|GetQuestMarker                              |Getter |Cell/Worldspace, Quest                     |
|GetCellOrWorldSpaceOriginForRef             |Getter |Cell/Worldspace, Reference                 |
|SetCellOrWorldSpaceOriginForRef             |Setter |Cell/Worldspace, Reference                 |
|GetCurrentMapMarkerRefs                     |Getter |Cell/Worldspace, Reference                 |
|GetABClass                                  |Getter |Class                                      |
|SetABClass                                  |Setter |Class                                      |
|GetSlowTimeMult                             |Getter |Combat Style                               |
|SetSlowTimeMult                             |Setter |Combat Style                               |
|GetTNGRgMult                                |Getter |Combat Style                               |
|SetTNGRgMult                                |Setter |Combat Style                               |
|GetCSOffensiveMult                          |Getter |Combat Style                               |
|GetCSDefensiveMult                          |Getter |Combat Style                               |
|GetCSGroupOffensiveMult                     |Getter |Combat Style                               |
|GetCSMeleeMult                              |Getter |Combat Style                               |
|GetCSRangedMult                             |Getter |Combat Style                               |
|GetCSShoutMult                              |Getter |Combat Style                               |
|GetCSStaffMult                              |Getter |Combat Style                               |
|GetCSUnarmedMult                            |Getter |Combat Style                               |
|SetCSOffensiveMult                          |Setter |Combat Style                               |
|SetCSDefensiveMult                          |Setter |Combat Style                               |
|SetCSGroupOffensiveMult                     |Setter |Combat Style                               |
|SetCSMeleeMult                              |Setter |Combat Style                               |
|SetCSRangedMult                             |Setter |Combat Style                               |
|SetCSShoutMult                              |Setter |Combat Style                               |
|SetCSStaffMult                              |Setter |Combat Style                               |
|SetCSUnarmedMult                            |Setter |Combat Style                               |
|GetCSMeleeAttackStaggeredMult               |Getter |Combat Style                               |
|GetCSMeleePowerAttackStaggeredMult          |Getter |Combat Style                               |
|GetCSMeleePowerAttackBlockingMult           |Getter |Combat Style                               |
|GetCSMeleeBashMult                          |Getter |Combat Style                               |
|GetCSMeleeBashRecoiledMult                  |Getter |Combat Style                               |
|GetCSMeleeBashAttackMult                    |Getter |Combat Style                               |
|GetCSMeleeBashPowerAttackMult               |Getter |Combat Style                               |
|GetCSMeleeSpecialAttackMult                 |Getter |Combat Style                               |
|SetCSMeleeAttackStaggeredMult               |Setter |Combat Style                               |
|SetCSMeleePowerAttackStaggeredMult          |Setter |Combat Style                               |
|SetCSMeleePowerAttackBlockingMult           |Setter |Combat Style                               |
|SetCSMeleeBashMult                          |Setter |Combat Style                               |
|SetCSMeleeBashRecoiledMult                  |Setter |Combat Style                               |
|SetCSMeleeBashAttackMult                    |Setter |Combat Style                               |
|SetCSMeleeBashPowerAttackMult               |Setter |Combat Style                               |
|SetCSMeleeSpecialAttackMult                 |Setter |Combat Style                               |
|GetCSCloseRangeDuelingCircleMult            |Getter |Combat Style                               |
|SetCSCloseRangeDuelingCircleMult            |Setter |Combat Style                               |
|GetCSLongRangeStrafeMult                    |Getter |Combat Style                               |
|SetCSLongRangeStrafeMult                    |Setter |Combat Style                               |
|GetCSCloseRangeDuelingFallbackMult          |Getter |Combat Style, Debug                        |
|SetCSCloseRangeDuelingFallbackMult          |Setter |Combat Style, Debug                        |
|GetCSMagicMult                              |Getter |Combat Style, Magic Effect                 |
|SetCSMagicMult                              |Setter |Combat Style, Magic Effect                 |
|GetConstructibleObjectResult                |Getter |Constructible Object                       |
|SetConstructibleObjectResult                |Setter |Constructible Object                       |
|GetConstructibleObjectResultQuantity        |Getter |Constructible Object                       |
|SetConstructibleObjectResultQuantity        |Setter |Constructible Object                       |
|RemoveInvalidConstructibleObjects           |Setter |Constructible Object                       |
|CreateConstructibleObject                   |Action |Constructible Object, Creature             |
|GetAllConstructibleObjects                  |Getter |Constructible Object, Debug                |
|GetConstructibleObjectWorkbenchKeyword      |Getter |Constructible Object, Enchantment, Keyword |
|SetConstructibleObjectWorkbenchKeyword      |Setter |Constructible Object, Enchantment, Keyword |
|GetConstructibleObjectNumIngredients        |Getter |Constructible Object, Ingredient           |
|GetConstructibleObjectNthIngredient         |Getter |Constructible Object, Ingredient           |
|SetConstructibleObjectNthIngredient         |Setter |Constructible Object, Ingredient           |
|GetConstructibleObjectNthIngredientQuantity |Getter |Constructible Object, Ingredient           |
|SetConstructibleObjectNthIngredientQuantity |Setter |Constructible Object, Ingredient           |
|GetMappedControl                            |Getter |Container                                  |
|GetVendorFactionContainer                   |Getter |Container, Faction                         |
|GetMenuContainer                            |Getter |Container, UI                              |
|CreatePersistentForm                        |Getter |Creature                                   |
|CreateFormList                              |Getter |Creature                                   |
|CreateColorForm                             |Action |Creature, Customization                    |
|CreateUICallback                            |Action |Creature, Debug, UI                        |
|CreateKeyword                               |Action |Creature, Keyword                          |
|CreateTextureSet                            |Setter |Creature, TextureSet                       |
|UpdateWeight                                |Action |Customization                              |
|SetHairColor                                |Setter |Customization                              |
|SetSkinColor                                |Setter |Customization                              |
|RevertOverlays                              |Action |Customization                              |
|SetHeight                                   |Setter |Customization                              |
|GetHeight                                   |Getter |Customization                              |
|BlendColorWithSkinTone                      |Action |Customization                              |
|RevertSkinOverlays                          |Action |Customization                              |
|SetFogColor                                 |Setter |Customization                              |
|GetColorFormColor                           |Getter |Customization                              |
|SetColorFormColor                           |Setter |Customization                              |
|RevertHeadOverlays                          |Action |Customization, Head Part                   |
|GetABNumOverlayHeadParts                    |Getter |Customization, Head Part                   |
|GetABNthOverlayHeadPart                     |Getter |Customization, Head Part                   |
|GetABIndexOfOverlayHeadPartByType           |Getter |Customization, Head Part                   |
|SetMembraneColorKeyData                     |Setter |Customization, Key                         |
|SetParticleColorKeyData                     |Setter |Customization, Key, Visual Effects         |
|GetLightColor                               |Getter |Customization, Light                       |
|SetLightColor                               |Setter |Customization, Light                       |
|SetItemDyeColor                             |Setter |Customization, NiOverride                  |
|ClearItemDyeColor                           |Action |Customization, NiOverride                  |
|UpdateItemDyeColor                          |Action |Customization, NiOverride                  |
|GetItemDyeColor                             |Getter |Customization, NiOverride                  |
|SetItemTextureLayerColor                    |Setter |Customization, NiOverride, TextureSet      |
|GetItemTextureLayerColor                    |Getter |Customization, NiOverride, TextureSet      |
|ClearItemTextureLayerColor                  |Action |Customization, NiOverride, TextureSet      |
|GetFormTypeAll                              |Getter |Debug                                      |
|DismissAllSummons                           |Getter |Debug                                      |
|SetChargeTimeAll                            |Setter |Debug                                      |
|AllowPCDialogue                             |Action |Debug                                      |
|RemAllItems                                 |Action |Debug                                      |
|RemoveAllInventoryEventFilters              |Setter |Debug                                      |
|GetFormInfo                                 |Getter |Debug                                      |
|GetAllTNGAddonsCount                        |Getter |Debug                                      |
|GetAllTNGPossibleAddons                     |Getter |Debug                                      |
|GetTNGRgInfo                                |Getter |Debug                                      |
|TNGWhyProblem                               |Action |Debug                                      |
|GetCSAllowDualWielding                      |Getter |Debug                                      |
|SetCSAllowDualWielding                      |Setter |Debug                                      |
|GetAllOutfitParts                           |Getter |Debug                                      |
|WhyHostile                                  |Action |Debug                                      |
|GetFactionInformation                       |Getter |Debug, Faction                             |
|GetAllHeadParts                             |Getter |Debug, Head Part                           |
|RemoveAllPackageOverride                    |Setter |Debug, NiOverride, Package                 |
|RemoveAllSkinReferenceOverrides             |Setter |Debug, NiOverride, Reference               |
|RemoveAllWeaponReferenceOverrides           |Setter |Debug, NiOverride, Reference, Weapon       |
|RemoveAllPerks                              |Setter |Debug, Perk                                |
|RemoveAllPerks                              |Setter |Debug, Perk                                |
|RemoveAllVisiblePerks                       |Getter |Debug, Perk                                |
|FindAllReferencesOfFormType                 |Action |Debug, Reference                           |
|FindAllReferencesOfType                     |Action |Debug, Reference                           |
|GetAllRefsInGrid                            |Getter |Debug, Reference                           |
|GetReferenceInfo                            |Getter |Debug, Reference                           |
|RemoveAllSpells                             |Setter |Debug, Spell                               |
|GetAllTexturePaths                          |Getter |Debug, TextureSet                          |
|StopAllShaders                              |Action |Debug, Visual Effects                      |
|GetAllEffectShaders                         |Getter |Debug, Visual Effects                      |
|SetDoorDestination                          |Setter |Door                                       |
|PlaceDoor                                   |Action |Door                                       |
|StartDraggingObject                         |Action |Dragon                                     |
|GetEnchantment                              |Getter |Enchantment                                |
|SetEnchantment                              |Setter |Enchantment                                |
|EnchantObject                               |Action |Enchantment                                |
|LearnEnchantment                            |Action |Enchantment                                |
|GetKnownEnchantments                        |Getter |Enchantment                                |
|AddMagicEffectToEnchantment                 |Setter |Enchantment, Magic Effect                  |
|RemoveMagicEffectFromEnchantment            |Setter |Enchantment, Magic Effect                  |
|CastEnchantment                             |Action |Enchantment, Spell                         |
|GetEnchantShader                            |Getter |Enchantment, Visual Effects                |
|SetEnchantShader                            |Setter |Enchantment, Visual Effects                |
|GetWeaponEnchantment                        |Getter |Enchantment, Weapon                        |
|GetFactionOwner                             |Getter |Faction                                    |
|ClearCachedFactionFightReactions            |Action |Faction                                    |
|FactionFlagHelp                             |Action |Faction, Reference                         |
|GetFootstepSet                              |Getter |Footstep                                   |
|SetFootstepSet                              |Setter |Footstep                                   |
|SetOutfit                                   |Setter |General                                    |
|Dismount                                    |Getter |General                                    |
|AddToMap                                    |Setter |General                                    |
|SelectCrosshair                             |Action |General                                    |
|SetSkinAlpha                                |Setter |General                                    |
|MarkFavorite                                |Action |General                                    |
|UnmarkFavorite                              |Action |General                                    |
|CopyAppearance                              |Action |General                                    |
|Teleport                                    |Action |General                                    |
|SaveEx                                      |Action |General                                    |
|Del                                         |Action |General                                    |
|GetFormIDFromEditorID                       |Getter |General                                    |
|GetEDIDFromFormID                           |Getter |General                                    |
|GetFormModName                              |Getter |General                                    |
|GetConditionList                            |Getter |General                                    |
|Sleep                                       |Action |General                                    |
|SetItemHealthPercent                        |Setter |General                                    |
|SetDisplayName                              |Getter |General                                    |
|ClearDestruction                            |Action |General                                    |
|SaveCharacter                               |Action |General                                    |
|LoadCharacter                               |Action |General                                    |
|GetDialogueTarget                           |Getter |General                                    |
|TriggerScreenBlood                          |Action |General                                    |
|SetItemMaxCharge                            |Setter |General                                    |
|SetItemCharge                               |Setter |General                                    |
|SetRestrained                               |Setter |General                                    |
|RGBToInt                                    |Action |General                                    |
|PrintArgsAsStrings                          |Action |General                                    |
|GetWorldFOV                                 |Getter |General                                    |
|SetWorldFOV                                 |Setter |General                                    |
|SetClipBoardText                            |Setter |General                                    |
|BlockActivation                             |Action |General                                    |
|PreventDetection                            |Action |General                                    |
|KillSilent                                  |Action |General                                    |
|KillEssential                               |Action |General                                    |
|ClearForcedMovement                         |Action |General                                    |
|SetUnconscious                              |Setter |General                                    |
|Duplicate                                   |Action |General                                    |
|SetHarvested                                |Setter |General                                    |
|SetOpen                                     |Setter |General                                    |
|GetMaterialType                             |Getter |General                                    |
|GetButtonForDXScanCode                      |Getter |General                                    |
|EnableSurvivalFeature                       |Action |General                                    |
|DisableSurvivalFeature                      |Getter |General                                    |
|StartCannibal                               |Action |General                                    |
|GetButtonForDXScanCode                      |Getter |General                                    |
|GetQuality                                  |Getter |General                                    |
|SetQuality                                  |Setter |General                                    |
|TrainWith                                   |Action |General                                    |
|GetSkillLegendaryLevel                      |Getter |General                                    |
|SetSkillLegendaryLevel                      |Setter |General                                    |
|ApplyMeleeHit                               |Action |General                                    |
|ApplyHit                                    |Action |General                                    |
|SetRecordFlag                               |Setter |General                                    |
|ClearRecordFlag                             |Action |General                                    |
|IsRecordFlagSet                             |Getter |General                                    |
|GetItemHealthPercent                        |Getter |General                                    |
|GetOutfit                                   |Getter |General                                    |
|RemoveFormFromFormlist                      |Getter |General                                    |
|GetOutfitNumParts                           |Getter |General                                    |
|GetOutfitNthPart                            |Getter |General                                    |
|UnsetOutfit                                 |Action |General                                    |
|StartSneaking                               |Action |General                                    |
|SetDontMove                                 |Setter |General                                    |
|SetPublic                                   |Setter |General                                    |
|SetFogPower                                 |Setter |General                                    |
|SetFogPlanes                                |Setter |General                                    |
|GetItemMaxCharge                            |Getter |General                                    |
|GetWorldModelPath                           |Getter |General                                    |
|SetWorldModelPath                           |Setter |General                                    |
|CopyWorldModelPath                          |Action |General                                    |
|GetABFacePreset                             |Getter |General                                    |
|SetABFacePreset                             |Setter |General                                    |
|GetABSkinFar                                |Getter |General                                    |
|SetABSkinFar                                |Setter |General                                    |
|GetABTemplate                               |Getter |General                                    |
|SetAutoLock                                 |Setter |General                                    |
|GetNumKeysPressed                           |Getter |General                                    |
|PrecacheCharGenClear                        |Action |General                                    |
|ModObjectiveGlobal                          |Action |General                                    |
|SetEffectFlag                               |Setter |General                                    |
|ClearEffectFlag                             |Action |General                                    |
|IsEffectFlagSet                             |Getter |General                                    |
|GetLocationCleared                          |Getter |General                                    |
|SetLocationCleared                          |Setter |General                                    |
|GetLocationParent                           |Getter |General                                    |
|SetLocationParent                           |Setter |General                                    |
|GetLocalGravity                             |Getter |General                                    |
|FindForm                                    |Action |General                                    |
|GetAddonModels                              |Getter |General                                    |
|SetAddonModels                              |Setter |General                                    |
|KnockAreaEffect                             |Action |General                                    |
|PlayImpactEffect                            |Action |General                                    |
|ApplyHavokImpulse                           |Action |General                                    |
|GetWornItemID                               |Getter |General                                    |
|SendTrespassAlarm                           |Action |General                                    |
|ClearArrested                               |Action |General                                    |
|ClearExtraArrows                            |Action |General                                    |
|ClearLookAt                                 |Action |General                                    |
|ForceMovementSpeed                          |Action |General                                    |
|ForceMovementRotationSpeed                  |Action |General                                    |
|ForceMovementSpeedRamp                      |Action |General                                    |
|ScaleObject3D                               |Action |General                                    |
|SendModEvent                                |Action |General                                    |
|SayTopic                                    |Action |General                                    |
|GetKeycodeString                            |Getter |General                                    |
|GetFormsInFormList                          |Getter |General                                    |
|GetGlobalVariable                           |Getter |General                                    |
|SetLocalGravity                             |Setter |General                                    |
|SelectObjectUnderFeet                       |Action |General                                    |
|GetTNGBoolValue                             |Getter |General                                    |
|SetTNGBoolValue                             |Setter |General                                    |
|GetTNGRgNames                               |Getter |General                                    |
|GetTNGRgAddons                              |Getter |General                                    |
|GetTNGRgAddon                               |Getter |General                                    |
|SetTNGRgAddon                               |Setter |General                                    |
|TNGSwapRevealing                            |Action |General                                    |
|UpdateTNGSettings                           |Setter |General                                    |
|UpdateTNGLogLvl                             |Action |General                                    |
|ShowTNGLogLocation                          |Action |General                                    |
|GetTNGErrDscr                               |Getter |General                                    |
|GetCSAvoidThreatChance                      |Getter |General                                    |
|SetCSAvoidThreatChance                      |Setter |General                                    |
|GetCSCloseRangeFlankingFlankDistance        |Getter |General                                    |
|GetCSCloseRangeFlankingStalkTime            |Getter |General                                    |
|SetCSCloseRangeFlankingFlankDistance        |Getter |General                                    |
|SetCSCloseRangeFlankingStalkTime            |Setter |General                                    |
|SetObjectiveText                            |Setter |General                                    |
|GetAutorunLines                             |Getter |General                                    |
|AddAutorunLine                              |Setter |General                                    |
|RemoveAutorunLine                           |Setter |General                                    |
|AddFormsToFormlist                          |Getter |General                                    |
|AddFormToFormlists                          |Getter |General                                    |
|PlaceBefore                                 |Action |General                                    |
|GetWornForms                                |Getter |General                                    |
|RemoveDecals                                |Setter |General                                    |
|Reload                                      |Action |General                                    |
|StartWhiterunAttack                         |Action |General                                    |
|AdvanceCustomSkill                          |Action |General                                    |
|IncrementCustomSkill                        |Action |General                                    |
|GetSkillName                                |Getter |General                                    |
|GetSkillLevel                               |Getter |General                                    |
|SetExpressionPhoneme                        |Setter |General                                    |
|SetExpressionModifier                       |Setter |General                                    |
|GetHazardIMOD                               |Getter |Hazard                                     |
|GetHazardIMODRadius                         |Getter |Hazard                                     |
|GetHazardIPDS                               |Getter |Hazard                                     |
|GetHazardLifetime                           |Getter |Hazard                                     |
|GetHazardLimit                              |Getter |Hazard                                     |
|GetHazardRadius                             |Getter |Hazard                                     |
|GetHazardTargetInterval                     |Getter |Hazard                                     |
|IsHazardFlagSet                             |Getter |Hazard                                     |
|ClearHazardFlag                             |Action |Hazard                                     |
|SetHazardFlag                               |Setter |Hazard                                     |
|SetHazardIMOD                               |Setter |Hazard                                     |
|SetHazardIMODRadius                         |Setter |Hazard                                     |
|SetHazardIPDS                               |Setter |Hazard                                     |
|SetHazardLifetime                           |Setter |Hazard                                     |
|SetHazardLimit                              |Setter |Hazard                                     |
|SetHazardRadius                             |Setter |Hazard                                     |
|SetHazardTargetInterval                     |Setter |Hazard                                     |
|GetHazardLight                              |Getter |Hazard, Light                              |
|SetHazardLight                              |Setter |Hazard, Light                              |
|GetHazardSound                              |Getter |Hazard, Sound                              |
|SetHazardSound                              |Setter |Hazard, Sound                              |
|GetHazardSpell                              |Getter |Hazard, Spell                              |
|SetHazardSpell                              |Setter |Hazard, Spell                              |
|ReplaceHeadPart                             |Action |Head Part                                  |
|ChangeHeadPart                              |Action |Head Part                                  |
|RegenerateHead                              |Action |Head Part                                  |
|GetNthHeadPart                              |Getter |Head Part                                  |
|SetNthHeadPart                              |Setter |Head Part                                  |
|SetHeadpartAlpha                            |Setter |Head Part                                  |
|GetABNumHeadParts                           |Getter |Head Part                                  |
|GetABNthHeadPart                            |Getter |Head Part                                  |
|SetABNthHeadPart                            |Setter |Head Part                                  |
|GetABIndexOfHeadPartByType                  |Getter |Head Part                                  |
|GetHeadPartType                             |Getter |Head Part                                  |
|SetHeadpartValidRaces                       |Setter |Head Part, Race                            |
|GetHeadpartValidRaces                       |Getter |Head Part, Race                            |
|HeadpartHelp                                |Action |Head Part, Reference                       |
|SetHeadPartTextureSet                       |Setter |Head Part, TextureSet                      |
|GetHeadPartTextureSet                       |Getter |Head Part, TextureSet                      |
|GetTreeIngredient                           |Getter |Ingredient                                 |
|SetTreeIngredient                           |Setter |Ingredient                                 |
|GetIngredientNthEffectArea                  |Getter |Ingredient                                 |
|SetIngredientNthEffectArea                  |Setter |Ingredient                                 |
|GetIngredientNthEffectMagnitude             |Getter |Ingredient                                 |
|SetIngredientNthEffectMagnitude             |Setter |Ingredient                                 |
|GetIngredientNthEffectDuration              |Getter |Ingredient                                 |
|SetIngredientNthEffectDuration              |Setter |Ingredient                                 |
|GetFloraIngredient                          |Getter |Ingredient                                 |
|SetFloraIngredient                          |Setter |Ingredient                                 |
|LearnIngredientEffect                       |Action |Ingredient                                 |
|CastIngredient                              |Action |Ingredient, Spell                          |
|AddKeyIfNeeded                              |Setter |Key                                        |
|SetKey                                      |Setter |Key                                        |
|TapKey                                      |Action |Key                                        |
|HoldKey                                     |Action |Key                                        |
|ReleaseKey                                  |Action |Key                                        |
|IsKeyPressed                                |Getter |Key                                        |
|GetNthKeyPressed                            |Getter |Key                                        |
|GetMappedKey                                |Getter |Key                                        |
|AddKeywordToForm                            |Setter |Keyword                                    |
|RemoveKeywordFromForm                       |Setter |Keyword                                    |
|GetLocationKeywordData                      |Getter |Keyword                                    |
|SetLocationKeywordData                      |Setter |Keyword                                    |
|GetKeywords                                 |Getter |Keyword                                    |
|AddKeyword                                  |Setter |Keyword                                    |
|RemoveKeyword                               |Setter |Keyword                                    |
|ReplaceKeyword                              |Action |Keyword                                    |
|GetKeyword                                  |Getter |Keyword                                    |
|CopyKeywords                                |Action |Keyword                                    |
|AddKeywordsToForm                           |Setter |Keyword                                    |
|RemoveKeywordsFromForm                      |Setter |Keyword                                    |
|AddKeywordToForms                           |Setter |Keyword                                    |
|RemoveKeywordFromForms                      |Setter |Keyword                                    |
|FindKeywordOnForm                           |Action |Keyword                                    |
|AddKeywordToRef                             |Setter |Keyword, Reference                         |
|RemoveKeywordFromRef                        |Setter |Keyword, Reference                         |
|AddFormToLeveledItem                        |Setter |Leveled Object                             |
|RevertLeveledItem                           |Action |Leveled Object                             |
|GetLeveledItemChanceNone                    |Getter |Leveled Object                             |
|SetLeveledItemChanceNone                    |Setter |Leveled Object                             |
|GetLeveledItemChanceGlobal                  |Getter |Leveled Object                             |
|SetLeveledItemChanceGlobal                  |Setter |Leveled Object                             |
|GetLeveledItemNumForms                      |Getter |Leveled Object                             |
|GetLeveledItemNthForm                       |Getter |Leveled Object                             |
|GetLeveledItemNthLevel                      |Getter |Leveled Object                             |
|SetLeveledItemNthLevel                      |Setter |Leveled Object                             |
|GetLeveledItemNthCount                      |Getter |Leveled Object                             |
|SetLeveledItemNthCount                      |Setter |Leveled Object                             |
|FlattenLeveledList                          |Getter |Leveled Object                             |
|GetLightFade                                |Getter |Light                                      |
|GetLightFOV                                 |Getter |Light                                      |
|GetLightRadius                              |Getter |Light                                      |
|GetLightRGB                                 |Getter |Light                                      |
|GetLightShadowDepthBias                     |Getter |Light                                      |
|GetLightType                                |Getter |Light                                      |
|SetLightFade                                |Setter |Light                                      |
|SetLightFOV                                 |Setter |Light                                      |
|SetLightRadius                              |Setter |Light                                      |
|SetLightRGB                                 |Setter |Light                                      |
|SetLightShadowDepthBias                     |Setter |Light                                      |
|SetLightType                                |Setter |Light                                      |
|GetCSFlightHoverChance                      |Getter |Light                                      |
|GetCSFlightDiveBombChance                   |Getter |Light                                      |
|GetCSFlightFlyingAttackChance               |Getter |Light                                      |
|SetCSFlightHoverChance                      |Setter |Light                                      |
|SetCSFlightDiveBombChance                   |Setter |Light                                      |
|GetLightingTemplate                         |Getter |Light                                      |
|SetLightingTemplate                         |Setter |Light                                      |
|GetMagicEffectLight                         |Getter |Light, Magic Effect                        |
|SetMagicEffectLight                         |Setter |Light, Magic Effect                        |
|AddMagicEffect                              |Setter |Magic Effect                               |
|ClearMagicEffects                           |Action |Magic Effect                               |
|CopyMagicEffects                            |Action |Magic Effect                               |
|GetMagicEffectAssociatedSkill               |Getter |Magic Effect                               |
|SetMagicEffectAssociatedSkill               |Setter |Magic Effect                               |
|GetMagicEffectResistance                    |Getter |Magic Effect                               |
|SetMagicEffectResistance                    |Getter |Magic Effect                               |
|GetMagicEffectImpactDataSet                 |Getter |Magic Effect                               |
|SetMagicEffectImpactDataSet                 |Setter |Magic Effect                               |
|GetMagicEffectImageSpaceMod                 |Getter |Magic Effect                               |
|SetMagicEffectImageSpaceMod                 |Setter |Magic Effect                               |
|GetMagicEffectExplosion                     |Getter |Magic Effect                               |
|SetMagicEffectExplosion                     |Setter |Magic Effect                               |
|GetMagicEffectProjectile                    |Getter |Magic Effect                               |
|SetMagicEffectProjectile                    |Setter |Magic Effect                               |
|GetMagicEffectSkillLevel                    |Getter |Magic Effect                               |
|SetMagicEffectSkillLevel                    |Setter |Magic Effect                               |
|GetMagicEffectBaseCost                      |Getter |Magic Effect                               |
|SetMagicEffectBaseCost                      |Setter |Magic Effect                               |
|GetMagicEffectArea                          |Getter |Magic Effect                               |
|SetMagicEffectArea                          |Setter |Magic Effect                               |
|GetMagicEffectAssociatedForm                |Getter |Magic Effect                               |
|GetMagicEffectArchetype                     |Getter |Magic Effect                               |
|GetFormMagicEffects                         |Getter |Magic Effect                               |
|GetMagicEffectPerk                          |Getter |Magic Effect, Perk                         |
|SetMagicEffectPerk                          |Setter |Magic Effect, Perk                         |
|MagicEffectHelp                             |Action |Magic Effect, Reference                    |
|SetMagicEffectSound                         |Setter |Magic Effect, Sound                        |
|GetMagicEffectSound                         |Getter |Magic Effect, Sound                        |
|AddMagicEffectToSpell                       |Setter |Magic Effect, Spell                        |
|RemoveMagicEffectFromSpell                  |Setter |Magic Effect, Spell                        |
|SetSpellMagicEffect                         |Setter |Magic Effect, Spell                        |
|GetSpellMagicEffects                        |Getter |Magic Effect, Spell                        |
|GetMagicEffectCastTime                      |Getter |Magic Effect, Spell                        |
|SetMagicEffectCastTime                      |Setter |Magic Effect, Spell                        |
|GetMagicEffectEquipAbility                  |Getter |Magic Effect, UI                           |
|SetMagicEffectEquipAbility                  |Setter |Magic Effect, UI                           |
|GetCurrentMusicType                         |Getter |Music                                      |
|GetNumberOfTracksInMusicType                |Getter |Music                                      |
|GetMusicTypeTrackIndex                      |Getter |Music                                      |
|SetMusicTypeTrackIndex                      |Setter |Music                                      |
|GetMusicTypePriority                        |Getter |Music                                      |
|SetMusicTypePriority                        |Setter |Music                                      |
|SetPlayerAIDriven                           |Setter |NiOverride                                 |
|SetPlayersLastRiddenHorse                   |Setter |NiOverride                                 |
|GetItemUniqueID                             |Getter |NiOverride                                 |
|GetObjectUniqueID                           |Getter |NiOverride                                 |
|ApplySkinOverrides                          |Action |NiOverride                                 |
|GetSeasonOverride                           |Getter |NiOverride                                 |
|SetSeasonOverride                           |Setter |NiOverride                                 |
|ClearSeasonOverride                         |Action |NiOverride                                 |
|MakePlayerFriend                            |Action |NiOverride                                 |
|ClearExpressionOverride                     |Action |NiOverride                                 |
|ResetExpressionOverrides                    |Action |NiOverride                                 |
|AddPackageOverride                          |Setter |NiOverride, Package                        |
|RemovePackageOverride                       |Setter |NiOverride, Package                        |
|CountPackageOverride                        |Action |NiOverride, Package                        |
|ClearPackageOverride                        |Action |NiOverride, Package                        |
|NiOverrideHelp                              |Action |NiOverride, Reference                      |
|GetLastPlayerActivatedRef                   |Getter |NiOverride, Reference                      |
|GetLastPlayerMenuActivatedRef               |Getter |NiOverride, Reference, UI                  |
|SetSpellCostOverride                        |Setter |NiOverride, Spell                          |
|SetItemTextureLayerType                     |Setter |NiOverride, TextureSet                     |
|GetItemTextureLayerType                     |Getter |NiOverride, TextureSet                     |
|ClearItemTextureLayerType                   |Action |NiOverride, TextureSet                     |
|SetItemTextureLayerTexture                  |Setter |NiOverride, TextureSet                     |
|GetItemTextureLayerTexture                  |Getter |NiOverride, TextureSet                     |
|ClearItemTextureLayerTexture                |Action |NiOverride, TextureSet                     |
|SetItemTextureLayerBlendMode                |Setter |NiOverride, TextureSet                     |
|GetItemTextureLayerBlendMode                |Getter |NiOverride, TextureSet                     |
|ClearItemTextureLayerBlendMode              |Action |NiOverride, TextureSet                     |
|UpdateItemTextureLayers                     |Action |NiOverride, TextureSet                     |
|AddSkinOverrideTextureSet                   |Setter |NiOverride, TextureSet                     |
|AddWeaponOverrideTextureSet                 |Setter |NiOverride, TextureSet, Weapon             |
|ApplyWeaponOverrides                        |Action |NiOverride, Weapon                         |
|MoveToPackageLocation                       |Action |Package                                    |
|GetRunningPackage                           |Getter |Package                                    |
|GetPackageTemplate                          |Getter |Package                                    |
|VCSAddPerk                                  |Setter |Perk                                       |
|VCSRemovePerk                               |Setter |Perk                                       |
|SetSpellCastingPerk                         |Setter |Perk, Spell                                |
|ForceAddRagdollToWorld                      |Setter |Physics                                    |
|ForceRemoveRagdollFromWorld                 |Setter |Physics                                    |
|GetActiveQuests                             |Getter |Quest                                      |
|GetQuestAliases                             |Getter |Quest                                      |
|GetRefAliases                               |Getter |Quest, Reference                           |
|GetRefAliasesWithScriptAttached             |Getter |Quest, Reference, Script                   |
|GetAliasesWithScriptAttached                |Getter |Quest, Script                              |
|GetRace                                     |Getter |Race                                       |
|SetRaceFlag                                 |Setter |Race                                       |
|ClearRaceFlag                               |Action |Race                                       |
|IsRaceFlagSet                               |Getter |Race                                       |
|GetRaceSkin                                 |Getter |Race                                       |
|SetRaceSkin                                 |Setter |Race                                       |
|GetRaceDefaultVoiceType                     |Getter |Race                                       |
|SetRaceDefaultVoiceType                     |Setter |Race                                       |
|RaceHelp                                    |Action |Race, Reference                            |
|ShowLimitedRaceMenu                         |Action |Race, UI                                   |
|VCSHelp                                     |Action |Reference                                  |
|FormTypeHelp                                |Action |Reference                                  |
|PlaceAroundReference                        |Action |Reference                                  |
|RecordSignatureHelp                         |Action |Reference                                  |
|PathToReference                             |Action |Reference                                  |
|SetLinkedRef                                |Setter |Reference                                  |
|GetAshPileLinkedRef                         |Getter |Reference                                  |
|CollisionHelp                               |Getter |Reference                                  |
|AVHelp                                      |Action |Reference                                  |
|FormRecordHelp                              |Action |Reference                                  |
|SetObjectRefFlag                            |Setter |Reference                                  |
|FormHelp                                    |Action |Reference                                  |
|ResetReference                              |Action |Reference                                  |
|DeleteReference                             |Action |Reference                                  |
|DisableReference                            |Getter |Reference                                  |
|ShowAsHelpMessage                           |Action |Reference                                  |
|ResetHelpMessage                            |Action |Reference                                  |
|SpellFlagHelp                               |Action |Reference, Spell                           |
|MenuHelp                                    |Action |Reference, UI                              |
|SetRefAsNoAIAcquire                         |Setter |Reference, UI                              |
|RefreshItemMenu                             |Action |Reference, UI                              |
|GetCurrentScene                             |Getter |Scene                                      |
|ForceStartScene                             |Action |Scene                                      |
|StartScene                                  |Action |Scene                                      |
|StopScene                                   |Action |Scene                                      |
|IsScenePlaying                              |Getter |Scene                                      |
|AttachPapyrusScript                         |Action |Script                                     |
|GetFormDescription                          |Getter |Script                                     |
|GetScriptsAttachedToActiveEffect            |Getter |Script                                     |
|SetDescription                              |Setter |Script                                     |
|ResetDescription                            |Action |Script                                     |
|GetFormsWithScriptAttached                  |Getter |Script                                     |
|IsScriptAttachedToForm                      |Getter |Script                                     |
|GetScriptsAttachedToForm                    |Getter |Script                                     |
|SetSoundDescriptor                          |Setter |Script, Sound                              |
|PlaySoundDescriptor                         |Action |Script, Sound                              |
|PlaySound                                   |Action |Sound                                      |
|SoundPause                                  |Action |Sound                                      |
|SoundUnpause                                |Action |Sound                                      |
|SoundMute                                   |Action |Sound                                      |
|SoundUnmute                                 |Action |Sound                                      |
|SetVolume                                   |Setter |Sound                                      |
|SetSpellTomeSpell                           |Setter |Spell                                      |
|SetSpellAutoCalculate                       |Setter |Spell                                      |
|SetSpellChargeTime                          |Setter |Spell                                      |
|SetSpellCastDuration                        |Setter |Spell                                      |
|SetSpellRange                               |Setter |Spell                                      |
|LaunchSpell                                 |Action |Spell                                      |
|GetSpellType                                |Getter |Spell                                      |
|SetSpellCastingType                         |Setter |Spell                                      |
|SetSpellDeliveryType                        |Setter |Spell                                      |
|SetSpellType                                |Setter |Spell                                      |
|DispelEffect                                |Getter |Spell                                      |
|GetCastTime                                 |Getter |Spell                                      |
|CombineSpells                               |Action |Spell                                      |
|GetABSpells                                 |Getter |Spell                                      |
|VCSEquipSpell                               |Action |Spell, UI                                  |
|GetEquippedSpell                            |Getter |Spell, UI                                  |
|GetSpellEquipType                           |Getter |Spell, UI                                  |
|SetSpellEquipType                           |Setter |Spell, UI                                  |
|CopySpellEquipType                          |Action |Spell, UI                                  |
|SetEyeTexture                               |Setter |TextureSet                                 |
|ReplaceFaceTextureSet                       |Setter |TextureSet                                 |
|ReplaceSkinTextureSet                       |Setter |TextureSet                                 |
|SetNthTexturePath                           |Setter |TextureSet                                 |
|GetNthTexturePath                           |Getter |TextureSet                                 |
|GetTextureSetNumPaths                       |Getter |TextureSet                                 |
|GetMembraneFillTexture                      |Getter |TextureSet                                 |
|GetMembraneHolesTexture                     |Getter |TextureSet                                 |
|GetMembranePaletteTexture                   |Getter |TextureSet                                 |
|SetMembraneFillTexture                      |Setter |TextureSet                                 |
|SetMembraneHolesTexture                     |Setter |TextureSet                                 |
|SetMembranePaletteTexture                   |Setter |TextureSet                                 |
|GetWorldModelNthTextureSet                  |Getter |TextureSet                                 |
|SetWorldModelNthTextureSet                  |Setter |TextureSet                                 |
|GetWorldModelTextureSets                    |Getter |TextureSet                                 |
|GetParticlePaletteTexture                   |Getter |TextureSet, Visual Effects                 |
|GetParticleShaderTexture                    |Getter |TextureSet, Visual Effects                 |
|SetParticlePaletteTexture                   |Setter |TextureSet, Visual Effects                 |
|SetParticleShaderTexture                    |Setter |TextureSet, Visual Effects                 |
|ShowGiftMenu                                |Action |UI                                         |
|ShowBarterMenu                              |Action |UI                                         |
|ShowMenu                                    |Action |UI                                         |
|HideMenu                                    |Action |UI                                         |
|ToggleOpenSleepWaitMenu                     |Action |UI                                         |
|GetEquipType                                |Getter |UI                                         |
|SetEquipType                                |Setter |UI                                         |
|VCSEquipItem                                |Action |UI                                         |
|VCSEquipShout                               |Action |UI                                         |
|GetLastMenuOpened                           |Getter |UI                                         |
|TemperEquipment                             |Action |UI                                         |
|TemperWornEquipment                         |Action |UI                                         |
|GetEquippedShout                            |Getter |UI                                         |
|GetEquippedShield                           |Getter |UI                                         |
|VCSUnequipItem                              |Action |UI                                         |
|SwapEquipment                               |Action |UI                                         |
|OpenCustomSkillMenu                         |Action |UI                                         |
|ShowCustomTrainingMenu                      |Action |UI                                         |
|GetEquippedWeapon                           |Getter |UI, Weapon                                 |
|SetVampire                                  |Setter |Vampire                                    |
|Bite                                        |Action |Vampire                                    |
|TurnVampire                                 |Action |Vampire                                    |
|TurnBetterVampire                           |Action |Vampire                                    |
|VampireFeed                                 |Action |Vampire                                    |
|ApplyMaterialShader                         |Action |Visual Effects                             |
|GetHitShader                                |Getter |Visual Effects                             |
|SetHitShader                                |Setter |Visual Effects                             |
|PlayDebugShader                             |Action |Visual Effects                             |
|SetShaderType                               |Setter |Visual Effects                             |
|GetEffectShaderTotalCount                   |Getter |Visual Effects                             |
|IsEffectShaderFlagSet                       |Getter |Visual Effects                             |
|GetParticleFullCount                        |Getter |Visual Effects                             |
|GetParticlePersistentCount                  |Getter |Visual Effects                             |
|ClearEffectShaderFlag                       |Action |Visual Effects                             |
|SetEffectShaderFlag                         |Setter |Visual Effects                             |
|SetParticlePersistentCount                  |Getter |Visual Effects                             |
|DrawWeapon                                  |Action |Weapon                                     |
|SheatheWeapon                               |Action |Weapon                                     |
|GetWeaponModelPath                          |Getter |Weapon                                     |
|SetWeaponModelPath                          |Setter |Weapon                                     |
|GetWeaponIconPath                           |Getter |Weapon                                     |
|SetWeaponIconPath                           |Setter |Weapon                                     |
|GetWeaponMessageIconPath                    |Getter |Weapon                                     |
|SetWeaponMessageIconPath                    |Setter |Weapon                                     |

License
===
To whatever extent I may be able to free this code to the wildest reaches of the Internet, it is free to use and redistribute with attribution in whatever means one decides.
