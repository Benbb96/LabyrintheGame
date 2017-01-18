// Classe pour construire les murs du labyrinthe

class Wall {
  
  PVector a; //Point A du mur (en haut à gauche)
  PVector b; //Point B du mur (en bas à droite)
  
  Wall(float ax, float ay, float bx, float by) {
    a = new PVector(ax, ay);
    b = new PVector(bx, by);
  }
  
  void display() {
    stroke(0);
    strokeWeight((width+height)/(nbCase*40));
    line(a.x * tailleX, a.y * tailleY, b.x * tailleX, b.y * tailleY);
  }
  
}