download non mac games like so:

1. use steamcmd (from brew cask) to install the game

> steamcmd

then in the shell it lauches

  login <username> <password>

  @sSteamCmdForcePlatformType windows
  NOTE: Set platform to Windows (if on Linux, for example)

  app_update <app_id>
  app_uninstall <app_id>
    NOTE: app_id is the last number in the url of an apps store page on steam

2 alt. open PlayOnMac
 click 'install'
 click 'Install a non-listed program'
 'Install a program in a new virtual drive'
 name the drive to the game name
 use another wine version: NOTE: make sure to select wine 64 during the wizard
 NOTE: for some reason ~/Library isnt listed when browsing for the game
  workaround: mkdir ~/steam-game-links/ and copy the .exe to this location

2 alt. go to the location of the .exe

> cd "$HOME/Library/Application Support/Steam/steamapps/common/<app>"

3. use PlayOnMac to launch app

in the .exe dir:
> explorer .

right click and open with PlayOnMac and go through the wizard

