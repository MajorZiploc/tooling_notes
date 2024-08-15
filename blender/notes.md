# settings

emulate numpad (when you dont have a numpad)

Edit -> Preferences -> Input -> Check Emulate Numpad (top nums will work like numpad)

# workflow

add assets from 1 .blend file to another
File -> Append

# short cuts

shift - space -- view tools

https://www.youtube.com/watch?v=ywVN__LjuyU&list=PLda3VoSoc_TR7X7wfblBGiRz-bvhKpGkS&index=4
	t - toggles left window (tools)
	n - toggles right window (camera lock area)
	ctrl +numpad(1,3,7) goes to back, left, and bottom respectively

Object mode

shift-A (add item)
Ctrl- 0NumPad (change active camera)

Toggle user view
5NumPad or View -> Perspective/Orthographic

From wiki blender book
alt - m = merging.
shift-s or shift-c helps relocate cursor
shift - f = while in cam view, it allows cam to fly, similar to lock cam view
lasso select - ctrl - lmb, to select, ctrl - select - lmb to deselect
ctrl while extruding snaps the moves by a blender unit
When some faces dont subdivide Mesh → Vertices → Remove Double
ctrl - n = recalc the normal direction
edit mode - L - selects all parts linked to the par	t that mouse is hovering over!!!

--simple hat--
ctrl +LMB is used to make generatrix shapes
alt+R is the spin tool
alt + m is the merge tool
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
