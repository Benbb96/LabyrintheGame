// Classe pour gérer le chronomètre du jeu

class Timer {
  
  int start, time;
  boolean isRunning;  // Permet de s'assurer que le timer est en route ou non
  
  Timer() {
    time = 0;  // On réinitialise le temps enregistré à 0
    restart();  // On démarre le timer
  }
  
  // Fonction pour démarrer ou redémarrer le chrono
  void restart() {
    start = millis();  // On enregistre le temps depuis que le jeu a été lancé, pour ensuite le comparer à un autre temps et ainsi avoir la différence
    isRunning = true;
  }
  
  // Mettre en pause le timer
  void pause() {
    time += millis() - start; // Calcul de la durée et on l'ajoute au temps déjà enregistré
    isRunning = false;
  }
  
  // Quand c'est la fin du labyrinthe
  void end() {
    if (isRunning) {
      pause();
      println(getDisplay());
    }
  }
  
  int getDays() {
    return time / 1000 / 60 / 60 / 24;  // Calcul du nombre de jours
  }
  
  int getHours() {
    return time / 1000 / 60 / 60;  // Calcul du nombre d'heures
  }
  
  int getMinutes() {
    return time / 1000 / 60;  // Calcul du nombre de minutes
  }
  
  int getSeconds() {
    return time / 1000;  // Calcul du nombre de seconde
  }
  
  
  String getDisplay() {
    String text = "";
    if (getSeconds() > 1) {  // S'il y a au moins une seconde
      if (getMinutes() > 1) {  // S'il y a au moins une minute
        if (getHours() > 1) {  // S'il y a au moins une heure
          if (getDays() > 1) {  // S'il y a au moins un jour
            text += getDays() + "j ";
          }
          text += getHours() + "h ";
        }
        text += getMinutes() % 60 + "m ";
      }
      text += getSeconds() % 60 + "s ";
    }
    text += time % 1000 + "ms";
    return text;
  }
}