-- Logic of compond items by skill
compound = class ({})

--[[
Compound table of water tower.
The first is target item, following is required items.
note that the order matters, the entry at top has higher priority
]]
WaterTowerItemCompoundTable6 = 
{   -- target           1               2               3               4               5               6
    --{ "item_dagon5",    "item_dagon2",  "item_dagon2",  "item_dagon2",  "item_dagon2",  "item_dagon2",  "item_dagon2" },
    { "item_ghost",    "item_gem",     "item_gem",     "item_gem",     "item_gem",     "item_gem",     "item_gem" }
}

-- Compound items in player slot 1 & slot 2
WaterTowerItemCompoundTable2 = 
{
    -- target           1                       2
    --{ "item_dagon3",    "item_dagon2",          "item_dagon2" },
    --{ "item_ghost",     "item_glimmer_cape",    "item_glimmer_cape" },
    { "item_glimmer_cape",    "item_gem",             "item_gem" },
    { "item_warglaive_of_azzinoth_right", "item_glimmer_cape", "item_glimmer_cape" },
}

-- Compound items at arbitrary slot of player
WaterTowerItemCompoundTable =
{
    --{ "item_dagon5", "item_dagon3", "item_dagon4", "item_dagon2" },
    { "item_heart", "item_ghost", "item_glimmer_cape" },
}

function compound:OnSpellStart()
    print( "player using skill compound" )
    local hCaster = self:GetCaster()
    local bOk = true
    while bOk do
        bOk = false
        bOk = bOk or compoundItem( hCaster, WaterTowerItemCompoundTable6, getPlayerItemsInAllSixSlot(hCaster) )  -- six same item into one item
        bOk = bOk or compoundItem( hCaster, WaterTowerItemCompoundTable2, getPlayerItemsFirstTwoSlot(hCaster) )  -- first two slot item into one item
        bOk = bOk or compoundItem( hCaster, WaterTowerItemCompoundTable,  getPlayerItemsInAllSixSlot(hCaster) )  -- other items into one item
    end
end

-- return true - new item made, false - no new item
function compoundItem( hCaster, formularTable, playerItems )
    local itemsToRemove = {}
    for formulaIndex, formulaItems in pairs( formularTable ) do
        local targetItemName = formulaItems[1]
        local unmatchedItems = {}
        for k,v in pairs( formulaItems ) do
            if k ~= 1 then  -- index 1 is the targe item
                local item = {};
                item.name = v
                item.match = false
                
                unmatchedItems[#unmatchedItems + 1] = item
            end
        end
        
        for dummy, playerItem in pairs( playerItems ) do
            if playerItem ~= nil then
                for itemIndex, itemRequired in pairs( unmatchedItems ) do
                    if( playerItem:GetName() == itemRequired.name ) then  -- index 1 is the targe item
                        if not itemRequired.match then
                            itemRequired.match = true
                            itemsToRemove[#itemsToRemove + 1] = playerItem
                            break
                        end
                    end
                end
            end
        end
        
        local bAllMatch = true;
        for dummy, item in pairs( unmatchedItems ) do
            if item.match == false then
                bAllMatch = false
                break
            end
        end
        
        print( "bAllMatch", bAllMatch )
        if bAllMatch then
            for k, v in pairs( itemsToRemove ) do
                print( "RemoveItem", v:GetName() )
                hCaster:RemoveItem( v )
            end
                
            hCaster:AddItemByName( targetItemName )
            print( "AddItem", targetItemName )
            return true -- done
        end
    end
    
    return false
end

function getPlayerItemsFirstTwoSlot( hCaster )
    local items = {}
    
    items[#items + 1] = hCaster:GetItemInSlot( 0 )
    items[#items + 1] = hCaster:GetItemInSlot( 1 )
    
    return items
end

function getPlayerItemsInAllSixSlot( hCaster )
    local items = {}
    
    items[#items + 1] = hCaster:GetItemInSlot( 0 )
    items[#items + 1] = hCaster:GetItemInSlot( 1 )
    items[#items + 1] = hCaster:GetItemInSlot( 2 )
    items[#items + 1] = hCaster:GetItemInSlot( 3 )
    items[#items + 1] = hCaster:GetItemInSlot( 4 )
    items[#items + 1] = hCaster:GetItemInSlot( 5 )
    
    return items
end