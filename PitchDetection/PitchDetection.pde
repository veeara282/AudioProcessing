import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer song;
//BeatDetect beat;
BeatListener beat;

UGen pitchDetect;

float threshold;

void setup()
{
  size(87*20, 220, P2D);
  minim = new Minim(this);
  // song = minim.loadFile("marcus_kellis_theme.mp3", 2048);
  pitchDetect = new FilePlayer(minim.loadFileStream("01 Lisztomania.mp3", 2048, true));
  chain: {
    // 80-1000 Hz
    UGen lowPart = pitchDetect.patch(new BandPass(540, 460, pitchDetect.sampleRate()));
    // >1000 Hz
    UGen highPart = pitchDetect.patch(new HighPass(1000, pitchDetect.sampleRate())).patch(new HalfWaveRectifier());
  }

  beat = new BeatListener(song);
  song.loop();

  ellipseMode(RADIUS);
  textSize(16);
  
  threshold = 0;
}

void draw()
{
  background(0);
  beat.draw();
  
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
      song.skip(-200);
    }
    // Fast forward
    if (keyCode == RIGHT) {
      song.skip(200);
    }
  }
}

