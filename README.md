# TopServeur FiveM Vote Resource

Resource FiveM officiel pour connecter un serveur GTA RP à TopServeur.

Il permet de vérifier les votes via l'API publique TopServeur, de réclamer une récompense une seule fois, puis de déclencher un event serveur `onPlayerVote`.

## Téléchargement

- Repository : https://github.com/DARKAOFF/topserveur-fivem-resource
- ZIP direct : https://github.com/DARKAOFF/topserveur-fivem-resource/archive/refs/heads/main.zip

## Installation

1. Téléchargez le ZIP.
2. Décompressez le dossier dans les resources de votre serveur FiveM.
3. Renommez le dossier en `topserveur_vote`.
4. Ajoutez la configuration ci-dessous dans `server.cfg`.
5. Redémarrez votre serveur ou lancez `ensure topserveur_vote`.

```cfg
ensure topserveur_vote

set topserveur_token "VOTRE_TOKEN_SERVEUR"
set topserveur_api_url "https://topserveur.fr/api/public/v1"
set topserveur_check_interval 60
set topserveur_identifier_type "username"
set topserveur_debug "false"
```

## Configuration

| Variable | Valeur par défaut | Description |
| --- | --- | --- |
| `topserveur_token` | vide | Token disponible dans le dashboard TopServeur. |
| `topserveur_api_url` | `https://topserveur.fr/api/public/v1` | URL de l'API publique. |
| `topserveur_check_interval` | `60` | Intervalle en secondes pour vérifier les votes des joueurs connectés. |
| `topserveur_identifier_type` | `username` | Mode d'identification du joueur. |
| `topserveur_debug` | `false` | Affiche des logs détaillés dans la console serveur. |

## Modes d'identifiant

`topserveur_identifier_type` peut valoir :

- `username` : utilise le pseudo FiveM du joueur.
- `steam` : utilise le SteamID du joueur.

Le mode choisi doit correspondre au type d'identifiant configuré dans le dashboard TopServeur.

## Event disponible

Ajoutez vos récompenses dans un fichier serveur, ou utilisez `example.lua`.

```lua
AddEventHandler('onPlayerVote', function(playername, date)
  print(('[TopServeurVote] %s a voté le %s'):format(playername, date))

  -- Exemple :
  -- giveMoney(playername, 5000)
  -- giveItem(playername, 'premium_case', 1)
end)
```

## Commande joueur

Un joueur peut forcer la vérification avec :

```txt
/topserveur_claimvote
```

## Sécurité

- Ne partagez jamais votre `topserveur_token` publiquement.
- Gardez le token uniquement côté serveur.
- Si le token fuite, régénérez-le depuis le dashboard TopServeur.
- Les routes `claim-*` consomment le vote et évitent les doubles récompenses.

## Endpoints utilisés

```txt
GET https://topserveur.fr/api/public/v1/votes/claim-username?server_token=TOKEN&playername=PSEUDO
GET https://topserveur.fr/api/public/v1/votes/claim-steam?server_token=TOKEN&steam_id=STEAM_ID
```

## Dépannage

- `Token manquant` : vérifiez `set topserveur_token`.
- `SteamID introuvable` : le joueur n'a pas d'identifiant Steam détecté ou le serveur n'expose pas Steam.
- `Aucun vote réclamable` : le joueur n'a pas voté récemment ou sa récompense a déjà été réclamée.
- `API erreur HTTP` : vérifiez l'URL API, le token et la connectivité du serveur.
