import java.util.Stack;

// Definição da classe Grafo
class Grafo {
  int numVertices;
  int[][] matrizAdj;
  PVector[] posicoes; // Posições das partículas (nós do grafo)
  PVector[] velocidades; // Velocidades das partículas
  float raio = 10; // Raio dos nós
  float k = 0.01; // Constante da mola para a atração
  float c = 3000; // Constante de repulsão
  
  // Construtor da classe Grafo
  Grafo(int numVertices) {
    this.numVertices = numVertices;
    matrizAdj = new int[numVertices][numVertices];
    posicoes = new PVector[numVertices];
    velocidades = new PVector[numVertices];
    inicializarPosicoes();
  }
  
  Grafo(int[][] adj) {
    this.numVertices = adj.length;
    matrizAdj = adj;
    posicoes = new PVector[numVertices];
    velocidades = new PVector[numVertices];
    inicializarPosicoes();
  }

  // Adiciona uma aresta entre dois vértices
  void adicionarAresta(int i, int j) {
    matrizAdj[i][j] = 1;
    matrizAdj[j][i] = 1; // Para grafos não direcionados
  }
  
  // Adiciona uma aresta entre dois vértices
  void adicionarAresta(int i, int j, int peso) {
    matrizAdj[i][j] = peso;
    matrizAdj[j][i] = peso; // Para grafos não direcionados
  }

  // Inicializa as posições das partículas em um círculo
  void inicializarPosicoes() {
    float angulo = TWO_PI / (numVertices - 1);
    float raioCirculo = min(width, height) / 3;
    for (int i = 1; i < numVertices; i++) {
      float x = width / 2 + raioCirculo * cos((i - 1) * angulo);
      float y = height / 2 + raioCirculo * sin((i - 1) * angulo);
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
        if (matrizAdj[i][j] > 0) {
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
        strokeWeight(matrizAdj[i][j]);
        if (matrizAdj[i][j] > 0) line(posicoes[i].x, posicoes[i].y, posicoes[j].x, posicoes[j].y);
      }
    }

    // Desenha os nós
    fill(255);
    stroke(255);
    strokeWeight(1);
    for (int i = 0; i < numVertices; i++) {
      fill(255);
      ellipse(posicoes[i].x, posicoes[i].y, raio * 2, raio * 2);
      fill(0);
      text(str(i), posicoes[i].x, posicoes[i].y+4);
    }
  }
  
  // Algoritmo de Dijkstra para encontrar o caminho mais curto a partir de um vértice origem até um vértice destino
  void Dijkstra(int origem, int destino) {
    int[] menoresDist = new int[numVertices]; // Array para armazenar as menores distâncias conhecidas da origem até cada vértice
    int[] anterior = new int[numVertices]; // Array para armazenar o vértice anterior no caminho mais curto até cada vértice
    
    // Inicializa os arrays com valores iniciais
    for (int v = 0; v < numVertices; v++) {
      menoresDist[v] = Integer.MAX_VALUE; // Inicializa todas as distâncias como infinito
      anterior[v] = -1; // Define o vértice anterior como -1 (ainda não definido)
    }
    
    menoresDist[origem] = 0; // A distância da origem para ela mesma é 0
    
    int[] Q = new int[numVertices]; // Array para controlar os vértices visitados
    
    // Loop principal do algoritmo de Dijkstra
    for(int i = 0; i < numVertices; i++) {
      int u = -1;
      int uDist = Integer.MAX_VALUE;
      
      // Encontra o vértice u não visitado com a menor distância atual
      for(int v = 0; v < numVertices; v++) {
        if(Q[v] == 0 && menoresDist[v] < uDist) {
          u = v;
          uDist = menoresDist[v];
        }
      }
      
      Q[u] = 1; // Marca o vértice u como visitado
      
      // Atualiza as distâncias dos vértices adjacentes ao vértice u
      for(int v = 0; v < numVertices; v++) {
        if(u == v || matrizAdj[u][v] == 0) continue; // Se v é u ou não há aresta entre u e v, continua para o próximo v
        
        int alt = uDist + matrizAdj[u][v]; // Calcula a possível nova distância até v
        
        // Se encontrar um caminho mais curto até v, atualiza menoresDist e anterior
        if(alt < menoresDist[v]) {
          menoresDist[v] = alt;
          anterior[v] = u;
        }
      }
    }
    
    // Reconstrói o caminho mais curto usando a pilha e desenha o caminho encontrado
    Stack<Integer> caminho = new Stack<Integer>(); // Pilha para armazenar o caminho do destino até a origem
    caminho.push(destino); // Inicia com o vértice de destino
    int v = anterior[destino]; // Obtém o vértice anterior ao destino
    
    // Preenche a pilha com os vértices do caminho mais curto
    while (v >= 0) {
      caminho.push(v);
      v = anterior[v];
    }
    
    desenhar(caminho); // Chama a função desenhar para visualizar o caminho encontrado
  }
  
  void desenhar(Stack<Integer> caminho) {
    textAlign(CENTER);
    // Desenha as arestas
    stroke(0);
    strokeWeight(1);
    for (int i = 0; i < numVertices; i++) {
      for (int j = i + 1; j < numVertices; j++) {
        stroke(0);
        if (caminho.contains(i) && caminho.contains(j)) stroke(255,0,0);
        strokeWeight(matrizAdj[i][j]);
        if (matrizAdj[i][j] > 0) line(posicoes[i].x, posicoes[i].y, posicoes[j].x, posicoes[j].y);
      }
    }
    // Desenha os nós
    fill(255);
    stroke(0);
    strokeWeight(1);
    for (int i = 0; i < numVertices; i++) {
      fill(255);
      ellipse(posicoes[i].x, posicoes[i].y, raio * 2, raio * 2);
      fill(0);
      text(str(i), posicoes[i].x, posicoes[i].y+4);
    }
  }
}

Grafo grafo;

void setup() {
  size(800, 600);
  frameRate(60);
  
  int n = 10;
  int[][] adj = new int[n][n];
  
  for(int i = 0; i < n; i++)
    for(int j = 0; j < n; j++){
      if(i == j){
        adj[i][j] = 0;
      }
      else{
        adj[i][j] = random(1) > 0.5 ? int(random(1, 5)) : 0;
        adj[j][i] = adj[i][j];
      }
    }
  
  grafo = new Grafo(adj);
  
}

void draw(){
  background(#F7D7AF);
  grafo.atualizar();
  grafo.Dijkstra(0, 7);
}
