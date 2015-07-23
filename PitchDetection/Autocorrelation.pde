class Autocorrelation extends UGen {
  
  public UGenInput audio;
  
  private FFT fft;
  
  public Autocorrelation(int timeSize, float sampleRate) {
    audio = new UGenInput(InputType.AUDIO);
  }
  
  @Override
  protected void uGenerate(float[] channels) {
    fft = new FFT(audio.getLastValues().length, audio.getIncomingUGen().sampleRate());
    fft.forward(audio.getLastValues());
    for (int i = 0; i < fft.specSize(); i++) {
      fft.scaleBand(i, pow(fft.getBand(i), -1/3));
    }
    fft.inverse(channels);
  }
  
}
