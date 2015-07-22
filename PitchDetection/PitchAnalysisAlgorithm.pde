// Pseudocode for pitch detection algorithm
// from http://www.ee.columbia.edu/~dpwe/papers/KarjT99-pitch.pdf
//
// equal loudness filtering
// pre-whitening
//
// lowpass = lowpass(fft, 1 kHz)
// unfft(lowpass) -> complex[]
// autocorrelation(lowpass)
//
// highpass = highpass(fft, 1 kHz)
// lowpass(highpass, ???)
// halfWaveRectify(unfft(highpass)) -> complex[]
// autocorrelation(highpass)
//
// lowpass + highpass

int REAL, IMAGINARY;

// Actually a band pass:
//
// "One more detail of implementation is that actually the two
// (second order) 1 kHz low-pass filters in the middle part of Fig. 2
// model include a high-pass property, e.g. with a cutoff at 80 Hz, in
// order to remove the down-ramp baseline of the correlation function
// up from zero time lag. These implementation features have been
// selected based on experimentation with various practical signals."
// (Karjalainen and Tolonen 1999)
float[] lowPass(FFT fft, int mode) {
  float[] yolo = new float[fft.specSize()];
  float[] orig = (mode == REAL) ? fft.getSpectrumReal() : fft.getSpectrumImaginary();
  // 80 Hz - 1 kHz
  for (int i = fft.freqToIndex(80); i < yolo.length && i <= fft.freqToIndex(1000); i++) {
    yolo[i] = orig[i];
  }
  return yolo;
}

float[] highPass(FFT fft) {
  float[] yolo = new float[fft.specSize()];
  float[] orig = (mode == REAL) ? fft.getSpectrumReal() : fft.getSpectrumImaginary();
  // starts at 1 kHz
  for (int i = fft.freqToIndex(1000); i < yolo.length; i++) {
    yolo[i] = orig[i];
  }
  return yolo;  
}

// Autocorrelation algorithm based on FFT
// http://stackoverflow.com/a/3950552/2276567
void autocorrelation(FFT fft) {
  float[] real = fft.getSpectrumReal(),
          imag = fft.getSpectrumImaginary(),
          yolo = new float[fft.specSize()], // real part: fill
          swag = new float[fft.specSize()]; // imaginary part: don't fill
  for (int i = 0; i < fft.specSize(); i++) {
    // multiply by complex conjugate
    yolo[i] = real[i]*real[i] + imag[i]*imag[i];
    // then take cube root (Karjalainen and Tolonen 1999)
    yolo[i] = Math.cbrt(yolo[i]);
  }
  fft.setComplex(yolo, swag);
}

class LowPassPart implements Runnable {
  
  FFT orig;
  
  public LowPassPart(FFT fft) {
    orig = fft;
  }
  
  @Override
  public void run() {
    float[] real = lowPass(orig, REAL), imag = lowPass(orig, IMAGINARY);

    FFT fft = new FFT(orig.timeSize(), orig.sampleRate());
    fft.setComplex(real, imag);
  }
}


class HighPassPart implements Runnable {
  
  FFT orig;
  
  public LowPassPart(FFT fft) {
    orig = fft;
  }
  
  @Override
  public void run() {
    float[] real = highPass(orig, REAL), imag = highPass(orig, IMAGINARY);

    float[] unfft = new float[orig.timeSize()];
    FFT fft = new FFT(orig.timeSize(), orig.sampleRate());
    fft.inverse(real, imag, unfft);
    
    // half wave rectify
    for (int i = 0; i < unfft.length; i++) {
      if (unfft[i] < 0) {
        unfft[i] = 0;
      }
    }
    
    fft.forward(unfft);
  }
}
