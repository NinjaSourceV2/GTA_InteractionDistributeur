--> Version de la Resource : 
local LatestVersion = ''; CurrentVersion = '1.3'
PerformHttpRequest('https://raw.githubusercontent.com/NinjaSourceV2/GTA_InteractionDistributeur/master/GTA_InteractionDistributeur/VERSION', function(Error, NewestVersion, Header)
    LatestVersion = NewestVersion
    if CurrentVersion ~= NewestVersion then
        print("\n\r ^2[GTA_InteractionDistributeur]^1 La version que vous utilisé n'est plus a jours, veuillez télécharger la dernière version. ^3\n\r")
    end
end)

RegisterServerEvent("GTA:PayerDistributeurBoisson")
AddEventHandler("GTA:PayerDistributeurBoisson", function()
local source = source
local license = GetPlayerIdentifiers(source)[1]
local prix = 25

TriggerEvent('GTA_Inventaire:GetItemQty', source, "cash", function(qtyItem, itemid)
        local argentPropre = qtyItem
        if (tonumber(argentPropre) >= prix) then
            TriggerClientEvent('GTA_Inventaire:RetirerItem', source, "cash", tonumber(prix))
			TriggerClientEvent('GTA:OnDistributeur', source)
        else
            TriggerClientEvent('nMenuNotif:showNotification', source, "~r~Tu n'as pas suffisamment d'argent !")
        end
    end)
end)