// Classe pour construire les murs du labyrinthe

class Wall {
  
  PVector a; //Point A du mur (en haut à gauche)
  PVector b; //Point B du mur (en bas à droite)
  float alpha = 255.0;
  
  Wall(float ax, float ay, float bx, float by) {
    a = new PVector(ax, ay);
    b = new PVector(bx, by);
  }
  
  void display() {
    // Calcul de la diminution de l'alpha (peut-être à adpater)
    if (labyrinthe.disappear) alpha -= 1.2 / (nbCase / 2);
    stroke(0, alpha);
    strokeWeight((width+height)/(nbCase*40));
    line(a.x * tailleX, a.y * tailleY, b.x * tailleX, b.y * tailleY);
  }
  
}