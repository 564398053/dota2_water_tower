'use strict';

if (!Game.WT) { Game.WT = {}; }

Game.WT.building_panel = $( '#building_panel_container' );
Game.WT.OnToggleBuildingPanel = function()
{
    Game.WT.building_panel.ToggleClass( 'hide' );
}

function Cast( abilityName ) {
    $.Msg( '[PUI] Cast ability: ', abilityName );

    // TODO: 取消当前的技能准备.
    $.DispatchEvent( 'DOTAHideAbilityTooltip' );
    $( '#building_panel_container' ).ToggleClass( 'hide' );

    var order = {
        AbilityIndex : Entities.GetAbilityByName( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), abilityName ),
        QueueBehavior : OrderQueueBehavior_t.DOTA_ORDER_QUEUE_NEVER,
        ShowEffects : false,
        OrderType : dotaunitorder_t.DOTA_UNIT_ORDER_CAST_NO_TARGET
    };
    var abilityBehavior = Abilities.GetBehavior( order.AbilityIndex );
    if ( abilityBehavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT )
    {
        order.OrderType = dotaunitorder_t.DOTA_UNIT_ORDER_CAST_POSITION;
        order.Position = GameUI.GetCursorPosition()
        $.Msg( 'order.Position', order.Position );
    }

    Game.PrepareUnitOrders( order );
}

$.Msg( '[PUI] load building_panel.js complete' );