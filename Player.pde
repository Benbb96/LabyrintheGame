//La classe du Joueur

class Player {
 
  PVector location; //La position réel sur l'écran (en pixel)
  PVector posOnGrid; //La position du joueur sur la grille
  float sizeX; //La taille largeur du joueur
  float sizeY; //La taille hauteur du joueur
  
  boolean overPlayer = false; //Pour savoir si la souris est au-dessus du joueur
  boolean isMoving = false; //Lorsque le joueur est est en déplacement
  boolean point = false; //Affichage des points de marquage du chemin du joueur
  boolean chemin = true; //Affichage des chemins empruntés par le joueur
  
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
    if (isMoving) {
      tryMoving();
    }
    location = new PVector(posOnGrid.x * tailleX + sizeX, posOnGrid.y * tailleY + sizeY);
  }
  
  // Fonction d'actualisation du joueur, sa taille, sa position et s'il a atteint son but
  void update() {
    //Remise à jour de la taille du joueur
    sizeX = tailleX/2;
    sizeY = tailleY/2;
    
    // Test si le curseur de la souris est au-dessus du joueur
    if (mouseX > location.x - sizeX/2 && mouseX < location.x + sizeX/2 && 
      mouseY > location.y - sizeY/2 && mouseY < location.y + sizeY/2) {
      overPlayer = true;
    } else {
      overPlayer = false;
    }
    
    // Mise à jour de sa position à partir de la position sur la grille de jeu et affichage
    updateLocation();
    display();
    //Vérification si le joueur est sur la dernière case
    checkFinish();
  }
  
  //Affiche le joueur
  void display() {
    pushStyle();
    if (isMoving) fill(230,150,70);
    else fill(couleur);
    if (overPlayer && !isMoving) strokeWeight((width+height)/(nbCase*40));
    else strokeWeight((width+height)/(nbCase*60));
    stroke(0);
    ellipse(location.x, location.y, sizeX, sizeY);
    popStyle();
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
    PVector oldPosOnGrid = new PVector(posOnGrid.x, posOnGrid.y);
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
    
    if (canGoThere) {
      if (grille[int(posOnGrid.y)][int(posOnGrid.x)] == 0) {
        grille[int(posOnGrid.y)][int(posOnGrid.x)] = 1;
        labyrinthe.chemins.add(new Chemin(oldPosOnGrid, new PVector(posOnGrid.x, posOnGrid.y)));
      }
    }
    
  }
  
  //Repositionne le joueur à l'endroit souhaité
  void repositionne(int x, int y) {
    posOnGrid.x = x;
    posOnGrid.y = y;
  }
  
  // Retourne le numéro de la case sur laquelle se positionne le joueur
  // Exemple : il y a 3 cases de largeur, le joueur est sur la 2ème case de la 3ème ligne (1,2), il est donc sur la 7ème case de la grille (2*3 + 1 = 7)
  int posOnMatrice() {
    return (int)posOnGrid.x * nbCase + (int)posOnGrid.y;
  }
  
  //Essaye de faire bouger le joueur à l'aide de la souris
  void tryMoving() {
    //Récupère les coordonnées de la position de la souris
    int x = floor(mouseX/tailleX);
    int y = floor(mouseY/tailleY);
    
    //Appelle la fonction de déplacement dans la direction où se trouve la souris par rapport au joueur
    move(getDirection(x, y));
  }
  
  //Retourne la direction à une case d'écart par rapport à la position donné en paramètre et la position du joueur
  int getDirection(int x, int y) {
    //Calcul d'où souhaite-t-on se rendre
    int targetX = int(x - posOnGrid.x);
    int targetY = int(y - posOnGrid.y);
    
    //Retourne la direction en fonction
    if(targetX == 1) return RIGHT;
    if(targetX == -1) return LEFT;
    if(targetY == 1) return DOWN;
    if(targetY == -1) return UP;
    return 0;
  }
  
}