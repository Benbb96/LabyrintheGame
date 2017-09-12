// Classe pour construire les murs du labyrinthe

class Wall {
  
  PVector a,  // Point A du mur (haut / gauche)
          b;  // Point B du mur (bas / droite)
  float alpha = 255.0;  // Transparence du mur
  
  Wall(float ax, float ay, float bx, float by) {
    a = new PVector(ax, ay);
    b = new PVector(bx, by);
  }
  
  void display() {
    // Calcul de la diminution de l'alpha (peut-être à adpater)
    if (disappear) alpha -= 1.2 / (nbCase / 2);
    if (alpha < niveau * -10) state = GAME_OVER;  // Si tous les murs ont disparu depuis un certain temps, le joueur a perdu
    stroke(wallColor, alpha);
    strokeWeight((width+height)/(nbCase*40));
    line(a.x * tailleX, a.y * tailleY, b.x * tailleX, b.y * tailleY);
  }
  
}