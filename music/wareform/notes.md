# Working in App

NOTE: can search keyboard shortcuts in Settings tab

space -- toggle play
fn + <left_arrow> -- back to beginning
l -- toggle looping -- based on beginning and ending market of loops
gain -- to make a track louder or quieter -- in Action Panel to left
volume -- adjust in left_panel or in right sub panel of track_viewport
r -- record

(bottom right of track_viewport)
n -- zoom to fit screen
f5 -- zoom horizontal
f6 -- zoom vertical
up_arrow and down_arrow also zoom

d -- duplicate clip
b -- toggles right panel

select clip by clicking clip header -- select multiple by holding down command
box select -- alt/option + drag
escape -- clears selection

delete clips by selecting and pressing delete

trim clip -- the hollow arrows on both sides of header of a clip
slip -- the full arrows on both sides of header of a clip
fade -- right below trim clip hollow arrows
  left_panel has options to control the tween style (or right click the fade handle)
pitch_fade -- right click the fade handle

reverse a clip -- right click the clip and select reverse -- doesnt work on midi clips. you have to mirror
mirror -- TOOD: takes notes on midi mirroring once you get to midi editing video

complete piece level (dbs) at bottom right

loop tool -- header of clip -- makes hollow arrow for trim clip actually repeat the track instead as you drag it out

name track -- left_panel

## Plugin / Effects (instruments as well)

order matters -- you can drag them to change the order

f -- toggle enabled when plugin is selected -- in left_panel bar aswell

### add Plugin
drag the gray '+' button at the top rightish to your track and select step clip next to the red '+' button

### delete Plugin
select by clicking plugin and press delete

## Loops

i -- set beginning marker
o -- set ending marker
l -- toggle or activate looped playback over the marked -- toggle looping
a -- sets begin and end marker around selected clips

## Click track

top bar Click tab
Click - C -- toggle click sound

tempo of click based on BPM at bottom of app
changing BPM changes the BPM of all tracks so it will slow or speed up things (if auto tempo is enabled)
  auto tempo is good to remember for when you change BPM and want tracks to auto adjust
  in Action Panel to left
  WARN: undo/redo doesnt repect auto tempo for markers

## Snap

top of bar snap
Snap to Grid - Q -- toggles

# Step Sequencing

## use micro sampler -- on a track (multi sampler) -- waveform plugin

### create your custom keyboard sounds mapped to keys

drag another clips with the file tool in the middle of top bar ontop the microsampler
in the microsampler
  right click each clip and quick zone it
    NOTE: you can also manually zone or edit the quick zone in the zones tab

### create the step clip
right click in track and select step clip
  NOTE: OR drag the red '+' button at the top rightish to your track and select step clip
double clip the step clip and fill in the matrix the notes you want and where
adjust velocity of notes by clicking the 'V' at the top left of the step clip

# Exporting
(top_bar) File -> Export

Useful Settings:
Source
  Range: Marked Region -- begin and end markers

Export can be found in right_panel: Files -> Project Files(in square_with_cut_icon)

# right_panel: Files -> Project Files(in square with cut icon)

can bookmark folder (favorite): nav to folder, click square_with_cut_icon, click 'Bookmark current folder'

# Midi

## recording tips
action: merge mode -- will merge recordings together as you progressively build up the track
  to break the piece for a single instrument down into pieces to make easier to play

### quantise -- prior to play (input quantise)
left_panel -- will quantise notes after playing -- can be useful for making drum beats or tight rhythm
  can remove awkward empty space

### quantise -- after the fact
useful for bulk editing notes to do things like fix timing of notes to land on the closest beat
  select the notes you want to do the action on

## Sounds - instrument plugins

### Attracktive -- main waveform / tracktion plugin that has tons of sounds
-- can also get a good deal on first register of waveform for a given email for $10

Boorish Bass: playing a note immediately cuts off the last note

### C major Pro 54

horror/omnious
  Clangorous Bells
sci fi
  PWM Sweep
  LongOctaveBass
  Hammer Lead
retro
  Precussive Organ
  Oboe
  Dumpy 3
heavenly
  Far Away
  Slow Strings

ambient sounds
  Transmitter
  Tune X
  Darkener

horror ambient sounds
  GT5

punching strings
  Plucking with Brass

bomb dropping
  Round and round
  Bombs dropping

bat
  Zwitscher

retro ghosts
  Echo-Repeat

rain
  Rain


# Workflows

chop clip into 2
  position cursor where you want to chop and press '/'
  NOTE: can use actual cursor or white line cursor -- white line cursor is only respected if actual cursor isnt on the clip

merge multiple clips
  select all clips
