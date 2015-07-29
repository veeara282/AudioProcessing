class LoudestThree {
  
  float[] amplitudes;
  
  float chordTimer;
  
  Oscil primary;
  Midi2Hz midi;
  
  float vol = 0.5;
  
  LoudestThree() {
    amplitudes = new float[12];
    chordTimer = 0;
    primary = new Oscil(330, 0, Waves.TRIANGLE);
    midi = new Midi2Hz(60);
    midi.patch(primary.frequency).patch(minim.getLineOut());
  }
  
  void draw() {
    int loudest = getLoudest();
    int secondLoudest = getLoudest(loudest);
    int thirdLoudest = getLoudest(loudest, secondLoudest);
    
    switch ((int) (chordTimer = (chordTimer + 1.0/3) % 3)) {
      case 0:
        playNote(loudest);
        break;
      case 1:
        playNote(secondLoudest);
        break;
      case 2:
        playNote(thirdLoudest);
    }

    for (int ii : new int[]{loudest, secondLoudest, thirdLoudest}) {
      if (ii >= 0) beat.listeners.get(ii).notePlayed(vol);
    }
    
    // finally draw the note things
    for (NoteListener l : beat.listeners) {
      l.draw();
      if (l.midi != loudest
       && l.midi != secondLoudest
       && l.midi != thirdLoudest) {
         l.notePlayed(0);
       }
    }

  }
  
  void playNote(int note) {
    if (note == -1) {
      primary.setAmplitude(0);
    }
    else {
      primary.setAmplitude(vol);
      midi.setMidiNoteIn(60 + note);
    }
  }
  
  float get(int note) {
    if (note == -1) return 0;
    return amplitudes[note];
  }
  
  void set(int note, float amp) {
    amplitudes[note] = amp;
  }
  
  // returns -1 iff no sound
  int getLoudest(int... excl) {
    int loudest = -1;
    float loudestAmp = 0;
    for (int i = 0; i < 12; i++) {
      if (amplitudes[i] > loudestAmp && !elementOf(i - 1, excl)
                                     && !elementOf(i, excl)
                                     && !elementOf(i + 1, excl)) {
        loudest = i;
        loudestAmp = amplitudes[i];
      }
    }
    return loudest;
  }
  
  private boolean elementOf(int i, int[] array) {
    for (int j: array) {
      if (i == j) return true;
    }
    return false;
  }
}
