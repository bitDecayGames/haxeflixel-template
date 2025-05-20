# Contributing

1. [Developer Setup](#development-setup)
1. [Execution](#execution)
2. [Assets](#assets)
3. [Dependencies](#dependencies)
4. [Metrics & Analytics](#metrics--analytics)
5. [Code Quality](#code-quality)

## Developer setup

1. `./bin/setup_hooks.sh` - Run to copy git hooks over
2. `./bin/init_deps.sh` - Run to pull all dependencies at the proper versions. See [Dependencies](#dependencies) for more info.

# Execution

## General Debugging

This project is intended to leverage VSCode to make some of the features available there. To debug the project from within VSCode:

1. Ensure that `HTML5 / Debug` is the selected target in the bottom bar.
1. Press `F5` to run the configuration
1. After making changes, use `Ctrl+Shift+F5` to restart the execution, or press the Refresh icon in the debugger button bar.
1. Refresh the browser window to run the new code.
   * _Do not close the browser window between code changes. The way the launch tasks work, you will have to kill the active tasks and restart the debugger._

To run the project from command line (breakpoints will not be available):

1. `./bin/run_debug.sh`
   * Any extra flags/arguments can be given to this script

# Assets

## Art

Art assets in the `assets/` directory will be compiled into the final game bundle. Any intermediate files (`.psd`, `.ase`, etc) that are not used directly by the code should be placed within the `art/` directory to avoid bloat of the deployable game. All exported art files (`.png` and the like) tha the game code is using directly must be in the `assets/` directory to be usable by the game. There is tooling to assist in getting some of these files to the proper place.

### Aseprite

All Aseprite files (file with the `.ase` and `.aseprite` extensions) within the `art/` directory are automatically exported as Atlases as part of a pre-commit hook. The details of this process can be found in the `pre-commit` hook file, as well as the `AsepritePacker` tool code.

There is an accompanying set of code in the `source/loaders/` directory to aid with loading these files into game objects that allow frames and durations to be driven entirely via the Aseprite files.

# Audio

This project is intended to leverage FMOD for the in-game audio. If just standard audio files are intended to be used, they should be placed into the `assets/` directory.

## FMOD

The top level `fmod/` directory is intended to hold all of the project files from FMOD. The FMOD project manages exporting files appropriately and saving them to their final destination in `assets/fmod/` for the game to load and use.

The included FMOD base project also manages the `FmodConstants.hx` file, which provides compile-time constants for what sound effect and music files are available for use.

## Dependencies

External dependencies use a local script and dependency file to ensure that the project has a local copy of required dependencies so that the user's global packages do not have to be configured before they can contribute to this repo.

#### **haxelib.deps**

* `./bin/init_deps.sh` - Script that reads `haxelib.deps` file and configures `haxelib`
  * This script will need to be run any time the dependencies change
  * This script is run by the github actions as part of the build so local and github builds are equivalent
* `haxelib.deps` - File Containing all dependencies needed by the project other than haxe itself
  * It supports two dep format styles
    * standard haxelib dependencies (pulled from `lib.haxe.org`)
      * Formatted as: `<libName> <libVersion>`
    * git dependencies
      * Formatted as: `<libName> git <gitRepoLocation> <OPTIONAL: commit-ish>`

# Metrics & Analytics

- Some basic analytics are already configured to be reported after the proper project configuration has been done.
- To view game metrics, run `./bin/view_metrics.sh` and a grafana instance will be created locally that connects to the cloud metrics. Graphs will be available at `http://localhost:3000` if the browser doesn't automatically open.
  - This script will prompt for a read token the first time it is run for access to the data. Consult whoever controls your cloud data for a token.
- Holding `D` and pressing `M` at the main menu will allow playing the release game without sending metrics. This is indicated by a sound effect and a log message once pressed.

# Code Quality

## Formatting

* This projects uses the [haxe-formatter](https://github.com/HaxeCheckstyle/haxe-formatter) package for formatting using default settings
  * `./bin/format.sh` is a convenience script will perform the formatting and is configured to run against all commits as part of the `pre-commit` hook.
