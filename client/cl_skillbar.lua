local levels = {
    ["easy"] = {
        duration = 3000,
        width = 30
    },
    ["normal"] = {
        duration = 1500 ,
        width = 20,
    },
    ["medium"] = {
        duration = 2000,
        width = 1
    },
    ["hard"] = {
        duration = 650 ,
        width = 10,
    }
}

local activePromise = nil
local inProgress = false

function CreateSkillbar(amount,level)
    if not inProgress then
        if type(level) == "string" then
            if not levels[level] then
                return false
            end
            level = levels[level]
        elseif type(level) == "table" then
            if not level.duration or not level.width then
                return false
            end
        end
        activePromise = promise:new()
        inProgress = true
        SendNUIMessage({
            action = "open",
            diff = level,
            amount=amount
        })
        CreateThread(listenToKeyCheck)
        return Citizen.Await(activePromise)
    else return false
    end
end

function listenToKeyCheck()
    while inProgress do
        Wait(0)
        if IsControlJustPressed(1,38) then
            SendNUIMessage({
                action = "check"
            })
        end
    end
end

RegisterNUICallback("finish",function(data,cb)
    local success = data.success
    inProgress = false
    if activePromise ~= nil then
        activePromise:resolve(success)
        activePromise = nil
    end
end)

AddEventHandler('esx:onPlayerDeath', function()
    if activePromise and inProgress then
        activePromise:resolve(false)
        activePromise = nil
        inProgress = false
        SendNUIMessage({
            action = "hide"
        })
    end
end)

AddEventHandler('skilbar:stop',function()
    inProgress = false
    SendNUIMessage({
        action = "hide"
    })
end)

exports("CreateSkillbar",CreateSkillbar)
