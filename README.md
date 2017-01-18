# LabyrintheGame
Jeu de labyrinthe généré aléatoirement avec Processing.
Jeu crée et développé par Benjamin Bernard-Bouissières.

Le but du jeu est évidemment de traversé des labyrinthes qui sont génénés aléatoirement grâce à un algorithme appelé le Recursive Backtracker (voir sur http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking)
Le jeu commence au niveau 1 avec un labyrinthe de 2 par 2 et à chaque fois que le joueur atteint la case rouge, un nouveau labyrinthe apparaît mais cette fois de dimension 3 par 3 et ainsi de suite de manière infini.
Le joueur est chronométré à chaque nouveau labyrtinthe.
Une intelligence artificielle, représenté par des pions rouges, rajoute une difficulté supplémentaire en essayant d'attraper le joueur en le faisant recommencer du début.

Axes d'améliorations :
     - Tracer le chemin qu'emprunte le joueur
     - Mettre un fond ? Animation construction du labyrinthe.
     - Amélioration de l'IA -> Algorithme de Disjktra -> déplacement à un point random pour une impression de cohérence dans les mouvements.
       L'IA pourrait faire un déplacement à chaque fois que le joueur se déplace (Pokemon Donjon Mystère)
     - Cases Abri pour se protéger des IA (dans les coins ?)
     - Ajout d'objets à collecter (Pouvoirs, score, ...)
     - Création d'un menu de jeu
     - Gestion des meilleurs scores dans un fichier
     - Ajout de différents sons
     - Etendre le labyrinthe de part et d'autre au lieu d'en générer un nouveau
