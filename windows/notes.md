# Disable animations

Useful for removing things like the slow switch desktops animations

Settings -> Accessibility -> Visual effects
Animation: Off

# Power settings

Settings -> System -> Power & battery
  Power Mode:
    Plugged in: Best Performance
    On battery: Best Power Efficiency

# Desktops:

## Nav - back and forth desktops

<super>+<ctrl>+<(left|right)_arrow>

## Desktop control panel
<super>+<tab>



# SLEEP ISSUE:
  SHORT:  always unplug on laptop before closing the lid

  EXPLANATION:
  windows moved away from s3 sleep. its on s0 network (connected|disconnected) sleep.

  means your cpu can be on when your laptop is sleeping.

  there are alot of work arounds for this but some unsafe becuz intel gen12 processors dont support s3 sleep now.

  if laptop is connected to power and you close the lid, it enters s0 network connected sleep
  if laptop is disconnected from power and you close the lid, it enters s0 network disconnected sleep
  if laptop is connected to power and you close the lid and then you unplug the laptop, it enters s0 network connected sleep

# Hanging processes holding on to file or folder:

## use handle to find out what is using it
handle.exe ./<file_or_folder>

## kill the task
taskkill /PID pid_number /F

# developer settings

Settings -> System -> For developers

  Enable Developer Mode

  Enable all File Explorer options

  Enable all Powershell options

  Enable sudo option
    adds sudo command
