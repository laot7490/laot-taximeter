ESX = nil
LAOT = nil

TriggerEvent('LAOTCore:GetObject', function(obj) LAOT = obj end)
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("laot-taximeter:server:ShowCost")
AddEventHandler("laot-taximeter:server:ShowCost", function(id, km, cost)
    if id and km and cost then
        if id ~= -1 then
            TriggerClientEvent("laot-taximeter:client:ShowCost", id, string.format("%.2f", km), string.format("%.2f", cost))
        end
    end
end)
