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

}

