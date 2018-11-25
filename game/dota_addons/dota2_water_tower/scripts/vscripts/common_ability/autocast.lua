-- autocast the ability
function AutocastOnAttack( event )
    local ability = event.ability
    local caster = event.caster
    local target = event.target

    caster:SetCursorCastTarget(target)

    if ability:IsCooldownReady() then
        ability:CastAbility()
    end
end