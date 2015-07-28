/**
 * This sketch demonstrates how to use the BeatDetect object song SOUND_ENERGY mode.<br />
 * You must call <code>detect</code> every frame and then you can use <code>isOnset</code>
 * to track the beat of the music.
 * <p>
 * This sketch plays an entire song, so it may be a little slow to load.
 * <p>
 * For more information about Minim and additional features, 
 * visit http://code.compartmental.net/minim/
 */

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
//BeatDetect beat;
BeatListener beat;

float threshold;

void setup()
{
  size(750, 250, P2D);
  minim = new Minim(this);
  // song = minim.loadFile("marcus_kellis_theme.mp3", 2048);
  song = minim.loadFile("01 Lisztomania.mp3", 2048);
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

