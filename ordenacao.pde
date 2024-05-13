int n = 20;
int[] array = new int[n];
int i = -1, j = -1, x;

void setup() {
  size(800, 600); // Define o tamanho da tela
  for (int i = 0; i < array.length; i++) {
    array[i] = (int) random(height); // Atribui valores aleatórios ao array
  }

  thread("ordenar"); // Executa paralelamente a função ordernar com a função draw
}

void draw() {
  background(220); // Define a cor de fundo
  int l = width / n; // Defile a largura dos retângulos

  // Determina as cores dos retângulos
  for (int k = 0; k < n; k++) {
    int h = int(array[k]);
    if (k == i || k == j) fill(#14DE9F);
    else if (k == (j - x)) fill(#71EDC6);
    else fill(#DE0B55);
    rect(k * l, height - h, l, h);
    fill(0);
    textAlign(CENTER);
    text(str(n), n * l, height - h - 10, l, h);
  }

  if (mousePressed) {
    for (int k = 0; k < array.length; k++) array[k] = (int) random(height);
  }
}

void ordenar() {
  while (true) shellSort(array); 
}

// ShellSort
void shellSort(int[] array) {
  int n = array.length; // Tamanho do array
  x = 1; 
  
  // Define de quanto em quanto serão feita as primeiras comparações
  while (x < n/3) x = (3*x) + 1;
  
  while (x >= 1) {

    for (i = 0; i < n; i++) {
      int temp = array[i];
      j = i;

      delay(500);
      
      // Compara o valor com outro valor que é x posições distante entre eles
      // Caso necessário, eles trocam de lugar
      while (j >= x && array[j - x] > temp) {
        array[j] = array[j - x]; 
        j = j - x;
      }

      delay(10);

      array[j] = temp;
    }
    
    // A distancia entre as comparações vão diminuindo
    x = x/3;
  }
}
