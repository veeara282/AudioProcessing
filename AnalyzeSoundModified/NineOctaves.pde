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

 void update(int octaveIndex, int noteIndex){
   int p = getOctave(octaveIndex).getNote(noteIndex).getPlayed();
   if(p==0){
     allOctaves[octaveIndex].getNote(noteIndex).setPlayed(2);
     //getOctave(octaveIndex).getNote(noteIndex).setPlayed(2);
   }else if(p==2){
     allOctaves[octaveIndex].getNote(noteIndex).setPlayed(1);
     for(int i=0; i<12; i++){
       if(i!=noteIndex){
         allOctaves[octaveIndex].getNote(noteIndex).setPlayed(0);
       }
     }
     //getOctave(octaveIndex).getNote(noteIndex).setPlayed(1);
   }else if(p==1){
     allOctaves[octaveIndex].getNote(noteIndex).setPlayed(0);
   }
 }

 

}
