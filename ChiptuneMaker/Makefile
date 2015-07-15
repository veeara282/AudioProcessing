all: Train.class data/neural-network.blob

Train.class: Train.java
	javac Train.java -classpath libraries/encog-core-3.3.0.jar

data/neural-network.blob: Train.class
	java -classpath .:libraries/encog-core-3.3.0.jar Train
