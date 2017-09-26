// Classe pour construire les chemins empruntés par le joueur

class Chemin {
  
  PVector a, b;
  float alpha = 255.0;
  
  boolean disappear = false;
  
  Chemin(PVector a, PVector b) {
    this.a = a;
    this.b = b;
  }
  
  void display() {
    // Calcul de la diminution de l'alpha (peut-être à adpater)
    if (disappear) alpha -= 1.2 / (nbCase / 2);
    stroke(color(255,0,0), alpha);
    strokeWeight((width+height)/(nbCase*50));
    line(a.x * tailleX + tailleX/2, a.y * tailleY + tailleY/2, b.x * tailleX + tailleX/2, b.y * tailleY + tailleY/2);
  }
}