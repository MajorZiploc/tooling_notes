# Settings

## Text Editor

Text Editor -> Behavior
  Indent Section:
Type: Spaces
Size: 2
  Files
Open Dominant Script on Scene Change: Checked

## 3D navigation

Editors -> 3D
  Navigation Section:
Navigation Scheme: Custom
Emulate 3 Button mouse: check
  Navigation Feel Section:
Orbit Sensitivity: 2.2
Translation Sensitivity: 7.2


# Vim

only works in godot v4+

godot-vim
 must be installed per project
    for release version (older)
      install via the middle scene top bar with AssetLib
      search vim and install
      must be enabled in Project -> Project Settings... -> Plugins
    for most up to date version:
      go to your project:
        cp -r <rest/of/lib/path>/godot-vim/addons/godot-vim/ <rest/of/your/project/path>/addons/godot-vim
      must be enabled in Project -> Project Settings... -> Plugins

if you want to use godot v3 and want vim:
  vscode godot plugin
  will need the project open in godot and vscode so that the lsp is up for vscode1

coc option
coc-gdscript addon
