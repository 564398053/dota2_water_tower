function modifier_poison_sting_debuff_datadriven_on_created(keys)
	if keys.target:HasModifier("modifier_plague_ward_datadriven_poison_sting_debuff_movement_speed") then
		keys.target:SetModifierStackCount("modifier_plague_ward_datadriven_poison_sting_debuff_movement_speed", nil, 0)
	end
end

function modifier_poison_sting_debuff_datadriven_on_destroy(keys)
	if keys.target:HasModifier("modifier_plague_ward_datadriven_poison_sting_debuff_movement_speed") then
		keys.target:SetModifierStackCount("modifier_plague_ward_datadriven_poison_sting_debuff_movement_speed", nil, 11)
		
		--Once we become able to determine the caster of a modifier, we can modify the code below to determine the correct
		--the movement speed slow from the current level of Poison Sting.
		--[[local poison_sting_ability = keys.attacker.venomancer_plague_ward_parent:FindAbilityByName("venomancer_poison_sting_datadriven")
		if poison_sting_ability == nil then
			poison_sting_ability = keys.attacker.venomancer_plague_ward_parent:FindAbilityByName("venomancer_poison_sting")
		end
	
		if poison_sting_ability ~= nil then
			local poison_sting_level = poison_sting_ability:GetLevel()
			
			if poison_sting_level > 0 then
				
				keys.target:SetModifierStackCount("modifier_plague_ward_datadriven_poison_sting_debuff_movement_speed", nil, math.abs(poison_sting_ability:GetLevelSpecialValueFor("movement_speed", poison_sting_level - 1)))
			end
		end]]
	end
end