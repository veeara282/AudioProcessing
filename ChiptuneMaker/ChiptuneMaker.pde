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
FFT fft;
float[][] buffer;
boolean playing = true;
float songLength;

void setup() {
  size(512, 200, P2D);

  minim = new Minim(this);

  input = minim.loadSample("jingle.mp3", 2048); 
  songLength = input.length();
  input.trigger();
  input.mute();

  fft = new FFT( input.bufferSize(), input.sampleRate() );

  float trackLength = input.length();//length in millis
  float trackSeconds= (trackLength/1000.0); //length in seconds
  int specSize    = fft.specSize();  //how many fft bands
  float numSamples = input.sampleRate() * trackSeconds;
  int numChunks = (int)numSamples/2048;
  int numLeftover = (int)numSamples%2048;

  float[] leftChannel = input.getChannel(AudioSample.LEFT);
  //println(leftChannel.length+" + "+numSamples);

  float[] rightChannel = input.getChannel(AudioSample.RIGHT);
  //println(rightChannel.length);

  buffer = new float[numChunks+1][2048]; 

  float[][] leftChunks = new float[numChunks+1][2048];
  float[][] rightChunks = new float[numChunks+1][2048];
  for (int c=0; c<numChunks+1; c++) {
    int indexStart = c*2048;
    int indexEnd = indexStart+2048;
    for (int i=indexStart; i< indexEnd; i++) {
      //println("c "+c+" i "+i);
      if (i<leftChannel.length) {
        leftChunks[c][i-indexStart]=leftChannel[i];
        rightChunks[c][i-indexStart]=rightChannel[i];
      } else {
        leftChunks[c][i-indexStart]=0;
        rightChunks[c][i-indexStart]=0;
      }
    }
  }

  for (int chunk = 0; chunk<leftChunks.length; chunk++) {
    fft.forward(leftChunks[chunk], rightChunks[chunk]);
    fft.inverse(buffer[chunk]);
  }


  float[] allChunks = new float[leftChannel.length];

  int totalIndex = 0;
  for (int c=0; c<leftChunks.length; c++) {
    for (int i=0; i< 2048; i++) {
      if (totalIndex<leftChannel.length) {
        allChunks[totalIndex] = buffer[c][i];
        totalIndex++;
      }
    }
  }


  //makes a new AudioSample;
  output = minim.createSample(allChunks, input.getFormat(), 2048); 
  
  output.trigger();
  
  //  for (int i=0; i<output.bufferSize ()-1; i++) {
  //    //println(output.left.get(i) + " " + output.right.get(i));
  //  }
  //
  //  if (playing) {
  //    output.trigger();
  //  }
}


void draw() {
  background(0);
  stroke(255);


  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  // note that if the file is MONO, left.get() and right.get() will return the same value

  //  for (int i = 0; i < output.bufferSize () - 1; i++)
  //  {
  //    float x1 = map( i, 0, output.bufferSize(), 0, width );
  //    float x2 = map( i+1, 0, output.bufferSize(), 0, width );
  //    line( x1, 50 + output.left.get(i)*50, x2, 50 + output.left.get(i+1)*50 );
  //    line( x1, 150 + output.right.get(i)*50, x2, 150 + output.right.get(i+1)*50 );
  //  }
}

void keyPressed() {
}

