-- autocast the ability
function AutocastOnAttack( event )
    local ability = event.ability
    if ability:IsCooldownReady() then
        ability:CastAbility()
    end
end