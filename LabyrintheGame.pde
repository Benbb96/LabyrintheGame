// Générateur de Labyrinthe
// Jeu crée et développé par Benjamin Bernard-Bouissières

// Le but du jeu est évidemment de traverser des labyrinthes qui sont génénés aléatoirement grâce
// à un algorithme appelé le Recursive Backtracker (voir sur http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking)

// Instanciation des variables globales
Player player;
int niveau = 1;

int nbCase = 3;  // Nombre de case
float tailleX;  // Taille largeur en pixel d'une case
float tailleY;  // Taille hauteur en pixel d'une case

Labyrinthe labyrinthe;  // Le labyrinthe du jeu
int[][] matrice;  // Matrice d'adjacence du jeu pour savoir si on a le droit de se déplacer sur une case ou non
int[][] grille;  // Grille qui va nous servir pour la construction du labyrinthe

color backgroundColor = color(0, 0, 0);
color wallColor = color(255, 255, 255);

int mode = 1;
final int MENU = 1;
final int NORMAL_MODE = 4;
final int LEVEL_UP = 10;
final int GAME_OVER = 13;

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
  
  //Dans quelle mode sommes-nous ?
  switch (mode) {
    case MENU :
      // Affichage du menu
      background(backgroundColor);
      fill(wallColor);
      textSize(width/20);
      text("The Labyrinthe Game", width/3,height/3);
      break;
      
    case NORMAL_MODE :
      // Raffraichissement de la couleur de fond
      background(backgroundColor);
      // Affichage du labyrinthe
      labyrinthe.display();
      
      // Déplacement du joueur via les touches du clavier
      if (keyPressed && key == CODED) {
        player.move(keyCode);
        delay(44);
      }
      
      // Mise à jour du joueur
      player.update();  //Met à jour la position du joueur
      break;
      
    case LEVEL_UP :
      background(backgroundColor);
      labyrinthe.display();
      player.update();
      popUp("Bravo !\nAppuiez sur Entrer pour continuer");
      break;
      
    case GAME_OVER :
      background(backgroundColor);
      labyrinthe.display();
      player.update();
      popUp("Game Over !\nAppuiez sur Entrée pour revenir au menu");
      break;
      
    default : background(255,0,0);
  }
}

// Fonction à l'appui d'une touche
void keyPressed() {
  // Cela dépend du mode de jeu dans lequel on est 
  if (mode == NORMAL_MODE) {
    switch(key) {
      case 'r' : mode = GAME_OVER; break;  // RESET
      case 'l' : levelUp(); break;
      case 'p' : player.point = player.point ? false : true; break;
      case 'c' : player.chemin = player.chemin ? false : true; break;
      case 'a' : labyrinthe.resetAlpha(); break;
      case 'd' : labyrinthe.disappear = labyrinthe.disappear ? false : true; break;
      case 'w' : println(player.posOnMatrice()); break;
    }
  } else if (mode == MENU && key == ENTER) {
    mode = NORMAL_MODE;
  }  else if (mode == LEVEL_UP && key == ENTER) {
    levelUp();
  } else if (mode == GAME_OVER && key == ENTER) {
    gameOver();
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
  niveau++;  //La fonction ne s'appelle pas level Up pour rien !
  // Le nombre de case augmente d'un
  nbCase += 3;
  // Resize la fenêtre correctement
  surface.setSize((width/nbCase + 1) * nbCase, (height/nbCase + 1) * nbCase);
  // Création d'un nouveau Labyrtinthe
  labyrinthe = new Labyrinthe();
  player.repositionne(labyrinthe.startCase.x, labyrinthe.startCase.y);
  player.isMoving = false;
  
  mode = NORMAL_MODE;
}

// Fonction appelée si le joueur se fait touché par l'une des IAs ou que le jeu est reset
public void gameOver() {
  // Le nombre de case revient à 3 et le niveau est à 1
  nbCase = 3;
  niveau = 1;
  surface.setSize(444, 444);
  // Création d'un nouveau Labyrtinthe et repositionnement du joueur
  labyrinthe = new Labyrinthe();
  player.repositionne(labyrinthe.startCase.x, labyrinthe.startCase.y);
  player.isMoving = false;
  
  mode = MENU;
}

// Fonction permettant l'affichage d'une pop-up un peu transparente avec un message
public void popUp(String message) {
  pushStyle();
  fill(255,255,255,200);
  stroke(0);
  strokeWeight(3);
  rect(width/5, height/5, (width*3)/5, (height*3)/5);
  fill(0);
  textSize(width/30);
  textAlign(CENTER, CENTER);
  text(message, width/2, height/2);
  popStyle();
}