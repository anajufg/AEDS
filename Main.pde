import util.ArrayList;

int numPop = 10;
int numComida = 10;
ArrayList<Organismo> populacao = new ArrayList<Organismo>(numPop);
ArrayList<PVector> comida = new ArrayList<Pvetor>(numComida);

void setup() {
  for (int i = 0; i < comida.size(); i++) {
    PVector p = comida.get(i);
  }
}

void draw() {
  background(255);
  
  for (int i = 0; i < comida.size(); i++) {
    PVector p = comida.get(i);
    fill();
    circle(p.x, p.y, 3);
  }
  
  for (Organismo o : 
}
