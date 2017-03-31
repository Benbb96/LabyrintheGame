# Labyrinthe Game

*Jeu de labyrinthe généré aléatoirement, créé et développé par Benjamin Bernard-Bouissières à l'aide du logiciel __[Processing](https://processing.org/)__*

## Présentation du jeu

Le but du jeu est évidemment de traverser des labyrinthes qui sont générés de façon aléatoire grâce à un algorithme appelé le __Recursive Backtracker__ (voir sur [ici](http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking) pour plus d'info)  
Le jeu commence au niveau 1 sur la case verte d'un labyrinthe de 2 par 2. A chaque fois que le joueur parvient à atteindre la case rouge, un nouveau labyrinthe apparaît mais cette fois de dimension 3 par 3 et ainsi de suite de manière infini.  
Le joueur est chronométré à chaque nouveau labyrtinthe.  
Une __intelligence artificielle__, représenté par des pions rouges, rajoute une difficulté supplémentaire en essayant d'attraper le joueur en le faisant recommencer du début.  
Les murs s'effacent au fur et à mesure, demandant au joueur de mémoriser leur emplacement ou de chercher à tâton la sortie.  
J'ai également crée une petite musique de fond qui se répète en boucle (cela peut devenir assez lassant au bout d'un moment ^^').  

## Axes d'améliorations

* Tracer le chemin qu'emprunte le joueur -> Fait, touche P pour activer/désactiver les points/remplissage de la case et touche C pour le chemin.
* Mettre un fond ? Animation construction du labyrinthe
* Amélioration de l'IA -> Algorithme de Disjktra -> déplacement à un point random pour une impression de cohérence dans les mouvements.  
L'IA pourrait faire un déplacement à chaque fois que le joueur se déplace (Pokemon Donjon Mystère)
* Cases Abri pour se protéger des IA (dans les coins ?)
* Ajout d'objets à collecter (Pouvoirs, score, ...)
* Création d'un menu de jeu
* Gestion des meilleurs scores dans un fichier -> Fait (à utiliser dans les futurs menus)
* Ajout de différents sons
* Etendre le labyrinthe de part et d'autre au lieu d'en générer un nouveau -> pas super car on repasse toujours par le même chemin
* Faire disparaître les murs au bou d'un certain temps. Le joueur doit donc mémoriser l'emplacement des murs. Une touche spéciale pourrait permettre de revoir les murs pendant un court instant -> Fait, touche A pour faire réapparaître et touche D pour toogle ce mode
* Mode 2 joueur : Splatoon, il faut recouvrir de sa couleur la plus grande partie du labyrinthe dans le temps imparti. A chaque fois que l'on passe sur une case, cela la recouvre de notre couleur.
