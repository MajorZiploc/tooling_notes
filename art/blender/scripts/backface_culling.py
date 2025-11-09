import bpy
# import math
import logging
# import time

# NOTE: requires you have all selected_objects set to Shade Auto Smooth
#   this can be done in bulk just by selected all objects and going almost_top_menu Object -> Shade Auto Smooth

logging.basicConfig(level=logging.INFO,
                    format='%(asctime)-15s %(levelname)8s %(name)s %(message)s')
logger = logging.getLogger('blender_id')
logger.setLevel(logging.DEBUG)

def manual_setter(obj):
    obj.active_material.use_backface_culling = True
    obj.active_material.use_backface_culling_shadow = True

def main():
    for obj in bpy.context.selected_objects:
        if obj.type != 'MESH':
            continue
        try:
            bpy.context.view_layer.objects.active = obj
            # time.sleep(0.05)
            # bpy.ops.object.shade_auto_smooth()
            # print(bpy.context.object.name)
            # time.sleep(0.05)
            manual_setter(obj)
            # for mod in bpy.context.object.modifiers:
            #     print(mod.name)
            # NOTE: the following is only setting on the main selected object. how do I set it on all selected objects
            #  even tho the bpy.context.object seems to be set
            # bpy.context.object.modifiers["Smooth by Angle"]["Input_1"] = math.radians(radians)
            logger.info(f"Applied smooth shading by {radians}° to {bpy.context.object.name}")
        except Exception as err:
            logger.error(f"Error applying smooth by angle to {obj.name}: {err}")
            continue

main()

