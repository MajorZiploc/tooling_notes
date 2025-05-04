from krita import Krita, Document, QImage, QByteArray, QColor
from typing import Union
from dataclasses import dataclass

@dataclass(frozen=True, eq=True)
class ColorRemap:
    _from: Union[str, tuple[int, int, int]]
    _to: Union[str, tuple[int, int, int]]

flip = False
color_remaps = [
    # ColorRemap(_from='#371603',_to='#a53030'),
    # ColorRemap(_from='#371603',_to=(62,233,1)),
    # ColorRemap(_from='#7a367b',_to='#3c5e8b'),
    # ColorRemap(_from='#c65197',_to='#73bed3'),
    # ColorRemap(_from='#df84a5',_to='#a4dddb'),
    ColorRemap(_from='#73bed3',_to='#3c5e8b'),
    ColorRemap(_from='#a4dddb',_to='#3c5e8b'),
    # ColorRemap(_from='#151d28',_to='#090a14'),
]
def target_node_pred(node):
    return True
    # return node.name() == "r"

def get_rgb_color(color: Union[str, tuple[int, int, int]]) -> tuple[int, int, int]:
    return color if type(color) is not str else tuple(int(color.lstrip("#")[i:i+2], 16) for i in (0, 2, 4)) # type: ignore
color_remaps = [ColorRemap(_from=get_rgb_color(color_remap._from),_to=get_rgb_color(color_remap._to)) for color_remap in color_remaps]
if flip:
    color_remaps = [ColorRemap(_from=color_remap._to,_to=color_remap._from) for color_remap in color_remaps]
 
def main():

    def process_layer(layer):
        if layer.type() != "paintlayer": return
        if layer.name() == "Background": return
        print('layer.name()')
        print(layer.name())
        width, height = doc.width(), doc.height()
        data = layer.pixelData(0, 0, width, height)
        img1 = QImage(data, doc.width(), doc.height(), QImage.Format_RGBA8888)
        for y in range(img1.height()):
            for x in range(img1.width()):
                color = QColor(img1.pixel(x, y))
                for color_remap in color_remaps:
                    r1,g1,b1 = color_remap._from
                    r2,g2,b2 = color_remap._to
                    # NOTE: red is blue and blue is red - someone messed up the api
                    if color.red() == b1 and color.green() == g1 and color.blue() == r1:
                        img1.setPixelColor(x, y, QColor(b2, g2, r2, color.alpha()))
        ptr = img1.bits()
        ptr.setsize(img1.byteCount())
        layer.setPixelData(QByteArray(ptr.asstring()), 0, 0, img1.width(), img1.height())
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
    if not doc:
        print("No active document found.")
        return
    print(f'Active Document: {doc.fileName()}')
    print('doc.animationLength()')
    print(doc.animationLength())
    root_node = doc.rootNode()
    target_node = root_node if target_node_pred(root_node) else find_target_node(root_node)
    if target_node is None:
        print("target_node not found")
        return
    for time in range(0, doc.animationLength()):
        doc.setCurrentTime(time)
        print('doc.currentTime()')
        print(doc.currentTime())
        traverse_layers(target_node)

# NOTE: krita calls main by default. no need to call it here
# if __name__ == "__main__":
#     main()
