import processing.sound.*;

// Générateur de Labyrinthe
// Jeu crée et développé par Benjamin Bernard-Bouissières

// Le but du jeu est évidemment de traversé des labyrinthes qui sont génénés aléatoirement grâce à un algorithme appelé le Recursive Backtracker
//   (voir sur http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking)
// Le jeu commence au niveau 1 avec un labyrinthe de 2 par 2 et à chaque fois que le joueur atteint la case rouge, un nouveau labyrinthe apparaît
// mais cette fois de dimension 3 par 3 et ainsi de suite de manière infini.
// Le joueur est chronométré à chaque labyrtinthe.
// Une intelligence artificielle, représenté par des pions rouges, rajoute une difficulté supplémentaire en essayant d'attraper le joueur en le faisant recommencer du début.

// Améliorations :
//    - Tracer le chemin qu'emprunte le joueur
//    - Mettre un fond ? Animation construction du labyrinthe.
//    - Amélioration de l'IA -> Algorithme de Disjktra -> déplacement à un point random pour une impression de cohérence dans les mouvements.
//      L'IA pourrait faire un déplacement à chaque fois que le joueur se déplace (Pokemon Donjon Mystère)
//    - Cases Abri pour se protéger des IA (dans les coins ?)
//    - Ajout d'objets à collecter (Pouvoirs, score, ...)
//    - Création d'un menu de jeu
//    - Gestion des meilleurs scores dans un fichier
//    - Ajout de différents sons
//    - Etendre le labyrinthe de part et d'autre au lieu d'en générer un nouveau


// Instanciation des variables globales
Player player;
int niveau = 1;

ArrayList<AIPlayer> aiplayers = new ArrayList(); //liste des IAs
boolean ai = true; //Permet d'activer ou de désactiver les IAs

int nbCase = 2; //Nombre de case
float tailleX; //Taille largeur en pixel d'une case
float tailleY; //Taille hauteur en pixel d'une case
int start, timer; //Timer pour chronométré le joueur

Labyrinthe labyrinthe; //Le labyrinthe du jeu
int[][] matrice; //Matrice d'adjacence du jeu pour savoir si on a le droit de se déplacer sur une case ou non
int[][] grille; //Grille qui va nous servir pour la construction du labyrinthe

boolean overPlayer = false; //Pour savoir si la souris est au-dessus du joueur
boolean moving = false; //Lorsque le joueur est est en déplacement

SoundFile music; //Musique de fond
boolean musicIsPlaying = false; //Permet de savoir si la musique est en train d'être joué ou non

void setup() {
  // Mise en place du terrain jeu
  size(400,400);
  surface.setResizable(true);
  background(255);
  
  // Calcul de la taille d'une case
  tailleX = width/nbCase;
  tailleY = height/nbCase;
  
  // Création du Labyrtinthe
  labyrinthe = new Labyrinthe();
  
  // Création du joueur
  player = new Player();
  
  // Load a soundfile from the /data folder of the sketch and play it back
  music = new SoundFile(this, "music.mp3");
  music.play();
  music.stop();
  //music.loop();
  musicIsPlaying = true;
  
  start = millis();
}

void draw() {
  // Recalcul de la taille d'une case
  tailleX = width/nbCase;
  tailleY = height/nbCase;
  
  //Fonction d'affichage du terrain de jeu
  afficheTerrain();
  
  // Mise à jour du joueur
  player.update(); //Met à jour la position du joueur
  
  //Mise à jour des IAs
  for (int i = 0; i < aiplayers.size(); i++) {
    AIPlayer aiPlayer = aiplayers.get(i);
    aiPlayer.update();
  }
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
  // Information sur la case départ du niveau du labyrinthe
  fill(0);
  text(niveau, tailleX/3, tailleY - tailleY/3);
  
  labyrinthe.display();
}