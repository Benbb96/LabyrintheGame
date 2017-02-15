
// Fonction à l'appui d'une touche
public void keyPressed() {
  // Activation/Désactivation des ennemis
  if (key == 'e') {
    if (ai) ai = false;
    else ai = true;
  }
  // Ajouter des ennemis
  else if (key == '+') {
    aiplayers.add(new AIPlayer());
  }
  // Retirer des ennemis
  else if (key == '-') {
    if (aiplayers.size() > 0) aiplayers.remove(aiplayers.size() - 1);
  }
  // Faire réapparaître les murs
  else if (key == 'a') {
    labyrinthe.resetAlpha();
  }
  // Faire apparaître/Disparaître les points tracés par le joueur
  else if (key == 'p') {
    if (point) point = false;
    else point = true;
  }
  // Gérer la musique
  else if (key == 'm') {
    if (musicIsPlaying) {
      music.stop();
      musicIsPlaying = false;
    } else {
      music.loop();
      musicIsPlaying = true;
    }
  }
  else if (key == CODED) {
    // Fonctions de déplacement du joueur
    player.move(keyCode);
    if (keyCode == CONTROL) {
      //afficherTableau(matrice, nbCase * nbCase);
      afficherTableau(grille, nbCase);
    }
  }
}

// Fonction au clic de souris
public void mousePressed() {
  if(overPlayer) { 
    moving = true;
  }
}

// Fonction au relachement du clic
public void mouseReleased() {
  moving = false;
}

// Fonction qui fait passer le jeu au niveau supérieur
public void levelUp() {
  timer = millis() - start; //On récupère le temps du joueur à ce niveau
  int sec = timer / 1000;
  int ms = timer % 1000;
  if (sec > 60) { // S'il a fait plus d'une minute, on a un affichage différent
    int min = sec / 60;
    sec = sec % 60;
    println("Vous avez passé le niveau " + (niveau) + " en " + min + " minute(s) et " + sec + "," + ms + " seconde(s).");
  } else {
    println("Bravo, vous avez passé le niveau " + (niveau) + " en " + sec + "," + ms + " seconde(s).");
  }
  
  // Crée le score du joueur et l'ajoute
  Score score = new Score(niveau,timer,name);
  saveJSONArray(scores, "data/scores.json");
  
  niveau++; //La fonction ne s'appelle pas level Up pour rien !
  
  //Le nombre de case augmente d'un
  nbCase++;
  
  // Création d'un nouveau Labyrtinthe
  labyrinthe = new Labyrinthe();
  
  // Repositionnement du joueur et des IAs
  player.repositionne(0, 0);
  for (int i = 0; i < aiplayers.size(); i++) {
    AIPlayer aiPlayer = aiplayers.get(i);
    aiPlayer.randomPosition();
  }
  
  // Création d'une nouvelle IA au niveau 4 puis au 6 puis au 8 et à tous les niveaux
  if (niveau % 4 == 0) {
    aiplayers.add(new AIPlayer());
  }
  
  start = millis();
}

// Fonction appelée si le joueur se fait touché par l'une des IAs
public void gameOver() {
  timer = millis() - start; //On récupère le temps du joueur
  int sec = timer / 1000;
  int ms = timer % 1000;
  if (sec > 60) { // S'il a fait plus d'une minute, on a un affichage différent
    int min = sec / 60;
    sec = sec % 60;
    println("Oups ! Vous vous êtes fait mangé par une IA au bout de " + min + " minute(s) et " + sec + "," + ms + " seconde(s).");
  } else {
    println("Aie ! Vous vous êtes fait mangé par une IA au bout de " + sec + "," + ms + " seconde(s).");
  }
  
  //Le nombre de case revient à 2 et le niveau est à 1
  nbCase = 2;
  niveau = 1;
  
  // Création d'un nouveau Labyrtinthe
  labyrinthe = new Labyrinthe();
  
  // Repositionnement du joueur et des IAs
  player.repositionne(0, 0);
  
  //On vide la liste des IAs
  aiplayers.clear();
  
  //On redémarre le compteur
  start = millis();
}

//Affiche les valeurs contenus dans un tableau à 2 dimensions
void afficherTableau(int[][] array, int size) {
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      print(array[i][j] + " | ");
    }
    println();
  }
}