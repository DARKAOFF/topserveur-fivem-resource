local voteCache = {}

local function log(message)
  if UpServeurVote.Debug then
    print(("[UpServeurVote] %s"):format(message))
  end
end

local function urlEncode(value)
  if value == nil then
    return ""
  end

  value = tostring(value)
  value = value:gsub("\n", "\r\n")
  value = value:gsub("([^%w%-_%.~])", function(character)
    return string.format("%%%02X", string.byte(character))
  end)

  return value
end

local function getSteamIdentifier(source)
  for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
    if identifier:sub(1, 6) == "steam:" then
      return identifier:gsub("steam:", "")
    end
  end

  return nil
end

local function claimVote(source)
  if UpServeurVote.Token == nil or UpServeurVote.Token == "" then
    print('[UpServeurVote] Token manquant. Ajoutez set upserveur_token "VOTRE_TOKEN" dans server.cfg')
    return
  end

  local playerName = GetPlayerName(source)
  if playerName == nil or playerName == "" then
    return
  end

  local endpoint
  if UpServeurVote.IdentifierType == "steam" then
    local steamId = getSteamIdentifier(source)
    if steamId == nil then
      log(("SteamID introuvable pour %s"):format(playerName))
      return
    end

    endpoint = ("%s/votes/claim-steam?server_token=%s&steam_id=%s"):format(
      UpServeurVote.ApiBaseUrl,
      urlEncode(UpServeurVote.Token),
      urlEncode(steamId)
    )
  else
    endpoint = ("%s/votes/claim-username?server_token=%s&playername=%s"):format(
      UpServeurVote.ApiBaseUrl,
      urlEncode(UpServeurVote.Token),
      urlEncode(playerName)
    )
  end

  PerformHttpRequest(endpoint, function(statusCode, body)
    if statusCode ~= 200 then
      log(("API erreur HTTP %s pour %s"):format(statusCode, playerName))
      return
    end

    local ok, payload = pcall(json.decode, body)
    if not ok or payload == nil then
      log(("Reponse JSON invalide pour %s"):format(playerName))
      return
    end

    if payload.success == true and payload.claimed == 1 then
      local now = os.time()
      voteCache[playerName] = now
      local isoDate = os.date("!%Y-%m-%dT%H:%M:%SZ", now)
      TriggerEvent("onPlayerVote", playerName, isoDate)
      TriggerEvent("onUpServeurVote", playerName, isoDate)
      TriggerClientEvent("chat:addMessage", source, {
        args = { "UpServeur", "Merci pour ton vote !" }
      })
      log(("Vote reclame pour %s"):format(playerName))
      return
    end

    log(("Aucun vote reclamable pour %s : %s"):format(playerName, payload.message or "sans message"))
  end, "GET")
end

local function claimVoteCommand(source)
  if source == 0 then
    print("[UpServeurVote] Cette commande doit etre utilisee par un joueur.")
    return
  end

  claimVote(source)
end

RegisterCommand("upserveur_claimvote", claimVoteCommand, false)
RegisterCommand("topserveur_claimvote", claimVoteCommand, false)

CreateThread(function()
  print("[UpServeurVote] Plugin de vote actif.")

  while true do
    Wait(UpServeurVote.CheckInterval * 1000)

    for _, source in ipairs(GetPlayers()) do
      claimVote(tonumber(source))
    end
  end
end)
