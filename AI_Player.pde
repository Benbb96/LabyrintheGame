//La classe de l'intelligence artificielle qui apparaît à partir du niveau 4

class AIPlayer extends Player {
  IntList directions = new IntList(); //liste des directions
  
  // Le méchant commence sur une case au hasard mais assez loin du joueur quand même
  AIPlayer () {
    super();
    //Initialisation des directions dans l'ordre (sens horaire)
    for (int i = LEFT; i <= DOWN; i++) directions.append(i);
    
    randomPosition(); //La position de l'IA est aléatoire sur la grille, mais pas trop proche du joueur
    
    couleur = color(255,0,0); //Les IAs ont une couleure rouge... Evidemment
  }
  
  void update() {
    //Remise à jour de la taille du joueur
    sizeX = tailleX/2;
    sizeY = tailleY/2;
    
    //Réflexion de l'IA pour savoir où elle va aller
    if (frameCount % 30 == 0) think();
    if (frameCount % 250 == 0) directions.reverse(); //Ajoute plus d'imprévisibilité
    
    // Mise à jour de sa position à partir de la position sur la grille de jeu
    updateLocation();
    
    //Vérification si l'IA touche le joueur
    checkTouched();
    
    //Affiche le'IA
    fill(couleur);
    strokeWeight(2);
    stroke(0);
    ellipse(location.x, location.y, sizeX, sizeY);
  }
  
  //Remet à jour la position réelle de l'IA en pixel à partir de sa position dans la grille de jeu
  void updateLocation() {
    location = new PVector(posOnGrid.x * tailleX + sizeX, posOnGrid.y * tailleY + sizeY);
  }
  
  void think() {
    switch(directions.get(0)) {
      case UP :
        if (posOnGrid.y > 0  && matrice[posOnMatrice()][(int)posOnGrid.x * nbCase + (int)posOnGrid.y-1] == 1) posOnGrid.y--;
        else {
          //randomDirection();
          directions.remove(0);
          directions.append(UP);
          think();
        }
        break;
      case DOWN :
        if (posOnGrid.y < nbCase-1 && matrice[posOnMatrice()][(int)posOnGrid.x * nbCase + (int)posOnGrid.y+1] == 1) posOnGrid.y++;
        else {
          //randomDirection();
          directions.remove(0);
          directions.append(DOWN);
          think();
        }
        break;
      case LEFT :
        if (posOnGrid.x > 0 && matrice[posOnMatrice()][((int)posOnGrid.x-1) * nbCase + (int)posOnGrid.y] == 1) posOnGrid.x--;
        else {
          //randomDirection();
          directions.remove(0);
          directions.append(LEFT);
          think();
        }
        break;
      case RIGHT :
        if (posOnGrid.x < nbCase-1 && matrice[posOnMatrice()][((int)posOnGrid.x+1) * nbCase + (int)posOnGrid.y] == 1) posOnGrid.x++;
        else {
          //randomDirection();
          directions.remove(0);
          directions.append(RIGHT);
          think();
        }
        break;
    }
  }
  
  void checkTouched() {
    if (posOnGrid.x == player.posOnGrid.x && posOnGrid.y == player.posOnGrid.y) {
      gameOver();
    }
  }
  
  /*
  void nextDirection() {
    switch(directions.get(0)) {
      case UP : //directions.get(0)
    }
  }
  */
  
  void randomPosition() {
    posOnGrid.x = (int)random(2, nbCase-1);
    posOnGrid.y = (int)random(2, nbCase-1);
  }
  
}