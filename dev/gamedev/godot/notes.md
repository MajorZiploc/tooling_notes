# Resources

## Gotches

To save theme changes when editing via the editor. PRESS THE SAVE BUTTON ON THE THEMES TAB
  other events can trigger a save, but they arent consistent

## Properties

// get the path of the current file within the file itself
scene_file_path

// pause all pausable nodes
get_tree().paused = true;

// make a node as not pausable - can also do in tscn under Node -> Process -> Mode: Always
self.process_mode = Node.PROCESS_MODE_ALWAYS;

## Methods

// call method on each node in a group
get_tree().call_group("group_name", "method_name", method_param_1);

// easy way to make something face the right direction
look_at(global_position + direction);

// casting types
func foo(param1: BaseType):
  var thing: SubType = param1 as SubType;

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

Requires getting the Export Templates from the godoto download page
then go to Editor -> Manage Export Templates...
  Install from File

## HTML
  DONT MARK IT AS RUNNABLE (a toggle box in the export)
    will cause jittering for game time and tweens and such
    it will be runnable without this ont
  right before saving
    rename to 'index.html'
    uncheck Export With Debug
