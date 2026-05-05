local function getCompatConvar(primaryName, legacyName, defaultValue)
  local primaryValue = GetConvar(primaryName, "")
  if primaryValue ~= nil and primaryValue ~= "" then
    return primaryValue
  end

  return GetConvar(legacyName, defaultValue)
end

UpServeurVote = {}

UpServeurVote.Token = getCompatConvar("upserveur_token", "topserveur_token", "")
UpServeurVote.ApiBaseUrl = getCompatConvar(
  "upserveur_api_url",
  "topserveur_api_url",
  "https://upserveur.fr/api/public/v1"
)
UpServeurVote.CheckInterval = tonumber(
  getCompatConvar("upserveur_check_interval", "topserveur_check_interval", "60")
) or 60
UpServeurVote.Debug = getCompatConvar("upserveur_debug", "topserveur_debug", "false") == "true"

-- Type d'identifiant utilise pour reclamer les votes.
-- username : pseudo FiveM / nom joueur.
-- steam    : identifiant steam:hex converti et envoye comme steam_id brut.
UpServeurVote.IdentifierType = getCompatConvar(
  "upserveur_identifier_type",
  "topserveur_identifier_type",
  "username"
)

-- Compatibility alias for older installs.
TopServeurVote = TopServeurVote or UpServeurVote
