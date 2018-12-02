'use strict';

function pad(num) {
    return ("00" + num).slice(-2);
}

function FormatTime( timeInSeconds ) {
    var hour = Math.floor(timeInSeconds / 3600);
    var minute = Math.floor(timeInSeconds / 60);
    var second = timeInSeconds % 60;

    return pad(hour) + ':' + pad(minute) + ':' + pad(second)
}

function UpdateCurrentLevel( eventArgs )
{
    var nextLevel = eventArgs.current_level + 1;
    $( '#current_level' ).text = $.Localize( '#next_level') + nextLevel;
}

function UpdateNextLevelArriveTime( eventArgs ) {
    $( '#next_level_arrive_time' ).text = FormatTime( eventArgs.next_level_arrive_time )
}

function UpdateTimer( eventArgs ) {
    $( '#timer' ).text = FormatTime( Math.floor(eventArgs.current_time) )
}


(function () {
    GameEvents.Subscribe( 'current_level_changed', UpdateCurrentLevel);
    GameEvents.Subscribe( 'next_level_arrive_time_changed', UpdateNextLevelArriveTime);
    GameEvents.Subscribe( 'current_time_changed', UpdateTimer);
})();