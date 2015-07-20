class NoteListener {
  
  int midi;
  
  float x, y, rad;
  color c;
  
  NoteListener(int midi) {
    this.midi = midi;
    
    y = height/2;
    x = 20 * (midi - 20) - 10;
    rad = 5;
    colorMode(HSB, 12, 1, 1, 1);
    c = color(midi % 12, 1, 1, 0.5);
  }
  
  void notePlayed(float amp) {
    rad = 5 + 10 * sqrt(amp);
  }
  
  void draw() {
    noStroke();
    fill(c);
    ellipseMode(RADIUS);
    ellipse(x, y, rad, rad);
//    rad -= 1;
//    if (rad < 5) rad = 5;
  }
}
