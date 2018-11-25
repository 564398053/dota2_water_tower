function DeathTrack(keys)	
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_item_medallion_of_courage_datadriven_debuff", nil)
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_item_medallion_of_courage_datadriven_debuff", nil)
	
	keys.caster:EmitSound("DOTA_Item.MedallionOfCourage.Activate")
	keys.target:EmitSound("DOTA_Item.MedallionOfCourage.Activate")
end