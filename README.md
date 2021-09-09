# Template Project for HaxeFlixel games

## Debugging

To develop on the game, run `line test html5`

### Template features:
- Preconfigured libraries
  - FMOD Studio project with menu sound effects and a random song I wrote
  - Ready to use Bitlytics tie-ins
  - Various utility libraries
- Basic state templates
  - Main menu with buttons to load the credits or start the game
    - Controller, keyboard, or mouse support for menu navigation
  - Credits state with built-in scrolling
- Preconfigured .gitignore
- Github build actions
  - Dev builds on push to master
  - Production builds on releases

### Configuration
1. Set the proper Github secrets:
    - `BUTLER_API_KEY`: The Butler API key from itch.io
    - `ANALYTICS_TOKEN`: The InfluxDB access token to the bucket
2. Run the `setup_repo.sh` script to update github workflow files and project configuration json

### Analytics
- Holding `D` and pressing `M` at the main menu will allow playing the release game without sending metrics. This is indicated by a sound effect and a log message once pressed.

### Dependencies

#### **haxelib.deps**

* `haxelib.deps` - Contains all dependencies needed by the project other than haxe itself
  * It supports two dep styles
    * standard haxelib dependencies
      * Formatted as: `<libName> <libVersion>`
    * git dependencies
      * Formatted as: `<libName> git <gitRepoLocation> <OPTIONAL: gitBranchOrTag>`
* `init.sh` - Script that reads `haxelib.deps` file and configures `haxelib`
  * This script will need to be run any time the dependencies change
  * This script is run by the github actions as part of the build so local and github builds are equivalent

### Maintenance

#### **Formatting**

* This projects uses the [haxe-formatter](https://github.com/HaxeCheckstyle/haxe-formatter) package for formatting using default settings
  * `format.sh` is a convenience script will perform the formatting
