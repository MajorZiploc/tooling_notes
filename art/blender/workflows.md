## generic workflow tips:

spliting a the view into 2 parts that are the same view type can be useful if you need multiple angles of viewing something
example: 2 3D view ports
  1 top and 1 front view
  can be easier to make edits this way
    Ex: selecting an edge in top and moving in front

adding objects while in edit_mode rather than object mode to auto 'join' the objects into 1 object can be much more convenient during modeling/edit_mode changes

Mirror modifier:
use clipping: on
  this will make sure you dont have verts cross over the mirror line
Mirror modifier goes by object origin by default unless using Mirror Object
  best to use a special object: Empty -> Plain Axes
    for your Mirror Object
    decouples need for origin of object to be set for the mirror modifier

fix curve of plane
1. make a generic_circle mesh and tweak it to your shape
2. turn on face or vertex snapping modes
3. only have the generic_circle and the plane visible
4. select vertices of the plan and tap g and it will snap to the circle

remove dupped verts quickly
1. select all verts
2. m -> By Distance
3. usually around 0.001m distance for merge setting

getting a vert
any mesh:
  edit_mode -> a (select all verts) -> m (merge at center)

better rendering for detailed meshes
  Viewport_Shading -> Options
    Cavity: checked

better bevels
  Meter Outer: Arc
  NOTE: can use on the bevel modifier aswell

alt for Orthographic views
  instead of depending on emulate 3 button mouse
  if you rotate while hold alt, it will snap into the various views

Checking number of samples needed for a render
  set samples to 0 (unlimited samples) and render and it will give you an estimate on how many samples you need
    referred to as Path Tracing Samples
  side_settings Render: Samples -> Viewport: 0
  almost_top_menu: Viewport_Shading -> Rendered
    should trigger rending for to show Path Tracing Samples
      if not, google how to render

Lights to Target
select all lights
shift-t -- cursor to where you want lights to point

fix messed up geometry -- can reform mesh to look more like rest of mesh -- can retopo your mesh
edit_mode: almost_top_menu: Face -> Grid Fill

remove side_settings tabs -- visible tabs
top right of side_settings dropdown


align object to a surface
enable basepoint snapping
object_mode: g (while moving object) -> b

reduce geometry on mesh
side_settings: Data -> Remesh
Mode: Quad
Click QuadriFlow Remesh
tweak settings as needed

cut hole in an object
sculpt_mode:
  left_side: Box Trim
cant find this one: -- seems to not work in 4.5+ -- was an add on
  object_mode: left_side: carve tools icon
  array is good for holes that need to be even in spacing
  https://extensions.blender.org/add-ons/carver/

slow blender on big sceens:
change OpenGL to Vulkan
Preferences -> System -> Display Graphics
  Backend: Vulkan

slow blender on big sceens:
side_settings: Render -> Simplify
  adjust settings as needed

slow render can be sped up by limiting to a specific region that needs to be rendered rather than rendering everything
3D_Viewport: ctrl-b -- box select a region
3D_Viewport: ctrl-alt-b to clear region

select collection via an item in the collection in 3D view port -- select by other relations aswell
object_mode: select item in viewport
shift-g -- choose Collection

reduce file sizes by purging unused data
File -> Clean Up -> Purge Unused Data...
  will delete unused textures aswell
  if you want to keep things like this - you need to set them to fake user to prevent them from being deleted
    (shield icon button)
      for textures: object_mode: with mesh selected
        side_settings: Material
          select a material and click the shield

NOTE: setting seems to not be there or moved in newer blenders
global material for easy single color on all meshes
side_settings: View Layer -> Override
  Material Override

see and control an objects animation path
object_mode: select keyframed object
side_settings: Object -> Motion Paths
  Calculate... (or its called Update Path if already Calcuated before)

how to tell what light does what
object_mode almost_top_menu: Viewport_Overlays -> Object -> enable Light colors

get 4 views of 3D_Viewport (toggles on and off)
ctrl-alt-q

free plugins
extensions.blender.org

multi camera angle in single animation
Timeline
create marker: m
select camera you want to link to the marker
Timeline: press ctrl-b -- to link to the marker

easier edits to inputs on materials with nodes
Shader_Editor: select material nodes
press ctrl-g -- groups them
should see a Group Input node
connect any input you want access to in the side_settings Material tab to the Group Input

using presents
if a tool has the mixer bars icon at the top left of it -- means it has presents
can also save your own presents here

remove noise from animated renders
side_settings: Render -> Advanced
  Seed
    enable Use Animated Seed (clock icon)

avoid redoing UV unwrap when editing mesh after have a textures and UV unwrap already done -- UVs will auto correct with any changes you make
Edit_Mode: N: Tool -> Options -> Transform
  enable Correct Face Attribute

see affect of adding/removing seems on the UVs instanting (live unwrap) -- removes need to manually unwrap after every change that you make
Edit_Mode: N: Tool -> Options -> UVs
  enable Live Unwrap

N: Tool can also be accessed on the side_settings with wrench and tool icon

quick particles and effects
object_mode: almost_top_menu Object -> Quick Effects

change Temperature of a light
side_settings: Data -> Light
  enable Temperature -- the Color Temperature Scale will change the color of a light

selective edge beveling with bevel modifier
Bevel Modifier -> Limit Method: Weight
edit_mode: select all edges you want to have a bevel
edit_mode: N -> Item -> Edge Data -> Bevel Weight: 1

build complex cylindrical shapes (like a chess piece or piece of pottery)
add a curve in front view and build a shape
add a screw modifier and change the axis to what you need
now can change the curve and quickly get different shapes

math and coding works in value fields
can do formulas like 0 + (cos(frame / 8) * 4)
`#frame (frame count or index) is a good value for when doing animations`
code functions are called drivers

Tissue - easy way to copy a pattern (1 mesh) across faces of another mesh -- tessellate
can even limit what faces by selecting the faces in edit mode and then tessellate
https://extensions.blender.org/add-ons/tissue/

stick an object perfecting to another object -- lattice
object_a = object you want to attach to object_b
1. shift-a -> Lattice
2. scale the lattice object to be slightly bigger than object_a
3. with Lattice object selected: side_settings -> Data
  specify the resolution that you need -- points of attachment to object_b
4. select object_a then the Lattice -- ctrl-p to parent -- Object (Keep Transform)
5. select object_a add Lattice modifier -- set the Lattice as the target
6. add shrinkwrap modifier to the Lattice -- set object_b as the target
7. play with shrinkwrap: Wrap Method to see what works best for your usecase
NOTE: snapping techniques can also achieve this
NOTE: shrinkwrap modifier can also work in some cases for this

create stairs pattern with bevel
make then cube and select the edge you want stairs on
ctrl-b and confirm
open Bevel context menu
  Width Type: Depth
  Profile Type: Custom
    Use Steps Preset
  increase Segments until you get the stairs you want
  change Width as needed
need more steps?
  increase Segments and reset the Preset to Default then Stairs

for creating holes
  https://extensions.blender.org/add-ons/looptools/
  in short:
    edit_mode: select faces; rmb: LoopTools -> [Bridge, Circle]
  boolean modifer is ok aswell but can create bad geometry
