import 'dart:html';

void main() {
  ImageElement image = querySelector("#david");
  image.onLoad.listen((e) {
    CanvasElement canvas = querySelector("#canvas");       
    querySelector("#depth").onChange.listen((e) => redraw(canvas, image, getDepth(), getDitherFlag()));
    querySelector("#dither").onChange.listen((e) => redraw(canvas, image, getDepth(), getDitherFlag()));
    redraw(canvas, image, getDepth(), getDitherFlag());
  });
}

int getDepth() {
  return int.parse(querySelector("#depth").value);
}

bool getDitherFlag() {
  return querySelector("#dither").checked;
}

void redraw(CanvasElement canvas, ImageElement image, int depth, bool dither) {
  // Align canvas dimensions with image dimensions.
  canvas.width = image.width;
  canvas.height = image.height;

  // Process the image and draw it to canvas.
  ImageData imageData = getPixels(image);
  reduceDepth(imageData.data, width: image.width, height: image.height, depth: depth, dither: dither);    
  canvas.context2D.putImageData(imageData, 0, 0);
}

/**
 * Returns image's ImageData.
 */
ImageData getPixels(ImageElement image) {
  CanvasElement canvas = new CanvasElement(width: image.width, height: image.height);
  CanvasRenderingContext2D screen = canvas.context2D;   
  screen.drawImage(image, 0, 0);
  return screen.getImageData(0, 0, image.width, image.height);
}

/**
 * Reduces color components' depth and optionally applies Floyd-Steinberg dithering to the array
 * of pixels.
 */
void reduceDepth(List<int> pixels, {int width, int height, int depth, bool dither}) {
  double scale = (depth - 1).toDouble() / 255.0;
  int offset = 0;
  int maxOffset = width * height * 4;
  int rowWidth = 4 * width;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      // For each of the color components smear do the dithering of a pixel.
      for (int i = 0; i < 4; i++, offset++) {
        int oldPixel = pixels[offset];
        
        // Reduce the depth of the pixel's value.
        int color = (oldPixel.toDouble() * scale).round();
        int newPixel = (color.toDouble() / scale).toInt();
        pixels[offset] = newPixel;
        
        if (!dither) {
          continue;
        }
 
        double quantError = (oldPixel - newPixel).toDouble() / 16;
        
        // Right.
        if (x + 1 < width) {
          pixels[offset + 4] += (7 * quantError).toInt();
        }
        
        // Continue only if that's not the last row.
        if (y + 1 == height) {
          continue;
        }
        
        // Bottom.
        pixels[offset + rowWidth] += (5 * quantError).toInt();
        
        // Bottom left.
        if (x - 1 >= 0) {
          pixels[offset + rowWidth - 4] += (3 * quantError).toInt();
        }
        
        // Bottom right.
        if (x + 1 < width) {
          pixels[offset + rowWidth + 4] += (1 * quantError).toInt();
        }
      }
    }
  }
}