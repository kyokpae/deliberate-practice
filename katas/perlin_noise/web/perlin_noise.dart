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
  height = 512;

  canvas.width = width;
  canvas.height = height;
 
  ctx = canvas.context2D;
  imageData = ctx.getImageData(0, 0, width, height);

  
  initializePerlin(); 
  window.requestAnimationFrame(animate);  
}

void animate(double frame) {
  int dx = (frame / 128.0).toInt();
  int dz = (frame / 64.0).toInt();
  
  List<int> pixels = imageData.data;    

  int offset = 0;
  for (int y = 0; y < height; y++) {  
    for (int x = 0; x < width; x++) {
      double value = noise3d(x + dx, y, dz);
      int color = y ~/ 2 -192 + (value * 256.0).toInt() + 128;
      
      pixels[offset] = 255;
      pixels[offset + 1] = 255;
      pixels[offset + 2] = 255;
      pixels[offset + 3] = color;
      offset += 4;
    }
  }
  ctx.putImageData(imageData, 0, 0);

  window.requestAnimationFrame(animate);
}

double noise3d(int x, int y, int z) {
  double value = 0.0;
  int grid = 256;
  double factor = 1.0;
  double dimnish = 0.45;
  while (grid >= 2 && factor > 0.01) {    
    int gridX = x ~/ grid;
    int gridY = y ~/ grid;
    int gridZ = z ~/ grid;
    
    double X = (x % grid) / grid;
    double Y = (y % grid) / grid;
    double Z = (z % grid) / grid;
    
    List<double> sG = noise(gridX, gridY, gridZ);
    List<double> tG = noise(gridX + 1, gridY, gridZ);
    List<double> uG = noise(gridX, gridY + 1, gridZ);
    List<double> vG = noise(gridX + 1, gridY + 1, gridZ);
    
    double s = sG[0] * X         + sG[1] * Y          + sG[2] * Z;
    double t = tG[0] * (X - 1.0) + tG[1] * Y          + tG[2] * Z;
    double u = uG[0] * X         + uG[1] * (Y - 1.0)  + uG[2] * Z;
    double v = vG[0] * (X - 1.0) + vG[1] * (Y - 1.0)  + vG[2] * Z;
        
    double SX = 3.0 * X * X - 2.0 * X * X * X;
    double SY = 3.0 * Y * Y - 2.0 * Y * Y * Y;
    double SZ = 3.0 * Z * Z - 2.0 * Z * Z * Z;
    
    double st = s + SX * (t - s);
    double uv = u + SX * (v - u);    
    double stuv = st + SY * (uv - st);

    List<double> sGP = noise(gridX, gridY, gridZ + 1);
    List<double> tGP = noise(gridX + 1, gridY, gridZ + 1);
    List<double> uGP = noise(gridX, gridY + 1, gridZ + 1);
    List<double> vGP = noise(gridX + 1, gridY + 1, gridZ + 1);
    
    double sP = sGP[0] * X         + sGP[1] * Y          + sGP[2] * (Z - 1.0);
    double tP = tGP[0] * (X - 1.0) + tGP[1] * Y          + tGP[2] * (Z - 1.0);
    double uP = uGP[0] * X         + uGP[1] * (Y - 1.0)  + uGP[2] * (Z - 1.0);
    double vP = vGP[0] * (X - 1.0) + vGP[1] * (Y - 1.0)  + vGP[2] * (Z - 1.0);
        
    double stP = sP + SX * (tP - sP);
    double uvP = uP + SX * (vP - uP);    
    double stuvP = stP + SY * (uvP - stP);
    
    double finalValue = stuv + SZ * (stuvP - stuv); 
       
    value += finalValue * factor;
    factor *= dimnish;
    grid >>= 1;
  }
  return value / sqrt(3);
}

void initializePerlin() {
  for (int i = 0; i < count; i++) {
    // Generate random number in the range <0; count).
    randomNumbers[i] = rng.nextInt(count);
    
    // Generate random 2D vector of length == 1.0.
    List<double> gradient = new List(3);
    gradient[0] = rng.nextDouble() * 2.0 - 1.0;
    gradient[1] = rng.nextDouble() * 2.0 - 1.0;
    gradient[2] = rng.nextDouble() * 2.0 - 1.0;
    
    double len = sqrt(gradient[0] * gradient[0] + gradient[1] * gradient[1] + gradient[2] * gradient[2]);
    gradient[0] /= len;
    gradient[1] /= len;
    gradient[2] /= len;

    gradients[i] = gradient;
  }
}
