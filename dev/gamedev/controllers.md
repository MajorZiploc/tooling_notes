# NYXI Hyperion 2

## remap programable buttons on back

the back buttons are called ML (left) and MR (right).

To remap one:

Hold T + ML (or T + MR) for about 3 seconds.
The RGB light should turn green, indicating programming mode.
Press the button(s) you want the back button to perform.
Press ML or MR again to save and exit programming mode.

To clear a mapping:

Hold T + ML/MR for about 3 seconds to enter programming mode.
Press ML/MR once without entering any buttons.
The mapping is cleared.

A couple of things to know:

ML can only be assigned left-controller functions (D-pad, L, ZL, L3, etc.).
MR can only be assigned right-controller functions (A, B, X, Y, R, ZR, R3, etc.). You can't map A to ML or L3 to MR directly.

# 8BitDo
## remap programable buttons on back and top
BELOW IS A CHATGPT THREAD ON HOW TO DO IT FOR THE MOBILE AND STANDARD CONTROLLER

The 8BitDo Ultimate 2 Bluetooth Controller has four extra buttons:

L4/R4 – the small buttons next to the bumpers on top.
P1/P2 – the two back buttons (paddles).

All four can be remapped through 8BitDo Ultimate Software V2.

On Windows
Connect the controller via USB or the 2.4 GHz dongle.
Bluetooth mode does not allow configuration from the Windows software.
Open 8BitDo Ultimate Software V2.
Select one of the three controller profiles.
Go to Mapping.
Click the button you want to change (L4, R4, P1, or P2).
Choose:
Another controller button (A, B, X, Y, L3, R3, D-pad, etc.)
A macro
Disable (Null), if desired
Click Apply or Sync to save it to the controller.
What you can remap them to

You can map them to:

✅ Face buttons
✅ D-pad
✅ Bumpers/triggers
✅ Stick clicks (L3/R3)
✅ Macros
✅ Null (disabled)
What you can't do

The extra buttons are not independent inputs in XInput mode. They can only duplicate another controller button or execute a macro. They cannot directly become keyboard keys or show up as unique buttons in most PC games.

If you're using Steam

If you want the extra buttons to behave as separate buttons that Steam Input can bind independently:

Update the controller to the latest firmware.
Turn the controller on in DirectInput mode by holding B while powering it on.
Enable Steam Input for the controller.

In DirectInput mode, newer firmware allows Steam to detect the extra buttons separately, though game support varies.

If your goal is to use the top buttons for something specific (for example, R4 = Right Stick Click, L4 = Tab, P1 = Shift, etc.), let me know what game or application you're using, and I can suggest the best mapping.

what about the 8BitDo Ultimate Mobile Gaming Bluetooth Controller?

Yes, and it's actually a bit different from the Ultimate 2 Bluetooth controller.

The 8BitDo Ultimate Mobile Gaming Bluetooth Controller has:

2 Pro back paddle buttons (P1/P2)
No extra L4/R4 shoulder buttons like the Ultimate 2 Bluetooth.
Remapping

The back paddles are configurable through 8BitDo Ultimate Software V2 on Android or iOS.

You can customize:

Button mapping
Stick sensitivity
Trigger sensitivity
Turbo
Controller profiles

The paddles can be assigned to duplicate standard controller inputs such as:

A/B/X/Y
D-pad directions
L1/R1
L2/R2
L3/R3
Other standard gamepad buttons
Can they be independent buttons?

No.

Like the other Ultimate controllers, the P1/P2 paddles are not exposed as separate Bluetooth buttons. They act as remapped copies of existing controller inputs. The controller does not advertise additional HID buttons for apps or games to bind directly.

Can they send keyboard keys?

Also no, at least through the official software.

You cannot assign:

Keyboard keys
Mouse buttons
Android system actions
Custom HID buttons

They are limited to controller button functions (and turbo/macros where supported).

If you're buying it for GameHub/Winlator/Steam Link

If your goal is to have extra independent inputs (for example, mapping the back buttons to keyboard keys like F1, Shift, Ctrl, etc.), the Ultimate Mobile controller won't do that by itself.

For true independent rear buttons, you'd want a controller that exposes them separately, such as:

Flydigi Vader 4 Pro
GameSir G8 Plus (with software support)
Some Xbox Elite-compatible solutions on PC

Since I remember you're planning to use GameHub to stream and play Steam games on Android, I can also recommend which mobile controllers actually provide the most flexible remapping for that specific setup.
