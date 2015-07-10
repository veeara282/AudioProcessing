import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*; // waveform templates
import ddf.minim.effects.*;

/**
 * Converts a user-provided audio file to a chiptune.
 * Step 1: FFT on small sections (2048 samples?)
 * Step 2: Use a neural network to break down into sine, square,
 * triangle, and sawtooth wave components.
 * (TODO: Train the network on simple wave spectrum examples,
 * then save it to a file.)
 * Step 3: Filter out everything except for basic waveforms.
 * 
 * You've got chiptune!
 * 
 * Extra steps:
 * - auto-tune the output to A-440 (use neural network)
 * - replace percussion with bursts of white/pink noise
 */

Minim minim;
AudioSample input, output;

void setup() {
  size(512, 200, P2D);

  minim = new Minim(this);

  input = minim.loadSample("jingle.mp3", 2048);
}


void draw() {
  background(0);
  stroke(255);

//  // use the mix buffer to draw the waveforms.
//  for (int i = 0; i < input.bufferSize() - 1; i++)
//  {
//    float x1 = map(i, 0, kick.bufferSize(), 0, width);
//    float x2 = map(i+1, 0, kick.bufferSize(), 0, width);
//    line(x1, 50 - kick.mix.get(i)*50, x2, 50 - kick.mix.get(i+1)*50);
//    line(x1, 150 - snare.mix.get(i)*50, x2, 150 - snare.mix.get(i+1)*50);
//  }
}

// when spacebar is pressed, plays the file
void keyPressed() 
{
  if (key == ' ' || key == 'i' || key == 'I')
  {
    // plays in another thread
    input.trigger();
  }
}

