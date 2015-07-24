import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioSample jingle;
FFT         fft;
AudioOutput out;
int counter, newCounter;
boolean played;
float spectrumScale = 4;
boolean[][] notes = new boolean[12*8][9080];
Octave[] octaves = new Octave[9];
Song thisSong;
float count;
NineOctaves moment;

void setup() {
  loadFreqs();
  count=0;
  frameRate(1000);
  counter=0;
  newCounter=0;
  played = false;
  size(1024, 200, P3D);
  minim = new Minim(this);
  
  //the song store all notes played
  thisSong = new Song(60);
  
  //jingle = minim.loadSample("jingle.mp3", 1024);
  //jingle = minim.loadSample("1-21 Thank You (Falettinme Be Mice Elf Agin).mp3", 1024);
  jingle = minim.loadSample("01 Lisztomania.mp3", 1024);
  
  fft = new FFT( jingle.bufferSize(), jingle.sampleRate() );
  fft.logAverages(22, 3); //breaks it into octaves
  
  jingle.trigger();
  jingle.mute();
  
  moment = new NineOctaves(); //to store all notes played in each frame
  out = minim.getLineOut();
}

void draw() {
  background(0);
  if (millis()<=jingle.length()/2) {
    analyze();
    count+=1.0/60.0; //for use with the playNote function later
  } else {
    jingle.stop();
  }
}

void analyze() {
  float centerFrequency = 0;

  fft.forward( jingle.mix );

  for (int i = 0; i < fft.avgSize (); i++) {
    centerFrequency    = fft.getAverageCenterFrequency(i);
    float averageWidth = fft.getAverageBandWidth(i);   
    float lowFreq  = centerFrequency - averageWidth/2;
    float highFreq = centerFrequency + averageWidth/2;
    int xl = (int)fft.freqToIndex(lowFreq);
    int xr = (int)fft.freqToIndex(highFreq);
    color c = color(255);

    if (i<9) {
      c=drawRect(i);
      addLoudest(i, xl, c);
    }
  }
  thisSong.add(moment);
}

color drawRect(int i) {
  fill(255);
  noStroke();
  color c;
  if (i%9==0) {
    c=color(255, 0, 0);
  } else if (i%9==1) {
    c=color(255, 100, 0);
  } else if (i%9==2) {
    c=color(255, 255, 0);
  } else if (i%9==3) {
    c=color(0, 255, 0);
  } else if (i%9==4) {
    c=color(0, 0, 255);
  } else if (i%9==5) {
    c=color(255, 0, 255);
  } else if (i%9==6) {
    c=color(0, 255, 255);
  } else if (i%9==7) {
    c=color(100, 100, 100);
  } else if (i%9==8) {
    c=color(255, 255, 255);
  } else {
    c=color(100);
  }

  fill(c);
  rect( 50+i*100, height, i, height - fft.getAvg(i)*10 );
  textSize(10);
  text(i, i*100+50, 100);
  noStroke();

  return c;
}

void addLoudest(int i, int xl, color c) {
  int loudestIndex = -1; //index of loudest note
  float loudestAmp = -1; //amplitude of loudest note
  boolean[] loudestIndices = new boolean[12]; //array of loudest notes (true if played, false if not)
  
  //goes through all 12 notes of the octave to find the loudest one
  for (int n=0; n<12; n++) {
    float f = octaves[i].getNote(n).getFreq(); //frequency of the note
    float a = fft.getBand(fft.freqToIndex(f)); //amlitude of the note
    if (loudestIndex==-1 && !loudestIndices[n]) { //if it hasn't already been added to loudestIndices
      loudestIndex=n;
      loudestAmp=a;
    }
    if (a>loudestAmp && !loudestIndices[n]) { //determines if the amplitude of the tested note is the highest
      loudestAmp = a;
      loudestIndex = n;
    }
  }

  loudestIndices[loudestIndex] = true;

  //draws an ellipse where the note is
  fill(c);
  ellipse(i*100-10+50, loudestIndex*12+50, loudestAmp/5, loudestAmp/5);

  if (i<9) {//done for all the first 9 octaves
    float f = octaves[i].getNote(loudestIndex).getFreq(); //frequency of loudest note
    float a = fft.getBand(fft.freqToIndex(f)); //amplitude of loudest note
    a = (int)a-(int)a%10; //simplified amplitude (perhaps unecessary?)
    boolean loudEnough = false; //this boolean will be used to determine if the note should be played at all

    //println(a);

    //these if statements check if the loudest note is loud enough to play
    //the thresholds are determined manually, but in the future they should be determined through code
    //for each octave
    if (i==0 || i==1) {
      loudEnough = a>=100;
    } else if (i==2) {
      loudEnough = a>=100;
    } else if (i==3) {
      loudEnough = a>10;
    } else if (i==4) {
      if (loudestIndex==0 || loudestIndex==7) {
        loudEnough=a>0;
      }
    } else if (i==5) {
      //loudEnough=a>0;
      if (loudestIndex==0 || loudestIndex==7) {
        loudEnough=a>0;
      }
    } else if (i==6) {
      if (loudestIndex==0 || loudestIndex==7) {
        loudEnough=a>0;
      }
    } else if (i==7) {
      loudEnough = a>0;
    } else if (i==8) {
      loudEnough = a>0;
    }

   //if the note is loud enough to play...
    if (loudEnough) {
      //if the note hadn't been played in the frame before, play it now
      if (moment.getOctave(i).getNote(loudestIndex).getPlayed()==0 ) {
        //the "played" variable of the Note class determines if it is being played
        //if played==0: not played
        //if played==2: played for the first time
        //if played==1: note still sounding after being played previously for the first time (don't play again)
        moment.getOctave(i).getNote(loudestIndex).setPlayed(2);
      }
      //if the note was already started, don't play again
      else if (moment.getOctave(i).getNote(loudestIndex).getPlayed()==2) {
        moment.getOctave(i).getNote(loudestIndex).setPlayed(1);
      }
      
      //if it should be played...
      if (moment.getOctave(i).getNote(loudestIndex).getPlayed()==2) {
        if (i==0 || i==1) {
          //the for loop plays each note in these two octaves twice, to make them louder
          for (int k=0; k<2; k++) {
            out.playNote(count*1.0/1000.0, 0.1, moment.getOctave(i).getNote(loudestIndex).getFreq());
          }
        } else {
          //all notes in other octaves play only once
          out.playNote(count*1.0/1000.0, 0.1, moment.getOctave(i).getNote(loudestIndex).getFreq());
        }
      }
    } else {
      //if it should not be played, update the note's "played" variable
      moment.getOctave(i).getNote(loudestIndex).setPlayed(0);
    }
  }

  //updates the "played" variable for all the notes not played
  for (int n=0; n<12; n++) {
    if (n!=loudestIndex) {
      moment.getOctave(i).getNote(n).setPlayed(0);
    }
  }
}


void loadFreqs() {
  for (int i=0; i<9; i++) {
    octaves[i] = new Octave(i);
  }
}

