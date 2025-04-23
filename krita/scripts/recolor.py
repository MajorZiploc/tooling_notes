from krita import Krita, Document, QImage, QByteArray

def main():

    def process_layer(layer):
        if layer.type() != "paintlayer": return
        if layer.name() == "Background": return
        print('layer.name()')
        print(layer.name())
        r, g, b = 255, 0, 0
        width, height = doc.width(), doc.height()
        data = layer.pixelData(0, 0, width, height)
        # print(data)
        # print(data[0])
        # img1 = QImage()
        # img1.loadFromData(data)
        # img1.rgbSwapped()
        img1 = QImage(data, doc.width(), doc.height(), QImage.Format_RGBA8888).rgbSwapped()
        ptr = img1.bits()
        # print('img1')
        # print(img1)
        # print('img1.bits()')
        # print(img1.bits())
        ptr.setsize(img1.byteCount())
        layer.setPixelData(QByteArray(ptr.asstring()), 0, 0, img1.width(), img1.height())
        doc.refreshProjection()
        #
        #
        # width, height = doc.width(), doc.height()
        # data = layer.pixelData(0, 0, width, height)
        # print(data)
        # print(data[0])
        # for y in range(height):
        #     for x in range(width):
        #         index = 4 * (y * width + x)
        #         data[index] = r
        #         data[index + 1] = g
        #         data[index + 2] = b
        # layer.setPixelData(data, 0, 0, width, height)
        #
        #
        # image_data = layer.getImageData()
        # Iterate through the pixels
        # for pixel_index, pixel in enumerate(image_data):
        #     # Check if the pixel is gray (simplified example)
        #     # if pixel[0] == pixel[1] and pixel[1] == pixel[2]:
        #         # Change the pixel to red
        #     image_data[pixel_index] = (255, 0, 0)  # Red
        # # Update the layer's image data
        # layer.setImageData(image_data)

    def traverse_layers(node):
        for child in node.childNodes():
            process_layer(child)
            if child.type() == "grouplayer":
                traverse_layers(child)

    print('hi')
    app = Krita.instance()
    doc = app.activeDocument()
    if doc:
        print(f'Active Document: {doc.fileName()}')
        root_node = doc.rootNode()
        traverse_layers(root_node)
    else:
        print("No active document found.")

# krita calls main by default. no need to call it here
# if __name__ == "__main__":
#     main()
