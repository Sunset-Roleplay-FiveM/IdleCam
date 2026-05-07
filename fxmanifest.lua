fx_version 'cerulean'
game 'gta5'

author 'HydraCode © 2026'
description ''
version '1.0.0'
repository ''

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    'server/main.lua',
    'server/update.lua
}

client_script 'client/main.lua'

dependency 'ox_lib'
