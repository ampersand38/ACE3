[
    QEGVAR(medical,alternateArmorPenetration),
    "CHECKBOX",
    [LSTRING(AlternateArmorPenetration_DisplayName), LSTRING(AlternateArmorPenetration_Description)],
    ELSTRING(medical,Category),
    true,
    1
] call CBA_fnc_addSetting;

[
    QEGVAR(medical,fatalDamageSource),
    "LIST",
    [LSTRING(fatalDamageSource_DisplayName), LSTRING(fatalDamageSource_Description)],
    ELSTRING(medical,Category),
    [[0, 1, 2], [LSTRING(fatalDamageSource_vitalShotsOnly), LSTRING(fatalDamageSource_trauma), LSTRING(fatalDamageSource_both)], 2],
    true
] call CBA_fnc_addSetting;

[
    QEGVAR(medical,playerDamageThreshold),
    "SLIDER",
    [LSTRING(PlayerDamageThreshold_DisplayName), LSTRING(PlayerDamageThreshold_Description)],
    ELSTRING(medical,Category),
    [0, 25, 1, 2],
    true
] call CBA_fnc_addSetting;

[
    QEGVAR(medical,AIDamageThreshold),
    "SLIDER",
    [LSTRING(AIDamageThreshold_DisplayName), LSTRING(AIDamageThreshold_Description)],
    ELSTRING(medical,Category),
    [0, 25, 1, 2],
    true
] call CBA_fnc_addSetting;

[
    QEGVAR(medical,useLimbDamage),
    "LIST",
    [LSTRING(useLimbDamage_DisplayName), LSTRING(useLimbDamage_Description)],
    ELSTRING(medical,Category),
    [[0, 1, 2], [ELSTRING(common,Never), ELSTRING(common,aiOnly), ELSTRING(common,playersAndAI)], 0],
    1
] call CBA_fnc_addSetting;

[
    QEGVAR(medical,limbDamageThreshold),
    "SLIDER",
    [LSTRING(limbDamageThreshold_DisplayName), LSTRING(limbDamageThreshold_Description)],
    ELSTRING(medical,Category),
    [0, 25, 5, 2],
    1
] call CBA_fnc_addSetting;

[
    QEGVAR(medical,painUnconsciousChance),
    "SLIDER",
    [LSTRING(PainUnconsciousChance_DisplayName), LSTRING(PainUnconsciousChance_Description)],
    ELSTRING(medical,Category),
    [0, 1, 0.1, 2, true],
    true
] call CBA_fnc_addSetting;

[
    QEGVAR(medical,painUnconsciousThreshold),
    "SLIDER",
    [LSTRING(PainUnconsciousThreshold_DisplayName), LSTRING(PainUnconsciousThreshold_Description)],
    ELSTRING(medical,Category),
    [0, 1, 0.5, 2, false],
    true
] call CBA_fnc_addSetting;

[
    QEGVAR(medical,deathChance),
    "SLIDER",
    [LSTRING(deathChance_DisplayName), LSTRING(deathChance_Description)],
    ELSTRING(medical,Category),
    [0, 1, 1, 2, true],
    true
] call CBA_fnc_addSetting;
