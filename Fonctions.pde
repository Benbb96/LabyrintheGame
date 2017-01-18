
// Fonction \u00e0 l'appui d'une touche
public void keyPressed() {
  if (key == CODED) {
    // Fonctions de d\u00e9placement du joueur
    player.move(keyCode);
    if (keyCode == CONTROL) {
      afficherTableau(matrice, nbCase * nbCase);
      //afficherTableau(grille, nbCase);
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

// Fonction qui fait passer le jeu au niveau sup\u00e9rieur
public void levelUp() {
  timer = millis() - start; //On r\u00e9cup\u00e8re le temps du joueur \u00e0 ce niveau
  int sec = timer / 1000;
  int ms = timer % 1000;
  if (sec > 60) { // S'il a fait plus d'une minute, on a un affichage diff\u00e9rent
    int min = sec / 60;
    sec = sec % 60;
    println("Vous avez pass\u00e9 le niveau " + (niveau) + " en " + min + " minute(s) et " + sec + "," + ms + " seconde(s).");
  } else {
    println("Bravo, vous avez pass\u00e9 le niveau " + (niveau) + " en " + sec + "," + ms + " seconde(s).");
  }
  niveau++; //La fonction ne s'appelle pas level Up pour rien !
  
  //Le nombre de case augmente d'un
  nbCase++;
  
  // Cr\u00e9ation d'un nouveau Labyrtinthe
  newLabyrinthe();
  
  // Repositionnement du joueur et des IAs
  player.repositionne(0, 0);
  for (int i = 0; i < aiplayers.size(); i++) {
    AIPlayer aiPlayer = aiplayers.get(i);
    aiPlayer.randomPosition();
  }
  
  // Cr\u00e9ation d'une nouvelle IA au niveau 4 puis au 6 puis au 8 et \u00e0 tous les niveaux
  if (niveau % 4 == 0) {
    if (ai) aiplayers.add(new AIPlayer());
  }
  
  start = millis();
}

// Fonction appel\u00e9 si le joueur se fait touch\u00e9 par l'une des IAs
public void gameOver() {
  timer = millis() - start; //On r\u00e9cup\u00e8re le temps du joueur
  int sec = timer / 1000;
  int ms = timer % 1000;
  if (sec > 60) { // S'il a fait plus d'une minute, on a un affichage diff\u00e9rent
    int min = sec / 60;
    sec = sec % 60;
    println("Oups ! Vous vous \u00eates fait mang\u00e9 par une IA au bout de " + min + " minute(s) et " + sec + "," + ms + " seconde(s).");
  } else {
    println("Aie ! Vous vous \u00eates fait mang\u00e9 par une IA au bout de " + sec + "," + ms + " seconde(s).");
  }
  
  //Le nombre de case revient \u00e0 2 et le niveau est \u00e0 1
  nbCase = 2;
  niveau = 1;
  
  // Cr\u00e9ation d'un nouveau Labyrtinthe
  newLabyrinthe();
  
  // Repositionnement du joueur et des IAs
  player.repositionne(0, 0);
  
  //On vide la liste des IAs
  aiplayers.clear();
  
  //On red\u00e9marre le compteur
  start = millis();
}

public void newLabyrinthe() {
  walls.clear();
  matrice = new int[nbCase*nbCase][nbCase*nbCase];
  grille = new int[nbCase][nbCase];
  creuse_passage(0, 0);
  drawMaze();
}