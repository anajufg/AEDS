import java.util.LinkedList;

LinkedList<Bola> bolas;

class Bola {
 int x;
 int y;
 float vy;
 float ay;
 int r = 100;
 
 Bola(int x, int y) {
   this.x = x;
   this.y = y;
   vy = 0;
   ay = 0.1;
 }
 
 void Update() {
   vy = vy + ay;
   y = y + (int)vy; // frameRate
   
   if (y >= height) {
     vy = -0.9*vy; 
     y = height;
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
