import bpy

def decimate_selected_meshes():
    for obj in bpy.context.selected_objects:
        if obj.type != 'MESH': continue
        bpy.context.view_layer.objects.active = obj
        decimate_mod = obj.modifiers.new(name='Decimate', type='DECIMATE')
        decimate_mod.decimate_type = 'COLLAPSE'
        decimate_mod.ratio = 0.5
        bpy.ops.object.modifier_apply(modifier='Decimate')

decimate_selected_meshes()
