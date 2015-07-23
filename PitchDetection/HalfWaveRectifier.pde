class HalfWaveRectifier extends UGen {
  
  public UGenInput audio;
  
  public HalfWaveRectifier()
  {
    audio = new UGenInput(InputType.AUDIO);
  }
  
  @Override
  protected void uGenerate(float[] channels) {
    for (int i = 0; i < channels.length; i++) {
      float x = audio.getLastValues()[i];
      if (x > 0) {
        channels[i] = x;
      }
      // else channels[i] = 0;
    }
  }
}
