all: setup/Train.class data/neural-network.blob

setup/Train.class: setup/Train.java
	cd setup; javac Train.java -classpath ../code/encog-core-3.3.0.jar

data/neural-network.blob: setup/Train.class
	cd setup; java -classpath .:../code/encog-core-3.3.0.jar Train
