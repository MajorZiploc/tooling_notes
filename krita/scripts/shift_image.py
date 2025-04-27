from krita import Krita

# WIP
# make this more like recolor script

# Get current document and node
app = Krita.instance()
doc = app.activeDocument()
node = doc.activeNode()

# Safety checks
if node.type() != 'paintlayer':
    raise Exception('Please select a paint layer!')

# Get the bounds of the layer content
bounds = node.bounds()
x, y, w, h = bounds.x(), bounds.y(), bounds.width(), bounds.height()

# Get the pixel data
pixel_data = node.pixelData(x, y, w, h)

# Create a new empty paint layer
# new_layer = doc.createNode(f"{node.name()}_shifted", "paintLayer")
new_layer = doc.createNode(node.name(), "paintLayer")

# Add the new layer above the original
parent = node.parentNode()
parent.addChildNode(new_layer, node)
parent.removeChildNode(node)

# Paste the pixel data shifted by 2 pixels right
new_layer.setPixelData(pixel_data, x + 2, y, w, h)

doc.refreshProjection()

