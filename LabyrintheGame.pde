// Générateur de Labyrinthe
// Jeu crée et développé par Benjamin Bernard-Bouissières

// Le but du jeu est évidemment de traverser des labyrinthes qui sont génénés aléatoirement grâce
// à un algorithme appelé le Recursive Backtracker (voir sur http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking)

// Instanciation des variables globales
Player player;
int niveau = 1;
int delai = 0;

// Taille par défaut de la fenêtre
final int DEFAULT_WIDTH = 444;
final int DEFAULT_HEIGHT = 444;
// Valeurs de défaut du jeu pouvant être altérés par les différents modes
int nbCaseDefaut;
int incrementationDefaut;

int nbCase;  // Nombre de case actuel
float tailleX;  // Taille largeur en pixel d'une case
float tailleY;  // Taille hauteur en pixel d'une case

Labyrinthe labyrinthe;  // Le labyrinthe du jeu
int[][] matrice;  // Matrice d'adjacence du jeu pour savoir si on a le droit de se déplacer sur une case ou non
int[][] grille;  // Grille qui va nous servir pour la construction du labyrinthe

color backgroundColor = color(4);  // Couleur du fond de jeu
color wallColor = color(244);  // Couleur des murs du labyrinthe
boolean disappear = false;  // Permet de choisir si les murs du labyrinthe disparaissent ou non

// Les différents états du jeu
final int MENU = 1;
final int GAME = 4;
final int LEVEL_UP = 44;
final int GAME_OVER = 13;
final int PAUSE = 10;
int state = MENU;  // La variable de l'état de jeu servant à déterminer quel écran afficher

// Les différents modes de jeu
final int EASY = 1;
final int MEDIUM = 2;
final int HARD = 3;
final int BLIND = 4;
int mode;  // La variable du mode de jeu pour définir les paramètres de jeu

// Les boutons du menus
Button[] buttons;
int selectedButton;

// ============================================================================================================================================

void settings() {
  size(DEFAULT_WIDTH, DEFAULT_HEIGHT);
}

void setup() {
  // Mise en place du terrain de jeu
  background(backgroundColor);
  
  //Construction des boutons du menu
  buttons = new Button[4];  // Tableau des boutons
  buttons[0] = new Button(0, "Easy", width/4, (height*6/10), EASY, color(0,255, 0));
  buttons[1] = new Button(1, "Medium", width/4, (height*7/10), MEDIUM, color (255,165,0));
  buttons[2] = new Button(2, "Hard", width/4, (height*8/10), HARD, color(255,0,0));
  buttons[3] = new Button(3, "Blind", width/4, (height*9/10), BLIND, color(60,60,255));
  buttons[1].selected = true;  // Le mode medium est sélectionné par défaut
  selectedButton = 1;
}

void draw() {
  
  //A quelle état sommes-nous ?
  switch (state) {
    
    case MENU :
      // Affichage du menu
      background(backgroundColor);
      fill(wallColor);
      textAlign(RIGHT);
      textSize(width/17);
      text("Le Labyrinthe Infini", width - 30, height/4);
      textAlign(LEFT);
      textSize(width/15);
      text("Jouer", width/9, (height*5/10));
      
      drawAnimatedMaze();
            
      // Affichage des boutons
      for (int i = 0; i < 4; i++) {
        buttons[i].display();
      }
      break;
      
    case GAME :
      // Raffraichissement de la couleur de fond
      background(backgroundColor);
      
      // Déplacement du joueur via les touches du clavier
      if (keyPressed && key == CODED) {
        player.move(keyCode);
        delay(delai);
      }
      
      displayGame(false);  // On affiche le jeu et on empêche pas le joueur de bouger
      break;
      
    case LEVEL_UP :
      background(backgroundColor);
      displayGame(true);
      popUp("Bravo !\nAppuiez sur Entrer\n Ou cliquez pour continuer");
      break;
      
    case GAME_OVER :
      background(backgroundColor);
      displayGame(true);
      popUp("Game Over !\nAppuiez sur Entrée\n Ou cliquez pour revenir au menu");
      break;
      
    case PAUSE :
      background(backgroundColor);
      displayGame(true);
      popUp("Pause\nAppuiez sur Entrée\n Ou cliquez pour revenir au menu");
      break;
      
    default : background(255,0,0);
  }
}

// Fonction de recalcul de la taille du case en fonction de la taille de la fenêtre
void updateCaseSize() {
  tailleX = width/nbCase;
  tailleY = height/nbCase;
}

// Fonction affichant correctement le terrain de jeu et défini si le joueur peut bouger ou non
void displayGame(boolean stopPlayer) {
  updateCaseSize();  // Recalcul de la taille d'une case
  labyrinthe.display();  // Affichage du labyrinthe
  player.update();  //Met à jour la position du joueur
  if (stopPlayer) {
    player.isMoving = false;  // On empêche le joueur de bouger pendant les différents menus
  }
}

// Fonction à l'appui d'une touche
void keyPressed() {
  switch (state) {
    case MENU :
      // A l'appui de la touche Entrée, on charge le mode sélectionné
      if (key == ENTER) {
        for (int i = 0; i < 4; i++) {
          if (buttons[i].selected) {
            buttons[i].chargeMode();
            runGame();
          }
        }
      } else if (key == CODED) {
        // Sélection des boutons du menu avec les touches du clavier
        if (keyCode == UP && selectedButton > 0) {
          buttons[selectedButton].selected = false;
          selectedButton--;
          buttons[selectedButton].selected = true;
        } else if (keyCode == DOWN && selectedButton < 3) {
          buttons[selectedButton].selected = false;
          selectedButton++;
          buttons[selectedButton].selected = true;
        }
      }
      break;
    case GAME :
      switch(key) {
        // Déplacement du joueur avec ZQSD
        case 'z' : player.move(UP); break;
        case 's' : player.move(DOWN); break;
        case 'q' : player.move(LEFT); break;
        case 'd' : player.move(RIGHT); break;
        case 'r' : state = GAME_OVER; break;  // RESET
        case 'l' : levelUp(); break;
        case 'p' : player.point = player.point ? false : true; break;
        case 'c' : player.chemin = player.chemin ? false : true; break;
        case 'a' : labyrinthe.resetAlpha(); break;
        case 'b' : disappear = disappear ? false : true; break; //Active le BLIND mode
        case 'w' : println(player.posOnMatrice()); break;
        case ESC :
          // La touche Echap permet de mettre le jeu en pause
          key = 0;  // Empêche le jeu de se fermer
          if (mode == BLIND) {  // Dans ce mode on stoppe la disparition des murs
            disappear = false;
          }
          state = PAUSE;
          break;
      }
      break;
    case LEVEL_UP :
      if (key == ENTER) {
        levelUp();
      }
      break;
    case GAME_OVER :
      if (key == ENTER) {
        gameOver();
      }
      break;
    case PAUSE :
      if (key == ENTER) {
        gameOver();  // Le jeu est terminé, on appelle donc Game Over
      } else if (key == ESC) {
        key = 0;
        if (mode == BLIND) {
            disappear = true;  // On remet la disparition des murs
          }
        state = GAME;
      }
      break;
  }
}

// Fonction au clic de souris
void mousePressed() {
  switch (state) {
    case MENU :
    for (int i = 0; i < 4; i++) {
        if (buttons[i].selected) {
          buttons[i].chargeMode();
          runGame();
        }
      }
      break;
    case GAME :
      // Si le joueur essaye de déplacer son personnage en cliquant sur celui-ci
      if (!player.isMoving && player.overPlayer) {
        player.isMoving = true;
      } else {
        player.isMoving = false;
      }
      break;
    case LEVEL_UP : levelUp(); break;
    case PAUSE :
    case GAME_OVER : gameOver(); break;
  }
}

// Fonction qui permet de lancer le jeu
void runGame() {
  // Calcul de la taille d'une case
  updateCaseSize();
  
  // Création du Labyrtinthe
  labyrinthe = new Labyrinthe();
  
  // Création du joueur
  player = new Player();
  
  state = GAME;  // On passe à l'état de Jeu
  surface.setResizable(true);  // Et on permet de redimmensionner la fenêtre
}

// Fonction qui fait passer le jeu au niveau supérieur
void levelUp() {  
  niveau++;  // La fonction ne s'appelle pas level Up pour rien !
  nbCase += incrementationDefaut;
  // Resize la fenêtre correctement
  surface.setSize((width/nbCase + 1) * nbCase, (height/nbCase + 1) * nbCase);
  // Création d'un nouveau Labyrtinthe
  labyrinthe = new Labyrinthe();
  player.repositionne(labyrinthe.startCase.x, labyrinthe.startCase.y);
  player.isMoving = false;
  
  if (mode == BLIND) {  // On remet la disparition des murs
    disappear = true;
  }
  state = GAME;
}

// Fonction de transition pour revenir au menu correctement
void gameOver() {
  niveau = 1;  // Reset le niveau
  surface.setSize(DEFAULT_WIDTH, DEFAULT_HEIGHT);
  surface.setResizable(false);  // Ne plus retoucher à la taille de l'écran
  
  state = MENU; // On retourne au Menu si Game Over
}

// Fonction permettant l'affichage d'une pop-up un peu transparente avec un message
void popUp(String message) {
  pushStyle();
  fill(255,255,255,200);
  stroke(0);
  strokeWeight(3);
  rect(width/5, (height*2/6), (width*3)/5, (height*2)/6);
  fill(0);
  textSize(width/30);
  textAlign(CENTER, CENTER);
  text(message, width/2, height/2);
  popStyle();
}

// Fonction pour afficher le labyrinthe animé de l'écran de démarrage
void drawAnimatedMaze() {
  pushMatrix();
  noFill();
  stroke(wallColor);
  strokeWeight(3);
  translate(220,220);
  rect(0,0,180,180);
  line(0,60,60,60);
  line(60,60,60,120);
  line(60,120,120,120);
  line(120,0,120,60);
  popMatrix();
}