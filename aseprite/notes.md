download links: (not linked to my actual humblebundle account)

https://www.humblebundle.com/downloads?key=dUq2xem2UvbSEZCS

# Download Palettes

NOTE: an easy way to find out where Aseprite is reading palettes from is to just attempt to import a palette. the default location the file explorer opens to is where the palette needs to go
  Palettes Section -> Presents -> Open Folder
NOTE: should work for png files
  apollo-1x.png should be usable in the same way

## macos downloaded directly (managed through /Applications)
cp /Users/manyu/projects/tooling_notes/aseprite/palettes/apollo.gpl /Applications/Aseprite.app/Contents/Resources/data/palettes/

## macos downloaded through steam
cp ~/Downloads/apollo.gpl "/Users/manyu/Library/Application Support/Steam/steamapps/common/Aseprite/Aseprite.app/Contents/Resources/data/palettes"
cp /Users/manyu/projects/tooling_notes/aseprite/palettes/apollo.gpl "/Users/manyu/Library/Application Support/Steam/steamapps/common/Aseprite/Aseprite.app/Contents/Resources/data/palettes"

# Copy over keyboard shortcuts (import process is wonky sometimes. sometimes need the .aseprite or the .aseprite-keys file. sometimes the built in importer works. sometimes you need to do some file copy stuff mentioned below)

## macos downloaded directly (managed through /Applications)
cp ./keyboard_shortcuts.aseprite /Applications/Aseprite.app/Contents/Resources/data/widgets

## macos downloaded through steam
cp ./keyboard_shortcuts.aseprite "/Users/manyu/Library/Application Support/Steam/steamapps/common/Aseprite/Aseprite.app/Contents/Resources/data/widgets"

# General Notes
select layer a pixel is on (with 'Auto Select Layer' checkbox on) :
  v 

when in shading mode with colors selected
  reverse shade:
  x
  color selection process (while in shading mode):
    dragging for adjacent colors
    shift click each color for non adjacent colors

eye dropper
  alt/option
  OR
  i

fill (paint bucket):
  G
  NOTE: Contiouous option can be useful

## Palette Colors
cycle back and forth  (previous/next)
go to previous color
[
go to next color
]

## Selection (also for Rotation and Scale)

magic wand:
  W
  NOTE: Contiouous option can be useful

rectangle:
  M

lasso
  Q

## Measure object sizes in canvas
done manually by counting the background_blocks for height and width
background_blocks are 16x16 by default
background_blocks size can be changed in Preferences -> Background

Replace Color (<shift>+r)

Outline (<shift>+o)

## Making drop shadows
can use Outline tool
do twice:
  dont use the presents
  Outside style
  bottom right dot

## Move multiple layers at once
NOTE: it will NOT look like its moving all the layers until you press esc after the move is done

1. Make a selection around the area where all the layer content exists
2. shift select all layers in the layers panel
3. move (NOT with V) the layers
4. press esc


## Outline whole animation
can use Outline tool
  Click 'Selected' to change to 'All'

Export
File -> Export
  Output File (right size ...) for adv mode. File format is here
  Resize
    200-800% for sharing
    100% for game asset
  Layers
OR
Export Sprite Sheet (<ctrl>+e) For converting an animation to a sprite sheet

color adjustments:
  Edit -> Adjustments -> (anything) ex: Brightness/Contrast

toggle views of the app (remove side bars and such or add them back)
<ctrl>+f

toggle timeline/layers
<tab>

toggle snapping mode
<shift>+s

tile mode (good for working on parallax landscapes)
duplicates canvas across x or y axis

change canvas size (c)
Sprite -> Canvas Size...

operations work on all selected elements
  examples:
    select all frames in an animation
      change a color in 1, it changes in all
    select a range of colors in your palette
      change the brightness, changes all

