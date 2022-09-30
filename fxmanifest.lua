-----------------For support, scripts, and more----------------
-----------------https://discord.gg/XJFNyMy3Bv-----------------
---------------------------------------------------------------
fx_version 'cerulean'

game 'gta5'

description "ESX Skill Based Fishing"

author 'wasabirobby#5110'

version '1.1.3'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/main.js'
}

client_scripts {
	'client/**.lua'
}

server_scripts {
	'server/**.lua'
}

shared_script 'config.lua'
