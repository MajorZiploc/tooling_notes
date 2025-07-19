download:
check_personal_files
https://www.humblebundle.com/downloads?key=dUq2xem2UvbSEZCS

# Settings

## Background

Defaults
  Colors: #808080 #c7cfcc
Preferred
  Colors: #6f6f6f #515151

# Download Palettes

NOTE: an easy way to find out where Aseprite is reading palettes from is to just attempt to import a palette. the default location the file explorer opens to is where the palette needs to go
  Palettes Section -> Presents -> Open Folder
NOTE: should work for png files
  apollo-1x.png should be usable in the same way

## macos downloaded directly (managed through /Applications)
cp ~/projects/tooling_notes/aseprite/palettes/*.gpl /Applications/Aseprite.app/Contents/Resources/data/palettes/

## macos downloaded through steam
cp ~/projects/tooling_notes/aseprite/palettes/*.gpl "$HOME/Library/Application Support/Steam/steamapps/common/Aseprite/Aseprite.app/Contents/Resources/data/palettes"
cp ~/projects/tooling_notes/aseprite/palettes/*.gpl "$HOME/Library/Application Support/Steam/steamapps/common/Aseprite/Aseprite.app/Contents/Resources/data/palettes"

# Copy over keyboard shortcuts (import process is wonky sometimes. sometimes need the .aseprite or the .aseprite-keys file. sometimes the built in importer works. sometimes you need to do some file copy stuff mentioned below)

## macos downloaded directly (managed through /Applications)
cp ./keyboard_shortcuts.aseprite /Applications/Aseprite.app/Contents/Resources/data/widgets

## macos downloaded through steam
cp ./keyboard_shortcuts.aseprite "/Users/manyu/Library/Application Support/Steam/steamapps/common/Aseprite/Aseprite.app/Contents/Resources/data/widgets"

# Scripts

potential locations:
"$HOME/Library/Application Support/Aseprite/scripts"


# General Notes
select layer a pixel is on (with 'Auto Select Layer' checkbox on) :
  v 

layers tab - show selected layer only
on the eyeball:
<alt>+<click>

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

if color palette is focused, you can zoom in and out of it

## Selection (also for Rotation and Scale)

magic wand:
  W
  NOTE: Contiouous option can be useful
  NOTE: selecting everything without brush strokes on it is a good strategy to ensure you dont paint over things and only paint on unpainted areas
    good for pairing with 'Brush out of selection' tip

### Brush out of selection (useful for making tilesets)
1. make a selection
2. press b
3. press <ctrl-b>
With contextual option: 'Paint aligned to source' selected

rectangle:
  M
  double clicking a block will select the block
    good for creating tilesets

lasso
  Q

### Deselecting small pieces of an already selected area
  contextual tool option: 'Subtract from selection'

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

## Animations

### timeline
go next frame
.
go prev frame
,

## Move multiple layers at once

1 press v to get into move tool
2 shift select layers in layers tab
3 left click and hold any visible content from any of the select areas and drag

OR

NOTE: it will NOT look like its moving all the layers until you press esc after the move is done

1. Make a selection around the area where all the layer content exists
2. shift select all layers in the layers panel
3. move (NOT with V) the layers
4. press esc

## Convert any image or layers to the current color palette
Sprite -> Color Mode -> Indexed

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

# good background size for desktop wallpaper style
800px width * 540px height

# submit/upload works at:
https://lospec.com/gallery/submit
https://www.deviantart.com/submit/

# convert image to fuse bead art
https://www.pixel-beads.net/

# sprite sizes

characters
6-7 blocks (96x96 to 112x112 pixels)
  should look into reducing the size

# References
## Games
Wizard of Legend
  good for really small characters that have really good animations and look

# Tags

pixel_art pixel_artwork pixelart girl cape black red brown boots gloves spear adventurer

pixel_art pixel_artwork pixelart girl brown fight gloves boots

pixel_art pixel_artwork pixelart girl brown fight punch

pixel_art pixel_artwork pixelart girl flag horse charge green gray red

pixel_art pixel_artwork pixelart girl field horizon red yellow brown

pixel_art pixel_artwork pixelart girl robe black purple floating

pixel_art pixel_artwork pixelart girl falling rooftop clouds building

pixel_art pixel_artwork pixelart girl cape black red brown boots bow adventurer readied archer

pixel_art pixel_artwork pixelart girl black white maid bag
