AddEventHandler('onPlayerVote', function(playername, date)
  -- Exemple ESX :
  -- local xPlayer = ESX.GetPlayerFromName(playername)
  -- if xPlayer then
  --   xPlayer.addMoney(1000)
  -- end

  -- Exemple QB-Core :
  -- local Player = QBCore.Functions.GetPlayerByCitizenId(playername)
  -- if Player then
  --   Player.Functions.AddMoney('cash', 1000)
  -- end

  print(('[UpServeurVote] %s a vote le %s'):format(playername, date))
end)
