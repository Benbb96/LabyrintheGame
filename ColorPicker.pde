// Classe pour l'outil de sélection de couleur

class ColorPicker {
  
  int 
    ColorPickerX,  // Position horizontal
    ColorPickerY,  // Position vertical
    LineY,  // Ligne verticale de la teinte
    CrossX,  // Position horizontal de la croix pour la saturation + luminosité
    CrossY,  // Position vertical de la croix pour la saturation + luminosité
    ColorSelectorX,  // Position horizontal de la du bouton pour ouvrir le color picker
    ColorSelectorY,  // Position vertical de la du bouton pour ouvrir le color picker
    OkX = 285,  // Position horizontal du bouton OK
    OkY = 235;  // Position vertical du bouton OK
  
  boolean 
    isDraggingCross = false,  // Vérifie si la souris fait bouger la croix
    isDraggingLine = false,  // Vérifie si la souris fait bouger la ligne de teinte
    ShowColorPicker = false;  // Active la visibilité du color picker
   
  color 
    activeColor,  // Contient la couleur sélectionnée
    interfaceColor = color(255);  // La couleur d'interface
  
  
  ColorPicker(int x, int y, color activeColor) {
    this.ColorSelectorX = x;
    this.ColorSelectorY = y;
    this.activeColor = activeColor;
    
    // Contraint la position du color picker à rester dans le cadre
    ColorPickerX = constrain( ColorSelectorX + 40 , 10 , width - 340 );
    ColorPickerY = constrain( ColorSelectorY + 40 , 10 , height - 300 );
    
    colorMode(HSB);
    LineY = ColorPickerY + int(hue(activeColor));  // Positionne la ligne de teinte en fonction de l'active color
    CrossX = ColorPickerX + int(saturation(activeColor));  // set initial Line position
    CrossY = ColorPickerY + int(brightness(activeColor));  // set initial Line position
    colorMode(RGB);
  }
  
  
  void display() {
    colorMode(HSB);
    drawColorSelector(); 
    
    if( ShowColorPicker ) {
      drawColorPicker();
      drawLine();
      drawCross();
      drawActiveColor();
      drawValues();
      drawOK();
    }
    
    checkMouse();
    
    activeColor = color( LineY - ColorPickerY , CrossX - ColorPickerX , 255 - ( CrossY - ColorPickerY ) );  // Défini la couleur qui est sélectionnée
    colorMode(RGB);
  }
  
  
  void drawColorSelector() {
    stroke( interfaceColor );
    strokeWeight( 1 );
    fill( 0 );
    rect( ColorSelectorX , ColorSelectorY , 20 , 20 );  // Le contour de sélection  pour le bouton servant à ouvrir le color picker
    
    stroke( 0 );
    
    // Si la souris ets par-dessus, on change la couleur à l'intérieur
    if(mouseX > ColorSelectorX && mouseX < ColorSelectorX + 20 && mouseY > ColorSelectorY && mouseY < ColorSelectorY + 20)
     fill( hue(activeColor) , saturation(activeColor) , brightness(activeColor)+50 );
    else
     fill( activeColor );
      
    rect( ColorSelectorX + 1 , ColorSelectorY + 1 , 18 , 18 ); //draw the color selector fill 1px inside the border
  }
  
  
  void drawOK() {
    if( mouseX > ColorPickerX + OkX && mouseX < ColorPickerX + OkX + 30 && mouseY > ColorPickerY + OkY && mouseY < ColorPickerY + OkY + 20 ) //check if the cross is on the darker color
      fill(0);  // Optimise la visibilité sur les couleurs clairs
    else
      fill(100);  // Optimise la visibilité sur les couleurs sombres
    textSize(14);
    text( "OK" , ColorPickerX + 300 , ColorPickerY + 245 );
  }
  
  
  void drawValues() {
    fill(0);
    textSize(10);
    textAlign(CENTER);
    
    text( "T: " + int( ( LineY - ColorPickerY ) * 1.417647 ) + "°" , ColorPickerX + 300 , ColorPickerY + 100 );
    text( "S: " + int( ( CrossX - ColorPickerX ) * 0.39215 + 0.5 ) + "%" , ColorPickerX + 301 , ColorPickerY + 115 );
    text( "L: " + int( 100 - ( ( CrossY - ColorPickerY ) * 0.39215 ) ) + "%" , ColorPickerX + 300 , ColorPickerY + 130 );
    
    text( "R: " + int( red( activeColor ) ) , ColorPickerX + 300 , ColorPickerY + 155 );
    text( "V: " + int( green( activeColor ) ) , ColorPickerX + 300 , ColorPickerY + 170 );
    text( "B: " + int( blue( activeColor ) ) , ColorPickerX + 300 , ColorPickerY + 185 );
    
    text( hex( activeColor , 6 ) , ColorPickerX + 303 , ColorPickerY + 210 );
  }
  
  
  void drawCross() {
    if( brightness( activeColor ) < 90 )
      stroke( 255 );
    else
      stroke( 0 );
      
    line( CrossX - 5 , CrossY , CrossX + 5 , CrossY );
    line( CrossX , CrossY - 5 , CrossX , CrossY + 5 );
  }
  
  
  void drawLine() {
    stroke(0);
    line( ColorPickerX + 259 , LineY , ColorPickerX + 276 , LineY );
  }
  
  void drawColorPicker() {
    stroke( interfaceColor );
    line( ColorSelectorX + 10 , ColorSelectorY + 10 , ColorPickerX - 3 , ColorPickerY - 3 );
     
    strokeWeight( 1 );
    fill( 0 );
    rect( ColorPickerX - 3 , ColorPickerY - 3 , 283 , 260 );
    
    loadPixels();
    
    for( int j = 0 ; j < 255 ; j++ ) {  //draw a row of pixel with the same brightness but progressive saturation
      for( int i = 0 ; i < 255 ; i++ )  //draw a column of pixel with the same saturation but progressive brightness
        set( ColorPickerX + j , ColorPickerY + i , color( LineY - ColorPickerY , j , 255 - i ) );
    }
    
    for( int j = 0 ; j < 255 ; j++ ) {
      for( int i = 0 ; i < 20 ; i++ )
        set( ColorPickerX + 258 + i , ColorPickerY + j ,color( j , 255 , 255 ) );
    }
    
    fill( interfaceColor );
    noStroke();
    rect( ColorPickerX + 280 , ColorPickerY - 3 , 45 , 261 );
  }
  
  void drawActiveColor() {
    fill( activeColor );
    stroke( 0 );
    strokeWeight( 1 );
    rect( ColorPickerX + 282 , ColorPickerY - 1 , 41 , 80 );
  }
  
  
  void checkMouse() {
    if (mousePressed) {
      if(mouseX > ColorPickerX + 258 && mouseX < ColorPickerX + 277 && mouseY > ColorPickerY - 1 && mouseY < ColorPickerY + 255 && !isDraggingCross && ShowColorPicker) { 
        LineY=mouseY;
        isDraggingLine = true;
      }
  
      if (mouseX > ColorPickerX - 1 && mouseX < ColorPickerX + 255 && mouseY > ColorPickerY - 1 && mouseY < ColorPickerY + 255 && !isDraggingLine && ShowColorPicker) {
        CrossX=mouseX;
        CrossY=mouseY;
        isDraggingCross = true;
      }
    }
  }
  
  boolean openColorPicker() {
    if (mouseX > ColorSelectorX && mouseX < ColorSelectorX + 20 && mouseY > ColorSelectorY && mouseY < ColorSelectorY + 20) {
      return true;
    }
    return false;
  }
  
  boolean closeColorPicker() {
    if (mouseX > ColorPickerX + OkX && mouseX < ColorPickerX + OkX + 30 && mouseY > ColorPickerY + OkY && mouseY < ColorPickerY + OkY + 20 && ShowColorPicker) {
      return true;
    }
    return false;
  }
}