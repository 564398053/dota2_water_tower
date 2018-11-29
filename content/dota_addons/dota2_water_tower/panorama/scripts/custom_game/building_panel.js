"use strict";

$.Msg("load building_panel.js start");;

function BuildUnit(unitName) {
    $.Msg( "In function BuildUnit():", unitName );

    // TODO: 取消当前的技能准备.
    $.DispatchEvent("DOTAHideAbilityTooltip");
    $("#building_panel").ToggleClass("building-panel--hide");

    var order = {
        AbilityIndex : Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), 2 ),
        QueueBehavior : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
        ShowEffects : false,
        OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_CAST_NO_TARGET
    };
    var abilityBehavior = Abilities.GetBehavior( order.AbilityIndex );
    if ( abilityBehavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT )
    {
        order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_POSITION;
        order.Position = GetMouseCastPosition( order.AbilityIndex );
    }

    Game.PrepareUnitOrders( order );
}

// JS directly interact with elements in game.
function OnExecuteAbility1ButtonPressed( cmdName )
{
    $.Msg( "ExecuteAbility1 as " + cmdName );
    // toggle panel
    $("#building_panel_container").ToggleClass("hide");

    // var order = {
    //     AbilityIndex : Entities.GetAbility( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), 1 ),
    //     QueueBehavior : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
    //     ShowEffects : false,
    //     OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_CAST_NO_TARGET
    // };
    // var abilityBehavior = Abilities.GetBehavior( order.AbilityIndex );
    // if ( abilityBehavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT )
    // {
    //     order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_POSITION;
    //     order.Position = GetMouseCastPosition( order.AbilityIndex );
    // }

    // Game.PrepareUnitOrders( order );
}

(function () {
    Game.AddCommand( "+ToggleBuildingPanel", OnExecuteAbility1ButtonPressed, "", 0 );
})();


$.Msg("load building_panel.js complete");