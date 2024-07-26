
# Running from windows side but getting lsp support in wsl

## init setup

you need to install node_modules in wsl (clone the repo on the wsl side)

then move those node_modules to the windows_side repo

```bash
npm i
mv node_modules /mnt/c/Users/<username>/projects/<projectpath>
```

start nvim on wsl side but in the windows_side repo

then to run from windows_side you need to reinstall the node_modules

backup the wsl node_modules

```bash
powershell.exe -c 'rename-item node_modules node_modules_wsl'
```

reinstall node_modules on windows side

```pwsh
npm i
```

## returning setup

```bash
powershell.exe -c 'rename-item node_modules node_modules_ws'
powershell.exe -c 'rename-item node_modules_wsl node_modules'
```

start nvim on wsl side but in the windows_side repo

```bash
powershell.exe -c 'rename-item node_modules node_modules_wsl'
powershell.exe -c 'rename-item node_modules_ws node_modules'
```

