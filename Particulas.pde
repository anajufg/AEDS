class Particula {
  PVector posicao;
  PVector velocidade;
  color cor;
  int duracaoVida;

  Particula(PVector posicao, PVector velocidade, color cor) {
    this.posicao = posicao;
    this.velocidade = velocidade;
    this.cor = cor;
    duracaoVida = int(random(255));
  }

  void atualizar() {
    posicao.add(velocidade);
    duracaoVida--;
    
    // Reflexao nas bordas
    if (posicao.x < 0 || posicao.x > width)  velocidade.x *= -1;
    if (posicao.y < 0 || posicao.y > height) velocidade.y *= -1;
    
  }

  void exibir() {
    fill(cor, duracaoVida);
    noStroke();
    ellipse(posicao.x, posicao.y, 10, 10);
  }
}









import java.util.*;
import java.util.stream.*;
import java.util.concurrent.atomic.AtomicLong;

List<Particula> particulas = new ArrayList<>();
int maximoParticulas = 500;

// Gerador de Stream
Stream<Particula> fluxoParticula;
Iterator<Particula> iteradorParticula;

void setup() {
  size(800, 600);
  background(0);
  
  fluxoParticula = Stream.iterate(0, n -> n + 1).map(n -> gerarParticulaAleatoria());
  iteradorParticula = fluxoParticula.iterator();
}

void draw() {
  background(0, 25); // Efeito de trilha //<>//

  // Adiciona novas particulas até atingir o maximo
  while (particulas.size() < maximoParticulas && iteradorParticula.hasNext()) {
    Particula novaParticula = iteradorParticula.next();
    particulas.add(novaParticula);
  }
  
 particulas = particulas.stream()
           // Remove particulas que atendem a determinada condicao (exemplo: duracaoVida > 0) usando filter
            .filter(p -> p.duracaoVida > 0)
            .collect(Collectors.toList());

  // Atualiza e exibe todas as particulas usando Streams
 particulas.stream()
            .map(p -> { p.atualizar(); return p; })
            .forEach(Particula::exibir);
           
}

Particula gerarParticulaAleatoria() {
  PVector pos = new PVector(random(width), random(height));
  PVector vel = PVector.random2D().mult(random(1, 3));
  color corAleatoria = color(random(255), random(255), random(255), 200);
  return new Particula(pos, vel, corAleatoria);
}
