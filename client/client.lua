-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local fishing = false

if Config.sellShop.enabled then
    CreateThread(function()
        local ped, textUI
        CreateBlip(Config.sellShop.coords, 356, 1, Strings.sell_shop_blip, 0.80)
        local point = lib.points.new({
            coords = Config.sellShop.coords,
            distance = 30
        })

        function point:nearby()
            if self.currentDistance < self.distance then
                if not ped then
                    lib.requestAnimDict('mini@strip_club@idles@bouncer@base', 100)
                    lib.requestModel(Config.sellShop.ped, 100)
                    ped = CreatePed(28, Config.sellShop.ped, Config.sellShop.coords.x, Config.sellShop.coords.y, Config.sellShop.coords.z, Config.sellShop.heading, false, false)
                    FreezeEntityPosition(ped, true)
                    SetEntityInvincible(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    TaskPlayAnim(ped, 'mini@strip_club@idles@bouncer@base', 'base', 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                end
                if self.currentDistance <= 1.8 then
                    if not textUI then
                        lib.showTextUI(Strings.sell_fish)
                        textUI = true
                    end
                    if IsControlJustReleased(0, 38) then
                        FishingSellItems()
                    end
                elseif self.currentDistance >= 1.9 and textUI then
                    lib.hideTextUI()
                    textUI = nil
                end
            end
        end

        function point:onExit()
            if ped then
                local model = GetEntityModel(ped)
                SetModelAsNoLongerNeeded(model)
                DeletePed(ped)
                SetPedAsNoLongerNeeded(ped)
                RemoveAnimDict('mini@strip_club@idles@bouncer@base')
                ped = nil
            end
        end
    end)
end

RegisterNetEvent('wasabi_fishing:startFishing', function()
    if IsPedInAnyVehicle(cache.ped) or IsPedSwimming(cache.ped) then
        TriggerEvent('wasabi_fishing:notify', Strings.cannot_perform, Strings.cannot_perform_desc, 'error')
        return
    end
    local hasItem = lib.callback.await('wasabi_fishing:checkItem', 100, Config.bait.itemName)
    if hasItem then
        local water, waterLoc = WaterCheck()
        if water then
            if not fishing then
                fishing = true
                local model = `prop_fishing_rod_01`
                lib.requestModel(model, 100)
                local pole = CreateObject(model, GetEntityCoords(cache.ped), true, false, false)
                AttachEntityToEntity(pole, cache.ped, GetPedBoneIndex(cache.ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
                SetModelAsNoLongerNeeded(model)
                lib.requestAnimDict('mini@tennis', 100)
                lib.requestAnimDict('amb@world_human_stand_fishing@idle_a', 100)
                TaskPlayAnim(cache.ped, 'mini@tennis', 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
                Wait(3000)
                TaskPlayAnim(cache.ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 1.0, -1.0, 1.0, 11, 0, 0, 0, 0)
                while fishing do
                    Wait()
                    local unarmed = `WEAPON_UNARMED`
                    SetCurrentPedWeapon(ped, unarmed)
                    ShowHelp(Strings.intro_instruction)
                    DisableControlAction(0, 24, true)
                    if IsDisabledControlJustReleased(0, 24) then
                        TaskPlayAnim(cache.ped, 'mini@tennis', 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
                        TriggerEvent('wasabi_fishing:notify', Strings.waiting_bite, Strings.waiting_bite_desc, 'inform')
                        Wait(math.random(Config.timeForBite.min, Config.timeForBite.max))
                        TriggerEvent('wasabi_fishing:notify', Strings.got_bite, Strings.got_bite_desc, 'inform')
                        Wait(1000)
                        local fishData = lib.callback.await('wasabi_fishing:getFishData', 100)
                        if lib.skillCheck(fishData.difficulty) then
                            ClearPedTasks(cache.ped)
                            TryFish(fishData)
                            TaskPlayAnim(cache.ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 1.0, -1.0, 1.0, 11, 0, 0, 0, 0)
                        else
                            local breakChance = math.random(1,100)
                            if breakChance < Config.fishingRod.breakChance then
                                TriggerServerEvent('wasabi_fishing:rodBroke')
                                TriggerEvent('wasabi_fishing:notify', Strings.rod_broke, Strings.rod_broke_desc, 'error')
                                ClearPedTasks(cache.ped)
                                fishing = false
                                break
                            end
                            TriggerEvent('wasabi_fishing:notify', Strings.failed_fish, Strings.failed_fish_desc, 'error')
                        end
                    elseif IsControlJustReleased(0, 194) then
                        ClearPedTasks(cache.ped)
                        break
                    elseif #(GetEntityCoords(cache.ped) - waterLoc) > 30 then
                        break
                    end
                end
                fishing = false
                DeleteObject(pole)
                RemoveAnimDict('mini@tennis')
                RemoveAnimDict('amb@world_human_stand_fishing@idle_a')
            end
        else
            TriggerEvent('wasabi_fishing:notify', Strings.no_water, Strings.no_water_desc, 'error')
        end
    else
        TriggerEvent('wasabi_fishing:notify', Strings.no_bait, Strings.no_bait_desc, 'error')
    end
end)

RegisterNetEvent('wasabi_fishing:interupt', function()
    fishing = false
    ClearPedTasks(cache.ped)
end)
