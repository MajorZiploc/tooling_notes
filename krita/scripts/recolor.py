from krita import Krita, Document, QImage, QByteArray, QColor
from typing import Union
from dataclasses import dataclass

flip = False
def target_node_pred(node):
    return True
    # return node.name() == "r"
def target_layer_prep(layer, parent):
    if parent is None: return False
    if parent.name() != "r": return False
    # if parent.name() != "managed_color_flats": return False
    return True
hive_std_01_entity_main = {
  "head": [
    '#8f3737',
    '#000000',
  ],
  "upper_body": [
    '#411d31',
    '#577277',
    '#577277',
    '#ca3329',
  ],
  "lower_body": [
    '#411d31',
    '#884b2b',
    '#411d31',
    '#dfb25d',
  ],
  "skin": [
    '#c09474',
    '#000000',
  ],
  "skin_overlay": [
    '#453c3b',
    '#705f5d',
  ],
  "items": [
    '#473e4e',
    '#000000',
  ],
};

@dataclass(frozen=True, eq=True)
class ColorRemap:
    _from: Union[str, tuple[int, int, int]]
    _to: Union[str, tuple[int, int, int]]

color_remaps = []

# NOTE: apollo palette - gotten from godot project - look for krita_python_script
blue_color_bases = ['172038', '253a5e', '3c5e8b', '4f8fba', '73bed3', 'a4dddb']
green_color_bases = ['19332d', '25562e', '468232', '75a743', 'a8ca58', 'd0da91']
skin_color_bases = ['4d2b32', '7a4841', 'ad7757', 'c09473', 'd7b594', 'e7d5b3']
brown_color_bases = ['241527', '341c27', '602c2c', '884b2b', 'be772b', 'e8c170']
red_color_bases = ['411d31', '752438', 'a53030', 'cf573c', 'da863e', 'de9e41']
purple_color_bases = ['1e1d39', '402751', '7a367b', 'a23e8c', 'c65197', 'df84a5']
gray_color_bases = ['090a14', '10141f', '151d28', '202e37', '394a50', '577277', '819796', 'a8b5b2', 'c7cfcc', 'ebede9']

all_base_colors_sorted = blue_color_bases + green_color_bases + skin_color_bases + brown_color_bases + red_color_bases + purple_color_bases + gray_color_bases;

def get_color_map_for_hard_coded() -> dict:
  color_map = {
    blue_color_bases[3]: "#000000",
  };
  return color_map;

def get_color_map_for_entity_main(entity_palette: dict) -> dict:
  color_map = {
    red_color_bases[2]: entity_palette["head"][0],
    red_color_bases[4]: entity_palette["head"][1],
    blue_color_bases[2]: entity_palette["upper_body"][0],
    blue_color_bases[4]: entity_palette["upper_body"][1],
    green_color_bases[2]: entity_palette["upper_body"][2],
    green_color_bases[4]: entity_palette["upper_body"][3],
    purple_color_bases[2]: entity_palette["lower_body"][0],
    purple_color_bases[4]: entity_palette["lower_body"][1],
    brown_color_bases[2]: entity_palette["lower_body"][2],
    brown_color_bases[4]: entity_palette["lower_body"][3],
    skin_color_bases[2]: entity_palette["skin"][0],
    skin_color_bases[4]: entity_palette["skin"][1],
    purple_color_bases[1]: entity_palette["items"][0],
    purple_color_bases[3]: entity_palette["items"][1],
  };
  return color_map;

def color_map_to_full_color_map(color_remaps_: dict) -> list[ColorRemap]:
  full_color_map = [ColorRemap(_from=base_color, _to=color_remaps_.get(base_color, base_color)) for base_color in all_base_colors_sorted];
  return full_color_map;

# color_map_dict = get_color_map_for_entity_main(hive_std_01_entity_main)

color_map_dict = get_color_map_for_hard_coded()

color_remaps = color_map_to_full_color_map(color_map_dict)

def get_rgb_color(color: Union[str, tuple[int, int, int]]) -> tuple[int, int, int]:
    return color if type(color) is not str else tuple(int(color.lstrip("#")[i:i+2], 16) for i in (0, 2, 4)) # type: ignore
color_remaps = [ColorRemap(_from=get_rgb_color(color_remap._from),_to=get_rgb_color(color_remap._to)) for color_remap in color_remaps]
if flip:
    color_remaps = [ColorRemap(_from=color_remap._to,_to=color_remap._from) for color_remap in color_remaps]
 
def main():

    def process_layer(layer, parent=None):
        if layer.type() != "paintlayer": return
        if layer.name() == "Background": return
        if not target_layer_prep(layer, parent): return
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
                process_layer(child, node)

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
