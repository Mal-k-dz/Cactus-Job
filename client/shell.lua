local showPro                 = false       -- don't touch
local spawnedcactusfish = 0
local Minecactus = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.cactusField.coords, true) < 50 then
			Spawncactus()
			Citizen.Wait(0)
		else
			Citizen.Wait(0)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #Minecactus, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(Minecactus[i]), false) < 1 then
				nearbyObject, nearbyID = Minecactus[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				ESX.ShowHelpNotification(_U('cactus_pickupprompt'))
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				isPickingUp = true

				ESX.TriggerServerCallback('Mal-k-Cactus:canPickUp', function(canPickUp)

					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_GARDENER_PLANT', 0, false)
	
						procent(50)
					--	Citizen.Wait(2000)
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(Minecactus, nearbyID)
						spawnedcactusfish = spawnedcactusfish - 1
		

						TriggerServerEvent('Mal-k-Cactus:pickedUpcactus')
					else
						ESX.ShowNotification(_U('cactus_inventoryfull'))
					end

					isPickingUp = false

				end, 'echinopsis')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(6)
    if showPro == true then
      local playerPed = PlayerPedId()
		  local coords = GetEntityCoords(playerPed)
      DrawText3D(coords.x, coords.y, coords.z, TimeLeft .. '~g~%', 0.4)
    end
	end
end)
function DrawText3D(x, y, z, text, scale)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

  SetTextScale(scale, scale)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextColour(255, 255, 255, 255)
  SetTextOutline()

  AddTextComponentString(text)
  DrawText(_x, _y)

  local factor = (string.len(text)) / 270
  DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

function procent(time)
  showPro = true
  TimeLeft = 0
  repeat
  TimeLeft = TimeLeft + 1        -- thank you (github.com/Loffes)
  Citizen.Wait(time)
  until(TimeLeft == 100)
  showPro = false
end



itemFound = false
itemFoundSell = false

RegisterNetEvent('Mal-k-Cactus:CheackingOK')
AddEventHandler('Mal-k-Cactus:CheackingOK', function()
	itemFound = true
end)


RegisterNetEvent('Mal-k-Cactus:CheackingSellOK')
AddEventHandler('Mal-k-Cactus:CheackingSellOK', function(itemValue)
	itemFoundSell = true
	itemValue = 1
end)

RegisterNetEvent('Mal-k-Cactus:CheackingNO')
AddEventHandler('Mal-k-Cactus:CheackingNo', function()
	itemFound = false
end)




Citizen.CreateThread(function()
  while true do
  Citizen.Wait(0)



  local coords = GetEntityCoords(PlayerPedId())
  local distance = Vdist(coords.x, coords.y, coords.z, Config.CircleZones.cactusCut.coords.x, Config.CircleZones.cactusCut.coords.y, Config.CircleZones.cactusCut.coords.z)

  if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, Config.CircleZones.cactusCut.coords.x, Config.CircleZones.cactusCut.coords.y, Config.CircleZones.cactusCut.coords.z, true) < 4) then



		local playerPed = PlayerPedId()
          DrawMarker(3, Config.CircleZones.cactusCut.coords.x, Config.CircleZones.cactusCut.coords.y, Config.CircleZones.cactusCut.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 15, 15, 15, 255, 255, 255, 100, false, true, 2, false, false, false, false)


          if distance < 2 then
          	StatusReady = true

          	if StatusReady == true  then
            ESX.ShowHelpNotification(_U('Enter'))
            TriggerServerEvent('Mal-k-Cactus:CheackingPack')

            end
            

            if IsControlJustReleased(1,  38) and StatusReady == true  then
            itemFound = false
            TriggerServerEvent('Mal-k-Cactus:CheackingPack')
             FreezeEntityPosition(playerPed, true)
            Citizen.Wait(500)
             FreezeEntityPosition(playerPed, false)
            if itemFound == true  then
            	itemFound = false 
            	StatusReady = false
            	
            	procent(50)
             	TriggerServerEvent('Mal-k-Cactus:pack')
            	ClearPedTasks(playerPed)
            	
            	Citizen.Wait(1000)

            	StatusReady = true
            else
            		ESX.ShowNotification(_U('NoItem'))

            end

            	


              
    
            end

            
          end


  end
  end
end)

Citizen.CreateThread(function()
  while true do
  Citizen.Wait(0)



  local coords = GetEntityCoords(PlayerPedId())
  local distance = Vdist(coords.x, coords.y, coords.z, Config.CircleZones.cactusSell.coords.x, Config.CircleZones.cactusSell.coords.y, Config.CircleZones.cactusSell.coords.z)

  if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, Config.CircleZones.cactusSell.coords.x, Config.CircleZones.cactusSell.coords.y, Config.CircleZones.cactusSell.coords.z, true) < 4) then



		local playerPed = PlayerPedId()
          DrawMarker(3, Config.CircleZones.cactusSell.coords.x, Config.CircleZones.cactusSell.coords.y, Config.CircleZones.cactusSell.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 15, 15, 15, 255, 255, 255, 100, false, true, 2, false, false, false, false)


          if distance < 2 then
          	StatusReady = true

          	if StatusReady == true then
            ESX.ShowHelpNotification(_U('EnterSell'))
            TriggerServerEvent('Mal-k-Cactus:CheackingPack')

            end
            

            if IsControlJustReleased(1,  38) and StatusReady == true  then
            itemFoundSell = false
            TriggerServerEvent('Mal-k-Cactus:SellCheak')
             FreezeEntityPosition(playerPed, true)
            Citizen.Wait(500)
             FreezeEntityPosition(playerPed, false)
            if itemFoundSell == true  then
            	itemFoundSell = false 
            	StatusReady = false
            	TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, false)
            	procent(150)
             	TriggerServerEvent('Mal-k-Cactus:Sellpack')
            	ClearPedTasks(playerPed)
            	
            	Citizen.Wait(300)

            	StatusReady = true
            else
            		ESX.ShowNotification(_U('NoItem'))

            end

            	


              
    
            end

            
          end


  end
  end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(Minecactus) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function Spawncactus()
	while spawnedcactusfish < 70 do
		Citizen.Wait(0)
		local cactusCoords = GeneratecactusCoords()

		ESX.Game.SpawnLocalObject('prop_cactus_02', cactusCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(Minecactus, obj)
			spawnedcactusfish = spawnedcactusfish + 1
		end)
	end
end

function ValidatecactusCoord(plantCoord)
	if spawnedcactusfish > 0 then
		local validate = true

		for k, v in pairs(Minecactus) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.cactusField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GeneratecactusCoords()
	while true do
		Citizen.Wait(1)

		local cactusCoordX, cactusCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-30, 30)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-60, 60)

		cactusCoordX = Config.CircleZones.cactusField.coords.x + modX
		cactusCoordY= Config.CircleZones.cactusField.coords.y + modY

		local coordZ = GetCoordZ(cactusCoordX, cactusCoordY)
		local coord = vector3(cactusCoordX, cactusCoordY, coordZ)

		if ValidatecactusCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end




