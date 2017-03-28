// Classe pour construire les chemins empruntés par le joueur
class Chemin {
  
  PVector a; //Point A du mur (en haut à gauche)
  PVector b; //Point B du mur (en bas à droite)
  float alpha = 255.0;
  
  Chemin(PVector a, PVector b) {
    this.a = a;
    this.b = b;
  }
  
  void display() {
    // Calcul de la diminution de l'alpha (peut-être à adpater)
    alpha -= 1.2 / (nbCase / 2);
    stroke(color(68, 44, 200), alpha);
    strokeWeight((width+height)/(nbCase*80));
    /*
    println("tailleX = ", tailleX);
    println("ax = ", a.x * tailleX + tailleX/2);
    println("ay = ", a.y * tailleY + tailleY/2);
    println("bx = ", b.x * tailleX + tailleX/2);
    println("by = ", b.y * tailleY + tailleY/2);
    */
    line(a.x * tailleX + tailleX/2, a.y * tailleY + tailleY/2, b.x * tailleX + tailleX/2, b.y * tailleY + tailleY/2);
  }
  
}