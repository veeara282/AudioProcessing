class NoteListener {
  
  int midi;
  
  float x, y, rad;
  color c;
  
  NoteListener(int midi) {
    this.midi = midi;
    
    y = 20;
    x = 20 * (midi - 21) - 10;
    rad = 5;
    colorMode(HSB, 12, 1, 1, 1);
    c = color(midi % 12, 1, 1, 0.5);
  }
  
  void notePlayed() {
    rad = 10;
  }
  
  void draw() {
    ellipseMode(RADIUS);
    ellipse(x, y, rad, rad);
    rad -= 1;
    if (rad < 5) rad = 5;
  }
}
