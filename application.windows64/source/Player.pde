//La classe du Joueur

class Player {
 
  PVector location; //La position réel sur l'écran (en pixel)
  PVector posOnGrid; //La position du joueur sur la grille
  float sizeX; //La taille largeur du joueur
  float sizeY; //La taille hauteur du joueur
  
  color couleur = color(255,255,0); //La couleur du joueur, par défaut jaune
  
  Player () {
    //Calcul de la taille du joueur
    sizeX = tailleX/2;
    sizeY = tailleY/2;
    
    //Le joueur commence sur la première case en haut à gauche (0,0)
    posOnGrid = new PVector(0,0);
    //posOnGrid = new PVector((int)random(nbCase),(int)random(nbCase)); //Random
    
    //On met à jour sa position réel
    updateLocation();
  }
  
  //Remet à jour la position réelle du joueur en pixel à partir de sa position dans la grille de jeu
  void updateLocation() {
    location = new PVector(posOnGrid.x * tailleX + sizeX, posOnGrid.y * tailleY + sizeY);
  }
  
  // Fonction d'actualisation du joueur, sa taille, sa position et s'il a atteint son but
  void update() {
    //Remise à jour de la taille du joueur
    sizeX = tailleX/2;
    sizeY = tailleY/2;
    // Mise à jour de sa position à partir de la position sur la grille de jeu
    updateLocation();
    checkFinish();
    //Affiche le joueur
    fill(couleur);
    strokeWeight(2);
    stroke(0);
    ellipse(location.x, location.y, sizeX, sizeY);
  }
  
  // Vérifie si le joueur a atteint le point d'arrivée
  void checkFinish() {
    if (posOnGrid.x == nbCase-1 && posOnGrid.y == nbCase-1) {
      levelUp();
    }
  }
  
  // Fonction de déplacement qui vérifie si le déplacement peut se faire (limites du terrain et les murs)
  void move(int direction) {
    boolean canGoThere = true;
    switch(direction) {
      case UP :
        if (posOnGrid.y > 0 && matrice[posOnMatrice()][(int)posOnGrid.x * nbCase + (int)posOnGrid.y-1] == 1) posOnGrid.y--;
        else canGoThere = false;
        break;
      case DOWN :
        if (posOnGrid.y < nbCase-1 && matrice[posOnMatrice()][(int)posOnGrid.x * nbCase + (int)posOnGrid.y+1] == 1) posOnGrid.y++;
        else canGoThere = false;
        break;
      case LEFT :
        if (posOnGrid.x > 0 && matrice[posOnMatrice()][((int)posOnGrid.x-1) * nbCase + (int)posOnGrid.y] == 1) posOnGrid.x--;
        else canGoThere = false;
        break;
      case RIGHT :
        if (posOnGrid.x < nbCase-1 && matrice[posOnMatrice()][((int)posOnGrid.x+1) * nbCase + (int)posOnGrid.y] == 1) posOnGrid.x++;
        else canGoThere = false;
        break;
    }
    
    if (canGoThere) { //Jouer un son quand le joueur se déplace
      grille[int(posOnGrid.y)][int(posOnGrid.x)] = 1;
    }
  }
  
  //Repositionne le joueur à l'endroit souhaité
  void repositionne(int x, int y) {
    posOnGrid.x = x;
    posOnGrid.y = y;
  }
  
  // Retourne le numéro de la case sur laquelle se positionne le joueur
  // Exemple : il y a 3 cases de largeur, le joueur est sur la 1ère case de la 3ème ligne (3,0)
  int posOnMatrice() {
    return (int)posOnGrid.x * nbCase + (int)posOnGrid.y;
  }
  
}