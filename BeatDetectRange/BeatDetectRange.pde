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

void setup()
{
  size(87*20, 20, P2D);
  minim = new Minim(this);
  song = minim.loadFile("marcus_kellis_theme.mp3", 2048);
  beat = new BeatListener(song);
  song.play();

  ellipseMode(RADIUS);
}

void draw()
{
  background(0);
  beat.draw();
}
