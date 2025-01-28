# toggle scroll bars on canvas
ctrl + b

# pane view
<space> + mouse

# convert object to path
Path -> Object to Path

# zoom to 100%
1

# scaling
To scale nodes closer together in Inkscape
Node Tool
select nodes
<shift> + <

To scale nodes apart in Inkscape
Node Tool
select nodes
<shift> + >

# lock aspect ratio when drawing shapes
ctrl
## draw shape from center out 
ctrl + shift

# identify hovered over object in Obect Explorer side bar
hold ctrl + alt and hover over each element
it will reduce opacity of all other objects on the canvas

# deep select the path in the layer and group
<ctrl>+<left_click>

# scale object
lmb -> handle
# rotate object
click object a second time
## hold ctrl key to lock object in 15d increments
## rotate around diff point
move the middle icon out to the point where you want to rotate from
  holding ctrl will allow you to move that point on an axis
### reset the rotate to geometry
click the icon while pressing shift

# duplicate
## while moving object
space

# bottom menu with colors on it
effects fill or stroke of selected objects
NOTE: hold shift to apply to stroke instead of fill
the left most x is for removing fill

# preferences (Edit -> Preferences)
## finding a os/system path for things
System
### import color palette
nav to palette folder and add *.gpl
NOTE: you can use inkscape to convert *.svg to *.gpl

# add path effects
Path -> Path Effects...
  useful for things like bending text (if the text object was converted to a path)

Path and Object top tabs are good for common tasks for modifying objects
  to path for example is often needed

Path top tab
  (all ops work on n objects)
  Union - for joining 2 or more paths into 1 and keep the look the same
  Difference - remove 1 shape from another
  Intersection - only keep the Intersection of 2 shapes


NOTE:
  if stroke or fill color doesnt show. check opacity

Selector Tool (s) (like normal mode in vim) many commands expect you to be in this mode

Node Tool (n)
NOTE: select or deselect nodes outward from currently selected nodes
  hover over a selected node and scroll up or down
    good for proportional editing of a shape
      select move, select more move, select more move...

  selecting adjacent nodes:
    using a mouse with a scroll wheel, you can select nodes in a path in inkscape by:
    Clicking on a node with the path tool.
    Keep the pointer hovered over the node.
    Hold down the control key, and wheel the scroll wheel up. Inkscape will select the next nodes in the path

Pen Tool (b)
NOTE: use 'Create Bspline path' option
  by default it curves lines
  holding shift lets you draw straight lines

Layers and Object tab:
  preview the hovered over path/group/layer
  hover and hold option/alt key

Dropper Tool -  Color Selector (d)

horizontal flip (h)

rotate ([ ])

# Clipping and Masking
https://inkscape-manuals.readthedocs.io/en/latest/clipping-and-masking.html

Select both objects
Object -> Clip -> (inverse or standard)

# Convert raster to svg
Path -> Trace Bitmap
NOTE: its good for generating weighted line art
  the multi colored option is usually better for thie

# Preferences

checkerboard background
File -> Document Properties -> Display
  Checkboard checkbox

# Resources
svg related stuff
https://www.visioncortex.org/
