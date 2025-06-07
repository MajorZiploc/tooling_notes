# from https://www.youtube.com/watch?v=30aPLDeN2kk&ab_channel=FirebelleyGames around 30:30

# frame rate independant lerp
# NOTE: can change the mod value based on your needs
var mod = -3;
# for _physics_process(delta)
velocity = velocity.lerp(Vector2.ZERO, 1 - exp(mod * get_physics_process_delta_time()))
# for _process(delta)
velocity = velocity.lerp(Vector2.ZERO, 1 - exp(mod * get_process_delta_time()))

