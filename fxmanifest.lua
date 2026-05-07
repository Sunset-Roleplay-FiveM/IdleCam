fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'

name 'sunset_idlecam'
author 'Sunset Roleplay'
description 'Deactivate the idle camera and persist each player status'
version '1.0.0'
repository 'https://github.com/Sunset-Roleplay-FiveM/IdleCam'

files {
    'locales/*.json'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv-main.lua'
}

client_script 'client/cl-main.lua'

dependencies {
    'ox_lib',
    'oxmysql'
}

ox_libs {
    'locale'
}
