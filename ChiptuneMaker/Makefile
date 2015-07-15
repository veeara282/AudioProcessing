all: Train.class data/chiptune-converter.nnet

Train.class: Train.java
	javac Train.java -classpath libraries/encog-core-3.3.0.jar

data/chiptune-converter.nnet: Train.class
	java -classpath .:libraries/encog-core-3.3.0.jar Train
