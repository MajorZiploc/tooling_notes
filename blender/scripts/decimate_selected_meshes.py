import bpy
import logging

logging.basicConfig(level=logging.INFO,
                    format='%(asctime)-15s %(levelname)8s %(name)s %(message)s')

# for name in ('blender_id', 'blender_cloud'):
#     logging.getLogger(name).setLevel(logging.DEBUG)

logger = logging.getLogger('blender_id')
logger.setLevel(logging.DEBUG)

# for logging
def register():
    pass

def decimate_selected_meshes():
    for obj in bpy.context.selected_objects:
        if obj.type != 'MESH': continue
        try:
            bpy.context.view_layer.objects.active = obj
            decimate_mod = obj.modifiers.new(name='Decimate', type='DECIMATE')
            decimate_mod.decimate_type = 'COLLAPSE'
            decimate_mod.ratio = 0.5
            bpy.ops.object.modifier_apply(modifier='Decimate')
            logger.info(f'Decimated {obj.name} successfully.')
        except Exception as err:
            logger.error(f'Error decimating {obj.name}: {err}')
            continue

decimate_selected_meshes()
