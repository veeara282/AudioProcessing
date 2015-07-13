all: Train.class data/chiptune-converter.nnet

Train.class: Train.java
	javac Train.java -classpath ./neuroph-core-2.9.jar 

data/chiptune-converter.nnet: Train.class
	java -classpath .:./neuroph-core-2.9.jar Train
