import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class InfiniteMaze extends PApplet {

// G\u00e9n\u00e9rateur de Labyrinthe
// Jeu cr\u00e9e et d\u00e9velopp\u00e9 par Benjamin Bernard-Bouissi\u00e8res

// Le but du jeu est \u00e9videmment de travers\u00e9 des labyrinthes qui sont g\u00e9n\u00e9n\u00e9s al\u00e9atoirement gr\u00e2ce
// \u00e0 un algorithme appel\u00e9 le Recursive Backtracker (voir sur http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking)

// Instanciation des variables globales
Player player;
int niveau = 1;


int nbCase = 3; //Nombre de case
float tailleX; //Taille largeur en pixel d'une case
float tailleY; //Taille hauteur en pixel d'une case

int[][] matrice; //Matrice d'adjacence du jeu pour savoir si on a le droit de se d\u00e9placer sur une case ou non
int[][] grille; //Grille qui va nous servir pour la construction du labyrinthe

ArrayList<Wall> walls = new ArrayList();

public void setup() {
  // Mise en place duterrain jeu
  
  surface.setResizable(true);
  background(255);
  
  // Calcul de la taille d'une case
  tailleX = width/nbCase;
  tailleY = height/nbCase;
  
  // Cr\u00e9ation du Labyrtinthe
  newLabyrinthe();
  
  // Cr\u00e9ation du joueur
  player = new Player();
}

public void draw() {
  // Recalcul de la taille d'une case
  tailleX = width/nbCase;
  tailleY = height/nbCase;
  
  //Fonction d'affichage du terrain de jeu
  afficheTerrain();
  
  // Mise \u00e0 jour du joueur
  player.update(); //Met \u00e0 jour la position du joueur
}

public void afficheTerrain() {
   background(255);
  //Cases D\u00e9part Vert et Arriv\u00e9e Rouge
  noStroke();
  fill(color(0,255,0));
  rect(0, 0, tailleX, tailleY);
  fill(color(255,0,0));
  rect(width - tailleX, height - tailleY, tailleX, tailleY);
  textSize(tailleY / 2);
  fill(0);
  text(niveau, tailleX/3, tailleY - tailleY/3);
  
  stroke(1);
  strokeWeight(3);
  grid(); //Trace une grille pour bien voir les cases
  
  //Affichage des murs
  for (int i = 0; i < walls.size(); i++) {
    Wall wall = walls.get(i);
    wall.display();
  }
  
  //Affichage des points de d\u00e9placements
    for (int i = 0; i < nbCase; i++) {
      for (int j = 0; j < nbCase; j++) {
        if (grille[j][i] == 1) {
          pushStyle();
          fill(grille[j][i]%255,grille[j][i]%255,255);
          noStroke();
          ellipse(i * tailleX + tailleX/2, j * tailleY + tailleY/2, tailleX/10, tailleY/10);
          popStyle();
        }
      }
    }
}

// Fonction de tra\u00e7age d'une grille de jeu en fonction du nombre de case
public void grid() {
  //Lignes verticales
  for (int i=1; i < width/tailleX; i++) {
    line(i*tailleX, 0, i*tailleX, height);
  }
  //Lignes Horizontales
  for (int i=1; i < height/tailleY; i++) {
    line(0, i*tailleY, width, i*tailleY);
  }
}

// Fonction \u00e0 l'appui d'une touche
public void keyPressed() {
  if (key == CODED) {
    // Fonctions de d\u00e9placement du joueur
    player.move(keyCode);
  } else if (key == 'r') {
    gameOver();
  } else if (key == 'l') {
    levelUp();
  }
}

// Fonction qui fait passer le jeu au niveau sup\u00e9rieur
public void levelUp() {
  niveau++; //La fonction ne s'appelle pas level Up pour rien !
  //Le nombre de case augmente de 3
  nbCase+=3;
  // Cr\u00e9ation d'un nouveau Labyrtinthe
  newLabyrinthe();
  // Repositionnement du joueur
  player.repositionne(0, 0);
}

// Fonction appel\u00e9 si le joueur se fait touch\u00e9 par l'une des IAs
public void gameOver() {
  nbCase = 3;
  niveau = 1;
  newLabyrinthe();
  player.repositionne(0, 0);
}

public void newLabyrinthe() {
  walls.clear();
  matrice = new int[nbCase*nbCase][nbCase*nbCase];
  grille = new int[nbCase][nbCase];
  creuse_passage(0, 0);
  grille = new int[nbCase][nbCase]; //On remet \u00e0 0 la grille pour renseigner ensuite par o\u00f9 est passer le joueur
  drawMaze();
}
//Le gestionnaire du labyrinthe

//North (UP - 38) => Y-1
//South (DOWN - 40) => Y+1
//West (LEFT - 37) => X-1
//East (RIGHT - 39) => X+1

//Fonction r\u00e9cursive qui permet de creuser le labyrinthe
public void creuse_passage (int cx, int cy) {
  //println("Creuse Passage depuis " + cx + "," + cy);
  IntList directions = newDirectionList();
  int direction;
  // On va tester chaque direction une \u00e0 une
  for (int i = 0; i < 4; i++) {
    direction = directions.get(i);
    // Quelle est la case qu'on souhaite atteindre
    int nx = cx + newX(direction);
    int ny = cy + newY(direction);
    
    //Est-elle sur la grille (entre 0 et le nombre de case) et a-t-elle \u00e9t\u00e9 d\u00e9j\u00e0 vu ?
    if ( ((ny >= 0 && ny < nbCase) && (nx >= 0 && nx < nbCase)) && grille[nx][ny] == 0 ) {
      // Elle est accessible donc on mets \u00e0 jour nos diff\u00e9rentes matrices
      grille[cx][cy] = direction; //Sur la cellule sur laquelle on se trouve, on met la direction o\u00f9 l'on va
      grille[nx][ny] = opposite(direction); //Sur la cellule sur laquelle on va arriver, on met la direction oppos\u00e9 vers o\u00f9 l'on va
      
      //Et on ajoute des 1 dans la matrice d'adjacence pour que le joueur sache qu'il peut atteindre cette cellule \u00e0 partir de celle-ci
      matrice[two2one(cx,cy)][two2one(nx,ny)] = 1;
      matrice[two2one(nx,ny)][two2one(cx,cy)] = 1;
      
      // Enfin on appelle donc \u00e0 nouveau cette m\u00eame fonction qui va continuer de creuser \u00e0 partir de cette nouvelle case atteinte
      creuse_passage(nx, ny);
    }
  } //Et cela donc pour chaque direction
}

//Cr\u00e9e une liste d'entier repr\u00e9sentant les 4 directions et rang\u00e9s dans le d\u00e9sordre
public IntList newDirectionList() {
  IntList list = new IntList();
  for (int i = LEFT; i <= DOWN; i++) list.append(i);
  list.shuffle(); //M\u00e9lange les nombres/directions
  return list;
}

// Fonction qui calcul quelle sera le nouveau x en fonction de la direction
public int newX(int direction) {
  int n = 0;
  if(direction == LEFT) n = -1;
  else if (direction == RIGHT) n = 1;
  return n;
}

// Fonction qui calcul quelle sera le nouveau y en fonction de la direction
public int newY(int direction) {
  int n = 0;
  if(direction == UP) n = -1;
  else if (direction == DOWN) n = 1;
  return n;
}

// Fonctions de correspondances entre le tableau 2 dimension et une dimension
public int two2one(int x, int y) {
  return x * nbCase + y;
}

public PVector one2two(int n) {
  PVector coordonnee = new PVector();
  coordonnee.x = n / nbCase;
  coordonnee.y = n % nbCase;
  return coordonnee;
}

//Retourne la direction oppos\u00e9
public int opposite(int direction) {
  switch(direction) {
    case UP : return DOWN;
    case DOWN : return UP;
    case LEFT : return RIGHT;
    case RIGHT : return LEFT;
    default: return 0;
  }
}

//Fonction qui dessine le labyrinthe, ou plus pr\u00e9cis\u00e9ment, qui efface les traits noirs l\u00e0 ou le joueur peut passer
public void drawMaze() {
  int ax,ay,bx,by; //Case A et B adjacente
  //On va parcourir notre matrice d'adjacence jusqu'\u00e0 trouver des 1 signifiant qu'il y a un passage
  for (int i = 0; i < nbCase*nbCase; i++) {
    for (int j = i; j < nbCase*nbCase; j++) {
      if(matrice[i][j] == 1) {
        ax = i / nbCase;
        ay = i % nbCase;
        bx = j / nbCase;
        by = j % nbCase;
        walls.add(new Wall(bx, by, ax+1, ay+1));
      }
    }
  }
}
//La classe du Joueur

class Player {
 
  PVector location; //La position r\u00e9el sur l'\u00e9cran (en pixel)
  PVector posOnGrid; //La position du joueur sur la grille
  float sizeX; //La taille largeur du joueur
  float sizeY; //La taille hauteur du joueur
  
  int couleur = color(255,255,0); //La couleur du joueur, par d\u00e9faut jaune
  
  Player () {
    //Calcul de la taille du joueur
    sizeX = tailleX/2;
    sizeY = tailleY/2;
    
    //Le joueur commence sur la premi\u00e8re case en haut \u00e0 gauche (0,0)
    posOnGrid = new PVector(0,0);
    //posOnGrid = new PVector((int)random(nbCase),(int)random(nbCase)); //Random
    
    //On met \u00e0 jour sa position r\u00e9el
    updateLocation();
  }
  
  //Remet \u00e0 jour la position r\u00e9elle du joueur en pixel \u00e0 partir de sa position dans la grille de jeu
  public void updateLocation() {
    location = new PVector(posOnGrid.x * tailleX + sizeX, posOnGrid.y * tailleY + sizeY);
  }
  
  // Fonction d'actualisation du joueur, sa taille, sa position et s'il a atteint son but
  public void update() {
    //Remise \u00e0 jour de la taille du joueur
    sizeX = tailleX/2;
    sizeY = tailleY/2;
    // Mise \u00e0 jour de sa position \u00e0 partir de la position sur la grille de jeu
    updateLocation();
    checkFinish();
    //Affiche le joueur
    fill(couleur);
    strokeWeight(2);
    stroke(0);
    ellipse(location.x, location.y, sizeX, sizeY);
  }
  
  // V\u00e9rifie si le joueur a atteint le point d'arriv\u00e9e
  public void checkFinish() {
    if (posOnGrid.x == nbCase-1 && posOnGrid.y == nbCase-1) {
      levelUp();
    }
  }
  
  // Fonction de d\u00e9placement qui v\u00e9rifie si le d\u00e9placement peut se faire (limites du terrain et les murs)
  public void move(int direction) {
    boolean canGoThere = true;
    switch(direction) {
      case UP :
        if (posOnGrid.y > 0 && matrice[posOnMatrice()][(int)posOnGrid.x * nbCase + (int)posOnGrid.y-1] == 1) posOnGrid.y--;
        else canGoThere = false;
        break;
      case DOWN :
        if (posOnGrid.y < nbCase-1 && matrice[posOnMatrice()][(int)posOnGrid.x * nbCase + (int)posOnGrid.y+1] == 1) posOnGrid.y++;
        else canGoThere = false;
        break;
      case LEFT :
        if (posOnGrid.x > 0 && matrice[posOnMatrice()][((int)posOnGrid.x-1) * nbCase + (int)posOnGrid.y] == 1) posOnGrid.x--;
        else canGoThere = false;
        break;
      case RIGHT :
        if (posOnGrid.x < nbCase-1 && matrice[posOnMatrice()][((int)posOnGrid.x+1) * nbCase + (int)posOnGrid.y] == 1) posOnGrid.x++;
        else canGoThere = false;
        break;
    }
    
    if (canGoThere) { //Jouer un son quand le joueur se d\u00e9place
      grille[PApplet.parseInt(posOnGrid.y)][PApplet.parseInt(posOnGrid.x)] = 1;
    }
  }
  
  //Repositionne le joueur \u00e0 l'endroit souhait\u00e9
  public void repositionne(int x, int y) {
    posOnGrid.x = x;
    posOnGrid.y = y;
  }
  
  // Retourne le num\u00e9ro de la case sur laquelle se positionne le joueur
  // Exemple : il y a 3 cases de largeur, le joueur est sur la 1\u00e8re case de la 3\u00e8me ligne (3,0)
  public int posOnMatrice() {
    return (int)posOnGrid.x * nbCase + (int)posOnGrid.y;
  }
  
}
// Classe pour construire les murs du labyrinthe

class Wall {
  
  PVector a; //Point A du mur (en haut \u00e0 gauche)
  PVector b; //Point B du mur (en bas \u00e0 droite)
  
  Wall(float ax, float ay, float bx, float by) {
    a = new PVector(ax, ay);
    b = new PVector(bx, by);
  }
  
  public void display() {
    stroke(255);
    strokeWeight(3);
    line(a.x * tailleX, a.y * tailleY, b.x * tailleX, b.y * tailleY);
  }
  
}
  public void settings() {  size(400,400); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "InfiniteMaze" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
