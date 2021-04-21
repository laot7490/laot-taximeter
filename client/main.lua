--[[

	██╗░░░░░░█████╗░░█████╗░████████╗░░░██╗░██╗░██████╗░███████╗░█████╗░░█████╗░
	██║░░░░░██╔══██╗██╔══██╗╚══██╔══╝██████████╗╚════██╗██╔════╝██╔══██╗██╔══██╗
	██║░░░░░███████║██║░░██║░░░██║░░░╚═██╔═██╔═╝░░███╔═╝██████╗░╚██████║╚██████║
	██║░░░░░██╔══██║██║░░██║░░░██║░░░██████████╗██╔══╝░░╚════██╗░╚═══██║░╚═══██║
	███████╗██║░░██║╚█████╔╝░░░██║░░░╚██╔═██╔══╝███████╗██████╔╝░█████╔╝░█████╔╝
	╚══════╝╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░░╚═╝░╚═╝░░░╚══════╝╚═════╝░░╚════╝░░╚════╝░
	
]]

local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
PlayerData = {}

LAOT = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while LAOT == nil do
		TriggerEvent('LAOTCore:GetObject', function(obj) LAOT = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent("laot-taximeter:client:ShowCost")
AddEventHandler("laot-taximeter:client:ShowCost", function(km, cost)
	if km and cost then
		LAOT.Functions.Notify("inform", "Taksici sizi " .. km .. " KM mesafe götürdü. Ödemeniz gereken $".. cost)
	end
end)

local KM = 0
local Cost = 0
local Help = true
local Open = false
local Zone = "Belli değil."

Citizen.CreateThread(
	function()

		while LAOT == nil do
			Citizen.Wait(10)
		end

		while true do
			local sleep = 1000

			local ped = PlayerPedId()
			local veh = GetVehiclePedIsIn(ped, false)
			if IsTaxi(veh) and GetPedInVehicleSeat(veh, -1) == ped then
				SetTaxiMeterUI(true)
				if Open == true then
					KM = KM + round(GetEntitySpeed(veh) * 0.00721371, 5)
					Cost = C.KMPrice * KM
				end

				local coords = GetEntityCoords(ped)
				local zonelol = GetNameOfZone(coords.x, coords.y, coords.z)
				Zone = GetLabelText(zonelol)

				if Help == true then
					Help = false
					KM = 0
					Cost = 0
					Open = false
					LAOT.Functions.Notify("inform", "<b>[U]</b> Fiyatlandırmayı başlat-durdur | <b>[K]</b> KM-Ücret sıfırla | <b>[H]</b> Ücreti en yakın kişiye göster")
				end
			else 
				SetTaxiMeterUI(false) 
				sleep = 1500 

				Help = true 
				KM = 0
				Cost = 0
				Open = false
			end

			Citizen.Wait(sleep)
		end

end)

function round(num, numDecimalPlaces)
	local mult = 5^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

Citizen.CreateThread(function()
	while true do
		local sleep = 500

		local ped = PlayerPedId()
		local veh = GetVehiclePedIsIn(ped, false)
		if IsTaxi(veh) and GetPedInVehicleSeat(veh, -1) == ped then
			sleep = 4
			if IsControlJustPressed(0, Keys["U"]) then -- Fiyatlandırma başlat veya durdur
				Open = not Open
			end
			if IsControlJustPressed(0, Keys["K"]) then
				KM = 0
				Cost = 0
			end
			if IsControlJustPressed(0, Keys["H"]) then
				print("laot#2599")
				local closestplayer, distance = ESX.Game.GetClosestPlayer()

				if closestplayer ~= -1 and distance < 3.0 then
					TriggerServerEvent("laot-taximeter:server:ShowCost", GetPlayerServerId(closestplayer), KM, Cost)
				else
					LAOT.Functions.Notify("error", "Yakında kimse yok.")
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

SetTaxiMeterUI = function(var)
	local Color = "red"
	if Open then
		Color = "green"
	end
	SendNUIMessage({
		type = "gui",
		data = var,
		zone = Zone,
		km = string.format("%.2f", KM),
		cost = string.format("%.2f", Cost),
		color = Color
    })
end

IsTaxi = function(veh)
	local modelvehhash = GetEntityModel(veh)
	for modelid, model in pairs(C.TaxiVehicles) do
		if modelvehhash == GetHashKey(model) then
			return true
		end
	end

	return false
end