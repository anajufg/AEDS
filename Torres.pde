import java.util.Stack;

int n = 5;
int h = 40;
int torresPosY = 200;
int posX1 = 150;
int posX2 = 300;
int posX3 = 450;

Stack<Disco> torre1;
Stack<Disco> torre2;
Stack<Disco> torre3;

boolean chose;
Disco buffer;

Botao restart;

void setup() {
  size(600, 600);

  torre1 = iniciaTorre();
  torre2 = new Stack<Disco>();
  torre3 = new Stack<Disco>();

  chose = false;
  
  restart = new Botao(width/2-180/2, height-100, 180, 45, #795126, #34210C, "RESTART", #FFC85A, 30);
}

void draw() {
  background(#F7E3BB);
  noStroke();

  fill(#8E6A22);
  rect(posX1, torresPosY, 10, 200);
  rect(posX2, torresPosY, 10, 200);
  rect(posX3, torresPosY, 10, 200);

  mostraTorre(torre1, posX1);
  mostraTorre(torre2, posX2);
  mostraTorre(torre3, posX3);

  selecionado(torre1);
  selecionado(torre2);
  selecionado(torre3);

  if (chose) {
    buffer.update(mouseX, mouseY);
    buffer.show();

    selecionaTorre(torre1, posX1);
    selecionaTorre(torre2, posX2);
    selecionaTorre(torre3, posX3);
  }
  
  restart.Show();
  restart.Selecionado();
  
  if (restart.pressed) {
    limpaTorre(torre1);
    limpaTorre(torre2);
    limpaTorre(torre3);
    buffer = null;
    chose = false;
    
    torre1 = iniciaTorre();
    
    restart.pressed = false;
  }
}

void mostraTorre(Stack<Disco> torre, int posX) {
  int i = 0;

  for (Disco disco : torre) {
    disco.update(posX+5, 400-i);
    disco.show();

    i = i + 40;
  }
}

void selecionado(Stack<Disco> torre) {
  if (!torre.empty()) {
    Disco ultimo = torre.peek();

    if ((mouseX >= ultimo.posX-ultimo.l/2 && mouseX <= ultimo.posX+ultimo.l/2) && (mouseY >= ultimo.posY-ultimo.h/2 && mouseY <= ultimo.posY+ultimo.h/2)) {
      if (mousePressed  && chose == false) {
        buffer = torre.pop();
        chose = true;
      }
    }
  }
}

void selecionaTorre(Stack<Disco> torre, int posX) {

  if ((mouseX >= posX-30 && mouseX <= posX+40) && (mouseY >= torresPosY-30 && mouseY <= torresPosY+25)) {
    fill(#866827);
    rect(posX, torresPosY-60, 10, 30);
    triangle(posX+5, torresPosY-20, posX-15, torresPosY-35, posX+25, torresPosY-35);

    if (!torre.empty()) {
      Disco ultimo = torre.peek();

      if (mousePressed && ultimo.l > buffer.l) {
        torre.push(buffer);
        chose = false;
      }
    } else {
      if (mousePressed) {
        torre.push(buffer);
        chose = false;
      }
    }
  }
}

Stack<Disco> iniciaTorre() {
  Stack<Disco> torre = new Stack<Disco>();

  for (int i = 0; i < n; i++) {
    Disco newDisco = new Disco((int)random(50, 200), h, color(random(255), random(255), random(255)));

    torre.push(newDisco);
  }

  return torre;
}

void limpaTorre(Stack<Disco> torre) {
  while (!torre.empty()) {
    torre.pop();
  }
}

// =================================================

class Disco {

  int l, h;
  int posX, posY;
  color cor;

  Disco (int l, int h, color cor) {
    this.l = l;
    this.h = h;
    this.cor = cor;
  }

  void show() {
    fill(cor);
    ellipse(posX, posY, l, h);
  }
  
  void update(int posX, int posY) {
    this.posX = posX;
    this.posY = posY;
  }
}

// ===================================================

class Botao {
  int x, y, l, h;
  color cor, corAtual;
  color sombra, sombraAtual;
  String texto;
  color corTexto, corTextoAtual;
  color corHightLight = 0, sombraHightLight = 225, corTextoHightLight = 255;
  int textoSize;
  boolean pressed;

  Botao(int x, int y, int l, int h, color cor, color sombra, String texto, color corTexto, int textoSize) {
    this.x = x;
    this.y = y;
    this.l = l;
    this.h = h;
    this.cor = cor;
    this.corAtual = cor;
    this.sombra = sombra;
    this.sombraAtual = sombra;
    this.texto = texto;
    this.corTexto = corTexto;
    this.corTextoAtual = corTexto;
    this.textoSize = textoSize;
    this.pressed = false;
  }

  void Show() {
    
    // Sombra do botao
    fill(sombraAtual);
    rect(x, y+h/4, l, h);
    rect(x+l, y+h/2, l/16, h/2);
    rect(x-l/16, y+h/2, l/16, h/2);

    // Botao
    fill(corAtual);
    rect(x, y, l, h);
    rect(x+l, y+h/4, l/16, h/2);
    rect(x-l/16, y+h/4, l/16, h/2);

    // Texto
    textAlign(CENTER);
    //textFont(fonte, 50);
    fill(corTextoAtual);
    textSize(textoSize);
    text(texto, x+l/2, y+h/2+h/4);
  }

  void Selecionado() { 
    // Botao selecionado
    // Verifica se o mouse está em cima do botao
    if ((mouseX >= x && mouseX <= x+l) && (mouseY >= y && mouseY <= y+h)) {
      corAtual = corHightLight;
      sombraAtual = sombraHightLight;
      corTextoAtual = corTextoHightLight;
      
      if(mousePressed) {
        pressed = true;
      } 
    } else {
      corAtual = cor;
      sombraAtual = sombra;
      corTextoAtual = corTexto;
    }
  }
}
