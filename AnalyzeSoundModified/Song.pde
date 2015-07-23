class Song {
  float bps = 0;
  ArrayList<NineOctaves> songNotes = new ArrayList<NineOctaves>();
  AudioOutput out = minim.getLineOut();

  Song(float b) {
    bps = b;
    out.setTempo(3600);
  }
  
  int size(){
   return songNotes.size(); 
  }

  void add(NineOctaves no) {
    songNotes.add(no);
  }
  
  NineOctaves getLast(){
    return songNotes.get(songNotes.size()-1);
  }

//  void setDurations() {
//    for (int i=0; i<songNotes.size (); i++) {
//      for (int n=0; n<songNotes.get (i).notesPlayed.size(); n++) {
//        Note playable = songNotes.get(i).notesPlayed.get(n);
//        if (i!=0) {
//          if (!songNotes.get(i-1).containsPlayedNote(playable)) {
//            songNotes.get(i-1).notesPlayed.get(n).start();
//          }
//        }
//      }
//    }
//  }
//
//
//  void play() {
//    println(bps);
//    setDurations();
//    out.pauseNotes();
//    for (int i=0; i<songNotes.size (); i++) {
//      for (int n=0; n<songNotes.get (i).notesPlayed.size(); n++) {
//        Note playable = songNotes.get(i).notesPlayed.get(n);
//        if (playable.started) {
//          out.playNote( i, 1.0, playable.getFreq());
//        }
//      }
//    }
//    //out.setNoteOffset( 8 );
//    out.resumeNotes();
//  }
}

