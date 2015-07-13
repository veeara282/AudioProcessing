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
FFT fft;
double[] fftRep;

void setup() {
  size(512, 200, P2D);

  minim = new Minim(this);

  input = minim.loadSample("jingle.mp3", 2048); 
  
  fft = new FFT( input.bufferSize(), input.sampleRate() );
  
  fftRep = new double[input.bufferSize()];
  
  //copies the middle frequency of each band in the fft into a double[] to use in the neural network
  for(int i=0; i<fftRep.length; i++){
    fftRep[i]=fft.indexToFreq(i);
  }
}


void draw() {
  background(0);
  stroke(255);
  
  fft.forward(input.mix);

  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  // note that if the file is MONO, left.get() and right.get() will return the same value
  for(int i = 0; i < input.bufferSize() - 1; i++)
  {
    float x1 = map( i, 0, input.bufferSize(), 0, width );
    float x2 = map( i+1, 0, input.bufferSize(), 0, width );
    line( x1, 50 + input.left.get(i)*50, x2, 50 + input.left.get(i+1)*50 );
    line( x1, 150 + input.right.get(i)*50, x2, 150 + input.right.get(i+1)*50 );
  }

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

