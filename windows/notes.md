# Disable animations

Useful for removing things like the slow switch desktops animations

Settings -> Accessibility -> Visual effects
Animation: Off

# Power settings

Settings -> System -> Power & battery
  Power Mode:
    Plugged in: Best Performance
    On battery: Best Power Efficiency

# Desktops:

## Nav - back and forth desktops

<super>+<ctrl>+<(left|right)_arrow>

## Desktop control panel
<super>+<tab>

# Magnifier
more fine grain Magnifier steps
by default it steps by 100% which is insanely high
Accessibility -> Magnifier or (win+ctrl+m)
Zoom increment to 5%

# SLEEP ISSUE:
  SHORT:  always unplug on laptop before closing the lid

  EXPLANATION:
  windows moved away from s3 sleep. its on s0 network (connected|disconnected) sleep.

  means your cpu can be on when your laptop is sleeping.

  there are alot of work arounds for this but some unsafe becuz intel gen12 processors dont support s3 sleep now.

  if laptop is connected to power and you close the lid, it enters s0 network connected sleep
  if laptop is disconnected from power and you close the lid, it enters s0 network disconnected sleep
  if laptop is connected to power and you close the lid and then you unplug the laptop, it enters s0 network connected sleep

# Hanging processes holding on to file or folder:

## use handle to find out what is using it
handle.exe ./<file_or_folder>

## kill the task
taskkill /PID pid_number /F

# developer settings

Settings -> System -> For developers

  Enable Developer Mode

  Enable all File Explorer options

  Enable all Powershell options

  Enable sudo option
    adds sudo command

# Autohide Taskbar not working

Task Manager -> Tasks
Restart 'Windows Explorer' background task

# Dealing with Performance issues

chat gdp log of godot specific question: https://chatgpt.com/share/690ccd07-a334-8002-ac03-ea20f0f2862a

question: godot 4.5 is 100 times slower on my mid range 2025 gaming windows laptop than on my 2021 m1 macbook pro how do i speed it up on my windows laptop?

answer:

Yeah — that’s a known pain point. Godot 4.x (especially with Vulkan) can run dramatically slower on some Windows setups compared to macOS, even on much stronger hardware. Let’s go through the most common and effective ways to fix that, especially for mid-range Windows gaming laptops:

🧩 1. Force Dedicated GPU (not the iGPU)

Godot may be running on your integrated GPU (Intel or AMD APU) instead of the discrete GPU (NVIDIA/AMD).

🔧 How to fix:

NVIDIA:

Open NVIDIA Control Panel → Manage 3D settings → Program Settings tab.

Add godot.exe.

Set “Preferred graphics processor” to High-performance NVIDIA processor.

AMD:

Open AMD Software: Adrenalin Edition → Settings (⚙️) → Graphics → Advanced Settings.

Under “GPU Workload,” ensure Godot is set to run on High performance GPU.

Windows 11 built-in way:

Go to Settings → System → Display → Graphics → Browse for godot.exe.

Choose High performance GPU.

✅ This alone can easily make Godot 10–100× faster.

⚙️ 2. Switch the Rendering Driver

Godot 4.5 defaults to Vulkan, which can perform poorly on some Windows GPU drivers.

Try switching to OpenGL or Forward+ renderers.

How:

In the Project → Project Settings → Rendering → Rendering Method:

Try Forward+ (fastest on discrete GPUs).

Or Compatibility (OpenGL) if Vulkan drivers are bad.

You can also launch Godot via CLI:

godot.exe --rendering-driver opengl3

🧱 3. Disable Debug Overheads

In the Editor, the debug build can kill FPS:

When running a scene, click the dropdown beside ▶️ and select:

“Run in Release Mode” (instead of Debug).

Or export a temporary “Release” build to benchmark real performance.

💡 4. Check for Background GPU Load

If you have:

OBS, Discord overlays, or browsers with hardware acceleration active → they can slow GPU pipelines.

Try closing those or disabling hardware acceleration in browsers.

🔋 5. Laptop Power Settings (NOTE: if using a low watt charger, the laptop might consider itself to be on battery rather than on charger. so change both settings to Best Performance!)

Windows loves to throttle under “Balanced” or “Power Saver.”

Go to Control Panel → Power Options → High Performance.

Or in Windows 11: Settings → Power & Battery → Power mode → Best Performance.

Then restart Godot.

🧰 6. Update GPU Drivers

Download directly from NVIDIA/AMD, not Windows Update.
Make sure Vulkan runtime is included (comes with the driver).

NVIDIA Driver Downloads

AMD Drivers

📊 7. Check VSync

Sometimes VSync causes stutter or frame-time issues:

In Project Settings → Display → Window → VSync Mode, try Disabled or Mailbox.

🧼 8. Reduce Editor GPU Load

In the Editor Settings → Interface → Editor → Low-Processor Mode → try enabling it.
Also disable Smooth Lines and High-DPI Scaling if not needed.

🧠 9. Compare Vulkan Versions

Some Vulkan layers conflict:
Run:

vulkaninfo | find "driver"


If you see “Microsoft” drivers, that’s software fallback. You need the GPU vendor’s Vulkan runtime.

🔬 10. Check Resource Intensive Shaders

If you’re testing shaders (e.g., ASCII effect, glitch shaders, etc.), some effects are fragment-bound — Macs can handle them with tile-based GPUs better than discrete GPUs with bandwidth bottlenecks. Try lowering:

Render resolution (viewport scaling)

Number of passes

Texture size

⚡ Quick sanity check

Try running the Godot “3D Platformer” demo or your own scene:

On macOS M1, note FPS.

On Windows, note FPS after forcing GPU and setting Forward+.

If FPS jumps from <10 to 60+, you’ve fixed it.

If you share:

Your GPU model (e.g., RTX 3060 laptop, RX 6600M, etc.)

Whether it’s Intel/NVIDIA/AMD

And whether you’re testing in Editor viewport or running a scene

I can pinpoint exactly what’s causing the 100× slowdown and suggest the best renderer/preset for your system.
