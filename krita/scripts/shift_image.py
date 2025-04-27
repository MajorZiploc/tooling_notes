from krita import Krita

# Get current document and node
app = Krita.instance()
doc = app.activeDocument()
node = doc.activeNode()

from krita import Krita, Document, QImage, QByteArray, QColor
from typing import Union
from dataclasses import dataclass

@dataclass(frozen=True, eq=True)
class PixelShift:
    x: int
    y: int

flip = False
pixel_shifts = [
    PixelShift(x=2,y=0),
]
target_node_pred = None
# def target_node_pred(node):
#     return node.name() == "r"

def magnify_shift(el: int) -> int:
    return el
    # return el * 2
pixel_shifts = [PixelShift(x=magnify_shift(color_remap.x),y=magnify_shift(color_remap.y)) for color_remap in pixel_shifts]
if flip:
    pixel_shifts = [PixelShift(x=color_remap.y,y=color_remap.x) for color_remap in pixel_shifts]
 
def main():

    def process_layer(layer):
        print('layer.name()')
        print(layer.name())
        if layer.type() != "paintlayer": return
        if layer.name() == "Background": return
        bounds = layer.bounds()
        x, y, w, h = bounds.x(), bounds.y(), bounds.width(), bounds.height()
        pixel_data = layer.pixelData(x, y, w, h)
        new_layer = doc.createNode(layer.name(), "paintLayer")
        parent = layer.parentNode()
        parent.addChildNode(new_layer, layer)
        parent.removeChildNode(layer)
        dx = 0
        dy = 0
        for pixel_shift in pixel_shifts:
            dx += pixel_shift.x
            dy += pixel_shift.y
        new_layer.setPixelData(pixel_data, x + dx, y + dy, w, h)
        doc.refreshProjection()

    def traverse_layers(node):
        if node.type() == "paintlayer":
            process_layer(node)
            return
        for child in node.childNodes():
            if child.type() == "grouplayer":
                traverse_layers(child)
            else:
                process_layer(child)

    def find_target_node(node):
        if node.type() == "paintlayer" and target_node_pred(node): return node
        for child in node.childNodes():
            if target_node_pred(child): return child
            if child.type() == "grouplayer": return find_target_node(child)

    app = Krita.instance()
    doc = app.activeDocument()
    if doc:
        print(f'Active Document: {doc.fileName()}')
        print('doc.animationLength()')
        print(doc.animationLength())
        root_node = doc.rootNode()
        target_node = find_target_node(root_node) if target_node_pred else root_node
        if target_node is None:
            print("target_node not found")
            return
        for time in range(0, doc.animationLength()):
            doc.setCurrentTime(time)
            print('doc.currentTime()')
            print(doc.currentTime())
            traverse_layers(target_node)
    else:
        print("No active document found.")

# krita calls main by default. no need to call it here
# if __name__ == "__main__":
#     main()
