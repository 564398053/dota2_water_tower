-- the shared abilities
blink = class({})

function blink:OnSpellStart()
    local hCaster = self:GetCaster()
    local hTargetPos = hCaster:GetCursorPosition()
    hCaster:SetOrigin( hTargetPos )
end
