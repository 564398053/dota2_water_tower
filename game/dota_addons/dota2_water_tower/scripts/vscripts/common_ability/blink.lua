-- the shared abilities
blink = class({})

function blink:OnSpellStart()
    local hCaster = self:GetCaster()
    local hTargetPos = hCaster:GetCursorPosition()
    
    local hero = hCaster:GetPlayerOwner():GetAssignedHero()
    local playerID = hero:GetPlayerID()
    local player = PlayerResource:GetPlayer( playerID )
    
    hero:SetAbsOrigin( hTargetPos )
end
