import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioSample input, output;
FFT fft;
//float[][] buffer;
//boolean playing = true;
float songLength;
int samples = 1024;

void setup() {
  size(samples, 200, P2D);
  // FIXME why is the loading screen delayed?
  background(0);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(72);
  text("Loading...", width/2, height/2);

  minim = new Minim(this);

  input = minim.loadSample("marcus_kellis_theme.mp3", samples); 
  songLength = input.length();
}

void draw() {
  background(0);
}

