// Classe pour construire les boutons du menu de démarrage

class Button {
  
  int id;  // Numéro du bouton servant de passer d'un bouton à l'autre avec le clavier
  String text;  // Le texte du bouton
  int x, y;  // La position du texte
  int buttonMode;  // Le mode auquel donne accès le bouton
  color overColor;  // Les couleurs du bouton
  boolean selected = false;  // Indique si le bouton est actuellement sélectionné
  
  Button(int id, String text, int x, int y, int mode, color overColor) {
    this.id = id;
    this.text = text;
    this.x = x;
    this.y = y;
    buttonMode = mode;
    this.overColor = overColor;
  }
  
  // Fonction permettant l'affichage du bouton
  void display() {
    // Si la souris est au-dessus du bouton, il est sélectionné
    if (mouseOver() && !selected) {
      resetSelectedButtons();
      selected = true;
      selectedButton = id;
    }
    
    if (selected) {  // Si le bouton est sélectionné, on utilise sa couleur de survol et on grossit un peu la taille du texte
      fill(overColor);
      stroke(overColor);
      strokeWeight(2);
      textSize(width/19);
      line(x - textWidth(text)/2 - 27, y + 3, x - textWidth(text)/2 - 8, y + 3);
      line(x + textWidth(text)/2 + 27, y + 3, x + textWidth(text)/2 + 8, y + 3);
    } else {
      fill(wallColor);
      textSize(width/21);
    }
    textAlign(CENTER, CENTER);
    text(text, x, y);
  }
  
  // Fonction qui initialise tous les paramètres propres à un mode de jeu
  void chargeMode() {
    switch (buttonMode) {
      case EASY :
        nbCaseDefaut = 2;
        incrementationDefaut = 1;
        disappear = false;
        mode = EASY;
        break;
      case MEDIUM :
        nbCaseDefaut = 3;
        incrementationDefaut = 2;
        disappear = false;
        mode = MEDIUM;
        break;
      case HARD :
        nbCaseDefaut = 4;
        incrementationDefaut = 3;
        disappear = false;
        mode = HARD;
        break;
      case BLIND :
        nbCaseDefaut = 3;
        incrementationDefaut = 3;
        disappear = true;  // On active le booléen de disparition
        mode = BLIND;
        break;
    }
    nbCase = nbCaseDefaut;
  }
  
  // Permet de déterminer si la souris estau-dessus du bouton ou non
  boolean mouseOver() {
    if (mouseY > y-25 && mouseY < y+10 && mouseX < width/2) {
      return true;
    } else {
      return false;
    }
  }
  
  // Fonction pour désélectionner tous les boutons
   void resetSelectedButtons() {
    for (int i = 0; i < 4; i++) {
        buttons[i].selected = false;
      }
  }
  
}