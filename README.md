# Template Project for HaxeFlixel games

### Template features:
- Pre-configured libraries
  - FMOD Studio project with menu sound effects and a random song I wrote
  - Ready to use Bitlytics tie-ins
    - - Grafana metrics visualization
  - Newgrounds API boiler plate
  - Various utility libraries
- Basic state templates
  - Main menu with buttons to load the credits or start the game
    - Controller, keyboard, or mouse support for menu navigation
  - Credits state with built-in scrolling
- Pre-configured .gitignore
- [Aseprite art pipeline](#aseprite)
- Github build actions
  - Dev builds on push to master
  - Production builds on releases

### Template Configuration (on repo creation)
1. Set the proper Github secrets:
    - `BUTLER_API_KEY`: The Butler API key from itch.io
        - API keys can be generated from `itch.io` -> `Settings` -> `API Keys` -> `Generate new API key`
        - If using this template for non Bit Decay games, the workflow files to use the correct `itchUserName`
    - `ANALYTICS_TOKEN`: The InfluxDB access token from influxdata.com
        - API token can be generated from `influxdata.com` -> `Load Data` -> `API Tokens` -> `Generate API Token`
2. Run the `./bin/setup_repo.sh` script to update github workflow files and project configuration json
