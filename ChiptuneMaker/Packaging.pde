// These functions are necessary because Minim uses floats
// while Encog uses doubles.

float[] spectrum(FFT fft) {
  float[] real = fft.getSpectrumReal();
  float[] imag = fft.getSpectrumImaginary();
  float[] magnitude = new float[real.length];
  for (int i = 0; i < real.length; i++) {
    magnitude[i] = mag(real[i], imag[i]);
  }
  return magnitude;
}

MLData pack(float[] data) {
  MLData pkg = new BasicMLData(data.length);
  for (int i = 0; i < data.length; i++) {
    pkg.setData(i, data[i]);
  }
  return pkg;
}

float[] unpack(MLData pkg) {
  float[] data = new float[pkg.size()];
  for (int i = 0; i < data.length; i++) {
    data[i] = (float) pkg.getData(i);
  }
  return data;
}
