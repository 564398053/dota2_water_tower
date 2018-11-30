// Even if the code is not re-executed, if a javascript file with a Game.AddCommand
// is recompiled mid-game, the command completely breaks.

// They even need their own independent XML file. As just throwing it in as an
// include in the custom_ui_manifest.xml file will cause it to break.

// Hence, their relegation to isolation here.

function WrapFunction(name) {
    return function() {
        (name)();
    };
}

// add a default empty handler to stop waring in console.
Game.WT.OnDefault = function()
{
}

Game.AddCommand( '+ToggleBuildingPanel', Game.WT.OnToggleBuildingPanel, '', 0 );
Game.AddCommand( '-ToggleBuildingPanel', Game.WT.OnDefault, '', 0 );

$.Msg("[PUI] Game.AddCommand ", '+ToggleBuildingPanel ', Game.WT.OnToggleBuildingPanel);