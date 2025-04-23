from krita import Krita, Document, QImage, QByteArray, QColor
 
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
        # QImage.Format_RGB32
        # img1 = QImage(data, doc.width(), doc.height(), QImage.Format_RGBA8888).rgbSwapped()
        # print('img1')
        # print(img1)
        # print('img1.bits()')
        # print(img1.bits())

        # address the TODO in this python krita plugin code snippet
        # NOTE: dont worry about undefined vars and such, this is a snippet from a larger code base
        # img1 = QImage(data, doc.width(), doc.height(), QImage.Format_RGBA32)
        # ptr = img1.bits()
        # # TODO: change all (r,g,b) = (55,22,3) to (r,g,b) = (62, 233, 1)
        # ptr.setsize(img1.byteCount())
        # layer.setPixelData(QByteArray(ptr.asstring()), 0, 0, img1.width(), img1.height())
        # doc.refreshProjection()

        img1 = QImage(data, doc.width(), doc.height(), QImage.Format_RGBA8888)
        for y in range(img1.height()):
            for x in range(img1.width()):
                color = QColor(img1.pixel(x, y))
                # print('------colors BEGIN')
                # print('color.red()')
                # print(color.red())
                # print('color.green()')
                # print(color.green())
                # print('color.blue()')
                # print(color.blue())
                # print('------colors END')
                # red is blue and blue is red - someone messed up the api
                if color.red() == 3 and color.green() == 22 and color.blue() == 55:
                    img1.setPixelColor(x, y, QColor(62, 233, 1, color.alpha()))
                    # print('CHANGE!')
                # break
            # break

        ptr = img1.bits()
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

    app = Krita.instance()
    doc = app.activeDocument()
    if doc:
        print(f'Active Document: {doc.fileName()}')
        print('doc.animationLength()')
        print(doc.animationLength())
        for time in range(0, doc.animationLength()):
            doc.setCurrentTime(time)
            print('doc.currentTime()')
            print(doc.currentTime())
            root_node = doc.rootNode()
            traverse_layers(root_node)
    else:
        print("No active document found.")

# krita calls main by default. no need to call it here
# if __name__ == "__main__":
#     main()
