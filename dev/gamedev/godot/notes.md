## Resources

### polished projects to reference
https://www.gdquest.com/
https://www.gdquest.com/library/character_movement_3d_platformer/#download-files

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

NOTE: if exporting from blender -- remember to back face cull on blender bcuz that setting will carry over to godot

## 3D top level design

limit lights to 1 directional, and 8 omni_or_spot_light in camera_fov

use decals to add details to things quickly
  do this plus color atlas for rest of colors

reserve UV2 for light baking -- light baking only to be done once game is actually done and needs more polish

fake ambient light by adding omni_or_spot_light in the reverse direction at lower energy to the main omni_or_spot_light
  this is a quick hack to avoid needing ambient lighting which has raises performances needs and also removes need for light baking which takes time to setup well and alot of time to actually bake

## Raycasts
Efficient Raycasting: If using raycasts, consider performing them less frequently or using force_raycast_update with disabled RayCast2D nodes for on-demand updates, especially with many agents.

## Importing 3D

NOTE: use nested_scene approach:
1. create 3D Scene
2. drag modal into Scene outliner

NOTE: if need to reference something inside the nested_scene
  right click and make editable (enable Editable Children)
  do your referencing and if you can remark the nested_scene as non_editable (disable Editable Children)
    NOTE: can be useful if you need a collision shape that matches the mesh exactly
      this collision shape is likely going to be very slow performance, so its better to stick to simple collision shapes or model ones in blender and import them
  if the asset remains editable, it can cause problems with reimport of the asset
  if you find yourself needing to keep assets editable -- it might be better to split the asset into multiple assets instead

normal import settings right of Scene tab top left

double click asset to get advanced import settings
  NOTE: to get materials extracted to where you can use StandardMaterial3D you need to do this

glTF 2.0 is apparaently better or easier to deal with than fbx
NOTE: glb is just glTF in binary format to save space
### Blender Export Settings for glb changes from defaults
Include
  Selected Objects: True
Mesh
  Apply Modifiers: True

NOTE .blend files are supported. Godot just converts them to glTF under the hood
  must configure godot to know the path of blender

### 3D model management

set the .glb as editable

temporary openning a .glb and search through the node properties can help when you need to set stuff dynamically through code 
^also the most reliable way to see the results of a .tres shader (ShaderMaterial)

### Materials

#### StandardMaterial3D

albedo -- base color -- like modulate

shading -- built in shader styles
can get toon shading by using Toon in Diffuse and Specular mode

Normal -- normal map -- depth for light
  Godot using OpenGl style normal maps, not DirectX normal maps
    DirectX maps will appear inverted
    Invert normal map texture by:
      go to import window of the normal map texture
      Process -> Normal Map Invert Y: Check
    Click: Reimport

Metallic -- like specular -- 1 channel
  NOTE: specular not supported

Roughness -- the invert of smooth -- 1 channel
  if you have a smooth map -- invert it in an image editor and import

Ambient Occlusion -- ao map -- how much ambient light reaches the surface -- 1 channel
  darken parts of the mesh that light should have a hard part reaching

Emission -- RGB
  manual or use an emission map

##### Transparency

requires the albedo texture to have reduced alphas on pixels aswell as enabling Transparency
NOTE: try your best to avoid Alpha_Blending
  cons of Alpha_Blending:
    cant have shadows
    has issues with sorting materials -- z index fighting
    slow to render -- performance issues
instead use one of [Alpha_Scissor, Alpha_Hash, Depth_Pre_Pass]

#### ORMMaterial3D

can combine with normal StandardMaterial3D's without issue

ORM texture and material
  combines Ambient (O)cclusion, (R)oughness and (M)etallic,
  Occlusion -- red channel
  Roughness -- green channel
  Metallic -- blue channel

## CollisionShape

NOTE: if you copy and paste, you need to right click the Shape property of the node and make unique

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
