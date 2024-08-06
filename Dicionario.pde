import java.util.HashMap;

// Armazena as cores das células preenchidas
HashMap<String, Integer> coresCelulas;

// Array com as sores possíveis
color[] cores = {color(0), color(0, 255, 0), color(255, 0, 0), color(0, 0, 255), color(#F7F720), color(255)};

// Variáveis de controle da visualização
float zoom = 1.0;
float deslocamentoX = 0;
float deslocamentoY = 0;
int tamanhoCelula = 50;

// Variáveis para controle de arrasto
boolean estaArrastando = false;
float inicioArrasteX, inicioArrasteY;

void setup() {
  size(800, 800);
  coresCelulas = new HashMap<String, Integer>();
  noLoop(); // Desativa o loop contínuo do draw()
}

void draw() {
  background(255); // Fundo branco
  desenharGrade();
}

void desenharGrade() {
  stroke(240); // Cor cinza bem claro para as linhas da grade
  
  float tamanhoEfetivoCelula = tamanhoCelula * zoom;
  
  // Calcula os limites da grade visível na tela
  int inicioX = floor((deslocamentoX - width/2) / tamanhoEfetivoCelula) - 1;
  int fimX = ceil((deslocamentoX + width/2) / tamanhoEfetivoCelula) + 1;
  int inicioY = floor((deslocamentoY - height/2) / tamanhoEfetivoCelula) - 1;
  int fimY = ceil((deslocamentoY + height/2) / tamanhoEfetivoCelula) + 1;
  
  // Desenha cada célula da grade
  for (int x = inicioX; x <= fimX; x++) {
    for (int y = inicioY; y <= fimY; y++) {
      // Calcula a posição da célula na tela
      float telaX = x * tamanhoEfetivoCelula - deslocamentoX + width/2;
      float telaY = y * tamanhoEfetivoCelula - deslocamentoY + height/2;
      
      // Gera a chave única para cada célula
      String chave = x + "," + y;
      
      // Determina a cor da célula (branco se não estiver preenchida)
      int corCelula = coresCelulas.containsKey(chave) ? coresCelulas.get(chave) : color(255);
      
      // Desenha a célula
      fill(corCelula);
      rect(telaX, telaY, tamanhoEfetivoCelula, tamanhoEfetivoCelula);
    }
  }
}

void mousePressed() {
  estaArrastando = false;
  inicioArrasteX = mouseX;
  inicioArrasteY = mouseY;
}

void mouseDragged() {
  float distanciaArraste = dist(inicioArrasteX, inicioArrasteY, mouseX, mouseY);
  if (distanciaArraste > 5) { // Considera como arrasto se mover mais de 5 pixels
    estaArrastando = true;
    // Atualiza o deslocamento baseado no movimento do mouse
    deslocamentoX -= (mouseX - pmouseX) / zoom;
    deslocamentoY -= (mouseY - pmouseY) / zoom;
    redraw(); // Redesenha a tela para refletir o novo deslocamento
  }
}

void mouseReleased() {
  if (!estaArrastando) {
    // Converte a posição do mouse para coordenadas do mundo
    float mundoX = (mouseX - width/2 + deslocamentoX) / zoom;
    float mundoY = (mouseY - height/2 + deslocamentoY) / zoom;
    
    // Calcula a posição da célula na grade
    int gradeX = floor(mundoX / tamanhoCelula);
    int gradeY = floor(mundoY / tamanhoCelula);
    
    String chave = gradeX + "," + gradeY;
    
    if (mouseButton == LEFT) {
      // Obtem a cor atyal da celula
      int corAtual = coresCelulas.get(chave);
      int corIndex = -1;
      
      // Obtem a cor da celula escolhida por meio array de cores
      for(int i = 0; i < cores.length; i++) {
        //////////////////////////////////////////////////////////////////////
      }
      
      int novaCor = color(0);
      coresCelulas.put(chave, novaCor);
    } else if (mouseButton == RIGHT) {
      // Botão direito: apaga a célula (remove a cor)
      coresCelulas.remove(chave);
    }
    
    redraw(); // Redesenha a tela para mostrar as mudanças
  }
}

void mouseWheel(MouseEvent evento) {
  float fatorEscala = 1.05;
  // Aumenta ou diminui o zoom baseado na direção da rolagem
  float novoZoom = (evento.getCount() < 0) ? zoom * fatorEscala : zoom / fatorEscala;
  
  // Limita o zoom entre 0.1 e 5.0
  novoZoom = constrain(novoZoom, 0.1, 5.0);
  
  // Calcula a posição do mouse antes e depois do zoom para manter o ponto sob o cursor fixo
  float mouseXAntesZoom = (mouseX - width/2) / zoom + deslocamentoX;
  float mouseYAntesZoom = (mouseY - height/2) / zoom + deslocamentoY;
  
  zoom = novoZoom;
  
  float mouseXAposZoom = (mouseX - width/2) / zoom + deslocamentoX;
  float mouseYAposZoom = (mouseY - height/2) / zoom + deslocamentoY;
  
  // Ajusta o deslocamento para manter o ponto sob o cursor fixo
  deslocamentoX += mouseXAntesZoom - mouseXAposZoom;
  deslocamentoY += mouseYAntesZoom - mouseYAposZoom;
  
  redraw(); // Redesenha a tela com o novo nível de zoom
}
