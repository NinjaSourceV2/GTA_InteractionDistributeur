RegisterServerEvent("GTA:PayerDistributeurBoisson")
AddEventHandler("GTA:PayerDistributeurBoisson", function()
local source = source
local license = GetPlayerIdentifiers(source)[1]
prix = 25

TriggerEvent('GTA:GetInfoJoueurs', source, function(data)
        local argentPropre = data.argent_propre
        if (tonumber(argentPropre) >= prix) then
			TriggerEvent('GTA:RetirerArgentPropre', source, tonumber(prix))
			TriggerClientEvent('GTA:OnDistributeur', source)
        else
            TriggerClientEvent('nMenuNotif:showNotification', source, "~r~Tu n'as pas suffisamment d'argent !")
        end
    end)
end)