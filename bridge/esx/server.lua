if GetResourceState('es_extended') ~= 'started' then return end
ESX = exports['es_extended']:getSharedObject()
Framework = 'esx'

function GetPlayer(source)
    return ESX.GetPlayerFromId(source)
end

function KickPlayer(source, reason)
    local player = GetPlayer(source)
    return player.kick(reason)
end

function HasGroup(source, filter)
    local player = GetPlayer(source)
    local type = type(filter)

    if type == 'string' then
        if player.job.name == filter then
            return player.job.name, player.job.grade
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            local grade = filter[player.job.name]

            if grade and grade <= player.job.grade then
                return player.job.name, player.job.grade
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                if player.job.name == filter[i] then
                    return player.job.name, player.job.grade
                end
            end
        end
    end
end

function GetIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.identifier
end

function GetName(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.getName()
end

function RegisterUsableItem(item, cb)
    ESX.RegisterUsableItem(item, cb)
end

function HasItem(source, item)
    local player = GetPlayer(source)
    local item = player.getInventoryItem(item)
    if item ~= nil then
        return item.count
    else
        return 0
    end
end

function AddItem(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    return player.addInventoryItem(item, count, metadata, slot)
end

function RemoveItem(source, item, count, slot, metadata)
    local player = GetPlayer(source)
    player.removeInventoryItem(item, count, metadata, slot)
end

function AddMoney(source, type, amount)
    if type == 'cash' then type = 'money' end
    local player = GetPlayer(source)
    player.addAccountMoney(type, amount)
end

function RemoveMoney(source, type, amount)
    if type == 'cash' then type = 'money' end
    local player = GetPlayer(source)
    player.removeAccountMoney(type, amount)
end
