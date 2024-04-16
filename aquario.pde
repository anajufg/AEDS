class Peixe {
  // Velocidade e posicao
  float x, y, vx, vy;
  // Comprimento e altura do peixe
  float bodyLength, bodyHeight;
  //Cor do peixe
  color cor;
  // Variavel contador
  int conta;

  Peixe() {
    x = (float)random(width);
    y = (float)random(onda, height);
    // Define o corpo do peixe
    this.bodyLength = (float)random(30, 40);
    this.bodyHeight = (float)random(20, 40);
    // Sorteia uma velocidade nos eixos x e y
    this.vx = (float)random(-200, 200);
    this.vy = (float)random(-200, 200);
    // Define a cor
    this.cor = color((int)random(225), (int)random(225), (int)random(225));
    this.conta = 0;
  }

  void Move() {
    if (this.conta < 600) {
      x = x + vx/frameRate;
      y = y + vy/frameRate;

      // Trata os casos das paredes
      if (x >= width || x < 0) vx = -vx;
      if (y >= height || y < onda) vy = -vy;

      this.conta++;
    } else {
      // Sorteia uma velocidade nos eixos x e y
      this.vx = (float)random(-200, 200);
      this.vy = (float)random(-200, 200);

      this.conta = 0;
    }
  }

  void Desenha() {
    fill(cor);
    // Corpo
    ellipse(x, y, bodyLength, bodyHeight);

    // Cauda
    float caudaLargura = bodyLength/4;
    float caudaAltura = bodyLength/2;
    if (vx > 0) {
      triangle((x-bodyLength/2), y,
        (x-bodyLength/2-caudaLargura), (y-caudaAltura),
        (x-bodyLength/2-caudaLargura), (y+caudaAltura));
    } else {
      triangle((x+bodyLength/2), y,
        (x+bodyLength/2+caudaLargura), (y+caudaAltura),
        (x+bodyLength/2+caudaLargura), (y-caudaAltura));
    }

    // Olho
    if (vx > 0) {
      fill(0);
      ellipse(x+bodyLength/4, y, bodyHeight/8, bodyHeight/8);
    } else {
      fill(0);
      ellipse(x-bodyLength/4, y, bodyHeight/8, bodyHeight/8);
    }
  }
}
class Algas {
  int numFolhas = 5; // Deifne o numero de folhas
  int l = 10; // Defile a largura das algas
  int[] folha = new int[numFolhas];
  int k, h;
  int posicao;

  public Algas (int posicao) {
    for (int i = 0; i < folha.length; i++) {
      folha[i] = (int)random(100); // Atribui tamanhos aleatórios para as folhas
    }
    this.posicao = posicao;
  }

  void Desenha () {

    for (int i = 0; i < numFolhas; i++) {

      h = int(folha[i]); // Altura da folha

      k = 0;

      if (i != 0) {
        for (int j = 1; j <= i; j++) {
          k += int(folha[j - 1]);
        }
      }

      fill(#34B261);
      stroke(#34B261);
      rect((int)random(posicao * l-(l/2), posicao * l+(l/2)), height-(k+h), l, h);
    }
  }
}
Peixe[] peixes = new Peixe[10];
int onda = 100, posicao = 0, distancia = (int)width/4;
int numAlga = 4;
Algas[] alga1 = new Algas[numAlga];
Algas[] alga2 = new Algas[numAlga];

void setup() {
  size(800, 600);

  for (int i = 0; i < peixes.length; i++) {
    peixes[i] = new Peixe();
  }

  // Posiciona a alga1 e a alga2
  for (int i = 0; i < alga1.length; i++) {
    alga1[i] = new Algas(posicao);
    alga2[i] = new Algas(posicao + (int)random(-4, 4)); // alga 2 um pouco mais distante
    posicao += distancia;
  }
}

void algas () {
  //Algas
  for (int i = 0; i < alga1.length; i++) {
    alga1[i].Desenha();
    alga2[i].Desenha();
    delay(100);
  }
}

void aquario() {
  fill(255);
  float j=0;
  stroke(255);

  for (int i=0; i < width; i++) {
    ellipse(j, 0, 120, onda);
    j+=onda;
  }
}

void draw() {
  background(#89D2F7);
  aquario();
  algas();
  stroke(#104D6C);

  //Peixes
  for (int i = 0; i < peixes.length; i++) {
    peixes[i].Move();
    peixes[i].Desenha();
  }
}
