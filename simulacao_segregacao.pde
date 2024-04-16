int[][] grid; 
int tamanho = 100; 

void setup() {
  size(600, 600); // Tamanho do quadro
  frameRate(100); // Velocidade do frame
  grid = criaGrid(); // Cria um grid
}

// Funcao que cria um grid
int[][] criaGrid() {
  int[][] grid_tmp = new int[tamanho][tamanho]; 
  int morador;

  for (int linha = 0; linha < tamanho; linha++) {
    for (int coluna = 0; coluna < tamanho; coluna++) {

      grid_tmp[linha][coluna] = 0; // Inicializa o quadrado com zero
      
      morador = (int)random(6); // Sorteia um numero de 0 a 6
      
      // Caso o numero sorteado seja 1, o quadrado passa a valer 1
      if (morador == 1)grid_tmp[linha][coluna] = 1;
      
      // Caso o numero sorteado seja 2, o quadrado passa a valer 2
      if (morador == 2)grid_tmp[linha][coluna] = 2;
      
      // Desta forma, ha mais espacos vazios
    }
  }

  return grid_tmp; // Retorna o grid
}

// Funcao que mostra um grid
void mostraGrid() {
  float largura = width/(float)tamanho;
  float altura = height/(float)tamanho;

  for (int linha = 0; linha < tamanho; linha++) {
    for (int coluna = 0; coluna < tamanho; coluna++) {

      stroke(200); // Cor do contorno do quadrado
      
      if (grid[linha][coluna] == 0)fill(255); // quadrado branco
      if (grid[linha][coluna] == 1)fill(0, 255, 0); //quadrado verde
      if (grid[linha][coluna] == 2)fill(0, 0, 255); // quadrado azul
      
      rect(coluna*largura, linha*altura, largura, altura); // Define o tamanho do quadrado
    }
  }
}

// Funcao que soma os vizinhos iguais
int vizinhosIguais(int linha, int coluna) {
  int soma = 0;

// Analisa os vizinhos
  for (int i = -1; i < 2; i++) {
    for (int j = -1; j < 2; j++) {
      // Caso o vizinho seja igual o morador, soma 1
      if (grid[(tamanho+linha+i)%tamanho][(tamanho+coluna+j)%tamanho] == grid[linha][coluna])soma++;
      // grid[(tamanho+linha+i)%tamanho][(tamanho+coluna+j)%tamanho] >>> compara somente a linha e coluna positiva 
    }
  }

  return soma - 1; // Retorna a soma dos vizinhos iguais
}

// Funcao que atualiza o grid
void atualizaGrid(){
  int[][] novoGrid = new int[tamanho][tamanho];
  int viz;
  
  // Analisa cada morador
  for(int linha = 0; linha < tamanho; linha++){
    for(int coluna = 0; coluna < tamanho; coluna++){
      viz = vizinhosIguais(linha,coluna);
      
      if (grid[linha][coluna] != 0) { 
        
        // Caso o morador tenha menos de 4 vizinhos iguais, ele se muda
        if(viz < 4) {
        
          // So sai do while se achar uma lugar para morar
          while(true) {
            int ki = (int)random(tamanho);
            int kj = (int)random(tamanho);
            
            if (grid[ki][kj] == 0 && novoGrid[ki][kj] == 0) {
              // Caso tenha um lugar vazio tanto no velho grid quanto novo grid, 
              // o morador se muda para la
              // e o lugar que ela estava fica vazio
              novoGrid[ki][kj] = grid[linha][coluna];
              novoGrid[linha][coluna] = 0;
              
              break;
            }
          }
        } else {
          // Caso ele esteja satisfeito ou o lugar esta vazio, ele permanece no mesmo lugar
          novoGrid[linha][coluna] = grid[linha][coluna];
        }
      }
    }
  }
  
  grid = novoGrid;
}

void draw() {
  mostraGrid();
  atualizaGrid();

  if (mousePressed) grid = criaGrid();
}
