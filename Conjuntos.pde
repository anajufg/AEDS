import java.util.Stack;
import java.util.HashSet;

// Definição da classe Grafo
class Grafo {
  int numVertices;
  HashSet<PVector> matrizAdj;
  PVector[] posicoes; // Posições das partículas (nós do grafo)
  PVector[] velocidades; // Velocidades das partículas
  float raio = 10; // Raio dos nós
  float k = 0.01; // Constante da mola para a atração
  float c = 3000; // Constante de repulsão
  int[] cores;

  // Construtor da classe Grafo
  Grafo(int numVertices) {
    this.numVertices = numVertices;
    matrizAdj = new HashSet<PVector>();
    posicoes = new PVector[numVertices];
    velocidades = new PVector[numVertices];
    
    cores = colorirGrafo();

    adicionarAresta();

    inicializarPosicoes();
  }

  // Adiciona uma aresta entre dois vértices
  void adicionarAresta() {
    int aresta;

    for (int i = 0; i < numVertices; i++) {
      for (int j = 0; j < numVertices; j++) {

        if (i != j) {
          aresta = random(1) > 0.5 ? int(random(1, 5)) : 0;

          if (aresta != 0) {
            if (i < j && !matrizAdj.contains(new PVector(i, j))) {
              matrizAdj.add(new PVector(i, j));
            }
          }
        }
      }
    }
  }

  // Inicializa as posições das partículas em um círculo
  void inicializarPosicoes() {
    float angulo = TWO_PI / (numVertices - 1);
    float raioCirculo = min(width, height) / 3;
    for (int i = 0; i < numVertices; i++) {
      float x = width / 2 + raioCirculo * cos((i) * angulo);
      float y = height / 2 + raioCirculo * sin((i) * angulo);
      posicoes[i] = new PVector(x, y);
      velocidades[i] = new PVector(0, 0);
    }
    // Posição fixa do vértice 0
    posicoes[0] = new PVector(width / 2, height / 2);
    velocidades[0] = new PVector(0, 0);
  }

  // Atualiza as posições das partículas
  void atualizar() {
    for (int i = 1; i < numVertices; i++) {
      PVector forca = new PVector(0, 0);

      // Força de repulsão
      for (int j = 0; j < numVertices; j++) {
        if (i != j) {
          PVector direcao = PVector.sub(posicoes[i], posicoes[j]);
          float distancia = direcao.mag();
          if (distancia > 0) {
            direcao.normalize();
            float forcaRepulsao = c / (distancia * distancia);
            direcao.mult(forcaRepulsao);
            forca.add(direcao);
          }
        }
      }

      // Força de atração
      for (int j = 0; j < numVertices; j++) {
        if (matrizAdj.contains(new PVector(i, j))) {
          PVector direcao = PVector.sub(posicoes[j], posicoes[i]);
          float distancia = direcao.mag();
          direcao.normalize();
          float forcaAtracao = k * (distancia - raio);
          direcao.mult(forcaAtracao);
          forca.add(direcao);
        }
      }

      velocidades[i].add(forca);
      posicoes[i].add(velocidades[i]);

      // Reduz a velocidade para estabilizar a simulação
      velocidades[i].mult(0.5);

      // Mantém as partículas dentro da tela
      if (posicoes[i].x < 0 || posicoes[i].x > width) velocidades[i].x *= -1;
      if (posicoes[i].y < 0 || posicoes[i].y > height)velocidades[i].y *= -1;
    }
  }

  // Desenha o grafo
  void desenhar() {
    textAlign(CENTER);
    // Desenha as arestas
    stroke(0);
    strokeWeight(1);
    for (int i = 0; i < numVertices; i++) {
      for (int j = i + 1; j < numVertices; j++) {
        strokeWeight(1);
        PVector x = new PVector(i, j);
        if (matrizAdj.contains(x)) line(posicoes[i].x, posicoes[i].y, posicoes[j].x, posicoes[j].y);
      }
    }

    // Desenha os nós
    fill(255);
    stroke(255);
    strokeWeight(1);
    for (int i = 0; i < numVertices; i++) {
      fill(cores[i]);
      ellipse(posicoes[i].x, posicoes[i].y, raio * 2, raio * 2);
      fill(0);
      text(str(i), posicoes[i].x, posicoes[i].y+4);
    }
  }

  int[] colorirGrafo() {
    HashSet<Integer> coresCriadas = new HashSet<Integer>();
    int[] cores = new int[numVertices];
    boolean[] coresDisp = new boolean[numVertices];
    int[] coresPossiveis = new int[numVertices];

    for (int i = 0; i < numVertices; i++) {
      coresPossiveis[i] = (int)color(random(255), random(255), random(255));
      cores[i] = 0;
      coresDisp[i] = true;
    }

    for (int v = 0; v < numVertices; v++) {
      for (int u = 0; u < numVertices; u++) {
        PVector x = new PVector(v, u);
        if (matrizAdj.contains(x)) {
          if (cores[u] != 0) {
            coresDisp[u] = false;
          }
        }
      }

      for (int cor = 0; cor < numVertices; cor++) {
        if (coresDisp[cor] == true) {
          cores[v] = coresPossiveis[cor];
          break;
        }
      }

      for (int i = 0; i < numVertices; i++) {
        coresDisp[i] = true;
      }
    }

    for (int i = 0; i < numVertices; i++) {
      println(cores[i]);
    }
    return cores;
  }
}

Grafo grafo;

void setup() {
  size(800, 600);
  frameRate(60);

  int n = 10;
  grafo = new Grafo(n);
}

void draw() {
  background(#F7D7AF);
  //grafo.atualizar();
  grafo.desenhar();
}
