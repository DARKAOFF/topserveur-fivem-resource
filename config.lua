TopServeurVote = {}

TopServeurVote.Token = GetConvar('topserveur_token', '')
TopServeurVote.ApiBaseUrl = GetConvar('topserveur_api_url', 'https://topserveur.fr/api/public/v1')
TopServeurVote.CheckInterval = tonumber(GetConvar('topserveur_check_interval', '60')) or 60
TopServeurVote.Debug = GetConvar('topserveur_debug', 'false') == 'true'

-- Type d'identifiant utilisé pour réclamer les votes.
-- username : pseudo FiveM / nom joueur.
-- steam    : identifiant steam:hex converti et envoyé comme steam_id brut.
TopServeurVote.IdentifierType = GetConvar('topserveur_identifier_type', 'username')
