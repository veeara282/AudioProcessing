import java.util.Random;
import java.io.*;

// Neuroph imports
import org.neuroph.core.*;
import org.neuroph.core.data.*;
import org.neuroph.nnet.*;

/**
 * Run this class to train the included neural network on a
 * randomly generated data set.
 */
public class Train {

    // Has to be a power of two
    public static final int VECTOR_SIZE = 1024;

    public static final Random r = new Random();

    public static void main(String[] args) throws IOException {
	NeuralNetwork nnet;

	// Open saved neural network or create new one
	// The program should always be able to read and write the file
	// because it created it
	File file = new File("data/chiptune-converter.nnet");
	if (file.canRead() && file.canWrite()) {
	    nnet = NeuralNetwork.load(file.getPath());
	}
	else {
	    file.createNewFile();
	    nnet = new Perceptron(VECTOR_SIZE, VECTOR_SIZE);
	}

	// Train on randomly generated FFT spectrum data
	DataSet trainingSet = randomFFTData();
	nnet.learn(trainingSet);

	// Save file - should always work
	nnet.save(file.getPath());
    }

    public static DataSet randomFFTData() {
	DataSet trainingSet = new DataSet(VECTOR_SIZE, VECTOR_SIZE);
	for (int i = 0; i < 5000; i++) {
	    trainingSet.addRow(randomFFT());
	}
	return trainingSet;
    }

    public static DataSetRow randomFFT() {
	double[] input = new double[VECTOR_SIZE],
	        output = new double[VECTOR_SIZE];
	
	// Code for randomly generating the input here
	double maxAmp = r.nextDouble(); // [0.0, 1.0)
	int baseFreq = r.nextInt(VECTOR_SIZE);
	int waveType = r.nextInt(4);
	addFrequency(output, baseFreq, maxAmp, waveType);

	// Copy input to output and leave it alone
	System.arraycopy(output, 0, input, 0, VECTOR_SIZE);

	// Add random noise with the same frequency
	for (int i = 0; i < 4; i++) {
	    if (i != waveType) {
		addFrequency(input, baseFreq, maxAmp * r.nextDouble() / 2, i);
	    }
	}

	return new DataSetRow(input, output);
    }

    public static final int SINE = 0, SQUARE = 1, TRIANGLE = 2, SAWTOOTH = 3;

    public static void addFrequency(double[] array, int freq, double amp, int waveType) {
	array[freq] += amp;
	switch (waveType) {
	case SAWTOOTH:
	    for (int i = 2; i < array.length / freq; i++) {
		array[freq*i] += amp/i;
	    }
	    return;
	case SQUARE:
	    for (int i = 3; i < array.length / freq; i += 2) {
		array[freq*i] += amp/i;
	    }
	    return;
	case TRIANGLE:
	    for (int i = 3; i < array.length / freq; i += 2) {
		array[freq*i] += amp/(i*i);
	    }
	    return;
	default:
	    return;
	}
    }
}
