local voteCache = {}

local function log(message)
  if TopServeurVote.Debug then
    print(('[TopServeurVote] %s'):format(message))
  end
end

local function urlEncode(value)
  if value == nil then
    return ''
  end

  value = tostring(value)
  value = value:gsub('\n', '\r\n')
  value = value:gsub('([^%w%-_%.~])', function(character)
    return string.format('%%%02X', string.byte(character))
  end)

  return value
end

local function getSteamIdentifier(source)
  for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
    if identifier:sub(1, 6) == 'steam:' then
      return identifier:gsub('steam:', '')
    end
  end

  return nil
end

local function claimVote(source)
  if TopServeurVote.Token == nil or TopServeurVote.Token == '' then
    print('[TopServeurVote] Token manquant. Ajoutez set topserveur_token "VOTRE_TOKEN" dans server.cfg')
    return
  end

  local playerName = GetPlayerName(source)
  if playerName == nil or playerName == '' then
    return
  end

  local endpoint
  if TopServeurVote.IdentifierType == 'steam' then
    local steamId = getSteamIdentifier(source)
    if steamId == nil then
      log(('SteamID introuvable pour %s'):format(playerName))
      return
    end

    endpoint = ('%s/votes/claim-steam?server_token=%s&steam_id=%s'):format(
      TopServeurVote.ApiBaseUrl,
      urlEncode(TopServeurVote.Token),
      urlEncode(steamId)
    )
  else
    endpoint = ('%s/votes/claim-username?server_token=%s&playername=%s'):format(
      TopServeurVote.ApiBaseUrl,
      urlEncode(TopServeurVote.Token),
      urlEncode(playerName)
    )
  end

  PerformHttpRequest(endpoint, function(statusCode, body)
    if statusCode ~= 200 then
      log(('API erreur HTTP %s pour %s'):format(statusCode, playerName))
      return
    end

    local ok, payload = pcall(json.decode, body)
    if not ok or payload == nil then
      log(('Réponse JSON invalide pour %s'):format(playerName))
      return
    end

    if payload.success == true and payload.claimed == 1 then
      local now = os.time()
      voteCache[playerName] = now
      TriggerEvent('onPlayerVote', playerName, os.date('!%Y-%m-%dT%H:%M:%SZ', now))
      TriggerClientEvent('chat:addMessage', source, {
        args = { 'Top Serveur', 'Merci pour ton vote !' }
      })
      log(('Vote réclamé pour %s'):format(playerName))
      return
    end

    log(('Aucun vote réclamable pour %s : %s'):format(playerName, payload.message or 'sans message'))
  end, 'GET')
end

RegisterCommand('topserveur_claimvote', function(source)
  if source == 0 then
    print('[TopServeurVote] Cette commande doit être utilisée par un joueur.')
    return
  end

  claimVote(source)
end, false)

CreateThread(function()
  print('[TopServeurVote] Plugin de vote actif.')

  while true do
    Wait(TopServeurVote.CheckInterval * 1000)

    for _, source in ipairs(GetPlayers()) do
      claimVote(tonumber(source))
    end
  end
end)
