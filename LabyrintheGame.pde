import processing.sound.*;

// Générateur de Labyrinthe
// Jeu crée et développé par Benjamin Bernard-Bouissières

// Instanciation des variables globales
Player player;
String name = "BBB"; //Le nom du joueur
int niveau = 1;

ArrayList<AIPlayer> aiplayers = new ArrayList(); //liste des IAs
boolean ai = false; //Permet d'activer ou de désactiver les IAs

int nbCase = 2; //Nombre de case
float tailleX; //Taille largeur en pixel d'une case
float tailleY; //Taille hauteur en pixel d'une case
int start, timer; //Timer pour chronométré le joueur

Labyrinthe labyrinthe; //Le labyrinthe du jeu
int[][] matrice; //Matrice d'adjacence du jeu pour savoir si on a le droit de se déplacer sur une case ou non
int[][] grille; //Grille qui va nous servir pour la construction du labyrinthe

boolean overPlayer = false; //Pour savoir si la souris est au-dessus du joueur
boolean moving = false; //Lorsque le joueur est est en déplacement
boolean point = true; //Affichage des points de marquage du chemin du joueur

SoundFile music; //Musique de fond
boolean musicIsPlaying = true; //Permet de savoir si la musique est en train d'être joué ou non

JSONArray scores;

void setup() {
  //Récupération des scores
  scores = loadJSONArray("scores.json");
  
  // Mise en place du terrain jeu
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
  
  // Load a soundfile from the /data folder of the sketch and play it back
  music = new SoundFile(this, "music.mp3");
  if (musicIsPlaying) {
    music.loop();
  }
  
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
  
  if (ai) {
    //Mise à jour des IAs
    for (int i = 0; i < aiplayers.size(); i++) {
      AIPlayer aiPlayer = aiplayers.get(i);
      aiPlayer.update();
    }
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
  
  //Affichage du labyrinthe
  labyrinthe.display();
}