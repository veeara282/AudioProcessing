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
    // rad = 15 + 10 * log(amp);
  }
  
  void draw() {
    noStroke();
    fill(c);
    ellipse(x, y, rad, rad);
    // A4
    if (midi == 69) {
      colorMode(RGB, 255, 255, 255, 1);
      fill(255);
      textAlign(CENTER, CENTER);
      text("A4", x, y);
    }
    // resets after
    rad -= 1;
    if (rad < 5) rad = 5;
  }
}
