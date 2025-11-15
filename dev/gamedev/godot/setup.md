## Editor settings

### indents
Editor -> Editor Settings -> [(look for 'Indent'): (Text Editor -> Behavior)]
  Type: Spaces
  Size: 2
  Auto Indent: On
  Convert Indent on Save: On

### disable on save actions
Editor -> Editor Settings -> [(look for 'on save')
  disable what makes sense

### font size (also ui component size)
Interface -> Editor
  Main Font Size: 10
  Code Font Size: 10

### for performance

Interface -> Editor
Single Window Mode: true
V-Sync Mode: Disabled
Low Processor Mode Sleep (usec): 33000 # roughly 30 fps
Update Continuously: false # NOTE: default value is false

Text Editor -> Code Complete Enabled: false
ctrl+space or cmd+space to trigger code complete manually

### Windows OS settings for performance

Enable Developer Mode on Windows
Win Key -> "Developer settings"

Power In Laptop to power source (may require high watt charger)
you may have settings on to reduce power draw on battery
  to toggle performance to high:
  1. Win Key -> "Power, sleep and battery settings"
    Power Mode:
      On battery: Best Performance
  2. Win Key -> "Nvidia Control Panel" -> 3D Settings -> Manager 3D settings
    Preferred graphics processor: "High-performance NVIDIA processor"
      Apply
  3. adjust more settings in Nvidia Control Panel
