import java.util.LinkedList;

LinkedList<Bola> bolas;

class Bola {
 int x;
 int y;
 float vy;
 float ay;
 int r;
 
 Bola(int x, int y) {
   this.x = x;
   this.y = y;
   vy = 0;
   ay = 0.1;
   r = 100;
 }
 
 void Update() {
   y = y + (int)vy;
   vy = vy + ay;
   
   if (y >= height-r/2) {
     vy = -0.9*vy; 
     y = height-r/2;
   }
 }
 
 void Show() {
   fill(#DB8331);
   ellipse(x, y, r, r);
   Update();
 }
}

void setup() {
  size(600, 600);
  bolas = new LinkedList<Bola>();
}

void mouseReleased() {
  bolas.add(new Bola(mouseX, mouseY));
}
void draw() {
  background(#74B8FF);
  
  for (int i = 0; i < bolas.size(); i++) {
   bolas.get(i).Show();
  }
}
