#include "script_component.hpp"

ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#include "initSettings.inc.sqf"

if (!hasInterface) exitWith { ADDON = true; };

["All", "init", LINKFUNC(compileMenu)] call CBA_fnc_addClassEventHandler;

GVAR(ActNamespace) = createHashMap;
GVAR(ActSelfNamespace) = createHashMap;

// Compile actions for CAManBase now and use for all mans types
["CAManBase"] call FUNC(compileMenu);
GVAR(cacheManActions) = +(GVAR(ActNamespace) getOrDefault ["CAManBase" call EFUNC(common,getConfigName), []]); // copy

// Event handlers for all interact menu controls
DFUNC(handleMouseMovement) = {
    if ([GVAR(cursorKeepCentered), GVAR(cursorKeepCenteredSelfInteraction)] select GVAR(keyDownSelfAction)) then {
        GVAR(cursorPos) = GVAR(cursorPos) vectorAdd [_this select 1, _this select 2, 0] vectorDiff [0.5, 0.5, 0];
        setMousePosition [0.5, 0.5];
    } else {
        GVAR(cursorPos) = [_this select 1, _this select 2, 0];
    };
};
DFUNC(handleMouseButtonDown) = {
    if !(GVAR(actionOnKeyRelease)) then {
        [GVAR(openedMenuType),true] call FUNC(keyUp);
    };
};

GVAR(keyDown) = false;
GVAR(keyDownSelfAction) = false;
GVAR(keyDownTime) = 0;
GVAR(openedMenuType) = -1;

GVAR(lastTime) = diag_tickTime;
GVAR(rotationAngle) = 0;

GVAR(selectedAction) = [[],[]];
GVAR(actionSelected) = false;
GVAR(selectedTarget) = objNull;

GVAR(menuDepthPath) = [];
GVAR(lastPos) = [0,0,0];

GVAR(currentOptions) = [];

GVAR(lastPath) = [];

GVAR(expanded) = false;

GVAR(startHoverTime) = diag_tickTime;
GVAR(expandedTime) = diag_tickTime;

// reset on mission load
addMissionEventHandler ["Loaded", {
    GVAR(startHoverTime) = 0;
    GVAR(expandedTime) = 0;
}];

GVAR(iconCtrls) = [];
GVAR(iconCount) = 0;

GVAR(collectedActionPoints) = [];
GVAR(foundActions) = [];
GVAR(lastTimeSearchedActions) = -1000;

// Selector positioning
GVAR(SELECTOR_LIST_X) = 0.014;
GVAR(SELECTOR_LIST_Y) = 0.014;
GVAR(SELECTOR_LIST_W) = 0.05;
GVAR(SELECTOR_LIST_H) = 0.035;
GVAR(SELECTOR_RADIAL_X) = 0.0505;
GVAR(SELECTOR_RADIAL_Y) = 0.0125;
GVAR(SELECTOR_RADIAL_W) = 0.1;
GVAR(SELECTOR_RADIAL_H) = 0.035;
if (str (getResolution select 4) == "3.55556") then { // 32:9
    GVAR(SELECTOR_LIST_X) = 0.012;
    GVAR(SELECTOR_LIST_Y) = 0.0125;
};

// Init zeus menu
[] call FUNC(compileMenuZeus);

// Handle addActionToClass with Inheritance flag set (CAManBase actions are seperated for speed)
GVAR(inheritedActionsAll) = [];
GVAR(inheritedClassesAll) = [];
GVAR(inheritedActionsMan) = [];
GVAR(inheritedClassesMan) = [];

["All", "InitPost", {
    BEGIN_COUNTER(InitPost);
    params ["_object"];
    private _type = typeOf _object;

    if (GVAR(inheritedClassesAll) pushBackUnique _type == -1) exitWith { END_COUNTER(InitPost); };

    {
        _x params ["_objectType", "_typeNum", "_parentPath", "_action", "_excludedClasses"];
        if (_type isKindOf _objectType && {_excludedClasses findIf {_type isKindOf _x} == -1}) then {
            [_type, _typeNum, _parentPath, _action] call FUNC(addActionToClass);
        };
    } forEach GVAR(inheritedActionsAll);
    END_COUNTER(InitPost);
}] call CBA_fnc_addClassEventHandler;
["CAManBase", "InitPost", {
    BEGIN_COUNTER(InitPost);
    params ["_object"];
    private _type = typeOf _object;

    if (GVAR(inheritedClassesMan) pushBackUnique _type == -1) exitWith { END_COUNTER(InitPost); };
    {
        _x params ["_typeNum", "_parentPath", "_action", "_excludedClasses"];
        if (_excludedClasses findIf {_type isKindOf _x} == -1) then { // skip excluded classes and children
            [_type, _typeNum, _parentPath, _action] call FUNC(addActionToClass);
        };
    } forEach GVAR(inheritedActionsMan);
    END_COUNTER(InitPost);
}, true, ["VirtualMan_F"]] call CBA_fnc_addClassEventHandler;

ADDON = true;
