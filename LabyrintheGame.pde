// Générateur de Labyrinthe
// Jeu crée et développé par Benjamin Bernard-Bouissières

// Le but du jeu est évidemment de traversé des labyrinthes qui sont génénés aléatoirement grâce
// à un algorithme appelé le Recursive Backtracker (voir sur http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking)

// Instanciation des variables globales
Player player;
int niveau = 1;

int nbCase = 3; //Nombre de case
float tailleX; //Taille largeur en pixel d'une case
float tailleY; //Taille hauteur en pixel d'une case

Labyrinthe labyrinthe; //Le labyrinthe du jeu
int[][] matrice; //Matrice d'adjacence du jeu pour savoir si on a le droit de se déplacer sur une case ou non
int[][] grille; //Grille qui va nous servir pour la construction du labyrinthe

void setup() {
  // Mise en place du terrain de jeu
  size(444,444);
  surface.setResizable(true);
  background(255);
  
  // Calcul de la taille d'une case
  tailleX = width/nbCase;
  tailleY = height/nbCase;
  
  // Création du Labyrtinthe
  labyrinthe = new Labyrinthe();
  
  // Création du joueur
  player = new Player();
}

void draw() {
  // Recalcul de la taille d'une case
  tailleX = width/nbCase;
  tailleY = height/nbCase;
  
  //Fonction d'affichage du terrain de jeu
  afficheTerrain();
  
  //Déplacement du joueur via les touches du clavier
  if (keyPressed && key == CODED) {
    player.move(keyCode);
    delay(44);
  }
  
  // Mise à jour du joueur
  player.update(); //Met à jour la position du joueur
}

void afficheTerrain() {
  background(255);
  //Cases Départ Vert et Arrivée Rouge
  noStroke();
  fill(color(0, 255, 0));
  rect(0, 0, tailleX, tailleY);
  fill(color(255, 0, 0));
  rect(tailleX * (nbCase-1), tailleY * (nbCase-1), tailleX, tailleY);
  textSize(tailleY / 2);
  // Information sur la case départ du niveau du labyrinthe
  fill(0);
  text(niveau, tailleX/3, tailleY - tailleY/3);
  
  // Carré du terrain de jeu
  strokeWeight((width+height)/(nbCase*40));
  stroke(0);
  line(0, 0, tailleX * nbCase, 0);
  line(0, 0, 0,  tailleY * nbCase);
  line(tailleX * nbCase, 0, tailleX * nbCase, tailleY * nbCase-1);
  line(0, tailleY * nbCase, tailleX * nbCase, tailleY * nbCase);

  //Affichage du labyrinthe
  labyrinthe.display();
}

// Fonction à l'appui d'une touche
void keyPressed() {
  if (key == 'r') {
    gameOver();
  } else if (key == 'l') {
    levelUp();
  }
  else if (key == 'p') {
    player.point = player.point ? false : true;
  }
  else if (key == 'c') {
    player.chemin = player.chemin ? false : true;
  }
  else if (key == 'a') {
    player.point = false;
    labyrinthe.resetAlpha();
  }
  else if (key == 'd') {
    labyrinthe.disappear = labyrinthe.disappear ? false : true;
  }
}

// Fonction au clic de souris
public void mousePressed() {
  if(!player.isMoving && player.overPlayer) {
    player.isMoving = true;
  } else {
    player.isMoving = false;
  }
}

// Fonction qui fait passer le jeu au niveau supérieur
public void levelUp() {  
  niveau++; //La fonction ne s'appelle pas level Up pour rien !
  //Le nombre de case augmente d'un
  nbCase += 3;
  // Création d'un nouveau Labyrtinthe
  labyrinthe = new Labyrinthe();
  player.repositionne(0, 0);
  player.isMoving = false;
}

// Fonction appelée si le joueur se fait touché par l'une des IAs
public void gameOver() {
  //Le nombre de case revient à 2 et le niveau est à 1
  nbCase = 3;
  niveau = 1;
  // Création d'un nouveau Labyrtinthe et repositionnement du joueur
  labyrinthe = new Labyrinthe();
  player.repositionne(0, 0);
  player.isMoving = false;
}