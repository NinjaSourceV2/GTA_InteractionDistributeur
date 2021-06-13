local modeltypes = {"prop_vend_soda_01", "prop_vend_soda_02"}
local animDict = "mini@sprunk"

local IsNearDistributeur = false
local isMessageHelpReady = false
local antiSpam = false

local playerPed = nil
local coord = nil
local Boisson = nil

local square = math.sqrt
function getDistance(a, b) 
    local x, y, z = a.x-b.x, a.y-b.y, a.z-b.z
    return square(x*x+y*y+z*z)
end

Citizen.CreateThread(function()
	while true do
		Wait(5)
		playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed, true)
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(500)
		for _,v in pairs(modeltypes) do
			distributeur = GetClosestObjectOfType(coords, 1.75, GetHashKey(v), false)
			if DoesEntityExist(distributeur) then
				currentVending = distributeur
				VendingX, VendingY, VendingZ = table.unpack(GetOffsetFromEntityInWorldCoords(currentVending, 0.0, -0.97, 0.0))

				vendingAnim = RequestAnimDict(animDict)
				while not HasAnimDictLoaded(animDict) do
					Wait(0)
				end
				
				if GetEntityModel(distributeur) == GetHashKey("prop_vend_soda_01") then
					CanModel = GetHashKey("prop_ecola_can")
				elseif GetEntityModel(currentVending) == GetHashKey("prop_vend_soda_02") then
					CanModel = GetHashKey("prop_ld_can_01b") 
				end

				RequestModel(CanModel)
				while not HasModelLoaded(CanModel) do
					Wait(0)
				end

				IsNearDistributeur = true
			end
		end

		if DoesEntityExist(currentVending) then
		    if getDistance(coords, GetEntityCoords(currentVending, true), true) > 1.5 then
		        isMessageHelpReady = false
		        IsNearDistributeur = false
		    end
		end
	end
end)

RegisterNetEvent("GTA:OnDistributeur")
AddEventHandler("GTA:OnDistributeur", function()
	boneIndex = GetPedBoneIndex(playerPed, 28422)
	
	TaskLookAtEntity(playerPed, currentVending, 2000, 2048, 2)
	TaskGoStraightToCoord(playerPed, VendingX, VendingY, VendingZ, 1.0, 4000, GetEntityHeading(currentVending), 0.5)
	Wait(1000)
		
	Boisson = CreateObject(CanModel, GetEntityCoords(currentVending, true), false, false, false)
	TaskPlayAnim(playerPed, animDict, "plyr_buy_drink_pt1", 2.0, -4.0, 4200, 1048576, 0, 0, 0, 0)
	Wait(500)
	AttachEntityToEntity(Boisson, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
	Wait(3000)
	DeleteEntity(Boisson)


	TriggerEvent("GTA_Inventaire:AjouterItem", "soda", 1)
	TriggerEvent("NUI-Notification", {"~b~+1 ~g~soda"})
	antiSpam = false
end)

Citizen.CreateThread(function()
	while true do
		Wait(15)
		if IsNearDistributeur then
			isMessageHelpReady = true
			if GetLastInputMethod(0) then
                TriggerEvent("GTA-Notification:InfoInteraction", "~INPUT_PICKUP~ pour ~b~intéragir")
			else
                TriggerEvent("GTA-Notification:InfoInteraction", "~INPUT_CELLPHONE_RIGHT~ pour ~b~intéragir")
			end
			
			if antiSpam == false then
				if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) then
					antiSpam = true
					TriggerServerEvent('GTA:PayerDistributeurBoisson')
				end
			end
		end
	end
end)