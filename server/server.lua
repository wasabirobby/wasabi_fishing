-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end

lib.callback.register('wasabi_fishing:checkItem', function(source, itemname)
    local item = HasItem(source, itemname)
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

RegisterNetEvent('wasabi_fishing:rodBroke', function()
    RemoveItem(source, Config.fishingRod.itemName, 1)
    TriggerClientEvent('wasabi_fishing:interupt', source)
end)

RegisterNetEvent('wasabi_fishing:tryFish', function(data)
    local xPole = HasItem(source, Config.fishingRod.itemName)
    local xBait = HasItem(source, Config.bait.itemName)
    if xPole > 0 and xBait > 0 then
        local chance = math.random(1,100)
        if chance <= Config.bait.loseChance then
            RemoveItem(source, Config.bait.itemName, 1)
            TriggerClientEvent('wasabi_fishing:notify', source, Strings.bait_lost, Strings.bait_lost_desc, 'error')
        end
	if Framework == 'esx' and not Config.oldESX then
	    local player = GetPlayer(source)
	    if player.canCarryItem(data.item, 1) then
	        AddItem(source, data.item, 1)
		TriggerClientEvent('wasabi_fishing:notify', source, Strings.fish_success, string.format(Strings.fish_success_desc, data.label), 'success')
	    else
                TriggerClientEvent('wasabi_fishing:notify', source, Strings.cannot_carry, Strings.cannot_carry_desc, 'error')
	    end
	else
            AddItem(source, data.item, 1)
            TriggerClientEvent('wasabi_fishing:notify', source, Strings.fish_success, string.format(Strings.fish_success_desc, data.label), 'success')
        end
    elseif xPole > 0 and xBait < 1 then
        TriggerClientEvent('wasabi_fishing:interupt', source)
        TriggerClientEvent('wasabi_fishing:notify', source, Strings.no_bait, Strings.no_bait_desc, 'error')
    elseif xPole < 1 then
        KickPlayer(source, Strings.kicked)
    end
end)

RegisterNetEvent('wasabi_fishing:sellFish', function()
    local playerPed = GetPlayerPed(source)
    local playerCoord = GetEntityCoords(playerPed)
    local distance = #(playerCoord - Config.sellShop.coords)
    if distance == nil then
        KickPlayer(source, Strings.kicked)
        return
    end
    if distance > 3 then
        KickPlayer(source, Strings.kicked)
        return
    end
    for i=1, #Config.fish do
        if HasItem(source, Config.fish[i].item) > 0 then
            local rewardAmount = 0
            for j=1, HasItem(source, Config.fish[i].item) do
                rewardAmount = rewardAmount + math.random(Config.fish[i].price[1], Config.fish[i].price[2])
            end
            if rewardAmount > 0 then
                AddMoney(source, 'money', rewardAmount)
                TriggerClientEvent('wasabi_fishing:notify', source, Strings.sold_for, (Strings.sold_for_desc):format(HasItem(source, Config.fish[i].item), Config.fish[i].label, addCommas(rewardAmount)), 'success')
                RemoveItem(source, Config.fish[i].item, HasItem(source, Config.fish[i].item))
            end
        end
    end
end)

RegisterUsableItem(Config.fishingRod.itemName, function(source)
    TriggerClientEvent('wasabi_fishing:startFishing', source)
end)
