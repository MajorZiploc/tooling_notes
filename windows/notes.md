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
