# resources
https://cgcookie.com/account/orders
https://blendermarket.com/

### textures and other 3d assets
https://polyhaven.com/

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

emulate numpad (when you dont have a numpad)
  Edit -> Preferences -> Input -> Check Emulate Numpad (top nums will work like numpad)

emulate 3 button mouse (Emulate middle mouse button) (when you dont have a mouse)
Edit -> Preferences -> Input -> Check Emulate 3 Button Mouse (alt+lmb)

^ undo stack
Edit -> Preferences -> System -> Memory & Limits -> Undo Steps: 256

Plugins -- (load your plugins from blendermarket place or where ever):
Edit -> Preferences -> Add-ons
  top right dropdown arrow -- Install from Disk...

# workflow

add assets from 1 .blend file to another
File -> Append

# short cuts

## High level control

General window toggles
  top left below x2 the blender icon. you will see a grid with a ball on it
  click it and you will see a bunch of editors and diff views
  NOTE: the 'Info' option under 'Scripting' is for app logs

shift + space -- view tools

` -- view all nav tools (View pie menu) `

. -- Pivot point menu

z -- render types like wire and solid meshes
  shift-z -- toggle back and forth between last 2 choices

tab -- toggle edit and object mode

t -- toggles left window (tools)

n -- toggles right window (camera lock area) (properties)

ctrl +numpad(1,3,7) goes to back, left, and bottom respectively

search menu (like ctrl-p in vscode)
F3

home -- show all objects in view

Toggle user view
5NumPad or View -> Perspective/Orthographic

# 3D Viewport

shift + 2finger_swipe -- pane

standard 2 finger pitching -- zoom

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
    OR to apply specific transformation: (almost top menu) Object -> Apply -> Choose: (scale, location, rotation, etc...)
  o -- proportional editing
    scroll wheel -- change area of influence

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

## more advanced

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
alt + p -- clear parent

F2 -- rename
ctrl+F2 -- batch rename

m -- move to collection

ctrl + (1-5) -- add subdivision surface modifier

## 3D Viewport -- Edit Mode

### Selection

NOTE: doesnt work with numpad preferences set to top numbers -- need to use top bar next to Edit Mode (3 little icons)

  1 -- vertex select mode

  2 -- edge select mode

  3 -- face select mode

l -- select linked at cursor

f -- fill
  will try to fill the best it can if left ambiguous
    best seen if select 1 edge and press f

ctrl+lmb -- select shortest path

atl+lmb -- select edge loop

ctrl+atl+lmb -- select edge ring

shift+g -- select similar

ctrl++ grow selection
ctrl+- shrink selection

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

# getting assets

## reducing vertex counts for performance and storage considerations
to right of 3D Viewport to the left the contextual_menu there is a series of colored icons
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








---------- TODO: vent the rest of this


# Object mode

ctrl while extruding snaps the moves by a blender unit

When some faces dont subdivide Mesh → Vertices → Remove Double

ctrl - n = recalc the normal direction

edit mode - L - selects all parts linked to the par	t that mouse is hovering over!!!

F6 brings up last done thing

normals in mesh in edit mode can be used to trouble shoot

-- putting hat on person
changing origin (med pt) of an object found in obj mode in tools section under edit, “origin” 
	Quick key is shift - ctrl - alt - c
---- parenting the hat to the person
parent and child relation is sometimes better than joining the objs into one
	ctrl -p in obj mode after all obj are selected (The last selected will be the parent)
troubling shooting loop to parents. Alt + p to clear all previous parents
you can chain parent-child. ex. Parent 1 - child1. Child1 can become Parent2 if paired with a Child2
	

---- mat and text
 Quite often, you will want to duplicate or move a colour specified in one place to another. If the two colour swatches are simultaneously visible, you can use the eyedropper button in the colour picker. But if they are not, then the easiest way is to bring up the colour picker for the colour you want to copy, switch to the hex display, select the 6 hex digits, and copy them with  CTRL + C . Then go to the colour you want to make the same, bring up its picker in hex mode, select the hex digits, and replace them with what you copied using  CTRL + V .

---- image text
the world tab (near the render cam) has an environment lighting tab inside for even lighting


penguin -----
ctrl - num+
ctrl - tab - edit mode --- switch between vertices, face, and edges select


Mountains out of molehills
w - edit mode - special tools
o - toggle proportional edit
space - access cool commands
shift -Okey = falloff type for proportional edit

SHIft - f = game like camera movement

alt - right click ---- makes making faces wayyyyyyy ezer for larger numbers of faces,verts, and edges




https://www.youtube.com/watch?v=AMBi1R7KB48
Ctrl + downarrow ---- full screens anything that mouse is in (toggles on and off with same buttons)
Talks about joining windows aswell.


Animation
I - used for setting key frames. usually use LocRotScale

Joining and separating objects
ctrl - j --- do this after all objects are selected to join objects
p --- separated selected piece of object from the rest
L ---- selects island. can help if two objects overlap, when trying to separate


Generatrix
	CTRL - LMB

https://www.youtube.com/watch?v=wxCy4tOrCqw 
Alt - P -- select a face and then alt - p and the face will be divided to a point
Alt - D -- select a vertice and it will create a new vertice to slide down

CUSTOM ORIENTATION
	CTRL-ALT-SPACE


Shift-B ---- while in camera view, allows you to render a small section of total render (Shift-B is used to clean up after)


More Precise Grab, Rotate, and Scale === G/R/S then hold Shift

Clean up Fire Flys in renders -- Cycles Render -- Render Tab -- Light Paths -- Turn off Caustics

Shift + LMB === when on top right handle of a view will pop it out into a new window.



USEFUL KEYS FOR MODEL CREATION found at https://www.youtube.com/watch?v=DiIoWrOlIRw 

ALT-RMB --- selects connecting pieces based on if your in vertex/face/ or edge select

CTRL- TAB --- SELECTS betw vertex/face/edge select

ALT-S ----- fatten and shrinken tool, gives more natural curves

CTRL-E>edgeslide ----- helps with giving more natural curves

SHIFT-ALT-S (0-1) --- helps round out faces

S-Z-0 --- flattens faces/vertexs,edges out on the Z axis (can be doen with Y and X aswell) in global or local mode

Snapping can be done with the magnet ORR -- Press G to move vertex and then hold CTRL to enable snapping
--------------------------------------------
