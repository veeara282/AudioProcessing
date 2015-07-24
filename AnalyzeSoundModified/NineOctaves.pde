class NineOctaves{
 Octave[] allOctaves = new Octave[9];
 
 NineOctaves(){
  for(int i=0; i<9; i++){
    allOctaves[i] = new Octave(i);
  }
 }
 
 Octave getOctave(int i){
   return allOctaves[i];
 } 

}
