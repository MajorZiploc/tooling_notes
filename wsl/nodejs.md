# NOTE: simpler path for this is to just git clone the deps on the wsl side and browser the code

# Running from windows side but getting lsp support in wsl

## init setup

you need to install node_modules in wsl (clone the repo on the wsl side)

then move those node_modules to the windows_side repo

```bash
npm i
mv node_modules /mnt/c/Users/<username>/projects/<projectpath>
```

or for moving (EXPERIMENTAL)

```pwsh
powershell.exe -c move-item '$(pwd_wsl)/node_modules' -destination node_modules"
```

start nvim on wsl side but in the windows_side repo

then to run from windows_side you need to reinstall the node_modules

backup the wsl node_modules

```bash
powershell.exe -c 'move-item node_modules -destination "$env:TEMP/nm_wsl"'
```

reinstall node_modules on windows side

```pwsh
npm i
```

## returning setup

```bash
powershell.exe -c 'move-item node_modules -destination "$env:Temp/nm_ws"'
powershell.exe -c 'move-item "$env:Temp/nm_wsl" -destination node_modules'
```

start nvim on wsl side but in the windows_side repo

```bash
powershell.exe -c 'move-item node_modules -destination "$env:Temp/nm_wsl"'
powershell.exe -c 'move-item "$env:Temp/nm_ws" -destination node_modules'
```

## stop program working with node_modules
```bash
powershell.exe -c 'handle.exe node_modules'
```

```bash
powershell.exe -c 'stop-process -Id <pid>'
```

## cacheing of node_modules libs

tsserver appears to cache the libs. may be useful to learn how to tap into this for types

### Example
/home/majorziploc/.cache/typescript/5.5/node_modules/@types/react-redux/index.d.ts |326 Col 14| export const connect: Connect;
