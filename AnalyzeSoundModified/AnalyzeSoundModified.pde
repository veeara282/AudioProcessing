import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioSample jingle;
FFT         fft;
AudioOutput out;
int counter, newCounter;
boolean played;
float spectrumScale = 4;
Octave[] octaves = new Octave[9];
Song thisSong;
float count;
NineOctaves moment;
boolean[] play = {
  true, true, true, true, true, true, true, true, true,
};
float thresholdMult = 7;
float frames = 1000;

void setup() {
  loadFreqs();
  count=0;
  frameRate(frames);
  counter=0;
  newCounter=0;
  played = false;
  size(1024, 200, P3D);
  minim = new Minim(this);

  //the song store all notes played
  thisSong = new Song(60);

  //jingle = minim.loadSample("02 Take the _A_ Train.mp3",1024);
  //jingle = minim.loadSample("01 Lisztomania.mp3",1024);
  //jingle = minim.loadSample("06 Karma Police.mp3",1024);
  //jingle = minim.loadSample("26 Let It Be.mp3",1024);
  //jingle = minim.loadSample("22 Get Back.mp3",1024);
  //jingle = minim.loadSample("18 Town Called Malice.mp3",1024);
  //jingle = minim.loadSample("jingle.mp3", 1024);
  //jingle = minim.loadSample("1-21 Thank You (Falettinme Be Mice Elf Agin).mp3", 1024);
  jingle = minim.loadSample("01 Song for My Father.mp3", 1024);
  //jingle = minim.loadSample("19 The Nutcracker Suite, Op. 71a_ Xiiic. Character Dances - Tea (Chinese Dance)_ Allegro Moderato.mp3", 1024);


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
    count+=1.0/frames;
    //count+=1.0/60.0; //for use with the playNote function later
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

    if (i<9 && play[i]) {
      c=drawRect(i);
      addLoudest(i, xl, c);
    }
  }
  thisSong.add(moment);
}

color drawRect(int i) {
  fill(255);
  noStroke();

  color c = 0;
  switch (i % 9) {
  case 0: 
    c = color(255, 0, 0); 
    break;
  case 1: 
    c = color(255, 100, 0); 
    break;
  case 2: 
    c = color(255, 255, 0); 
    break;
  case 3: 
    c = color(0, 255, 0); 
    break;
  case 4: 
    c = color(0, 0, 255); 
    break;
  case 5: 
    c = color(255, 0, 255); 
    break;
  case 6: 
    c = color(0, 255, 255); 
    break;
  case 7: 
    c = color(100, 100, 100); 
    break;
  case 8: 
    c = color(255, 255, 255);
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
    float a = fft.getBand(fft.freqToIndex(f)); //amplitude of the note
    if (loudestIndex==-1 && !loudestIndices[n]) { //if it hasn't already been added to loudestIndices
      loudestIndex=n;
      loudestAmp=a;
    }
    if (a>loudestAmp && !loudestIndices[n]) { //determines if the amplitude of the tested note is the highest
      loudestAmp = a;
      loudestIndex = n;
    }
  }

  float threshold = thresholdMult*loudestAmp/8.0;
  boolean aboveOctaveThreshold = false;
  //we need to set a general threshold for each octave as well
  switch(i) {
  case 0: 
    aboveOctaveThreshold = threshold>=128; 
    break;
  case 1: 
    aboveOctaveThreshold = threshold>=64;  
    break;
  case 2: 
    aboveOctaveThreshold = threshold>=32; 
    break;
  case 3: 
    aboveOctaveThreshold = threshold>=16; 
    break;
  case 4: 
    aboveOctaveThreshold = threshold>=8;  
    break;
  case 5: 
    aboveOctaveThreshold = threshold>=4;  
    break;
  case 6: 
    aboveOctaveThreshold = threshold>=2;  
    break;
  case 7: 
    aboveOctaveThreshold = threshold>=1;   
    break;
  case 8: 
    aboveOctaveThreshold = threshold>=0.5;  
    break;
  }

  if (aboveOctaveThreshold) {
    //goes through all 12 notes of the octave to find ones louder than the threshold
    for (int n=0; n<12; n++) {
      float f = octaves[i].getNote(n).getFreq(); //frequency of the note
      float a = fft.getBand(fft.freqToIndex(f)); //amlitude of the note
      if (a>=threshold) {
        loudestIndices[n] = true; //puts the note in an array
      }
    }
  }

  //draws an ellipse where the note is
  fill(c);
  for (int n=0; n<12; n++) {
    float f = octaves[i].getNote(n).getFreq(); //frequency of the note
    float a = fft.getBand(fft.freqToIndex(f)); //amlitude of the note
    if (loudestIndices[n]) {
      ellipse(i*100-10+50, n*12+50, a/5, a/5);
    }
  }

  if (i<9) {//done for all the first 9 octaves
    for (int n=0; n<12; n++) {
      if (loudestIndices[n]) {
        float f = octaves[i].getNote(n).getFreq(); //frequency of loudest note
        float a = fft.getBand(fft.freqToIndex(f)); //amplitude of loudest note
        a = (int)a-(int)a%10; //simplified amplitude (perhaps unecessary?)
        boolean loudEnough = false; //this boolean will be used to determine if the note should be played at all

        //println(a);
        loudEnough = a>0;

        //if the note is loud enough to play...
        if (loudEnough) {
          //if the note hadn't been played in the frame before, play it now
          if (moment.getOctave(i).getNote(n).getPlayed()==0 ) {
            //the "played" variable of the Note class determines if it is being played
            //if played==0: not played
            //if played==2: played for the first time
            //if played==1: note still sounding after being played previously for the first time (don't play again)
            moment.getOctave(i).getNote(n).setPlayed(2);
          }
          //if the note was already started, don't play again
          else if (moment.getOctave(i).getNote(n).getPlayed()==2) {
            moment.getOctave(i).getNote(n).setPlayed(1);
          }

          //if it should be played...
          if (moment.getOctave(i).getNote(n).getPlayed()==2) {
            if (i==0 || i==1) {
              //the for loop plays each note in these two octaves twice, to make them louder
              for (int k=0; k<1; k++) {
                out.playNote(count*1.0/frames, 0.1, moment.getOctave(i).getNote(n).getFreq());
              }
            } else {
              //all notes in other octaves play only once
              out.playNote(count*1.0/frames, 0.1, moment.getOctave(i).getNote(n).getFreq());
            }
          }
        } else {
          //if it should not be played, update the note's "played" variable
          moment.getOctave(i).getNote(n).setPlayed(0);
        }
      }
    }
  }

  //updates the "played" variable for all the notes not played
  for (int n=0; n<12; n++) {
    if (!loudestIndices[n]) {
      moment.getOctave(i).getNote(n).setPlayed(0);
    }
  }
}


void loadFreqs() {
  for (int i=0; i<9; i++) {
    octaves[i] = new Octave(i);
  }
}

void keyPressed() {
  int i=key-48;
  play[i]=!play[i];
}

