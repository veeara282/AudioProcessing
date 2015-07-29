class NoteListener {
  
  int midi;
  
  float x, y, rad;
  color c;
  
  float amp;
  
  NoteListener(int midi) {
    this.midi = midi;
    
    y = height/2;
    x = 60 * midi + 50;
    rad = 5;
    colorMode(HSB, 12, 1, 1, 1);
    c = color(midi % 12, 1, 1, 0.5);
    amp = 0;
  }
  
  void notePlayed(float amp) {
    this.amp = amp;
    rad = 5 + 10 * sqrt(amp);
//    rad = 15 + 10 * log(amp);
  }
  
  void draw() {
    noStroke();
    fill(c);
    ellipse(x, y, rad, rad);
      textAlign(CENTER, CENTER);
      text(amp, x, y);
      println(midi + " " + amp);
    // resets after
//    rad -= 1;
//    if (rad < 5) 
    rad = 5;
  }
}
