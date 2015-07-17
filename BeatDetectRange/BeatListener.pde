class BeatListener {

  BeatDetect beatDetect;
  AudioSource audio;
  ArrayList<NoteListener> listeners;

  BeatListener(AudioSource src) {
    audio = src;
    beatDetect = new BeatDetect(src.bufferSize(), src.sampleRate());
    listeners = new ArrayList<NoteListener>();
    // A0-C8 (piano range)
    for (int i = 21; i < 108; i++) {
      listeners.add(new NoteListener(i));
    }
  }

  // Called each time draw() is called
  void draw() {
    beatDetect.detect(audio.mix);
    for (NoteListener l: listeners) {
      int min = minBand(l.midi), max = maxBand(l.midi);
      if (beatDetect.isRange(min, max, (max - min) / 2)) {
        l.notePlayed();
      }
      l.draw();
    }
  }

  final float SEMITONE = pow(2, 1/12.0);

  float freq(int midi) {
    return 440.0 * pow(SEMITONE, midi - 69);
  }

  float minFreq(int midi) {
    return maxFreq(midi - 1);
  }

  float maxFreq(int midi) {
    return 440.0 * pow(SEMITONE, midi - 69) * sqrt(SEMITONE);
  }

  int minBand(int midi) {
    return (int) (minFreq(midi) * audio.bufferSize() / audio.sampleRate());
  }

  int maxBand(int midi) {
    return (int) (maxFreq(midi) * audio.bufferSize() / audio.sampleRate());
  }
}

