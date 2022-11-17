-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

ESX = exports['es_extended']:getSharedObject()


lib.callback.register('wasabi_fishing:checkItem', function(source, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname).count
    if item >= 1 then
        return true
    else
        return false
    end
end)

lib.callback.register('wasabi_fishing:getFishData', function(source)
    local data = Config.fish[math.random(#Config.fish)]
    return data
end)

RegisterServerEvent('wasabi_fishing:rodBroke')
AddEventHandler('wasabi_fishing:rodBroke', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(Config.fishingRod.itemName, 1)
    TriggerClientEvent('wasabi_fishing:interupt', source)
end)

RegisterServerEvent('wasabi_fishing:tryFish')
AddEventHandler('wasabi_fishing:tryFish', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPole = xPlayer.getInventoryItem(Config.fishingRod.itemName).count
    local xBait = xPlayer.getInventoryItem(Config.bait.itemName).count
    if xPole > 0 and xBait > 0 then
        local chance = math.random(1,100)
        if chance <= Config.bait.loseChance then
            xPlayer.removeInventoryItem(Config.bait.itemName, 1)
            TriggerClientEvent('wasabi_fishing:notify', source, Strings.bait_lost, Strings.bait_lost_desc, 'error')
        end
        local awardItem = data.item
        local awardLabel = ESX.GetItemLabel(awardItem)
        if Config.OldESX then
            local limitItem = xPlayer.getInventoryItem(awardItem)
            if limitItem.limit == -1 or (limitItem.count + 1) <= limitItem.limit then
                xPlayer.addInventoryItem(awardItem, 1)
                TriggerClientEvent('wasabi_fishing:notify', source, Strings.fish_success, string.format(Strings.fish_success_desc, awardLabel), 'success')
            else
                TriggerClientEvent('wasabi_fishing:notify', source, Strings.cannot_carry, Strings.cannot_carry_desc, 'error')
            end
        else
            if xPlayer.canCarryItem(awardItem, 1) then
                xPlayer.addInventoryItem(awardItem, 1)
                TriggerClientEvent('wasabi_fishing:notify', source, Strings.fish_success, string.format(Strings.fish_success_desc, awardLabel), 'success')
            else
                TriggerClientEvent('wasabi_fishing:notify', source, Strings.cannot_carry, Strings.cannot_carry_desc, 'error')
            end
        end
    elseif xPole > 0 and xBait < 1 then
        TriggerClientEvent('wasabi_fishing:interupt', source)
        TriggerClientEvent('wasabi_fishing:notify', source, Strings.no_bait, Strings.no_bait_desc, 'error')
    elseif xPole < 1 then
        xPlayer.kick(Strings.kicked)
    end
end)

RegisterServerEvent('wasabi_fishing:sellFish')
AddEventHandler('wasabi_fishing:sellFish', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetEntityCoords(playerPed)
    local distance = #(playerCoord - Config.sellShop.coords)
    if distance == nil then
        xPlayer.kick(Strings.kicked)
        return
    end
    if distance > 3 then
        xPlayer.kick(Strings.kicked)
        return
    end
    for i=1, #Config.fish do
        if xPlayer.getInventoryItem(Config.fish[i].item).count > 0 then
            local rewardAmount = 0
            for j=1, xPlayer.getInventoryItem(Config.fish[i].item).count do
                rewardAmount = rewardAmount + math.random(Config.fish[i].price[1], Config.fish[i].price[2])
            end
            if rewardAmount > 0 then
                xPlayer.addMoney(rewardAmount)
                TriggerClientEvent('wasabi_fishing:notify', source, Strings.sold_for, (Strings.sold_for_desc):format(xPlayer.getInventoryItem(Config.fish[i].item).count, xPlayer.getInventoryItem(Config.fish[i].item).label, addCommas(rewardAmount)), 'success')
                xPlayer.removeInventoryItem(Config.fish[i].item, xPlayer.getInventoryItem(Config.fish[i].item).count)
            end
        end
    end
end)

ESX.RegisterUsableItem(Config.fishingRod.itemName, function(source)
    TriggerClientEvent('wasabi_fishing:startFishing', source)
end)

addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end
