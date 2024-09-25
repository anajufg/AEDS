class Organismo {
  PVector posicao;
  PVector velocidade;
  float[] dna;
  float vida; // Indica a aptidão (quanto mais saúde, melhor)
  float velocidadeMax;
  float percepcao; // Distância máxima para detectar recursos
  float tamanho;
  int sexo;
  
  Organismo(PVector posicao, float[] dna) {
    this.posicao = posicao.copy();
    this.dna = dna;
    this.vida = 200;
    
    // Fenótipo derivado do genótipo (DNA)
    this.velocidadeMax = map(dna[0], 0, 1, 2, 5);
    this.percepcao = map(dna[1], 0, 1, 50, 200);
    this.tamanho = map(dna[2], 0, 1, 6, 12);
    this.velocidade = PVector.random2D();
    this.sexo = (int)(10*(dna[0]+dna[2]));
  }
  
  void atualiza() {
    // Movimento simples
    posicao.add(velocidade);
    // Consume energia ao se mover
    vida -= velocidadeMax/10.0;
    
    // Limites da tela
    if (posicao.x > width) posicao.x = 0;
    if (posicao.x < 0) posicao.x = width;
    if (posicao.y > height) posicao.y = 0;
    if (posicao.y < 0) posicao.y = height;
  }
  
  void procuraComida() {
    PVector maisProximo = null;
    float dist = Float.MAX_VALUE;
    
    for (PVector r : comida) {
      float d = PVector.dist(posicao, r);
      if (d < dist && d < percepcao) {
        dist = d;
        maisProximo = r;
      }
    }
    
    if (maisProximo != null) {
      PVector desejado = PVector.sub(maisProximo, posicao);
      desejado.setMag(velocidadeMax);
      
      PVector direcao = PVector.sub(desejado, velocidade);
      velocidade.add(direcao);
      
      // Se reach o recurso, consome-o
      if (dist < tamanho) {
        vida += 20;
        comida.remove(maisProximo);
      }
    }
  }
  
  Organismo reproduzir() {
    // Reproduz com uma probabilidade baseada na saúde
    if (random(1) < 0.005 && vida > 50) {
      float[] novoDna = new float[3];
      arrayCopy(dna, novoDna);
      
      // mutacao
      for(int k = 0; k < novoDna.length; k++)
        if(random(1) < 0.001) novoDna[k] = constrain(novoDna[k] + random(-0.1, 0.1), 0, 1);
      
      return new Organismo(posicao, novoDna);
    } else {
      return null;
    }
  }
  
  Organismo reproduzir(float[] dnaParceiro) {
    float taxaReproducao = 0.01;
    
    if(populacao.size() > 100) taxaReproducao = 0.001;
    if(populacao.size() < 90) taxaReproducao = 0.05;
    
    if(random(1) < taxaReproducao && vida > 50) {
      float[] novoDna = new float[3];
      novoDna[0] = this.dna[0];
      novoDna[1] = dnaParceiro[1];
      novoDna[2] = dnaParceiro[2];
      
      // mutacao
      for(int k = 0; k < novoDna.length; k++)
        if(random(1) < 0.001) novoDna[k] = constrain(novoDna[k] + random(-0.1, 0.1), 0, 1);
        
      return new Organismo(posicao, novoDna);
    } else {
      return null;
    }
  }
  
  boolean morreu() {
    return vida <= 0;
  }
  
  void mostra() {
    stroke(0);
    colorMode(HSB, 360, 100, 100);
    fill(cor(map(velocidadeMax, 2, 5, 0, 100)));
    ellipse(posicao.x, posicao.y, tamanho, tamanho);
    colorMode(RGB, 255, 255, 255);
  }
  
  color cor(float valor) {
    valor = constrain(valor, 0, 100);
    float matiz = map(valor, 0, 100, 0, 120);
    return color(matiz, 100, 100);
  }
}


// ---------------------------------------------------------
// Parâmetros da Simulação
int tamanhoDaPopulacao = 100;    // Tamanho da população
int geracao = 0;                // Contador de gerações
ArrayList<Organismo> populacao; // Lista de organismos
ArrayList<PVector> comida;      // Lista de recursos
int quantidadeRecursos = 10;   // Número de recursos no ambiente
int tempoDeVida = 100;          // Duração de cada geração em frames
int contadorDeFrames = 0;       // Contador de frames

void setup() {
  size(800, 700);
  populacao = new ArrayList<Organismo>();
  comida = new ArrayList<PVector>();
  
  // Inicializa a população
  for (int i = 0; i < tamanhoDaPopulacao; i++) {
    float[] dna = new float[3];
    for(int k = 0; k < dna.length; k++) dna[k] = random(1);
    populacao.add(new Organismo(new PVector(random(width), random(height)), dna));
  }
  
  // Inicializa os recursos
  for (int i = 0; i < quantidadeRecursos; i++) {
    comida.add(new PVector(random(width), random(height)));
  }
}

void draw() {
  background(#010043);
  noStroke();
  
  // Atualiza e desenha os recursos
  for (PVector r : comida) {
    fill(255);
    ellipse(r.x, r.y, 12, 12);
  }
  
  // Atualiza e desenha os organismos
  for (int i = 0; i < populacao.size(); i++) {
    Organismo o = populacao.get(i);
    o.procuraComida();
    o.atualiza();
    o.mostra();
    
    // Verifica se está morto
    if (o.morreu()) {
      populacao.remove(i);
    } else {
      // Tentativa de reprodução
      for (int j = i+1; j < populacao.size(); j++) {
        Organismo parceiro = populacao.get(j);
        // Verifica se os organismos estão proximos 
        if ((o.posicao.dist(parceiro.posicao)) < (populacao.get(i).tamanho+parceiro.tamanho)) {
          // Verifica se os organismos são de sexos distintos
          if((o.sexo%2==0 && parceiro.sexo%2!=0) || (o.sexo%2!=0 && parceiro.sexo%2==0)) {
            // Tentativa de reprodução
            Organismo filho = o.reproduzir(parceiro.dna);
            if (filho != null) populacao.add(filho);
          }
        }
      }
    }
  }
  
  // Contador de frames para controlar as gerações
  contadorDeFrames++;
  if (contadorDeFrames >= tempoDeVida) {
    novaGeracao();
    contadorDeFrames = 0;
    geracao++;
  }
    
  surface.setTitle("Geração: " + geracao + " | " + "População: " + populacao.size() + " | " + "Recursos: " + comida.size());
}

void novaGeracao() {
  // Reabastece os recursos
  comida.clear();
  for (int i = 0; i < quantidadeRecursos; i++) {
    comida.add(new PVector(random(width), random(height)));
  }
  
}
