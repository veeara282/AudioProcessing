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

void setup() {
  minim = new Minim(this);
}

void draw() {
  
}
