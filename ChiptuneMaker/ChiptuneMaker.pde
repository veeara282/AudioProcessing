import java.io.*;

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*; // waveform templates
import ddf.minim.effects.*;
import javax.sound.sampled.*;

import org.encog.neural.networks.BasicNetwork;
import org.encog.ml.data.MLData;
import org.encog.ml.data.basic.BasicMLData;

/**
 * Converts a user-provided audio file to a chiptune.
 * Step 1: FFT on small sections (1024 samples)
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
//float[][] buffer;
//boolean playing = true;
float songLength;

// Neural network
File file;
BasicNetwork net;

void setup() {
  size(512, 200, P2D);
  // FIXME why is the loading screen delayed?
  background(0);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(72);
  text("Loading...", width/2, height/2);

  file = new File(sketchPath("data/neural-network.blob"));
  println(file.getAbsolutePath());
  net = load();

  minim = new Minim(this);
  
  int samples = 1024;

  input = minim.loadSample("jingle.mp3", samples); 
  songLength = input.length();

  fft = new FFT( input.bufferSize(), input.sampleRate() );
  fft.window(FFT.HAMMING);

  float trackLength = input.length();//length in millis
  float trackSeconds= (trackLength/1000.0); //length in seconds
  int specSize    = fft.specSize();  //how many fft bands
  int numSamples = (int) (input.sampleRate() * trackSeconds); //total number of samples in the song
  int numChunks = numSamples/samples; //the number of complete 1024-sample chunks
  int numLeftover = numSamples%samples; //the number of samples leftover after dividing it into chunks

  float[] leftChannel = input.getChannel(AudioSample.LEFT); //all real sample values

  float[] rightChannel = input.getChannel(AudioSample.RIGHT); //all imaginary sample values

  float[][] leftChunks = new float[numChunks+1][samples]; //breaks the left channel into chunks of 1024
  float[][] rightChunks = new float[numChunks+1][samples]; //breaks the right channel into chunks of 1024

  //copies the values from leftChannel and rightChannel into the 2d arrays used to break them into chunks
  for (int c=0; c<numChunks+1; c++) {
    int indexStart = c*samples;
    int indexEnd = indexStart+samples;
    for (int i=indexStart; i< indexEnd; i++) {
      if (i<leftChannel.length) {
        leftChunks[c][i-indexStart]=leftChannel[i];
        rightChunks[c][i-indexStart]=rightChannel[i];
      } else {
        leftChunks[c][i-indexStart]=0;
        rightChunks[c][i-indexStart]=0;
      }
    }
  }

  float[][] buffer = new float[numChunks+1][samples]; //the empty arrays used to store the values from the inverse fft

  //runs each chunk through the forward fft and back
  for (int chunk = 0; chunk<leftChunks.length; chunk++) {
    fft.forward(leftChunks[chunk], rightChunks[chunk]);

    // Run thru neural network...
    MLData dataIn = pack(spectrum(fft));
    MLData dataOut = net.compute(dataIn);
    // ...then put back in buffer
    buffer[chunk] = unpack(dataOut);
    
    // filter
    for (int i = 0; i < buffer[chunk].length; i++) {
      if (buffer[chunk][i] < 0.01) {
        buffer[chunk][i] = 0;
      }
    }

    fft.inverse(buffer[chunk]);
  }

  float[] allChunks = new float[leftChannel.length]; //array of all samples in the song

  //consolidates the samples from all chunks into one array
  int totalIndex = 0;
  for (int c=0; c<leftChunks.length; c++) {
    for (int i=0; i< samples; i++) {
      if (totalIndex<leftChannel.length) {
        allChunks[totalIndex] = buffer[c][i];
        totalIndex++;
      }
    }
  }


  //makes a new AudioSample;
  output = minim.createSample(allChunks, input.getFormat(), samples); 

  //plays the song
  //  output.trigger();
}


void draw() {
  background(0);
  stroke(255);

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

void keyPressed() {
  output.trigger();
}

