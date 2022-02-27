-----------------For support, scripts, and more----------------
-----------------https://discord.gg/XJFNyMy3Bv-----------------
---------------------------------------------------------------
Config = {}

Config.OldESX = false -- Using ESX 1.1 or older put true

Config.SellShop = vector3(-1612.06, -989.13, 13.02) -- X, Y, Z Coords of where 

Config.Bait = {
    itemName = 'fishbait', -- Item name of bait
    loseChance = 90 -- Chance of loosing bait(Setting to 100 will use bait every cast)
}

Config.FishingRod = {
    itemName = 'fishingrod', -- Item name of fishing rod
    breakChance = 50 --Chance of breaking pole when failing skillbar (Setting to 0 means never break)
}

Config.Fish = { -- Name of obtainable fish (Must be in item database/table)
    'tuna',
    'salmon',
    'trout',
    'anchovy'
}

Config.FishPrices = { -- Price ranges for the items to sell (Must have the same as above)
    ['tuna'] = {100, 150},
    ['salmon'] = {60, 95},
    ['trout'] = {45, 55},
    ['anchovy'] = {20, 44}
}




RegisterNetEvent('wasabi_fishing:notify')
AddEventHandler('wasabi_fishing:notify', function(message)

-- Place notification system info here, ex: exports['mythic_notify']:SendAlert('inform', message)
ESX.ShowNotification(message)


end)

Language = {
    --Help Text
    ['intro_instruction'] = 'Press ~INPUT_ATTACK~ to cast line, ~INPUT_FRONTEND_RRIGHT~ to cancel.',
    ['rod_broke'] = 'You pulled to hard and your fishing rod snapped!',
    ['cannot_perform'] = 'You cannot do this right now.',
    ['failed_fish'] = 'You failed to catch fish!',
    ['no_water'] = 'You are not facing any water.',
    ['no_bait'] = 'You don\'t have fishing bait.',
    ['bait_lost'] = 'Fishing bait was lost.',
    ['fish_success'] = 'You caught ~r~1x %s~w~!',
    ['sell_shop_blip'] = 'Fish Market',
    ['sell_fish'] = 'Press [~g~E~w~] To Sell Fish',
    ['kicked'] = 'Nice try, please do not attempt to exploit!',
    ['sold_for'] = 'You sold %sx %s for $%s',
    ['cannot_carry'] = 'You cannot carry reward!'
    
}