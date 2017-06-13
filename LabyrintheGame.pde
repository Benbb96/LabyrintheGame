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

color backgroundColor = color(0, 0, 0);
color wallColor = color(255, 255, 255);

void setup() {
  // Mise en place du terrain de jeu
  size(444,444);
  surface.setResizable(true);
  background(backgroundColor);
  
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
  
  //Raffraichissement de la couleur de fond
  background(backgroundColor);
  
  //Affichage du labyrinthe
  labyrinthe.display();
  
  //Déplacement du joueur via les touches du clavier
  if (keyPressed && key == CODED) {
    player.move(keyCode);
    delay(44);
  }
  
  // Mise à jour du joueur
  player.update(); //Met à jour la position du joueur
}

// Fonction à l'appui d'une touche
void keyPressed() {
  switch(key) {
    case 'r' : gameOver(); break;
    case 'l' : levelUp(); break;
    case 'p' : player.point = player.point ? false : true; break;
    case 'c' : player.chemin = player.chemin ? false : true; break;
    case 'a' : labyrinthe.resetAlpha(); break;
    case 'd' : labyrinthe.disappear = labyrinthe.disappear ? false : true; break;
    case 'w' : println(player.posOnMatrice());
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
  // Resize la fenêtre correctement
  surface.setSize((width/nbCase + 1) * nbCase, (height/nbCase + 1) * nbCase);
  // Création d'un nouveau Labyrtinthe
  labyrinthe = new Labyrinthe();
  player.repositionne(labyrinthe.startCase.x, labyrinthe.startCase.y);
  player.isMoving = false;
}

// Fonction appelée si le joueur se fait touché par l'une des IAs
public void gameOver() {
  //Le nombre de case revient à 2 et le niveau est à 1
  nbCase = 3;
  niveau = 1;
  surface.setSize(444, 444);
  // Création d'un nouveau Labyrtinthe et repositionnement du joueur
  labyrinthe = new Labyrinthe();
  player.repositionne(labyrinthe.startCase.x, labyrinthe.startCase.y);
  player.isMoving = false;
}