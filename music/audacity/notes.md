# input device
ensure no audio effects or noise cancelation is happening from your OS
access your devices advanced optiosn:
Windows:
  TLDR: go to sound input devices and click your device and go to advanced settings and disable enchancements
  1. Select Additional device properties from the Device Properties panel. (Start > Settings > System > Sound > Select your microphone from the dropdown under Input > Device Properties >Additional device properties)
  2. Depending on your manufacturer, the setting to disable audio enhancements will either be on the Enhancements tab, or the Advanced tab.
  3. On the Enhancements tab, select either the Disable all enhancements or the Disable all sound effects check box (depending on which option you see), and then select OK.
  4. If you don't see the setting there, select the Advanced tab, and look for the setting, Enable audio enhancements.  If the manufacturer located the setting here, uncheck the box to disable audio enhancements.

# reduce .aup3 (project) file size
Edit -> Preferences -> Audio Settings:
  Project Sample Rate: choose a lower number
  tracks can also be converted to a lower sample rate after a track has been created
Edit -> Preferences -> Quality:
  reduce Sample Rate Converter dropdowns quality levels
