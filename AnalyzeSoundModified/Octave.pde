class Octave {
  Note[] allNotes = new Note[12];

  Octave(int o) {
    for (int i=0; i<12; i++) {
      allNotes[i] = new Note(i, o);
    }
  }

  Note getNote(int i) {
    return allNotes[i];
  }
}

