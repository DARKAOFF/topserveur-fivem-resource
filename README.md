# UpServeur FiveM Vote Resource

Plugin officiel UpServeur pour connecter un serveur de jeu au système de vote UpServeur.

Cette ressource FiveM permet de vérifier les votes via l’API publique UpServeur, de réclamer une récompense une seule fois, puis de déclencher un événement serveur exploitable par tes scripts.

## Installation

1. Télécharge le dépôt ou le ZIP GitHub.
2. Place le dossier dans `resources/[upserveur]/upserveur_vote`.
3. Ajoute la configuration recommandée dans `server.cfg`.
4. Lance `ensure upserveur_vote`.

```cfg
ensure upserveur_vote

set upserveur_token "VOTRE_TOKEN_SERVEUR"
set upserveur_api_url "https://upserveur.fr/api/public/v1"
set upserveur_check_interval 60
set upserveur_identifier_type "username"
set upserveur_debug "false"
```

## Compatibilité ancienne configuration

La ressource lit encore temporairement les anciennes variables :

- `topserveur_token`
- `topserveur_api_url`
- `topserveur_check_interval`
- `topserveur_identifier_type`
- `topserveur_debug`

Tu peux donc migrer sans casser un serveur déjà en production.

## Variables

| Variable | Valeur par défaut | Description |
| --- | --- | --- |
| `upserveur_token` | vide | Token serveur disponible sur UpServeur. |
| `upserveur_api_url` | `https://upserveur.fr/api/public/v1` | Base URL API. |
| `upserveur_check_interval` | `60` | Intervalle de vérification en secondes. |
| `upserveur_identifier_type` | `username` | Mode d’identification du joueur. |
| `upserveur_debug` | `false` | Active les logs détaillés. |

## Modes d’identifiant

- `username` : utilise le pseudo FiveM du joueur
- `steam` : utilise le SteamID détecté

## Événements exposés

- `onUpServeurVote`
- `onPlayerVote` reste déclenché temporairement pour compatibilité

Exemple :

```lua
AddEventHandler("onUpServeurVote", function(playername, date)
  print(("[UpServeurVote] %s a vote le %s"):format(playername, date))
end)
```

## Commandes

- `/upserveur_claimvote`
- `/topserveur_claimvote` reste disponible temporairement

## Endpoints utilisés

```txt
GET https://upserveur.fr/api/public/v1/votes/claim-username?server_token=TOKEN&playername=PSEUDO
GET https://upserveur.fr/api/public/v1/votes/claim-steam?server_token=TOKEN&steam_id=STEAM_ID
```

## Dépannage

- `Token manquant` : vérifie `set upserveur_token`
- `SteamID introuvable` : le joueur n’expose pas Steam côté serveur
- `Aucun vote réclamable` : pas de vote récent ou récompense déjà consommée
- `API erreur HTTP` : vérifie l’URL, le token et la connectivité réseau
