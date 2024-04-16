class Planeta {
  float distancia, raio, angulo, omega;
  color cor;

  Planeta(float angulo, float omega) {
    this.angulo = angulo;
    this.omega = omega;
    this.raio = random(10, 50);
    this.distancia = (float)random(width/2) + this.raio + 75;
    this.cor = color((int)random(256), (int)random(256), (int)random(256));
  }

  void update () {
    // Varia o angulo em funcao do omega
    angulo = angulo + omega/frameRate;
    // Trata os casos do angulo
    if (angulo > 360) angulo -= 360;
    if (angulo < 0) angulo += 360;
  }

  void show() {
    fill(cor);
    // Define a posicao cartesiana do planeta
    float x = this.distancia*cos(radians(angulo));
    float y = this.distancia*sin(radians(angulo));
    
    ellipse(x, y, raio, raio);
  }
}

float r = 300;
Planeta[] sistema = new Planeta[5];

void setup() {
  size(600, 600);
  for (int i = 0; i < sistema.length; i++) {
    sistema[i] = new Planeta(0, random(1, 10));
  }
}

void draw() {
  translate(300, 300);
  background(0);
  
  // Sol
  fill(#F2F264);
  ellipse(0, 0, 150, 150);
  
  // Planetas
  for (int i = 0; i < sistema.length; i++) {
    sistema[i].update();
   sistema[i].show();
  }
}
