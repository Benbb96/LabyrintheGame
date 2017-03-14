//Le gestionnaire du labyrinthe

//North (UP - 38) => Y-1
//South (DOWN - 40) => Y+1
//West (LEFT - 37) => X-1
//East (RIGHT - 39) => X+1

//Fonction récursive qui permet de creuser le labyrinthe
void creuse_passage (int cx, int cy) {
  //println("Creuse Passage depuis " + cx + "," + cy);
  IntList directions = newDirectionList();
  int direction;
  // On va tester chaque direction une à une
  for (int i = 0; i < 4; i++) {
    direction = directions.get(i);
    // Quelle est la case qu'on souhaite atteindre
    int nx = cx + newX(direction);
    int ny = cy + newY(direction);
    
    //Est-elle sur la grille (entre 0 et le nombre de case) et a-t-elle été déjà vu ?
    if ( ((ny >= 0 && ny < nbCase) && (nx >= 0 && nx < nbCase)) && grille[nx][ny] == 0 ) {
      // Elle est accessible donc on mets à jour nos différentes matrices
      grille[cx][cy] = direction; //Sur la cellule sur laquelle on se trouve, on met la direction où l'on va
      grille[nx][ny] = opposite(direction); //Sur la cellule sur laquelle on va arriver, on met la direction opposé vers où l'on va
      
      //Et on ajoute des 1 dans la matrice d'adjacence pour que le joueur sache qu'il peut atteindre cette cellule à partir de celle-ci
      matrice[two2one(cx,cy)][two2one(nx,ny)] = 1;
      matrice[two2one(nx,ny)][two2one(cx,cy)] = 1;
      
      // Enfin on appelle donc à nouveau cette même fonction qui va continuer de creuser à partir de cette nouvelle case atteinte
      creuse_passage(nx, ny);
    }
  } //Et cela donc pour chaque direction
}

//Crée une liste d'entier représentant les 4 directions et rangés dans le désordre
IntList newDirectionList() {
  IntList list = new IntList();
  for (int i = LEFT; i <= DOWN; i++) list.append(i);
  list.shuffle(); //Mélange les nombres/directions
  return list;
}

// Fonction qui calcul quelle sera le nouveau x en fonction de la direction
int newX(int direction) {
  int n = 0;
  if(direction == LEFT) n = -1;
  else if (direction == RIGHT) n = 1;
  return n;
}

// Fonction qui calcul quelle sera le nouveau y en fonction de la direction
int newY(int direction) {
  int n = 0;
  if(direction == UP) n = -1;
  else if (direction == DOWN) n = 1;
  return n;
}

// Fonctions de correspondances entre le tableau 2 dimension et une dimension
int two2one(int x, int y) {
  return x * nbCase + y;
}

PVector one2two(int n) {
  PVector coordonnee = new PVector();
  coordonnee.x = n / nbCase;
  coordonnee.y = n % nbCase;
  return coordonnee;
}

//Retourne la direction opposé
int opposite(int direction) {
  switch(direction) {
    case UP : return DOWN;
    case DOWN : return UP;
    case LEFT : return RIGHT;
    case RIGHT : return LEFT;
    default: return 0;
  }
}

//Fonction qui dessine le labyrinthe, ou plus précisément, qui efface les traits noirs là ou le joueur peut passer
void drawMaze() {
  int ax,ay,bx,by; //Case A et B adjacente
  //On va parcourir notre matrice d'adjacence jusqu'à trouver des 1 signifiant qu'il y a un passage
  for (int i = 0; i < nbCase*nbCase; i++) {
    for (int j = i; j < nbCase*nbCase; j++) {
      if(matrice[i][j] == 1) {
        ax = i / nbCase;
        ay = i % nbCase;
        bx = j / nbCase;
        by = j % nbCase;
        walls.add(new Wall(bx, by, ax+1, ay+1));
      }
    }
  }
}