particles of chunk size: (64 amd) or (128 nvidia) per compute unit
  if not using full chunk, the rest of the gpu compute unit isnt doing any work
  from: https://www.reddit.com/r/godot/comments/1dknbcn/cpu_vs_gpu_particles_2d_cpu_wins_at_least_for_my/
    full comment:

You're spot on with base cost. I'm pretty sure this is also influenced with how a GPU works in general.

GPUs have shader units and compute units. One compute unit usually controls 64 (on AMD) or 128 (on recent nVidia) shader units. Think of a shader unit as a slightly more sophisticated ALU and a compute unit as an actual "core".

Simplified, each compute unit can only run a single program (shader code) but it can govern to run that program with (lets take the nVidia example) 128 different data sets or stacks. Now, if you run a particle sim on that with only 5 particles, then only 5 shader units have actual data to work with. The other 123 that the compute unit controls do nothing and just idle. (Remember, only one program for all of those 128 units). If you run the same sim with 100 particles per system you will still have the exact same execution speed but only 28 units will be without data to work on. This can explain why you did see basically no difference between 5 and 100 particles per system on your GPU test.

Ofc, a GPU has multiple compute units so you could theoretically still run multiple particle systems in parallel on those. Sure that will be faster than the CPU? Theoretically yes but practically you always need to keep in mind that loading small tiny programs in the hundreds on your GPU and have them all run in parallel comes with other overhead such as cache latency and sizes, memory bottlenecks, job setup cost. And as you said, the general base cost. Also the cost for the drawcall, so on so on.

nVidia and AMD offer some really cool frame analyzer tools that help you look into what your GPU is actually doing during a frame. Godot does not have these facilities built in and tbh, the manufacturers tools do a really good job already, it makes sense to just use those. You can see and observe memory, cache and other bottlenecks there. If you really want to dig into it I'd recommend you give them a shot:

nVidia: https://developer.nvidia.com/nsight-graphics

AMD: https://gpuopen.com/rgp/

Intel also has something similar

Okay, so a lot of text. Lets talk about godot 4.3:

In 4.2 the way the engine parallelized work on the GPU was kinda garbage. There were a lot of blockers that would cause many things that could run in parallel not to run in parallel. 4.3 uses a new method to organize and sort out work on the GPU for better parallelization. The blogpost says this: "GPU particle systems will get massive improvements". It almost sounds like they had issues with that in particular. Here is the blogpost, it's a long and a bit dry read but interesting if you feel like digging: https://godotengine.org/article/rendering-acyclic-graph/

Also, make a copy of your project, load it up with 4.3 beta 2 and see what happened to your framerate with GPU particles.

I would love to know as well, so if you do, please come back and report :)


