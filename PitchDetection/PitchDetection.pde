import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
//AudioPlayer song;
//BeatDetect beat;
//BeatListener beat;

UGen pitchDetect;
FilePlayer song;

float threshold;

void setup()
{
  size(87*20, 220, P2D);
  minim = new Minim(this);
  // song = minim.loadFile("marcus_kellis_theme.mp3", 2048);
  song = new FilePlayer(minim.loadFileStream("01 Lisztomania.mp3", 2048, true));
  pitchDetect = song;

  // 80-1000 Hz -> autocorrelation
  UGen lowPart = pitchDetect.patch(new BandPass(540, 460, pitchDetect.sampleRate())).patch(new Autocorrelation(2048, pitchDetect.sampleRate()));
  // >1000 Hz -> half wave rectify -> low pass -> autocorrelation
  UGen highPart = pitchDetect.patch(new HighPassSP(1000, pitchDetect.sampleRate())).patch(new HalfWaveRectifier()).patch(new Autocorrelation(2048, pitchDetect.sampleRate()));

  // merge back
  UGen combiner = new Summer();
  lowPart.patch(combiner);
  highPart.patch(combiner);
  pitchDetect = combiner;

  pitchDetect.patch(minim.getLineOut());

  //  beat = new BeatListener(song);
  //  song.loop();

  ellipseMode(RADIUS);
  textSize(16);

  threshold = 0;
  
  song.play();
}

void draw()
{
  background(0);
  //  beat.draw();

  fill(255);
  textAlign(LEFT, TOP);
  text(""+threshold, 10, 10);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && threshold < 1.0) {
      threshold += 0.05;
    }
    if (keyCode == DOWN && threshold > 0) {
      threshold -= 0.05;
    }
    // Rewind
    if (keyCode == LEFT) {
      //      song.skip(-200);
    }
    // Fast forward
    if (keyCode == RIGHT) {
      //      song.skip(200);
    }
  }
}

