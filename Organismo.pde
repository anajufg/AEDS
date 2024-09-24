class Organismo {
  float[] dna;
  PVector pos;
  PVector vel;
  
  float percepcao;
  float velMax;
  float tam;
  
  float vida = 100;
 
 Organismo(float[] dna, PVector pos) {
   this.dna = dna;
   this.pos = pos;
   
   this.vel = new PVector(random(-1, 1), random(-1, 1));
   percepcao = map(dna[0], 0, 1, 0, 50);
   velMax = map(dna[1], 0, 1, 1, 5);
   tam = map(dna[2], 0, 1, 10, 20);
 }
 
 Organismo(PVector pos) {
  dna = new float[3];
  for(int k = 0; k < dna.length; k++) dna[k] = random(-1, 1);
  this.pos = pos;
   
   this.vel = new PVector(random(-1, 1), random(-1, 1));
   percepcao = map(dna[0], 0, 1, 0, 50);
   velMax = map(dna[1], 0, 1, 1, 5);
   tam = map(dna[2], 0, 1, 10, 20);
   
 }
 
 void atualiza() {
   pos.add(vel);
   vida -= 0.1;
   
   if (pos.x > width) {
     pos.x = width;
     vel.x = -vel.x;
   }
   if (pos.x < 0) {
     pos.x = 0;
     vel.x = -vel.x;
   }
   if (pos.y > height) {
     pos.y = height;
     vel.y = -vel.y;
   }
   if (pos.y < 0) {
     pos.y = 0;
     vel.y= -vel.y;
   }
 }
 
 void mostra() {
  fill(map(dna[1], 0, 1, 0, 255));
  circle(pos.x, pos.y, tam);
 }  
}
