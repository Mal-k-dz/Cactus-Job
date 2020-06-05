
ESX = nil
local playersProcessingStones = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Mal-k-Cactus:pickedUpcactus')
AddEventHandler('Mal-k-Cactus:pickedUpcactus', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('echinopsis')
	math.randomseed(GetGameTimer())

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('stone_inventoryfull'))
	else

		xPlayer.addInventoryItem(xItem.name, 3)
	end
end)


RegisterServerEvent('Mal-k-Cactus:pack')
AddEventHandler('Mal-k-Cactus:pack', function()
	local xPlayer = ESX.GetPlayerFromId(source)


	xPlayer.removeInventoryItem('echinopsis', 3)
	xPlayer.addInventoryItem('cactus', 3)

end)

RegisterServerEvent('Mal-k-Cactus:Sellpack')

AddEventHandler('Mal-k-Cactus:Sellpack', function()
	--[[local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('fresh_cactusfish', 1)
	xPlayer.addMoney(Config.Price)--]]

	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('cactus')

	xPlayer.removeInventoryItem('cactus', xItem.count)
	xPlayer.addMoney(Config.Price * xItem.count)

end)

RegisterServerEvent('Mal-k-Cactus:CheackingPack')
AddEventHandler('Mal-k-Cactus:CheackingPack', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('echinopsis')

	if xItem.count > 1 then
	TriggerClientEvent('Mal-k-Cactus:CheackingOK', source)

	end




end)


RegisterServerEvent('Mal-k-Cactus:CheackingPack')
AddEventHandler('Mal-k-Cactus:CheackingPack', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('echinopsis')

	if xItem.count > 1 then



	TriggerClientEvent('Mal-k-Cactus:CheackingOK', source)

	end




end)

RegisterServerEvent('Mal-k-Cactus:SellCheak')
AddEventHandler('Mal-k-Cactus:SellCheak', function()

	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('cactus')

	if xItem.count > 0 then
	TriggerClientEvent('Mal-k-Cactus:CheackingSellOK', source)

	end


end)

ESX.RegisterServerCallback('Mal-k-Cactus:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)

	if xItem.limit ~= -1 and xItem.count >= xItem.limit then
		cb(false)
	else
		cb(true)
	end
end)



function CancelProcessing(playerID)
	if playersProcessingStones[playerID] then
		ESX.ClearTimeout(playersProcessingStones[playerID])
		playersProcessingStones[playerID] = nil
	end
end

RegisterServerEvent('Mal-k-Cactus:cancelProcessing')
AddEventHandler('Mal-k-Cactus:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)

