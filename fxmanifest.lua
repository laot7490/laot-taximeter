fx_version "bodacious"

game "gta5"
author "laot"

ui_page "nui/index.html"
files {
    "nui/index.html",
    "nui/scripts.js",
    "nui/style.css",
}

client_scripts {
    "@laot-core/locale.lua",
    "locales/tr.lua",
    "config.lua",
    "client/main.lua"
}

server_scripts {
    "@laot-core/locale.lua",
    "locales/tr.lua",
    "config.lua",
    "server/main.lua"
}

dependency "laot-core"