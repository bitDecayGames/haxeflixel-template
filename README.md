# Template Project for HaxeFlixel games

### Template features:
- FMOD Studio project with menu sound effects and a random song I wrote
- Main menu with buttons to load the credits or start the game
- Credits state with built-in scrolling
- Preconfigured .gitignore
- Pre-integrated Bitlytics tie-ins
- Automatic Github build actions

### Configuration
- Set the proper Github secrets:
  - `BUTLER_KEY`: The Butler API key from itch.io
  - `ANALYTICS_KEY`: The InfluxDB access token to the bucket
- Fill out the `assets/data/config.json` fields
  - `analytics.name`: The simplified game name, used as the metrics id and some other things. Should be snake case or similar.
  - `analytics.influx.bucket`: The bucket ID from InfluxDB
- Fill in the `itchGameName` in both workflow files
  - This should be the URL name from itch.io