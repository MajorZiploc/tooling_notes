import bpy
# import math
import logging
# import time

# NOTE: requires you have all selected_objects set to Shade Auto Smooth
#   this can be done in bulk just by selected all objects and going almost_top_menu Object -> Shade Auto Smooth

radians = 15

logging.basicConfig(level=logging.INFO,
                    format='%(asctime)-15s %(levelname)8s %(name)s %(message)s')
logger = logging.getLogger('blender_id')
logger.setLevel(logging.DEBUG)

def manual_setter(obj, angleDegrees):
    if "Smooth by Angle" in obj.modifiers:
        obj.modifiers["Smooth by Angle"].__setitem__("Input_1",angleDegrees*0.0174533)
        # TODO: make this set actually work
        obj.modifiers["Smooth by Angle"]["Ignore Sharpness"] = True
        # NOTE: FOR HAIR
        # obj.modifiers["Smooth by Angle"].node_group.nodes["Set Shade Smooth.001"].domain = 'FACE'
    else:
        foo=bpy.context.temp_override(active_object= obj)
        foo.__enter__()
        bpy.ops.object.modifier_add_node_group(asset_library_type='ESSENTIALS', asset_library_identifier="", relative_asset_identifier="geometry_nodes/smooth_by_angle.blend/NodeTree/Smooth by Angle")
        foo.__exit__()
        obj.modifiers["Smooth by Angle"].__setitem__("Input_1",angleDegrees*0.0174533)
        # TODO: make this set actually work
        obj.modifiers["Smooth by Angle"]["Ignore Sharpness"] = True
        # NOTE: FOR HAIR
        # obj.modifiers["Smooth by Angle"].node_group.nodes["Set Shade Smooth.001"].domain = 'FACE'
        # OG: (lambda obj, angleDegrees=30: (obj.modifiers["Smooth by Angle"].__setitem__("Input_1",angleDegrees*0.0174533) if "Smooth by Angle" in obj.modifiers else (foo:=bpy.context.temp_override(active_object= obj),foo.__enter__(),bpy.ops.object.modifier_add_node_group(asset_library_type='ESSENTIALS', asset_library_identifier="", relative_asset_identifier="geometry_nodes/smooth_by_angle.blend/NodeTree/Smooth by Angle"),foo.__exit__(),obj.modifiers["Smooth by Angle"].__setitem__("Input_1",angleDegrees*0.0174533))))(obj,25)
        # ^ from https://blender.stackexchange.com/questions/316696/attributeerror-mesh-object-has-no-attribute-use-auto-smooth

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
            manual_setter(obj, radians)
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

