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

int[][] matrice; //Matrice d'adjacence du jeu pour savoir si on a le droit de se déplacer sur une case ou non
int[][] grille; //Grille qui va nous servir pour la construction du labyrinthe

ArrayList<Wall> walls = new ArrayList();

void setup() {
  // Mise en place duterrain jeu
  size(400,400);
  surface.setResizable(true);
  background(255);
  
  // Calcul de la taille d'une case
  tailleX = width/nbCase;
  tailleY = height/nbCase;
  
  // Création du Labyrtinthe
  newLabyrinthe();
  
  // Création du joueur
  player = new Player();
}

void draw() {
  // Recalcul de la taille d'une case
  tailleX = width/nbCase;
  tailleY = height/nbCase;
  
  //Fonction d'affichage du terrain de jeu
  afficheTerrain();
  
  // Mise à jour du joueur
  player.update(); //Met à jour la position du joueur
}

void afficheTerrain() {
   background(255);
  //Cases Départ Vert et Arrivée Rouge
  noStroke();
  fill(color(0,255,0));
  rect(0, 0, tailleX, tailleY);
  fill(color(255,0,0));
  rect(width - tailleX, height - tailleY, tailleX, tailleY);
  textSize(tailleY / 2);
  fill(0);
  text(niveau, tailleX/3, tailleY - tailleY/3);
  
  stroke(1);
  strokeWeight(3);
  grid(); //Trace une grille pour bien voir les cases
  
  //Affichage des murs
  for (int i = 0; i < walls.size(); i++) {
    Wall wall = walls.get(i);
    wall.display();
  }
  
  //Affichage des points de déplacements
    for (int i = 0; i < nbCase; i++) {
      for (int j = 0; j < nbCase; j++) {
        if (grille[j][i] == 1) {
          pushStyle();
          fill(grille[j][i]%255,grille[j][i]%255,255);
          noStroke();
          ellipse(i * tailleX + tailleX/2, j * tailleY + tailleY/2, tailleX/10, tailleY/10);
          popStyle();
        }
      }
    }
}

// Fonction de traçage d'une grille de jeu en fonction du nombre de case
void grid() {
  //Lignes verticales
  for (int i=1; i < width/tailleX; i++) {
    line(i*tailleX, 0, i*tailleX, height);
  }
  //Lignes Horizontales
  for (int i=1; i < height/tailleY; i++) {
    line(0, i*tailleY, width, i*tailleY);
  }
}

// Fonction à l'appui d'une touche
void keyPressed() {
  if (key == CODED) {
    // Fonctions de déplacement du joueur
    player.move(keyCode);
  } else if (key == 'r') {
    gameOver();
  } else if (key == 'l') {
    levelUp();
  }
}

// Fonction qui fait passer le jeu au niveau supérieur
void levelUp() {
  niveau++; //La fonction ne s'appelle pas level Up pour rien !
  //Le nombre de case augmente de 3
  nbCase+=3;
  // Création d'un nouveau Labyrtinthe
  newLabyrinthe();
  // Repositionnement du joueur
  player.repositionne(0, 0);
}

// Fonction appelé si le joueur se fait touché par l'une des IAs
void gameOver() {
  nbCase = 3;
  niveau = 1;
  newLabyrinthe();
  player.repositionne(0, 0);
}

void newLabyrinthe() {
  walls.clear();
  matrice = new int[nbCase*nbCase][nbCase*nbCase];
  grille = new int[nbCase][nbCase];
  creuse_passage(0, 0);
  grille = new int[nbCase][nbCase]; //On remet à 0 la grille pour renseigner ensuite par où est passer le joueur
  drawMaze();
}