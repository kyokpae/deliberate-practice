import 'dart:html';
import 'dart:math';

Random rng = new Random(123);
int count = 256;
List<int> randomNumbers = new List(count);
List<List<double>> gradients = new List(count);

List<double> noise(int x, int y, int z) {  
  return gradients[(z + randomNumbers[(y + randomNumbers[x & 0xff]) & 0xff]) & 0xff];
}

int width = 0;
int height = 0;
CanvasElement canvas;  
CanvasRenderingContext2D ctx;
ImageData imageData;

void main() {
  canvas = querySelector("#canvas");

  width = window.document.documentElement.clientWidth;
  height = window.document.documentElement.clientHeight;

  canvas.width = width;
  canvas.height = height;
 
  ctx = canvas.context2D;
  imageData = ctx.getImageData(0, 0, width, height);

  
  initializePerlin(); 
  window.requestAnimationFrame(animate);  
}

void animate(double frame) {
  int dx = (frame / 10).toInt();
  
  List<int> pixels = imageData.data;    

  int offset = 0;
  for (int y = 0; y < height; y++) {  
    for (int x = 0; x < width; x++) {
      double value = noise2d(x + dx, y);
      int color = (y.toDouble() ~/ 2 + value * 256 - 256).toInt();
      
      pixels[offset] = color;
      pixels[offset + 1] = color ~/2 + 128;
      pixels[offset + 2] = 255;
      pixels[offset + 3] = 255;
      offset += 4;
    }
  }
  ctx.putImageData(imageData, 0, 0);

  window.requestAnimationFrame(animate);
}

double noise2d(int x, int y) {
  double value = 0.0;
  int grid = 512;
  double factor = 1.0;
  double dimnish = 0.45;
  while (grid >= 2 && factor > 0.01) {    
    int gridY = y ~/ grid;
    int gridX = x ~/ grid;
    
    double X = (x % grid) / grid;
    double Y = (y % grid) / grid;
    
    List<double> sG = noise(gridX, gridY, 0);
    List<double> tG = noise(gridX + 1, gridY, 0);
    List<double> uG = noise(gridX, gridY + 1, 0);
    List<double> vG = noise(gridX + 1, gridY + 1, 0);
    
    double s = sG[0] * X         + sG[1] * Y;
    double t = tG[0] * (X - 1.0) + tG[1] * Y;
    double u = uG[0] * X         + uG[1] * (Y - 1.0);
    double v = vG[0] * (X - 1.0) + vG[1] * (Y - 1.0);
    
    
    double SX = 3.0 * X * X - 2.0 * X * X * X;
    double st = s + SX * (t - s);
    double uv = u + SX * (v - u);
    
    double SY = 3.0 * Y * Y - 2.0 * Y * Y * Y;
    double stuv = st + SY * (uv - st);
    
    value += stuv * factor;
    factor *= dimnish;
    grid >>= 1;
  }
  return value / sqrt(2);
}

void initializePerlin() {
  for (int i = 0; i < count; i++) {
    // Generate random number in the range <0; count).
    randomNumbers[i] = rng.nextInt(count);
    
    // Generate random 2D vector of length == 1.0.
    List<double> gradient = new List(2);
    gradient[0] = rng.nextDouble() * 2.0 - 1.0;
    gradient[1] = rng.nextDouble() * 2.0 - 1.0;
    
    double len = sqrt(gradient[0] * gradient[0] + gradient[1] * gradient[1]);
    gradient[0] /= len;
    gradient[1] /= len;

    gradients[i] = gradient;
  }
}
