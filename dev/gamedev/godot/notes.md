# Resources

## Gotches

Callable - you cant await a .call() it wont error or warn you, but it also definitely wont wait - use signals to workaround this

To save theme changes when editing via the editor. PRESS THE SAVE BUTTON ON THE THEMES TAB
  other events can trigger a save, but they arent consistent

### Shaders

#### instance uniforms
there is a limit of 16 instance shader params
  use vec4s and similar to stuff multiple variables into
  if you have to pass 4 floats, just send 1 vec4

how to apply multiple shaders (in order) to a single texture
  applying 1 shader per color rect that is a child of the target texture is 1 approach for this if you
    did this for applying fog and cross shine to a texture
  can also dup the texture and apply an effect to 1 of the dups
    did this for shadows
  if static shaders then you can use each shader on the texture then write to a new texture and replace the original texture and repeat for all shaders

https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/canvas_item_shader.html

https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shading_language.html
  Shading language
    Data types
    Arrays
    Constants
    Structs
    Operators
    Flow control
    Discarding
    Functions
    Varyings
    Interpolation qualifiers
    Uniforms
    Built-in variables
    Built-in functions

https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shader_functions.html

#### Compute Shaders

Forward+ only: https://docs.godotengine.org/en/stable/tutorials/shaders/compute_shaders.html#
seems like an interesting way to parallelize work
write glsl code
likely limited to basic data types
1D, 2D, 3D data struct support
requires you to do memory cleanup on your own
can result in crashes if a piece of gpu work takes more than 5-10 seconds on some systems
  this becomes even more complex based on the type of gpu
  older gpus will reach that time limit quickier

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

## 3D viewport

click on axis to get top, side, front, etc views

1 unit = 1 metric meter (NOTE: 1 unit = 1 pixel in 2d)

F -- focus selected element

hold rmb -- wasd mode, can also look around with mouse
  + shift to fly faster

q -- toggle select mode

y -- toggle snapping
  configure snap:
    almost_top_menu: Transform -> Configure Snap...
      Translate Snap: 0.1
      Rotate Snap (deg): 10
      Scale Snap (%): 10

Translation Modes:
hold ctrl to toggle snapping
t -- toggle local vs global mode

  w -- toggle move mode

  e -- toggle rotate mode

  r -- toggle scale mode
    scale uniformly by clicking and holding outside of the gizmos rather than on the gizmos

see ./editor/notes.md Keybinds section
  just like blender using the Begin* keymaps, you can press xyz to limit your transform to a specific axis
    and add shift to that to NOT transform only on said axis

## 3D Grayboxing

### interiors
csg nodes
node_settings: Use Collision: checked

CSGCombiner -- group a bunch of CSGs
  makes configuring things like Collision easier since its at the group level instead of individual

#### how csg nodes impact each other:
Operation: [Union, Intersection, Subtraction]

### exteriors
Terrian3D for Godot 4 extension

## Exporting

export grey box / csg scenes to .gltf to import into blender to use as a base to model the real scene:
Scene -> Export as...
  glTF 2.0 Scene

## Importing
glTF 2.0 is apparaently better or easier to deal with than fbx

## CLI location

### mac

/Applications/Godot.app/Contents/MacOS/Godot

## User data Storage Location

### Mac
"$HOME/Library/Application Support/Godot/app_userdata/game_02"

### Windows
"%APPDATA%\Godot\app_userdata\game_02"

### Linux
"$HOME/.local/share/godot/app_userdata/game_02"


## Translations

### run from cli
$GODOT_CLI --language <lang_code>

## Devtool notes:

### Game Tab (one of the top middle tabs near AssetLib)
  3 dots has 2 good options
  the second one allows you to toggle the game window to be in the editor or floating

### various cli flags to debug info about game

#### NOTE: some of these flags may cause your game window to popup in the background rather than the focused window

$GODOT_CLI "$godot_scene" --debug-path --debug-collisions --debug-paths --debug-navigation --debug-avoidance --debug-stringnames --debug-canvas-item-redraw

  --debug-stringnames is very noisy after quiting the run

  can also be done via ui:
    Debug -> Visible *

### hot reload of code changes is supported if running via the editor

  either
    change code directly in editor and save
  OR
    change code in nvim and save and go to editor. choose to reload changes and then make a blank line change via editor

## Localization
valid TranslationServer.set_locale(language); values: (Set 1 column)
https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes
