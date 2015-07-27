class Song {
  float bps = 0;
  ArrayList<NineOctaves> songNotes = new ArrayList<NineOctaves>();
  AudioOutput out = minim.getLineOut();

  Song(float b) {
    bps = b;
    out.setTempo(3600);
  }

  int size() {
    return songNotes.size();
  }

  void add(NineOctaves no) {
    songNotes.add(no);
  }

  NineOctaves getLast() {
    return songNotes.get(songNotes.size()-1);
  }

  void smoothAudio(int searchFwd) {
    for (int i = 0; i < songNotes.size (); i++) {
      NineOctaves staff = songNotes.get(i);
      for (int j = 0; j < 9; j++) {
        Octave octave = staff.getOctave(j);
        for (int k = 0; k < 12; k++) {
          Note note = octave.getNote(k);
          // Search forward searchForward ticks
          if (note.getPlayed() != 0) {
            boolean fill = false;
            for (int ahead = i + 1; !fill && ahead < songNotes.size() && ahead <= i + searchFwd; ahead++) {
              Note n = songNotes.get(ahead).getOctave(j).getNote(k);
              if (n.getPlayed() != 0) {
                fill = true;
              }
            }
            for (int ahead = i + 1; !fill && ahead < songNotes.size() && ahead <= i + searchFwd; ahead++) {
              Note n = songNotes.get(ahead).getOctave(j).getNote(k);
              n.setPlayed(1);
            }
          }
        }
      }
    }
  }
}

