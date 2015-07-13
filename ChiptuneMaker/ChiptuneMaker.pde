import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*; // waveform templates
import ddf.minim.effects.*;
import javax.sound.sampled.*;

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
AudioFormat format;
FFT fft;
double[] NNInput, NNOutput; //the double arrays that go into and out of the neural network
float[] NNOutputFloat, buffer, AudioSampleInput;

void setup() {
  size(512, 200, P2D);

  minim = new Minim(this);

  input = minim.loadSample("jingle.mp3", 2048); 
  format = input.getFormat();

  fft = new FFT( input.bufferSize(), input.sampleRate() );

  NNInput = new double[1024];
  NNOutput = new double[1024];
  NNOutputFloat = new float[1024];//the float version of NNOutput
  
  //the empty float[] to put the data from fft inverse in.
  buffer = new float[NNOutput.length];

//  format = new AudioFormat( 44100, // sample rate
//  16, // sample size in bits
//  1, // channels
//  true, // signed
//  true   // bigEndian
//  );
  
  AudioSampleInput = new float[2048];
}


void draw() {
  background(0);
  stroke(255);

  fft.forward(input.mix);

//  //copies the middle frequency of each band in the fft into a double[] to use in the neural network
//  for (int i=0; i<NNInput.length; i++) {
//    NNInput[i]=(double)fft.indexToFreq(i);
//  }
//
//  //this is where the code would go to put it through the neural network:
//  //right now, for testing purposes, I'm using the values from NNInput
//  for(int i=0; i<NNInput.length; i++){
//    NNOutput[i] = NNInput[i];
//  }
//
//  
//  //copies the values obtained through use of the neural network into a new float[] to convert back into an AudioSample
//  for (int i=0; i<NNOutput.length; i++) {
//    NNOutputFloat[i] = (float)NNOutput[i];
//  }


  fft.inverse(buffer);
  
  
  //makes a new AudioSample;
  output = minim.createSample(buffer, input.getFormat(), 2048); 




  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  // note that if the file is MONO, left.get() and right.get() will return the same value
  
  for (int i = 0; i < output.bufferSize () - 1; i++)
  {
    float x1 = map( i, 0, output.bufferSize(), 0, width );
    float x2 = map( i+1, 0, output.bufferSize(), 0, width );
    line( x1, 50 + output.left.get(i)*50, x2, 50 + output.left.get(i+1)*50 );
    line( x1, 150 + output.right.get(i)*50, x2, 150 + output.right.get(i+1)*50 );
  }
  
}

// when spacebar is pressed, plays the file
void keyPressed() 
{
  if (key == ' ' || key == 'i' || key == 'I')
  {
    // plays in another thread
    //input.trigger();
    output.trigger();
  }
}

