import java.util.Random;
import java.io.*;

// Encog imports
import org.encog.engine.network.activation.ActivationSigmoid;
import org.encog.ml.data.*;
import org.encog.ml.data.basic.*;
import org.encog.neural.networks.BasicNetwork;
import org.encog.neural.networks.layers.BasicLayer;
import org.encog.neural.networks.training.propagation.resilient.ResilientPropagation;

/**
 * Run this class to train the included neural network on a
 * randomly generated data set.
 */
public class Train {

    // Has to be a power of two
    public static final int VECTOR_SIZE = 1024;

    public static final Random r = new Random();

    public static final File file = new File("../data/neural-network.blob");

    public static void main(String[] args) throws IOException {
	BasicNetwork net;

	// Open saved neural network or create new one
	// The program should always be able to read and write the file
	// because it created it
	if (file.exists() && file.canRead() && file.canWrite()) {
	    net = load();
	}
	else {
	    file.createNewFile();
	    net = new BasicNetwork();
	    net.addLayer(new BasicLayer(null, true, VECTOR_SIZE));
	    net.addLayer(new BasicLayer(new ActivationSigmoid(), true, VECTOR_SIZE));
	    net.addLayer(new BasicLayer(new ActivationSigmoid(), false, VECTOR_SIZE));
	    net.getStructure().finalizeStructure();
	    net.reset();
	}

	// Randomly generate training data
	MLDataSet trainingSet = randomFFTData();
	
	// Train to your heart's content!
	// tolerance: 0.01
	final ResilientPropagation train = new ResilientPropagation(net, trainingSet);

	int epoch = 1;

	do {
	    train.iteration();
	    System.out.println("Epoch #" + epoch + " Error:" + train.getError());
	    epoch++;
	} while(train.getError() > 0.01);
	train.finishTraining();

	// Save file - should always work
	//	net.save(file.getPath());
	save(net);
    }

    public static MLDataSet randomFFTData() {
	MLDataSet trainingSet = new BasicMLDataSet();
	// Generate 50 single-frequency examples
	for (int i = 0; i < 50; i++) {
	    trainingSet.add(randomFFT());
	}
	// Combine them in 50 ways
	for (int i = 0; i < 150; i++) {
	    trainingSet.add(randomCombo(trainingSet));
	}
	return trainingSet;
    }

    public static MLDataPair randomFFT() {
	double[] input = new double[VECTOR_SIZE],
	        output = new double[VECTOR_SIZE];
	
	// Code for randomly generating the input here
	double maxAmp = r.nextDouble(); // [0.0, 1.0)
	int baseFreq = 1 + r.nextInt(VECTOR_SIZE - 1); // cannot be zero
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

	return new BasicMLDataPair(new BasicMLData(input), new BasicMLData(output));
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

    public static MLDataPair randomCombo(MLDataSet set) {
	// two different random numbers
	int i = r.nextInt((int) set.size());
	int j = i;
	while (j == i) {
	    j = r.nextInt((int) set.size());
	}
	BasicMLData
	    ix = (BasicMLData) set.get(i).getInput(),
	    iy = (BasicMLData) set.get(i).getIdeal(),
	    jx = (BasicMLData) set.get(j).getInput(), 
	    jy = (BasicMLData) set.get(j).getIdeal();
	MLData rx = ix.plus(jx), ry = iy.plus(jy);
	return new BasicMLDataPair(rx, ry);
    }

    public static BasicNetwork load() {
	try (ObjectInputStream input = new ObjectInputStream(new FileInputStream(file))) {
		return (BasicNetwork) input.readObject();
	    }
	catch (ClassNotFoundException e) {
	    System.err.println("Looks like Encog isn't imported properly :(");
	    System.exit(1);
	    return null;
	}
	catch (IOException e) {
	    e.printStackTrace();
	    return null;
	}
    }

    public static boolean save(BasicNetwork net) {
	try (ObjectOutputStream output = new ObjectOutputStream(new FileOutputStream(file, false))) {
		output.writeObject(net);
		return true;
	    }
	catch (IOException e) {
	    e.printStackTrace();
	    return false;
	}
    }

}
