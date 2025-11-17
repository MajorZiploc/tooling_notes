# resources
https://cgcookie.com/account/orders
https://blendermarket.com/

## full model references
https://models.spriters-resource.com/

### textures and other 3d assets
https://polyhaven.com/
https://www.poliigon.com/

## 3d printing pipeline

### wide range of .stl files
https://www.printables.com/

### good tool for stl creation - has a good svg converter
https://www.tinkercad.com/dashboard

### create cookie / polymer clay .stl files
https://app.cookiecad.com/

### cookie / polymer clay .stl files (free and priced)
https://cults3d.com/
-- NOTE: think about making own and selling here

# python scripts
## installing deps
pyenv install 3.11
pyenv global 3.11
pip install -r ./requirements.txt

# blender cheat sheets (based alot of what i have here on these)

https://docs.google.com/document/d/1dH4r1tCrf2EddWYfjmFc2FTWdHiXYMymI9cVisXd6hg/edit?pli=1#heading=h.vc3zuzjxkz5v

# settings

NOTE: save preferences
  Edit -> Preferences -> bottom_left -> hamburger_menu

emulate numpad (when you dont have a numpad)
  Edit -> Preferences -> Input -> Check Emulate Numpad (top nums will work like numpad)

emulate 3 button mouse (Emulate middle mouse button) (when you dont have a mouse)
Edit -> Preferences -> Input -> Check Emulate 3 Button Mouse (alt+lmb)

^ undo stack
Edit -> Preferences -> System -> Memory & Limits -> Undo Steps: 256

extra shading stuff
Edit -> Preferences -> Kepmap -> check: Extra Shading Pie Menu Items

Plugins -- (load your plugins from blendermarket place or where ever):
Edit -> Preferences -> Add-ons
  top right dropdown arrow -- Install from Disk...

Enable these built in plugins:
  Node Wrangler - good or working with materials (like in the shader editor)
  Rigify - good for creating characters - gives various rigs in the shift+a menu

Render options (right_side_menu)
  to match other software (like game engines):
    Color Management:
      View Transform: Standard

  better for low poly game art:
  Render Engine: EEVEE

# workflow

add assets from 1 .blend file to another
File -> Append

## reset movement tools to better respect scale of object you wish to focus/edit on

toggles all other objects and rescales things to work better with current object
/

doesnt toggle all other objects and rescales things to work better with current object
` (choose View Selected) `

# short cuts

## High level control

numpad(1,3,7) cam_angles goes to front, right, and top respectively

ctrl + numpad(1,3,7) cam_angles goes to back, left, and bottom respectively
 
General window toggles
  top left below x2 the blender icon. you will see a grid with a ball on it
  click it and you will see a bunch of editors and diff views
  NOTE: the 'Info' option under 'Scripting' is for app logs

shift + space -- view tools -- dynamic context menu

` -- view all nav tools (View pie menu) `

. -- Pivot point menu

z -- render types like wire and solid meshes
  shift-z -- toggle back and forth between last 2 choices

tab -- toggle edit and object mode

t -- toggles left window (tools)

n -- toggles right window (camera lock area) (properties)

ctrl + space -- toggles scene collections and big tools

search menu (like ctrl-p in vscode)
F3

Bring up options of last command (only way to bring back the shift-a new shape options)
F9

home -- show all objects in view

Toggle user view
5NumPad or View -> Perspective/Orthographic

# 3D_Viewport

shift + 2finger_swipe -- pane

standard 2 finger pitching -- zoom

change zoom target:
alt-mmb -- hovered over area you want to be zoom target

2finger_swipe -- rotate view

g -- move
alt+g -- clear move/location

r -- rotate
rr -- trackball rotate
alt+r -- clear rotate

s -- scale
alt+s -- clear scale

  modifier controls for these
  ctrl -- while moving mouse will snap to grid (incremental movement / snapping)
  shift -- micro motions (precise movement)
  x,y,z to limit to the axis
  xx,yy,zz to limit to the local axis
  shift + x,y,z to limit to NOT axis the selected axis
  ctrl+a -- apply transformation - bakes transformation in and remove clear ability
    OR to apply specific transformation: (almost_top_menu) Object -> Apply -> Choose: (scale, location, rotation, etc...)
  o -- proportional editing
    scroll wheel -- change area of influence
      or pgup and pgdown
        some keyboards dont have these keys so you need to change the key shortcut under:
          Preferences -> Keymap
            search 'page'

a -- select all
alt+a -- deselect all
lmb -- select object
shift+lmb -- select multiple object
lmb+drag / b -- box select
c -- circle select
ctrl+i -- invert selection

shift+z -- toggle solid / wireframe view
alt+z -- toggle x-ray view

h -- hide
alt + h -- unhide all
shift + h -- hide all except selected

x -- delete

F9 -- adjust last operation
shift + r -- repeat last action

shift + d -- duplicate
alt + d -- duplicate linked

shift-a (add item)

merge menu / OR new collection -- depends on context
m

alt + m -- merging

shift+rmb -- move 3D cursor
shift+s (snap menu) or shift-c helps relocate cursor

0 -- toggle camera view

Ctrl+0NumPad -- change active camera

shift + f -- while in cam view, it allows cam to fly, similar to lock cam view

Mirroring object
ctrl + m -- followed by x,y,z then enter

Convert things like curves to mesh
rmb > convert to mesh

move vertexs to median z
sz0

rename
select object in Object mode
F2
or find object in outliner collection

toggle grid lines
alt + shift + z

toggle xray
alt + z

transform pivot point menu (almost_top_menu in middle)
  good for changing how things are scaled, etc

## more advanced

change render settings of an object (useful for making an object wireframe always when using a boolean modifier)
(right_side_menu)
Object -> Viewport_Display
  Display As: Wire

easier to see edges and such for low poly models
almost_top_menu Viewport_Shadings:
  Cavity: on
  Shadow: on

while changing values in the N panel or properties window
  select multiple objects
  hold alt (while changing values)

tmp drawing for annotation purposes:
  hold d + lmb -- draw stuff
  hold d + rmb -- erase drawings

q - quick favorites

lasso select
  lmb + drag - to select
  ctrl + lmb - to deselect

ctrl + j -- join objects

] -- select children
shift + ] -- extend child selection
[ -- select parent
shift + [ -- extend parent selection
ctrl + p -- parent to active object
  the Keep Transform choice is the most common
alt + p -- clear parent

F2 -- rename
ctrl+F2 -- batch rename

m -- move to collection

ctrl + (1-5) -- add subdivision surface modifier

## 3D_Viewport -- Edit_Mode

Viewport_Overlays options - top right of 3D_Viewport next to 2 circle icon
  many tools here for customizing what is shown in the 3D_Viewport

edit mesh more overlay options - top right of 3D_Viewport next to square with 4 verts and 1 of those verts white
  can find normals facing direction and many other tools here for customizing what is shown in the 3D_Viewport

ctrl + l -- link menu

p -- split selection into another object -- with faces selected -- choice selection and it will separate your current selection into a different object

with camera selected - video game controls (WASD) (EQ)
  scroll_wheel to affect the speed of movement
    NOTE: key shortcuts at bottom nav bar
  left_click to finalize camera movement and get out
works without a camera selected aswell
shift + ` -- fly_mode  `

remap key since windows uses this key chord
ctrl + atl + ` -- remap for fly_mode `

merge a bunch of vertex pairs -- by distance
1. select all pairs you want to merge
2. M -> Merge by Distance
3. change the distance based on pair distance
NOTE: can work in more complex situations that just pairs

### Selection

ctrl + lmb -- shortest path selection
l -- link select
w -- cycle through common selection tools
  lasso select is one of them

NOTE: doesnt work with numpad preferences set to top numbers -- need to use top bar next to Edit_Mode (3 little icons)

  1 -- vertex select mode

  2 -- edge select mode

  3 -- face select mode

l -- select linked at cursor

f -- fill
  will try to fill the best it can if left ambiguous
    best seen if select 1 edge and press f
sometimes you want this instead:
  ctrl + e -- (fill) bridge edge loop

ctrl+lmb -- select shortest path

in edge selection mode

  alt+lmb -- select edge loop

  ctrl+alt+lmb -- select edge ring

shift+g -- select similar

ctrl++ grow selection
ctrl+- shrink selection

toggle selected object isolated view
/

### Modeling

ctrl+v -- vertex menu
rmb (on model with selected vertrices) -- vertex context menu -- NOTE: subdivide is in there
ctrl+e -- edge menu
ctrl+f -- face menu
alt+e -- extrude menu
alt+n -- normals menu

e -- extrude
ctrl+RMB -- extrude to cursor

f -- fill face / new edge

j -- vertex connect path

p -- separate

m -- merge

y -- split

v -- rip

ctrl+b -- bevel
ctrl+shift+b -- vertex bevel

i -- inset
ii -- inset individual faces

ctrl+r -- loop cut
ctrl+r,scroll_wheel -- loop cut count
gg -- loop / vertex slide

k -- knife

alt+s -- shrink / fatten

shift+ctrl+alt+s -- shear

shift+alt+s -- to sphere

shift+n -- recalculate normals

edge create -- while using subdivision surface modifier
  shift+e

### Scripting

#### where are my logs/prints?
Windows:
Window -> Toggle System Console
Mac: Have to lauch Blender from the terminal
cd "/Users/manyu/Library/Application Support/Steam/steamapps/common/Blender/Blender.app/Contents/MacOS/"; ./Blender;
NOTE: Linux is done similar to Mac

### Sculpting

Viewport_Overlays:
  Statistics -- will show vert count and other metrics

. -- hover over area and view will pane to that area

common brushes:
  grab
    stretch out areas for large shapes
  brush
    inflate and enflate
      for more detailed shapes
  smooth
    average out blocky areas in a big way - relies on remesh voxel size (larger value) to not be overly detailed
    truely smoothing - relies on remesh voxel size (smaller value)
  crease
    high detail
    small size brush is common

when hover over object, you will see little yellow dots -- the closer they are the more to the center of a shape you are

changing brush size/strength/weight
f -- size
shift-f -- strength
ctrl-shift-f -- weight

invert current brush operation
hold ctrl and paint

smooth tool shortcut
hold shift

remesh
ctrl-r

change voxel size of remesh
r

basic shaping techniques:
  1
    brush to remesh to smooth
    brush to pull out or push in details followed by remesh then smooth to even out the shape
  2
    grab brush

isolate to only painting front faces
Brush -> Front Face Only checkbox
  NOTE: xray mode not an option in material preview or rendered modes -- go to solid view instead

invert a mask
ctrl-i

use inflate/deflate brush
i

use grab brush
g

use smooth brush
s

use mask
m

mask modifiers
(top_menu)
Mask -> modifier

for clearing a mask:
alt-m
Mask -> Clear Mask

for smoothing a mask:
Mask -> Smooth mask

mesh filter
applies a uniform value to whole mesh (minus mask) by the Filter Type
drag right = Filter action
drag left = invert Filter action

select/toggle_to diff mesh/object while in sculpt_mode
alt-q -- hover over what you want to select

workflow:
setup for sculpting high_vert_count_model
  join all objects you plan to sculpt on into 1
  in sculpt_mode almost_top_menu: Remesh -> Remesh
    will get rid of internal/overlapping mesh parts
    gives new verts to work with
  Dyntopo:
    Resolution to around 37-42
    Dyntopo means when you sculpt you are creating new verts
  optional: turn on mirroring in brush
converting high_vert_count_model to low_vert_count_model
object_mode
snapping tool
  Face Nearest
make plane mesh
  right_side_menu: Object -> Viewport_Display -> In_Front (checked)

### UVs

NOTE: make sure to apply scale on meshes before hand (vec3(1.0,1.0,1.0))

NOTE: start with a single color texture such as #00000000
  May need to just use Eraser tool on whole texture

NOTE: How to select faces in UVEditor and have those faces select in edit_mode 3D_Viewport (uv sync selection)
UVEditor -> UV Sync Selection (almost_top_menu top left <2 arrows pointing in opposite directions>)
makes finding groups of UVs easier since you can select them in the UVEditor

u -- uv menu
  'Project from View' option is really good

shift + alt + z -- hide overlays (good for seeing textures without a bunch of noise on your model)

export UV map on texture to make easier to see when creating textures in krita:
UV_Editor -> UV -> Export_UV_Layout

Quick and Dirty - best for if you plan to paint straight in blender
NOTE:
  only include meshes you need
  GOOD_ENOUGH_BETTER:
  0 a pass of smart uv unwrap of all faces and place it outside of the texture
  1 a pass where only select the faces that need alot of detail and let them take the most image space
  2 a pass of all faces that need almost no space
  3 a pass of all faces that need mid space
  NOTE for 1-3 steps above: for when scaling smart UV unwraps - you will get overlapping faces if you scale down
    1 scale down
    2 Pack Islands
      uncheck Scale at top
      adjust Margin as needed
    3 can adjust face sizes to make specific faces take more or less texture resolution and then redo 1-2 steps of this subprocess

Tool setting starting points:
  smart UV unwrap -- Object Mode: select all meshes -> Edit_Mode: deselect then select all -> U -> smart UV unwrap
    good starting point:
    Rotation Method: Axis-aligned (Horizontally)
    Margin Method: Scaled
    Margin: 0.002
  Pack Islands
    ensure each island has enough padding around it so that flats dont spill over on different islands
    and ensure you align faces horizontally or vertically
    good starting point:
    Rotation Method: Axis-aligned (Horizontally)
    Margin Method: Scaled
    Margin: 0.002
  Average Islands Scale

Manual seams approach:
1. apply scale
2. project from view (select all faces) - creates a clean slate
3. mark seams
  can help select common seams quickier with:
    Edit_Mode - Edge mode -- almost_top_menu: Select -> Select Sharp Edges
4. unwrap (in UVEditor select all faces; u (unwrap))

#### UV Textures

Shader Editor:
  Image Texture Node setting:
    use Clip instead of Repeat

UVMap.Face -- order extra UVMaps -- UVMap.*
  every mesh on model needs each UVMap you create
    if it isnt used on a particular UVMap then you smart uv unwrap it for that UVMap.*
    move it off of the texture
      if using Clip on Image Texture Nodes then it will make it not use that texture

### Texture painting

shift+x -- color picker -- DONT CLICK just hover over color and release keys

paint through mesh to get flats done quick
texture_paint_mode: with a brush selected: N -> Tool -> Options -> uncheck [Occlude, Backface Culling]
  reduce bleed to 1px or even 0px depending
  Optional: first pass use bleed, then do flats pass with 0px bleed
    -- try without, if get weird results during flats, then try this
hit it with (cam_angles) with a big hard brush and that will get everything

### Rigging

Rigify plugin is a must

Optional: Display wireframe at all times to make matching skeleton to mesh easier with:
  almost_top_menu right side Viewport_Overlays -> Geometry -> Wireframe

Rigify General workflow to setup a rig on a model from start to finish
  for simple human rig use shift+a -> armature -> Rigify Meta-Rigs -> Basic -> Basic Human
  adjust all bones to model
    NOTE: dont forget to use the symmetry X option at almost_top_menu right
  apply transformations to rig -- ctrl+a
  with metarig selected go to right_side_menu Data -> Rigify and lmb Generate Rig
  a new rig with more info will be created
  to auto weight paint - select all parts of your model and then select the new rig
    ctrl-p -> Armature Deform -> With Automatic Weights
  to refine the auto weight paint:
  with the mesh you want to paint selected: enter Weight Paint mode
    NOTE: can use the riggify controls to pose in texture_paint_mode to see if your painting is fixing issues
    Simple toggle between vertex groups visually
      with rig selected right_side_menu Data -> Bone Collections: press star next to Def (will isolate the bones) (NOTE: lmb again to reset to prev state)
      lmb on rig, shift-lmb on model (the current mesh you are painting) go to Weight Paint mode
        bones are now present and represent the vertex groups
        with Move tool: shift-lmb (or just lmb seems to work) a bone to go to that bones vertex group
        OR: alt-lmb
        can rotote non def (non deformation) bones with r-g-s
    General case:
      go through all Vertex Groups and find the bone with the most weight for the mesh and with Weight: 1.00 and Strength: 1.00 and Gradient tool. give all of the weight to said bone
      play with it a little to see if you want to share weight between bones
    NOTE: xray mode not an option in material preview or rendered modes -- go to solid view instead
      OR: if need to see textures (while in solid view) go to almost_top_menu right
        Viewport_Shading menu:
          Lighting: Flat (default: Studio)
          Object Color: Texture (default: Material)
    use the Vertex groups at almost_top_menu center or right_side_menu in Data
      each Vertex group corresponds to a bone
      can arrow through them
    NOTE: dont forget to use the symmetry X option at almost_top_menu right
    N (tool) - properties important
      for low poly models you usually want 0 or 1 painting so set the Brush curve under (Brush Settings -> Falloff menu) to constant (last curve option)
      Brush Settings -> Advanced: Front Faces only checkbox
        NOTE: this toggle and the Falloff Shape under (Brush Settings -> Falloff menu) along with xray mode or not can change how weight painting works
      Options: Auto Normalize -- check it!!! (without it multiple bones can have influences OVER 100% on a model)
        With it checked, if you add weight to 1 bone, it removes it from the other bones proportionally to the amount of weight you added to the new bone
      top level paint modes: almost_top_menu left - [Paint Mask, Vertex Selection] -- leave both off for low poly
      NOTE: painting styles
        To paint through mesh
          weight_paint_mode -> brush tool -> N: tool
            Advanced -> Front Faces Only: off
            Falloff ->
              Falloff shape: Projected
              Front-Face only: off
        else default to:
          weight_paint_mode -> brush tool -> N: tool
            Advanced -> Front Faces Only: on
            Falloff ->
              Falloff shape: Sphere
              Front-Face only: on
  adding new bones to the rig (ex: hair) (useful for secondary motion areas)
    shift-a in edit_mode of rig will create a bone -- place it in the bangs
    create a group for Hair in right_side_menu Data -> Bone Collections
      with the new bone selected - lmb the assign button under Bone Collections
      optional:
        color the new bone: right_side_menu Bone -> Viewport_Display: Bone Color
        rename new bone: select bone and in edit_mode: F2 (hair_front)
    weighting to hair mesh:
      in object mode: lmb hair, then shift-lmb on new bone
        ctrl+p: Armature Deform -> With Empty Groups
        weight paint yourself
  make new bone a child of the proper bone in the existing rig (ex: hair_front child to head bone)
    edit_mode of rig and lmb new bone
    right_side_menu Bone -> Relations -> Parent
      DEF spine 006 (verify from the weight paint mode as to which Vertex group makes sense for your new bone)

Rigify notes:
toggle vis of certain rig groups
  N -> Rig Layers
FK and IK are 2 different right motion types
  by default Rigify basic human rig only has IK enabled

ctrl+tab -- toggle pose and object mode

Bones -- head is chunky part - tail is thin part -- have a hierarchy
(right_side_menu) -- show bone in front of other things -- (on top / render)
Data -> Viewport_Display
  In_Front

ctrl+p -- armature deform (with automatic weights) -- quick weighting
  NOTE: select mesh then bone before this

alt+p clear parent of a bone

a -> alt+r -- reset pose

# Texture Animation

Duplicate/copy a texture hierarchy:
  usually you already have a root texture with some shader editor nodes that you want for the animation texture aswell
  Object Mode: select mesh you want to apply new_texture to
  go to right_side_menu Material and lmb '+' next to current material list
  in dropdown (with circle that is checkerboxed) choose the main texture from the og_texture
  then lmb 'New Material' button (the little copy symbol)
  copy complete

Assign the new_texture to the mesh
  Edit_Mode
    select the faces from the mesh you want to animate
    right_side_menu Material - select the new_texture and lmb 'assign'

Node Wrangler in shader editor
ctrl-t -- when on image_texture node adds texture_coordinate and mapping nodes as input chain

Add bone to a value node for easier editing of value during animation creation by just moving the bone instead of editing the value in the shader editor
  Add new bone to rig
  name 'face_control'
  create new Bone Collection named 'face_controller' -- with bone selected in Edit_mode in right_side_menu -> Data
  select face mesh (mesh with shader editor nodes) in Object Mode
  rmb the value property in the value node
  Add Driver
    NOTE: if you mouse away you can pull back driver details by right clicking the value property and selecting 'Edit Driver'
    Type: Z Location
    Space: Location Space
  right_side_menu -> Data -> Axes - checkbox to true
  on face_control bone: N -> Transform -> Roll: 0
  To change how fast the enum changes values:
    Edit Driver on face mesh:
      Expression: var * 15.0
  To only allow bone to move on z axis (the axis that actually controls the face animation)
    in Pose Mode: select face_control bone: right_side_menu -> Bone Constraints -> (Transform) Limit Location
      check the min and max x and y checkboxes
      Owner: Local Space

# Animation

## with Mixamo and Rokoko

Mixamo is a site owned by Adobe that has animations you can map unto your char

https://www.mixamo.com/#/

Rokoko is a external blender plugin for retargeting animations from 1 rig to another

NOTE: ensure your rig has all transforms applyed (ctrl-a)

## multiple animations

Dope_Sheet (window_type)
  window_type_dropdown: Action Editor

Nonlinear_Animation (window_type)
  can reorg animations
  trigger start and stop editing on animations

### Important settings in .fbx export

Bake Animation -> NLA Strips: check to get Nonlinear_Animation strips
  else just get Action_Editor animations

# Pose

## important tabs
Dope_Sheet
  N has create pose option

Action_Editor -- window_type_dropdown (click the name 'Dope_Sheet' -- its a dropdown and select it)

Asset_Browser
  where poses will be listed
  can toggle current file or all
  the pose_thumbnail is generated by the camera view in your scene
  NOTE: refresh pose_thumbnail by selecting pose_thumbnail -- press N -- click refresh button under Preview section

### Getting an animation from Mixamo

select an animation
need to provide site your model
  select your meshes of the model (not including rig)
  export to .obj
    Include: Selection Only checked
    uncheck Materials
update to site
  make sure your character is t posing face you
download as fbx binary with skin
import fbx into blender
  scale it up, its really small
alt-g to reset position
in pose_mode of the animated rig
  a -- select all
  almost_top_menu: Pose -> Clean Transformation -> All
  now the new rig should line up with current rig

### Mapping Mixamo rig onto your riggify rig

N: Rokoko -> retargeting
Source: Armature (the rig from Mixamo)
Target: rig (your riggify rig)

Click 'Rebuild Bone List'
it will map wrong so clear the mapping by click the 'x' on the left of 'Rebuild Bone List'
default to using fk
  NOTE: can use ik -- but not all fk's have a ik counterpart
  NOTE: IK is easier to control but high chance of running into issues
FK: can import this file to get the common mappings for basic human riggify rigs
  ./animations/fk_mixamo_rokoko_example_mappings.json
TODO: create a json for IK
Auto Scale: uncheck
Use Pose: current
Click Retarget Animation
  if you get crazy stretching then the mappings are wrong
if limbs dont align with Mixamo rig, then you need to change your riggify rig settings to use FK instead of IK for all limbs if using FK (1.0) else invert this (0.0)
  NOTE: to see these controls in N: Tool of pose_mode of your riggify rig
    a -- select all

### Fix Timeline for keyframes of animation
NOTE: you must be in pose_mode of a rig with all bones selected to ensure keyframes show up on Timeline
If keyframes dont show up in Timeline
  insert a new keyframe at the last frame
  while mouse on viewport - press i to insert keyframe
  then delete that new keyframe with 'delete' while mouse in Timline

# Outliner

top level CRUD everything in your .blend file
almost_top_menu (Display Mode) -> Blender File

toggle all open/close
shift

# Reference images
reduce Opacity (right_side_menu)
Data -> Opacity

# getting assets

## reducing vertex counts for performance and storage considerations
to right of 3D_Viewport to the left the contextual_menu there is a series of colored icons
click the Wrench -> Generate -> Decimate -> (will change the contextual_menu) Add Modifier -> Collapse -> Ratio less than 1.0
  Once happy with LOD: Apply changes
    the dropdown arrow in the contextual_menu next to the camera icon
      -> Apply
OR: better
open the Scripting view and paste the content from this script into the text editor:
`./scripts/decimate_selected_meshes.py`
select the meshes you want to reduce the polygon count of
click the Play icon (Run Script) in the Scripting view

## unity

### general keyboard shortcuts of unity
shift+space -- toggle min/max a window

### delete assets on hard disk
have to go to where they are stored on your computer. Unity does not have a built in way to do it

#### windows
~/AppData/Roaming/Unity/Asset\ Store-5.x

### convert to .fbx
To export a Unity asset as an FBX file, you can use the FBX Exporter tool -- install it from:
Window -> Package Manager (Packages: Unity Registry) -- search for it and install it
  then you can right click on assets in the bottom content window and select 'Convert to FBX Prefab Variant...'
    NOTE: you may have to adjust some settings

then just import the .fbx to blender

## unreal engine

### convert to .fbx

you can right click on assets in the bottom content window:
  Asset Actions -> Export... -> select .fbx
  FBX compatibility: 2020
  only checkbox these:
    Mesh:
      Vertex Color
    Static Mesh:
      Export Source Mesh
    Skeletal Mesh:
      Export Morph Targets
  NOTE: if a dropdown - then set to NONE if not specified above

then just import the .fbx to blender


## USEFUL KEYS FOR MODEL CREATION found at https://www.youtube.com/watch?v=DiIoWrOlIRw 

ALT-RMB --- selects connecting pieces based on if your in vertex/face/ or edge select

CTRL- TAB --- SELECTS betw vertex/face/edge select

ALT-S ----- fatten and shrinken tool, gives more natural curves

CTRL-E>edgeslide ----- helps with giving more natural curves
  gg -- seems to be similar or the same
  gg + e -- edge slide even
  gg + e + f -- edge slide even (flipped) -- to match the other edge on the other side

SHIFT-ALT-S (0-1) --- helps round out faces

S-Z-0 --- flattens faces/vertexs,edges out on the Z axis (can be doen with Y and X aswell) in global or local mode

Snapping can be done with the magnet ORR -- Press G to move vertex and then hold CTRL to enable snapping
--------------------------------------------
