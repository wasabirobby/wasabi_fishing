-----------------For support, scripts, and more----------------
-----------------https://discord.gg/XJFNyMy3Bv-----------------
---------------------------------------------------------------
ESX = nil
local fishing = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    CreateBlip(Config.SellShop, 356, 1, Language['sell_shop_blip'], 0.80)
end)

 --Sell Shop Functionality
 Citizen.CreateThread(function()
	while true do
        local Sleep = 1500
		local player = PlayerPedId()
		local playerCoords = GetEntityCoords(player)
		local dist = #(playerCoords - Config.SellShop)
		if dist <= 10.0 then
            Sleep = 0
            DrawMarker(0, vector3(Config.SellShop.x, Config.SellShop.y, Config.SellShop.z-0.5), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.25, 0.25, 0.25, 255, 205, 0, 100, false, true, 2, true, false, false, false) 
            if dist <= 1.5 then
                DrawText3Ds(Config.SellShop, Language['sell_fish'], 0.55, 1.5, 0.7)
                if IsControlJustReleased(0, 38) and dist <= 1.5 then
                    FishingSellItems(dist)
                end
			end
		end
    Wait(Sleep)
	end
end)

RegisterNetEvent('wasabi_fishing:startFishing')
AddEventHandler('wasabi_fishing:startFishing', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) or IsPedSwimming(ped) then
        TriggerEvent('wasabi_fishing:notify', Language['cannot_perform'])
        return
    end
    ESX.TriggerServerCallback('wasabi_fishing:checkItem', function(cb)
        if cb == true then
            local water, waterLoc = waterCheck()
            if water then
                if not fishing then
                    fishing = true
                    local modelHash = `prop_fishing_rod_01`
                    local model = loadModel(modelHash)
                    local pole = CreateObject(model, GetEntityCoords(PlayerPedId()), true, false, false)
                    AttachEntityToEntity(pole, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
                    SetModelAsNoLongerNeeded(pole)
                    local castDict = loadDict('mini@tennis')
                    local idleDict = loadDict('amb@world_human_stand_fishing@idle_a')
                    TaskPlayAnim(ped, castDict, 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
                    Wait(3000)
                   -- while IsEntityPlayingAnim(ped, "mini@tennis", "forehand_ts_md_far", 3) do
                     --   Wait(0)
                    --end
                    TaskPlayAnim(ped, idleDict, 'idle_c', 1.0, -1.0, 1.0, 11, 0, 0, 0, 0)
                    while fishing do
                        Wait(0)
                        local unarmed = `WEAPON_UNARMED`
                        SetCurrentPedWeapon(ped, unarmed)
                        ShowHelp(Language['intro_instruction'])
                        DisableControlAction(0, 24, true)
                        if IsDisabledControlJustReleased(0, 24) then
                            TaskPlayAnim(ped, castDict, 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
                            local skillbar = exports['skillbar']:CreateSkillbar(1, 'medium')
                            if skillbar then
                                ClearPedTasks(ped)
                                tryFish()
                                TaskPlayAnim(ped, idleDict, 'idle_c', 1.0, -1.0, 1.0, 11, 0, 0, 0, 0)
                            else
                                local breakChance = math.random(1,100)
                                if breakChance < Config.FishingRod.breakChance then
                                    TriggerServerEvent('wasabi_fishing:rodBroke')
                                    TriggerEvent('wasabi_fishing:notify', Language['rod_broke'])
                                    ClearPedTasks(ped)
                                    fishing = false
                                    break
                                end
                                TriggerEvent('wasabi_fishing:notify', Language['failed_fish'])
                            end
                        elseif IsControlJustReleased(0, 194) then
                            ClearPedTasks(ped)
                            break
                        elseif #(GetEntityCoords(ped) - waterLoc) > 30 then
                            break
                        end
                    end
                    fishing = false
                    DeleteObject(pole)
                    RemoveAnimDict('mini@tennis')
                    RemoveAnimDict('amb@world_human_stand_fishing@idle_a')
                end
            else
                TriggerEvent('wasabi_fishing:notify', Language['no_water'])
            end
        elseif cb == false then
            TriggerEvent('wasabi_fishing:notify', Language['no_bait'])
        end
    end, Config.Bait.itemName)
end)


RegisterNetEvent('wasabi_fishing:interupt')
AddEventHandler('wasabi_fishing:interupt', function()
    local ped = PlayerPedId()
    fishing = false
    ClearPedTasks(ped)
end)
