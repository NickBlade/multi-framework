@echo off
set /p scriptname="Script name: "
set /p scriptdescription="Script description: "
set /p githubrepo="Github repository (example: NickBlade/test): "
mkdir %scriptname%
echo fx_version 'adamant' > %scriptname%/fxmanifest.lua
echo game 'gta5' >> %scriptname%/fxmanifest.lua
echo description '%scriptdescription%' >> %scriptname%/fxmanifest.lua
echo version '1.0.0' >> %scriptname%/fxmanifest.lua
echo author 'NickBlade#5623' >> %scriptname%/fxmanifest.lua
echo shared_scripts { >> %scriptname%/fxmanifest.lua
echo    './shared/config.lua' >> %scriptname%/fxmanifest.lua
echo } >> %scriptname%/fxmanifest.lua
echo server_scripts { >> %scriptname%/fxmanifest.lua
echo 	'./server/main.lua' >> %scriptname%/fxmanifest.lua
echo } >> %scriptname%/fxmanifest.lua
echo client_scripts { >> %scriptname%/fxmanifest.lua
echo 	'./client/main.lua', >> %scriptname%/fxmanifest.lua
echo 	'./client/modules/framework.lua' >> %scriptname%/fxmanifest.lua
echo } >> %scriptname%/fxmanifest.lua

cd %scriptname%
mkdir client
mkdir server
mkdir shared

cd client
copy NUL client.lua
mkdir modules
echo ESX = ESX > modules/framework.lua
echo QBCore = QBCore >> modules/framework.lua
echo if Config.Framework == "esx" then >> modules/framework.lua
echo    CreateThread(function() >> modules/framework.lua
echo        while ESX == nil do >> modules/framework.lua
echo        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) >> modules/framework.lua
echo        Wait(0) >> modules/framework.lua
echo    end >> modules/framework.lua
echo end) >> modules/framework.lua
echo elseif Config.Framework == "qbcore" then >> modules/framework.lua
echo    exports['qb-core']:GetCoreObject() >> modules/framework.lua
echo else >> modules/framework.lua
echo    print("Framework not set in Config.lua") >> modules/framework.lua
echo end >> modules/framework.lua

cd ..
echo ESX = ESX > server/server.lua
echo QBCore = QBCore >> server/server.lua
echo if Config.Framework == "esx" then >> server/server.lua
echo        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) >> server/server.lua
echo else >> server/server.lua
echo        exports['qb-core']:GetCoreObject() >> server/server.lua
echo end >> server/server.lua

echo Config = {} or Config > shared/config.lua
echo Config.Framework = "esx" -- or "qbcore" >> shared/config.lua

git init
git add *
git commit -m "Upload (multi-framework script)"
git branch -M main
git remote add origin git@github.com:%githubrepo%.git
git remote set-url origin https://github.com/%githubrepo%.git
git push -u origin main

