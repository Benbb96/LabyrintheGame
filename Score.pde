class Score extends JSONObject{
  
  int level; //Le niveau du score
  int rang; //Le rang du score, si c'est le meilleur score, c'est le 1
  float temps; //Le score en lui même qui représente le temps pour finir le labyrinthe
  String name; //Le nom du joueur qui a fait ce score
  
  Score(int level, float temps, String name) {
    this.level = level;
    this.temps = temps;
    this.name = name;
    // On appelle la méthode de calcul du rang pour pouvoir modifier également les autres scores si leur rang s'en trouve impacté
    updateRang();
  }
  
  // Crée l'objet score à partir d'un JSONObject déjà existant
  Score(JSONObject score) {
    level = score.getInt("level");
    rang = score.getInt("rang");
    temps = score.getFloat("temps");
    name = score.getString("name");
  }
  
  //Permet d'enregistrer le score avec tous ses attributs de définis
  JSONObject persist() {
    setInt("level", level);
    setInt("rang", rang);
    setFloat("temps", temps);
    setString("name", name);
    
    return this;
  }
  
  // A terminer ---> Reprendre le calcul du rang... C'est chaud :(
  
  // Méthode de calcul du rang du score
  void updateRang() {
    JSONArray scoresLevel = new JSONArray();
    // On vérifie si un tableau des scores existe déjà pour ce niveau
    if (scores.isNull(level)) { //Le level correspond également à la position dans le tableau JSON
      scores.setJSONArray(level, scoresLevel); //Comme il n'existe pas, on l'ajoute au bon endroit
    } else {
      scoresLevel = scores.getJSONArray(level); //Il existe donc on le récupère
    }
    
    //On vérifie si le tableau de score est vide
    if (scoresLevel.size() == 0) {
      println("Premier score inscrit au niveau " + level + " !");
      rang =  1; //S'il y a aucun score de renseigner à ce niveau, il sera donc le meilleur score
      scoresLevel.setJSONObject(0, this.persist());
    } else {
      // On crée une liste de tous les scores
      ArrayList<Score> scoreList = new ArrayList();
      boolean added = false;
      for (int i = 0; i < scoresLevel.size(); i++) {
        //On récupère le score pour accéder à ses propriétés
        Score score = new Score(scoresLevel.getJSONObject(i));
        // On compare le temps effectué avec le temps du score récupéré et on vérifie si le nouveau score a déjà été ajouté
        if (temps < score.temps && !added) {
          scoreList.add(this);
          scoreList.add(score);
          added = true;
        } else if (i == scoresLevel.size() - 1 && !added) { // Si on est sur le dernier score, il faut penser à tout de même ajouter le nouveau temps après celui-ci
          scoreList.add(score); 
          scoreList.add(this);
        } else {
          scoreList.add(score); //Sinon, on ajoute le score à la suite
        }
      }
      //Score List est maintenant trié, il faut rajouter les scores dans l'ordre dans le JSON Array
      for (int i = 0; i < scoreList.size(); i++) {
        Score score = scoreList.get(i);
        //Mise à jour du rang
        score.rang = i + 1;
        scoresLevel.setJSONObject(i, score.persist());
      }
    }
  }
  
  
}