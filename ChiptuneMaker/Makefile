all: Train.class data/chiptune-converter.nnet

Train.class: Train.java
	javac Train.java -classpath ./neuroph-core-2.9.jar:./slf4j-api-1.7.12.jar:slf4j-simple-1.7.12.jar

data/chiptune-converter.nnet: Train.class
	java -classpath .:./neuroph-core-2.9.jar:./slf4j-api-1.7.12.jar:slf4j-simple-1.7.12.jar Train
