# Resources

## Effects like fire, water, wind, fog
https://godotshaders.com/

## course
https://www.gamedev.tv/courses/godot-complete-2d/lectures/46645012

# General

## Recoloring

### Sprites
- up front
  recolor with replace_color.gd script i made in the crash course repo

- shaders (will use gpu but will be run continuously)
  with canvas_item fragment .gdshaders

### Tillsets
- up front
  cant do inside godot. do in aseprite with color replace tools i made in this repo

- shaders (will use gpu but will be run continuously)

# Plugins

Phantom Camera
  enhanced Camera

https://github.com/BenjaTK/Gaea
  procedural maps


# Misc

draw order of a scene is top down, so last thing will be ontop of previous things

y sort enabled for auto z indexing elements on screen

# Export

## HTML
  DONT MARK IT AS RUNNABLE (a toggle box in the export)
    will cause jittering for game time and tweens and such
    it will be runnable without this ont
