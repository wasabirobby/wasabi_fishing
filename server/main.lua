-----------------For support, scripts, and more----------------
-----------------https://discord.gg/XJFNyMy3Bv-----------------
---------------------------------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('wasabi_fishing:checkItem', function(source, cb, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname).count
    if item >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('wasabi_fishing:rodBroke')
AddEventHandler('wasabi_fishing:rodBroke', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(Config.FishingRod.itemName, 1)
    TriggerClientEvent('wasabi_fishing:interupt', source)
end)

RegisterServerEvent('wasabi_fishing:tryFish')
AddEventHandler('wasabi_fishing:tryFish', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPole = xPlayer.getInventoryItem(Config.FishingRod.itemName).count
    local xBait = xPlayer.getInventoryItem(Config.Bait.itemName).count
    if xPole > 0 and xBait > 0 then
        local chance = math.random(1,100)
        if chance <= Config.Bait.loseChance then
            xPlayer.removeInventoryItem(Config.Bait.itemName, 1)
            TriggerClientEvent('wasabi_fishing:notify', source, Language['bait_lost'])
        end
        local awardItem = Config.Fish[math.random(#Config.Fish)]
        local awardLabel = ESX.GetItemLabel(awardItem)
        if Config.OldESX then
            local limitItem = xPlayer.getInventoryItem(awardItem)
            if limitItem.limit == -1 or (limitItem.count + 1) <= limitItem.limit then
                xPlayer.addInventoryItem(awardItem, 1)
                TriggerClientEvent('wasabi_fishing:notify', source, string.format(Language['fish_success'], awardLabel))
            else
                TriggerClientEvent('wasabi_fishing:notify', source, Language['cannot_carry'])
            end
        else
            if xPlayer.canCarryItem(awardItem, 1) then
                xPlayer.addInventoryItem(awardItem, 1)
                TriggerClientEvent('wasabi_fishing:notify', source, string.format(Language['fish_success'], awardLabel))
            else
                TriggerClientEvent('wasabi_fishing:notify', source, Language['cannot_carry'])
            end
        end
    elseif xPole > 0 and xBait < 1 then
        TriggerClientEvent('wasabi_fishing:interupt', source)
        TriggerClientEvent('wasabi_fishing:notify', source, Language['no_bait'])
    elseif xPole < 1 then
        xPlayer.kick(Language['kicked'])
    end
end)

RegisterServerEvent('wasabi_fishing:sellFish')
AddEventHandler('wasabi_fishing:sellFish', function(distance)
    if distance ~= nil then
        if distance <= 3 then
            for k, v in pairs(Config.FishPrices) do
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer.getInventoryItem(k).count > 0 then
                    local rewardAmount = 0
                    for i = 1, xPlayer.getInventoryItem(k).count do
                        rewardAmount = rewardAmount + math.random(v[1], v[2])
                    end
                    xPlayer.addMoney(rewardAmount)
                    TriggerClientEvent('wasabi_fishing:notify', source, (Language['sold_for']):format(xPlayer.getInventoryItem(k).count, xPlayer.getInventoryItem(k).label, addCommas(rewardAmount)))
                    xPlayer.removeInventoryItem(k, xPlayer.getInventoryItem(k).count)
                end
            end
        else
            xPlayer.kick(Language['kicked'])
        end
    else
        xPlayer.kick(Language['kicked'])
    end
end)

ESX.RegisterUsableItem(Config.FishingRod.itemName, function(source)
    TriggerClientEvent('wasabi_fishing:startFishing', source)
end)

addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end