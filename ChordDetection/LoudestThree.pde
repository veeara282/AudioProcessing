class LoudestThree {
  
  float[] amplitudes;
  
  LoudestThree() {
    amplitudes = new float[12];
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
