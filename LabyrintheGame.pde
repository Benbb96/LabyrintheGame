// Générateur de Labyrinthe
// Jeu crée et développé par Benjamin Bernard-Bouissières

// Le but du jeu est évidemment de traverser des labyrinthes qui sont génénés aléatoirement grâce
// à un algorithme appelé le Recursive Backtracker (voir sur http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking)

// Instanciation des variables globales
Player player;
int niveau = 1,
    delai = 0;

// Taille par défaut de la fenêtre
final int
  DEFAULT_WIDTH = 444,
  DEFAULT_HEIGHT = 444;

// Valeurs de défaut du jeu pouvant être altérés par les différents modes
int nbCaseDefaut,
    incrementationDefaut;

int nbCase;  // Nombre de case actuel
float
  tailleX,  // Taille largeur en pixel d'une case
  tailleY;  // Taille hauteur en pixel d'une case

Labyrinthe labyrinthe;  // Le labyrinthe du jeu
int[][] matrice;  // Matrice d'adjacence du jeu pour savoir si on a le droit de se déplacer d'une case à l'autre ou non
int[][] grille;  // Grille qui va nous servir pour la construction du labyrinthe

color backgroundColor = color(4),  // Couleur du fond de jeu
      wallColor = color(244);  // Couleur des murs du labyrinthe
boolean disappear = false;  // Permet de choisir si les murs du labyrinthe disparaissent ou non

// Les différents états du jeu
final int
  MENU = 1,
  GAME = 4,
  LEVEL_UP = 44,
  GAME_OVER = 13,
  PAUSE = 10;
int state = MENU;  // La variable de l'état de jeu servant à déterminer quel écran afficher

// Les différents modes de jeu
final int
  EASY = 1,
  MEDIUM = 2,
  HARD = 3,
  BLIND = 4;
int mode;  // La variable du mode de jeu pour définir les paramètres de jeu

// Les boutons du menus
Button[] buttons;
int selectedButton;

// Les sélecteurs de couleurs
ColorPicker backgroundColorPicker, wallColorPicker;

// Les lignes d'animations pour l'écran d'accueil
MovingLine[] lines = new MovingLine[4];

// Le timer qui sera utilisé pour chronométrer le temps passé dans un labyrinthe
Timer timer;

// ============================================================================================================================================

void settings() {
  size(DEFAULT_WIDTH, DEFAULT_HEIGHT);
}

void setup() {
  backgroundColor = color(4);
  
  wallColor = color(244);
  background(backgroundColor);
  
  //Construction des boutons du menu
  buttons = new Button[4];  // Tableau des boutons
  buttons[0] = new Button(0, "Easy", width/4, (height*5/9), EASY, color(0,255, 0));
  buttons[1] = new Button(1, "Medium", width/4, (height*6/9), MEDIUM, color (255,165,0));
  buttons[2] = new Button(2, "Hard", width/4, (height*7/9), HARD, color(255,0,0));
  buttons[3] = new Button(3, "Blind", width/4, (height*8/9), BLIND, color(60,60,255));
  buttons[1].selected = true;  // Le mode medium est sélectionné par défaut
  selectedButton = 1;
  
  // Construction des ColorPickers
  backgroundColorPicker = new ColorPicker(20, 20, wallColor);
  wallColorPicker = new ColorPicker(20, 60, backgroundColor);
  
  // Construction des Moving Lines avec leurs animations prédéfinis
  lines[0] = new MovingLine(new PVector(0, 1), new PVector(1, 0), new IntList(4,0,4,6,4,4,3, 4,2,2,6,5,1,2, 2,0,2,5,2,2,1, 2,4,4,5,6,3,4));
  lines[1] = new MovingLine(new PVector(2, 0), new PVector(0, 1), new IntList(4,2,2,6,5,1,2, 2,0,2,5,2,2,1, 2,4,4,5,6,3,4, 4,0,4,6,4,4,3));
  lines[2] = new MovingLine(new PVector(1, 1), new PVector(0, 1), new IntList(3,0,4,4,5,2,0, 1,0,2,2,6,4,0));
  lines[3] = new MovingLine(new PVector(1, 2), new PVector(1, 0), new IntList(4,5,1,6,3,5,1, 2,6,3,5,1,6,3));
}

void draw() {
  
  //A quelle état sommes-nous ?
  switch (state) {
    
    case MENU :
      // Affichage du menu
      background(backgroundColor);
      fill(wallColor);
      textAlign(RIGHT);
      textSize(width/13);
      text("Le Labyrinthe Infini", width - 30, height/3);
      
      drawAnimatedMaze();
            
      // Affichage des boutons
      for (int i = 0; i < 4; i++) {
        buttons[i].display();
      }
      
      // Color Picker
      fill(wallColor);
      textAlign(LEFT);
      textSize(12);
      text("Couleur de fond", 50, 35);
      text("Couleur des murs", 50, 75);
      backgroundColorPicker.display();
      wallColorPicker.display();
      break;
      
    case GAME :
      // Raffraichissement de la couleur de fond
      background(backgroundColor);
      
      // Déplacement du joueur via les touches du clavier
      if (keyPressed && key == CODED) {
        player.move(keyCode);
        delay(delai);
      }
      
      displayGame(false);  // On affiche le jeu et on n'empêche pas le joueur de bouger
      break;
      
    case LEVEL_UP :
      background(backgroundColor);
      displayGame(true);
      popUp("Bravo !\nNiveau " + niveau + "\nTemps : " + timer.getDisplay() + "\nAppuiez sur Entrée\n Ou cliquez pour continuer");
      break;
      
    case GAME_OVER :
      background(backgroundColor);
      displayGame(true);
      popUp("Game Over !\nNiveau " + niveau + "\nAppuiez sur Entrée\n Ou cliquez pour revenir au menu");
      break;
      
    case PAUSE :
      background(backgroundColor);
      displayGame(true);
      popUp("Pause\nNiveau " + niveau + "\nTemps : " + timer.getDisplay() + "\nAppuiez sur Entrée\npour revenir au menu");
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
          timer.pause();  // On met le timer en pause
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
        timer.restart();  // On relance le timer
        state = GAME;
      }
      break;
  }
}

// Fonction au clic de souris
void mousePressed() {
  switch (state) {
    case MENU :
      // Clique pour ouvrir le color picker du fond
      if (backgroundColorPicker.openColorPicker()) {
        if (wallColorPicker.ShowColorPicker) {  // Si celui pour les murs est déjà ouvert, on le referme
          wallColorPicker.ShowColorPicker = false;
        } 
        if (backgroundColorPicker.ShowColorPicker) backgroundColorPicker.ShowColorPicker = false;
        else backgroundColorPicker.ShowColorPicker = true;
      }
      // Clique pour ouvrir le color picker des murs
      else if (wallColorPicker.openColorPicker()) {
        if (backgroundColorPicker.ShowColorPicker) {  //  Si celui pour le fond est déjà ouvert, on le referme
          backgroundColorPicker.ShowColorPicker = false;
        }
        if (wallColorPicker.ShowColorPicker) wallColorPicker.ShowColorPicker = false;
        else wallColorPicker.ShowColorPicker = true;
      } else if (!backgroundColorPicker.ShowColorPicker && !wallColorPicker.ShowColorPicker) {
        for (int i = 0; i < 4; i++) {
          if (buttons[i].mouseOver()) {
            buttons[i].chargeMode();
            runGame();
          }
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
      if (mode == BLIND) {
        disappear = true;  // On remet la disparition des murs
      }
      timer.restart();  // On relance le timer
      state = GAME;
      break;
    case GAME_OVER : gameOver(); break;
  }
}

// Fonction lors du relachement du clic de la souris
void mouseReleased() {
  backgroundColorPicker.isDraggingCross = false;
  backgroundColorPicker.isDraggingLine = false;
  wallColorPicker.isDraggingCross = false;
  wallColorPicker.isDraggingLine = false;
  
  if (backgroundColorPicker.closeColorPicker()) {
    backgroundColorPicker.ShowColorPicker = false;
    backgroundColor = backgroundColorPicker.activeColor;
  } else if (wallColorPicker.closeColorPicker()) {
    wallColorPicker.ShowColorPicker = false;
    wallColor = wallColorPicker.activeColor;
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
  
  timer = new Timer(); // Enfin, on instancie et démarre le timer
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
  timer = new Timer();  // On crée un nouveau timer pour ce nouveau niveau
  state = GAME;
}

// Fonction de transition pour revenir au menu correctement
void gameOver() {
  niveau = 1;  // Reset le niveau
  surface.setSize(DEFAULT_WIDTH, DEFAULT_HEIGHT);
  surface.setResizable(false);  // Ne plus retoucher à la taille de l'écran
  
  // Remise à 0 des Moving Lines
  lines[0] = new MovingLine(new PVector(0, 1), new PVector(1, 0), new IntList(4,0,4,6,4,4,3, 4,2,2,6,5,1,2, 2,0,2,5,2,2,1, 2,4,4,5,6,3,4));
  lines[1] = new MovingLine(new PVector(2, 0), new PVector(0, 1), new IntList(4,2,2,6,5,1,2, 2,0,2,5,2,2,1, 2,4,4,5,6,3,4, 4,0,4,6,4,4,3));
  lines[2] = new MovingLine(new PVector(1, 1), new PVector(0, 1), new IntList(3,0,4,4,5,2,0, 1,0,2,2,6,4,0));
  lines[3] = new MovingLine(new PVector(1, 2), new PVector(1, 0), new IntList(4,5,1,6,3,5,1, 2,6,3,5,1,6,3));
  
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
  strokeWeight(4);
  translate(220,220);
  rect(0,0,180,180);
  for (int i = 0; i < 4; i++) {
    lines[i].show();
  }
  popMatrix();
}