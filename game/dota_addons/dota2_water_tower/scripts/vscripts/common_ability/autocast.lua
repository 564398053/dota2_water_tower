-- 攻击时自动施法
function AutocastOnAttack( event )
    local ability = event.ability
    local caster = event.caster
    local target = event.target
    local toggle_state = caster:Attribute_GetIntValue("AbilityToggleState", 1)

    print("AbilityToggleState", toggle_state)

    caster:SetCursorCastTarget(target)

    if ability:IsCooldownReady() and toggle_state == 1 then
        ability:CastAbility()
    end
end

-- 开启/关闭自动施法
function ToggleAutocast( event )
    local ability = event.ability
    local caster = event.caster

    -- set all ablities with the same toggle state
    local toggle_state = 0
   	if ability:GetToggleState() then
   		toggle_state = 1
   	end

   	caster:Attribute_SetIntValue("AbilityToggleState", toggle_state)
end