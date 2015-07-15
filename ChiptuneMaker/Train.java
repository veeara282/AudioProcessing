//import java.util.Random;
//import java.io.*;
//
//// Neuroph imports
////import org.neuroph.core.*;
////import org.neuroph.core.data.*;
////import org.neuroph.nnet.*;
//
///**
// * Run this class to train the included neural network on a
// * randomly generated data set.
// */
//public class Train {
//
//    // Has to be a power of two
//    public static final int VECTOR_SIZE = 1024;
//
//    Random r = new Random();
//
//    public static void main(String[] args) throws IOException {
//	NeuralNetwork nnet;
//
//	// Open saved neural network or create new one
//	// The program should always be able to read and write the file
//	// because it created it
//	File file = new File("data/chiptune-converter.nnet");
//	if (file.canRead() && file.canWrite()) {
//	    nnet = NeuralNetwork.load(file.getPath());
//	}
//	else {
//	    file.createNewFile();
//	    nnet = new Perceptron(VECTOR_SIZE, VECTOR_SIZE);
//	}
//
//	// Train on randomly generated FFT spectrum data
//	DataSet trainingSet = randomFFTData();
//	nnet.learn(trainingSet);
//
//	// Save file - should always work
//	nnet.save(file.getPath());
//    }
//
//    public static DataSet randomFFTData() {
//	DataSet trainingSet = new DataSet(VECTOR_SIZE, VECTOR_SIZE);
//	for (int i = 0; i < 5000; i++) {
//	    trainingSet.addRow(randomFFT());
//	}
//	return trainingSet;
//    }
//
//    public static DataSetRow randomFFT() {
//	double[] input = new double[VECTOR_SIZE],
//	        output = new double[VECTOR_SIZE];
//	
//	// Code for randomly generating the input here
//
//	// Copy input to output and leave it alone
//
//	// Tweak input
//
//	return new DataSetRow(input, output);
//    }
//}
