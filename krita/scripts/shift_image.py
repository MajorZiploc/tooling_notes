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
    PixelShift(x=2,y=5),
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

    # TODO: as it is now, seems like the layer glitches a little and leaves artifact pixels in places
    def process_layer(layer):
        print('layer.name()')
        print(layer.name())
        if layer.type() != "paintlayer": return
        if layer.name() == "Background": return
        bounds = layer.bounds()
        x, y, w, h = bounds.x(), bounds.y(), bounds.width(), bounds.height()
        # blank_layer = doc.createNode(layer.name(), "paintLayer")
        new_layer = layer.clone()
        pixel_data = layer.pixelData(x, y, w, h)
        # # new_layer.setPixelData(QByteArray(), x, y, w, h)
        # blank_img = QImage(new_layer.pixelData(0, 0, w, h), doc.width(), doc.height(), QImage.Format_RGBA8888) #.fill(QColor(0,0,0,0))
        # for y in range(blank_img.height()):
        #     for x in range(blank_img.width()):
        #         color = QColor(blank_img.pixel(x, y))
        #         # blank_img.setPixelColor(x, y, QColor(0, 0, 0, color.alpha()))
        #         blank_img.setPixelColor(x, y, QColor(0, 0, 0, 0))
        # blank_img_ptr = blank_img.bits()
        # blank_img_ptr.setsize(blank_img.byteCount())
        # new_layer.setPixelData(QByteArray(blank_img_ptr.asstring()), 0, 0, blank_img.width(), blank_img.height())
        dx = 0
        dy = 0
        for pixel_shift in pixel_shifts:
            dx += pixel_shift.x
            dy += pixel_shift.y
        new_layer.setPixelData(pixel_data, x + dx, y + dy, w, h)
        parent = layer.parentNode()
        parent.addChildNode(new_layer, layer)
        parent.removeChildNode(layer)
        # blank_layer_pixel_data = blank_layer.pixelData(x, y, w, h)
        # new_layer.setPixelData(blank_layer_pixel_data, x + dx, y + dy, w, h)
        doc.refreshProjection()

    # def process_layer(layer):
    #     if layer.type() != "paintlayer": return
    #     if layer.name() == "Background": return
    #     print('layer.name()')
    #     print(layer.name())
    #     width, height = doc.width(), doc.height()
    #     data = layer.pixelData(0, 0, width, height)
    #     img1 = QImage(data, doc.width(), doc.height(), QImage.Format_RGBA8888)
    #     dx = 0
    #     dy = 0
    #     for pixel_shift in pixel_shifts:
    #         dx += pixel_shift.x
    #         dy += pixel_shift.y
    #     for y in range(img1.height()):
    #         for x in range(img1.width()):
    #             color = QColor(img1.pixel(x, y))
    #             img1.setPixelColor(x+dx, y+dy, color)
    #     ptr = img1.bits()
    #     ptr.setsize(img1.byteCount())
    #     layer.setPixelData(QByteArray(ptr.asstring()), 0, 0, img1.width(), img1.height())
    #     doc.refreshProjection()

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
