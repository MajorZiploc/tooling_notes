vscode cli

# reload (useful for reloading extensions)
<cmd>+<shift>+<p> Developer: Reload Window
<cmd>+<shift>+<p> Developer: Reload With Extensions Disabled

# lists installed extensions
code --list-extensions
code --install-extension ms-vscode.cpptools
code --uninstall-extension ms-vscode.csharp

# toggle notifications (bottom right info, warning, error messages)
<cmd>+<shift>+<p> Noticiations: Toggle Do Not Disturb Mode

# nav to last open file
<cmd>+p <cmd>+p
then release

# vim plugin notable supported commands

-- view open buffers and allows for jk motion (like <ctrl>+<tab> on mac but in reverse)
:ls

-- is like <ctrl>+<tab> on mac but with jk motions
:vsc workbench.action.quickOpenPreviousRecentlyUsedEditor

q:

-- close all folds
zM

-- open all folds
zR

-- close current fold
za

-- open current fold
zo
