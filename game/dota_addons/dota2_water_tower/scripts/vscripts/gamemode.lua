
DEBUG_SPEW = 1

HERO_ABILITY_TABLE_DEFAULT_LV1 = 
{
    "compound",
    "blink",
    "build_npc_dota_tower_basedef",
    "build_ranger_first_stage",
    "build_ranger_middle_stage",
    "build_ranger_final_stage",
    "build_ranger_beastmaster_Lv1",
}

function CustomGameMode:InitGameMode()
    GameRules:GetGameModeEntity():SetFogOfWarDisabled( true )
    GameRules:GetGameModeEntity():SetCustomGameForceHero( "npc_dota_hero_windrunner" )

	-- Get Rid of Shop button - Change the UI Layout if you want a shop button
	GameRules:GetGameModeEntity():SetHUDVisible(6, false)
	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1300)

	-- DebugPrint
	Convars:RegisterConvar('debug_spew', tostring(DEBUG_SPEW), 'Set to 1 to start spewing debug info. Set to 0 to disable.', 0)
	
	-- Event Hooks
	ListenToGameEvent('entity_killed', Dynamic_Wrap(CustomGameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(CustomGameMode, 'OnPlayerPickHero'), self)
    ListenToGameEvent('player_chat', Dynamic_Wrap(CustomGameMode, 'OnPlayerChat'), self)
    ListenToGameEvent('player_spawn', Dynamic_Wrap(CustomGameMode, 'OnPlayerSpawn'), self)
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(CustomGameMode, 'OnNpcSpawned'), self)

	-- Filters
    GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( CustomGameMode, "FilterExecuteOrder" ), self )

    -- Register Listener
    CustomGameEventManager:RegisterListener( "update_selected_entities", Dynamic_Wrap(CustomGameMode, 'OnPlayerSelectedEntities'))
   	CustomGameEventManager:RegisterListener( "repair_order", Dynamic_Wrap(CustomGameMode, "RepairOrder"))  	
    CustomGameEventManager:RegisterListener( "building_helper_build_command", Dynamic_Wrap(BuildingHelper, "BuildCommand"))
	CustomGameEventManager:RegisterListener( "building_helper_cancel_command", Dynamic_Wrap(BuildingHelper, "CancelCommand"))
	
	-- Full units file to get the custom values
	GameRules.AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
  	GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
  	GameRules.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
  	GameRules.ItemKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")
  	GameRules.Requirements = LoadKeyValues("scripts/kv/tech_tree.kv")

  	-- Store and update selected units of each pID
	GameRules.SELECTED_UNITS = {}

	-- Keeps the blighted gridnav positions
	GameRules.Blight = {}
end

-- A player picked a hero
function CustomGameMode:OnPlayerPickHero(keys)
	local hero = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
	local playerID = hero:GetPlayerID()
    
    -- set the initial skill of hero
    local abilityCount = hero:GetAbilityCount()
    local i = 0;
    while i < abilityCount do
        local ability = hero:GetAbilityByIndex( i )
        if ability then
            local abilityName = ability:GetName()
            for k, v in pairs( HERO_ABILITY_TABLE_DEFAULT_LV1 ) do
                if abilityName == v then
                    ability:SetLevel( 1 )
                end
            end
        end
        
        i = i + 1
    end

	-- Initialize Variables for Tracking
	player.units = {} -- This keeps the handle of all the units of the player, to iterate for unlocking upgrades
	player.structures = {} -- This keeps the handle of the constructed units, to iterate for unlocking upgrades
	player.buildings = {} -- This keeps the name and quantity of each building
	player.upgrades = {} -- This kees the name of all the upgrades researched
	player.lumber = 0 -- Secondary resource of the player

    -- Create city center in front of the hero
    local position = hero:GetAbsOrigin() + hero:GetForwardVector() * 300
    local city_center_name = "city_center"
	local building = BuildingHelper:PlaceBuilding(player, city_center_name, position, true, 5) 

	-- Set health to test repair
	building:SetHealth(building:GetMaxHealth()/3)

	-- These are required for repair to know how many resources the building takes
	building.GoldCost = 100
	building.LumberCost = 100
	building.BuildTime = 15

	-- Add the building to the player structures list
	player.buildings[city_center_name] = 1
	table.insert(player.structures, building)

	CheckAbilityRequirements( hero, player )
	CheckAbilityRequirements( building, player )

	-- Add the hero to the player units list
	table.insert(player.units, hero)
	hero.state = "idle" --Builder state

	-- Give Initial Resources
	hero:SetGold(990000, false)
	ModifyLumber(player, 5000)

	-- Lumber tick
	Timers:CreateTimer(1, function()
		ModifyLumber(player, 10)
		return 10
	end)

	-- Give a building ability
	local item = CreateItem("item_build_wall", hero, hero)
	hero:AddItem(item)
end

-- An entity died
function CustomGameMode:OnEntityKilled( event )
    -- create a drop item
    local killedEntity = EntIndexToHScript(event.entindex_killed)
    if killedEntity ~= nil then
        CreateDrop("item_flask", killedEntity:GetAbsOrigin())
    end

	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript(event.entindex_killed)
	-- The Killing entity
	local killerEntity
	if event.entindex_attacker then
		killerEntity = EntIndexToHScript(event.entindex_attacker)
	end

	-- Player owner of the unit
	local player = killedUnit:GetPlayerOwner()

	-- Building Killed
	if IsCustomBuilding(killedUnit) then

		 -- Building Helper grid cleanup
		BuildingHelper:RemoveBuilding(killedUnit, true)

		-- Check units for downgrades
		local building_name = killedUnit:GetUnitName()
				
		-- Substract 1 to the player building tracking table for that name
		if player.buildings[building_name] then
			player.buildings[building_name] = player.buildings[building_name] - 1
		end

		-- possible unit downgrades
		for k,units in pairs(player.units) do
		    CheckAbilityRequirements( units, player )
		end

		-- possible structure downgrades
		for k,structure in pairs(player.structures) do
			CheckAbilityRequirements( structure, player )
		end
	end

	-- Cancel queue of a builder when killed
	if IsBuilder(killedUnit) then
		BuildingHelper:ClearQueue(killedUnit)
	end

	-- Table cleanup
	if player then
		-- Remake the tables
		local table_structures = {}
		for _,building in pairs(player.structures) do
			if building and IsValidEntity(building) and building:IsAlive() then
				--print("Valid building: "..building:GetUnitName())
				table.insert(table_structures, building)
			end
		end
		player.structures = table_structures
		
		local table_units = {}
		for _,unit in pairs(player.units) do
			if unit and IsValidEntity(unit) then
				table.insert(table_units, unit)
			end
		end
		player.units = table_units		
	end
end

-- Called whenever a player changes its current selection, it keeps a list of entity indexes
function CustomGameMode:OnPlayerSelectedEntities( event )
	local pID = event.pID

	GameRules.SELECTED_UNITS[pID] = event.selected_entities

	-- This is for Building Helper to know which is the currently active builder
	local mainSelected = GetMainSelectedEntity(pID)
	if IsValidEntity(mainSelected) and IsBuilder(mainSelected) then
		local player = PlayerResource:GetPlayer(pID)
		player.activeBuilder = mainSelected
	end
end

-- create drop item
function CreateDrop (itemName, pos)
   local newItem = CreateItem(itemName, nil, nil)
   newItem:SetPurchaseTime(0)
   CreateItemOnPositionSync(pos, newItem)
   newItem:LaunchLoot(false, 300, 0.75, pos + RandomVector(RandomFloat(50, 350)))
 end
 
-- on player chart
function CustomGameMode:OnPlayerChat(keys)
    print("player chart")
    for key,val in pairs(keys) do
        print(key, val)
    end
    local playerid = keys.playerid
    local player = PlayerResource:GetPlayer(playerid)
    local hero = player:GetAssignedHero()
    local position = hero:GetAbsOrigin()
    
    if keys.text == "m" then 
        CreateDrop("item_glimmer_cape", position)
        CreateDrop("item_gem", position)
    elseif keys.text == "e" then
        GenerateEnemy()
    end
end

-- on npc spawned
function CustomGameMode:OnNpcSpawned(keys)
end

-- on play spawned
function CustomGameMode:OnPlayerSpawn(event)
end

function GenerateEnemy()
    for i=1, 16 do
        local entityStart = Entities:FindByName(nil, "player1_path_corner_start")
        local enemyUnit = CreateUnitByName("bad_guy_Lv1", entityStart:GetOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS)
 
        enemyUnit:SetMustReachEachGoalEntity(true)
        enemyUnit:SetInitialGoalEntity(entityStart)
        enemyUnit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
    end
end
