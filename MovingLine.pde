// La classe des lignes animées

class MovingLine {
  
  PVector a, b, t, initialT;
  float r = 0;
  float initialR = 0;
  float speed = 0.005; // => 0.026
  
  int animation = 0;  // Indique quelle est l'animation en cours
  IntList animations;  // La liste des animations à jouer dans l'ordre
  int index = 0;  // L'index de l'animation en cours (démarre de 0 puis est incrémenté à l'appel de getAnimation() )
  boolean ready = true;  // Permet de savoir si la ligne est prête pour une nouvelle animation
  
  static final int SIZE = 60;  // La taille de la ligne
  
  MovingLine(PVector a, PVector b, IntList animations) {
    t = a;
    initialT = new PVector();
    this.a = new PVector(0,0);
    this.b = b;
    this.animations = animations;
  }
  
  void show() {
    // Lance l'animation à intervalle régulier
    if (frameCount == 30 ||frameCount % (1.25/speed) == 0) {
      setAnimation(getAnimation());
    }
    
    switch (animation) {
      
      // Rotations dans le sens horaire
      case 1 :
      case 3 :
        // Tant que la rotation n'est pas arrivée à un quart de tour, on l'incrémente
        if (r < initialR + HALF_PI) r += speed / 0.65;
        else endAnimation(true);
        break;
        
      // Rotations dans le sens anti-horaire
      case 2 :
      case 4 :
        if (r > initialR - HALF_PI) r -= speed / 0.65;
        else endAnimation(true);
        break;
        
      // Translations
      case 5 :
        if ( (b.x + b.y) * (t.x + t.y) < (b.x + b.y) * ( (initialT.x + initialT.y) + (b.x + b.y) ) ) {
          t.set(t.x + b.x * speed, t.y + b.y * speed);
        }
        else endAnimation(false);
        break;
      case 6 :
        if ( (b.x + b.y) * (t.x + t.y) > (b.x + b.y) * ( (initialT.x + initialT.y) - (b.x + b.y) ) ) {
          t.set(t.x - b.x * speed, t.y - b.y * speed);
        }
        else endAnimation(false);
        break;
        
      default :
        animation = 0;
        ready = true;
    }
    
    pushMatrix();
    translate(t.x * SIZE, t.y * SIZE);  // On applique la nouvelle translation
    rotate(r);  // On applique la nouvelle rotation
    line(a.x * SIZE , a.y * SIZE, b.x * SIZE, b.y * SIZE);  // On dessine la ligne
    popMatrix();
  }
  
  // Prépare et lance l'animation passée en paramètre
  void setAnimation(int n) {
    if (ready) {
      ready = false;
      animation = n;
      if (n == 3 || n == 4) { // Inversion des deux points
        t.add(b);
        a.set(-b.x, -b.y);
        b.set(0,0);
      } else if (n == 5 || n == 6) {
        initialT.set(t.x, t.y);
      }
    }
  }
  
  // Restaure les paramètres comme il faut et en fonction de si c'est une rotation ou une translation
  void endAnimation(boolean rotation) {
    initialR = 0;
    initialT.set(t.x, t.y);
    r = 0;
    if (rotation) replace();
    animation = 0;
    ready = true;
  }
  
  // Permet de replacer les points correctement en fonction de la rotation qui a eu lieu
  void replace() {
    if (animation == 1 || animation == 3) {  // Rotation horaire
      if (a.x == 0 && a.y == 0) {  // Le point de pivot est a
        b.set(-b.y,b.x);
      } else {  // Le point de pivot est b
        t.set(t.x - a.y, t.y + a.x);
        b.set(a.y, -a.x);
        a.set(0,0);
      }
    } else {  // Rotation anti-horaire
      if (a.x == 0 && a.y == 0) {
        b.set(b.y,-b.x);
      } else {
        t.set(t.x + a.y, t.y - a.x);
        b.set(-a.y, a.x);
        a.set(0,0);
      }
    }
  }
  
  // Retourne l'animation à jouer et l'incrémente par la même occasion
  int getAnimation() {
    if (index == animations.size()) {
      index = 0;  // L'index repart de 0 quand il a fait le tour de la liste
    }
    return animations.get(index++);
  }
}